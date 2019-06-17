--Insert Script for SystemConfigurationKeys to Disable SSID On School DistrictAssignment, Disable when value is 'Y'
--PEP-Customizations: #10208

IF NOT EXISTS (SELECT * FROM SystemConfigurationKeys WHERE [Key] = 'DisableSSIDOnSchoolDistrictAssignment')
BEGIN
	INSERT INTO SystemConfigurationKeys ([Key],Value)
	VALUES ('DisableSSIDOnSchoolDistrictAssignment','N')
END