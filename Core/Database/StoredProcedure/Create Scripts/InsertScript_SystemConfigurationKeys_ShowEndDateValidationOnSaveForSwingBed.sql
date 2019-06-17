--What : Implemented the functionality for End date validation.When the value of the key 'ShowEndDateValidationOnSaveForSwingBed' is set to 'Yes', then validation is required for End date on save of Swing Bed.
--       When the value of the key 'ShowEndDateValidationOnSaveForSwingBed' is set to 'No', then Validation of End Date is not required on save of Swing Bed.
--Why  : The end date validation is implemented as part of Renaissance Dev items. Per task description the end date is not required.When end date is null then it will show the bed census bed drop-down. for Comprehensive-Environment Issues Tracking #568
IF NOT EXISTS (
		SELECT 1
		FROM dbo.SystemConfigurationKeys
		WHERE [Key] = 'ShowEndDateValidationOnSaveForSwingBed'
		)
BEGIN
	INSERT INTO [SystemConfigurationKeys] (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[Key]
		,[Value]
		,[Description]
		,[AcceptedValues]
		,[Modules]
		,[Screens]
		,[AllowEdit]
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'ShowEndDateValidationOnSaveForSwingBed'
		,'Yes'
		,'Read AS "Show End Date Validation On Save For Swing Bed" Default value = No.IF Value is No then Validation of End Date is not required on save of Swing Bed 
		  IF Value is Yes then validation is required for End date(Current Behaviour) '
		,'Yes,No'
		,'Swing Bed'
		,'Census Management – Swing Bed'
		,'Y'
		)
END
