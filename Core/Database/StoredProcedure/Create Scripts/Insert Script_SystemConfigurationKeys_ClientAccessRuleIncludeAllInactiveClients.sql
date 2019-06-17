if not exists ( select  *
                from    SystemConfigurationKeys
                where   [key] = 'ClientAccessRuleDaysAfterProgramDischarge' ) 
  begin
    insert  into [dbo].[SystemConfigurationKeys]
            ([Key],
             [Value],
             [Description],
             [AcceptedValues],
             [ShowKeyForViewingAndEditing],
             [Modules])
    values  ('ClientAccessRuleDaysAfterProgramDischarge',
             '0',
             'Number of days a clinician has access to a client after the client has been discharged from a program they shared',
             null,
             'Y',
             'Permissions - Client Access')
            
  end

  if not exists ( select  *
                from    SystemConfigurationKeys
                where   [key] = 'ClientAccessRuleIncludeAllInactiveClients' ) 
  begin
    insert  into [dbo].[SystemConfigurationKeys]
            ([Key],
             [Value],
             [Description],
             [AcceptedValues],
             [ShowKeyForViewingAndEditing],
             [Modules])
    values  ('ClientAccessRuleIncludeAllInactiveClients',
             'N',
             'Include all inactive clients for staff with All Clients access permission',
             'Y,N',
             'Y',
             'Permissions - Client Access')
            
  end


