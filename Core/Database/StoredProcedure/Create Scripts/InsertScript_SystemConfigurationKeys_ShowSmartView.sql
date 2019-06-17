IF NOT EXISTS (
		SELECT *
		FROM SystemConfigurationKeys
		WHERE [Key] = 'ShowSmartView'
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
		)
	SELECT suser_sname()
		,GETDATE()
		,suser_sname()
		,GETDATE()
		,NULL
		,NULL
		,NULL
		,'ShowSmartView'
		,'No'
		,'Configuration Key to Enable or Disable SmartView Feature in SC Application. By Default it is No'
		,'Yes,No'
END 