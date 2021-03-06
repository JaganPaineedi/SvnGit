/****** Object:  UserDefinedFunction [dbo].[fn_SCGetDefaultScreenId]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_SCGetDefaultScreenId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fn_SCGetDefaultScreenId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_SCGetDefaultScreenId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create FUNCTION [dbo].[fn_SCGetDefaultScreenId] (      
      
@StaffId int      
      
)  RETURNS   int      
/********************************************************************************        
-- FUNCTION: dbo.fn_SCGetDefaultScreenId      
--        
-- Copyright: Streamline Healthcate Solutions        
--        
-- Purpose: Get screen id for which staff have permission.        
--        
-- Updates:                                                               
-- Date        Author        Purpose        
-- 05.07.2010  Vikas Monga   Created.              
*********************************************************************************/        
      
begin      
declare @ScreenId int      
declare @defaultScreenid int

select @defaultScreenid=defaultScreenid from tabs where tabid=1
if exists(select * from ViewStaffPermissions where staffid=@StaffId and PermissionTemplateType=5703  and PermissionItemId=@defaultScreenid)
Begin
	set @ScreenId= @defaultScreenid
END
else
begin
Select top 1  @ScreenId=B.ScreenId  from ViewStaffPermissions VP         
left join Banners B         
on B.BannerId= VP.PermissionItemId         
where PermissionTemplateType=5703         
and StaffId=@StaffId and B.TabId=1        
    
end
return @ScreenId  
end
' 
END
GO
