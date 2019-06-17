DECLARE @DBNAME VARCHAR(maX)
SET @DBNAME = CASE DB_NAME()
			 WHEN 'NDNWTrainSmartCare'
				THEN 'Train'
			 WHEN 'NDNWProdSmartCare'
				THEN 'Prod'
		  END
---update systemreports with NDNW custom payment receipt report
UPDATE SystemReports
SET ReportURL = 'http://FARMDB30/ReportServer_NDNW?/NDNW/' + @DBNAME + 'Documents/NDNW Print Payment Receipt&rs:Command=Render&rc:Parameters=false&PaymentId=<PaymentId>'
WHERE SystemReportId = (SELECT SystemReportId FROM SystemReports WHERE ISNULL(RecordDeleted,'N')='N' AND ReportName = 'Print Payment Receipt')