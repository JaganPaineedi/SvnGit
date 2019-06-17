IF NOT EXISTS (
		SELECT *
		FROM SystemConfigurationKeys
		WHERE [Key] = 'AllowFutureDateTimeInFlowSheet'
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
		,Modules
		)
	SELECT suser_sname()
		,GETDATE()
		,suser_sname()
		,GETDATE()
		,NULL
		,NULL
		,NULL
		,'AllowFutureDateTimeInFlowSheet'
		,'Yes'
		,'This key will check if future date/time is allowed in record date/time field of flowsheet.'
		,'Yes,No'
		,'Flow Sheet'
END
ELSE
BEGIN
 UPDATE SystemConfigurationKeys SET CreatedBy = suser_sname(),CreateDate = GETDATE(),ModifiedBy = suser_sname(),ModifiedDate = GETDATE(),[Key] = 'AllowFutureDateTimeInFlowSheet',Value = 'Yes',AcceptedValues='Yes,No' WHERE [Key] = 'AllowFutureDateTimeInFlowSheet'
END
