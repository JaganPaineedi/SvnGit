/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentHealthHomeCarePlanPESNeeds]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentHealthHomeCarePlanPESNeeds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentHealthHomeCarePlanPESNeeds]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentHealthHomeCarePlanPESNeeds]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE   [dbo].[csp_RDLCustomDocumentHealthHomeCarePlanPESNeeds]         
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

                    
   
	SELECT   CustomDocumentHealthHomeCarePlanPESNeedId,  
		CDHHCP.CreatedBy,  
		CDHHCP.CreatedDate,  
		CDHHCP.ModifiedBy,  
		CDHHCP.ModifiedDate,  
		CDHHCP.RecordDeleted,  
		CDHHCP.DeletedBy,  
		CDHHCP.DeletedDate,  
		CDHHCP.DocumentVersionId,  
		PsychosocialSupportNeedSequence,
		PsychosocialSupportNeedType,
		PsychosocialSupportNeedPlan
 FROM CustomDocumentHealthHomeCarePlanPESNeeds CDHHCP INNER JOIN
                      DocumentVersions AS DV ON CDHHCP.DocumentVersionId = DV.DocumentVersionId  AND (CDHHCP.DocumentVersionId = @DocumentVersionId) 
                INNER JOIN  
                      Documents ON DV.DocumentId = Documents.DocumentId AND DV.DocumentVersionId = Documents.CurrentDocumentVersionId 
                     
	  WHERE     (ISNULL(CDHHCP.RecordDeleted, ''N'') = ''N'') AND (CDHHCP.DocumentVersionId = @DocumentVersionId)       
               
If (@@error!=0)                                                          
 Begin                                                          
  RAISERROR  20006   ''[csp_RDLCustomDocumentHealthHomeCarePlanPESNeeds] : An Error Occured''                                                           
  Return                                                          
 End                                                                   
End

' 
END
GO
