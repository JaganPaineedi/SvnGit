IF NOT EXISTS (SELECT 1 FROM SystemConfigurationKeys WHERE [Key] = 'LIMITNUMBEROFSERVICESTOBEERRORED')
BEGIN
	INSERT INTO SystemConfigurationKeys ([Key],Value, Description,AcceptedValues,Screens)
	VALUES ('LIMITNUMBEROFSERVICESTOBEERRORED','50','To control how many services are allowed to be errored at one time', 'Numeric, non nullabe','Office - Services List page')
END