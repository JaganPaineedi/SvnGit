/****** Object:  UserDefinedFunction [dbo].[parseList]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[parseList]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[parseList]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[parseList]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'






create function [dbo].[parseList] (@s varchar(2000))
returns @values table (value varchar(2000))
as begin
declare @v varchar(2000) ,@i int
set @i = patIndex(''%,%'',@s)
while @i > 0 begin
insert @values values (substring(@s,1,@i-1))
set @s = substring(@s,@i+1,len(@s) - @i)
set @i = patIndex(''%,%'',@s)
end
insert @values values (@s)
return
end








' 
END
GO
