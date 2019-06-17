IF EXISTS(SELECT * FROM  GlobalCodes WHERE Category='ROIEXPIRATION' AND Code='Revoke')
	BEGIN
		UPDATE Globalcodes SET RecordDeleted='Y' WHERE Category='ROIEXPIRATION' AND Code='Revoke'
	END