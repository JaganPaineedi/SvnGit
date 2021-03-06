/****** Object:  StoredProcedure [dbo].[csp_validateCustomAuthorizationDocumentsWeb]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomAuthorizationDocumentsWeb]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomAuthorizationDocumentsWeb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomAuthorizationDocumentsWeb]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_validateCustomAuthorizationDocumentsWeb]           
@DocumentVersionId Int           
as           
/******************************************************************************                                  
**  File: csp_validateCustomAuthorizationDocumentsWeb                              
**  Name: csp_validateCustomAuthorizationDocumentsWeb          
**  Desc: For Validation  on Custom Act Entrance Stay Criteria document    
**  Return values: Resultset having validation messages                                  
**  Called by:                                   
**  Parameters:              
**  Auth:  Ankesh Bharti                 
**  Date:  16/11/2009       
**  Description: Created According to Data Model 3.0                          
*******************************************************************************                                  
**  Change History                                  
*******************************************************************************                                  
**  Date:       Author:       Description:                                  
    
**  18/Nov/2009  Ankesh        Modified According to Data Model 3.1                                    
*******************************************************************************/                                
    
Begin                                                  
        
 Begin try     
--*TABLE CREATE*--           
CREATE TABLE #CustomAuthorizationDocuments (            
DocumentVersionId Int,          
ClientCoveragePlanId int NULL,    
AuthorizationRequestorComment text NULL,    
AuthorizationReviewerComment text NULL,    
Assigned int NULL,    
)             
--*INSERT LIST*--           
INSERT INTO #CustomAuthorizationDocuments (            
DocumentVersionId,             
ClientCoveragePlanId,    
AuthorizationRequestorComment,    
AuthorizationReviewerComment,    
Assigned    
)             
--*Select LIST*--           
Select DocumentVersionId,             
ClientCoveragePlanId,    
AuthorizationRequestorComment,    
AuthorizationReviewerComment,    
Assigned    
FROM CustomAuthorizationDocuments WHERE DocumentVersionId = @DocumentVersionId and isnull(RecordDeleted,''N'')<>''Y''              
           
Insert into #validationReturnTable (  TableName, ColumnName, ErrorMessage )     
SELECT ''CustomAuthorizationDocuments'', ''AuthorizationRequestorComment'', ''AuthorizationRequestorComment must be specified'' 
	FROM #CustomAuthorizationDocuments WHERE cast(isnull(AuthorizationRequestorComment,'''') as varchar) = ''''                      
UNION    
SELECT ''CustomAuthorizationDocuments'', ''Assigned'', ''Assigned must be specified'' 
	FROM #CustomAuthorizationDocuments WHERE Assigned is null    
    
end try                                                                                     
BEGIN CATCH      
DECLARE @Error varchar(8000)                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_validateCustomAuthorizationDocumentsWeb'')                                                                                 
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
