DECLARE @ViewDocumentURL VARCHAR(500)
DECLARE @ViewDocumentRDL VARCHAR(500)

DECLARE @DocumentCodeId INT
SET @DocumentCodeId = 1649

SET @ViewDocumentURL ='RDLDocumentRevokeReleaseofInformation'
SET @ViewDocumentRDL ='RDLDocumentRevokeReleaseofInformation'

UPDATE [dbo].[DocumentCodes] 
SET	[ViewDocumentURL] = @ViewDocumentURL, 
		[ViewDocumentRDL] = @ViewDocumentRDL
		 where  DocumentCodeId = @DocumentCodeId  