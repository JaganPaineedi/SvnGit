/****** Object:  StoredProcedure [dbo].[csp_AutoCreateDDAssessmentOffOfHRMDDAssessment]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AutoCreateDDAssessmentOffOfHRMDDAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_AutoCreateDDAssessmentOffOfHRMDDAssessment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AutoCreateDDAssessmentOffOfHRMDDAssessment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_AutoCreateDDAssessmentOffOfHRMDDAssessment]  
/*******************************************************************************        
**  Change History        
*******************************************************************************        
**  Date:  Author:    Description:        
**  --------  --------    ----------------------------------------------------        
   
*******************************************************************************/      
  
 @DocumentVersionId int

as  
  
Declare @NewDocumentId int  
Declare @NewDocumentVersionId int  
  
Insert into Documents  
(ClientId, DocumentCodeId, EffectiveDate, Status, AuthorId,  SignedByAuthor, SignedByAll)  
Select d.ClientId, 110, d.EffectiveDate, 21, d.AuthorId, ''N'', ''N''  
From Documents d  
Where d.CurrentDocumentVersionId = @DocumentVersionId  
and isnull(d.RecordDeleted, ''N'')= ''N''  
  
Set @NewDocumentId = @@Identity  
  
Insert into DocumentVersions  
(DocumentId, Version)  
Values (@NewDocumentId, 1)  

  set @NewDocumentVersionId= @@Identity 

Update Documents set CurrentDocumentVersionId= @NewDocumentVersionId where DocumentId= @NewDocumentId  
Insert into CustomDDAssessment  
(DocumentVersionId)  
Values (@NewDocumentVersionId)
' 
END
GO
