/****** Object:  StoredProcedure [dbo].[csp_InitializeReportDetail]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitializeReportDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitializeReportDetail]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitializeReportDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'                     
        
        
Create PROCEDURE  [dbo].[csp_InitializeReportDetail]       
(                              
 @StaffId int,        
 @ClientID int,        
 @CustomParameters xml                              
)                                                      
As                                                            
Begin                                                                
 /*********************************************************************/                                                                  
 /* Stored Procedure: [csp_InitializeReportDetail]               */                                                         
 /* Creation Date:  08/July/2010                                   */                                                                  
 /* Creation By : Damanpreet Kaur                                                                  */                                                                  
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
 /*********************************************************************/                                                                   
       
       
   SELECT ''Reports'' as TableName,    
       -1 as [ReportId]    
      ,'''' as[Name]    
      ,[Description]    
      ,''N'' as [IsFolder]    
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
       from systemconfigurations s left outer join Reports        
       on s.Databaseversion = -1       
                             
                        
END                
                                  
--Checking For Errors     
If (@@error!=0)          
Begin                     
RAISERROR 20006 ''[csp_InitializeReportDetail] : An Error Occured''         
Return                   
End                          ' 
END
GO
