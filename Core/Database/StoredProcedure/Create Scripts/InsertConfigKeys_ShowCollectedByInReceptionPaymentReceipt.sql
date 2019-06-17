-- Insert script for SystemConfigurationKeys ShowCollectedByInReceptionPaymentReceipt   Childrens Services Center-Customizations #20 
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'ShowCollectedByInReceptionPaymentReceipt'
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
		,Screens
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'ShowCollectedByInReceptionPaymentReceipt'
		,'No'
		,'Yes,No'
		,'Read Key as -  "Show Collected By In Reception Payment Receipt" (Collected By is the Logged in Staff Name who collected the money and provided the receipt in Payment Receipt).  
		  When the key value is set as "Yes", Collected By should be displayed in Payment Receipt.Collected By is the Logged in Staff Name who collected the money and provided the 
		  receipt in Payment Receipt. If the Value is set as "No" which is current behavior, then Collected By should not be displayed in Receipt.'
		,'Y'
		,'Reception Payment Receipt'
		,NULL
		)
END
