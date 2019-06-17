
--Task: #483 SWMBH - Support
--Date: 08/23/2016

DECLARE @ReportServerId INT
DECLARE @ReportServerPath VARCHAR(250)


SET @ReportServerId = (
		SELECT TOP 1 ReportServerId
		FROM ReportServers
		WHERE ISNULL(RecordDeleted, 'N') = 'N'
		)
SET @ReportServerPath = (
		SELECT ReportFolderName
		FROM SystemConfigurations
		)
		

IF NOT EXISTS (
		SELECT 1
		FROM ReportS
		WHERE NAME = '1099 Report'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO ReportS (
		NAME
		,[Description]
		,IsFolder
		,ParentFolderId
		,AssociatedWith
		,ReportServerId
		,ReportServerPath
		)
	VALUES (
		'1099 Report'
		,'Print 1099 for specific insurers/providers for specified calendar year'
		,'N'
		,NULL
		,NULL
		,@ReportServerId
		,'/' + @ReportServerPath + '/' + 'Print 1099 Forms'
		)
END


UPDATE SystemReports 
SET ReportURL= '<Please Update URL>/'+ @ReportServerPath +'/Print 1099 Forms&rs:Command=Render&rc:Parameters=false&SessionId=<SessionId>&TaxId1=<TaxId1>&TaxId2=<TaxId2>&CalendarYear=<CalendarYear>'
WHERE SystemReportId=8

GO