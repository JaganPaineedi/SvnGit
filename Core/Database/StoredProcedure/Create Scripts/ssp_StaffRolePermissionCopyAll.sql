IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_StaffRolePermissionCopyAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_StaffRolePermissionCopyAll]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_StaffRolePermissionCopyAll]
    @RoleIdTo INT ,
    @RoleIdFrom INT ,
    @PermissionTemplateType INT = NULL ,
    @UserCode VARCHAR(30)  
/********************************************************************************                        
-- Stored Procedure: dbo.ssp_StaffRolePermissionCopyAll                          
--                        
-- Copyright: Streamline Healthcate Solutions                        
--                        
-- Purpose: copy permissions from one role to another  
--                        
-- Updates:                                                                               
-- Date        Author      Purpose                        
-- 07.06.2010  SFarber     Created.             
-- 02.25.2016  NJain	   Added new logic to copy permissions to remove duplication of data
-- 10.30.2018  Gautam      Modified the RAISERROR syntax as per 2014 syntax,Task #115 in Renaissance - Current Project Tasks             
*********************************************************************************/
AS
    DECLARE @ErrorNumber INT  
--Added by vishant to implement message code functionality  
--declare @ErrorMessage varchar(100)
    DECLARE @ErrorMessage NVARCHAR(MAX)    
    
    CREATE TABLE #newPermissionTemplates
        (
          PermissionTemplateId INT ,
          PermissionTemplateType INT
        )
  
	
	--
    
    INSERT  INTO PermissionTemplates
            ( RoleId ,
              PermissionTemplateType
            )
    OUTPUT  INSERTED.PermissionTemplateId ,
            INSERTED.PermissionTemplateType
            INTO #newPermissionTemplates ( PermissionTemplateId, PermissionTemplateType )
            SELECT DISTINCT
                    @RoleIdTo ,
                    a.PermissionTemplateType
            FROM    PermissionTemplates a
            WHERE   a.RoleId = @RoleIdFrom
                    AND ISNULL(a.RecordDeleted, 'N') = 'N'
	

  
    IF @@error <> 0
        BEGIN  
--Added by vishant to implement message code functionality
            SELECT  @ErrorNumber = 50010 ,
                    @ErrorMessage = dbo.Ssf_GetMesageByMessageCode(29, 'FAILINSERTPERMTEMPLATES_SSP', 'Failed to insert into PermissionTemplates')
            GOTO error  
        END  
                     
                     
--
;
    WITH    RolePermissionItemsToBeCopied
              AS ( SELECT DISTINCT
                            b.PermissionItemId ,
                            a.PermissionTemplateType
                   FROM     PermissionTemplates a
                            JOIN PermissionTemplateItems b ON a.PermissionTemplateId = b.PermissionTemplateId
                   WHERE    a.RoleId = @RoleIdFrom
                            AND ISNULL(a.RecordDeleted, 'N') = 'N'
                            AND ISNULL(b.RecordDeleted, 'N') = 'N'
                 )
        INSERT  INTO PermissionTemplateItems
                ( PermissionTemplateId ,
                  PermissionItemId
                )
                SELECT  a.PermissionTemplateId ,
                        b.PermissionItemId
                FROM    #newPermissionTemplates a
                        JOIN RolePermissionItemsToBeCopied b ON b.PermissionTemplateType = a.PermissionTemplateType


    DROP TABLE #newPermissionTemplates

  
    IF @@error <> 0
        BEGIN  
--Added by vishant to implement message code functionality
            SELECT  @ErrorNumber = 50020 ,
                    @ErrorMessage = dbo.Ssf_GetMesageByMessageCode(29, 'FAILINSERTPERMITEMS_SSP', 'Failed to insert into PermissionTemplateItems')
            GOTO error  
        END  
  
	EXEC ssp_StaffRolePermissionRxCopy @RoleIdTo,@RoleIdFrom,@PermissionTemplateType,@UserCode 

    RETURN  
  
    error:  
  
set @ErrorMessage = @ErrorMessage + ', Error Number: %d'
RAISERROR(@ErrorMessage, 16, 1, @ErrorNumber )  
GO



