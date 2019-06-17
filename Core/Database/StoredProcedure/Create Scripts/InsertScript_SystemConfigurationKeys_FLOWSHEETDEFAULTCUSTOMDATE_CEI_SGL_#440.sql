IF NOT EXISTS (
		SELECT *
		FROM SystemConfigurationKeys
		WHERE [Key] = 'FLOWSHEETDEFAULTCUSTOMDATE'
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
		,'FLOWSHEETDEFAULTCUSTOMDATE'
		,'12'
END
ELSE
BEGIN
 UPDATE SystemConfigurationKeys SET CreatedBy = suser_sname(),CreateDate = GETDATE(),ModifiedBy = suser_sname(),ModifiedDate = GETDATE(),[Key] = 'FLOWSHEETDEFAULTCUSTOMDATE',Value = '12' WHERE [Key] = 'FLOWSHEETDEFAULTCUSTOMDATE'
END
