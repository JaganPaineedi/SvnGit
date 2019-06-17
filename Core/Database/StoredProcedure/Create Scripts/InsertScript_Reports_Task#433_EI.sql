
--Task: #433 Engineering Improvement Initiatives- NBL(I) 
--Date: 10/24/2016

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
		WHERE NAME = 'Revert Episode Discharge'
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
		'Revert Episode Discharge'
		,'Revert Episode Discharge'
		,'N'
		,NULL
		,NULL
		,@ReportServerId
		,'/' + @ReportServerPath + '/' + 'RDLRevertEpisodeDischarge'
		)
END