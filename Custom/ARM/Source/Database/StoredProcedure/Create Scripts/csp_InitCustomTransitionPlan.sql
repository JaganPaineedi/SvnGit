/****** Object:  StoredProcedure [dbo].[csp_InitCustomTransitionPlan]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomTransitionPlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomTransitionPlan]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomTransitionPlan]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomTransitionPlan]        
(                            
 @ClientID int,      
 @StaffID int,    
 @CustomParameters xml                            
)                                                    
As                                                      
                                                             
 /*********************************************************************/                                                                
 /* Stored Procedure: [csp_InitCustomTransitionPlan]   */                                                     
                                                              
 /*       Date              Author                  Purpose                   */                                                                
 /*       21/Feb/2013      Bernardin               To Retrieve Data           */      
 /*********************************************************************/        
Declare @NextMHServicDate datetime
Declare @NextHHServicDate datetime
Declare @Type varchar(100)
                                                                            
Begin                                              
    
Begin try

-- Get NextScheduledHHServiceDate value
SELECT Top(1)   @NextHHServicDate = Services.DateOfService
FROM         Services INNER JOIN
                      Programs ON Services.ProgramId = Programs.ProgramId INNER JOIN
                      ServiceAreas ON Programs.ServiceAreaId = ServiceAreas.ServiceAreaId
WHERE Services.ClientId = @ClientID and ServiceAreas.ServiceAreaName = ''Health Home Service'' and (ISNULL(Services.RecordDeleted, ''N'') = ''N'') and Services.DateOfService > GETDATE() ORDER BY DateOfService

-- Get NextScheduledMHServiceDate value
SELECT Top(1)   @NextMHServicDate = Services.DateOfService
FROM         Services INNER JOIN
                      Programs ON Services.ProgramId = Programs.ProgramId INNER JOIN
                      ServiceAreas ON Programs.ServiceAreaId = ServiceAreas.ServiceAreaId
WHERE Services.ClientId = @ClientID and ServiceAreas.ServiceAreaName = ''Mental Health'' and (ISNULL(Services.RecordDeleted, ''N'') = ''N'') and Services.DateOfService > GETDATE() ORDER BY DateOfService

-- Get Procedurecode name for this document
SELECT @Type = DisplayAs FROM ProcedureCodes WHERE AssociatedNoteId = 1000268

-- CustomDocumentHealthHomeTransitionPlans                      
Select TOP 1 ''CustomDocumentHealthHomeTransitionPlans'' AS TableName, -1 as ''DocumentVersionId'', 
'''' as CreatedBy,                  
getdate() as CreatedDate,                  
'''' as ModifiedBy,                  
getdate() as ModifiedDate,
@NextHHServicDate as NextScheduledHHServiceDate,
@NextMHServicDate as NextScheduledMHServiceDate,
@Type as NextScheduledMHServiceType
from systemconfigurations s left outer join CustomDocumentHealthHomeTransitionPlans                                                                      
on s.Databaseversion = -1
                        
end try                                              
                                                                                       
BEGIN CATCH  
DECLARE @Error varchar(8000)                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                             
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomTransitionPlan'')                                                                             
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
