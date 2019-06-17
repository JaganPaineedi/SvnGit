-- Engineering Improvement #555 Change Rule Code Must Exist on TP before creating charge to "Before creating Claim"


-------CoveragePlanRuleTypes

IF  EXISTS(SELECT 1
	FROM CoveragePlanRuleTypes
	WHERE RuleTypeId=4261 AND RuleTypeName='Code must exist on a Treatment Plan before creating a charge')
BEGIN
	UPDATE CoveragePlanRuleTypes 
	SET RuleTypeName='Code must exist on a Treatment Plan before creating a claim',
		ModifiedBy='EII#555',
		ModifiedDate=getdate()
	WHERE RuleTypeId=4261 
	AND RuleTypeName='Code must exist on a Treatment Plan before creating a charge'
END
Go


--------------GlobalCodes

IF EXISTS(SELECT 1
	FROM GlobalCodes
	WHERE GlobalCodeId = 4261 AND CodeName='Code must exist on a Treatment Plan before creating a charge')
BEGIN
	UPDATE GlobalCodes
	SET CodeName ='Code must exist on a Treatment Plan before creating a claim',
		ModifiedBy='EII#555',
		ModifiedDate=getdate()
	WHERE GlobalCodeId = 4261 AND CodeName='Code must exist on a Treatment Plan before creating a charge'
END
GO

