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
		WHERE NAME = 'Active clients no insurance'
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
		'Active clients no insurance'
		,'Active clients no insurance'
		,'N'
		,NULL
		,NULL
		,@ReportServerId
		,'/' + @ReportServerPath + '/' + 'ActiveClientsWit NoInsurance'
		)
END