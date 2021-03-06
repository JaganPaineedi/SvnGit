/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentActivityNote]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentActivityNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentActivityNote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentActivityNote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************/
/* 
Date			Author					Purpose
2/Aug/2012		Mamta Gupta				Task No. 1850 - Harbor Go Live (To handle 2nd version exception in case of RDL)
*/
/*22.12.2017 - Kavya.N     - Changed clientname and ClinicianName format to (Firstname Lastname)*/
/*********************************************************************************************/
CREATE PROCEDURE   [dbo].[csp_RDLCustomDocumentActivityNote]  
(  
@DocumentVersionId  int   
)  
AS  
  
Begin  
  
BEGIN TRY  
  
SELECT  SystemConfig.OrganizationName,  
  C.FirstName + '' '' + C.LastName as ClientName,  
  Documents.ClientID,  
  dc.DocumentName as DocumentName,
  CONVERT(VARCHAR(10), DOCUMENTS.EffectiveDate, 101) as EffectiveDate,
  S.FirstName + '' '' + S.LastName + '' '' + ISNull(GC.CodeName,'''') as ClinicianName, 
  --CASE DS.VerificationMode 
		--WHEN ''P'' THEN
		--''''
		--WHEN ''S'' THEN 
		--(SELECT PhysicalSignature FROM DocumentSignatures DS WHERE dv.DocumentId=DS.DocumentId) 
		--DS.PhysicalSignature--Added by Mamta Gupta #1850 Harbor Go Live
		--END as [Signature],
		--CONVERT(VARCHAR(10), DS.SignatureDate, 101) as SignatureDate,
	--	DS.VerificationMode as VerificationStyle, 
     AN.CreatedBy,  
     AN.CreatedDate,  
     AN.ModifiedBy,  
     AN.ModifiedDate,  
     AN.RecordDeleted,  
     AN.DeletedBy,  
     AN.DeletedDate,    
     AN.Narrative
FROM [CustomDocumentActivityNotes]AN  
join DocumentVersions as dv on dv.DocumentVersionId = AN.DocumentVersionId  
join Documents ON  Documents.DocumentId = dv.DocumentId 
join dbo.DocumentCodes as dc on dc.DocumentCodeId = Documents.DocumentCodeId
join Staff S on Documents.AuthorId= S.StaffId  
join Clients C on Documents.ClientId= C.ClientId  
Left Join GlobalCodes GC On S.Degree=GC.GlobalCodeId 
--Updated by Suhdir Singh: if SignedDocumentVersionId (#1850 Harbor Go Live ) 
--left join DocumentSignatures DS on dv.DocumentId=DS.DocumentId
--left join DocumentSignatures DS on dv.DocumentId=DS.DocumentId and DS.SignedDocumentVersionId = @DocumentVersionId 
Cross Join SystemConfigurations as SystemConfig  
where AN.DocumentVersionId=@DocumentVersionId   
and isnull(Documents.RecordDeleted,''N'')=''N''  
and isnull(S.RecordDeleted,''N'')=''N'' 
and isnull(C.RecordDeleted,''N'')=''N''
and isNull(GC.RecordDeleted,''N'')=''N''   
--and isNull(DS.RecordDeleted,''N'')=''N''
  
END TRY  
  
BEGIN CATCH  
  
   DECLARE @Error VARCHAR(8000)         
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                              
   + ''*****'' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),''csp_RDLCustomDocumentPsychologicalNotes'')                                                                                               
   + ''*****'' + CONVERT(VARCHAR,ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                
   + ''*****'' + CONVERT(VARCHAR,ERROR_STATE())  
  RAISERROR  
  (  
   @Error, -- Message text.  
   16,  -- Severity.  
   1  -- State.  
  );  
END CATCH  
End  
' 
END
GO
