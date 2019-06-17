
IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'MobileActivationCode'
)
    BEGIN
        INSERT INTO SystemConfigurationKeys
([Key],
 [Value],
 Description,
 AcceptedValues,
 ShowKeyForViewingAndEditing,
 Comments,
 SourceTableName,
 Modules
)
        VALUES
('MobileActivationCode',
 NULL,
 'This key value will be the activation code used for registering Mobile Device with SmartCare Native Application.',
 NULL,
 'Y',
 'This Key value will be populated from Mobile Central for the particular SmartCare instance. This will help the Administrator user to search for Activation Code and they can provide to the SmartCare users.',
 NULL,
 'MOBILE'
);
    END;