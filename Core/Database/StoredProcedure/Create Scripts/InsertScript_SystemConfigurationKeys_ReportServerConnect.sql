IF NOT EXISTS(SELECT TOP 1 * FROM SystemConfigurationKeys WHERE [Key]='ReportServerConnect' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[Key]
		,Value
		,[Description]
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'ReportServerConnect'
		,''
		,'ReportServerConnect'
		)
	
	END
	
      
IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ReportServerConnect')  AND [ScreenId] = 104) 
      BEGIN 
            INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
            VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ReportServerConnect'),104)
      END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ReportServerConnect')  AND [ScreenId] = 106) 
      BEGIN 
            INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
            VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ReportServerConnect'),106)
      END
