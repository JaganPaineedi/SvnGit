DECLARE @ReportServerId INT = 1;
DECLARE @ReportFolderName VARCHAR(max);

SELECT @ReportServerId = ReportServerId
FROM dbo.ReportServers
WHERE ISNULL(RecordDeleted,'N')='N'

SELECT @ReportFolderName = ReportFolderName
FROM dbo.SystemConfigurations

IF @ReportFolderName NOT LIKE '/%'
BEGIN

SELECT @ReportFolderName = '/' + @ReportFolderName;
END
IF @ReportFolderName NOT LIKE '%/'
BEGIN

SELECT @ReportFolderName = @ReportFolderName + '/';
END

INSERT INTO dbo.Reports
        ( 
          ReportServerId ,
          Name ,
          [Description] ,
          IsFolder ,
          ReportServerPath 
        )
SELECT @ReportServerId,
'Electronic Prescription Status',
'',
'N',
@ReportFolderName + 'RDLPrescriptionStatus'
WHERE NOT EXISTS (SELECT 1
				  FROM Reports AS r
				  WHERE r.ReportServerPath LIKE '%RDLPrescriptionStatus'
				  AND ISNULL(r.RecordDeleted,'N')='N'
				  )