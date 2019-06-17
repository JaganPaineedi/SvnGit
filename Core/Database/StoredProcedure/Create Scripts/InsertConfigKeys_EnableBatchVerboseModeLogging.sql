-- Insert script for SystemConfigurationKeys EnableBatchVerboseModeLogging   task EI#564 - Implement Verbose Mode Logging in SmartCare Application
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'EnableBatchVerboseModeLogging'
		)
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
		,AllowEdit
		,Modules
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'EnableBatchVerboseModeLogging'
		,'Yes'
		,'Yes,No'
		,'Reads as --- "Enable Batch Verbose Mode Logging", Default Value = Yes. This will make Batch/Bulk entry in base table if this key is set to "Yes". If value No = when this mode is set system will keep updating each and every individual record to the database'
		,'Y'
		,NULL
		)
END

ELSE 
BEGIN
UPDATE SystemConfigurationKeys

SET		Value='Yes'
		,AcceptedValues='Yes,No'
		,[Description]='Reads as --- "Enable Batch Verbose Mode Logging", Default Value = Yes. This will make Batch/Bulk entry in base table if this key is set to "Yes". If value No = when this mode is set system will keep updating each and every individual record to the database'
		,ModifiedBy=SYSTEM_USER
		,ModifiedDate=CURRENT_TIMESTAMP
WHERE [Key] = 'EnableBatchVerboseModeLogging'

END




