/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomAuthorizationDocuments]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomAuthorizationDocuments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomAuthorizationDocuments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomAuthorizationDocuments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_ValidateCustomAuthorizationDocuments]       
@DocumentVersionId Int--, @DocumentCodeId Int       
as       
--This is a temporary  Procedure we will modify this as needed      
/******************************************************************************                              
**  File: csp_ValidateCustomAuthorizationDocuments                          
**  Name: csp_ValidateCustomAuthorizationDocuments      
**  Desc: For Validation  on Custom Act Entrance Stay Criteria document
**  Return values: Resultset having validation messages                              
**  Called by:                               
**  Parameters:          
**  Auth:  Ankesh Bharti             
**  Date:  28/09/2009   
**  Description: Modify According to Data Model 3.0                      
*******************************************************************************                              
**  Change History                              
*******************************************************************************                              
**  Date:       Author:       Description:                              

**  --------    --------        ----------------------------------------------------                              
*******************************************************************************/                            
      
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
--SELECT ''CustomAuthorizationDocuments'', ''ClientCoveragePlanId'', ''ClientCoveragePlanId must be specified'' FROM #CustomAuthorizationDocuments WHERE ClientCoveragePlanId is null         
--UNION
SELECT ''CustomAuthorizationDocuments'', ''AuthorizationRequestorComment'', ''AuthorizationRequestorComment must be specified'' FROM #CustomAuthorizationDocuments WHERE cast(isnull(AuthorizationRequestorComment,'''') as varchar) = ''''                  
UNION
--SELECT ''CustomAuthorizationDocuments'', ''AuthorizationReviewerComment'', ''AuthorizationReviewerComment must be specified'' FROM #CustomAuthorizationDocuments WHERE cast(isnull(AuthorizationReviewerComment,'''') as varchar) = ''''                  
--UNION
SELECT ''CustomAuthorizationDocuments'', ''Assigned'', ''Assigned must be specified'' FROM #CustomAuthorizationDocuments WHERE Assigned is null


if @@error <> 0 goto error  return  error: raiserror 50000 ''csp_validateCustomAuthorizationDocuments failed.  Please contact your system administrator. We apologize for the inconvenience.''
' 
END
GO
