UPDATE dbo.SystemConfigurationKeys
SET Value = 'false'
WHERE [Key] = 'EnableMinification'

UPDATE dbo.SystemConfigurationKeys
SET Value = 'false'
WHERE [Key] = 'EnableBundlingMinification'
