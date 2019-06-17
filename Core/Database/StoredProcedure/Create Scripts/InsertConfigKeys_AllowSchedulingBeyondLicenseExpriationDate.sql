-- Insert script for SystemConfigurationKeys AllowSchedulingBeyondLicenseExpirationDate       MHP Enhancement Task #333
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'AllowSchedulingBeyondLicenseExpirationDate'
					  		
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[Key]
		,[Value]
		,AcceptedValues
		,[Description]
		,AllowEdit
		,Modules
		,Screens
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'AllowSchedulingBeyondLicenseExpirationDate'
		,'0'
		,'Positive Integer (1 through 12, which denotes number of months)'
		,'Read Key as -  Allow Scheduling Beyond License Expiration Date.  
		  When value of the key is set to 0(Zero), the system does not allow providers to schedule appointments beyond their license expiration date in services detail page.
		  When value of the key is set to any number from 1 through 12, the system will allow providers to schedule appointments past the license expiration date till the number of months specified in key.
		  Default value will be 0(Zero). This is the existing system behaviour. In this case, the system does not allow providers to schedule appointments beyond their license expiration date in services detail page'
		,'Y'
		,'Service Details'
		,'Client --> Service Details'
		)
END


