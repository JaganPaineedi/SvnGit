 -------------------------------------------------------------------------------------------------------------
 --Author : Suneel.N
 --Date   : 13/11/2017
 --Purpose: Changed name of the rule in Plan -Rules tab.Ref #98 MHP - Implementation.
 --------------------------------------------------------------------------------------------------------------

IF EXISTS(SELECT 1 FROM CoveragePlanRuleTypes WHERE RuleTypeId=4275)
 BEGIN
	  UPDATE CoveragePlanRuleTypes SET RuleTypeName = 'Only these degrees may provide billable services for these codes-includes attending'
	  WHERE RuleTypeId = 4275
	  AND RuleTypeName = 'Only these degrees may provide billable services for these codes'
 END
 
IF EXISTS(SELECT 1 FROM GlobalCodes WHERE GlobalCodeId = 4275)
BEGIN
	UPDATE GlobalCodes SET CodeName = 'Only these degrees may provide billable services for these codes-includes attending'
	WHERE GlobalCodeId = 4275
	AND CodeName = 'Only these degrees may provide billable services for these codes'
END