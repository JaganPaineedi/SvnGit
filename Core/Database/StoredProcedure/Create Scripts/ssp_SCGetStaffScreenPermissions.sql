if object_id('dbo.ssp_SCGetStaffScreenPermissions') is not null
  drop procedure dbo.ssp_SCGetStaffScreenPermissions
go

create procedure dbo.ssp_SCGetStaffScreenPermissions
  @LoggedInStaffId int,
  @StaffId int = null  
/********************************************************************************  
-- Stored Procedure: dbo.ssp_SCGetStaffScreenPermissions    
--  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose: returns screens and screen controls that staff member does not have permissions to.  
-- Updates:                                                         
-- Date        Author      Purpose  
--04.01.2010  SFarber      Created.   
--07.09.2010  SFarber      Added logic to support Supervisor view.  
--06.05.2012  Sonia Dhamija Made changes to support new Permission template for Screens
-- 6.25. 2014  Ponnin		Added Banners.Active = 'Y' for banners/screens permission. Why : For task #1511 of Core Bugs. 
                            Issue : If there are multiple banner entries for same screenid then the screens permission is not working due to duplicate banner entries. 
--06.25.2015  Chethan N		What : Permission check for both 'Document Code (Edit)' and 'Document Code (View).
							Why : Macon Desing task#60
-- 05.11.2017  sali         Split logic to improve performance for Phil Haven since they have large number of records in permissions table
-- 06.22.2017  SFarber      Modified to check if a screen is not permitted under a different banner

*********************************************************************************/
as
set @StaffId = isnull(@StaffId, @LoggedInStaffId)  
  
-- Screens that staff member does not have permissions to  
select  s.ScreenId
from    Screens s
        join DocumentCodes dc on dc.DocumentCodeId = s.DocumentCodeId
where   isnull(dc.RecordDeleted, 'N') = 'N'
        and isnull(s.RecordDeleted, 'N') = 'N'
        and not exists ( select *
                         from   ViewStaffPermissions p
                         where  p.StaffId = @StaffId
                                and p.PermissionItemId = dc.DocumentCodeId
                                and p.PermissionTemplateType in (5702, 5924) ) -- Chethan N Changes -- Permission check for both 'Document Code (Edit)' and 'Document Code (View)'
union  

-- Screens not assoicated with Banners and not associated with DocumentCodes
-- Split query into below two queries for improve query performance due to Phil Haven having large number of permissions
select  s.ScreenId
from    Screens s
        left join Banners b on b.ScreenId = s.ScreenId
where   isnull(s.RecordDeleted, 'N') = 'N'
        and not exists ( select *
                         from   ViewStaffPermissions p
                         where  p.StaffId = @StaffId
                                and p.PermissionItemId = s.ScreenId
                                and p.PermissionTemplateType = 5921 )
        and (s.ScreenType <> 5763)
        and b.ScreenId is null
        and isnull(b.RecordDeleted, 'N') = 'N'
union
select  s.ScreenId
from    Screens s
        join Banners b on b.ScreenId = s.ScreenId
where   isnull(b.RecordDeleted, 'N') = 'N'  
        -- 6.25. 2014  Ponnin		Added Banners.Active = 'Y' for banners/screens permission. Why : For task #1511 of Core Bugs. 
        and isnull(s.RecordDeleted, 'N') = 'N'
        and b.Active = 'Y'
        and s.DocumentCodeId is null -- Changes by Chethan N -- To check for Screens which are not associated to Documents.
        and @LoggedInStaffId = @StaffId
        and not exists ( select *
                         from   ViewStaffPermissions p
                         where  p.StaffId = @LoggedInStaffId
                                and p.PermissionItemId = b.BannerId
                                and p.PermissionTemplateType = 5703 )
        -- Check if a screen is not permitted under a different banner
        and not exists ( select *
                         from   Banners db
                                join ViewStaffPermissions p on p.PermissionItemId = db.BannerId
                         where  p.StaffId = @LoggedInStaffId
                                and db.ScreenId = s.ScreenId
                                and db.BannerId <> b.BannerId
                                and p.PermissionTemplateType = 5703 )
union
select  s.ScreenId
from    Screens s
        join Banners b on b.ScreenId = s.ScreenId
where   isnull(b.RecordDeleted, 'N') = 'N'  
        -- 6.25. 2014  Ponnin		Added Banners.Active = 'Y' for banners/screens permission. Why : For task #1511 of Core Bugs. 
        and isnull(s.RecordDeleted, 'N') = 'N'
        and b.Active = 'Y'
        and s.DocumentCodeId is null -- Changes by Chethan N -- To check for Screens which are not associated to Documents.
        and @LoggedInStaffId <> @StaffId -- Supervisor view
        and not exists ( select *
                         from   ViewStaffRoleSupervisorPermissions p
                         where  p.StaffId = @LoggedInStaffId
                                and p.PermissionItemId = b.BannerId
                                and p.PermissionTemplateType = 5703 )
        -- Check if a screen is not permitted under a different banner
        and not exists ( select *
                         from   Banners db
                                join ViewStaffRoleSupervisorPermissions p on p.PermissionItemId = db.BannerId
                         where  p.StaffId = @LoggedInStaffId
                                and db.ScreenId = s.ScreenId
                                and db.BannerId <> b.BannerId
                                and p.PermissionTemplateType = 5703 ) 
  
  
-- Screen controls that staff member does not have permissions to   
-- Split query into below two queries for improve query performance due to Phil Haven having large number of permissions
select  spc.ScreenId,
        spc.ControlName
from    Screens s
        join ScreenPermissionControls spc on spc.ScreenId = s.ScreenId
where   spc.Active = 'Y'
        and isnull(spc.RecordDeleted, 'N') = 'N'
        and isnull(s.RecordDeleted, 'N') = 'N'
        and ((@LoggedInStaffId = @StaffId
             and not exists ( select  *
                              from    ViewStaffPermissions p
                              where   p.StaffId = @LoggedInStaffId
                                      and p.PermissionItemId = spc.ScreenPermissionControlId
                                      and p.PermissionTemplateType = 5701 )))
union
select  spc.ScreenId,
        spc.ControlName
from    Screens s
        join ScreenPermissionControls spc on spc.ScreenId = s.ScreenId
where   spc.Active = 'Y'
        and isnull(spc.RecordDeleted, 'N') = 'N'
        and isnull(s.RecordDeleted, 'N') = 'N'
        and ((@LoggedInStaffId <> @StaffId
             and -- Supervisor view  
             not exists ( select  *
                          from    ViewStaffRoleSupervisorPermissions p
                          where   p.StaffId = @LoggedInStaffId
                                  and p.PermissionItemId = spc.ScreenPermissionControlId
                                  and p.PermissionTemplateType = 5701 )))
option  (recompile)



go
