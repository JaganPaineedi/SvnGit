IF NOT EXISTS (SELECT 1 FROM SystemConfigurationKeys WHERE [Key]='AuthorizationscreenId')
INSERT INTO SystemConfigurationKeys ([Key],Value,Description,ShowKeyForViewingAndEditing,Modules)
VALUES ('AuthorizationscreenId',21,'Authorization ScreenId for Contact Notes Authorization link','Y','ContactNote')
ELSE
UPDATE SystemConfigurationKeys Set Value=21 WHERE [Key]='AuthorizationscreenId'


