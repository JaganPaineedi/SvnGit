/****** Object:  UserDefinedFunction [dbo].[cf_Conv_Resolve_GlobalCode]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cf_Conv_Resolve_GlobalCode]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[cf_Conv_Resolve_GlobalCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cf_Conv_Resolve_GlobalCode]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create function [dbo].[cf_Conv_Resolve_GlobalCode] (
@category  char(20),
@code   char(10)) 
returns int
as
begin
  declare @return int

  select @return = GlobalCodeId
    from Cstm_Conv_Map_GlobalCodes
   where category = @category
     and code = @code
  
  if @@rowcount = 0
    set @return = -1

  return @return
end
' 
END
GO
