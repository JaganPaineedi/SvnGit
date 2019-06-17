/****** Object:  UserDefinedFunction [dbo].[GetDX]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDX]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetDX]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDX]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'







CREATE function [dbo].[GetDX] 
(
@DX1 varchar(1),
@DX2 varchar(1),
@DX3 varchar(1)
)
returns varchar(10)
Begin
declare @strQry varchar(500)
set @strQry=''''
if(@DX1=''Y'' and @DX2=''Y'' and @DX3=''Y'')
begin
set @strQry=''1, 2, 3''
end
else if(@DX1=''Y'' and @DX2=''N'' and @DX3=''N'')
begin
set @strQry=''1''
end
else if(@DX1=''Y'' and @DX2=''Y'' and @DX3=''N'')
begin
set @strQry=''1, 2''
end
else if(@DX1=''N'' and @DX2=''Y'' and @DX3=''N'')
begin
set @strQry=''2''
end
else if(@DX1=''N'' and @DX2=''Y'' and @DX3=''Y'')
begin
set @strQry=''2, 3''
end
else if(@DX1=''Y'' and @DX2=''N'' and @DX3=''Y'')
begin
set @strQry=''1, 3''
end
else if(@DX1=''N'' and @DX2=''N'' and @DX3=''Y'')
begin
set @strQry=''3''
end
return @strQry
End





















' 
END
GO
