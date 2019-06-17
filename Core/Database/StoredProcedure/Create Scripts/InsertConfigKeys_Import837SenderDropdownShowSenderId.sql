-- 	Heartland East - EIT #48 837 Sender:  UPI number

  if not exists ( select  *
                from    SystemConfigurationKeys
                where   [key] = 'Import837SenderDropdownShowSenderId' ) 
  begin
    insert  into [dbo].[SystemConfigurationKeys]
            ([Key],
             [Value],
             [Description],
             [AcceptedValues],
             [ShowKeyForViewingAndEditing],
             [Modules])
    values  ('Import837SenderDropdownShowSenderId',
             'N',
             'Show Sender ID next to Sender Name in Sender dropdown',
             'Y,N',
             'Y',
             'Import 837')
            
  end