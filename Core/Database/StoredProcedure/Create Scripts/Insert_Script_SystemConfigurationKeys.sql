IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'SETMOBILEGLOBALCODES'
)
    BEGIN
        INSERT INTO SystemConfigurationKeys
        ([Key],
         [Value],
         Description,
         ShowKeyForViewingAndEditing,
         Comments,
         SourceTableName,
         Modules
        )
        VALUES
        ('SETMOBILEGLOBALCODES',
         'ADDRESSTYPE,PHONETYPE,SERVICESTATUS,APPOINTMENTTYPE,SHOWTIMEAS',
         'GlobalCode list for Mobile',
         'Y',
         'Categories as comma seperated',
         NULL,
         'MOBILE'
        );
    END;
ELSE
    BEGIN
        UPDATE SystemConfigurationKeys
          SET
              [Value] = 'ADDRESSTYPE,PHONETYPE,SERVICESTATUS,APPOINTMENTTYPE,SHOWTIMEAS',
              [Description] = 'GlobalCode list for Mobile',
              Comments = 'Categories as comma seperated',
              ShowKeyForViewingAndEditing = 'Y'
        WHERE [Key] = 'SETMOBILEGLOBALCODES';
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'SETMOBILEIDLETIMEINSECONDS'
)
    BEGIN
        INSERT INTO SystemConfigurationKeys
        ([Key],
         [Value],
         Description,
         ShowKeyForViewingAndEditing,
         Comments,
         SourceTableName,
         Modules
        )
        VALUES
        ('SETMOBILEIDLETIMEINSECONDS',
         '30',
         'Idle Time',
         'Y',
         'Idle Time should be in second',
         NULL,
         'MOBILE'
        );
    END;
BEGIN
    UPDATE SystemConfigurationKeys
      SET
          [Value] = 30,
          [Description] = 'Time Time',
          Comments = 'Idle Time should be in second',
          ShowKeyForViewingAndEditing = 'Y'
    WHERE [Key] = 'SETMOBILEIDLETIMEINSECONDS';
END;
IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'SETMOBILETIMEOUTINSECONDS'
)
    BEGIN
        INSERT INTO SystemConfigurationKeys
        ([Key],
         [Value],
         Description,
         ShowKeyForViewingAndEditing,
         Comments,
         SourceTableName,
         Modules
        )
        VALUES
        ('SETMOBILETIMEOUTINSECONDS',
         '30',
         'Timeout',
         'Y',
         'Idle Timeout should be in second',
         NULL,
         'MOBILE'
        );
    END;
ELSE
    BEGIN
        UPDATE SystemConfigurationKeys
          SET
              [Value] = 30,
              [Description] = 'Timeout',
              Comments = 'Idle Timeout should be in second',
              ShowKeyForViewingAndEditing = 'Y'
        WHERE [Key] = 'SETMOBILETIMEOUTINSECONDS';
    END;
IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'SETMOBILEPAGINGINNUMBERS'
)
    BEGIN
        INSERT INTO SystemConfigurationKeys
        ([Key],
         [Value],
         Description,
         ShowKeyForViewingAndEditing,
         Comments,
         SourceTableName,
         Modules
        )
        VALUES
        ('SETMOBILEPAGINGINNUMBERS',
         50,
         'Paging',
         'Y',
         'Mobile list page paging in numbers',
         NULL,
         'MOBILE'
        );
    END;
ELSE
    BEGIN
        UPDATE SystemConfigurationKeys
          SET
              [Value] = 50,
              [Description] = 'Paging',
              Comments = 'Mobile list page paging in numbers',
              ShowKeyForViewingAndEditing = 'Y'
        WHERE [Key] = 'SETMOBILEPAGINGINNUMBERS';
    END;    

IF NOT EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'SETMOBILEOFFLINECHECKINMILLISECONDS'
)
    BEGIN
        INSERT INTO SystemConfigurationKeys
        ([Key],
         [Value],
         Description,
         ShowKeyForViewingAndEditing,
         Comments,
         SourceTableName,
         Modules
        )
        VALUES
        ('SETMOBILEOFFLINECHECKINMILLISECONDS',
         5000,
         'Offline Check',
         'Y',
         'Mobile Offline Check in milli seconds',
         NULL,
         'MOBILE'
        );
    END;
ELSE
    BEGIN
        UPDATE SystemConfigurationKeys
          SET
              [Value] = 5000,
              [Description] = 'Offline Check',
              Comments = 'Mobile Offline Check in milli seconds',
              ShowKeyForViewingAndEditing = 'Y'
        WHERE [Key] = 'SETMOBILEOFFLINECHECKINMILLISECONDS';
    END;        