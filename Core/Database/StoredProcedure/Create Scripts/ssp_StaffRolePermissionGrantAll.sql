IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_StaffRolePermissionGrantAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_StaffRolePermissionGrantAll]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_StaffRolePermissionGrantAll] --19817,5701,'JSCOBY'
@RoleId int,    
@PermissionTemplateType int = null,    
@UserCode varchar(30)    
/********************************************************************************                          
-- Stored Procedure: dbo.ssp_StaffRolePermissionGrantAll                            
--                          
-- Copyright: Streamline Healthcate Solutions                          
--                          
-- Purpose: grants complete access to a role                    
--                          
-- Updates:                                                                                 
-- Date        Author      Purpose                          
-- 07.06.2010  SFarber     Created.     
-- 13.07.2010  Shifali     Modified(Added IncludeAll field in insertion of PermissionTemplates(as its non-null)  
-- 10.30.2018  Gautam      Modified the RAISERROR syntax as per 2014 syntax,Task #115 in Renaissance - Current Project Tasks             
*********************************************************************************/                          
as    
    
declare @ErrorNumber int    
--Added by vishant to implement message code functionality   
--declare @ErrorMessage varchar(100)    
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
select distinct     
       @RoleId,    
       pti.PermissionTemplateType,    
       --'N',    
       @UserCode,    
       getdate(),    
       @UserCode,    
       getdate()    
  from @PermissionItems pti    
 where not exists(select *    
                    from PermissionTemplates pt    
                   where pt.RoleId = @RoleId    
                     and pt.PermissionTemplateType = pti.PermissionTemplateType    
                     and isnull(pt.RecordDeleted, 'N') = 'N')    
    
if @@error <> 0    
begin    
--Added by vishant to implement message code functionality
select  @ErrorNumber = 50010,
        @ErrorMessage = dbo.Ssf_GetMesageByMessageCode(29,'FAILINSERTPERMTEMPLATES_SSP','Failed to insert into PermissionTemplates')  
    goto error 
end    
                       
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
       join PermissionTemplates pt on pt.RoleId = @RoleId and pt.PermissionTemplateType = pti.PermissionTemplateType    
 where isnull(pt.RecordDeleted, 'N') = 'N'    
   and not exists(select *    
                    from PermissionTemplateItems pti2     
                         join PermissionTemplates pt2 on pt2.PermissionTemplateId = pti2.PermissionTemplateId    
                   where pt2.RoleId = pt.RoleId     
                     and pt2.PermissionTemplateType = pt.PermissionTemplateType    
      and pti2.PermissionItemId = pti.PermissionItemId    
                     and isnull(pti2.RecordDeleted, 'N') = 'N'    
                     and isnull(pt2.RecordDeleted, 'N') = 'N')    
    
if @@error <> 0    
begin    
--Added by vishant to implement message code functionality 
 select  @ErrorNumber = 50020,
        @ErrorMessage = dbo.Ssf_GetMesageByMessageCode(29,'FAILINSERTPERMTEMPLATES_SSP','Failed to insert into PermissionTemplates')       
    goto error 
end      


EXEC [ssp_StaffRolePermissionRxGrantAll] @RoleId,@PermissionTemplateType,@UserCode,'GrantAll'    
    
return    
    
error:    
    
set @ErrorMessage = @ErrorMessage + ', Error Number: %d'
RAISERROR(@ErrorMessage, 16, 1, @ErrorNumber )  
GO


