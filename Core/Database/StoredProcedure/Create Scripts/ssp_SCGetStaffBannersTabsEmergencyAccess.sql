/****** Object:  StoredProcedure [dbo].[ssp_SCGetStaffBannersTabsEmergencyAccess]    Script Date: 05-10-2017 10:38:25 ******/
DROP PROCEDURE [dbo].[ssp_SCGetStaffBannersTabsEmergencyAccess]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetStaffBannersTabsEmergencyAccess]    Script Date: 05-10-2017 10:38:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
  
CREATE procedure [dbo].[ssp_SCGetStaffBannersTabsEmergencyAccess]          
(           
@StaffId int = null,          
@RoleId int          
)                      
/********************************************************************************                  
-- Stored Procedure: dbo.ssp_SCGetStaffBannersTabs                    
--                  
-- Copyright: Streamline Healthcate Solutions                  
--                  
-- Purpose: selects staff banners and tabs                  
--                  
-- Updates:                                                                         
-- Date        Author      Purpose                  
-- 05.07.2010  SFarber     Created.                  
-- 06.25.2010  SFarber     Modified to return more data for tabs.                  
-- 07.09.2010  SFarber     Added logic to support Supervisor view.                  
--                  
*********************************************************************************/                  
as             
          
declare @ViewStaffPermissions table (staffid int,PermissionTemplateType int,PermissionItemId int  )          
insert into @ViewStaffPermissions(staffid,PermissionTemplateType,PermissionItemId)                                          
              
select @Staffid as staffid, PermissionTemplates.PermissionTemplateType  as PermissionTemplateType, PermissionTemplateItems.PermissionItemId as PermissionItemId           
from PermissionTemplates inner join PermissionTemplateItems on PermissionTemplates.PermissionTemplateId = PermissionTemplateItems.PermissionTemplateId where           
RoleId =@RoleId and  isnull (PermissionTemplates.RecordDeleted,'N')='N' and ISNULL(PermissionTemplateItems.RecordDeleted,'N')='N'              
          

declare @PermittedBanners table (BannerId int)                  
                  
declare @StaffBanners table (                  
BannerOrder    int identity not null,                  
BannerId       int,                  
BannerName     varchar(100),                  
DisplayAs      varchar(100),                  
TabId          int,                  
ParentBannerId int,                  
ScreenId       int,                  
ScreenType     int,                  
Custom         char(1),
DefaultOrder	int)                  
                  
declare @StaffTabs table(                  
TabId           int,                  
TabName         varchar(30),                  
DisplayAs       varchar(30),                  
DefaultScreenId int,                  
TabOrder        int)                  
                  
    
  insert into @PermittedBanners (BannerId)                  
  select vsp.PermissionItemId                  
    from @ViewStaffPermissions vsp                   
   where vsp.StaffId = @StaffId                  
     and vsp.PermissionTemplateType in (5703)     
        
    Insert into @PermittedBanners (BannerId)    
    select Bannerid  from  banners b inner join Screens s on b.ScreenId=s.ScreenId     
    where s.DocumentCodeId in (select PermissionItemId from @ViewStaffPermissions where PermissionTemplateType=5702)    
                  
--end                   
                  
-- Banners       
    
insert into @StaffBanners (                  
       BannerId,                  
       BannerName,                  
       DisplayAs,                  
       TabId,                  
       ParentBannerId,                  
       ScreenId,                  
       ScreenType,                  
       Custom,
	   DefaultOrder)                  
select DISTINCT b.BannerId,                    
       b.BannerName,                    
       b.DisplayAs,            
       b.TabId,                    
       b.ParentBannerId,                    
       b.ScreenId,                    
      s.ScreenType,                  
       b.Custom,                  
     b.DefaultOrder
 from Banners as b              
        join @PermittedBanners pb on pb.BannerId = b.BannerId    
  left join Screens s on s.ScreenId = b.ScreenId            
  left join DocumentCodes dc on dc.DocumentCodeId = s.DocumentCodeId            
  left join @ViewStaffPermissions pd on  pd.PermissionItemId = dc.DocumentCodeId and pd.PermissionTemplateType = 5702  
       
      
 where b.Active = 'Y'            
   and (dc.Active = 'Y' or dc.DocumentCodeId is null)            
   and isnull(b.RecordDeleted, 'N') = 'N'                
   and (    
   dc.DocumentCodeId is null or    
    pd.PermissionItemId is not null)            
 order by b.TabId,            
          b.ParentBannerId,            
          b.DefaultOrder,            
          DisplayAs   
     
    
insert into @StaffTabs (TabId, TabName, DisplayAs, DefaultScreenId, TabOrder)                  
select t.TabId, t.TabName, t.DisplayAs, t.DefaultScreenId, t.TabOrder                  
  from Tabs t                  
 where exists(select *                  
                from @StaffBanners sb                  
               where sb.TabId = t.TabId)                  
   and isnull(t.RecordDeleted, 'N') = 'N'                  
                    
-- If there is no permission for the default screen, replace it with the first available screen                  
update st                  
   set DefaultScreenId = sb.ScreenId                  
  from @StaffTabs st                  
       join @StaffBanners sb on sb.TabId = st.TabId                  
 where not exists(select *                  
                    from @StaffBanners sb2                  
          where sb2.TabId = st.TabId                  
                     and sb2.ScreenId = st.DefaultScreenId)                  
   and not exists(select *                  
                    from @StaffBanners sb3                  
                   where sb3.TabId = st.TabId                  
                     and sb3.BannerOrder < sb.BannerOrder)                  
                    
-- Final selects                  
                                       
select  sb.BannerId,                  
       sb.BannerName,                  
       sb.DisplayAs,                  
       sb.TabId,                  
       sb.ParentBannerId,                  
       sb.BannerOrder,                  
       sb.ScreenId,                  
       sb.ScreenType,                  
       sb.Custom                  
  from @StaffBanners sb                  
 order by sb.BannerOrder                  
                    
select st.TabId, st.TabName, st.DisplayAs, st.DefaultScreenId, st.TabOrder                  
  from @StaffTabs st                  
 order by st.TabOrder, st.TabId 
GO


