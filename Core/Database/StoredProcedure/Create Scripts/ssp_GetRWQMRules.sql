
/****** Object:  StoredProcedure [dbo].[ssp_GetRWQMRules]    Script Date: 05/07/2017 16:14:52 ******/
IF EXISTS (SELECT
    *
  FROM sys.objects
  WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ssp_GetRWQMRules]')
  AND TYPE IN (
  N'P'
  , N'PC'
  ))
  DROP PROCEDURE [dbo].[ssp_GetRWQMRules]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetRWQMRules] 5 Script Date: 05/07/2017 16:14:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetRWQMRules] (@RWQMRuleId int)
AS
-- =============================================
-- Author:		Ajay 
-- Create date: 05/07/2017
-- Description:	Get Saved RWQM Rules data.AHN-Customization: #44
-- Modified By			Date				Reason 	
-- Alok Kumar			12/Feb/2018			Added columns in table RWQMRules & few new table based on the requirements.	Ref: Task##44 AHN-Customization.

-- =============================================
BEGIN TRY
  ---------RWQMRules	              
  SELECT
    RWQMR.RWQMRuleId,
    RWQMR.CreatedBy,
    RWQMR.CreatedDate,
    RWQMR.ModifiedBy,
    RWQMR.ModifiedDate,
    RWQMR.RecordDeleted,
    RWQMR.DeletedBy,
    RWQMR.DeletedDate,
    RWQMR.StartDate,
    RWQMR.EndDate,
    RWQMR.Active,
    RWQMR.RWQMRuleName,
    RWQMR.RulePriority,
    RWQMR.RuleType,
    RWQMR.RuleNumberOfDays,
    RWQMR.Balance,
    RWQMR.IncludeFlaggedCharges,
    RWQMR.DaysToDueDate,
    RWQMR.DaysToOverdue,
    CASE
      WHEN RWQMR.AllChargeActions IS NULL THEN 'Y'
      ELSE RWQMR.AllChargeActions
    END AS AllChargeActions,
    RWQMR.ChargesActions,
    CASE
      WHEN RWQMR.AllChargeStatuses IS NULL THEN 'Y'
      ELSE RWQMR.AllChargeStatuses
    END AS AllChargeStatuses,
    RWQMR.ChargeStatuses,
    CASE
      WHEN RWQMR.AllFinancialAssignments IS NULL THEN 'Y'
      ELSE RWQMR.AllFinancialAssignments
    END AS AllFinancialAssignments,
    RWQMR.FinancialAssignments,
    RWQMR.Comments,
    RWQMR.ChargePayerType,
	Case when RWQMR.AllChargePayerType is null then 'Y' else AllChargePayerType end as AllChargePayerType,
	RWQMR.ChargePayer,
	Case when RWQMR.AllChargePayer is null then 'Y' else AllChargePayer end as AllChargePayer,
	RWQMR.ChargePlan,
	Case when RWQMR.AllChargePlan is null then 'Y' else AllChargePlan end as AllChargePlan,
	RWQMR.ChargeProgram,
	Case when RWQMR.AllChargeProgram is null then 'Y' else AllChargeProgram end as AllChargeProgram,
	RWQMR.ChargeLocation,
	Case when RWQMR.AllChargeLocation is null then 'Y' else AllChargeLocation end as AllChargeLocation,
	RWQMR.ChargeServiceArea,
	Case when RWQMR.AllChargeServiceArea is null then 'Y' else AllChargeServiceArea end as AllChargeServiceArea,
	RWQMR.ChargeProcedureCode,
	Case when RWQMR.AllChargeProcedureCode is null then 'Y' else AllChargeProcedureCode end as AllChargeProcedureCode,
	RWQMR.ChargeErrorReason,
	Case when RWQMR.AllChargeErrorReason is null then 'Y' else AllChargeErrorReason end as AllChargeErrorReason,
	RWQMR.ChargeAdjustmentCodes,
	Case when RWQMR.AllChargeAdjustmentCodes is null then 'Y' else AllChargeAdjustmentCodes end as AllChargeAdjustmentCodes,
	RWQMR.ChargeResponsibleDays,
	RWQMR.ClientFinancialResponsible,
	RWQMR.FinancialAssignmentChargeClientLastNameFrom,
	RWQMR.FinancialAssignmentChargeClientLastNameTo,
	RWQMR.IncludeClientCharge,
	RWQMR.ExcludePayerCharges,
	RWQMR.DefaultStaffId,
	CASE WHEN ISNULL(S.DisplayAs, '') != '' Then S.DisplayAs
			ELSE (S.LastName + ', ' + S.FirstName)
	END AS DefaultStaffName
  FROM RWQMRules RWQMR
  Left Join Staff S ON S.StaffId = RWQMR.DefaultStaffId AND S.Active = 'Y' AND ISNULL(S.RecordDeleted,'N')='N'
  WHERE ISNULL(RWQMR.RecordDeleted, 'N') = 'N'
  AND RWQMR.RWQMRuleId = @RWQMRuleId

  --RWQMRuleChargeActions
  SELECT
    RWQMRCA.RWQMRuleChargeActionId,
    RWQMRCA.CreatedBy,
    RWQMRCA.CreatedDate,
    RWQMRCA.ModifiedBy,
    RWQMRCA.ModifiedDate,
    RWQMRCA.RecordDeleted,
    RWQMRCA.DeletedBy,
    RWQMRCA.DeletedDate,
    RWQMRCA.RWQMRuleId,
    RWQMRCA.RWQMActionId
  FROM RWQMRuleChargeActions RWQMRCA --join RWQMActions RWQMA on RWQMA.RWQMActionId = RWQMRCA.RWQMActionId 
  WHERE RWQMRCA.RWQMRuleId = @RWQMRuleId
  AND ISNULL(RWQMRCA.RecordDeleted, 'N') = 'N'



  --RWQMRuleChargeStatuses		
  SELECT
    RWQMACS.RWQMRuleChargeStatusId,
    RWQMACS.CreatedBy,
    RWQMACS.CreatedDate,
    RWQMACS.ModifiedBy,
    RWQMACS.ModifiedDate,
    RWQMACS.RecordDeleted,
    RWQMACS.DeletedBy,
    RWQMACS.DeletedDate,
    RWQMACS.RWQMRuleId,
    RWQMACS.ChargeStatuses
  FROM RWQMRuleChargeStatuses RWQMACS
  WHERE RWQMACS.RWQMRuleId = @RWQMRuleId
  AND ISNULL(RWQMACS.RecordDeleted, 'N') = 'N'


  --RWQMRuleFinancialAssignments		
  SELECT
    RWQMRFA.RWQMRuleFinancialAssignmentId,
    RWQMRFA.CreatedBy,
    RWQMRFA.CreatedDate,
    RWQMRFA.ModifiedBy,
    RWQMRFA.ModifiedDate,
    RWQMRFA.RecordDeleted,
    RWQMRFA.DeletedBy,
    RWQMRFA.DeletedDate,
    RWQMRFA.RWQMRuleId,
    RWQMRFA.FinancialAssignmentId
  FROM RWQMRuleFinancialAssignments RWQMRFA
  WHERE RWQMRFA.RWQMRuleId = @RWQMRuleId
  AND ISNULL(RWQMRFA.RecordDeleted, 'N') = 'N'
  



	-- RWQMRulePayerTypes
	SELECT RWQMRPT.RWQMRulePayerTypeId
		,RWQMRPT.CreatedBy
		,RWQMRPT.CreatedDate
		,RWQMRPT.ModifiedBy
		,RWQMRPT.ModifiedDate
		,RWQMRPT.RecordDeleted
		,RWQMRPT.DeletedBy
		,RWQMRPT.DeletedDate
		,RWQMRPT.RWQMRuleId
		,RWQMRPT.PayerTypeId
	FROM RWQMRulePayerTypes RWQMRPT
	--JOIN RWQMRules RWQMR ON RWQMR.RWQMRuleId = RWQMRPT.RWQMRuleId AND AND ISNULL(RWQMR.RecordDeleted, 'N') = 'N'
	WHERE RWQMRPT.RWQMRuleId = @RWQMRuleId
	AND ISNULL(RWQMRPT.RecordDeleted, 'N') = 'N'
  
  
	-- RWQMRulePayers
	SELECT RWQMRP.RWQMRulePayerId
		,RWQMRP.CreatedBy
		,RWQMRP.CreatedDate
		,RWQMRP.ModifiedBy
		,RWQMRP.ModifiedDate
		,RWQMRP.RecordDeleted
		,RWQMRP.DeletedBy
		,RWQMRP.DeletedDate
		,RWQMRP.RWQMRuleId
		,RWQMRP.PayerId
	FROM RWQMRulePayers RWQMRP
	WHERE RWQMRP.RWQMRuleId = @RWQMRuleId
	AND ISNULL(RWQMRP.RecordDeleted, 'N') = 'N'
  
  
	-- RWQMRulePlans
	SELECT RWQMRPS.RWQMRulePlanId
		,RWQMRPS.CreatedBy
		,RWQMRPS.CreatedDate
		,RWQMRPS.ModifiedBy
		,RWQMRPS.ModifiedDate
		,RWQMRPS.RecordDeleted
		,RWQMRPS.DeletedBy
		,RWQMRPS.DeletedDate
		,RWQMRPS.RWQMRuleId
		,RWQMRPS.CoveragePlanId
	FROM RWQMRulePlans RWQMRPS
	WHERE RWQMRPS.RWQMRuleId = @RWQMRuleId
	AND ISNULL(RWQMRPS.RecordDeleted, 'N') = 'N'
  

	-- RWQMRulePrograms
	SELECT RWQMRPRG.RWQMRuleProgramId
		,RWQMRPRG.CreatedBy
		,RWQMRPRG.CreatedDate
		,RWQMRPRG.ModifiedBy
		,RWQMRPRG.ModifiedDate
		,RWQMRPRG.RecordDeleted
		,RWQMRPRG.DeletedBy
		,RWQMRPRG.DeletedDate
		,RWQMRPRG.RWQMRuleId
		,RWQMRPRG.ProgramId
	FROM RWQMRulePrograms RWQMRPRG
	WHERE RWQMRPRG.RWQMRuleId = @RWQMRuleId
	AND ISNULL(RWQMRPRG.RecordDeleted, 'N') = 'N'


	-- RWQMRuleLocations
	SELECT RWQMRL.RWQMRuleLocationId
		,RWQMRL.CreatedBy
		,RWQMRL.CreatedDate
		,RWQMRL.ModifiedBy
		,RWQMRL.ModifiedDate
		,RWQMRL.RecordDeleted
		,RWQMRL.DeletedBy
		,RWQMRL.DeletedDate
		,RWQMRL.RWQMRuleId
		,RWQMRL.LocationId
	FROM RWQMRuleLocations RWQMRL
	WHERE RWQMRL.RWQMRuleId = @RWQMRuleId
	AND ISNULL(RWQMRL.RecordDeleted, 'N') = 'N'
  
  
	-- RWQMRuleServiceAreas
	SELECT RWQMRSA.RWQMRuleServiceAreaId
		,RWQMRSA.CreatedBy
		,RWQMRSA.CreatedDate
		,RWQMRSA.ModifiedBy
		,RWQMRSA.ModifiedDate
		,RWQMRSA.RecordDeleted
		,RWQMRSA.DeletedBy
		,RWQMRSA.DeletedDate
		,RWQMRSA.RWQMRuleId
		,RWQMRSA.ServiceAreaId
	FROM RWQMRuleServiceAreas RWQMRSA
	WHERE RWQMRSA.RWQMRuleId = @RWQMRuleId
	AND ISNULL(RWQMRSA.RecordDeleted, 'N') = 'N'
  
  
 	-- RWQMRuleProcedureCodes
	SELECT RWQMRPC.RWQMRuleProcedureCodeId
		,RWQMRPC.CreatedBy
		,RWQMRPC.CreatedDate
		,RWQMRPC.ModifiedBy
		,RWQMRPC.ModifiedDate
		,RWQMRPC.RecordDeleted
		,RWQMRPC.DeletedBy
		,RWQMRPC.DeletedDate
		,RWQMRPC.RWQMRuleId
		,RWQMRPC.ProcedureCodeId
	FROM RWQMRuleProcedureCodes RWQMRPC
	WHERE RWQMRPC.RWQMRuleId = @RWQMRuleId
	AND ISNULL(RWQMRPC.RecordDeleted, 'N') = 'N'



 	-- RWQMRuleErrorReasons
	SELECT RWQMRER.RWQMRuleErrorReasonId
		,RWQMRER.CreatedBy
		,RWQMRER.CreatedDate
		,RWQMRER.ModifiedBy
		,RWQMRER.ModifiedDate
		,RWQMRER.RecordDeleted
		,RWQMRER.DeletedBy
		,RWQMRER.DeletedDate
		,RWQMRER.RWQMRuleId
		,RWQMRER.ErrorReasonId
	FROM RWQMRuleErrorReasons RWQMRER
	WHERE RWQMRER.RWQMRuleId = @RWQMRuleId
	AND ISNULL(RWQMRER.RecordDeleted, 'N') = 'N'


 	-- RWQMRuleAdjustmentCodes
	SELECT RWQMRAC.RWQMRuleAdjustmentCodeId
		,RWQMRAC.CreatedBy
		,RWQMRAC.CreatedDate
		,RWQMRAC.ModifiedBy
		,RWQMRAC.ModifiedDate
		,RWQMRAC.RecordDeleted
		,RWQMRAC.DeletedBy
		,RWQMRAC.DeletedDate
		,RWQMRAC.RWQMRuleId
		,RWQMRAC.AdjustmentCodes
	FROM RWQMRuleAdjustmentCodes RWQMRAC
	WHERE RWQMRAC.RWQMRuleId = @RWQMRuleId
	AND ISNULL(RWQMRAC.RecordDeleted, 'N') = 'N'



END TRY
BEGIN CATCH
  DECLARE @Error varchar(8000)

  SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_GetRWQMRules') + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY()) + '*****' + CONVERT(varchar, ERROR_STATE())

  RAISERROR (
  @Error
  ,-- Message text.                                    
  16
  ,-- Severity.                                    
  1 -- State.                                    
  );
END CATCH
GO