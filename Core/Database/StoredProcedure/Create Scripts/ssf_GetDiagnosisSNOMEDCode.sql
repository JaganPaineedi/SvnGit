/****** Object:  UserDefinedFunction [dbo].[ssf_GetDiagnosisSNOMEDCode]    Script Date: 02/12/2014 11:30:56 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ssf_GetDiagnosisSNOMEDCode]')
			AND TYPE IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[ssf_GetDiagnosisSNOMEDCode]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_GetDiagnosisSNOMEDCode]    Script Date: 02/12/2014 11:30:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[ssf_GetDiagnosisSNOMEDCode] (
	@DxCode NVARCHAR(250)
	,@DxType NVARCHAR(100)
	,@HL7EncodingChars NVARCHAR(5)
	)
RETURNS VARCHAR(250)

BEGIN
	-- pull hl7 esc chars 
	DECLARE @FieldChar CHAR
	DECLARE @CompChar CHAR
	DECLARE @RepeatChar CHAR
	DECLARE @EscChar CHAR
	DECLARE @SubCompChar CHAR

	SET @FieldChar = SUBSTRING(@HL7EncodingChars, 1, 1)
	SET @CompChar = SUBSTRING(@HL7EncodingChars, 2, 1)
	SET @RepeatChar = SUBSTRING(@HL7EncodingChars, 3, 1)
	SET @EscChar = SUBSTRING(@HL7EncodingChars, 4, 1)
	SET @SubCompChar = SUBSTRING(@HL7EncodingChars, 5, 1)

	DECLARE @DiagnosisSNOMEDFormat NVARCHAR(250)
	DECLARE @DiagnosisCode NVARCHAR(7)
	DECLARE @CodeDescription NVARCHAR(43)
	DECLARE @CodeType NVARCHAR(3)

	SET @CodeType = 'SCT' -- SNOMED

	IF ISNULL(@DxCode, '') != ''
	BEGIN
		IF @DxType = 'ICD-9'
		BEGIN
			SELECT @DiagnosisCode = SNMD.SNOMEDCTCode
				,@CodeDescription = SNMD.SNOMEDCTDescription
			FROM ICD9SNOMEDCTMapping I9SNMD
			INNER JOIN SNOMEDCTCodes SNMD ON SNMD.SNOMEDCTCodeId = I9SNMD.SNOMEDCTCodeId
			WHERE I9SNMD.ICD9Code = @DxCode

			SET @DiagnosisSNOMEDFormat = ISNULL(@DiagnosisCode, '') + @CompChar + ISNULL(@CodeDescription, '') + @CompChar + ISNULL(@CodeType, '')
		END

		IF @DxType = 'ICD-10'
		BEGIN
			SELECT @DiagnosisCode = SNMD.SNOMEDCTCode
				,@CodeDescription = SNMD.SNOMEDCTDescription
			FROM ICD10SNOMEDCTMapping I10SNMD
			INNER JOIN SNOMEDCTCodes SNMD ON SNMD.SNOMEDCTCodeId = I10SNMD.SNOMEDCTCodeId
			WHERE I10SNMD.ICD10CodeId = @DxCode

			SET @DiagnosisSNOMEDFormat = ISNULL(@DiagnosisCode, '') + @CompChar + ISNULL(@CodeDescription, '') + @CompChar + ISNULL(@CodeType, '')
		END
	END

	RETURN ISNULL(@DiagnosisSNOMEDFormat, '')
END
GO

