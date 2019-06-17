-- insert script for GlobalCodes and AdjudicationRules
-- Network 180 – Customizations - #69 -Budget Caps – Backend
set identity_insert GlobalCodes on

if not exists ( select  *
                from    GlobalCodes
                where   GlobalCodeId = 2583 ) 
  begin
    
    insert  into GlobalCodes
            (GlobalCodeId,
             Category,
             CodeName,
             Active,
             CannotModifyNameOrDelete)
    values  (2583,
             'DENIALREASON',
             'Claim line''s approved amount is over budget',
             'Y',
             'N')
  
    
  end



set identity_insert GlobalCodes off

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
                'Y',
                'Y',
                'P',
                'N',
                30,
                'Y'
        from    GlobalCodes gc
        where   gc.GlobalCodeId in (2583)
                and not exists ( select *
                                 from   dbo.AdjudicationRules ar
                                 where  ar.RuleTypeId = gc.GlobalCodeId
                                        and isnull(ar.RecordDeleted, 'N') = 'N' ) 
