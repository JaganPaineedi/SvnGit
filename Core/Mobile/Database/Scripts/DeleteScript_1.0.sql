
IF EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'MobileCentralEnvironmentNum'
)
    BEGIN
        DELETE FROM SystemConfigurationKeys
        WHERE [Key] = 'MobileCentralEnvironmentNum';
    END;
IF EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'MobileCentralApplicationNum'
)
    BEGIN
        DELETE FROM SystemConfigurationKeys
        WHERE [Key] = 'MobileCentralApplicationNum';
    END;
IF EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'MobileCentralCustomerName'
)
    BEGIN
        DELETE FROM SystemConfigurationKeys
        WHERE [Key] = 'MobileCentralCustomerName';
    END;