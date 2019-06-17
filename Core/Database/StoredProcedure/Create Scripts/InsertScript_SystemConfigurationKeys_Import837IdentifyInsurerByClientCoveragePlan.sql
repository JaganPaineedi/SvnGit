  if not exists ( select  *
                from    SystemConfigurationKeys
                where   [key] = 'Import837IdentifyInsurerByClientCoveragePlan' ) 
  begin
    insert  into [dbo].[SystemConfigurationKeys]
            ([Key],
             [Value],
             [Description],
             [AcceptedValues],
             [ShowKeyForViewingAndEditing],
             [Modules])
    values  ('Import837IdentifyInsurerByClientCoveragePlan',
             'N',
             'Use client coverage history for identifying insurer on a claim.',
             'Y,N',
             'Y',
             'Import 837')
            
  end


