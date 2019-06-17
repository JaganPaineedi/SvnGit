--Added by SuryaBalan on 30-March-2017 for SpringRiver Customizations #11 Turn off validation requiring ICD10 code when family information is entered.
IF NOT EXISTS(SELECT 1 FROM SystemConfigurationKeys WHERE [Key]='HideFamilyHistoryDiseaseConditionValidation')
BEGIN
	INSERT INTO SystemConfigurationKeys([Key],Value,[Description],AcceptedValues,ShowKeyForViewingAndEditing,Modules,Screens,Comments)
	VALUES ('HideFamilyHistoryDiseaseConditionValidation','N','Turn off validation requiring ICD10 code when family information is entered.',NULL,'Y','Assessment',NULL,NULL)
END

