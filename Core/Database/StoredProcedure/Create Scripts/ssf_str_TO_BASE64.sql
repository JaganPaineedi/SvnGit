/****** Object:  UserDefinedFunction [dbo].[ssf_str_TO_BASE64]    Script Date: 04/28/2016 15:06:01 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssf_str_TO_BASE64]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[ssf_str_TO_BASE64]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_str_TO_BASE64]    Script Date: 04/28/2016 15:06:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- To Base64 string
CREATE FUNCTION [dbo].[ssf_str_TO_BASE64] (@STRING VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
	RETURN (
			SELECT CAST(N'' AS XML).value('xs:base64Binary(xs:hexBinary(sql:column("bin")))', 'VARCHAR(MAX)') Base64Encoding
			FROM (
				SELECT CAST(@STRING AS VARBINARY(MAX)) AS bin
				) AS bin_sql_server_temp
			)
END
GO

