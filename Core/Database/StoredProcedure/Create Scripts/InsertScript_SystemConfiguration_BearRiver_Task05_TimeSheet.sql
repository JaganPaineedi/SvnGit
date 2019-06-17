IF NOT EXISTS (SELECT 1 FROM SystemConfigurationKeys WHERE [Key]='AdminDisableTimeSheetAfterNumberOfDay')
INSERT INTO SystemConfigurationKeys ([Key],Value,Description,ShowKeyForViewingAndEditing,Modules)
VALUES ('AdminDisableTimeSheetAfterNumberOfDay',20,'TimeSheet will be disabled for Admin Role','Y','TimeSheet')


IF NOT EXISTS (SELECT 1 FROM SystemConfigurationKeys WHERE [Key]='UserDisableTimeSheetAfterNumberOfDay')
INSERT INTO SystemConfigurationKeys ([Key],Value,Description,ShowKeyForViewingAndEditing,Modules)
VALUES ('UserDisableTimeSheetAfterNumberOfDay',10,'TimeSheet will be disabled for User Role','Y','TimeSheet')