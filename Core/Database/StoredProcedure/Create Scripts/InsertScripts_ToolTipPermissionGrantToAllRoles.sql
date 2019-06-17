/********************************************************************************                              
-- Script : InsertScripts_ToolTipPermissionGrantToAllRoles                               
--                              
-- Copyright: Streamline Healthcate Solutions                              
--                              
-- Purpose: grants Tool Tip access to all roles    
                    
-- Updates:                                                                                     
-- Date        Author      Purpose                              
-- 14.02.2018  RK     Created.  
	What: Client Hover: Enhancements being requested
	Why: MHP-Customizations - Task 121       
*********************************************************************************/                              
declare @PermissionTemplateType int
declare @UserCode varchar(30)

Set @PermissionTemplateType = 5930        
Set @UserCode =  suser_sname()    
        
declare @ErrorId int        
declare @ErrorMessage nvarchar(max)         
declare @PermissionItems table (        
PermissionTemplateType int,        
PermissionTemplateTypeName varchar(100),        
PermissionItemId int,        
PermissionItemName varchar(250),        
ParentId int,        
ParentName varchar(100),        
Denied char(1),        
Granted char(1),        
PermissionTemplateItemId int)        
        
-- Get all available permission items        
insert into @PermissionItems (        
       PermissionTemplateType,        
       PermissionTemplateTypeName,        
       PermissionItemId,        
       PermissionItemName,        
       ParentId,        
       ParentName)        
  exec ssp_GetPermissionItems @PermissionTemplateType = @PermissionTemplateType        
        
-- Insert templates        
insert into PermissionTemplates (        
       RoleId,        
       PermissionTemplateType,        
       --IncludeAll,        
       CreatedBy,        
       CreatedDate,        
       ModifiedBy,        
       ModifiedDate)   
  
    select          
       GlobalCodeId,        
       @PermissionTemplateType,        
       --'N',        
       @UserCode,        
       getdate(),        
       @UserCode,        
       getdate()        
  from  GlobalCodes GC where GC.Category = 'STAFFROLE' AND ISNULL(GC.RecordDeleted, 'N') = 'N'  and GC.Active='Y' 
  AND not exists(select *        
                    from PermissionTemplates pt        
                   where pt.RoleId = GC.GlobalCodeId        
                     and pt.PermissionTemplateType = @PermissionTemplateType        
                     and isnull(pt.RecordDeleted, 'N') = 'N')  
                           
-- Insert template items          
insert into PermissionTemplateItems (        
       PermissionTemplateId,        
       PermissionItemId,        
       CreatedBy,        
       CreatedDate,        
       ModifiedBy,        
       ModifiedDate)        
select pt.PermissionTemplateId,        
       pti.PermissionItemId,        
       @UserCode,        
       getdate(),        
       @UserCode,        
       getdate()        
  from @PermissionItems pti   
       join PermissionTemplates pt on pt.PermissionTemplateType = pti.PermissionTemplateType 
       inner join GlobalCodes GC on GC.GlobalCodeId = pt.RoleId  
      
 where isnull(pt.RecordDeleted, 'N') = 'N' AND  GC.Category = 'STAFFROLE' AND ISNULL( GC.RecordDeleted, 'N') = 'N'  and  GC.Active='Y'      
   and not exists(select *        
                    from PermissionTemplateItems pti2         
                         join PermissionTemplates pt2 on pt2.PermissionTemplateId = pti2.PermissionTemplateId        
                   where pt2.RoleId = pt.RoleId         
                     and pt2.PermissionTemplateType = pt.PermissionTemplateType        
      and pti2.PermissionItemId = pti.PermissionItemId        
                     and isnull(pti2.RecordDeleted, 'N') = 'N'        
                     and isnull(pt2.RecordDeleted, 'N') = 'N')        
        

