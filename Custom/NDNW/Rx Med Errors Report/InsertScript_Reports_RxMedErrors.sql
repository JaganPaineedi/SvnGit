DECLARE @DBName VARCHAR(max) = CASE DB_NAME()	
					   WHEN 'NDNWProdSmartcare'
						  THEN '/Prod'
					   WHEN 'NDNWTrainSmartCare'
						  THEN '/Train'
					END
					
IF not EXISTS(SELECT 1 FROM reports WHERE Name = 'Rx Med Errors' AND ReportServerPath = '/NDNW' + @DBName + 'Documents/RxMedError' AND ISNULL(RecordDeleted ,'N')='N')
BEGIN
INSERT INTO Reports(IsFolder,Name,ReportServerId,ReportServerPath) VALUES ('N','Rx Med Errors',2,'/NDNW' + @DBName + 'Documents/RxMedError')
END	

