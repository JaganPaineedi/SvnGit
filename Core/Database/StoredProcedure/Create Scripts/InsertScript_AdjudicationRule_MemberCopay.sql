if not exists ( select  *
                from    dbo.AdjudicationRules
                where   RuleTypeId = 2584
                        and isnull(RecordDeleted, 'N') = 'N' )
  begin
    insert  into AdjudicationRules
            (RuleTypeId,
             RuleName,
             SystemRequiredRule,
             Active,
             ClaimLineStatusIfBroken,
             MarkClaimLineToBeWorked,
             ToBeWorkedDays,
             AllInsurers)
    select  2584,
            'Member copay',
            'N',
            'N',
            'D',
            'N',
            30,
            'Y'
  end;

