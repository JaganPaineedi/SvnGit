/****** Object:  UserDefinedFunction [dbo].[ssf_str_FROM_BASE64]    Script Date: 04/28/2016 15:09:40 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssf_str_FROM_BASE64]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[ssf_str_FROM_BASE64]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_str_FROM_BASE64]    Script Date: 04/28/2016 15:09:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- From Base64 string
CREATE FUNCTION [dbo].[ssf_str_FROM_BASE64] (@BASE64_STRING VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
	RETURN (
			SELECT CAST(CAST(N'' AS XML).value('xs:base64Binary(sql:variable("@BASE64_STRING"))', 'VARBINARY(MAX)') AS VARCHAR(MAX)) UTF8Encoding
			)
END
GO

