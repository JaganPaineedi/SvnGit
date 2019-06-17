/********************************************/
/*Insert script to add key TimeSheetLockTime */
/*******************************************/
IF NOT EXISTS (SELECT 1 FROM SystemConfigurationKeys WHERE [Key]='TimeSheetLockTime')
INSERT INTO SystemConfigurationKeys ([Key],Value,Description,ShowKeyForViewingAndEditing,Modules)
VALUES ('TimeSheetLockTime',8,'TimeSheet will be disabled','Y','TimeSheet')