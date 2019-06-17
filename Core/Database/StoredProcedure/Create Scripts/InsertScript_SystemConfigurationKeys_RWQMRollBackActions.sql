IF NOT EXISTS (SELECT [KEY] FROM SystemConfigurationKeys WHERE [KEY] = 'RWQMRollBackActions' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value, [Description],AcceptedValues,Modules, Comments)
    VALUES ('RWQMRollBackActions', '10', 'The X days to roll back the RWQM Actions', 'Numeric Numbers', 'RWQM Work Queue List page', 'Only allowed to roll back actions completed in the last (X) days where X is a system configuration key. ')
END
GO
