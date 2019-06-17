-- Insert script for SystemConfigurationKeys SETLIMITFORSERVICESELECTIONINPAYMENTPOSTING  for task #306 in Woods - Support Go Live.
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'SETLIMITFORSERVICESELECTIONINPAYMENTPOSTING'
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
		,Modules
		,Comments
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'SETLIMITFORSERVICESELECTIONINPAYMENTPOSTING'
		,'300'
		,'Numeric values less than or equal to 300'
		,'This key is used to set Limit For Service Selection In Payment Posting – Advanced Option'
		,'Payment/Adjustment Posting'
		,'If we select the service more than 300 services that will affect the page performance and it will give database
		 timeout error. To avoid this we have to set service selection limit.'
		)
END
