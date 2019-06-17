/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_SegmentPV2]    Script Date: 06/10/2016 01:31:57 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetHL7_MU_SegmentPV2]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetHL7_MU_SegmentPV2]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_SegmentPV2]    Script Date: 06/10/2016 01:31:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_GetHL7_MU_SegmentPV2] @VendorId INT
	,@ClientId INT
	,@HL7EncodingChars NVARCHAR(5)
	,@DocumentVersionId INT
	,@PV2SegmentRaw NVARCHAR(Max) OUTPUT
AS
--===========================================
/*
Declare @PV1SegmentRaw nVarchar(max)
EXEC SSP_GetHL7_MU_SegmentPV2 1,24,'|^~\&',@PV1SegmentRaw Output
Select @PV1SegmentRaw
Author: Varun
*/
--===========================================
BEGIN
	BEGIN TRY
		DECLARE @SegmentName VARCHAR(3)
		DECLARE @SetId NVARCHAR(4)
		DECLARE @PatientClass VARCHAR(1)
		DECLARE @AssignedPatientLocation VARCHAR(40)
		DECLARE @FieldChar CHAR
		DECLARE @CompChar CHAR
		DECLARE @RepeatChar CHAR
		DECLARE @EscChar CHAR
		DECLARE @SubCompChar CHAR
		DECLARE @ChiefComplaint VARCHAR(max)
		DECLARE @ICD10Code VARCHAR(100)
		DECLARE @DiagnosisType INT
		DECLARE @ICD10Description VARCHAR(max)
		DECLARE @PV2SegmentExt VARCHAR(max)
		DECLARE @ICD9Code VARCHAR(100)
		DECLARE @ICD9Description VARCHAR(max)
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

		SET @SegmentName = 'PV2'

		SELECT @DXSearchPreference = G.CodeName
		FROM GlobalCodes G
		INNER JOIN Staff S ON G.GlobalCodeId = S.DXSearchPreference
		INNER JOIN DocumentSyndromicSurveillances DSS ON DSS.CreatedBy = S.UserCode
		WHERE DSS.DocumentVersionId = @DocumentVersionId

		SELECT TOP 1 @ICD10Code = REPLACE(D.ICD10Code, '*', '')
			,@ICD10Description = DSM.ICDDescription
			,@DiagnosisType = D.DiagnosisType
			,@ICD9Code = D.ICD9Code
			,@ICD9Description = DC.ICDDescription
			,@SnomedCTCode = S.SnomedCTCode
			,@SnomedCTCodeDesc = S.SnomedCTDescription
			,@Source=D.Source
		FROM DocumentDiagnosisCodes AS D
		INNER JOIN DiagnosisICD10Codes AS DSM ON DSM.ICD10CodeId = D.ICD10CodeId
		INNER JOIN DocumentDiagnosis AS DD ON DD.DocumentVersionId = D.DocumentVersionId
		LEFT JOIN DiagnosisICDCodes AS DC ON DC.ICDCode = D.ICD9Code
		LEFT JOIN SNOMEDCTCodes AS S ON D.SNOMEDCODE = S.SNOMEDCTCode
		WHERE (D.DocumentVersionId = @DocumentVersionId)
			AND (ISNULL(D.RecordDeleted, 'N') = 'N')
			AND D.DiagnosisType = 142
		ORDER BY D.ModifiedDate

		SELECT @ChiefComplaint = ChiefComplaint
		FROM DocumentSyndromicSurveillances
		WHERE DocumentVersionId = @DocumentVersionId

		IF (@DiagnosisType = 142)
		BEGIN
			IF (@Source = 'SNOMED')
				SET @PV2SegmentExt = REPLACE(@SnomedCTCode, '.', '') + @CompChar + ISNULL(@SnomedCTCodeDesc, '') + @CompChar + 'SCT'
			ELSE IF (@DXSearchPreference = 'ICD9')
				SET @PV2SegmentExt = REPLACE(@ICD9Code, '.', '') + @CompChar + ISNULL(@ICD9Description, '') + @CompChar + 'I9CDX'
			ELSE
				SET @PV2SegmentExt = REPLACE(@ICD10Code, '.', '') + @CompChar + ISNULL(@ICD10Description, '') + @CompChar + 'I10C'
		END
		ELSE IF (
				ISNULL(@DiagnosisType, '') = ''
				AND ISNULL(@ChiefComplaint, '') <> ''
				)
			SET @PV2SegmentExt = @CompChar + @ChiefComplaint

		IF (ISNULL(@PV2SegmentExt, '') <> '')
			SET @PV2SegmentRaw = @SegmentName + @FieldChar + @FieldChar + @FieldChar + @PV2SegmentExt
		ELSE
			SET @PV2SegmentRaw = ''
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_GetHL7_MU_SegmentPV2') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

