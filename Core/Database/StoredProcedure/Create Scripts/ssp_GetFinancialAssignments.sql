
/****** Object:  StoredProcedure [dbo].[ssp_GetFinancialAssignments]    Script Date: 12/15/2014 16:14:52 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ssp_GetFinancialAssignments]')
			AND TYPE IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetFinancialAssignments] 
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetFinancialAssignments]    Script Date: 12/15/2014 16:14:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetFinancialAssignments] (@FinancialAssignmentId INT)
AS
-- =============================================
-- Author:		Veena S Mani
-- Create date: 03/18/2015
-- Description:	Get Saved Financial Assignment data.
--Modified By   Date          Reason
--Veena         22-10-2015    Added payer Type,payer and plan in Payment Tab
--Ajay          16-June-2017  Added FinancialAssignmentAdjustmentCodes table in Charge tab and FinancialAssignmentClinicians table in Service tab
--                            Why: AHN Customization #Task:44		
-- =============================================
BEGIN TRY
---------FinancialAssignments	              
SELECT FA.FinancialAssignmentId,
FA.CreatedBy,
FA.CreatedDate,
FA.ModifiedBy,
FA.ModifiedDate,
FA.RecordDeleted,
FA.DeletedBy,
FA.DeletedDate,
FA.AssignmentName,
FA.Active,
FA.ChargePayerType,
FA.ChargePayer,
FA.ChargePlan,
FA.ChargeProgram,
FA.ChargeLocation,
FA.ChargeServiceArea,
FA.ChargeProcedureCode,
FA.ChargeErrorReason,
FA.ChargeResponsibleDays,
FA.ChargeIncludeClientCharge,
FA.FinancialAssignmentChargeClientLastNameFrom,
FA.FinancialAssignmentChargeClientLastNameTo,
FA.PaymentProgram,
FA.PaymentLocation,
FA.PaymentServiceArea,
FA.PaymentProcedureCode,
FA.PaymentPrimaryClinician,
FA.PaymentDenialReason,
FA.FinancialAssignmentPaymentClientLastNameFrom,
FA.FinancialAssignmentPaymentClientLastNameTo,
FA.ServiceProgram,
FA.ServiceLocation,
FA.ServiceServiceArea,
FA.ServiceProcedureCode,
FA.ServicePrimaryClinician,
FA.ServiceErrorReason,
FA.ServicePayer,
FA.FinancialAssignmentServiceClientLastNameFrom,
FA.FinancialAssignmentServiceClientLastNameTo,
Case when FA.AllChargePayerType is null then 'Y' else AllChargePayerType end as AllChargePayerType,
Case when FA.AllChargePayer is null then 'Y' else AllChargePayer end as AllChargePayer,
Case when FA.AllChargePlan is null then 'Y' else AllChargePlan end as AllChargePlan,
Case when FA.AllChargeProgram is null then 'Y' else AllChargeProgram end as AllChargeProgram,
Case when FA.AllChargeLocation is null then 'Y' else AllChargeLocation end as AllChargeLocation,
Case when FA.AllChargeServiceArea is null then 'Y' else AllChargeServiceArea end as AllChargeServiceArea,
Case when FA.AllChargeProcedureCode is null then 'Y' else AllChargeProcedureCode end as AllChargeProcedureCode,
Case when FA.AllChargeErrorReason is null then 'Y' else AllChargeErrorReason end as AllChargeErrorReason,
Case when FA.AllPaymentProgram is null then 'Y' else AllPaymentProgram end as AllPaymentProgram,
Case when FA.AllPaymentLocation is null then 'Y' else AllPaymentLocation end as AllPaymentLocation,
Case when FA.AllPaymentServiceArea is null then 'Y' else AllPaymentServiceArea end as AllPaymentServiceArea,
Case when FA.AllServiceProgram is null then 'Y' else AllServiceProgram end as AllServiceProgram,
Case when FA.AllServiceLocation is null then 'Y' else AllServiceLocation end as AllServiceLocation,
Case when FA.AllServiceServiceArea is null then 'Y' else AllServiceServiceArea end as AllServiceServiceArea,
Case when FA.AllServiceProcedureCode is null then 'Y' else AllServiceProcedureCode end as AllServiceProcedureCode,
Case when FA.AllServicePrimaryClinician is null then 'Y' else AllServicePrimaryClinician end as AllServicePrimaryClinician,
Case when FA.AllPaymentPrimaryClinician is null then 'Y' else AllPaymentPrimaryClinician end as AllPaymentPrimaryClinician,
--Added by Veen for Adding payer Type,payer and plan in Payment Tab on 22/10/2015
Case when FA.AllPaymentPayerType is null then 'Y' else AllPaymentPayerType end as AllPaymentPayerType,
Case when FA.AllPaymentPayer is null then 'Y' else AllPaymentPayer end as AllPaymentPayer,
Case when FA.AllPaymentPlan is null then 'Y' else AllPaymentPlan end as AllPaymentPlan,
FA.PaymentPayerType,
FA.PaymentPayer,
FA.PaymentPlan,
FA.ListPageFilter,
FA.RevenueWorkQueueManagement,
--RWQMAssigned,
FA.ChargeAdjustmentCodes,
Case when FA.AllChargeAdjustmentCodes is null then 'Y' else AllChargeAdjustmentCodes end as AllChargeAdjustmentCodes,
Case when FA.AllServiceClinicians is null then 'Y' else AllServiceClinicians end as AllServiceClinicians,
FA.RWQMAssignedId,
(CASE WHEN rtrim(ltrim(s.DisplayAs)) IS NULL THEN rtrim(ltrim(s.LastName)) + ', ' + rtrim(s.FirstName)   ELSE rtrim(ltrim(s.DisplayAs))   END) as RWQMAssignedText,
FA.RWQMAssignedBackupId,
(CASE WHEN rtrim(ltrim(S1.DisplayAs)) IS NULL THEN rtrim(ltrim(S1.LastName)) + ', ' + rtrim(S1.FirstName)   ELSE rtrim(ltrim(S1.DisplayAs))   END)  as RWQMAssignedBackupText,
FA.ServiceClinicians, 
FA.ExcludePayerCharges,
FA.ClientFinancialResponsible
FROM FinancialAssignments FA Left Join Staff S ON FA.RWQMAssignedId= s.StaffId
      Left Join Staff S1 ON FA.RWQMAssignedBackupId= s1.StaffId
WHERE ISNULL(FA.RecordDeleted, 'N') = 'N' AND FA.FinancialAssignmentId = @FinancialAssignmentId
		
--FinancialAssignmentErrorReasons
Select FinancialAssignmentErrorReasonId,
FPA.CreatedBy,
FPA.CreatedDate,
FPA.ModifiedBy,
FPA.ModifiedDate,
FPA.RecordDeleted,
FPA.DeletedBy,
FPA.DeletedDate,
FPA.FinancialAssignmentId,
FPA.AssignmentType,
FPA.ErrorReasonId
From FinancialAssignmentErrorReasons FPA join FinancialAssignments FA on FA.FinancialAssignmentId = FPA.FinancialAssignmentId
AND FA.FinancialAssignmentId = @FinancialAssignmentId
AND  ISNULL(FA.RecordDeleted, 'N') = 'N'
AND  ISNULL(FPA.RecordDeleted, 'N') = 'N'

		
--FinancialAssignmentLocations		
Select FinancialAssignmentLocationId,
FPA.CreatedBy,
FPA.CreatedDate,
FPA.ModifiedBy,
FPA.ModifiedDate,
FPA.RecordDeleted,
FPA.DeletedBy,
FPA.DeletedDate,
LocationId,
FPA.FinancialAssignmentId,
AssignmentType
From FinancialAssignmentLocations FPA join FinancialAssignments FA on FA.FinancialAssignmentId = FPA.FinancialAssignmentId
AND FA.FinancialAssignmentId = @FinancialAssignmentId
AND ISNULL(FPA.RecordDeleted, 'N') = 'N'
AND ISNULL(FA.RecordDeleted, 'N') = 'N'

--FinancialAssignmentPayers		
Select FinancialAssignmentPayerId,
FPA.CreatedBy,
FPA.CreatedDate,
FPA.ModifiedBy,
FPA.ModifiedDate,
FPA.RecordDeleted,
FPA.DeletedBy,
FPA.DeletedDate,
PayerId,
FPA.FinancialAssignmentId,
AssignmentType
From FinancialAssignmentPayers FPA join FinancialAssignments FA on FA.FinancialAssignmentId = FPA.FinancialAssignmentId
AND ISNULL(FPA.RecordDeleted, 'N') = 'N'
AND ISNULL(FA.RecordDeleted, 'N') = 'N'
AND FA.FinancialAssignmentId = @FinancialAssignmentId
		
--FinancialAssignmentPayerTypes		
Select FinancialAssignmentPayerTypeId,
FPA.CreatedBy,
FPA.CreatedDate,
FPA.ModifiedBy,
FPA.ModifiedDate,
FPA.RecordDeleted,
FPA.DeletedBy,
FPA.DeletedDate,
FPA.FinancialAssignmentId,
AssignmentType,
PayerTypeId
From FinancialAssignmentPayerTypes FPA join FinancialAssignments FA on FA.FinancialAssignmentId = FPA.FinancialAssignmentId
AND ISNULL(FPA.RecordDeleted, 'N') = 'N'
AND ISNULL(FA.RecordDeleted, 'N') = 'N'
AND FA.FinancialAssignmentId = @FinancialAssignmentId
		
--FinancialAssignmentPlans		
Select FinancialAssignmentPlanId,
FPA.CreatedBy,
FPA.CreatedDate,
FPA.ModifiedBy,
FPA.ModifiedDate,
FPA.RecordDeleted,
FPA.DeletedBy,
FPA.DeletedDate,
CoveragePlanId,
FPA.FinancialAssignmentId,
AssignmentType
From FinancialAssignmentPlans FPA join FinancialAssignments FA on FA.FinancialAssignmentId = FPA.FinancialAssignmentId
AND ISNULL(FPA.RecordDeleted, 'N') = 'N'
AND ISNULL(FA.RecordDeleted, 'N') = 'N'
AND FA.FinancialAssignmentId = @FinancialAssignmentId
		
--FinancialAssignmentPrimaryClinicians		
Select FinancialAssignmentPrimaryClinicianId,
FPA.CreatedBy,
FPA.CreatedDate,
FPA.ModifiedBy,
FPA.ModifiedDate,
FPA.RecordDeleted,
FPA.DeletedBy,
FPA.DeletedDate,
PrimaryClinicianId,
FPA.FinancialAssignmentId,
AssignmentType
From FinancialAssignmentPrimaryClinicians FPA join FinancialAssignments FA on FA.FinancialAssignmentId = FPA.FinancialAssignmentId
AND ISNULL(FPA.RecordDeleted, 'N') = 'N'
AND ISNULL(FA.RecordDeleted, 'N') = 'N'
AND FA.FinancialAssignmentId = @FinancialAssignmentId
		
--FinancialAssignmentProcedureCodes		
Select FinancialAssignmentProcedureCodeId,
FPA.CreatedBy,
FPA.CreatedDate,
FPA.ModifiedBy,
FPA.ModifiedDate,
FPA.RecordDeleted,
FPA.DeletedBy,
FPA.DeletedDate,
ProcedureCodeId,
FPA.FinancialAssignmentId,
AssignmentType
From FinancialAssignmentProcedureCodes FPA join FinancialAssignments FA on FA.FinancialAssignmentId = FPA.FinancialAssignmentId
AND ISNULL(FPA.RecordDeleted, 'N') = 'N'
AND ISNULL(FA.RecordDeleted, 'N') = 'N'
AND FA.FinancialAssignmentId = @FinancialAssignmentId
		
--FinancialAssignmentPrograms		
Select FinancialAssignmentProgramId,
FPA.CreatedBy,
FPA.CreatedDate,
FPA.ModifiedBy,
FPA.ModifiedDate,
FPA.RecordDeleted,
FPA.DeletedBy,
FPA.DeletedDate,
ProgramId,
FPA.FinancialAssignmentId,
AssignmentType
From FinancialAssignmentPrograms FPA join FinancialAssignments FA on FA.FinancialAssignmentId = FPA.FinancialAssignmentId
AND ISNULL(FPA.RecordDeleted, 'N') = 'N'
AND ISNULL(FA.RecordDeleted, 'N') = 'N'
AND FA.FinancialAssignmentId = @FinancialAssignmentId


--FinancialAssignmentServiceAreas		
Select FinancialAssignmentServiceAreaId,
FPA.CreatedBy,
FPA.CreatedDate,
FPA.ModifiedBy,
FPA.ModifiedDate,
FPA.RecordDeleted,
FPA.DeletedBy,
FPA.DeletedDate,
ServiceAreaId,
FPA.FinancialAssignmentId,
AssignmentType
From FinancialAssignmentServiceAreas FPA join FinancialAssignments FA on FA.FinancialAssignmentId = FPA.FinancialAssignmentId
AND ISNULL(FPA.RecordDeleted, 'N') = 'N'
AND ISNULL(FA.RecordDeleted, 'N') = 'N'
AND FA.FinancialAssignmentId = @FinancialAssignmentId

--Staff
Select FPA.LastName + ', ' + FPA.FirstName as StaffName,
FPA.StaffId
From 
Staff FPA join FinancialAssignments FA on FA.FinancialAssignmentId = FPA.FinancialAssignmentId
and ISNULL(FPA.RecordDeleted, 'N') = 'N'
		AND FA.FinancialAssignmentId = @FinancialAssignmentId order by StaffName
	
 --FinancialAssignmentAdjustmentCodes		--added by Ajay on  16-June-2017
Select FinancialAssignmentAdjustmentCodeId,
FPA.CreatedBy,
FPA.CreatedDate,
FPA.ModifiedBy,
FPA.ModifiedDate,
FPA.RecordDeleted,
FPA.DeletedBy,
FPA.DeletedDate,
FPA.FinancialAssignmentId,
AdjustmentCodes,
AssignmentType 
From FinancialAssignmentAdjustmentCodes FPA join FinancialAssignments FA on FA.FinancialAssignmentId = FPA.FinancialAssignmentId
AND ISNULL(FPA.RecordDeleted, 'N') = 'N'
AND ISNULL(FA.RecordDeleted, 'N') = 'N'
AND FA.FinancialAssignmentId = @FinancialAssignmentId	 
		
		--FinancialAssignmentClinicians		--added by Ajay on  16-June-2017
Select FinancialAssignmentClinicianId,
FPA.CreatedBy,
FPA.CreatedDate,
FPA.ModifiedBy,
FPA.ModifiedDate,
FPA.RecordDeleted,
FPA.DeletedBy,
FPA.DeletedDate,
FPA.FinancialAssignmentId,
ClinicianId,
AssignmentType 
From FinancialAssignmentClinicians FPA join FinancialAssignments FA on FA.FinancialAssignmentId = FPA.FinancialAssignmentId
AND ISNULL(FPA.RecordDeleted, 'N') = 'N'
AND ISNULL(FA.RecordDeleted, 'N') = 'N'
AND FA.FinancialAssignmentId = @FinancialAssignmentId	
END TRY		
BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetFinancialAssignments') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                                    
			16
			,-- Severity.                                    
			1 -- State.                                    
			);
END CATCH
GO

