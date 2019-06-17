-- Insert script for Core global Codes (4280 and 6448) and New Core Coverage Plan Rules 
-- Texas Customizations #112

IF NOT EXISTS (
            SELECT 1
            FROM GlobalCodes
            WHERE  GlobalCodeID = 4280
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
            4280
            ,'COVERAGEPLANRULE' 
			,'Non Billable Locations' 
			,'NONBILLABLELOCATIONS' 
			,'Y' 
			,'Y'

            )
      SET IDENTITY_INSERT dbo.GlobalCodes OFF   
END         
 

----New Core CoveragePlanRuleType

IF NOT EXISTS (
            SELECT 1
            FROM CoveragePlanRuleTypes
            WHERE RuleTypeId = 4280
            )
BEGIN
 SET IDENTITY_INSERT dbo.CoveragePlanRuleTypes ON
	INSERT INTO dbo.CoveragePlanRuleTypes
	( RuleTypeId ,
	RuleTypeName ,
	RuleVariesBy
	)
	SELECT 4280 ,
	'Non Billable Locations' ,
	6448 
	
 SET IDENTITY_INSERT dbo.CoveragePlanRuleTypes OFF
 END
 ---Rule type varies by
 IF NOT EXISTS (
            SELECT 1
            FROM GlobalCodes
            WHERE  GlobalCodeID = 6448
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
            6448
            ,'COVERAGEPLANRULEVAR' 
			,'Varies By Location Code' 
			,'VARIESBYLOCATIONCODE' 
			,'Y' 
			,'Y'

            )
      SET IDENTITY_INSERT dbo.GlobalCodes OFF   
END         
 
 


 
 


