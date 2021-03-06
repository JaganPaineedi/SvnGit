/****** Object:  StoredProcedure [dbo].[csp_InitCustomOutlierManagmentStandardInitialization]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomOutlierManagmentStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomOutlierManagmentStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomOutlierManagmentStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'             
                      
                      
                      
                      
CREATE PROCEDURE  [dbo].[csp_InitCustomOutlierManagmentStandardInitialization]                         
@StaffId int,          
@ClientId int,                                                             
 @CustomParameters xml                                                             
As                                                                                                                                                                       
 Begin                                                                              
 /*********************************************************************/                                                                                
 /* Stored Procedure: [csp_InitCustomOutlierManagmentStandardInitialization]               */                                                                       
                                                                       
 /* Copyright: 2006 Streamline SmartCare*/                                                                                
                                                                       
 /* Creation Date:                                 */                                                                                
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
 /*            */                      
 /*********************************************************************/                         
             
 ---- Task----            
 SELECT ''Tasks'' as TableName            
,-1 as [TaskId]            
      ,Tasks.[CreatedBy]            
      ,Tasks.[CreatedDate]            
      ,Tasks.[ModifiedBy]            
      ,Tasks.[ModifiedDate]            
      ,Tasks.[RecordDeleted]            
      ,Tasks.[DeletedDate]            
      ,Tasks.[DeletedBy]            
      ,[AssignedToStaffId]            
      ,Tasks.[Category]            
      ,Tasks.[Group]            
      ,Tasks.[Type]            
      ,[Status]            
      ,[StartDate]            
      ,[EndDate]            
      ,[PercentComplete]            
      ,[Summary]  
      ,null as FormId       
      , @StaffId as StaffId          
from systemconfigurations s left outer join [Tasks]                    
on s.Databaseversion = -1    
              
  ---------- TaskComments-----------         
  --declare @StaffName as varchar(50)        
  --set @StaffName=(select LastName + '', '' + FirstName from Staff where StaffId=@StaffId)        
             
--  SELECT ''TaskComments'' as TableName            
--   ,-1 as [TaskCommentId]            
--      ,TaskComments.[CreatedBy]            
--      ,TaskComments.[CreatedDate]            
--      ,TaskComments.[ModifiedBy]            
--      ,TaskComments.[ModifiedDate]            
--      ,TaskComments.[RecordDeleted]            
--      ,TaskComments.[DeletedDate]            
--      ,TaskComments.[DeletedBy]            
--      ,-1 as [TaskId]            
--      ,@StaffId as [StaffId]                  
--      ,TaskComments.[Comment]        
--      ,@StaffName as StaffName             
                 
-- from systemconfigurations s left outer join [TaskComments]        
-- --inner join Staff as SF on TaskComments.StaffId=SF.StaffId                       
--on s.Databaseversion = -1                                          
               select ''CustomOMTasks'' as TableName  ,    
                 -1 as TaskId      
       ,COM.[CreatedBy]                    
      ,COM.[CreatedDate]                    
      ,COM. [ModifiedBy]                    
      ,COM. [ModifiedDate]                    
      ,COM.[RecordDeleted]                    
      ,COM.[DeletedDate]                    
      ,COM.[DeletedBy]       
      ,COM.Details      
      ,COM.Hypothesis      
      ,COM.Recommendations      
      ,COM.ActionSteps       
      from systemconfigurations s left outer join [CustomOMTasks] as COM                                
 on s.Databaseversion = -1                                 
END                                              
                  
                                                
--Checking For Errors                                         
                                        
If (@@error!=0)                                         
                                        
Begin                                         
                                        
RAISERROR 20006 ''[csp_InitCustomOutlierManagmentStandardInitialization] : An Error Occured''                                         
                                        
Return                                         
                                        
End               
' 
END
GO
