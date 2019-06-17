/****** Object:  StoredProcedure [dbo].[SSP_SCGetLabsoft_SegmentDiags]    Script Date: 04/12/2016 14:15:25 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetLabsoft_SegmentDiags]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCGetLabsoft_SegmentDiags]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCGetLabsoft_SegmentDiags]    Script Date: 04/12/2016 14:15:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetLabsoft_SegmentDiags] @DocumentVersionId INT
	,@EncodingChars NVARCHAR(5)
	,@DiagsSegmentRaw NVARCHAR(Max) OUTPUT
AS
/*
-- ================================================================  
-- Stored Procedure: SSP_SCGetLabsoft_SegmentDiags  
-- Create Date : Sep 09 2015 
-- Purpose : Get Diags Segment for Labsoft  
-- Created By : Gautam  
	declare @DiagsSegmentRaw nVarchar(max)
	exec SSP_SCGetLabsoft_SegmentDiags 2, '|^~\&' ,@DiagsSegmentRaw Output
	select @DiagsSegmentRaw
-- ================================================================  
-- History --  

-- ================================================================  
*/
BEGIN
	BEGIN TRY
		DECLARE @SetId INT
		DECLARE @DiagnosisCode NVARCHAR(250)
		DECLARE @DiagnosisDesc NVARCHAR(250)
		DECLARE @SegmentName NVARCHAR(5)
		DECLARE @OverrideSPName NVARCHAR(200)
		DECLARE @DG1Segment NVARCHAR(max)
		-- pull out encoding characters
		DECLARE @FieldChar CHAR
		DECLARE @CompChar CHAR
		DECLARE @RepeatChar CHAR
		DECLARE @EscChar CHAR
		DECLARE @SubCompChar CHAR

		EXEC SSP_SCGetLabSoft_EncChars @EncodingChars
			,@FieldChar OUTPUT
			,@CompChar OUTPUT
			,@RepeatChar OUTPUT
			,@EscChar OUTPUT
			,@SubCompChar OUTPUT

		SET @SegmentName = 'Diags'

		CREATE TABLE #tempDiagnoses (
			SetId INT identity(1, 1)
			,ICD10Code NVARCHAR(1000)
			,ICD10Description NVARCHAR(1000)
			)
			--DECLARE @LatestICD10DocumentVersionID INT
			--SET @LatestICD10DocumentVersionID = (
			--		SELECT TOP 1 a.CurrentDocumentVersionId
			--		FROM Documents AS a
			--		INNER JOIN DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId
			--		INNER JOIN DocumentDiagnosis AS DDC ON a.CurrentDocumentVersionId = DDC.DocumentVersionId
			--		WHERE a.ClientId = @ClientId
			--			AND a.EffectiveDate <= getDate()
			--			AND a.STATUS = 22
			--			AND Dc.DiagnosisDocument = 'Y'
			--			AND isNull(a.RecordDeleted, 'N') <> 'Y'
			--			AND isNull(Dc.RecordDeleted, 'N') <> 'Y'
			--			AND ISNULL(DDC.RecordDeleted, 'N') <> 'Y'
			--		ORDER BY a.EffectiveDate DESC
			--			,a.ModifiedDate DESC
			--		);
			;

		WITH Diagnoses_CTE (
			ICD10Code
			,ICD10Description
			)
		AS (
			SELECT DISTINCT REPLACE(DICD.ICD10Code, '*', '') AS ICD10Code
				,DICD.ICDDescription
			FROM ClientOrdersDiagnosisIIICodes DIC
			JOIN DiagnosisICD10Codes DICD ON DICD.ICD10CodeId = DIC.ICD10CodeId
			WHERE DIC.ClientOrderId IN (
					SELECT CO.ClientOrderId
					FROM ClientOrders CO
					WHERE CO.DocumentVersionId = @DocumentVersionId
						AND ISNULL(CO.OrderPended, 'N') = 'N'
						AND ISNULL(CO.RecordDeleted, 'N') = 'N'
						AND NOT EXISTS (
							SELECT 1
							FROM LabsoftMessages LM
							WHERE LM.ClientOrderId = CO.ClientOrderId
								AND ISNULL(LM.RecordDeleted, 'N') = 'N'
							)
					)
				AND ISNULL(DIC.RecordDeleted, 'N') = 'N'
				AND ISNULL(DICD.RecordDeleted, 'N') = 'N'
			)
		--ORDER by DV.DocumentVersionId DESC)          
		INSERT INTO #tempDiagnoses (
			ICD10Code
			,ICD10Description
			)
		SELECT Convert(NVARCHAR(25), CP.ICD10Code)
			,Convert(NVARCHAR(1000), CP.ICD10Description)
		FROM Diagnoses_CTE CP

		--Loop through Diagnoses
		DECLARE DiagnosesCRSR CURSOR LOCAL SCROLL STATIC
		FOR
		SELECT SetId
			,ICD10Code
			,ICD10Description
		FROM #tempDiagnoses

		OPEN DiagnosesCRSR

		FETCH NEXT
		FROM DiagnosesCRSR
		INTO @SetId
			,@DiagnosisCode
			,@DiagnosisDesc

		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF ISNULL(@DG1Segment, '') = ''
				SET @DG1Segment = dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(@DiagnosisCode, ''), @EncodingChars) + ' ' + dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(@DiagnosisDesc, ''), @EncodingChars)
			ELSE
				SET @DG1Segment = ISNULL(@DG1Segment, '') + @FieldChar + dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(@DiagnosisCode, ''), @EncodingChars) + ' ' + dbo.GetParseLabSoft_OUTBOUND_XFORM(ISNULL(@DiagnosisDesc, ''), @EncodingChars)

			FETCH NEXT
			FROM DiagnosesCRSR
			INTO @SetId
				,@DiagnosisCode
				,@DiagnosisDesc
		END

		CLOSE DiagnosesCRSR

		DEALLOCATE DiagnosesCRSR

		IF ISNULL(@DG1Segment, '') = ''
		BEGIN
			SET @DiagsSegmentRaw = @SegmentName + @FieldChar
		END
		ELSE
		BEGIN
			SET @DiagsSegmentRaw = @SegmentName + @FieldChar + @DG1Segment
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCGetLabsoft_SegmentDiags') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		INSERT INTO ErrorLog (
			ErrorMessage
			,VerboseInfo
			,DataSetInfo
			,ErrorType
			,CreatedBy
			,CreatedDate
			)
		VALUES (
			@Error
			,NULL
			,NULL
			,'HL7 Procedure Error'
			,'SmartCare'
			,GetDate()
			)

		RAISERROR (
				@Error
				,-- Message text.                                                                      
				16
				,-- Severity.                                                                      
				1 -- State.                                                                      
				);
	END CATCH
END
GO


