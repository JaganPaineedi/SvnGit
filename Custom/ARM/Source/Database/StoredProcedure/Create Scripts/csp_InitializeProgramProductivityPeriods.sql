/****** Object:  StoredProcedure [dbo].[csp_InitializeProgramProductivityPeriods]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitializeProgramProductivityPeriods]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitializeProgramProductivityPeriods]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitializeProgramProductivityPeriods]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitializeProgramProductivityPeriods]                   
(                                      
 @StaffId int,                
 @ClientID int,                
 @CustomParameters xml                                      
)                                                              
As                                                                     
 Begin                                                                        
 /*********************************************************************/                                                                          
 /* Stored Procedure: [csp_InitializeProgramProductivityPeriods]             */                                                                 
 /* Creation Date:  12/MARCH/2012                                     */                                                                          
 /* Created By: Jagdeep Hundal                                        */                                                                          
 /* Input Parameters:@StaffId,@ClientID,@CustomParameters             */                                                                        
 /* Output Parameters:                                                */                                                                          
 /* Called By:Program Productivity Periods Details                            */                                                                
 /* Calls:                                                            */                                                                          
 /* Data Modifications:                                               */                                                                          
 /*   Updates:                                                        */                                                                          
 /*       Date              Author                  Purpose           */                                                                          
 /*********************************************************************/                                                                           
                                        
  SELECT Placeholder.TableName, ISNULL(PPP.ProgramProductivityPeriodId,-1) AS ProgramProductivityPeriodId     
      ,PPP.[CreatedBy]
      ,PPP.[CreatedDate]
      ,PPP.[ModifiedBy]
      ,PPP.[ModifiedDate]
      ,PPP.[RecordDeleted]
      ,PPP.[DeletedDate]
      ,PPP.[DeletedBy]
      ,PPP.[Active]
      ,PPP.[ProgramId]
      ,PPP.[NextPeriodLength]
      ,PPP.[NextPeriodStartDate]
  FROM (SELECT ''ProgramProductivityPeriods'' AS TableName) AS Placeholder    
  LEFT JOIN ProgramProductivityPeriods PPP ON ( PPP.ProgramProductivityPeriodId = -1    
  AND ISNULL(PPP.RecordDeleted,''N'') <> ''Y'' )                     
                              
END                                        
                                          
--Checking For Errors                                   
                                  
If (@@error!=0)                                   
                                  
Begin                                   
                                  
RAISERROR 20006 ''[csp_InitializeProgramProductivityPeriods] : An Error Occured''                                   
                                  
Return                                   
                                  
End  ' 
END
GO
