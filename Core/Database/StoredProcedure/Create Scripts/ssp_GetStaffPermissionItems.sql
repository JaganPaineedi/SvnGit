/****** Object:  StoredProcedure [dbo].[ssp_GetStaffPermissionItems]    Script Date: 11/18/2011 16:25:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetStaffPermissionItems]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetStaffPermissionItems]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ssp_GetStaffPermissionItems]     
@StaffId int,          
@PermissionTemplateType int,          
@ParentId int = null,          
@PermissionStatus char(1) = null -- 'G' - granted, 'D' - Denied, NULL - all    
,@PermissionItemName VARCHAR(100)=''           
/********************************************************************************                                
-- Stored Procedure: dbo.ssp_GetStaffPermissionItems                                  
--                                
-- Copyright: Streamline Healthcate Solutions                                
--                                
-- Purpose: gets staff permission items for Staff Details Roles/Permissions tab                             
--                                
-- Updates:                                                                                       
-- Date        Author      Purpose                                
-- 06.23.2010  SFarber     Created.                     
-- 06.30.2010  SFarber     Added more columns from StaffPermissionExceptions to the final SELECT.          
-- 07.06.2010  SFarber     Modified to use ssp_GetPermissionItems.          
-- 07.11.2010  SFarber     Added defaults to arguments.        
-- 23.10.2012  Saurav Pande  We correct the inner join and there was no check of active with global code whether the role is active or not.    
-- 26.12.2018  Venkatesh   Added parameter PermissionItemName to get the Permission Items based on Permission Item Name. Ref Task: Engineering Improvement Initiatives- NBL(I) #449.1
*********************************************************************************/                                
as          
          
declare @Roles table (RoleId int)   
       
          
declare @PermissionItems table (          
PermissionTemplateType int,          
PermissionTemplateTypeName varchar(100),          
PermissionItemId int,          
PermissionItemName varchar(250),          
ParentId int,          
ParentName varchar(100),          
Denied char(1),          
DeniedByRole char(1),          
Granted char(1),          
GrantedByRole char(1),          
StaffPermissionExceptionId int)          
          
 --modified by Ryan         
insert into @Roles(RoleId)        
--select RoleId from StaffRoles where StaffId  = @StaffId and ISNULL(RecordDeleted,'N') <> 'Y'        
    
select RoleId from StaffRoles SR join Globalcodes GC ON GC.GlobalCodeId=SR.RoleId    
where StaffId  = @StaffId and ISNULL(SR.RecordDeleted,'N') <> 'Y' and  ISNULL(GC.RecordDeleted,'N') <> 'Y' AND ISNULL(GC.ACTIVE,'N') = 'Y'    

DECLARE @UserCode VARCHAR(100)
SELECT @UserCode=UserCode FROM Staff WHERE StaffId=@StaffId
          
-- Get all available permission items          
insert into @PermissionItems (          
       PermissionTemplateType,          
       PermissionTemplateTypeName,          
       PermissionItemId,          
       PermissionItemName,          
       ParentId,          
       ParentName)          
  exec ssp_GetPermissionItems @PermissionTemplateType = @PermissionTemplateType          
          
-- Everything is denied by default          
update @PermissionItems          
   set GrantedByRole = 'N',          
       Granted = 'N',          
       DeniedByRole = 'Y',          
       Denied = 'Y'          
                
-- Apply role permissions          
update pit          
   set GrantedByRole = 'Y',          
       Granted = 'Y',          
       DeniedByRole = 'N',          
       Denied = 'N'          
  from @PermissionItems pit          
 where exists(select *          
                from PermissionTemplates pt          
                     join @Roles r on r.RoleId = pt.RoleId          
                     join PermissionTemplateItems pti on pti.PermissionTemplateId = pt.PermissionTemplateId          
               where pt.PermissionTemplateType = pit.PermissionTemplateType          
                 and pti.PermissionItemId = pit.PermissionItemId          
                 and isnull(pt.RecordDeleted, 'N') = 'N'          
                 and isnull(pti.RecordDeleted, 'N') = 'N')          
         
-- Apply exceptions          
update pit          
   set Granted = spe.Allow,          
       Denied = case spe.Allow when 'Y' then 'N' else 'Y' end,          
       StaffPermissionExceptionId = spe.StaffPermissionExceptionId          
  from @PermissionItems pit          
       join StaffPermissionExceptions spe on spe.StaffId = @StaffId and spe.PermissionTemplateType = pit.PermissionTemplateType and spe.PermissionItemId = pit.PermissionItemId          
 where isnull(spe.RecordDeleted, 'N') = 'N'          
          
-- Final select          
select pit.PermissionTemplateType,          
       pit.PermissionTemplateTypeName,          
       pit.PermissionItemId,          
       pit.PermissionItemName,          
       pit.ParentId,          
       pit.ParentName,          
       pit.Denied,          
       pit.DeniedByRole,          
       pit.Granted,          
       pit.GrantedByRole,          
       case when pit.StaffPermissionExceptionId is null          
 then convert(int, 0 - row_number() over (order by  pit.StaffPermissionExceptionId desc))             
            else pit.StaffPermissionExceptionId           
       end as StaffPermissionExceptionId,          
       @StaffId as StaffId,          
       spe.Allow,          
       spe.StartDate,          
       spe.EndDate,          
       COALESCE(spe.RowIdentifier, NewId()) AS RowIdentifier,         
       COALESCE(spe.CreatedBy,@UserCode) AS CreatedBy,             
       COALESCE(spe.CreatedDate,GETDATE()) AS  CreatedDate,           
       COALESCE(spe.ModifiedBy,@UserCode) AS ModifiedBy,     
       COALESCE(spe.ModifiedDate, GETDATE()) AS ModifiedDate,           
       spe.RecordDeleted,          
       spe.DeletedDate,          
       spe.DeletedBy          
  from @PermissionItems pit          
       left join StaffPermissionExceptions spe on spe.StaffPermissionExceptionId = pit.StaffPermissionExceptionId          
 where   
 (@PermissionItemName='' OR @PermissionItemName=NULL  OR (pit.PermissionItemName like '%'+@PermissionItemName+'%' or pit.PermissionItemName like '%'+@PermissionItemName+'%'))    and   
 (pit.PermissionTemplateType = @PermissionTemplateType or @PermissionTemplateType is null)          
   and (pit.ParentId = @ParentId or @ParentId is null)          
   and ((pit.Granted = 'Y' and @PermissionStatus = 'G') or (pit.Denied = 'Y' and @PermissionStatus = 'D') or @PermissionStatus is null)          
 order by pit.PermissionTemplateTypeName, pit.ParentName, pit.PermissionItemName    
    