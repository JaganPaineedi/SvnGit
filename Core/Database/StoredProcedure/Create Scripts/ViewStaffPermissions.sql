if object_id('dbo.ViewStaffPermissions') is not null
  drop view dbo.ViewStaffPermissions
go  

create view dbo.ViewStaffPermissions as    
/********************************************************************************    
-- View: dbo.ViewStaffPermissions      
--    
-- Copyright: Streamline Healthcate Solutions    
--    
-- Purpose: returns all permission items that are allowed from staff    
-- Updates:                                                           
-- Date        Author      Purpose    
-- 04.01.2010  SFarber     Created.          
-- 06.30.2010  SFarber     Modified to use Staff.Administrator flag.    
-- 07.29.2010  SFarber     Added check for Staff.RecordDeleted where it was missing    
-- 08.30.2010  SFarber     Added support for the 'Image Associations' template.     
--                         Remapped 5706 and 5707 to 5906 and 5907 accordingly.    
-- 09.21.2010  SFarber     Replaced Administrator with SystemAdministrator.    
-- 02.10.2011  SFarber     Added support for the 'Staff Access Rules' template, #5909    
-- 07.29.2011  Sonia       Added support for the 'Event Type' template, #5905     
-- 08.16.2011  KGarg       Added support for the Screen control permissions for Insert and Update mode separately.     
-- 06.07.2014  SFarber     Added support for the 'Application Dropdowns' template, #5904
-- 6.10. 2014  Ponnin	Commented the SystemAdministrator permissions for Banners and Widgets. Why : For task #1511 of Core Bugs.      
-- 6.19. 2014  Ponnin	Default permission to Staff/Users, Role Definition and My Preferences banners for SystemAdministrator. Why : For task #1511 of Core Bugs.
-- 10.07.2014  Chethan N   Added support for the 'Client Information Tabs' template, #5922
-- 30/10/2014  Shruthi.S   Commented the SystemAdministrator permissions for Application dropdowns.Ref : #11 Care Management to SmartCare Env. Issues Tracking.
-- 06.23.2015  Chethan N	What : Added Document Code(View) in permission template type -- #5924
							Why : Macon Design Task#60
-- 06/Jan/2016 Ajay Bangar  Why: Added CONTACT NOTE REASON in permission template type -- #5925
							Why: Woods - Support Go Live:#143
-- 8/8/2017    Hemant       What:Included the flag types.Project:Network180 Support Go Live #307 	-- 
-- 23/Jan/2018 Manjunath	What/Why: Included SmartView Permission type(GlobalCodeId 5929)			-----							For Engineering Improvement Initiatives- NBL(I) 599.	       	       	
*********************************************************************************/    
    
select sp.StaffId, sp.PermissionTemplateType, sp.PermissionItemId    
  from (    
-- All screen controls (INSERT)    
select s.StaffId as StaffId, 5701 as PermissionTemplateType, spc.ScreenPermissionControlId as PermissionItemId    
  from Staff s    
       cross join ScreenPermissionControls spc    
 where s.SystemAdministrator = 'Y'    
   and isnull(s.RecordDeleted, 'N') = 'N'    
   and isnull(spc.RecordDeleted, 'N') = 'N'    
union    
-- All screen controls (UPDATE)     
select s.StaffId as StaffId, 5920 as PermissionTemplateType, spc.ScreenPermissionControlId as PermissionItemId      
  from Staff s      
       cross join ScreenPermissionControls spc      
 where s.SystemAdministrator = 'Y'      
   and isnull(s.RecordDeleted, 'N') = 'N'      
   and isnull(spc.RecordDeleted, 'N') = 'N'      
union   
-- All document codes    
select s.StaffId, 5702, dc.DocumentCodeId      
  from Staff s    
       cross join DocumentCodes dc    
 where s.SystemAdministrator = 'Y'    
   and isnull(s.RecordDeleted, 'N') = 'N'    
   and isnull(dc.RecordDeleted, 'N') = 'N'    
union    
-- All banners   
--*********************************************************************************************** --
-- ******** 6.19. 2014  Ponnin	Default permission to Staff/Users, Role Definition and My Preferences banners for SystemAdministrator. Why : For task #1511 of Core Bugs.   *************-
-- ** Banners			ScreenId

-- ** Staff/Users			84
-- ** Role Definition		85
-- ** My Preferences		17
-- *********************************************************************************************** --   
select s.StaffId, 5703, b.BannerId      
  from Staff s    
       cross join Banners b    
 where s.SystemAdministrator = 'Y'    
   and isnull(s.RecordDeleted, 'N') = 'N'    
   and isnull(b.RecordDeleted, 'N') = 'N' and b.ScreenId in (17,84,85)   
union    
-- All client access rules    
select s.StaffId, 5705, gc.GlobalCodeId    
  from Staff s    
       cross join GlobalCodes gc    
 where s.SystemAdministrator = 'Y'    
   and gc.Category = 'CLIENTACCESSRULE'    
   and gc.Active = 'Y'    
   and isnull(s.RecordDeleted, 'N') = 'N'    
   and isnull(gc.RecordDeleted, 'N') = 'N'    
 --  *********************************************************************************************** --
-- ******** 6.10. 2014  Ponnin	Commented the SystemAdministrator permissions for Banners and Widgets. Why : For task #1511 of Core Bugs.   *************-
-- ** Below is commented for widgets
-- *********************************************************************************************** --  
union    
-- All reports    
select s.StaffId, 5907, r.ReportId    
  from Staff s    
       cross join Reports r    
 where s.SystemAdministrator = 'Y'    
   and isnull(s.RecordDeleted, 'N') = 'N'    
   and isnull(r.RecordDeleted, 'N') = 'N'    
union    
-- All image associations    
select s.StaffId, 5908, gc.GlobalCodeId    
  from Staff s    
       cross join GlobalCodes gc    
 where s.SystemAdministrator = 'Y'    
   and gc.Category = 'IMAGEASSOCIATEDWITH'    
   and gc.Active = 'Y'    
   and isnull(s.RecordDeleted, 'N') = 'N'    
   and isnull(gc.RecordDeleted, 'N') = 'N'    
union    
-- All staff access rules    
select s.StaffId, 5909, gc.GlobalCodeId    
  from Staff s    
       cross join GlobalCodes gc    
 where s.SystemAdministrator = 'Y'    
   and gc.Category = 'STAFFACCESSRULE'    
   and gc.Active = 'Y'    
   and isnull(s.RecordDeleted, 'N') = 'N'    
   and isnull(gc.RecordDeleted, 'N') = 'N'    
union      
-- All Event Types
select s.StaffId, 5905, e.EventTypeId    
  from Staff s    
       cross join EventTypes e    
 where s.SystemAdministrator = 'Y'    
   and isnull(s.RecordDeleted, 'N') = 'N'    
   and isnull(e.RecordDeleted, 'N') = 'N'    
union      
-- All screens
select s.StaffId, 5921, sc.ScreenId  
  from Staff s    
       cross join Screens sc
 where s.SystemAdministrator = 'Y'    
   and isnull(s.RecordDeleted, 'N') = 'N'    
   and isnull(sc.RecordDeleted, 'N') = 'N'    
  --Commented the SystemAdministrator permissions for Application dropdowns.Ref : #11 Care Management to SmartCare Env. Issues Tracking.
--union    
---- All application dropdowns
--select s.StaffId, 5904, gc.GlobalCodeId    
--  from Staff s    
--       cross join GlobalCodes gc    
-- where s.SystemAdministrator = 'Y'    
--   and gc.Category = 'APPLICATIONDROPDOWNS'    
--   and gc.Active = 'Y'    
--   and isnull(s.RecordDeleted, 'N') = 'N'    
--   and isnull(gc.RecordDeleted, 'N') = 'N'    
union   
-- All items that are allowed    
select sr.StaffId, pt.PermissionTemplateType, pti.PermissionItemId    
  from StaffRoles sr    
       join Staff s on s.StaffId = sr.StaffId    
       join PermissionTemplates pt on pt.RoleId = sr.RoleId    
       join PermissionTemplateItems pti on pti.PermissionTemplateId = pt.PermissionTemplateId    
   where pt.PermissionTemplateType in (5701, 5702, 5703, 5704, 5705, 5906, 5907, 5908, 5909, 5905, 5920, 5921, 5904, 5922, 5924, 5925, 5928,5929)    
   and isnull(sr.RecordDeleted, 'N') = 'N'    
   and isnull(pt.RecordDeleted, 'N') = 'N'    
   and isnull(pti.RecordDeleted, 'N') = 'N'    
   and isnull(s.RecordDeleted, 'N') = 'N'    
union    
-- All exceptions that are allowed    
select spe.StaffId, spe.PermissionTemplateType, spe.PermissionItemId    
  from StaffPermissionExceptions spe    
       join Staff s on s.StaffId = spe.StaffId    
 where spe.PermissionTemplateType in (5701, 5702, 5703, 5704, 5705, 5906, 5907, 5908, 5909, 5905, 5920, 5921, 5904, 5922, 5924, 5925, 5928, 5929)    
   and spe.Allow = 'Y'    
   and (spe.StartDate <= getdate() or spe.StartDate is null)    
   and (dateadd(dd, 1, spe.EndDate) > getdate() or spe.EndDate is null)    
   and isnull(spe.RecordDeleted, 'N') = 'N'    
   and isnull(s.RecordDeleted, 'N') = 'N') as sp    
 where not exists(select *    
                    from StaffPermissionExceptions spe     
                   where spe.StaffId = sp.StaffId    
                     and spe.PermissionTemplateType = sp.PermissionTemplateType     
                     and spe.PermissionItemId = sp.PermissionItemId    
                     and isnull(spe.Allow, 'N') = 'N'    
                     and isnull(spe.RecordDeleted, 'N') = 'N')    
    
    
go