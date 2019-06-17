IF NOT EXISTS (SELECT 1 FROM SystemConfigurationKeys WHERE [Key] = 'LIMITNUMBEROFSERVICESTOBEBUNDLED')
BEGIN
	INSERT INTO SystemConfigurationKeys ([Key],Value, Description,AcceptedValues,Screens)
	VALUES ('LIMITNUMBEROFSERVICESTOBEBUNDLED','5000','To control how many services are allowed to be bundled at one time', 'Numeric, non nullabe','Office - Services List page')
END