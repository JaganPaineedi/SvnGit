/****** Object:  StoredProcedure [dbo].[csp_InitializeOrganizationLevels]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitializeOrganizationLevels]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitializeOrganizationLevels]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitializeOrganizationLevels]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

create PROCEDURE  [dbo].[csp_InitializeOrganizationLevels]                 
(                                    
 @StaffId int,              
 @ClientID int,              
 @CustomParameters xml                                    
)                                                            
As                                                                   
 Begin                                                                      
 /*********************************************************************/                                                                        
 /* Stored Procedure: [csp_InitializeOrganizationLevels]               */                                                               
 /* Creation Date:  07/Oct/2011                                   */                                                                        
 /*                                                                   */                                                                        
 /* Purpose: To Initialize */                                                                       
 /*                                                                   */                                                                      
 /* Input Parameters:  */                                                                      
 /*                                                                   */                                                                         
 /* Output Parameters:                                */                                                                        
 /*                                                                   */                                                                        
 /* Return:   */                                                                        
 /*                                                                   */                                                                        
 /* Called By:Immunization Deatails    */                                                              
 /*                                                                   */                                                                        
 /* Calls:                                                            */                                                                        
 /*                                                                   */                                                                        
 /* Data Modifications:                                               */                                                                        
 /*                                                                   */                                                                        
 /*   Updates:                                                          */                                                                        
 /*       Date              Author                  Purpose                                    */                                                                        
 /*       07/Oct/2011       Jagdeep             To Retrieve Data      */                                                                        
 /*********************************************************************/                                                                         
                                      
  SELECT Placeholder.TableName, ISNULL(OL.OrganizationLevelId,-1) AS OrganizationLevelId   
      ,OL.[CreatedBy]
      ,OL.[CreatedDate]
      ,OL.[ModifiedBy]
      ,OL.[ModifiedDate]
      ,OL.[RecordDeleted]
      ,OL.[DeletedDate]
      ,OL.[DeletedBy]
      ,OL.[LevelName]
      ,OL.[LevelTypeId]
      ,OL.[ProgramId]
      ,OL.[ParentLevelId]
      ,OL.[ManagerId]
  FROM (SELECT ''OrganizationLevels'' AS TableName) AS Placeholder  
  LEFT JOIN OrganizationLevels OL ON ( OL.OrganizationLevelId = -1  
  AND ISNULL(OL.RecordDeleted,''N'') <> ''Y'' )                   
                            
END                                      
                                        
--Checking For Errors                                 
                                
If (@@error!=0)                                 
                                
Begin                                 
                                
RAISERROR 20006 ''[csp_InitializeOrganizationLevels] : An Error Occured''                                 
                                
Return                                 
                                
End 
' 
END
GO
