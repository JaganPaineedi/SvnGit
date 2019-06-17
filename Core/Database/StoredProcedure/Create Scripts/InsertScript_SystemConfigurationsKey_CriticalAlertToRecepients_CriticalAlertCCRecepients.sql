IF NOT EXISTS ( SELECT  *
                FROM    SystemConfigurationKeys
                WHERE   [Key] = 'CriticalAlertToRecipients' )
    BEGIN

        INSERT  INTO SystemConfigurationKeys
                ( [Key] ,
                  [Value] ,
                  [Description] ,
                  [AcceptedValues]
                )
        VALUES  ( 'CriticalAlertToRecipients' ,
                  'USDev@streamlinehealthcare.com' ,
                  'Enter semicolon seperated EmailId to whom the Alerts need to be sent.Ex-Recipient1@gmail.com; Recipient2@gmail.com' ,
                  'EmailId'
                );
 
    END;



IF NOT EXISTS ( SELECT  *
                FROM    SystemConfigurationKeys
                WHERE   [Key] = 'CriticalAlertCCRecipients' )
    BEGIN

        INSERT  INTO SystemConfigurationKeys
                ( [Key] ,
                  [Value] ,
                  [Description] ,
                  [AcceptedValues]
                )
        VALUES  ( 'CriticalAlertCCRecipients' ,
                  'noc@streamlinehealthcare.com' ,
                  'Enter semicolon seperated EmailId to whom the Alerts need to copied. Ex-Recipient1@gmail.com; Recipient12@gmail.com' ,
                  'EmailId'
                );
     END;

 IF NOT EXISTS ( SELECT  *
                FROM    SystemConfigurationKeys
                WHERE   [Key] = 'CriticalAlertSetUpDateTime' )
    BEGIN

        INSERT  INTO SystemConfigurationKeys
                ( [Key] ,
                  [Value] ,
                  [Description] ,
                  [AcceptedValues]
                )
        VALUES  ( 'CriticalAlertSetUpDateTime' ,
                   GETDATE() ,
                  'The CriticalAlert Process was setup On this DateTime.' ,
                  'DateTime'
                );
    END;


