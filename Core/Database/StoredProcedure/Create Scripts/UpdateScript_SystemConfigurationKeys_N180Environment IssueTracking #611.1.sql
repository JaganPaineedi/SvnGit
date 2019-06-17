UPDATE SystemConfigurationKeys
SET 
ShowKeyForViewingAndEditing = 'Y',
AcceptedValues = 'Y,N,NULL'
WHERE [KEY] LIKE '%ShowCMAuthorizationReasonforchange%'
