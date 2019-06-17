/****** Object:  StoredProcedure [dbo].[SSP_SCGetHL7_251_SegmentDG1]    Script Date: 05/19/2016 14:46:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetHL7_251_SegmentDG1]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCGetHL7_251_SegmentDG1]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCGetHL7_251_SegmentDG1]    Script Date: 05/19/2016 14:46:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetHL7_251_SegmentDG1] @VendorId INT
	,@ClientId INT
	,@HL7EncodingChars NVARCHAR(5)
	,@DG1SegmentRaw NVARCHAR(max) OUTPUT
AS
--===================================          
-- DESC : Gets diagnosescode an description based on the clientId.           
--    As the diagnoses is a document in SC we fetch all ICD codes            
--    and its description for the documents which are signed (valid)          
/*          
Declare @DG1SegmentRaw nVarchar(max)          
EXEC SSP_SCGetHL7_251_SegmentDG1 1,2,'|^~\&',@DG1SegmentRaw Output          
Select @DG1SegmentRaw          
Date   Modified By     Reason          
05/Oct/2015  Gautam   Changed code for ICD10 from ICD9          
*/
--===================================          
BEGIN
	BEGIN TRY
		DECLARE @SetId INT
		DECLARE @DiagnosisCodingMethod NVARCHAR(6)
		DECLARE @DiagnosisCode NVARCHAR(250)
		DECLARE @DiagnosisDesc NVARCHAR(250)
		DECLARE @DiagnosisType NVARCHAR(2)
		DECLARE @SegmentName NVARCHAR(3)
		DECLARE @OverrideSPName NVARCHAR(200)
		DECLARE @DG1Segment NVARCHAR(max)
		-- pull out encoding characters          
		DECLARE @FieldChar CHAR
		DECLARE @CompChar CHAR
		DECLARE @RepeatChar CHAR
		DECLARE @EscChar CHAR
		DECLARE @SubCompChar CHAR

		EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars
			,@FieldChar OUTPUT
			,@CompChar OUTPUT
			,@RepeatChar OUTPUT
			,@EscChar OUTPUT
			,@SubCompChar OUTPUT

		SET @SegmentName = 'DG1'
		SET @DiagnosisType = 'F' --A=Admitting  W=Working  F=Final          
		SET @DiagnosisCodingMethod = 'ICD-10'

		CREATE TABLE #tempDiagnoses (
			SetId INT identity(1, 1)
			,ICD10Code NVARCHAR(1000)
			,ICD10Description NVARCHAR(1000)
			,DiagnosisOrder INT
			)

		DECLARE @LatestICD10DocumentVersionID INT

		SET @LatestICD10DocumentVersionID = (
				SELECT TOP 1 a.CurrentDocumentVersionId
				FROM Documents AS a
				INNER JOIN DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId
				INNER JOIN DocumentDiagnosis AS DDC ON a.CurrentDocumentVersionId = DDC.DocumentVersionId
				WHERE a.ClientId = @ClientId
					AND a.EffectiveDate <= getDate()
					AND a.STATUS = 22
					AND Dc.DiagnosisDocument = 'Y'
					AND isNull(a.RecordDeleted, 'N') <> 'Y'
					AND isNull(Dc.RecordDeleted, 'N') <> 'Y'
					AND ISNULL(DDC.RecordDeleted, 'N') <> 'Y'
				ORDER BY a.EffectiveDate DESC
					,a.ModifiedDate DESC
				);

		WITH Diagnoses_CTE (
			ICD10Code
			,ICD10Description
			,DiagnosisOrder
			)
		AS (
			SELECT REPLACE(D.ICD10Code, '*', '') AS ICD10Code
				,DSM.ICDDescription
				,D.DiagnosisOrder
			FROM DocumentDiagnosisCodes AS D
			INNER JOIN DiagnosisICD10Codes AS DSM ON DSM.ICD10CodeId = D.ICD10CodeId
			INNER JOIN DocumentDiagnosis AS DD ON DD.DocumentVersionId = D.DocumentVersionId
			WHERE (D.DocumentVersionId = @LatestICD10DocumentVersionID)
				AND (ISNULL(D.RecordDeleted, 'N') = 'N')
			)
		--ORDER by DV.DocumentVersionId DESC)          
		INSERT INTO #tempDiagnoses (
			ICD10Code
			,ICD10Description
			)
		SELECT Convert(NVARCHAR(25), CP.ICD10Code)
			,Convert(NVARCHAR(1000), CP.ICD10Description)
		FROM Diagnoses_CTE CP
		ORDER BY CP.DiagnosisOrder

		--Loop through Diagnoses          
		DECLARE @Counter INT
		DECLARE @TotalDiagnoses INT

		SET @Counter = 1

		SELECT @TotalDiagnoses = count(*)
		FROM #tempDiagnoses

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
			DECLARE @PrevString NVARCHAR(max)

			SELECT @PrevString = ISNULL(@DG1Segment, '')

			SET @DG1Segment = @SegmentName + @FieldChar + Convert(NVARCHAR(4), @SetId) + @FieldChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(@DiagnosisCodingMethod, ''), @HL7EncodingChars) + @FieldChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(@DiagnosisCode, ''), @HL7EncodingChars) + @FieldChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(@DiagnosisDesc, ''), @HL7EncodingChars) + @FieldChar + @FieldChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(@DiagnosisType, ''), @HL7EncodingChars) + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar

			IF @Counter = @TotalDiagnoses
			BEGIN
				SELECT @DG1Segment = @PrevString + @DG1Segment
			END
			ELSE
			BEGIN
				SELECT @DG1Segment = @PrevString + @DG1Segment + CHAR(13)
			END

			SET @Counter = @Counter + 1

			FETCH NEXT
			FROM DiagnosesCRSR
			INTO @SetId
				,@DiagnosisCode
				,@DiagnosisDesc
		END

		CLOSE DiagnosesCRSR

		DEALLOCATE DiagnosesCRSR

		SELECT @OverrideSPName = StoredProcedureName
		FROM HL7CPSegmentConfigurations
		WHERE VendorId = @VendorId
			AND SegmentType = @SegmentName
			AND ISNULL(RecordDeleted, 'N') = 'N'

		IF ISNULL(@OverrideSPName, '') != ''
		BEGIN
			--Pass the resulting string and modify in the Override SP.                
			DECLARE @OutputString NVARCHAR(max)
			DECLARE @SPName NVARCHAR(max)
			DECLARE @ParamDef NVARCHAR(max)
			DECLARE @StartingString NVARCHAR(max) -- starting string to work with for override sp          

			SET @StartingString = @DG1Segment
			SET @SPName = 'EXEC ' + @OverrideSPName + ' @VendorId,@ClientId,@HL7EncodingChars,@OutputString OUTPUT'
			SET @ParamDef = N'@VendorId int, @ClientId int,@HL7EncodingChars nVarchar(5),@OutputString nvarchar(max) OUTPUT'

			EXECUTE sp_executesql @SPName
				,@ParamDef
				,@VendorId
				,@ClientId
				,@HL7EncodingChars
				,@OutputString OUTPUT

			SET @DG1Segment = @OutputString
		END

		SET @DG1SegmentRaw = @DG1Segment
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCGetHL7_251_SegmentDG1') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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
	END CATCH
END
GO


