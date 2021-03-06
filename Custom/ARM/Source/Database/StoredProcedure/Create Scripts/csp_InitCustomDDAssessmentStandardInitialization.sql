/****** Object:  StoredProcedure [dbo].[csp_InitCustomDDAssessmentStandardInitialization]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDDAssessmentStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDDAssessmentStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDDAssessmentStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomDDAssessmentStandardInitialization]        
(                            
 @ClientID int,      
 @StaffID int,    
 @CustomParameters xml                            
)                                                    
As                                                      
                                                             
 /*********************************************************************/                                                                
 /* Stored Procedure: [csp_InitCustomDDAssessmentStandardInitialization]               */                                                       
                                                       
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
 /*       Nov18,2009         Ankesh                 Made changes as per database  SCWebVenture3.0 */    
 /*       May 11,2010        Mahesh Sharma          Comment the section Custom Data in proc B''cz. No need to initilize those fields*/    
 /*********************************************************************/                                                                                   
Begin                                              
    
Begin try
                          
Select TOP 1 ''CustomDDAssessment'' AS TableName, -1 as ''DocumentVersionId'',                    
                 
--Custom data     
/*           
'''' as  AssistanceMobility,              
'''' as  AssistanceMedication,              
'''' as  AssistancePersonal,              
'''' as  AssistanceHousehold,              
'''' as  AssistanceCommunity,              
--Custom Data      
*/          
                             
'''' as CreatedBy,                  
getdate() as CreatedDate,                  
'''' as ModifiedBy,                  
getdate() as ModifiedDate 
from systemconfigurations s left outer join CustomDDAssessment C                                                                       
on s.Databaseversion = -1
                                   
end try                                              
                                                                                       
BEGIN CATCH  
DECLARE @Error varchar(8000)                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                             
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomDDAssessmentStandardInitialization'')                                                                             
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
