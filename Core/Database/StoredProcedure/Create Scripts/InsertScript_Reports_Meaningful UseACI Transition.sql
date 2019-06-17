
DECLARE @ReportServerId INT
DECLARE @ReportServerPath VARCHAR(250)
SET @ReportServerId=(SELECT TOP 1 ReportServerId FROM ReportServers WHERE ISNULL(RecordDeleted,'N')='N')
SET @ReportServerPath=(SELECT ReportFolderName FROM SystemConfigurations)
IF NOT EXISTS(SELECT 1 FROM ReportS WHERE  Name='Meaningful Use / ACI Transition' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
INSERT INTO ReportS
(Name,
 [Description],
IsFolder,
ParentFolderId,
AssociatedWith,
ReportServerId,
ReportServerPath
)

VALUES( 
'Meaningful Use / ACI Transition',
'Meaningful Use / ACI Transition',
'N',
NULL,
NULL,
@ReportServerId,
'/'+@ReportServerPath+'/'+'RDLClinicianMeaningFulUseFromMUThird'
)
END


