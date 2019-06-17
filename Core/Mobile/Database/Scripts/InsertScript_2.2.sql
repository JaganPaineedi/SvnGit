IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'LogCentralUrl'
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
        ('LogCentralUrl',
         NULL,
         'URL for Log Central',
         'Y',
         'URL for Log Central',
         NULL,
         'MOBILE',
		 NULL
        );
    END;
	
IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'ResourceOwnerGrantSecretForLogCentral'
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
        ('ResourceOwnerGrantSecretForLogCentral',
         NULL,
         'Secret key used for logging in Log Central',
         'Y',
         'Secret key used for logging in Log Central',
         NULL,
         'MOBILE',
		 NULL
        );
    END;

IF EXISTS
(
    SELECT *
    FROM SystemConfigurationKeys
    WHERE [key] = 'EnableMobileTFA'
)
    BEGIN
        UPDATE SystemConfigurationKeys
          SET 
              Description = 'This key is used for enable/disable 2FA feature. Before enabling the configuration for remote staff or all staff please ensure that the staff have updated notification types setup in their staff details, such as phonenumber, email. If they don''t have valid phone or email on file they may not receive 2FA notification and hence may not be able to log in to the application.'
        WHERE [key] = 'EnableMobileTFA';
    END;
