
-- Date: 3/3/2016
-- Task: Ionia - Support #245

IF NOT EXISTS (SELECT * FROM SystemConfigurationKeys WHERE [Key]='AllowDeleteOnNewFlowsheetEntry')
INSERT INTO SystemConfigurationKeys ([Key],Value,[Description],AcceptedValues,ShowKeyForViewingAndEditing,Modules)
VALUES ('AllowDeleteOnNewFlowsheetEntry','N','This Key will hide/show Trash Can Icon (delete button) on New Entry Flow Sheet screen','Y,N','Y','Flow Sheet')

Update SystemConfigurationKeys Set Value='N' WHERE [Key]='AllowDeleteOnNewFlowsheetEntry'