IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_StaffRolePermissionRemoveAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_StaffRolePermissionRemoveAll]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--if object_id('dbo.ssp_StaffRolePermissionRemoveAll') is not null  
--  drop procedure dbo.ssp_StaffRolePermissionRemoveAll  
--go                                  
  
CREATE PROCEDURE [dbo].[ssp_StaffRolePermissionRemoveAll] 
@RoleId int,  
@PermissionTemplateType int = null,  
@UserCode varchar(30)  
/********************************************************************************                        
-- Stored Procedure: dbo.ssp_StaffRolePermissionRemoveAll                          
--                        
-- Copyright: Streamline Healthcate Solutions                        
--                        
-- Purpose: removes all permissions from a role                  
--                        
-- Updates:                                                                               
-- Date        Author      Purpose                        
-- 07.06.2010  SFarber     Created.  
-- 10.30.2018  Gautam      Modified the RAISERROR syntax as per 2014 syntax,Task #115 in Renaissance - Current Project Tasks
*********************************************************************************/                        
as  
  
declare @ErrorNumber int  
--Added by vishant to implement message code functionality   
--declare @ErrorMessage varchar(100)  
  declare @ErrorMessage nvarchar(max)    
-- Delete template items  
delete pti  
  from PermissionTemplateItems pti  
       join PermissionTemplates pt on pt.PermissionTemplateId = pti.PermissionTemplateId  
 where pt.RoleId = @RoleId  
   --and (pt.PermissionTemplateType = @PermissionTemplateType or @PermissionTemplateType is null)  
   and (pt.PermissionTemplateType = @PermissionTemplateType or @PermissionTemplateType is null)  
   and isnull(pti.RecordDeleted, 'N') = 'N'  
   and isnull(pt.RecordDeleted, 'N') = 'N'  
  
if @@error <> 0  
begin  
	select  @ErrorNumber = 50010,
            @ErrorMessage = dbo.Ssf_GetMesageByMessageCode(29,'FAILDELETEPERMITEMS_SSP','Failed to delete from PermissionTemplateItems')
    goto error
end 
         
-- Delete templates  
delete pt  
  from PermissionTemplates pt  
 where pt.RoleId = @RoleId  
   --and (pt.PermissionTemplateType = @PermissionTemplateType or @PermissionTemplateType is null)  
   and (pt.PermissionTemplateType = @PermissionTemplateType or @PermissionTemplateType is null)  
   and isnull(pt.RecordDeleted, 'N') = 'N'  
  
if @@error <> 0  
begin  
	--Added by Vishant Garg to implement message code functionality
	select  @ErrorNumber = 50020,
            @ErrorMessage = dbo.Ssf_GetMesageByMessageCode(29,'FAILDELETEPERMTEMPLATES_SSP','Failed to delete from PermissionTemplates')
    goto error 
end

EXEC [ssp_StaffRolePermissionRxGrantAll] @RoleId,@PermissionTemplateType,@UserCode,'RemoveAll'  
  
return  
  
error:  
set @ErrorMessage = @ErrorMessage + ', Error Number: %d'
RAISERROR(@ErrorMessage, 16, 1, @ErrorNumber )  
GO


