--5/25/2017 - Robert Caffrey - Harbor Support #1396 - Configuration Key to Include Prescriber License Number of Electronic Scripts 

IF not exists ( select  *
                from    SystemConfigurationKeys
                where   [key] = 'SurescriptsAlwaysSendPrescriberLicense' ) 
  begin
    insert  into [dbo].[SystemConfigurationKeys]
            ([Key],
             [Value],
             [Description],
             [AcceptedValues],
             [ShowKeyForViewingAndEditing],
             [Modules])
    values  ('SurescriptsAlwaysSendPrescriberLicense',
             'N',
             'Always include the Prescriber License Number when sending Electronic Scripts',
             'Y,N',
             'Y',
             'Rx - Surescripts')
            
  end

