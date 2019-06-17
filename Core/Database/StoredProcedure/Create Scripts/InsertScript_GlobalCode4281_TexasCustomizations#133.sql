-- Insert script for Core global Codes (4281 and 6449) and New Core Coverage Plan Rules 
-- Texas Customizations #133

IF NOT EXISTS (
            SELECT 1
            FROM GlobalCodes
            WHERE  GlobalCodeID = 4281
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
            4281
            ,'COVERAGEPLANRULE' 
			,'Only these Programs may provide billable services for these codes' 
			,'Only these Programs may provide billable services for these codes' 
			,'Y' 
			,'Y'

            )
      SET IDENTITY_INSERT dbo.GlobalCodes OFF   
END         
 

----New Core CoveragePlanRuleType

IF NOT EXISTS (
            SELECT 1
            FROM CoveragePlanRuleTypes
            WHERE RuleTypeId = 4281
            )
BEGIN
 SET IDENTITY_INSERT dbo.CoveragePlanRuleTypes ON
	INSERT INTO dbo.CoveragePlanRuleTypes
	( 
		RuleTypeId ,
		RuleTypeName ,
		RuleVariesBy
	)
	VALUES
	 ( 
		 4281 ,
		'Only these Programs may provide billable services for these codes' ,
		 6449 
	)
	
 SET IDENTITY_INSERT dbo.CoveragePlanRuleTypes OFF
 END
 ---Rule type varies by
 IF NOT EXISTS (
            SELECT 1
            FROM GlobalCodes
            WHERE  GlobalCodeID = 6449
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
             6449
            ,'COVERAGEPLANRULEVAR' 
			,'Varies By Program' 
			,'VARIESBYPROGRAM' 
			,'Y' 
			,'Y'

            )
      SET IDENTITY_INSERT dbo.GlobalCodes OFF   
END         
 
 


 
 


