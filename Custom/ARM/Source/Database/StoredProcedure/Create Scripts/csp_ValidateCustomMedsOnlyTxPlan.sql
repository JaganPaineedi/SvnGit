/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomMedsOnlyTxPlan]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomMedsOnlyTxPlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomMedsOnlyTxPlan]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomMedsOnlyTxPlan]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  PROCEDURE [dbo].[csp_ValidateCustomMedsOnlyTxPlan]           
@DocumentVersionId Int, @DocumentCodeId Int           
as           
    
/******************************************************************************                                  
**  File: csp_ValidateCustomMedsOnlyTxPlan                              
**  Name: csp_ValidateCustomMedsOnlyTxPlan          
**  Desc: For Validation  on Custom Meds Only Treatment Plan document    
**  Return values: Resultset having validation messages                                  
**  Called by:                                   
**  Parameters:              
**  Auth:  Devinder Pal Singh                 
**  Date:  Aug 24 2009                              
*******************************************************************************                                  
**  Change History                                  
*******************************************************************************                                  
**  Date:       Author:       Description:                                  
**  17/09/2009  Ankesh Bharti  Modify according to Data Model 3.0    
**  --------    --------        ----------------------------------------------------                                  
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
           
           
Insert into #validationReturnTable (  TableName, ColumnName, ErrorMessage )            
SELECT ''CustomMedsOnlyTxPlan'', ''AreasOfConcernSymptoms'', ''Note - CAFAS Date must be specified'' FROM #CustomMedsOnlyTxPlan WHERE CAST(ISNULL(AreasOfConcernSymptoms,'''') AS VARCHAR) = ''''            
UNION          
SELECT ''CustomMedsOnlyTxPlan'', ''ClientMethod'', ''Note - CAFAS Interval must be specified'' FROM #CustomMedsOnlyTxPlan WHERE CAST(ISNULL(ClientMethod,'''') AS VARCHAR) = ''''          
UNION            
SELECT ''CustomMedsOnlyTxPlan'', ''MyGoalsTreatment'', ''Note - Rater Clinician must be specified'' FROM #CustomMedsOnlyTxPlan WHERE CAST(ISNULL(MyGoalsTreatment,'''') AS VARCHAR) = ''''          
              
            
  if @@error <> 0 goto error  return  error: raiserror 50000 ''csp_ValidateCustomMedsOnlyTxPlan failed.  Please contact your system administrator. We apologize for the inconvenience.''
' 
END
GO
