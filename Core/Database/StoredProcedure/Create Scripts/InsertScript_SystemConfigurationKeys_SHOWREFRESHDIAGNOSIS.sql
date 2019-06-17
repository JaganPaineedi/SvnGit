--System configuration key 'SHOWREFRESHDIAGNOSIS' for Key Point Support Go Live# 1176

IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'SHOWREFRESHDIAGNOSIS'
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
		,AcceptedValues
		,[Description]
		,AllowEdit
		,ShowKeyForViewingAndEditing
		)
	SELECT suser_sname()
		,GETDATE()
		,suser_sname()
		,GETDATE()
		,NULL
		,NULL
		,NULL
		,'SHOWREFRESHDIAGNOSIS'
		,'N'
		,'Y,N,NULL'
		,'Refresh the Diagnosis Grid'
		,'Y'
		,'Y'
END
