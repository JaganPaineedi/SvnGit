IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'MOBILECENTRALSERVICEURL'
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
        ('MOBILECENTRALSERVICEURL',
         NULL,
         'Mobile Service URL for Mobile Central',
         'Y',
         'Mobile Service URL for Mobile Central',
         NULL,
         'MOBILE',
		 NULL
        );
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'MOBILECENTRALAUTHORITYURL'
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
        ('MOBILECENTRALAUTHORITYURL',
         NULL,
         'Mobile Authority URL for Mobile Central',
         'Y',
         'Mobile Authority URL for Mobile Central',
         NULL,
         'MOBILE',
		 NULL
        );
    END;	
IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'MOBILECENTRALCUSTOMERNAME'
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
        ('MOBILECENTRALCUSTOMERNAME',
         NULL,
         'Customer value for Mobile Central',
         'Y',
         'Customer value for Mobile Central',
         NULL,
         'MOBILE',
		 NULL
        );
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'MOBILECENTRALENVIRONMENTENUM'
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
        ('MOBILECENTRALENVIRONMENTENUM',
         NULL,
         'Environment Enum value for Mobile Central',
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
    WHERE [Key] = 'MOBILECENTRALAPPLICATIONENUM'
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
        ('MOBILECENTRALAPPLICATIONENUM',
         NULL,
         'Environment Enum value for Mobile Central',
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
    WHERE [Key] = 'ENABLEMOBILENOTIFICATIONS'
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
        ('ENABLEMOBILENOTIFICATIONS',
         NULL,
         'To Enable Mobile notification',
         'Y',
         'To Enable Mobile notification',
         NULL,
         'MOBILE',
		 'Y,N'
        );
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'ENABLEMOBILETFA'
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
        ('ENABLEMOBILETFA',
         NULL,
		 'To Enable Two Factor Authentication',
         'Y',
         'TFA is enabled for the value Y, disables if the value is N and R enables only for Remote access',
         NULL,
         'MOBILE',
		 'Y,N,R'
        );
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'PROMPTDAYSMOBILETFA'
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
        ('PROMPTDAYSMOBILETFA',
         1,
		 'Number of days for Authentication promt',
         'Y',
         'Default value is 1. This key means that on my first login I''ll be prompted for TFA. But then remaining logis within the number of days will not require TFA. Value 1 means my first login within the 1 day will need TFA approval, and remaining within that day won''t need TFA approval. This will apply to each staff individually.',
         NULL,
         'MOBILE',
		 'Y,N'
        );
    END;
	