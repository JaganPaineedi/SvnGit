
/********************************************************************************
Script:		InsertScriptReports_NDNWEnh_12.sql

Date		Author			Purpose
2019-04-26	jstedman		Created ; NDNW Enhancements 12

*********************************************************************************/

-- insert new report in reports table.
DECLARE
	@PathName varchar(50)
	, @ReportServerId int
	, @ReportName varchar(250) = 'Clients without an Active Treatment Plan'
;

----Test Code
--BEGIN TRAN;

IF NOT EXISTS (
	SELECT	*
	FROM	dbo.Reports AS r
	WHERE	( r.RecordDeleted IS NULL OR r.RecordDeleted = 'N' )
			AND r.Name = @ReportName
)
BEGIN

	SELECT	@PathName = sc.Value
	FROM	dbo.SystemConfigurationKeys AS sc
	WHERE	( sc.RecordDeleted IS NULL OR sc.RecordDeleted = 'N' )
			AND sc.[key] = 'ReportFolderName'
	;

	SELECT	TOP(1)
			@ReportServerId = rs.ReportServerId
	FROM	dbo.ReportServers AS rs
	WHERE	( rs.RecordDeleted IS NULL OR rs.RecordDeleted = 'N' )
	ORDER BY
			rs.ReportServerId
	;

	----Test Code
	--SELECT @PathName AS [@PathName], @ReportServerId AS [@ReportServerId]
	--;

	INSERT INTO dbo.Reports (
		ParentFolderId
		, ReportServerId
		, Name
		, [Description]
		, IsFolder
		, ReportServerPath
	)
	VALUES (
		NULL
		, @ReportServerId
		, @ReportName
		, ''
		, 'N'
		, '/' + @PathName + '/RDLClientsWithoutTreatmentPlan'
	)
	;

END;

----Test Code
--SELECT	*
--FROM	dbo.Reports AS r
--WHERE	r.Name = @ReportName
--;

----Test Code
--ROLLBACK TRAN;

GO

/*
--Test Code

DECLARE @MaxId int;

SELECT @MaxId = MAX(ReportId) FROM dbo.Reports;
SELECT @MaxId AS [@MaxId];
IF @MaxId IS NULL
BEGIN
	SET @MaxId = 0;
	SELECT @MaxId AS [New @MaxId];
END;

DBCC CHECKIDENT(Reports, RESEED, @MaxId);

*/

