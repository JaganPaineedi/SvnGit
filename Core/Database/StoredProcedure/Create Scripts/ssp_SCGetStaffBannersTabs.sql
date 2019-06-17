SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
if object_id('[ssp_SCGetStaffBannersTabs]', 'P') is not null
	drop procedure [dbo].[ssp_SCGetStaffBannersTabs] 
go

create procedure [dbo].[ssp_SCGetStaffBannersTabs]
@LoggedInStaffId int,
@StaffId int = null
/********************************************************************************
-- Stored Procedure: dbo.ssp_SCGetStaffBannersTabs 550
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
-- 03.02.2012  T. Remisoski Use new ClientPagePreference value to determine default screen-id when client selected.
-- 05.06.2012  MSuma		Use HomePageScreenId for Default Tab Navigation(MyOffice)
-- 07/03/2013  Shruthi.S    There were duplicate records in PermissionTemplateItems tables for all the staffs.So,pulled distinct records from ViewStaffRoleSupervisorPermissions. Ref #529 St.Joe-Support.
-- 04.09.2015  Khusro		Changed parameter from @LoggedInStaffId to @StaffId to filter records based on selected staff for Supervisor view w.r.t Core Bugs #1739
-- 06.23.2015  Chethan N	What : Changes made to get Banners associated to Document Code(Document Code with both 'Edit' and 'View' permission)
--							Why : Macon Desing task#60
-- 01.07.2015  Venkatesh	If screenid is null in @StaffBanners set it the screenid to 17 before updating the DefaultScreenId in @StaffTabs
-- 12.03.2015  Vijay        Commented Logic to show Client Page Prefrence Screen in Client search. Why:  task #443 MFS - Customization Issue Tracking
-- 12.30.2015  Chethan N    What : Default to Summary Page as Client Preference Screen for Non Staff User if not set.
--							Why : Engineering Improvement Initiatives- NBL(I) Task# 279
-- 3-11-2016   Arjun K R    What : Added ScreenParameters column into banner select statement.
--                          Why : AspenPointe-Customizations Task #447.
-- 24-Mar-2018 Kkumar		Why : ScreenCode is added to Banners
*********************************************************************************/
as

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
ScreenParameters varchar(max),--3-11-2016   Arjun K R
ScreenCode varchar(100)
) 

declare @StaffTabs table(
TabId           int,
TabName         varchar(30),
DisplayAs       varchar(30),
DefaultScreenId int,
TabOrder        int)

set @StaffId = isnull(@StaffId, @LoggedInStaffId)

-- Get all permitted banners
-- If @LoggedInStaffId <> @StaffId, then Supervisor view
if @LoggedInStaffId = @StaffId
begin
  insert into @PermittedBanners (BannerId)
  select vsp.PermissionItemId
    from ViewStaffPermissions vsp
   where vsp.StaffId = @LoggedInStaffId
     and vsp.PermissionTemplateType = 5703
end
else
begin
  insert into @PermittedBanners (BannerId)
  select distinct(vsp.PermissionItemId)
    from ViewStaffRoleSupervisorPermissions vsp
   where vsp.StaffId = @StaffId      -- Changed on 04.09.2015 by Khusro
     and vsp.PermissionTemplateType = 5703
end

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
       ScreenParameters,--3-11-2016   Arjun K R
	   ScreenCode)  
select b.BannerId,
       b.BannerName,
       b.DisplayAs,
       b.TabId,
       b.ParentBannerId,
       b.ScreenId,
       s.ScreenType,
       b.Custom,
       b.ScreenParameters,--3-11-2016   Arjun K R
	   s.code
  from Banners as b
       join @PermittedBanners pb on pb.BannerId = b.BannerId
       left join Screens s on s.ScreenId = b.ScreenId
       left join DocumentCodes dc on dc.DocumentCodeId = s.DocumentCodeId
     --left join ViewStaffPermissions pd on pd.StaffId = @StaffId and pd.PermissionItemId = dc.DocumentCodeId  and pd.PermissionTemplateType = 5702
      where b.Active = 'Y'
   and (dc.Active = 'Y' or dc.DocumentCodeId is null)
   and isnull(b.RecordDeleted, 'N') = 'N'
   and 
   (dc.DocumentCodeId is null 
    -- Chethan N Changes -- Included Document Code (View) TemplateId
   or exists(SELECT 1 FROM ViewStaffPermissions pd where pd.StaffId = @StaffId and pd.PermissionItemId = dc.DocumentCodeId 
   AND pd.PermissionTemplateType IN (5702, 5924) AND  pd.PermissionItemId is not null)) -- 5702- Document Codes (Edit) , 5924 - Document Codes (View)
  
 order by b.TabId,
          b.ParentBannerId,
          b.DefaultOrder,
          DisplayAs


-- Tabs
-- Use new "ClientPagePreferenceScreenId"
insert into @StaffTabs (TabId, TabName, DisplayAs, DefaultScreenId, TabOrder)
--select t.TabId, t.TabName, t.DisplayAs, ISNULL(st.ClientPagePreferenceScreenId, t.DefaultScreenId), t.TabOrder
--  from Tabs t
--  cross join dbo.Staff as st
-- where st.StaffId = @StaffId
-- and exists(select *
--                from @StaffBanners sb
--               where sb.TabId = t.TabId)
--   and isnull(t.RecordDeleted, 'N') = 'N'

select t.TabId, t.TabName, t.DisplayAs,
CASE WHEN t.TabId = 1
		THEN
		 ISNULL(st.HomePageScreenId, t.DefaultScreenId)
	 WHEN t.TabId = 2 THEN CASE WHEN ISNULL(NonStaffUser, 'N')='Y' THEN  ISNULL(st.ClientPagePreferenceScreenId, 977) ELSE  
   ISNULL(st.ClientPagePreferenceScreenId, t.DefaultScreenId)  END  
	 ELSE
		 t.DefaultScreenId
     END 
		  , t.TabOrder
  from Tabs t
  cross join dbo.Staff as st
 where st.StaffId = @StaffId
 and exists(select *
                from @StaffBanners sb
               where sb.TabId = t.TabId)
   and isnull(t.RecordDeleted, 'N') = 'N'

-- If there is no permission for the default screen, replace it with the first available screen
update st
   set DefaultScreenId = coalesce(sb.ScreenId, 17) -- Added by Venkatesh, if ScreenId is null update with default screen id
  from @StaffTabs st
       join @StaffBanners sb on sb.TabId = st.TabId        
 where not exists(select *
                    from @StaffBanners sb2
          where sb2.TabId = st.TabId
          --12.03.2015  Vijay  
                     and sb2.ScreenId = st.DefaultScreenId) -- and sb2.BannerId not in(Select distinct ParentBannerId FROM Banners where ParentBannerId IS NOt NULL))
   and not exists(select *
                    from @StaffBanners sb3
                   where sb3.TabId = st.TabId
                     and sb3.BannerOrder < sb.BannerOrder)


-- Final selects

select sb.BannerId,
       sb.BannerName,
       sb.DisplayAs,
       sb.TabId,
       sb.ParentBannerId,
       sb.BannerOrder,
       sb.ScreenId,
       sb.ScreenType,
       sb.Custom,
       sb.ScreenParameters, --3-11-2016   Arjun K R
       ScreenCode
  from @StaffBanners sb
 order by sb.BannerOrder

select st.TabId, st.TabName, st.DisplayAs, st.DefaultScreenId, st.TabOrder
  from @StaffTabs st
 order by st.TabOrder, st.TabId
GO
