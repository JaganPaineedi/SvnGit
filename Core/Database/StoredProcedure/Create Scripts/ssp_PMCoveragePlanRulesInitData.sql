IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[ssp_PMCoveragePlanRulesInitData]') AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1)
	DROP PROCEDURE ssp_PMCoveragePlanRulesInitData
GO
/****************************************************************************** 
** File: ssp_PMCoveragePlanRulesInitData.sql
** Name: ssp_PMCoveragePlanRulesInitData
** Desc:  
** 
** 
** This template can be customized: 
** 
** Return values: Filter Values - Rules Tab
** 
** Called by: 
** 
** Parameters: 
** Input			Output 
** ----------		----------- 
** CoveragePlanId   Dropdown values for Rules Tab
** Auth: Mary Suma
** Date: 12/05/2011
******************************************************************************* 
** Change History 
******************************************************************************* 
** Date: 			Author: 			Description: 
** 12/05/2011		Mary Suma			Query to Procedures for the Rules Tab
-------- 			-------- 			--------------- 
** 30/09/2011		MSuma				Included Exception Block
** 03/08/2015       Shruthi.S           Added logic to retrieve custom rules.Ref #4 CEI - Customizations.
******************************************************************************/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE ssp_PMCoveragePlanRulesInitData
@CoveragePlanId		INT	
AS
   BEGIN
   BEGIN TRY 
    -- Table 1 All Active Plans with Rules
	Select 
		 distinct CP.CoveragePlanId,
		 CP.DisplayAs AS CoveragePlanName     
	FROM                 
		 CoveragePlans CP        
     JOIN        
        CoveragePlanRules CPR      
        ON         
        CPR.CoveragePlanId = CP.CoveragePlanId 
        
        
	-- Table 2 Coverage Plan Rules  RULES Tab from new Table CoveragePlanRuleType
	--Variables for sysconfig key
	Declare @CustomRuleFlag char(1)
	set @CustomRuleFlag ='N'
	Declare @CustomRule1 int
	Declare @CustomRule2 int
	select @CustomRuleFlag = [Value] from SystemConfigurationKeys where [Key]='XDisplayCustomPlanRules'
	select @CustomRule1 = CT.RuleTypeId from CoveragePlanRuleTypes CT where CT.RuleTypeId  in (SELECT R.IntegerCodeId FROM dbo.ssf_RecodeValuesCurrent('CEICustomRule1') R) and  RuleVariesBy=6441 
	SELECT @CustomRule2 = CT.RuleTypeId from CoveragePlanRuleTypes CT where CT.RuleTypeId  in (SELECT R.IntegerCodeId FROM dbo.ssf_RecodeValuesCurrent('CEICustomRule2') R) and  RuleVariesBy=6441
  
	
	SELECT
		RuleTypeId AS RuleTypeId,
		RuleTypeName AS RuleTypeName,
		RuleVariesBy AS RuleVariesBy
	FROM
		CoveragePlanRuleTypes
	WHERE 
		ISNULL(RecordDeleted,'N')='N' 
        and ((isnull(@CustomRuleFlag,'N') ='N' and (RuleTypeId not in (4272,4273)) ) OR isnull(@CustomRuleFlag,'N') ='Y')
	ORDER BY
		RuleTypeId
	       
        --Table4 Action if Rule is broken
        
       SELECT            
		  GlobalCOdeId AS GlobalCodeId, 
		  COdeName      AS CodeName      
	   FROM            
			GlobalCOdes            
	   WHERE            
			  Active = 'Y'
			  AND 
			  (RecordDeleted='N' or RecordDeleted is null)  
			  AND Category =     'RULEVIOLATIONACTION'    
	ORDER BY            
	   SortOrder,CodeName 
	   
	 END TRY
              
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PMCoveragePlanRulesInitData')                                                                                             
			+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ '*****' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
	END CATCH 
	RETURN
END

GO