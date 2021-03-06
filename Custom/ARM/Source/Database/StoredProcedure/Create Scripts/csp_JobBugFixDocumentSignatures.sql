/****** Object:  StoredProcedure [dbo].[csp_JobBugFixDocumentSignatures]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobBugFixDocumentSignatures]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_JobBugFixDocumentSignatures]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobBugFixDocumentSignatures]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_JobBugFixDocumentSignatures]


AS

/*
08.07.2012	avoss	created
08.08.2012	avoss	modified to fix author,staff mismatch on document signature records  addtional bug

*/

DECLARE @Golive DATETIME
SET @Golive = ''7/9/2012''


UPDATE ds 
SET
signatureDate = d.ModifiedDate
,SignerName = s.FirstName + '' '' + s.LastName + CASE WHEN gc.GlobalCodeId IS NOT NULL THEN '', '' + gc.CodeName ELSE '''' END
,ClientSignedPaper = ''N''
,RevisionNumber = 1
,VerificationMode = ''P''
FROM documents d 
JOIN dbo.DocumentSignatures ds ON ds.DocumentId = d.DocumentId AND ds.StaffId = d.AuthorId AND ds.SignerName IS NULL AND ISNULL(ds.RecordDeleted,''N'')<>''Y'' 
--JOIN dbo.DocumentVersions dv ON dv.DocumentVersionId = ds.SignedDocumentVersionId AND ISNULL(dv.RecordDeleted,''N'')<>''Y''
JOIN staff s ON s.StaffId = d.AuthorId
LEFT JOIN dbo.GlobalCodes gc ON gc.GlobalCodeId = s.Degree
WHERE d.Status = 22
AND d.EffectiveDate > @Golive
AND ds.SignedDocumentVersionId IS NOT NULL 
AND ISNULL(d.RecordDeleted,''N'')<>''Y''


UPDATE ds
	SET VerificationMode = ''P''
FROM documents d 
JOIN dbo.DocumentSignatures ds ON ds.DocumentId = d.DocumentId AND ds.StaffId = d.AuthorId AND ds.SignerName IS NOT NULL AND ISNULL(ds.RecordDeleted,''N'')<>''Y'' AND VerificationMode IS NULL
JOIN staff s ON s.StaffId = d.AuthorId
WHERE d.Status = 22
AND d.EffectiveDate > @Golive
AND ds.SignedDocumentVersionId IS NOT NULL 
AND ISNULL(d.RecordDeleted,''N'')<>''Y''


--08.08.2012 new fix
INSERT INTO CustomOldDocumentSignaturesToCorrect

SELECT 
st.LastName + '', '' + st.FirstName AS clinician,
st2.LastName + '', '' + st2.FirstName AS author, 
st3.LastName + '', '' + st3.FirstName AS Signer,
d.Status,
d.AuthorId,
ds.StaffId AS IncorrectDocumentSignatureStaffId,
ds.*,
GETDATE() AS CustomCreatedDate
FROM services s 
JOIN staff st ON st.Staffid = s.ClinicianId 
JOIN documents d ON d.ServiceId = s.ServiceId AND ISNULL(d.RecordDeleted,''N'')<>''Y''
	JOIN staff st2 ON st2.Staffid = D.AuthorId 
JOIN documentSignatures ds ON ds.DocumentId = d.DocumentId AND ds.SignatureOrder = 1 AND ISNULL(ds.RecordDeleted,''N'') <> ''Y''
	JOIN staff st3 ON st3.Staffid = ds.StaffId 
WHERE ds.StaffId <> d.AuthorId
AND ISNULL(s.RecordDeleted,''N'')<>''Y''
AND ISNULL(d.ProxyId,-1) <> 0 
AND NOT EXISTS ( SELECT 1 FROM CustomOldDocumentSignaturesToCorrect x WHERE x.SignatureId = ds.SignatureId )


BEGIN TRAN

UPDATE ds
	SET StaffId = a.AuthorId
FROM CustomOldDocumentSignaturesToCorrect a 
JOIN dbo.DocumentSignatures ds ON ds.SignatureId = a.SignatureId
WHERE ds.StaffId <> a.AuthorId

COMMIT

' 
END
GO
