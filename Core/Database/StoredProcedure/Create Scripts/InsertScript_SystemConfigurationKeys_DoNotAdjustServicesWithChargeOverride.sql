--System configuration key 'DONOTADJUSTSERVICESWITHCHARGEOVERRIDE' for Woods Support Go Live #658


IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'DoNotAdjustServicesWithChargeOverride'
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
		)
	SELECT suser_sname()
		,GETDATE()
		,suser_sname()
		,GETDATE()
		,NULL
		,NULL
		,NULL
		,'DoNotAdjustServicesWithChargeOverride'
		,'N'
		,'Y,N'
		,'if the key is set to "Y", then the adjustments process will not post any adjustments to services that have override charge box checked.'
		,'Y'
END
