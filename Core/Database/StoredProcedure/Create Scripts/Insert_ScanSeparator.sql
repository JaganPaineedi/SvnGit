
IF NOT EXISTS (
		SELECT 1
		FROM Reports
		WHERE [Name] = 'Scan Separator'
			
		)
BEGIN

DECLARE @ReportServerId INT
select Top 1  @ReportServerId=ReportServerId from ReportServers
INSERT INTO [Reports]
           ([Name]
           ,[Description]
           ,[IsFolder]
           ,[ParentFolderId]
           ,[AssociatedWith]
           ,[ReportServerId]
           ,[ReportServerPath]
          
           ,[CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate]
           )
     VALUES
           ('Scan Separator'
           ,'Scan Separator'
           ,'N'
           ,NULL
           ,NULL
           ,@ReportServerId
           ,'/Network180SmartCareQA40/ScanSeparator'
           
           ,'sa'
           ,GETDATE()
           ,'sa'
           ,GETDATE()
         )
           
END
GO


