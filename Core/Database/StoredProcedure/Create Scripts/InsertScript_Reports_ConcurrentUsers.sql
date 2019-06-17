
INSERT INTO dbo.Reports ( Name, Description, IsFolder, ParentFolderId, AssociatedWith, ReportServerId, ReportServerPath )
SELECT 'Concurrent Users',NULL,'N',NULL,NULL,(SELECT TOP 1
											  a.ReportServerId
											  FROM dbo.ReportServers AS a
											  WHERE ISNULL(a.RecordDeleted,'N')='N'
											  ),(SELECT ReportFolderName FROM dbo.SystemConfigurations) + '\ConcurrentUsers.rdl'
											  WHERE NOT EXISTS( SELECT 1
																FROM Reports AS r
																WHERE r.ReportServerPath LIKE '%ConcurrentUsers.rdl'
																AND ISNULL(r.RecordDeleted,'N')='N'
																)