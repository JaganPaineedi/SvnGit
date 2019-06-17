
-- Insert script for SystemConfigurationKeys EvaluateServiceForNonBillableLocationBillingRule    Task: #112 Texas Customizations
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'EvaluateServiceForNonBillableLocationBillingRule'
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
		,'EvaluateServiceForNonBillableLocationBillingRule'
		,'No'
		,'Yes,No'
		,'IF Value is Yes then System will allow running of overnight service complete process for Bllable rule ‘Non Billable Locations’ 
		  IF Values is No  then service complete process without checking any billing rule for  ‘Non Billable Locations’'
		,'Y'
		,'Plan Details'
		)
END

