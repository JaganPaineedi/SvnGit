--System configuration key 'ShowOnlySelectedFieldsInEMNoteReport' for Project: Texas Customizations #58.6

-- Insert script for SystemConfigurationKeys for the KEY 'ShowOnlySelectedFieldsInEMNoteReport' for Account Period for Selected date


IF NOT EXISTS (
		SELECT *
		FROM SystemConfigurationKeys
		WHERE [Key] = 'ShowOpenFlowSheetButton'
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
		,'ShowOpenFlowSheetButton'
		,'Yes'
		,'Reads as --- "Show Open Flow Sheet Button"
Default Value = Yes.It will show the Open Flow Sheet button
No = It will hide the Open flow sheet button'
		,'Yes,No'
		,'Y'
		,'ColorVitals'
		,'ColorVitals'
END
