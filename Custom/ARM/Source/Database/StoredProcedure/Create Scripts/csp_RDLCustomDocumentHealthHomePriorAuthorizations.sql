/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentHealthHomePriorAuthorizations]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentHealthHomePriorAuthorizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentHealthHomePriorAuthorizations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentHealthHomePriorAuthorizations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE   [dbo].[csp_RDLCustomDocumentHealthHomePriorAuthorizations]         
(                               
@DocumentVersionId  int           
)                      
AS                      
                
Begin                
-- =============================================
-- Author:		Veena S Mani
-- Create date: 22/02/2013
-- Description:	To get data for CustomDocumentHealthHomePriorAuthorizations.
-- ============================================= 

                    
   
	SELECT   HealthHomePriorAuthorizationId,  
		CDHHCP.CreatedBy,  
		CDHHCP.CreatedDate,  
		CDHHCP.ModifiedBy,  
		CDHHCP.ModifiedDate,  
		CDHHCP.RecordDeleted,  
		CDHHCP.DeletedBy,  
		CDHHCP.DeletedDate,  
		CDHHCP.DocumentVersionId,  
		SequenceNumber,
		ServiceDescription,
		CONVERT(VARCHAR(10), DateAuthorizationObtained, 101) as DateAuthorizationObtained
 FROM CustomDocumentHealthHomePriorAuthorizations CDHHCP INNER JOIN
                      DocumentVersions AS DV ON CDHHCP.DocumentVersionId = DV.DocumentVersionId  AND (CDHHCP.DocumentVersionId = @DocumentVersionId) 
                INNER JOIN  
                      Documents ON DV.DocumentId = Documents.DocumentId AND DV.DocumentVersionId = Documents.CurrentDocumentVersionId 
                     
	  WHERE     (ISNULL(CDHHCP.RecordDeleted, ''N'') = ''N'') AND (CDHHCP.DocumentVersionId = @DocumentVersionId)       
               
If (@@error!=0)                                                          
 Begin                                                          
  RAISERROR  20006   ''[csp_RDLCustomDocumentHealthHomePriorAuthorizations] : An Error Occured''                                                           
  Return                                                          
 End                                                                   
End
' 
END
GO
