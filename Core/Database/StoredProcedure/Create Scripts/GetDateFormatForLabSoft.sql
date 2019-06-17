/****** Object:  UserDefinedFunction [dbo].[GetDateFormatForLabSoft]    Script Date: 09/13/2013 12:51:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDateFormatForLabSoft]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetDateFormatForLabSoft]
GO

/****** Object:  UserDefinedFunction [dbo].[GetDateFormatForLabSoft]    Script Date: 09/13/2013 12:51:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GetDateFormatForLabSoft](@Date DATETIME, @EncodingChars nVarchar(5))
RETURNS VARCHAR(26)
BEGIN
	DECLARE @CurrentDate VARCHAR(26)
	SELECT @CurrentDate = dbo.GetParseLabSoft_OUTBOUND_XFORM(REPLACE(REPLACE(REPLACE(CONVERT(varchar(19), @Date, 121), '-', ''), ':', ''), ' ', ''), @EncodingChars)
	RETURN ISNULL(@CurrentDate,'')
END

GO


