SELECT * FROM SystemReports


--for brt

DECLARE @ReportURL VARCHAR(MAX)
DECLARE @SystemReportId INT

SET @ReportURL = 'http://FARMDB30/ReportServer_NDNW?/NDNW/' + 
CASE 
    WHEN DB_NAME() LIKE '%Test%'
	   THEN 'Test'
    WHEN DB_NAME() LIKE '%Train%'
	   THEN 'Train'
    WHEN DB_NAME() LIKE '%Prod%'
	   THEN 'Prod'
END 
+
'Documents/NDNW Client Statements&rs:Command=Render&rc:Parameters=false&ClientStatementId=<ClientStatementId>'

Select @SystemReportId = sr.SystemReportId
FROM dbo.SystemReports sr
WHERE ISNULL(sr.RecordDeleted,'N')='N'
AND sr.ReportName = 'View Client Statement'

UPDATE sr 
SET sr.ReportURL = @ReportURL
FROM dbo.SystemReports sr
WHERE SystemReportId = @SystemReportId

SET @ReportURL = 'http://FARMDB30/ReportServer_NDNW?/NDNW/' + 
CASE 
    WHEN DB_NAME() LIKE '%Test%'
	   THEN 'Test'
    WHEN DB_NAME() LIKE '%Train%'
	   THEN 'Train'
    WHEN DB_NAME() LIKE '%Prod%'
	   THEN 'Prod'
END 
+
'Documents/NDNW Client Statements&rs:Command=Render&rc:Parameters=false&ClientStatementBatchId=<StatementBatchId>'

Select @SystemReportId = sr.SystemReportId
FROM dbo.SystemReports sr
WHERE ISNULL(sr.RecordDeleted,'N')='N'
AND sr.ReportName = 'Print Client Statements'


UPDATE sr 
SET sr.ReportURL = @ReportURL
FROM dbo.SystemReports sr
WHERE SystemReportId = @SystemReportId