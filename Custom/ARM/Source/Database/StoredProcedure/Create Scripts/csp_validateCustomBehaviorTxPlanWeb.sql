/****** Object:  StoredProcedure [dbo].[csp_validateCustomBehaviorTxPlanWeb]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomBehaviorTxPlanWeb]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomBehaviorTxPlanWeb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomBehaviorTxPlanWeb]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_validateCustomBehaviorTxPlanWeb]         
@DocumentVersionId Int, @DocumentCodeId Int         
as         
  
/******************************************************************************                                
**  File: csp_validateCustomBehaviorTxPlanWeb                            
**  Name: csp_validateCustomBehaviorTxPlanWeb        
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
**  4/12/2009  Ankesh Bharti  Modify according to Data Model 3.0  
**  --------    --------        ----------------------------------------------------                                
*******************************************************************************/                              
    
Return
    
/*    
        
--*TABLE CREATE*--         
CREATE TABLE #CustomBehaviorTxPlan (          
DocumentVersionId Int,        
[Type] varchar(2),  
DOB datetime,  
Age int  
)           
--*INSERT LIST*--         
INSERT INTO #CustomBehaviorTxPlan (          
DocumentVersionId,           
[Type],           
DOB,           
Age         
)           
--*Select LIST*--         
Select DocumentVersionId,           
[Type],           
DOB,           
Age            
FROM CustomBehaviorTxPlan WHERE DocumentVersionId = @DocumentVersionId and isnull(RecordDeleted,''N'')<>''Y''          
         
         
Insert into #validationReturnTable (  TableName, ColumnName, ErrorMessage )          
SELECT ''CustomBehaviorTxPlan'', ''[Type]'', ''Note - Type must be specified'' FROM #CustomBehaviorTxPlan WHERE isnull([Type],'''')=''''          
UNION        
SELECT ''CustomBehaviorTxPlan'', ''Age'', ''Note - Age must be specified'' FROM #CustomBehaviorTxPlan WHERE isnull(Age,'''')=''''        
UNION          
SELECT ''CustomBehaviorTxPlan'', ''DOB'', ''Note - Date Of Birth must be specified'' FROM #CustomBehaviorTxPlan WHERE isnull(DOB,'''')=''''        
            
          
if @@error <> 0 goto error  return  error: raiserror 50000 ''csp_validateCustomBehaviorTxPlanWeb failed.  Please contact your system administrator. We apologize for the inconvenience.'' 

*/
' 
END
GO
