-- Insert script for Core global Codes (4279) and New Core Coverage Plan Rules 
-- Journey Customizations #1200

IF NOT EXISTS (
            SELECT 1
            FROM GlobalCodes
            WHERE  GlobalCodeID = 4279
            )
BEGIN
      SET IDENTITY_INSERT dbo.GlobalCodes ON
      INSERT INTO GlobalCodes (
            GlobalCodeId
            ,Category 
			,CodeName 
			,Code 
			,Active 
			,CannotModifyNameOrDelete 

            )
      VALUES (
            4279
            ,'COVERAGEPLANRULE' 
			,'For these procedures, remove all Modifiers from Claims' 
			,'THESEPROCEDURESREMOVEALLMODIFIERSFROMCLAIMS' 
			,'Y' 
			,'Y'

            )
      SET IDENTITY_INSERT dbo.GlobalCodes OFF   
END         
 

----New Core CoveragePlanRuleType

IF NOT EXISTS (
            SELECT 1
            FROM CoveragePlanRuleTypes
            WHERE RuleTypeId = 4279
            )
BEGIN
 SET IDENTITY_INSERT dbo.CoveragePlanRuleTypes ON
	INSERT INTO dbo.CoveragePlanRuleTypes
	( RuleTypeId ,
	RuleTypeName ,
	RuleVariesBy
	)
	SELECT 4279 ,
	'For these procedures, remove all Modifiers from Claims' ,
	6441 --Procedure Code
	
 SET IDENTITY_INSERT dbo.CoveragePlanRuleTypes OFF

 END
 
 
 
 
 



 
 


