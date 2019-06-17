-- Add-On Code: no corresponding base claim line found
if not exists ( select  *
                from    dbo.AdjudicationRules
                where   RuleTypeId = 2586
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
    select  gc.GlobalCodeId,
            gc.CodeName,
            'N',
            'N',
            'P',
            'N',
            30,
            'Y'
    from    GlobalCodes gc
    where   gc.GlobalCodeId = 2586
  end
go

-- Add-On Code: corresponding base claim line has not been approved
if not exists ( select  *
                from    dbo.AdjudicationRules
                where   RuleTypeId = 2587
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
    select  gc.GlobalCodeId,
            gc.CodeName,
            'N',
            'N',
            'P',
            'N',
            30,
            'Y'
    from    GlobalCodes gc
    where   gc.GlobalCodeId = 2587
  end
go