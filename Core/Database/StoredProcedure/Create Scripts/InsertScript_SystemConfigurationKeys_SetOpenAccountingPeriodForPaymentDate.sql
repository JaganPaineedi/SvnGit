--System configuration key 'SetLastOpenAccountingPeriodForPaymentDate' for Project: AHN-Customizations Task: 73

-- Insert script for SystemConfigurationKeys for the KEY 'SetLastOpenAccountingPeriodForPaymentDate' for Account Period for Selected date


IF NOT EXISTS (
		SELECT *
		FROM SystemConfigurationKeys
		WHERE [Key] = 'SetLastOpenAccountingPeriodForPaymentDate'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedDate
		,DeletedBy
		,[Key]
		,Value
		,[Description]
		,AcceptedValues
		,AllowEdit
		,Modules
		,Screens
		)
	SELECT suser_sname()
		,GETDATE()
		,suser_sname()
		,GETDATE()
		,NULL
		,NULL
		,NULL
		,'SetLastOpenAccountingPeriodForPaymentDate'
		,'No'
		,'This key SetLastOpenAccountingPeriodForPaymentDate is used to set Open Accounting Period for payment date in the Payments/Adjustments screen. If Key is set to Yes it will set last open accounting period. If Key is set to No it will work as per existing logic. '
		,'Yes,No'
		,'Y'
		,'Payments/Adjustments'
		,'Payments/Adjustments'
		
END
