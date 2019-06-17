IF NOT EXISTS (SELECT [KEY] FROM SystemConfigurationKeys WHERE [KEY] = 'ASSESSMENTDOCUMENTCODEID' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value)
    VALUES ('ASSESSMENTDOCUMENTCODEID', 10018)
END
ELSE
BEGIN
UPDATE SystemConfigurationKeys SET Value =10018 where [Key]='ASSESSMENTDOCUMENTCODEID'
END
GO