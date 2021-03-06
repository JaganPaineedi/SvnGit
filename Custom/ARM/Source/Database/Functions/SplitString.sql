/****** Object:  UserDefinedFunction [dbo].[SplitString]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SplitString]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[SplitString]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SplitString]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'






CREATE FUNCTION [dbo].[SplitString] 
( 
@InString varchar(8000), 
@Delim char(1) 
) 
RETURNS @Return table 
( 
Position int identity, 
Token varchar(100) -- Maximum token size is 100 chars... 
) 
As 
BEGIN 
Declare @CR varchar(1), 
@LF varchar(1) 
Set @CR = char(10) 
Set @LF = char(13) 
-- 
If @InString is null return 
-- 
Declare @Pos int 
Declare @Pattern char(3) 
Set @Pattern = ''%'' + @Delim + ''%'' 
-- 
Declare @Token varchar(30) 
SELECT @InString = @InString + @Delim -- add trailing delimiter 
SELECT @Pos = PATINDEX(@Pattern, @InString) 
WHILE (@Pos <> 0) BEGIN 
SELECT @Token = ltrim(rtrim(SUBSTRING(@InString, 1, @Pos - 1))) 
Select @Token = replace(@Token, @CR, '''') 
Select @Token = replace(@Token, @LF, '''') 
Insert @Return Values (@Token) 
SELECT @InString = STUFF(@InString, 1, PATINDEX(@Pattern, @InString),'''') 
SELECT @Pos = PATINDEX(@Pattern, @InString) 
END 
-- 
return 
-- 
END







' 
END
GO
