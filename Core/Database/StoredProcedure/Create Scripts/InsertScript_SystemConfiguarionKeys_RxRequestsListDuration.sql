IF NOT EXISTS ( SELECT  *
                FROM    SystemConfigurationKeys
                WHERE   [Key] = 'RxRequestsListDuration' )
    BEGIN

        INSERT  INTO SystemConfigurationKeys
                ( [Key] ,
                  [Value] ,
                  [Description] ,
                  [AcceptedValues]
                )
        VALUES  ( 'RxRequestsListDuration' ,
                  '90' ,
                  'Gets all the RxRequest(Refill,Change,Fill) records for this Duration' ,
                  'Numeric Values'
                );
 
    END;