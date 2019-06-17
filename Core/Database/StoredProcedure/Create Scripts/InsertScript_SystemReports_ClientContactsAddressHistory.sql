IF(NOT(EXISTS(SELECT * FROM SystemReports WHERE SystemReportId = 1105)))
      BEGIN   
      SET IDENTITY_INSERT [dbo].[SystemReports] ON
        INSERT INTO [SystemReports] ([SystemReportId],[ReportName],[ReportURL],[PageId],[Active],[Description],[ReportCategory],[ReportSubCategory],[AllowAllStaff],[UsedInPracticeManagement],[UsedInCareManagement],[RowIdentifier],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedDate],[DeletedBy])
        VALUES(1105,'ClientContactsHistory','.../ClientContactsAddressHistory&rs:Command=Render&rc:Parameters=False&ClientId=<ClientId>',NULL,'Y',NULL,NULL,NULL,'Y',NULL,NULL,'8F693577-BD7F-467A-AF49-311EE5592B65','sa','Dec  4 2010  5:08:52:230PM','sa','Dec  4 2010  5:08:52:230PM',NULL,NULL,NULL)
      SET IDENTITY_INSERT [dbo].[SystemReports] OFF
    END
    
