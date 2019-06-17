/****** Object:  StoredProcedure [dbo].[SSP_PostUpdatePlanDetail]    Script Date: 09/03/2015 12:35:07 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_PostUpdatePlanDetail]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_PostUpdatePlanDetail]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_PostUpdatePlanDetail] @ScreenKeyId INT
	,@StaffId INT
	,@CurrentUser VARCHAR(30)
	,@CustomParameters XML
	/************************************************************************************************                                
**  File:                                                   
**  Name: SSP_PostUpdatePlanDetail  282,563,'kweirick',''                                                
**  Desc: This storeProcedure will executed on post update of Inquiry         
**        
**  Parameters:         
**  Input   @ScreenKeyId INT,        
 @StaffId INT,        
 @CurrentUser VARCHAR(30),        
 @CustomParameters XML         
**  Output     ----------       -----------         
**          
**  Auth:  Pabitra        
**  Date:  Jan 4, 2012        
*************************************************************************************************        
**  Change History          
*************************************************************************************************         
**  Date:			Author:   Description:         
**  --------		--------  -------------------------------------------------------------        
*   5/3/2016		Pabitra	  Camino-Environment issues traking #95      
*   17-June-2016	Gautam    Added code to include Procedurecodes based on Primary rule changes.
							  Task Camino - Support Go Live #3 Admin - Plan Details - Procedure Code Not Binding
*   27 July 2018	Vandana   Added code to include Locations and Degrees based on Primary rule changes.
							  Task Texas -Customizations #112:  Admin - Plan Details - Location Not Binding						  
*************************************************************************************************/
AS
BEGIN
  begin try  
	DECLARE @CoveragePlanId INT
	DECLARE @Usercode Varchar(30)
	
	Select @Usercode = Usercode From Staff where staffid=@StaffId
	
	CREATE TABLE #CoveragePlansUsingTemplates (
		CoverageplanId INT
		,CoverageplanName CHAR(250)
		)

	INSERT INTO #CoveragePlansUsingTemplates (
		CoverageplanId
		,CoverageplanName
		)
	SELECT CoverageplanId
		,CoverageplanName
	FROM CoveragePlans
	WHERE UseBillingRulesTemplateId = @ScreenKeyId
		AND Active = 'Y'

	CREATE TABLE #CoveragePlansRules (
		CoveragePlanId INT
		,RuleTypeId INT
		,RuleName VARCHAR(250)
		,AppliesToAllProcedureCodes CHAR(1)
		,AppliesToAllCoveragePlans CHAR(1)
		,AppliesToAllStaff CHAR(1)
		,AppliesToAllDSMCodes CHAR(1)
		,RuleViolationAction INT
		,AppliesToAllICD9Codes CHAR(1)
		,AppliesToAllICD10Codes CHAR(1)
		,AppliesToAllLocations CHAR(1)   
		)

	INSERT INTO #CoveragePlansRules (
		CoveragePlanId
		,RuleTypeId
		,RuleName
		,AppliesToAllProcedureCodes
		,AppliesToAllCoveragePlans
		,AppliesToAllStaff
		,AppliesToAllDSMCodes
		,RuleViolationAction
		,AppliesToAllICD9Codes
		,AppliesToAllICD10Codes
		,AppliesToAllLocations
		)
	SELECT CoveragePlanId
		,RuleTypeId
		,RuleName
		,AppliesToAllProcedureCodes
		,AppliesToAllCoveragePlans
		,AppliesToAllStaff
		,AppliesToAllDSMCodes
		,RuleViolationAction
		,AppliesToAllICD9Codes
		,AppliesToAllICD10Codes
		,AppliesToAllLocations 
	FROM CoveragePlanRules
	WHERE coverageplanid = @ScreenKeyId
		AND ISNULL(RecordDeleted, 'N') = 'N'

	INSERT INTO CoveragePlanRules (
		CoveragePlanId
		,RuleTypeId
		,RuleName
		,AppliesToAllProcedureCodes
		,AppliesToAllCoveragePlans
		,AppliesToAllStaff
		,AppliesToAllDSMCodes
		,RuleViolationAction
		,AppliesToAllICD9Codes
		,AppliesToAllICD10Codes
		,AppliesToAllLocations 
		)
	SELECT CP.CoveragePlanId AS CoveragePlanId
		,RuleTypeId
		,RuleName
		,AppliesToAllProcedureCodes
		,AppliesToAllCoveragePlans
		,AppliesToAllStaff
		,AppliesToAllDSMCodes
		,RuleViolationAction
		,AppliesToAllICD9Codes
		,AppliesToAllICD10Codes
		,AppliesToAllLocations
	FROM #CoveragePlansRules CPR
	CROSS JOIN #CoveragePlansUsingTemplates CP
	WHERE NOT EXISTS (
			SELECT 1
			FROM CoveragePlanRules CP1
			WHERE CP1.CoveragePlanId = CP.CoveragePlanId
				AND CP1.RuleTypeId = CPR.RuleTypeId
				AND ISNULL(CP1.RecordDeleted, 'N') = 'N'
			)

	UPDATE CP3
	SET CP3.RecordDeleted = 'Y'
		,CP3.DeletedDate = GETDATE()
		,CP3.DeletedBy = @Usercode
	FROM CoveragePlanRules CP3
	WHERE ISNULL(RecordDeleted, 'N') = 'N'
		AND EXISTS (
			SELECT CPR.CoveragePlanRuleId
			FROM CoveragePlanRules CPR
			JOIN #CoveragePlansUsingTemplates CP ON CPR.CoveragePlanId = CP.CoveragePlanId
			WHERE CP3.CoveragePlanRuleId = CPR.CoveragePlanRuleId
				AND ISNULL(CPR.RecordDeleted, 'N') = 'N'
				AND NOT EXISTS (
					SELECT 1
					FROM #CoveragePlansRules CP1
					CROSS JOIN #CoveragePlansUsingTemplates CP2
					WHERE CP.CoveragePlanId = CP2.CoveragePlanId
						AND CPR.RuleTypeId = CP1.RuleTypeId
					)
			)

	DECLARE tCursor CURSOR FAST_FORWARD
	FOR
	SELECT CoverageplanId
	FROM #CoveragePlansUsingTemplates

	OPEN tCursor

	FETCH NEXT
	FROM tCursor
	INTO @CoveragePlanId

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		INSERT INTO CoveragePlanRuleVariables (
			CoveragePlanRuleId
			,ProcedureCodeId
			,CoveragePlanId
			,StaffId
			,AppliesToAllProcedureCodes
			,AppliesToAllCoveragePlans
			,AppliesToAllStaff
			,AppliesToAllDSMCodes
			,DiagnosisCode
			,DiagnosisCodeType
			,AppliesToAllICD9Codes
			,AppliesToAllICD10Codes
			,LocationId
			,AppliesToAllLocations 
			,AppliesToAllDegrees
			,DegreeId 
			)
		SELECT CPR2.CoveragePlanRuleId
			,Base1.ProcedureCodeId
			,@CoveragePlanId
			,Base1.StaffId
			,Base1.AppliesToAllProcedureCodes
			,Base1.AppliesToAllCoveragePlans
			,Base1.AppliesToAllStaff
			,Base1.AppliesToAllDSMCodes
			,Base1.DiagnosisCode
			,Base1.DiagnosisCodeType
			,Base1.AppliesToAllICD9Codes
			,Base1.AppliesToAllICD10Codes
			,Base1.LocationId
			,Base1.AppliesToAllLocations
			,Base1.AppliesToAllDegrees
			,Base1.DegreeId
		FROM CoveragePlanRules CPR2
		JOIN (
			SELECT CPR.CoveragePlanId
				,CPR.RuleTypeId
				,CPRV.CoveragePlanRuleId
				,CPRV.ProcedureCodeId
				,CPRV.StaffId
				,CPRV.AppliesToAllProcedureCodes
				,CPRV.AppliesToAllCoveragePlans
				,CPRV.AppliesToAllStaff
				,CPRV.AppliesToAllDSMCodes
				,CPRV.DiagnosisCode
				,CPRV.DiagnosisCodeType
				,CPRV.AppliesToAllICD9Codes
				,CPRV.AppliesToAllICD10Codes
				,CPRV.LocationId
				,CPRV.AppliesToAllLocations
				,CPRV.AppliesToAllDegrees
				,CPRV.DegreeId
			FROM CoveragePlanRules CPR
			JOIN CoveragePlanRuleVariables CPRV ON CPR.CoveragePlanRuleId = CPRV.CoveragePlanRuleId
			WHERE ISNULL(CPR.RecordDeleted, 'N') = 'N'
				AND ISNULL(CPRV.RecordDeleted, 'N') = 'N'
				AND CPR.CoveragePlanId = @ScreenKeyId
				AND NOT EXISTS (
					SELECT 1
					FROM CoveragePlanRules CPR1
					JOIN CoveragePlanRuleVariables CPRV1 ON CPR1.CoveragePlanRuleId = CPRV1.CoveragePlanRuleId
					WHERE ISNULL(CPR1.RecordDeleted, 'N') = 'N'
						AND ISNULL(CPRV1.RecordDeleted, 'N') = 'N'
						AND CPR1.CoveragePlanId = @CoveragePlanId
						AND CPR1.RuleTypeId = CPR.RuleTypeId
						AND CPRV1.ProcedureCodeId = CPRV.ProcedureCodeId
					)
					AND NOT EXISTS (    
					 SELECT 1    
					 FROM CoveragePlanRules CPR1    
					 JOIN CoveragePlanRuleVariables CPRV1 ON CPR1.CoveragePlanRuleId = CPRV1.CoveragePlanRuleId    
					 WHERE ISNULL(CPR1.RecordDeleted, 'N') = 'N'    
					  AND ISNULL(CPRV1.RecordDeleted, 'N') = 'N'    
					  AND CPR1.CoveragePlanId = @CoveragePlanId    
					  AND CPR1.RuleTypeId = CPR.RuleTypeId    
					  AND CPRV1.LocationId = CPRV.LocationId   
					 )  
					 AND NOT EXISTS (    
					 SELECT 1    
					 FROM CoveragePlanRules CPR1    
					 JOIN CoveragePlanRuleVariables CPRV1 ON CPR1.CoveragePlanRuleId = CPRV1.CoveragePlanRuleId    
					 WHERE ISNULL(CPR1.RecordDeleted, 'N') = 'N'    
					  AND ISNULL(CPRV1.RecordDeleted, 'N') = 'N'    
					  AND CPR1.CoveragePlanId = @CoveragePlanId    
					  AND CPR1.RuleTypeId = CPR.RuleTypeId    
					  AND CPRV1.DegreeId = CPRV.DegreeId   
					 )  
			) Base1 ON Base1.RuleTypeId = CPR2.RuleTypeId
			AND CPR2.CoveragePlanId = @CoveragePlanId
			AND ISNULL(CPR2.RecordDeleted, 'N') = 'N'

		UPDATE CP3
		SET CP3.RecordDeleted = 'Y'
			,CP3.DeletedDate = GETDATE()
			,CP3.DeletedBy = @Usercode
		FROM CoveragePlanRuleVariables CP3 Join CoveragePlanRules CPR3 On 
		CP3.CoveragePlanRuleId = CPR3.CoveragePlanRuleId
		WHERE ISNULL(CP3.RecordDeleted, 'N') = 'N' and ISNULL(CPR3.RecordDeleted, 'N') = 'N'
			AND CPR3.CoveragePlanId = @CoveragePlanId
			AND EXISTS (
				SELECT CPR.CoveragePlanRuleId
				FROM CoveragePlanRules CPR
				JOIN CoveragePlanRuleVariables CPRV ON CPR.CoveragePlanRuleId = CPRV.CoveragePlanRuleId
				WHERE CP3.CoveragePlanRuleId = CPR.CoveragePlanRuleId
					AND CPR.CoveragePlanId = @CoveragePlanId
					AND ISNULL(CPR.RecordDeleted, 'N') = 'N'
					AND ISNULL(CPRV.RecordDeleted, 'N') = 'N')
			AND NOT EXISTS (
						SELECT 1
						FROM CoveragePlanRules CPR1
						JOIN CoveragePlanRuleVariables CPRV1 ON CPR1.CoveragePlanRuleId = CPRV1.CoveragePlanRuleId
						WHERE ISNULL(CPR1.RecordDeleted, 'N') = 'N'
							AND ISNULL(CPRV1.RecordDeleted, 'N') = 'N'
							AND CPR1.CoveragePlanId = @ScreenKeyId
							AND CPR1.RuleTypeId = CPR3.RuleTypeId
							AND CPRV1.ProcedureCodeId = CP3.ProcedureCodeId
						)
			AND NOT EXISTS (    
					  SELECT 1    
					  FROM CoveragePlanRules CPR1    
					  JOIN CoveragePlanRuleVariables CPRV1 ON CPR1.CoveragePlanRuleId = CPRV1.CoveragePlanRuleId    
					  WHERE ISNULL(CPR1.RecordDeleted, 'N') = 'N'    
					   AND ISNULL(CPRV1.RecordDeleted, 'N') = 'N'    
					   AND CPR1.CoveragePlanId = @ScreenKeyId    
					   AND CPR1.RuleTypeId = CPR3.RuleTypeId    
					   AND CPRV1.LocationId = CP3.LocationId 
					  )       
			AND NOT EXISTS (    
					  SELECT 1    
					  FROM CoveragePlanRules CPR1    
					  JOIN CoveragePlanRuleVariables CPRV1 ON CPR1.CoveragePlanRuleId = CPRV1.CoveragePlanRuleId    
					  WHERE ISNULL(CPR1.RecordDeleted, 'N') = 'N'    
					   AND ISNULL(CPRV1.RecordDeleted, 'N') = 'N'    
					   AND CPR1.CoveragePlanId = @ScreenKeyId    
					   AND CPR1.RuleTypeId = CPR3.RuleTypeId    
					   AND CPRV1.DegreeId = CP3.DegreeId 
					  )       

		FETCH NEXT
		FROM tCursor
		INTO @CoveragePlanId
	END

	CLOSE tCursor

	DEALLOCATE tCursor
end try  
   
  begin catch  
    declare @Error varchar(8000)         
    set @Error = convert(varchar, error_number()) + '*****' + convert(varchar(4000), error_message()) + '*****' + isnull(convert(varchar, error_procedure()), 'SSP_PostUpdatePlanDetail') + '*****' + convert(varchar, error_line()) + '*****' + convert(varchar, error_severity()) + '*****' + convert(varchar, error_state())  
    raiserror  
  (  
   @Error, -- Message text.  
   16,  -- Severity.  
   1  -- State.  
  );  
  end catch  	
END
