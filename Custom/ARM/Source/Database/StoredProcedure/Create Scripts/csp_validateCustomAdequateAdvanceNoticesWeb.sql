/****** Object:  StoredProcedure [dbo].[csp_validateCustomAdequateAdvanceNoticesWeb]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomAdequateAdvanceNoticesWeb]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomAdequateAdvanceNoticesWeb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomAdequateAdvanceNoticesWeb]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_validateCustomAdequateAdvanceNoticesWeb]         
@DocumentVersionId Int         
as         
  
/******************************************************************************                                
**  File: csp_validateCustomAdequateAdvanceNoticesWeb                             
**  Name: csp_validateCustomAdequateAdvanceNoticesWeb         
**  Desc: For Validation  on Custom AdequateAdvanceNotices document(For Prototype purpose, Need modification)        
**  Return values: Resultset having validation messages                                
**  Called by:                                 
**  Parameters:            
**  Auth:  Ankesh Bharti              
**  Date:  Nov 23 2009                            
*******************************************************************************                                
**  Change History                                
*******************************************************************************                                
**  Date:       Author:       Description:                                
*******************************************************************************/                              

Return


/*
  
Begin                                                
      
 Begin try    
--*TABLE CREATE*--         
CREATE TABLE #CustomAdvanceAdequateNotices (          
DocumentVersionId Int,        
MedicaidCustomer  char(1),          
ActionRequestedServices char(1),  
ActionRequestedServicesSpecifier char(1)  
)           
--*INSERT LIST*--         
INSERT INTO #CustomAdvanceAdequateNotices (          
DocumentVersionId,           
MedicaidCustomer,           
ActionRequestedServices,  
ActionRequestedServicesSpecifier  
)           
--*Select LIST*--         
Select DocumentVersionId,           
MedicaidCustomer,           
ActionRequestedServices,  
ActionRequestedServicesSpecifier            
FROM CustomAdvanceAdequateNotices WHERE DocumentVersionId = @DocumentVersionId and isnull(RecordDeleted,''N'')<>''Y''         
         
         
Insert into #validationReturnTable (  TableName, ColumnName, ErrorMessage )          
SELECT ''CustomAdvanceAdequateNotices'', ''MedicaidCustomer'', ''Medicaid Cutomer must be specified'' FROM #CustomAdvanceAdequateNotices WHERE isnull(MedicaidCustomer,'''')=''''          
UNION        
SELECT ''CustomAdvanceAdequateNotices'', ''ActionRequestedServices'', ''Action Requested Services must be specified'' FROM #CustomAdvanceAdequateNotices WHERE isnull(ActionRequestedServices,'''')=''''        
UNION          
SELECT ''CustomAdvanceAdequateNotices'', ''ActionRequestedServicesSpecifier'', ''Action Requested Services Specifier must be specified'' FROM #CustomAdvanceAdequateNotices WHERE isnull(ActionRequestedServicesSpecifier,'''')=''''        
end try                                                
                                                                                         
BEGIN CATCH    
DECLARE @Error varchar(8000)                                                 
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                               
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_validateCustomAdequateAdvanceNoticesWeb'')                                                                               
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

*/
' 
END
GO
