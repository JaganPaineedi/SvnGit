--Added by SuryaBalan on 30-March-2017 for SpringRiver Customizations #11 Turn off validation requiring ICD10 code when family information is entered.
IF NOT EXISTS(SELECT 1 FROM SystemConfigurationKeys WHERE [Key]='EnableSelectReasonValidation')
BEGIN
	INSERT INTO SystemConfigurationKeys([Key],Value,[Description],AcceptedValues,ShowKeyForViewingAndEditing,Modules,Screens,Comments)
	VALUES ('EnableSelectReasonValidation','N','Turn On Validation if the user selects any status other than approved or requested, they will need to select a reason prior to inserting the authorization into the list','N,Y','Y','Authorization Details',NULL,NULL)
END

--update SystemConfigurationKeys set Value='Y' where [Key]='EnableSelectReasonlValidation'