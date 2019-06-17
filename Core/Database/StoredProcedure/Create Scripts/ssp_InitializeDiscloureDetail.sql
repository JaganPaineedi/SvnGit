IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitializeDiscloureDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitializeDiscloureDetail]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[ssp_InitializeDiscloureDetail]                   
(                                      
 @StaffId int,                
 @ClientID int,                
 @CustomParameters xml                                      
)                                                              
As                                                                
                                  
                                                                       
 Begin                                                                        
 /*********************************************************************/                                                                          
 /* Stored Procedure: [ssp_InitializeDiscloureDetail]               */                                                                 
                                                                 
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
/*        08/Jan/2013        samrat                Added OrganizationId to Retrieve Data      */                                                                          
/*        08/Aug/2013       Aravind                Added the column DisclosureRequestType #42,SummitPointe 3.5x */
/*        9/19/2015         Hemant                 Added columns RequestFromIdSource,DisclosedToIdSource Philhaven-Support #7
*/                            
 /*********************************************************************/                         
                                        
                   
                   
    SELECT                 
    'ClientDisclosures' as TableName                
     ,-1 as [ClientDisclosureId]                
      ,@ClientID as [ClientId]                
      ,[DisclosureDate]               
      ,@StaffId as [DisclosedBy]                 
      ,[DisclosureRequestType]   
      ,[DisclosureType]                
      ,[DisclosureTypeDescription]                
      ,[Comments]                
      ,[ClientInformationReleaseId]                
      ,[DisclosedToId]                
 ,[DisclosedToName]                
      --,[RowIdentifier]                
      ,[ClientDisclosures].[CreatedBy]                
      ,[ClientDisclosures].[CreatedDate]                
      ,[ClientDisclosures].[ModifiedBy]                
      ,[ClientDisclosures].[ModifiedDate]                
      ,[RecordDeleted]                
      ,[DeletedDate]                
      ,[DeletedBy]    
      ,[DisclosedToDeliveryType]
      --Added by samrat against Task #114 InteractDevelopmentImplementation
      ,[DEOrganizationId] 
      ,RequestFromIdSource
      ,DisclosedToIdSource               
from systemconfigurations s left outer join [ClientDisclosures]                
on s.Databaseversion = -1                
    
---Reports    
    
    
Declare @DisclosureCoverLetterReportFolderId as int    
    
---------------------------------------------------------------    
--statement to be removed when DisclosureCoverLetterReportFolderId appears    
set  @DisclosureCoverLetterReportFolderId=88    
---------------------------------------------------------------    
    
---------------------------------------------------------------    
--to be uncommented when column DisclosureCoverLetterReportFolderId appears    
--select @DisclosureCoverLetterReportFolderId= DisclosureCoverLetterReportFolderId from SystemConfigurations     
---------------------------------------------------------------    
select ReportId,Name, [Description],IsFolder,AssociatedWith,ReportServerId,ReportServerPath,ParentFolderId from Reports where ParentFolderId=@DisclosureCoverLetterReportFolderId     
and AssociatedWith=5819    
                            
END                                        
                                          
--Checking For Errors                                   
                                  
If (@@error!=0)                                   
                                  
Begin                                   
                                  
RAISERROR 20006 '[ssp_InitializeDiscloureDetail] : An Error Occured'                                   
                                  
Return                                   
                                  
End 

