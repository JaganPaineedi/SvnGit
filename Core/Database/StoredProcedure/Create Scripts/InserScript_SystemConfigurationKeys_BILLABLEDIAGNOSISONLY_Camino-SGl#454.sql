IF NOT EXISTS (
		SELECT *
		FROM SystemConfigurationKeys
		WHERE [Key] = 'BILLABLEDIAGNOSISONLY'
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
		,'BILLABLEDIAGNOSISONLY'
		,'Y'
		,'This key is used to select either billable or both billable and non billable diagnosis values'
		,'Y,N'
END
