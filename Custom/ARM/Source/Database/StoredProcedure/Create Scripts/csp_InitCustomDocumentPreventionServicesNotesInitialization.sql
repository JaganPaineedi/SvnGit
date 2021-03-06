/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentPreventionServicesNotesInitialization]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentPreventionServicesNotesInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDocumentPreventionServicesNotesInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentPreventionServicesNotesInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomDocumentPreventionServicesNotesInitialization]              
(                                  
 @ClientID int,            
 @StaffID int,          
 @CustomParameters xml                                  
)                                                          
As                                                            
                                                                   
 /*********************************************************************/                                                                      
 /* Stored Procedure: [csp_InitCustomDocumentPreventionServicesNotesInitialization]              */                                                             
                                                             
 /* Copyright: 2011 Streamline SmartCare*/                                                                      
                                                             
 /* Creation Date:  29/Apr/2011                                    */                                                                      
 /*                                                                   */                                                                      
 /* Purpose: To Initialize */                                                                     
 /*                                                                   */                                                                    
 /* Input Parameters:  */                                                                    
 /*                                                                   */                                                                       
 /* Output Parameters:                                */                                                                      
 /*                                                                   */                                                                      
 /* Return:   */                                                                      
 /*                                                                   */                                                                      
 /* Called By:   */                                                            
 /*      */                                                            
                                                             
 /*                                                                   */                                                                      
 /* Calls:                                                            */                                                                      
 /*                                                                   */                                                                      
 /* Data Modifications:                                               */                                                                      
 /*                                                                   */                                                                      
 /*   Updates:                                                          */                                                                      
                                                             
 /*       Date              Author                  Purpose                                    */                                                                      
 /*       29/Apr/2011       Pradeep A    To Retrieve Data      */          
     
 /*********************************************************************/                                                                                         
Begin                                                    
          
Begin try      
                                
Select TOP 1 ''CustomDocumentPreventionServicesNotes'' AS TableName, -1 as ''DocumentVersionId'',                          
         
      
                                   
'''' as CreatedBy,                        
getdate() as CreatedDate,                        
'''' as ModifiedBy,                        
getdate() as ModifiedDate       
from systemconfigurations s left outer join CustomDocumentPreventionServicesNotes C                                                                             
on s.Databaseversion = -1      
                                         
end try                                                    
                                                                                             
BEGIN CATCH        
DECLARE @Error varchar(8000)                                                     
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                   
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomDocumentPreventionServicesNotesInitialization'')                                                                                   
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                    
    + ''*****'' + Convert(varchar,ERROR_STATE())                                
 RAISERROR                                                                                   
 (                                                     
  @Error, -- Message text.                                                                                  
  16, -- Severity.                                                                                  
  1 -- State.                                                                                  
 );                                                                                
END CATCH                               
END      ' 
END
GO
