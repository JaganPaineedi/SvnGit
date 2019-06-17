if not exists ( select  *
                from    dbo.AdjudicationRules
                where   RuleTypeId = 2582
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
    select  GlobalCodeId,
            CodeName,
            'N',
            'N',
            'P',
            'N',
            30,
            'Y'
    from    dbo.GlobalCodes
    where   GlobalCodeId = 2582
  end;