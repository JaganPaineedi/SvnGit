IF NOT EXISTS(SELECT TOP 1 * FROM SystemConfigurationKeys WHERE [Key]='ShowRDLAfterSign' AND ISNULL(RecordDeleted,'N')='N')
	BEGIN
		INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[Key]
		,Value
		,[Description]
		,AcceptedValues
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'ShowRDLAfterSign'
		,'N'
		,'ShowRDLAfterSign'
		,'Y,N'
		)
	
	END
	
      
IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowRDLAfterSign')  AND [ScreenId] = 104) 
      BEGIN 
            INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
            VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowRDLAfterSign'),104)
      END

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowRDLAfterSign')  AND [ScreenId] = 106) 
      BEGIN 
            INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
            VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'ShowRDLAfterSign'),106)
      END
