/****** Object:  StoredProcedure [dbo].[ssp_PostUpdateClientInformation]    Script Date: 08/16/2017 18:47:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PostUpdateClientInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PostUpdateClientInformation]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PostUpdateClientInformation]    Script Date: 08/16/2017 18:47:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[ssp_PostUpdateClientInformation]
    @ScreenKeyId INT
   ,@StaffId INT
   ,@CurrentUser VARCHAR(30)
   ,@CustomParameters XML
AS /******************************************************************/                                              
/* Stored Procedure: dbo.ssp_PostUpdateRoleDefinition                */                                              
/* Creation Date:    12/27/2010                                      */                                              
/*                                                                   */                                              
/* Purpose:															 */                                              
/*                                                                   */                                               
/* Input Parameters:												 */                                              
/*                                                                   */                                              
/* Output Parameters:                                                */                                              
/*                                                                   */                                              
/* Return Status:                                                    */                                              
/*                                                                   */                                              
/* Called By:														 */                                              
/*                                                                   */                                              
/* Calls:                                                            */                                              
/*                                                                   */                                              
/* Data Modifications:                                               */                                              
/*                                                                   */                                              
/* Updates:                                                          */                                              
/*   Date                   Author      Purpose                      */                                               
/*  12/27/2010	            zkavhic		Created                      */
/*  8/16/2017               Hemant      Included the RecordDeleted Check for GlobalCodes table.
                                        Network180 Support Go Live #307
                                        
*/
/*********************************************************************/                                           

    BEGIN
	
        BEGIN TRY			
		
		--Following option is reqd for xml operations              
            SET ARITHABORT ON 
            DECLARE @RoleAction VARCHAR(10)		
		--set @RoleAction = @CustomParameters.value('(/Root/Parameters/@RoleAction)[1]', 'varchar(10)' )             
            SELECT  @RoleAction = T.c.query('RoleAction').value('.', 'VARCHAR(20)')
            FROM    @CustomParameters.nodes('/Root') T ( c )

            IF ( @RoleAction = 'ADDROLE' ) 
                BEGIN
	
                    INSERT  INTO PermissionTemplates
                            ( PermissionTemplateType
                            ,RoleId
                            ,CreatedBy
                            ,ModifiedBy )
                            SELECT  GlobalCodeId
                                   ,@ScreenKeyId
                                   ,@CurrentUser
                                   ,@CurrentUser
                            FROM    GlobalCodes
                            WHERE   Category = 'PERMISSIONTEMPLATETP'
                            AND IsNull(RecordDeleted, 'N') = 'N'
                            AND Active = 'Y'
		
                END
	
            ELSE 
                IF ( @RoleAction = 'DeleteRole' ) 
                    BEGIN
	
                        UPDATE  PermissionTemplateItems
                        SET     RecordDeleted = 'Y'
                               ,ModifiedBy = @CurrentUser
                               ,ModifiedDate = GETDATE()
                        WHERE   PermissionItemId IN ( SELECT    PermissionTemplateId
                                                      FROM      PermissionTemplates
                                                      WHERE     RoleId = @ScreenKeyId )
						
                        UPDATE  PermissionTemplates
                        SET     RecordDeleted = 'Y'
                               ,ModifiedBy = @CurrentUser
                               ,ModifiedDate = GETDATE()
                        WHERE   RoleId = @ScreenKeyId
		
                    END
        END TRY
        BEGIN CATCH
		
            DECLARE @Error VARCHAR(8000)                              
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PostUpdateRoleDefinition') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())	
            RAISERROR                                                                                             
		(                                                             
			@Error, -- Message text.	
			16, -- Severity.	
			1 -- State.	
		) ;   	
        END CATCH
    END

GO


