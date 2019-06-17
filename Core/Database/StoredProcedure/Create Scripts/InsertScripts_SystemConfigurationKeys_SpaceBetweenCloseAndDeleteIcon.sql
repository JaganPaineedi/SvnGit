
IF NOT EXISTS (SELECT [KEY] FROM SystemConfigurationKeys WHERE [KEY] = 'SPACEBETWEENCLOSEANDDELETEICON' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value, [Description], AcceptedValues, Modules)
    VALUES ('SPACEBETWEENCLOSEANDDELETEICON', 'N', 'This key configuration is used to Moving trash icon away from the "X"(close) icon for the mobile devices (Android and IOS devices).', 'Y,N, Default value: N',  'All Documents and Details screen')
 END
GO


