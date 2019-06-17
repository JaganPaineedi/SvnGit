---------------------------------------------------------------------------------------
--Author : Shruthi.S
--Date   : 03/03/2016
--Purpose: Added sys config key to display and hide start date is required validation.Ref : #618.4 Network 180 - Customizations.
---------------------------------------------------------------------------------------

IF EXISTS (SELECT [KEY] FROM SystemConfigurationKeys WHERE [KEY] = 'ProviderInformationStartDateRequired' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
  Update SystemConfigurationKeys set [KEY] = 'REQUIREPROVIDERINFORMATIONSTARTDATE' where [KEY] = 'ProviderInformationStartDateRequired'
END

IF NOT EXISTS (SELECT [KEY] FROM SystemConfigurationKeys WHERE [KEY] = 'REQUIREPROVIDERINFORMATIONSTARTDATE' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value)
    VALUES ('REQUIREPROVIDERINFORMATIONSTARTDATE', 'N')
END

