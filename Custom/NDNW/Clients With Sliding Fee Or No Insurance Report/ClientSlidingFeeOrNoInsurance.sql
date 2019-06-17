DECLARE @DBName VARCHAR(MAX) = CASE DB_NAME()
						  WHEN 'NDNWProdSmartcare'
							 THEN '/NDNW/Prod'
						  WHEN 'NDNWTrainSmartCare'
							 THEN '/NDNW/Train'
						END

IF NOT EXISTS (SELECT 1 FROM dbo.Reports r WHERE r.Name = 'Currently Active Clients with a Sliding Fee or No Insurance' 
									   AND r.ReportServerPath = @DBName + 'Documents/ClientSlidingFeeOrNoInsurance'
									   AND ISNULL(r.RecordDeleted,'N')='N'
									   )
BEGIN 
INSERT INTO dbo.Reports (Name,ReportServerId,ReportServerPath,IsFolder)
VALUES
('Currently Active Clients with a Sliding Fee or No Insurance',2,@DBName + 'Documents/ClientSlidingFeeOrNoInsurance','N')
END 