IF NOT EXISTS (
		SELECT *
		FROM SystemConfigurationKeys
		WHERE [Key] = 'ALLOWREFRESHSDIAGNOSISFORCOMPLETEDSERVICE'
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
		)
	SELECT suser_sname()
		,GETDATE()
		,suser_sname()
		,GETDATE()
		,NULL
		,NULL
		,NULL
		,'ALLOWREFRESHSDIAGNOSISFORCOMPLETEDSERVICE'
		,'Y'
END
