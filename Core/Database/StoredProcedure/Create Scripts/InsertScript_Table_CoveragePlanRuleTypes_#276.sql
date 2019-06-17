IF NOT EXISTS(SELECT 1 FROM CoveragePlanRuleTypes WHERE RuleTypeId=4274)
 BEGIN
    SET IDENTITY_INSERT CoveragePlanRuleTypes ON
      INSERT INTO CoveragePlanRuleTypes(RuleTypeId,RuleTypeName,RuleVariesBy) 
      VALUES(4274,'No authorization required if service is created from claim.',6441)
    SET IDENTITY_INSERT CoveragePlanRuleTypes OFF
 END
 
 
