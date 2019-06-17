UPDATE ce 
SET [Status] = 100, DischargeDate = NULL
FROM dbo.ClientEpisodes ce
JOIN Clients c ON ce.ClientId = c.ClientId
JOIN Documents d ON c.ClientId = d.ClientId
JOIN Documents d2 ON d.CurrentDocumentVersionId = d2.DocumentId
JOIN dbo.DocumentSignatures ds ON d2.DocumentId = ds.DocumentId
WHERE DATEDIFF(SECOND, ds.SignatureDate, ce.DischargeDate) = 0
AND CONVERT(TIME, ds.SignatureDate) <> '00:00'
