/****** Object:  StoredProcedure [dbo].[csp_InitCustomPersonalCareAssessmentStandardInitialization]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomPersonalCareAssessmentStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomPersonalCareAssessmentStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomPersonalCareAssessmentStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomPersonalCareAssessmentStandardInitialization]        
(                        
 @ClientID int,    
 @StaffID int,  
 @CustomParameters xml                        
)                                                
As  
                                                    
 /*********************************************************************/                                                          
 /* Stored Procedure: [csp_InitCustomPersonalCareAssessmentStandardInitialization]               */                                                 
                                                 
 /* Copyright: 2006 Streamline SmartCare*/                                                          
                                                 
 /* Creation Date:  14/Jan/2008                                    */                                                          
 /*                                                                   */                                                          
 /* Purpose: To Initialize */                                                         
 /*                                                                   */                                                        
 /* Input Parameters:  */                                                        
 /*                                                                   */                                                           
 /* Output Parameters:                                */                                                          
 /*                                                                   */                                                          
 /* Return:   */                                                          
 /*                                                                   */                                                          
 /* Called By:CustomDocuments Class Of DataService    */                                                
 /*      */                                                
                                                 
 /*                                                                   */                                                          
 /* Calls:                                                            */                                                          
 /*                                                                   */                                                          
 /* Data Modifications:                                               */                                                          
 /*                                                                   */                                                          
 /*   Updates:                                                          */                                                          
                                                 
 /*       Date              Author                  Purpose                                    */                                                          
 /*       14/Jan/2008        Rishu Chopra          To Retrieve Data      */   
 /*       18/Nov/2009        Ankesh Bharti     Modify according to DataModel 3.0*/                                                      
 /*********************************************************************/ 
                                                                          
Begin                                              
    
Begin try                                                                            
                            
Select TOP 1 ''CustomPersonalCareAssessment'' AS TableName, -1 as ''DocumentVersionId'',          
  
--Custom data            
 getdate() as DateOfNotice,          
--Custom Data            
                         
'''' as CreatedBy,              
getdate() as CreatedDate,              
'''' as ModifiedBy,              
getdate() as ModifiedDate                
from systemconfigurations s left outer join CustomPersonalCareAssessment                                                                  
on s.Databaseversion = -1  
                  
                         
end try                                              
                                                                                       
BEGIN CATCH  
DECLARE @Error varchar(8000)                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                             
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomPersonalCareAssessmentStandardInitialization'')                                                                             
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                              
    + ''*****'' + Convert(varchar,ERROR_STATE())                          
 RAISERROR                                                                             
 (                                               
  @Error, -- Message text.                                                                            
  16, -- Severity.                                                                            
  1 -- State.                                                                            
 );                                                                          
END CATCH                         
END
' 
END
GO
