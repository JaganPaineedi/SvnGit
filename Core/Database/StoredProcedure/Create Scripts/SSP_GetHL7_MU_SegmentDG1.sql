/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_SegmentDG1]    Script Date: 06/09/2016 23:33:50 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetHL7_MU_SegmentDG1]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetHL7_MU_SegmentDG1]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_SegmentDG1]    Script Date: 06/09/2016 23:33:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_GetHL7_MU_SegmentDG1] @VendorId INT
	,@ClientId INT
	,@HL7EncodingChars NVARCHAR(5)
	,@DocumentVersionId INT
	,@DG1SegmentRaw NVARCHAR(max) OUTPUT
AS
--===================================          
-- DESC : Gets diagnosescode an description based on the clientId.           
--    As the diagnoses is a document in SC we fetch all ICD codes            
--    and its description for the documents which are signed (valid) 
-- Author: Varun         
--===================================          
BEGIN
	BEGIN TRY
		DECLARE @SetId INT
		DECLARE @DiagnosisCodingMethod NVARCHAR(6)
		DECLARE @DiagnosisCode NVARCHAR(250)
		DECLARE @DiagnosisDesc NVARCHAR(max)
		DECLARE @DiagnosisType NVARCHAR(2)
		DECLARE @SegmentName NVARCHAR(3)
		DECLARE @OverrideSPName NVARCHAR(200)
		DECLARE @DG1Segment NVARCHAR(max)
		DECLARE @FieldChar CHAR
		DECLARE @CompChar CHAR
		DECLARE @RepeatChar CHAR
		DECLARE @EscChar CHAR
		DECLARE @SubCompChar CHAR
		DECLARE @DiagnosisICD9Code NVARCHAR(250)
		DECLARE @DiagnosisICD9Desc NVARCHAR(max)
		DECLARE @DXSearchPreference NVARCHAR(250)
		DECLARE @SnomedCTCode NVARCHAR(250)
		DECLARE @SnomedCTCodeDesc NVARCHAR(max)
		DECLARE @Source NVARCHAR(100)

		EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars
			,@FieldChar OUTPUT
			,@CompChar OUTPUT
			,@RepeatChar OUTPUT
			,@EscChar OUTPUT
			,@SubCompChar OUTPUT

		SET @SegmentName = 'DG1'

		CREATE TABLE #tempDiagnoses (
			SetId INT identity(1, 1)
			,ICD10Code NVARCHAR(1000)
			,ICD10Description NVARCHAR(max)
			,DiagnosisType VARCHAR(10)
			,ICD9Code NVARCHAR(1000)
			,ICD9Description NVARCHAR(max)
			,SnomedCTCode NVARCHAR(1000)
			,SnomedCTDescription NVARCHAR(max)
			,Source VARCHAR(100)
			);

		--SET @DXSearchPreference = (
		--		SELECT G.CodeName
		--		FROM GlobalCodes G
		--		INNER JOIN Staff S ON G.GlobalCOdeId = S.DXSearchPreference
		--		INNER JOIN DocumentSyndromicSurveillances DSS ON DSS.CreatedBy = S.UserCode
		--		WHERE DSS.DocumentVersionId = @DocumentVersionId
		--		);

		WITH Diagnoses_CTE (
			ICD10Code
			,ICD10Description
			,DiagnosisType
			,ModifiedDate
			,ICD9Code
			,ICD9Description
			,SnomedCTCode
			,SnomedCTDescription
			,Source
			)
		AS (
			SELECT REPLACE(D.ICD10Code, '*', '') AS ICD10Code
				,DSM.ICDDescription
				,D.DiagnosisType
				,D.ModifiedDate
				,D.ICD9Code
				,DC.ICDDescription
				,S.SnomedCTCode
				,S.SnomedCTDescription
				,D.Source
			FROM DocumentDiagnosisCodes AS D
			INNER JOIN DiagnosisICD10Codes AS DSM ON DSM.ICD10CodeId = D.ICD10CodeId
			INNER JOIN DocumentDiagnosis AS DD ON DD.DocumentVersionId = D.DocumentVersionId
			LEFT JOIN DiagnosisICDCodes AS DC ON DC.ICDCode = D.ICD9Code
			LEFT JOIN SNOMEDCTCodes AS S ON D.SNOMEDCODE = S.SNOMEDCTCode
			WHERE (D.DocumentVersionId = @DocumentVersionId)
				AND (ISNULL(D.RecordDeleted, 'N') = 'N')
				AND D.DiagnosisType <> 142
			)
		--ORDER by DV.DocumentVersionId DESC)          
		INSERT INTO #tempDiagnoses (
			ICD10Code
			,ICD10Description
			,DiagnosisType
			,ICD9Code
			,ICD9Description
			,SnomedCTCode
			,SnomedCTDescription
			,Source
			)
		SELECT Convert(NVARCHAR(25), CP.ICD10Code)
			,Convert(NVARCHAR(1000), CP.ICD10Description)
			,CASE 
				WHEN DiagnosisType = 140
					THEN 'F'
				ELSE 'W'
				END
			,ICD9Code
			,ICD9Description
			,SnomedCTCode
			,SnomedCTDescription
			,Source
		FROM Diagnoses_CTE CP
		ORDER BY CP.ModifiedDate

		--SELECT *
		--FROM #tempDiagnoses
		--SELECT @DXSearchPreference
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
			,DiagnosisType
			,ICD9Code
			,ICD9Description
			,SnomedCTCode
			,SnomedCTDescription
			,Source
		FROM #tempDiagnoses

		OPEN DiagnosesCRSR

		FETCH NEXT
		FROM DiagnosesCRSR
		INTO @SetId
			,@DiagnosisCode
			,@DiagnosisDesc
			,@DiagnosisType
			,@DiagnosisICD9Code
			,@DiagnosisICD9Desc
			,@SnomedCTCode
			,@SnomedCTCodeDesc
			,@Source

		WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE @PrevString NVARCHAR(max)

			SELECT @PrevString = ISNULL(@DG1Segment, '')

			IF (@Source = 'SNOMED')
				SET @DG1Segment = @SegmentName + @FieldChar + Convert(NVARCHAR(4), @SetId) + @FieldChar + @FieldChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(@SnomedCTCode, ''), @HL7EncodingChars) + @CompChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(@SnomedCTCodeDesc, ''), @HL7EncodingChars) + @CompChar + 'SCT' + @FieldChar + @FieldChar + @FieldChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(@DiagnosisType, ''), @HL7EncodingChars)
			ELSE IF (@Source = 'ICD9')
				SET @DG1Segment = @SegmentName + @FieldChar + Convert(NVARCHAR(4), @SetId) + @FieldChar + @FieldChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(@DiagnosisICD9Code, ''), @HL7EncodingChars) + @CompChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(@DiagnosisICD9Desc, ''), @HL7EncodingChars) + @CompChar + 'I9CDX' + @FieldChar + @FieldChar + @FieldChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(@DiagnosisType, ''), @HL7EncodingChars)
			ELSE
				SET @DG1Segment = @SegmentName + @FieldChar + Convert(NVARCHAR(4), @SetId) + @FieldChar + @FieldChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(@DiagnosisCode, ''), @HL7EncodingChars) + @CompChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(@DiagnosisDesc, ''), @HL7EncodingChars) + @CompChar + 'I10C' + @FieldChar + @FieldChar + @FieldChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(@DiagnosisType, ''), @HL7EncodingChars)
			IF @Counter = @TotalDiagnoses
			BEGIN
				SELECT @DG1Segment = @PrevString + @DG1Segment + CHAR(13)
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
				,@DiagnosisType
				,@DiagnosisICD9Code
				,@DiagnosisICD9Desc
				,@SnomedCTCode
				,@SnomedCTCodeDesc
				,@Source
		END

		CLOSE DiagnosesCRSR

		DEALLOCATE DiagnosesCRSR

		SET @DG1SegmentRaw = ISNULL(LTRIM(RTRIM(STUFF(@DG1Segment, LEN(@DG1Segment), 1, ''))), '')
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_GetHL7_MU_SegmentDG1') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

