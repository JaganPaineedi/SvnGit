UPDATE SE
SET SE.Comment= Main.NextPhysicianVisit
FROM Services SE JOIN (
						SELECT CD.DocumentVersionId,CD.NextPhysicianVisit , S.Comment,S.ServiceId
						FROM CustomDocumentPsychiatricNoteMDMs CD
						INNER JOIN Documents D ON D.CurrentDocumentVersionId=CD.DocumentVersionId AND DocumentcodeId=60000 AND Status=22 AND ISNULL(D.RecordDeleted,'N')<>'Y' 
						INNER JOIN Services S ON S.ServiceId=D.ServiceId AND ISNULL(S.RecordDeleted,'N')<>'Y' 
						WHERE 
							ISNULL(CD.RecordDeleted,'N')<>'Y' 
							AND CD.NextPhysicianVisit IS NOT NULL
							AND (S.Comment IS NULL OR CAST(CD.NextPhysicianVisit AS VARCHAR(MAX))<> CAST(S.Comment AS VARCHAR(MAX)))
							) Main ON SE.ServiceId=Main.ServiceId
