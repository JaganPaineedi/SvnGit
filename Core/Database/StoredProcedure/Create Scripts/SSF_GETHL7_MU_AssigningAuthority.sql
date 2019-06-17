/****** Object:  UserDefinedFunction [dbo].[SSF_GETHL7_MU_AssigningAuthority]    Script Date: 06/15/2016 10:32:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSF_GETHL7_MU_AssigningAuthority]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[SSF_GETHL7_MU_AssigningAuthority]
GO


/****** Object:  UserDefinedFunction [dbo].[SSF_GETHL7_MU_AssigningAuthority]    Script Date: 06/15/2016 10:32:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[SSF_GETHL7_MU_AssigningAuthority]
	(	  @HL7EncodingChars NVARCHAR(5)
	)
-- =============================================
-- Author:		Chethan N
-- Create date: 06/15/2016
-- Description:	To get Agency Information -- AssigningAuthority
--DECLARE @AssigningAuthority VARCHAR(250)

--  Select @AssigningAuthority= dbo.[SSF_GetHL7_MU_PatientAddress] ('|^~\&' )
  
--  Select @AssigningAuthority
-- =============================================
RETURNS NVARCHAR(250)
	BEGIN
		DECLARE	@AssigningAuthority NVARCHAR(250)

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
	
		SELECT	@AssigningAuthority = dbo.HL7_OUTBOUND_XFORM(ISNULL(RTRIM(LTRIM(AG.AgencyName)), ''),
													  @HL7EncodingChars)
				+  CASE WHEN AG.NationalProviderId IS NOT NULL THEN @SubCompChar + ISNULL(AG.NationalProviderId, '') ELSE '' END
				
				+ CASE WHEN AG.NationalProviderId IS NOT NULL THEN @SubCompChar +  'NPI' ELSE '' END
		FROM	Agency AG
		RETURN ISNULL(@AssigningAuthority,'')
	END


GO


