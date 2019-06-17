-- Insert script for SystemConfigurationKeys ExcludeCopayCollectUpfrontClientChargesFromReallocation, Valley - Support Go Live,#319.
IF NOT EXISTS (			
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'ExcludeCopayCollectUpfrontClientChargesFromReallocation'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[Key]
		,Value
		,AcceptedValues
		,[Description]
		,ShowKeyForViewingAndEditing
		,Modules
		,Screens
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'ExcludeCopayCollectUpfrontClientChargesFromReallocation'
		,'N'
		,'Y,N'
		,'When reallocating charges, if a copay collect upfront transfer has been created by service completion, do not reallocate the clients charge'
		,'Y'
		,'Reallocation'
		,NULL
		)
END


