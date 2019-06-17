-- Insert script for SystemConfigurationKeys ConsiderZeroDollarPaymentsWhenExcludingPaidServicesFromReallocation     AHN-SGL#337
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'ConsiderZeroDollarPaymentsWhenExcludingPaidServicesFromReallocation'
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
		,ShowKeyForViewingAndEditing
		,Modules
		,Screens
		,Comments 
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'ConsiderZeroDollarPaymentsWhenExcludingPaidServicesFromReallocation'
		,'No'
		,'Yes/No'
		,'Read Key as --Consider Zero Dollar Payments When Excluding Paid Services From Reallocation. 
			ConsiderZeroDollarPaymentsWhenExcludingPaidServicesFromReallocation is set to ''Yes'' the system will exclude services having a 0$ payment.
			ConsiderZeroDollarPaymentsWhenExcludingPaidServicesFromReallocation is set to ''No'' the system will ignore this key (current behavior)'
		,'Y'
		,'Y'
		,'Reallocation'
		,NULL
		,NULL
		)
END



