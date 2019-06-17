-- Mobile - task#6.2
-- Insert script for SystemConfigurationKeys SetGenericMobileNotificationMessageText
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'SetGenericMobileNotificationMessageText'
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
		,'SetGenericMobileNotificationMessageText'
		,'You have a new unread Message'
		,'Customer can provide what content their staff want to receive while sending a notification of type Message'
		,'Read Key as ---  "Set Generic Mobile Notification Message Text"  
		  When there is any new Message created in SmartCare, the corresponding staff will get notification through their 
		  Registered Mobile or Email. We cannot send the actual message content because PHI issue. So this Key can be used 
		  to configure a Generic message for the notification.
		  If we set Value as "You have a new unread Message", staff will receive a notification with a content 
		  "You have a new unread Message".
		  For example, a new message is created for a Staff from SmartCare and the Staff is configured for Push/SMS/Email 
		  notification then Staff will get a Push/SMS/Email with the content ''You have a new unread Message''.'
		,'Y'
		,'MOBILE'
		,NULL
		)
END

-- Insert script for SystemConfigurationKeys SetGenericMobileNotificationMessageTextForAlerts
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'SetGenericMobileNotificationMessageTextForAlerts'
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
		,'SetGenericMobileNotificationMessageTextForAlerts'
		,'You have a new Alert'
		,'Customer can provide what content their staff want to receive while sending a notification of type Alert'
		,'Read Key as ---  "Set Generic Mobile Notification Message Text For Alerts"  
		  When there is any new alert created from our SmartCare, the corresponding staff will get notification through 
		  their Registered Mobile or Email. We cannot send the actual message content because PHI issue. So this Key can be used 
		  to configure a Generic message for the notification.
		  If we set Value as "You have a new Alert", staff will receive a notification with a content "You have a new Alert".
		  For example, a new Alert is created for a Staff from SmartCare and the Staff is enabled Push/SMS/Email notification. 
		  Then Staff will get a Push/SMS/Email with the content "You have a new Alert".'
		,'Y'
		,'MOBILE'
		,NULL
		)
END

-- Insert script for SystemConfigurationKeys SetGenericMobileNotificationMessageTextForFlags
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'SetGenericMobileNotificationMessageTextForFlags'
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
		,'SetGenericMobileNotificationMessageTextForFlags'
		,'You have a new Note'
		,'Customer can provide what content their staff want to receive while sending a notification of type Flag/Note'
		,'Read Key as ---  "Set Generic Mobile Notification Message Text For Flags"  
		  When there is any new Flag created from SmartCare, the assigned staff will get notification through their Registered 
		  Mobile or Email. We cannot send the actual message content because PHI issue. So this Key can be used to configure a 
		  Generic message for the notification.
		  If we set Value as "You have a new Note", staff will receive a notification with a content "You have a new Note".
		  For example, a new Note is assigned for a Staff from SmartCare and the Staff is enabled Push/SMS/Email notification. 
		  Then Staff will get a Push/SMS/Email with the content "You have a new Note".'
		,'Y'
		,'MOBILE'
		,NULL
		)
END

-- Insert script for SystemConfigurationKeys SetFromValueForMobileNotificationMessage
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'SetFromValueForMobileNotificationMessage'
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
		,'SetFromValueForMobileNotificationMessage'
		,'SmartCare'
		,'Customer can provide their organization name for identifying the notification send from'
		,'Read Key as ---  "Set From Value For Mobile Notification Message"  
		  Sending only content will not be good, users cannot understand where from they got the notification.
		  If we set Value as "SmartCare", staff will receive a notification with a content starting with "SmartCare".
		  For example, a new message is created for a Staff from SmartCare and the Staff is enbaled Push/SMS/Email notification. 
		  And customer has set the Value of "MobileNotificationContentFrom" as "SmarCare" 
		  and  "MobileNotificationContentForMessages" as  "You have a new unread Message". 
		  Then Staff will get a Push/SMS/Email with the content "SmartCare : You have a new unread Message".'
		,'Y'
		,'MOBILE'
		,NULL
		)
END
