
IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'SendAdvanceMobileNotificationForFlags'
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
('SendAdvanceMobileNotificationForFlags',
 'Yes',
 'To send Mobile Notification for Client tracking Flags in Advance',
 'Yes,No',
 'Y',
 'If value is set to Yes, send Notification before StartDate and EndDate according to the Value of SendAdvanceMobileNotificationForFlagsNumDays key',
 NULL,
 'MOBILE'
);
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'SendAdvanceMobileNotificationForFlagsNumDays'
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
('SendAdvanceMobileNotificationForFlagsNumDays',
 '7',
 'Set the Number of Days when Flag Notification has to send in Advance',
 'Number',
 'Y',
 'Value of this key will be using to send Flag Notification before the Start and End Date. The default value is 7 that means, 7 days before of start and End date we need to Notify.',
 NULL,
 'MOBILE'
);
    END;