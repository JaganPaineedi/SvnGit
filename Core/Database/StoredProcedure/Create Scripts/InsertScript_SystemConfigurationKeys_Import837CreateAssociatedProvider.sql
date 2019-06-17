  if not exists ( select  *
                from    SystemConfigurationKeys
                where   [key] = 'Import837CreateAssociatedProvider' ) 
  begin
    insert  into [dbo].[SystemConfigurationKeys]
            ([Key],
             [Value],
             [Description],
             [AcceptedValues],
             [ShowKeyForViewingAndEditing],
             [Modules])
    values  ('Import837CreateAssociatedProvider',
             'N',
             'Create a rendering, supervising or ordering provider and associate it with the billing provider.',
             'Y,N',
             'Y',
             'Import 837')
            
  end
