
/****** Object:  UserDefinedFunction [dbo].[SplitString]    Script Date: 04/06/2017 11:28:40 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SplitString]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[SplitString]
GO


/****** Object:  UserDefinedFunction [dbo].[SplitString]    Script Date: 04/06/2017 11:28:40 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[SplitString] (
	@InString VARCHAR(8000)
	,@Delim CHAR(1)
	)
RETURNS @Return TABLE (
	Position INT identity
	,Token VARCHAR(1000) -- Maximum token size is 100 chars... 
	)
AS
BEGIN
	DECLARE @CR VARCHAR(1)
		,@LF VARCHAR(1)

	SET @CR = CHAR(10)
	SET @LF = CHAR(13)

	-- 
	IF @InString IS NULL
		RETURN

	-- 
	DECLARE @Pos INT
	DECLARE @Pattern CHAR(3)

	SET @Pattern = '%' + @Delim + '%'

	-- 
	DECLARE @Token VARCHAR(1000)

	SELECT @InString = @InString + @Delim -- add trailing delimiter 

	SELECT @Pos = PATINDEX(@Pattern, @InString)

	WHILE (@Pos <> 0)
	BEGIN
		SELECT @Token = ltrim(rtrim(SUBSTRING(@InString, 1, @Pos - 1)))

		SELECT @Token = replace(@Token, @CR, '')

		SELECT @Token = replace(@Token, @LF, '')

		INSERT @Return
		VALUES (@Token)

		SELECT @InString = STUFF(@InString, 1, PATINDEX(@Pattern, @InString), '')

		SELECT @Pos = PATINDEX(@Pattern, @InString)
	END

	-- 
	RETURN
		-- 
END
GO


