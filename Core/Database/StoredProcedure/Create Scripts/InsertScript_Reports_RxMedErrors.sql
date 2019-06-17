DECLARE @ReportFolderName VARCHAR(MAX);
DECLARE @ReportServerId INT = 1;

SELECT  @ReportServerId = ReportServerId
FROM    dbo.ReportServers
WHERE   ISNULL(RecordDeleted, 'N') = 'N';

SELECT  @ReportFolderName = ReportFolderName
FROM    dbo.SystemConfigurations;

IF @ReportFolderName NOT LIKE '/%'
BEGIN 
 SET @ReportFolderName = '/' + @ReportFolderName
END 


IF NOT EXISTS ( SELECT  1
                FROM    Reports
                WHERE   ReportServerPath = @ReportFolderName + '/RxMedError'
                        AND ISNULL(RecordDeleted, 'N') = 'N' )
    BEGIN
        INSERT  INTO Reports ( IsFolder, Name, ReportServerId, ReportServerPath )
        VALUES  ( 'N', 'Rx Med Errors', @ReportServerId, @ReportFolderName + '/RxMedError' );
    END;	
