-- Insert script for SystemConfigurationKeys SETSTATUSFORPRIMARYCAREAPPOINTMENTS


Declare @ScreenId Int;
Set @ScreenId = 750

IF NOT EXISTS ( SELECT 1 FROM SystemConfigurationKeys WHERE [Key] = 'SETSTATUSFORPRIMARYCAREAPPOINTMENTS' )
	BEGIN
		INSERT INTO SystemConfigurationKeys (
			CreatedBy
			,CreateDate
			,ModifiedBy
			,ModifiedDate
			,[Key]
			,Value
			,AcceptedValues
			,[Description]
			)
		VALUES (
			SYSTEM_USER
			,CURRENT_TIMESTAMP
			,SYSTEM_USER
			,CURRENT_TIMESTAMP
			,'SETSTATUSFORPRIMARYCAREAPPOINTMENTS'
			,'8038'								-- Category = PCAPPOINTMENTSTATUS And CodeName = Exam Room
			,'GlobalCodes.GlobalCodeId'
			,'It is used to pull Location, Program and Time value from Primary Care Appointment to E&M Code Evaluation pop up, If Exam Room status is selected in Primary Care Appointment screen.'
			)
	END



-- Modules
-------------

IF NOT EXISTS (SELECT 1 FROM Modules WHERE [ModuleName] = 'PrimaryCare') 
	BEGIN
		INSERT [dbo].[Modules] ([ModuleName]) 
		VALUES ('PrimaryCare')
	END


-- ModuleScreens
-------------
IF NOT EXISTS (SELECT 1 FROM ModuleScreens WHERE [ModuleId] = (Select ModuleId from Modules where ModuleName = 'PrimaryCare')  AND [ScreenId] = @ScreenId) 
	BEGIN 
		INSERT [dbo].[ModuleScreens] ([ModuleId], [ScreenId])
		VALUES ((Select ModuleId from Modules where ModuleName = 'PrimaryCare')
		,@ScreenId)
	END


-- ScreenConfigurationKeys
-------------

IF NOT EXISTS (SELECT 1 FROM ScreenConfigurationKeys WHERE [SystemConfigurationKeyId] = (Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'SETSTATUSFORPRIMARYCAREAPPOINTMENTS')  AND [ScreenId] = @ScreenId) 
	BEGIN 
		INSERT [dbo].[ScreenConfigurationKeys] ([SystemConfigurationKeyId], [ScreenId])
		VALUES ((Select SystemConfigurationKeyId from SystemConfigurationKeys where [Key] = 'SETSTATUSFORPRIMARYCAREAPPOINTMENTS')
		,@ScreenId)
	END


