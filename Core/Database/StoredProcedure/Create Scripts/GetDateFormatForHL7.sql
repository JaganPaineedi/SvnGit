/****** Object:  UserDefinedFunction [dbo].[GetDateFormatForHL7]    Script Date: 4/2/2014 10:11:51 AM ******/
IF EXISTS ( SELECT	1
			FROM	INFORMATION_SCHEMA.ROUTINES
			WHERE	SPECIFIC_SCHEMA = 'dbo'
					AND SPECIFIC_NAME = 'GetDateFormatForHL7' ) 
	DROP FUNCTION [dbo].[GetDateFormatForHL7]
GO

/****** Object:  UserDefinedFunction [dbo].[GetDateFormatForHL7]    Script Date: 4/2/2014 10:11:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[GetDateFormatForHL7]
	(
	  @Date DATETIME,
	  @HL7EncodingChars NVARCHAR(5)
	)
RETURNS VARCHAR(26)
	BEGIN
		DECLARE	@CurrentDate VARCHAR(26)
		SELECT	@CurrentDate = dbo.HL7_OUTBOUND_XFORM(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(10), @Date, 121),
															  '-', ''), ':',
															  ''), ' ', ''),
													  @HL7EncodingChars)
		RETURN ISNULL(@CurrentDate,'')
	END


GO


