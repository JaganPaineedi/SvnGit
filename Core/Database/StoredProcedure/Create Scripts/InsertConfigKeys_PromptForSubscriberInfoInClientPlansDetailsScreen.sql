-- Insert script for SystemConfigurationKeys PromptForSubscriberInfoInClientPlansDetailsScreen   (Harbor - Enhancements #18)
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'PromptForSubscriberInfoInClientPlansDetailsScreen'
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
		,AllowEdit
		,Modules
		,Screens
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'PromptForSubscriberInfoInClientPlansDetailsScreen'
		,'No'
		,'Yes/No'
		,'Read Key As - Prompt For Subscriber Info In Client Plans Details Screen. When the key value is set to "Yes" and DOB, Phone, Gender and Address are missing for the selected Subscriber/Client Contact in Insured Name
        Dropdownlist of Client Plans Details screen, application will display a warning message called "Subscriber is missing DOB, Phone, Gender or Address. Please Update Client Information". When the key value is set to "No"
        then no warning message will be displayed(Current Behaviour)'
		,'Y'
		,'Client Plans'
		,'Client Plans'
		)
END

