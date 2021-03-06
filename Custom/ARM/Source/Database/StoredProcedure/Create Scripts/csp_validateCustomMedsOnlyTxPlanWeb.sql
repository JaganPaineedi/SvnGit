/****** Object:  StoredProcedure [dbo].[csp_validateCustomMedsOnlyTxPlanWeb]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomMedsOnlyTxPlanWeb]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomMedsOnlyTxPlanWeb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomMedsOnlyTxPlanWeb]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create PROCEDURE [dbo].[csp_validateCustomMedsOnlyTxPlanWeb]             
@DocumentVersionId Int, @DocumentCodeId Int             
as             
      
/******************************************************************************                                    
**  File: csp_validateCustomMedsOnlyTxPlanWeb                                
**  Name: csp_validateCustomMedsOnlyTxPlanWeb            
**  Desc: For Validation  on Custom Meds Only Treatment Plan document      
**  Return values: Resultset having validation messages                                    
**  Called by:                                     
**  Parameters:                
**  Auth:  Ankesh Bharti                   
**  Date:  Nov 25 2009                                
*******************************************************************************                                    
**  Change History                                    
*******************************************************************************                                    
**  Date:       Author:       Description:                                    
**  26/11/2009  Ankesh Bharti  Modify according to Data Model 3.0         
*******************************************************************************/                                  
            
--*TABLE CREATE*--             
CREATE TABLE #CustomMedsOnlyTxPlan (              
DocumentVersionId Int,            
AreasOfConcernSymptoms text,      
MyGoalsTreatment text,      
ClientMethod text      
)               
--*INSERT LIST*--             
INSERT INTO #CustomMedsOnlyTxPlan (              
DocumentVersionId,               
AreasOfConcernSymptoms,               
MyGoalsTreatment,               
ClientMethod             
)               
--*Select LIST*--             
Select DocumentVersionId,               
AreasOfConcernSymptoms,               
MyGoalsTreatment,               
ClientMethod                
FROM CustomMedsOnlyTxPlan WHERE DocumentVersionId = @DocumentVersionId and isnull(RecordDeleted,''N'')<>''Y''   
              
if @@error <> 0 goto error  return  error: raiserror 50000 ''csp_ValidateCustomMedsOnlyTxPlan failed.  Please contact your system administrator. We apologize for the inconvenience.''
' 
END
GO
