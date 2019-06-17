/****** Object:  UserDefinedFunction [dbo].[smsf_FlattenedJSONObject]    Script Date: 11/22/2016 12:35:34 PM ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[smsf_FlattenedJSONObject]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[smsf_FlattenedJSONObject]
GO

/****** Object:  UserDefinedFunction [dbo].[smsf_FlattenedJSONObject]    Script Date: 11/22/2016 12:35:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[smsf_FlattenedJSONObject] (@XMLResult XML)
RETURNS NVARCHAR(max)
	WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE @JSONVersion NVARCHAR(max)
		,@Rowcount INT

	SELECT @JSONVersion = ''
		,@rowcount = count(*)
	FROM @XMLResult.nodes('/root/*') x(a)

	SELECT @JSONVersion = @JSONVersion + Stuff((
				SELECT TheLine
				FROM (
					SELECT ',' + coalesce(x.a.value('local-name(.)', 'NVARCHAR(255)'), '') + ':  
    {' + Stuff((
								SELECT ',"' + coalesce(b.c.value('local-name(.)', 'NVARCHAR(255)'), '') + '":"' + Replace(--escape tab properly within a value  
										Replace(--escape return properly  
											Replace(--linefeed must be escaped  
												Replace(--backslash too  
													Replace(coalesce(b.c.value('text()[1]', 'NVARCHAR(MAX)'), ''), --forwardslash  
														'\', '\\'), '/', '\/'), CHAR(10), '\n'), CHAR(13), '\r'), CHAR(09), '\t') + '"'
								FROM x.a.nodes('*') b(c)
								FOR XML path('')
									,TYPE
								).value('(./text())[1]', 'NVARCHAR(MAX)'), 1, 1, '') + '}'
					FROM @XMLResult.nodes('/root/*') x(a)
					) JSON(theLine)
				FOR XML path('')
					,TYPE
				).value('.', 'NVARCHAR(MAX)'), 1, 1, '')

	IF @Rowcount > 0
		RETURN '{' + @JSONVersion + '  
}'

	RETURN @JSONVersion
END
GO


