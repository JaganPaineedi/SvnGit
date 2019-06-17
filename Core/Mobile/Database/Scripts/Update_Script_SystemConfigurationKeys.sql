
IF EXISTS
(
    SELECT 1
    FROM SystemConfigurationKeys
    WHERE [Key] = 'SETMOBILEGLOBALCODES'
)
    BEGIN
        UPDATE SystemConfigurationKeys
          SET
              [Value] = 'ADDRESSTYPE,PHONETYPE,SERVICESTATUS,APPOINTMENTTYPE,SHOWTIMEAS,RELATIONSHIP'
        WHERE [Key] = 'SETMOBILEGLOBALCODES';
    END;