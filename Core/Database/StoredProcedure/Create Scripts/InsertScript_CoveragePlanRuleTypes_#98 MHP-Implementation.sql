 -------------------------------------------------------------------------------------------------------------
 --Author : Suneel.N
 --Date   : 20/06/2017
 --Purpose: Added new custom rule in Plan -Rules tab.Ref #98 MHP - Implementation.
 --------------------------------------------------------------------------------------------------------------

IF NOT EXISTS(SELECT 1 FROM CoveragePlanRuleTypes WHERE RuleTypeId=4275)
 BEGIN
    SET IDENTITY_INSERT CoveragePlanRuleTypes ON
      INSERT INTO CoveragePlanRuleTypes(RuleTypeId,RuleTypeName,RuleVariesBy) 
      VALUES(4275,'Only these degrees may provide billable services for these codes',6447)
    SET IDENTITY_INSERT CoveragePlanRuleTypes OFF
 END
 
 

