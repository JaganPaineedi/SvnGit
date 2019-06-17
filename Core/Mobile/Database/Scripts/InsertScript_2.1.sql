
IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'EnablePushNotifications'
)
    BEGIN
        INSERT INTO SystemConfigurationKeys
        ([Key],
         [Value],
         Description,
         ShowKeyForViewingAndEditing,
         Comments,
         SourceTableName,
         Modules,
		 AcceptedValues
        )
        VALUES
        ('EnablePushNotifications',
         NULL,
         'Enable push notification based on the Value',
         'Y',
         'User will receive push notification only if this Key Value set to Yes',
         NULL,
         'MOBILE',
		 'Yes,No'
        );
    END;

	IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'EnableSMSNotifications'
)
    BEGIN
        INSERT INTO SystemConfigurationKeys
        ([Key],
         [Value],
         Description,
         ShowKeyForViewingAndEditing,
         Comments,
         SourceTableName,
         Modules,
		 AcceptedValues
        )
        VALUES
        ('EnableSMSNotifications',
         NULL,
         'Enable SMS notification based on the Value',
         'Y',
         'User will receive SMS notifications to the registered Phone number if this Key Value is set to Yes',
         NULL,
         'MOBILE',
		 'Yes,No'
        );
    END;

	IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'EnableEmailNotifications'
)
    BEGIN
        INSERT INTO SystemConfigurationKeys
        ([Key],
         [Value],
         Description,
         ShowKeyForViewingAndEditing,
         Comments,
         SourceTableName,
         Modules,
		 AcceptedValues
        )
        VALUES
        ('EnableEmailNotifications',
         NULL,
         'Enable Email notification based on the Value',
         'Y',
         'User will receive Email notifications to registered Email ID if this Key Value is set to Yes',
         NULL,
         'MOBILE',
		 'Yes,No'
        );
    END;

		IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'ResourceOwnerGrantSecret'
)
    BEGIN
        INSERT INTO SystemConfigurationKeys
        ([Key],
         [Value],
         Description,
         ShowKeyForViewingAndEditing,
         Comments,
         SourceTableName,
         Modules,
		 AcceptedValues
        )
        VALUES
        ('ResourceOwnerGrantSecret',
         NULL,
         'It is a Secret Key for Mobile API',
         'Y',
         'This Key value will be used as an secret key for Mobile API',
         NULL,
         'MOBILE',
		 'AlphaNumeric'
        );
    END;

		IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'CustomerIdentifier'
)
    BEGIN
        INSERT INTO SystemConfigurationKeys
        ([Key],
         [Value],
         Description,
         ShowKeyForViewingAndEditing,
         Comments,
         SourceTableName,
         Modules,
		 AcceptedValues
        )
        VALUES
        ('CustomerIdentifier',
         NULL,
         'This key is used to identify the customer from Mobile Central',
         'Y',
         'The value of this Key will be in GUID format and it is used to configure the Mobile client for sending notifications',
         NULL,
         'MOBILE',
		 'GUID'
        );
    END;

		IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'SmartCareInstanceIdentifier'
)
    BEGIN
        INSERT INTO SystemConfigurationKeys
        ([Key],
         [Value],
         Description,
         ShowKeyForViewingAndEditing,
         Comments,
         SourceTableName,
         Modules,
		 AcceptedValues
        )
        VALUES
        ('SmartCareInstanceIdentifier',
         NULL,
         'This key is used to identify the instance of Smartcare',
         'Y',
         'The value of this Key will be in GUID format and it is used to configure Mobile client for sending the notification to the respective Smartcare instances',
         NULL,
         'MOBILE',
		 'GUID'
        );
    END;