  if not exists ( select  *
                from    dbo.AdjudicationRules
                where   RuleTypeId = 2551
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
    select  2551,
            'Third Party Plan is fully responsible',
            'N',
            'N',
            'D',
            'N',
            30,
            'Y'
  end;