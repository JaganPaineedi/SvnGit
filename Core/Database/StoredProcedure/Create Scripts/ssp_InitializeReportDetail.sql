IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitializeReportDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitializeReportDetail]
GO
Create PROCEDURE  [dbo].[ssp_InitializeReportDetail]         
(                                
 @StaffId int,          
 @ClientID int,          
 @CustomParameters xml                                
)                                                        
As                                                              
Begin                                                                  
 /*********************************************************************/          
 /* Stored Procedure: [ssp_InitializeReportDetail]                    */ 
 /* Creation Date	: 28th April 2016                                 */
 /* Creation By		: Manjunath Kondikoppa							  */ 
 /*	Purpose			: Initialization StoredProcedure for Report Detail Page. Ref. Core Bugs 2056 */
 /* Date              Author                  Purpose                 */
 /* 22-Nov-2016     Arjun KR         To Add a Column "AddAsBanner" to select statement. Task #447 AspenPointe Customizations. */
 /*********************************************************************/ 
    SELECT 'Reports' as TableName,      
       -1 as [ReportId]      
      ,'' as[Name]      
      ,[Description]      
      ,'N' as [IsFolder]      
      ,[ParentFolderId]      
      ,[AssociatedWith]      
      ,[ReportServerId]      
      ,[ReportServerPath]      
      ,[RowIdentifier]      
      ,Reports.[CreatedBy]      
      ,Reports.[CreatedDate]      
      ,Reports.[ModifiedBy]      
      ,Reports.[ModifiedDate]      
      ,[RecordDeleted]      
      ,[DeletedDate]      
      ,[DeletedBy] 
      ,[AddAsBanner]    
       from systemconfigurations s left outer join Reports                 on s.Databaseversion = -1         
                               
                          
END                  
                                    
--Checking For Errors       
If (@@error!=0)            
Begin                       
RAISERROR 20006 '[ssp_InitializeReportDetail] : An Error Occured'           
Return                     
End                            