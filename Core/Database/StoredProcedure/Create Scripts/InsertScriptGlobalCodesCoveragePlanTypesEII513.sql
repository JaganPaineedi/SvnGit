-- Insert script for Core global Codes (4277 & 4278) and New Core Coverage Plan Rules 
-- Engineering Improvement Initiatives- NBL(I) > Tasks > New Coverage Plan Rule #513

IF NOT EXISTS (
            SELECT 1
            FROM GlobalCodes
            WHERE  GlobalCodeID = 4277
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
            4277
            ,'COVERAGEPLANRULE' 
			,'For these procedures, calculate Billing Code & Units after combining same day services (ignore clinician when bundling)' 
			,'CALCULATEBILLINGCODESUNITSIGNORECLINICIAN' 
			,'Y' 
			,'Y'

            )
      SET IDENTITY_INSERT dbo.GlobalCodes OFF   
END         
 

----New Core CoveragePlanRuleType

IF NOT EXISTS (
            SELECT 1
            FROM CoveragePlanRuleTypes
            WHERE RuleTypeId = 4277
            )
BEGIN
 SET IDENTITY_INSERT dbo.CoveragePlanRuleTypes ON
	INSERT INTO dbo.CoveragePlanRuleTypes
	( RuleTypeId ,
	RuleTypeName ,
	RuleVariesBy
	)
	SELECT 4277 ,
	'For these procedures, calculate Billing Code & Units after combining same day services (ignore clinician when bundling)' ,
	6441 --Procedure Code
	
 SET IDENTITY_INSERT dbo.CoveragePlanRuleTypes OFF

 END
 
 IF NOT EXISTS (
            SELECT 1
            FROM GlobalCodes
            WHERE  GlobalCodeID = 4278
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
            4278
            ,'COVERAGEPLANRULE' 
			,'For these procedures, calculate Billing Code & Units after combining same day services (consider clinician when bundling)' 
			,'CALCULATEBILLINGCODESUNITSCONSIDERCLINICIAN' 
			,'Y' 
			,'Y'

            )
      SET IDENTITY_INSERT dbo.GlobalCodes OFF   
END         
 

----New Core CoveragePlanRuleType

IF NOT EXISTS (
            SELECT 1
            FROM CoveragePlanRuleTypes
            WHERE RuleTypeId = 4278
            )
BEGIN
 SET IDENTITY_INSERT dbo.CoveragePlanRuleTypes ON
	INSERT INTO dbo.CoveragePlanRuleTypes
	( RuleTypeId ,
	RuleTypeName ,
	RuleVariesBy
	)
	SELECT 4278 ,
	'For these procedures, calculate Billing Code & Units after combining same day services (consider clinician when bundling)' ,
	6441 --Procedure Code
	
 SET IDENTITY_INSERT dbo.CoveragePlanRuleTypes OFF

 END
 
 
 
 



 
 


