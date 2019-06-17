
 /* Date		  Author			Purpose  
 22/DEC/2015	  Ravichandra 		what:Save ReportServerPath 
								    why:Customizations: #32 National Health Service Corps Report*/

DECLARE @ReportServerId INT
DECLARE @ReportServerPath VARCHAR(250)
SET @ReportServerId=(SELECT TOP 1 ReportServerId FROM ReportServers WHERE ISNULL(RecordDeleted,'N')='N')
SET @ReportServerPath=(SELECT ReportFolderName FROM SystemConfigurations)
IF NOT EXISTS(SELECT 1 FROM ReportS WHERE  Name='RDLNationalHealthServiceCorps' AND ISNULL(RecordDeleted,'N')='N')
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
'RDLNationalHealthServiceCorps',
'National Health Service Corps Report ',
'N',
NULL,
NULL,
@ReportServerId,
'/'+@ReportServerPath+'/'+'RDLNationalHealthServiceCorps'
)
END
