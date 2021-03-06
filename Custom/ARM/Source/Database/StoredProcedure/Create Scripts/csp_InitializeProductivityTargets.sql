/****** Object:  StoredProcedure [dbo].[csp_InitializeProductivityTargets]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitializeProductivityTargets]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitializeProductivityTargets]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitializeProductivityTargets]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitializeProductivityTargets]                   
(                                      
 @StaffId int,                
 @ClientID int,                
 @CustomParameters xml                                      
)                                                              
As                                                                     
 Begin                                                                        
 /*********************************************************************/                                                                          
 /* Stored Procedure: [csp_InitializeProductivityTargets]             */                                                                 
 /* Creation Date:  09/MARCH/2012                                     */                                                                          
 /* Created By: Jagdeep Hundal                                        */                                                                          
 /* Input Parameters:@StaffId,@ClientID,@CustomParameters             */                                                                        
 /* Output Parameters:                                                */                                                                          
 /* Called By:Productivity Targets Details                            */                                                                
 /* Calls:                                                            */                                                                          
 /* Data Modifications:                                               */                                                                          
 /* Updates:                                                          */                                                                          
 /* Date         Author                  Purpose                      */
 -- 05/16/2012   Jagdeep                 Modify to set default Value of Active,TargetOrOffset.                                                 
 /*********************************************************************/                                                                           
                                        
  SELECT Placeholder.TableName, ISNULL(PT.ProductivityTargetId,-1) AS ProductivityTargetId     
      ,PT.[CreatedBy]
      ,PT.[CreatedDate]
      ,PT.[ModifiedBy]
      ,PT.[ModifiedDate]
      ,PT.[RecordDeleted]
      ,PT.[DeletedDate]
      ,PT.[DeletedBy]
      ,PT.[TargetName]
      ,''Y'' as [Active]
      ,''T'' TargetOrOffset
  FROM (SELECT ''ProductivityTargets'' AS TableName) AS Placeholder    
  LEFT JOIN ProductivityTargets PT ON ( PT.ProductivityTargetId = -1    
  AND ISNULL(PT.RecordDeleted,''N'') <> ''Y'' )                     
                              
END                                        
                                          
--Checking For Errors                                   
                                  
If (@@error!=0)                                   
                                  
Begin                                   
                                  
RAISERROR 20006 ''[csp_InitializeProductivityTargets] : An Error Occured''                                   
                                  
Return                                   
                                  
End  ' 
END
GO
