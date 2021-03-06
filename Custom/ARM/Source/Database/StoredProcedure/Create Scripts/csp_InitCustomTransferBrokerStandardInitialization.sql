/****** Object:  StoredProcedure [dbo].[csp_InitCustomTransferBrokerStandardInitialization]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomTransferBrokerStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomTransferBrokerStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomTransferBrokerStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomTransferBrokerStandardInitialization]      
(                                
 @ClientID int,        
 @StaffID int,      
 @CustomParameters xml                                
)                                                        
As        
                                                        
Begin                                                                  
 /*********************************************************************/                                                                    
 /* Stored Procedure: [csp_InitCustomTransferBrokerStandardInitialization]               */                                                           
                                                           
 /* Copyright: 2009 Streamline SmartCareWeb*/                                                                    
                                                           
 /* Creation Date:  8/Oct/2009                                    */                                                                    
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
 /*       8/Oct/2009       Umesh Sharma           To Retrieve Data      */                                                                    
 /*********************************************************************/                                                                     
  BEGIN TRY                                                                             
      
                                    
Select TOP 1 ''CustomTransferBroker'' AS TableName, -1 as ''DocumentVersionId''                      
--Custom data                    
      ,[DocumentType]      
      ,[DateOfRequest]      
      ,[CurrentProgram]      
      ,[ProgramRequested]      
      ,[ServiceRequested]      
      ,[RequestedClinician]      
      ,[VerballyAcceptedDate]      
      ,[Rationale]      
      ,[Findings]      
      ,[NoticeDeliveredDate]      
      ,[NotifyStaff1]      
      ,[NotifyStaff2]      
      ,[NotifyStaff3]      
      ,[NotifyStaff4]      
      ,[NotificationMessage]      
      ,[NotificationSent],        
--Custom Data                    
'''' as CreatedBy,                      
getdate() as CreatedDate,                      
'''' as ModifiedBy,                      
getdate() as ModifiedDate                        
from systemconfigurations s left outer join CustomTransferBroker        
on s.Databaseversion = -1        
                         
                              
                                        
         
 END TRY                        
 BEGIN CATCH                              
  DECLARE @Error varchar(8000)                                                                 
  set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                
  + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[csp_InitCustomTransferBrokerStandardInitialization]'')                                                                 
  + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                                
  + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                                
  RAISERROR                                                                 
  (                           
  @Error, -- Message text.                                                                 
  16, -- Severity.                                                                 
  1 -- State.                                                                 
  )                              
 END CATCH                           
                            
End
' 
END
GO
