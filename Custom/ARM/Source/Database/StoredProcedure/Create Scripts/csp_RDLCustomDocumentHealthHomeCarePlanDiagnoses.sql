/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentHealthHomeCarePlanDiagnoses]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentHealthHomeCarePlanDiagnoses]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentHealthHomeCarePlanDiagnoses]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentHealthHomeCarePlanDiagnoses]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE   [dbo].[csp_RDLCustomDocumentHealthHomeCarePlanDiagnoses]         
(                               
@DocumentVersionId  int           
)                      
AS                      
                
Begin                
-- =============================================
-- Author:		Veena S Mani
-- Create date: 08/02/2013
-- Description:	To get data for Custom Health Evaluation RDL.
-- ============================================= 

                    
   
	SELECT   CustomDocumentHealthHomeCarePlanDiagnosisId,  
		CDHHCP.CreatedBy,  
		CDHHCP.CreatedDate,  
		CDHHCP.ModifiedBy,  
		CDHHCP.ModifiedDate,  
		CDHHCP.RecordDeleted,  
		CDHHCP.DeletedBy,  
		CDHHCP.DeletedDate,  
		CDHHCP.DocumentVersionId,  
		SequenceNumber,  
		ReportedDiagnosis,  
		DiagnosisSource,  
		TreatmentProvider  
	FROM CustomDocumentHealthHomeCarePlanDiagnoses CDHHCP INNER JOIN
		  DocumentVersions AS DV ON CDHHCP.DocumentVersionId = DV.DocumentVersionId INNER JOIN
		  Documents ON DV.DocumentId = Documents.DocumentId AND DV.DocumentVersionId = Documents.CurrentDocumentVersionId AND 
		  DV.DocumentVersionId = Documents.InProgressDocumentVersionId
	  WHERE     (ISNULL(CDHHCP.RecordDeleted, ''N'') = ''N'') AND (CDHHCP.DocumentVersionId = @DocumentVersionId)       
               
If (@@error!=0)                                                          
 Begin                                                          
  RAISERROR  20006   ''[csp_CustomDocumentHealthHomeCarePlanDiagnoses] : An Error Occured''                                                           
  Return                                                          
 End                                                                   
End
' 
END
GO
