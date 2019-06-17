---------------------------------------------------------------------------------------- 
--Author :Vichee 
--Date   :06 , 2016 
--Purpose:To insert into SystemReports Ref Task #92 CEI - Support Go Live 
--Note Update SytemReportURL depends on the environment
---------------------------------------------------------------------------------------- 
SET IDENTITY_INSERT [SystemReports] ON
GO
IF NOT EXISTS(SELECT 1 
              FROM   SystemReports 
              WHERE  SystemReportId = 15 
                    ) 
  BEGIN 
      INSERT INTO SystemReports 
                  (SystemReportId, 
                   ReportName, 
                   ReportURL, 
                   ReportRDL, 
                  Active,
                  AllowAllStaff,
                  UsedInCareManagement) 
      VALUES      (15, 
                   'Print Denial Notices', 
                   '', 
                   '', 
                   'Y',
                   'Y',
                   'Y') 
  END 
  
SET IDENTITY_INSERT [SystemReports] OFF
GO

----Update Query For Report URL

IF EXISTS(SELECT 1 
              FROM   SystemReports 
              WHERE  SystemReportId = 15 and ReportName='Print Denial Notices'
                    ) 
  BEGIN 
      UPDATE SystemReports set ReportURL='<Please Update URL>/Print_Denial_Letters&rs:Command=Render&rc:Parameters=true&DenialLetterId=<DenialLetterId>' where SystemReportId = 15 
  END 



