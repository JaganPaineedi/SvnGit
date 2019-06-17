
-- Partner Solutions - Enhancements #7

-- Insert script for SystemConfigurationKeys AllowOnlyBillingCodesSearch 
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'AllowOnlyBillingCodesSearch'
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
		,'AllowOnlyBillingCodesSearch'
		,'No'
		,'Yes,No'
		,'Read Key as ---  "Allow Only Billing Codes Search"  
		  When the value of the key AllowOnlyBillingCodesSearch is set to "Yes", the system will restrict the Billing Codes displayed when added through pop up window on the Claim Bundles Details. 
		  When we say that the system restricts billing codes, it means only the base billing code without modifier permutations will be displayed.
		  When the value of the key AllowOnlyBillingCodesSearch is set to "No", the system will display all billing codes plus modifier permutations individually. This is current behavior.'
		,'Y'
		,'Claim Bundle Details'
		,NULL
		)
END
