IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'MobileCentralServiceUrl'
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
        ('MobileCentralServiceUrl',
         NULL,
         'Service URL for Mobile Central',
         'Y',
         'Service URL for Mobile Central',
         NULL,
         'MOBILE',
		 NULL
        );
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'MobileCentralAuthorityUrl'
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
        ('MobileCentralAuthorityUrl',
         NULL,
         'Authority URL for Mobile Central',
         'Y',
         'Authority URL for Mobile Central',
         NULL,
         'MOBILE',
		 NULL
        );
    END;	
IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'MobileCentralCustomerName'
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
        ('MobileCentralCustomerName',
         NULL,
         'Customer Name value for Mobile Central',
         'Y',
         'Customer Name value for Mobile Central',
         NULL,
         'MOBILE',
		 NULL
        );
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'MobileCentralEnvironmentNum'
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
        ('MobileCentralEnvironmentNum',
         NULL,
         '1 = PROD, 2 = TEST, 3 = QA, 4 = TRAIN, 5 = DEMO, 6 = STAGING, 10 = DEV, 11 = DEV1, 12 = DEV2, 13 = DEV3',
         'Y',
         'Environment Enum value for Mobile Central',
         NULL,
         'MOBILE',
		 NULL
        );
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'MobileCentralApplicationNum'
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
        ('MobileCentralApplicationNum',
         NULL,
         'SHSLOGWeb = 1, SHSLOGJob = 2, SHSLOGWebApi = 3, SHSMOBWeb = 4, SHSMOBJOb = 5, SHSMOBWebApi = 6, SHSMOBXam = 7, SCApi = 8, SCFaxService = 9, Smartcare = 100, SmartcareRx = 125',
         'Y',
         'Environment Enum value for Mobile Central',
         NULL,
         'MOBILE',
		 NULL
        );
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'EnableMobileNotifications'
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
        ('EnableMobileNotifications',
         NULL,
         'To Enable Mobile notification',
         'Y',
         'To Enable Mobile notification',
         NULL,
         'MOBILE',
		 'Yes,No'
        );
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'EnableMobileTFA'
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
        ('EnableMobileTFA',
         NULL,
		 'To Enable Two Factor Authentication',
         'Y',
         'TFA is enabled for the value Yes, disables if the value is No and Remote enables only for Remote access',
         NULL,
         'MOBILE',
		 'Yes,No,Remote'
        );
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'PromptForMobileTFAAfterTheseNumDays'
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
        ('PromptForMobileTFAAfterTheseNumDays',
         1,
		 'Number of days for Authentication promt',
         'Y',
         'Default value is 1. This key means that on my first login I''ll be prompted for TFA. But then remaining logis within the number of days will not require TFA. Value 1 means my first login within the 1 day will need TFA approval, and remaining within that day won''t need TFA approval. This will apply to each staff individually.',
         NULL,
         'MOBILE',
		 'Number'
        );
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'AllowUserToReceiveOTPViaEmail'
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
        ('AllowUserToReceiveOTPViaEmail',
         'Yes',
		 'This is to allow the user to recieve OTP on their email.',
         'Y',
         'Default value is Yes. If it is Yes, user can retrieve their OTP on Email. Otherwise User has to contact administrator to Get the OTP if they don''t have access to Device.',
         NULL,
         'MOBILE',
		 'Yes,No'
        );
    END;	
	