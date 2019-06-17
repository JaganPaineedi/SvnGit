if not exists ( select  *
                from    dbo.SystemConfigurationKeys as sck
                where   sck.[Key] = 'RXEnableFormulary' )
    begin 

        insert  into dbo.SystemConfigurationKeys
                ( [Key]
                , Value
                , Description
                , AcceptedValues
                , ShowKeyForViewingAndEditing
                , Modules
                )
        values  ( 'RXEnableFormulary'  -- Key - varchar(200)
                , 'Y'  -- Value - varchar(max)
                , 'Key used to enable or disable formulary request'  -- Description - type_Comment2
                , 'Y or N'  -- AcceptedValues - varchar(max)
                , 'Y' -- ShowKeyForViewingAndEditing - type_YOrN
                , 'Rx'  -- Modules - varchar(500)
                );

    end;
