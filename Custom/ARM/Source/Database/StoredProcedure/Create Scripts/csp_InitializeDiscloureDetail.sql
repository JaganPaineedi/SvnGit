/****** Object:  StoredProcedure [dbo].[csp_InitializeDiscloureDetail]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitializeDiscloureDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitializeDiscloureDetail]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitializeDiscloureDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitializeDiscloureDetail]               
(                                  
 @StaffId int,            
 @ClientID int,            
 @CustomParameters xml                                  
)                                                          
As                                                            
                              
                                                                   
 Begin                                                                    
 /*********************************************************************/                                                                      
 /* Stored Procedure: [csp_InitBasis32StandardInitialization]               */                                                             
                                                             
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
 /*********************************************************************/                                                                       
                                    
               
               
    SELECT             
    ''ClientDisclosures'' as TableName            
     ,-1 as [ClientDisclosureId]            
      ,@ClientID as [ClientId]            
      ,[DisclosureDate]           
      ,@StaffId as [DisclosedBy]             
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
                              
RAISERROR 20006 ''[csp_InitializeDiscloureDetail] : An Error Occured''                               
                              
Return                               
                              
End
' 
END
GO
