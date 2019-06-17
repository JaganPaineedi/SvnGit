/****** Object:  StoredProcedure [dbo].[ssp_SCGetStaffListPermissions]    Script Date: 04/03/2014 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetStaffScreenPermissionsForUpdateMode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetStaffScreenPermissionsForUpdateMode]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetStaffScreenPermissionsForUpdateMode] 
@LoggedInStaffId int,    
@StaffId int = null    
/********************************************************************************    
-- Stored Procedure: dbo.ssp_SCGetStaffScreenPermissionsForUpdateMode      
--    
-- Copyright: Streamline Healthcate Solutions    
--    
-- Purpose: returns screens and screen controls that staff member does not have permissions to.    
-- Updates:                                                           
-- Date        Author      Purpose    
-- 12.Aug.2011 Karan Garg  Fetching Screen Control Permission for Update Mode  
--    
*********************************************************************************/    
as    
    
    
set @StaffId = isnull(@StaffId, @LoggedInStaffId)    
    
-- Screens that staff member does not have permissions to    
--select s.ScreenId    
--  from Screens s    
--       join DocumentCodes dc on dc.DocumentCodeId = s.DocumentCodeId    
-- where isnull(dc.RecordDeleted, 'N') = 'N'    
--   and isnull(s.RecordDeleted, 'N') = 'N'    
--   and not exists(select *    
--                    from ViewStaffPermissions p    
--                   where p.StaffId = @StaffId    
--                     and p.PermissionItemId = dc.DocumentCodeId    
--                     and p.PermissionTemplateType = 5702)    
--union    
--select s.ScreenId    
--  from Screens s    
--       join Banners b on b.ScreenId = s.ScreenId    
-- where isnull(b.RecordDeleted, 'N') = 'N'    
--   and isnull(s.RecordDeleted, 'N') = 'N'    
--   and ((@LoggedInStaffId = @StaffId and     
--         not exists(select *    
--                     from ViewStaffPermissions p    
--                    where p.StaffId = @LoggedInStaffId    
--                      and p.PermissionItemId = b.BannerId    
--                      and p.PermissionTemplateType = 5703)) or    
--        (@LoggedInStaffId <> @StaffId and -- Supervisor view    
--         not exists(select *    
--                     from ViewStaffRoleSupervisorPermissions p    
--                    where p.StaffId = @LoggedInStaffId    
--                      and p.PermissionItemId = b.BannerId    
--                      and p.PermissionTemplateType = 5703)))    
    
    
-- Screen controls that staff member does not have permissions to     
select spc.ScreenId,    
       spc.ControlName    
  from Screens s    
       join ScreenPermissionControls spc on spc.ScreenId = s.ScreenId    
 where spc.Active = 'Y'    
   and isnull(spc.RecordDeleted, 'N') = 'N'    
   and isnull(s.RecordDeleted, 'N') = 'N'    
   and ((@LoggedInStaffId = @StaffId and     
         not exists(select *    
                      from ViewStaffPermissions p     
                     where p.StaffId = @LoggedInStaffId    
                       and p.PermissionItemId = spc.ScreenPermissionControlId    
                       and p.PermissionTemplateType = 5920)) or    
        (@LoggedInStaffId <> @StaffId and -- Supervisor view    
         not exists(select *    
                      from ViewStaffRoleSupervisorPermissions p     
                     where p.StaffId = @LoggedInStaffId    
                       and p.PermissionItemId = spc.ScreenPermissionControlId    
                       and p.PermissionTemplateType = 5920)))    
OPTION(RECOMPILE)    



GO


