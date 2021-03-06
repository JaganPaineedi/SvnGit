/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportCustomDocumentAssessmentNeeds]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomDocumentAssessmentNeeds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportCustomDocumentAssessmentNeeds]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomDocumentAssessmentNeeds]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create procedure [dbo].[csp_RDLSubReportCustomDocumentAssessmentNeeds]           
@DocumentVersionId  int   
/************************************************************************/                                                            
/* Stored Procedure: [CDAN]   */                                                                                         
/* Copyright: 2008 Streamline SmartCare         */                                                                                                  
/* Creation Date:  June 24, 2011          */                                                            
/*                  */                                                            
/* Purpose: Retrieve needs for a CustomDocumentAssessmentNeeds*/            
/*                  */                                                          
/* Input Parameters: DocumentVersionId         */                                                          
/* Output Parameters:             */                                                            
/* Purpose: Use For Rdl Report           */                                                  
/* Calls:                */                                                            
/* Author: Jagdeep Hundal            */                                                            
/************************************************************************/                              
            
as            
            
SELECT            
  CDAN.NeedName,          
  CDAN.NeedStatus,   
  CDAN.NeedDescription,            
  CDAN.CreatedBy,            
  CDAN.CreatedDate,            
  CDAN.ModifiedBy,            
  CDAN.ModifiedDate             
FROM CustomDocumentAssessmentNeeds as CDAN            
JOIN DocumentVersions  ON        
CDAN.DocumentVersionId = DocumentVersions.DocumentVersionId  and isnull(DocumentVersions.RecordDeleted,''N'')<>''Y''    
JOIN Documents  on Documents.DocumentId = DocumentVersions.DocumentId       
AND  isnull(Documents.RecordDeleted,''N'')<>''Y''          
WHERE CDAN.DocumentVersionId = @DocumentVersionId            
AND isnull(CDAN.RecordDeleted,''N'') <> ''Y''            
ORDER BY            
  CDAN.ModifiedDate,            
  CDAN.ModifiedBy,            
  CDAN.CreatedDate,            
  CDAN.CreatedBy            
 --Checking For Errors                                                              
If (@@error!=0)                                                              
 Begin                                                              
  RAISERROR  20006   ''[csp_RDLSubReportCustomDocumentAssessmentNeeds] : An Error Occured''                                                               
  Return                                                              
 End ' 
END
GO
