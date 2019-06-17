---------------------------------------------------------------------------------------- 
--Author :Rohith 
--Date   :31 OCT, 2014 
--Purpose:To insert into SystemReports Ref Task #25 CM to SC Project 
---------------------------------------------------------------------------------------- 
DECLARE @SystemReportId Int
SET @SystemReportId = 100

IF NOT EXISTS(SELECT 1 FROM   SystemReports WHERE  SystemReportId = @SystemReportId )
    BEGIN 
		SET IDENTITY_INSERT [SystemReports] ON 
		  INSERT INTO SystemReports 
					  (SystemReportId, 
					   ReportName, 
					   ReportURL, 
					   ReportRDL, 
					  Active,
					  AllowAllStaff,
					  UsedInCareManagement) 
		  VALUES      (@SystemReportId, 
					   'Audit Log', 
					   '<Please Update URL>/Audit Log&rs:Command=Render&rc:Parameters=true&TableName=<TableName>&PrimaryKeyValue=<PrimaryKeyValue>', 
					   '', 
					   'Y',
					   'Y',
					   'Y') 
		SET IDENTITY_INSERT [SystemReports] OFF
    END 
ELSE
	BEGIN
		UPDATE   [SystemReports]
		SET    ReportName = 'Audit Log', 
			   ReportURL= '<Please Update URL>/Audit Log&rs:Command=Render&rc:Parameters=true&TableName=<TableName>&PrimaryKeyValue=<PrimaryKeyValue>', 
			   ReportRDL= '',
			   Active='Y',
			   AllowAllStaff='Y',
			   UsedInCareManagement='Y'
	   WHERE SystemReportId = @SystemReportId
	END
GO 




