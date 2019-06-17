/****** Object:  UserDefinedFunction [dbo].[SSF_GETHL7_MU_Ethnicity]    Script Date: 06/15/2016 10:32:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSF_GETHL7_MU_Ethnicity]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[SSF_GETHL7_MU_Ethnicity]
GO


/****** Object:  UserDefinedFunction [dbo].[SSF_GETHL7_MU_Ethnicity]    Script Date: 06/15/2016 10:32:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[SSF_GETHL7_MU_Ethnicity]
	( @ClientId INT,
	@HL7EncodingChars NVARCHAR(5)
	)
-- =============================================
-- Author:		Chethan N
-- Create date: 06/15/2016
-- Description:	To get Client Ethnic Information
-- =============================================
RETURNS NVARCHAR(250)
	BEGIN
		DECLARE	@Ethnicity VARCHAR(MAX)

		DECLARE	@FieldChar CHAR 
		DECLARE	@CompChar CHAR
		DECLARE	@RepeatChar CHAR
		DECLARE	@EscChar CHAR
		DECLARE	@SubCompChar CHAR
		

	
		SET @FieldChar = SUBSTRING(@HL7EncodingChars, 1, 1)
		SET @CompChar = SUBSTRING(@HL7EncodingChars, 2, 1)
		SET @RepeatChar = SUBSTRING(@HL7EncodingChars, 3, 1)
		SET @EscChar = SUBSTRING(@HL7EncodingChars, 4, 1)
		SET @SubCompChar = SUBSTRING(@HL7EncodingChars, 5, 1)
	
		
		SELECT @Ethnicity = STUFF((
			SELECT '~' + ISNULL(RTRIM(LTRIM(HV.ConceptCode)), '') + @CompChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(RTRIM(LTRIM(GC.CodeName)), ''), @HL7EncodingChars) + @CompChar + dbo.HL7_OUTBOUND_XFORM(ISNULL(RTRIM(LTRIM(HV.HL7Table0396Code)), ''), @HL7EncodingChars)
			FROM ClientEthnicities CE
			JOIN GlobalCodes GC ON GC.GlobalCodeId = CE.EthnicityId
			JOIN HL7Vocabulary HV ON HV.ConceptName = GC.CodeName
			WHERE CE.ClientId = @ClientId AND ISNULL(CE.RecordDeleted,'N') = 'N'
				AND CE.ClientEthnicityId IN (
					SELECT ClientEthnicityId
					FROM ClientEthnicities
					JOIN GlobalCodes GC ON GC.GlobalCodeId = EthnicityId
					JOIN HL7Vocabulary HV ON HV.ConceptName = GC.CodeName
					WHERE ClientId = @ClientId
					)
			FOR XML PATH('')
			), 1, 1, '')
 
		
		
		RETURN ISNULL(RTRIM(LTRIM(@Ethnicity)),'')
		
	END


GO


