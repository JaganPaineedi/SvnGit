IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLNationalHealthServiceCorps]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLNationalHealthServiceCorps]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
    
CREATE PROCEDURE [dbo].[csp_RDLNationalHealthServiceCorps]   
(    
@ProviderId INT,    
@DateRangeStartDate DATETIME,    
@DateRangeEndDate DATETIME    
)   
  
/******************************************************************************  
**  File: csp_RDLNationalHealthServiceCorps.sql  
**  Name: csp_RDLNationalHealthServiceCorps  
**  Desc: Tracking total patient visits and insurance type for an annual report.   
**  
**  Return values: <Return Values>  
**  
**  Called by: <Code file that calls>  
**  
**  Parameters:  
**  Input			Output  
**  ProviderId     -----------  
**  StartDate
	EndDate
**  Created By: Revathi  
**  Date:  Dec 21-12-2015  
*******************************************************************************  
**  Change History  
*******************************************************************************  
**  Date:			Author:    Description:  
**  --------		--------    -------------------------------------------  
	Dec 21-12-2015	Revathi		what: National Health Service Corps Report  Created RDL
								why: task #32  New Directions - Customizations

  
*******************************************************************************/  
   
AS        
BEGIN    
BEGIN TRY    
   
DECLARE @SiteName VARCHAR(250)    
 ,@SiteAddress VARCHAR(MAX)    
 ,@DatePrepared VARCHAR(100)    
 ,@RepotingPeriod VARCHAR(max)    
 ,@PreparedBy VARCHAR(100)    
 ,@AnnualPatients INT    
 ,@PatientsWithMedicare INT    
 ,@PatientsWithMedicaid INT    
 ,@PatientsPublicInsurance INT    
 ,@PatientsPrivateInsurance INT    
 ,@PatientsSlidingFeeSchedule INT    
 ,@PatientsSelfPay INT    
 ,@BilledToMedicare DECIMAL(10, 2)    
 ,@ActualAmountMedicareCharges DECIMAL(10, 2)    
 ,@BilledToMedicaid DECIMAL(10, 2)    
 ,@ActualAmountMedicaidCharges DECIMAL(10, 2)    
 ,@BilledToPublicInsurance DECIMAL(10, 2)    
 ,@ActualAmountPublicInsuranceCharges DECIMAL(10, 2)    
 ,@BilledToPrivateInsurance DECIMAL(10, 2)    
 ,@ActualAmountPrivateInsuranceCharges DECIMAL(10, 2)    
 ,@ActualAmountCollectedselfPay DECIMAL(10, 2)    
 ,@ActualAmountselfPay DECIMAL(10, 2)    
 ,@AdjustmentsSlidingFeeScale DECIMAL(10, 2)    
 ,@SelfPayAdjustments DECIMAL(10, 2)    
 ,@TotalSelfPayAdjustments DECIMAL(10, 2)    
 ,@ApplicationsForSlidingFee INT    
 ,@ApplicationsForSlidingFeeNotApproved INT    
    
SET @RepotingPeriod = CONVERT(VARCHAR, @DateRangeStartDate, 101) + ' - ' + CONVERT(VARCHAR, @DateRangeEndDate, 101)    
    
SELECT Top 1 @SiteName = AgencyName    
 ,@SiteAddress = AddressDisplay    
 ,@PreparedBy = AbbreviatedAgencyName    
FROM Agency    
    
SET @DatePrepared = CONVERT(VARCHAR, getdate(), 101)    
    
CREATE TABLE #ActiveClient (ClientID INT,ClientCoveragePlanId int,CoveragePlanId int,MedicaidPlan char(1),MedicarePlan char(1))    
    
CREATE TABLE #ResultSet (    
 SiteName VARCHAR(500)    
 ,SiteAddress VARCHAR(500)    
 ,DatePrepared VARCHAR(500)    
 ,PreparedBy VARCHAR(500)    
 ,RepotingPeriod VARCHAR(max)    
 ,AnnualPatients INT    
 ,PatientsWithMedicare INT    
 ,PatientsWithMedicaid INT    
 ,PatientsPublicInsurance INT    
 ,PatientsPrivateInsurance INT    
 ,PatientsSlidingFeeSchedule INT    
 ,PatientsSelfPay INT    
 ,BilledToMedicare DECIMAL(10, 2)    
 ,ActualAmountMedicareCharges DECIMAL(10, 2)    
 ,BilledToMedicaid DECIMAL(10, 2)    
 ,ActualAmountMedicaidCharges DECIMAL(10, 2)    
 ,BilledToPublicInsurance DECIMAL(10, 2)    
 ,ActualAmountPublicInsuranceCharges DECIMAL(10, 2)    
 ,BilledToPrivateInsurance DECIMAL(10, 2)    
 ,ActualAmountPrivateInsuranceCharges DECIMAL(10, 2)    
 ,ActualAmountCollectedselfPay DECIMAL(10, 2)    
 ,ActualAmountselfPay DECIMAL(10, 2)    
 ,AdjustmentsSlidingFeeScale DECIMAL(10, 2)    
 ,SelfPayAdjustments DECIMAL(10, 2)    
 ,TotalSelfPayAdjustments DECIMAL(10, 2)    
 ,ApplicationsForSlidingFee INT    
 ,ApplicationsForSlidingFeeNotApproved INT    
 )    
    
INSERT INTO #ActiveClient(ClientId,ClientCoveragePlanId,CoveragePlanId,MedicaidPlan,MedicarePlan)    
SELECT DISTINCT C.ClientId,CCP.ClientCoveragePlanId,CP.CoveragePlanId,Cp.MedicaidPlan,Cp.MedicarePlan    
FROM Clients C    
LEFT JOIN ClientCoveragePlans CCP ON CCP.ClientId = C.ClientId    
 AND ISNULL(CCP.RecordDeleted, 'N') = 'N'    
LEFT JOIN CoveragePlans CP ON CP.CoveragePlanId = ccp.CoveragePlanId    
 AND ISNULL(CP.RecordDeleted, 'N') = 'N'    
LEFT JOIN  ClientCoverageHistory CCH ON CCH.ClientCoveragePlanId=CCP.ClientCoveragePlanId    
AND cast(CCH.StartDate as DATE)>=cast(@DateRangeStartDate as date)    
AND cast(CCH.EndDate as DATE)<=cast(@DateRangeEndDate as date)    
WHERE C.Active = 'Y'    
 AND cast(C.CreatedDate AS DATE) <= cast(@DateRangeEndDate AS DATE)    
 AND ISNULL(C.RecordDeleted, 'N') = 'N'    
    
SELECT @AnnualPatients = COUNT(DISTINCT C.ClientId)    
FROM #ActiveClient C    
    
--Number of Patients with MedicarePlan    
SELECT @PatientsWithMedicare = COUNT(DISTINCT C.ClientId)    
FROM #ActiveClient C    
WHERE ISNULL(C.MedicarePlan, 'N') = 'Y'    
--Number of Patients with MedicaidPlan    
SELECT @PatientsWithMedicaid = COUNT(DISTINCT C.ClientId)    
FROM #ActiveClient C    
WHERE ISNULL(C.MedicaidPlan, 'N') = 'Y'    
    
--Number of Patients with Other Public Insurance    
SELECT @PatientsPublicInsurance = COUNT(DISTINCT C.ClientId)    
FROM #ActiveClient C    
WHERE EXISTS (    
  SELECT 1    
  FROM dbo.ssf_RecodeValuesCurrent('XOTHERPUBLICINSURENCE')    
  WHERE C.CoveragePlanId = IntegerCodeId    
  )  
 AND ISNULL(C.MedicaidPlan, 'N') = 'N'    
 AND ISNULL(C.MedicarePlan, 'N') = 'N'      
    
--Number of patients with private insurance    
SELECT @PatientsPrivateInsurance = COUNT(DISTINCT C.ClientId)    
FROM #ActiveClient C    
WHERE NOT EXISTS (    
  SELECT 1    
  FROM dbo.ssf_RecodeValuesCurrent('XOTHERPUBLICINSURENCE')    
  WHERE C.CoveragePlanId = IntegerCodeId    
  )    
 AND ISNULL(C.MedicaidPlan, 'N') = 'N'    
 AND ISNULL(C.MedicarePlan, 'N') = 'N'    
    
--Number of patients with sliding fee schedule     
SELECT @PatientsSlidingFeeSchedule = COUNT(DISTINCT C.ClientId)    
FROM #ActiveClient C    
WHERE EXISTS (    
  SELECT 1    
  FROM CustomClientfees CF    
  WHERE CF.ClientId = C.ClientId    
   AND ISNULL(CF.RecordDeleted, 'N') = 'N'    
   AND CAST(CF.StartDate as DATE)>= cast(@DateRangeStartDate AS DATE)    
    AND CAST(CF.EndDate as DATE)<= cast(@DateRangeEndDate AS DATE)    
  )    
  AND NOT EXISTS (    
  SELECT 1    
  FROM ClientCoveragePlans CCP    
  WHERE CCP.ClientId = C.ClientId    
   AND ISNULL(CCP.RecordDeleted, 'N') = 'N'    
  )    
    
--Number of patients with self pay    
SELECT @PatientsSelfPay = COUNT(DISTINCT C.ClientId)    
FROM #ActiveClient C    
WHERE NOT EXISTS (    
  SELECT 1    
  FROM ClientCoveragePlans CCP    
  WHERE CCP.ClientId = C.ClientId    
   AND ISNULL(CCP.RecordDeleted, 'N') = 'N'    
  )    
     AND  NOT EXISTS (    
  SELECT 1    
  FROM CustomClientfees CF    
  WHERE CF.ClientId = C.ClientId    
    AND CAST(CF.StartDate as DATE)>= cast(@DateRangeStartDate AS DATE)    
    AND CAST(CF.EndDate as DATE)<= cast(@DateRangeEndDate AS DATE)    
   AND ISNULL(CF.RecordDeleted, 'N') = 'N'    
  )    
---Total and Actual amount collected of Medicare charges    
SELECT @BilledToMedicare = cast(SUM(case when ARL.LedgerType = 4201 then  ISNULL(ARL.Amount, 0) else 0 end) AS DECIMAL(18, 2))    
 ,@ActualAmountMedicareCharges = cast(Sum(case when ARL.LedgerType = 4202 then ISNULL(ARL.Amount, 0) else 0 end) AS DECIMAL(18, 2))    
FROM Services S    
JOIN #ACtiveClient C ON C.ClientId = S.ClientId    
LEFT JOIN Charges Ch ON CH.ServiceId = S.ServiceId    
 AND ISNULL(ch.RecordDeleted, 'N') = 'N'    
LEFT JOIN ARLedger ARL ON ARL.ChargeId = CH.ChargeId    
 --AND ARL.LedgerType = 4202    
WHERE ISNULL(C.MedicarePlan, 'N') = 'Y'    
 AND cast(S.DateOfService AS DATE) >= cast(@DateRangeStartDate AS DATE)    
 AND cast(S.DateOfService AS DATE) <= cast(@DateRangeEndDate AS DATE)    
 AND (    
  ISNULL(@ProviderId, 0) = 0    
  OR S.ClinicianId = @ProviderId    
  )    
 AND ISNULL(S.RecordDeleted, 'N') = 'N'    
     
    
---Total and Actual amount collected of Medicaid charges    
SELECT @BilledToMedicaid =cast(SUM(case when ARL.LedgerType = 4201 then  ISNULL(ARL.Amount, 0) else 0 end) AS DECIMAL(18, 2))    
 ,@ActualAmountMedicaidCharges =  cast(Sum(case when ARL.LedgerType = 4202 then ISNULL(ARL.Amount, 0) else 0 end) AS DECIMAL(18, 2))    
FROM Services S    
JOIN #ACtiveClient C ON C.ClientId = S.ClientId    
LEFT JOIN Charges Ch ON CH.ServiceId = S.ServiceId    
 AND ISNULL(ch.RecordDeleted, 'N') = 'N'    
 LEFT JOIN ARLedger ARL ON ARL.ChargeId = CH.ChargeId    
    
WHERE ISNULL(C.MedicaidPlan, 'N') = 'Y'    
 AND cast(S.DateOfService AS DATE) >= cast(@DateRangeStartDate AS DATE)    
 AND cast(S.DateOfService AS DATE) <= cast(@DateRangeEndDate AS DATE)    
 AND (    
  ISNULL(@ProviderId, 0) = 0    
  OR S.ClinicianId = @ProviderId    
  )    
 AND ISNULL(S.RecordDeleted, 'N') = 'N'    
    
--Total dollar amount of other public insurance    
---Actual amount collected from other public insurance    
SELECT @BilledToPublicInsurance = cast(SUM(case when ARL.LedgerType = 4201 then  ISNULL(ARL.Amount, 0) else 0 end) AS DECIMAL(18, 2))    
 ,@ActualAmountPublicInsuranceCharges =  cast(Sum(case when ARL.LedgerType = 4202 then ISNULL(ARL.Amount, 0) else 0 end) AS DECIMAL(18, 2))    
FROM Services S    
JOIN #ACtiveClient C ON C.ClientId = S.ClientId    
LEFT JOIN Charges Ch ON CH.ServiceId = S.ServiceId    
 AND ISNULL(ch.RecordDeleted, 'N') = 'N'    
LEFT JOIN ARLedger ARL ON ARL.ChargeId = CH.ChargeId    
WHERE EXISTS (    
  SELECT 1    
  FROM dbo.ssf_RecodeValuesCurrent('XOTHERPUBLICINSURENCE')    
  WHERE C.CoveragePlanId = IntegerCodeId    
  )    
 AND cast(S.DateOfService AS DATE) >= cast(@DateRangeStartDate AS DATE)    
 AND cast(S.DateOfService AS DATE) <= cast(@DateRangeEndDate AS DATE)    
 AND (    
  ISNULL(@ProviderId, 0) = 0    
  OR S.ClinicianId = @ProviderId    
  )    
 AND ISNULL(S.RecordDeleted, 'N') = 'N'    
    
--Total dollar amount of private insurance    
---Actual amount collected from private insurance    
SELECT @BilledToPrivateInsurance = cast(SUM(case when ARL.LedgerType = 4201 then  ISNULL(ARL.Amount, 0) else 0 end) AS DECIMAL(18, 2))    
 ,@ActualAmountPrivateInsuranceCharges = cast(Sum(case when ARL.LedgerType = 4202 then ISNULL(ARL.Amount, 0) else 0 end) AS DECIMAL(18, 2))    
FROM Services S    
JOIN #ACtiveClient C ON C.ClientId = S.ClientId    
LEFT JOIN Charges Ch ON CH.ServiceId = S.ServiceId    
 AND ISNULL(ch.RecordDeleted, 'N') = 'N'    
LEFT JOIN ARLedger ARL ON ARL.ChargeId = CH.ChargeId    
WHERE NOT EXISTS (    
  SELECT 1    
  FROM dbo.ssf_RecodeValuesCurrent('XOTHERPUBLICINSURENCE')    
  WHERE C.CoveragePlanId = IntegerCodeId    
  )    
 AND ISNULL(C.MedicaidPlan, 'N') = 'N'    
 AND ISNULL(C.MedicarePlan, 'N') = 'N'    
 AND cast(S.DateOfService AS DATE) >= cast(@DateRangeStartDate AS DATE)    
 AND cast(S.DateOfService AS DATE) <= cast(@DateRangeEndDate AS DATE)    
 AND (    
  ISNULL(@ProviderId, 0) = 0    
  OR S.ClinicianId = @ProviderId    
  )    
 AND ISNULL(S.RecordDeleted, 'N') = 'N'    
    
--Actual dollar amount collected from self pay    
SELECT @ActualAmountselfPay =  cast(Sum(case when ARL.LedgerType = 4202 then ISNULL(ARL.Amount, 0) else 0 end) AS DECIMAL(18, 2)),    
@ActualAmountCollectedselfPay= cast(SUM(case when ARL.LedgerType = 4201 then  ISNULL(ARL.Amount, 0) else 0 end) AS DECIMAL(18, 2))    
FROM Services S    
JOIN #ACtiveClient C ON C.ClientId = S.ClientId    
LEFT JOIN Charges Ch ON CH.ServiceId = S.ServiceId    
 AND ISNULL(ch.RecordDeleted, 'N') = 'N'    
LEFT JOIN ARLedger ARL ON ARL.ChargeId = CH.ChargeId    
 --AND ARL.LedgerType = 4202    
WHERE ch.ClientCoveragePlanid IS NULL    
 AND cast(S.DateOfService AS DATE) >= cast(@DateRangeStartDate AS DATE)    
 AND cast(S.DateOfService AS DATE) <= cast(@DateRangeEndDate AS DATE)    
 AND (    
  ISNULL(@ProviderId, 0) = 0    
  OR S.ClinicianId = @ProviderId    
  )    
 AND ISNULL(S.RecordDeleted, 'N') = 'N'    
    
--Number of  self pay adjustments and Total self pay adjustments    
SELECT @SelfPayAdjustments = cast(Sum(ISNULL(ARL.Amount, 0)) AS DECIMAL(18, 2))--Count(DISTINCT ARLedgerId)    
 --,@TotalSelfPayAdjustments = cast(Sum(ISNULL(ARL.Amount, 0)) AS DECIMAL(18, 2))    
FROM Services S    
JOIN #ACtiveClient C ON C.ClientId = S.ClientId    
LEFT JOIN Charges Ch ON CH.ServiceId = S.ServiceId    
 AND ISNULL(ch.RecordDeleted, 'N') = 'N'    
LEFT JOIN ARLedger ARL ON ARL.ChargeId = CH.ChargeId    
 AND ARL.LedgerType = 4203    
WHERE ch.ClientCoveragePlanid IS NULL    
 AND cast(S.DateOfService AS DATE) >= cast(@DateRangeStartDate AS DATE)    
 AND cast(S.DateOfService AS DATE) <= cast(@DateRangeEndDate AS DATE)    
 AND cast(ARL.PostedDate AS DATE) >= CAST(@DateRangeStartDate AS DATE)    
 AND cast(ARL.PostedDate AS DATE) <= cast(@DateRangeEndDate AS DATE)    
 AND (    
  ISNULL(@ProviderId, 0) = 0    
  OR S.ClinicianId = @ProviderId    
  )    
 AND ISNULL(S.RecordDeleted, 'N') = 'N'    
AND NOT EXISTS (    
  SELECT 1    
  FROM CustomClientfees CF    
  WHERE CF.ClientId = C.ClientId    
   AND ISNULL(CF.RecordDeleted, 'N') = 'N'    
   AND CAST(CF.StartDate as DATE)>= cast(@DateRangeStartDate AS DATE)    
    AND CAST(CF.EndDate as DATE)<= cast(@DateRangeEndDate AS DATE)    
  )    
    
--Number of adjustments for Sliding Fee Scale    
SELECT  @AdjustmentsSlidingFeeScale = cast(Sum(ISNULL(ARL.Amount, 0)) AS DECIMAL(18, 2))    
-- ,@TotalSelfPayAdjustments = cast(Sum(ISNULL(ARL.Amount, 0)) AS DECIMAL(18, 2))    
FROM Services S    
JOIN #ACtiveClient C ON C.ClientId = S.ClientId    
LEFT JOIN Charges Ch ON CH.ServiceId = S.ServiceId    
 AND ISNULL(ch.RecordDeleted, 'N') = 'N'    
LEFT JOIN ARLedger ARL ON ARL.ChargeId = CH.ChargeId    
 AND ARL.LedgerType = 4203    
WHERE ch.ClientCoveragePlanid IS NULL    
 AND cast(S.DateOfService AS DATE) >= cast(@DateRangeStartDate AS DATE)    
 AND cast(S.DateOfService AS DATE) <= cast(@DateRangeEndDate AS DATE)    
 AND cast(ARL.PostedDate AS DATE) >= CAST(@DateRangeStartDate AS DATE)    
 AND cast(ARL.PostedDate AS DATE) <= cast(@DateRangeEndDate AS DATE)    
 AND (    
  ISNULL(@ProviderId, 0) = 0    
  OR S.ClinicianId = @ProviderId    
  )    
 AND ISNULL(S.RecordDeleted, 'N') = 'N'    
 AND EXISTS (    
  SELECT 1    
  FROM CustomClientfees CF    
  WHERE CF.ClientId = C.ClientId    
   AND ISNULL(CF.RecordDeleted, 'N') = 'N'    
   AND CAST(CF.StartDate as DATE)>= cast(@DateRangeStartDate AS DATE)    
    AND CAST(CF.EndDate as DATE)<= cast(@DateRangeEndDate AS DATE)    
  )    
    
SET @TotalSelfPayAdjustments=@SelfPayAdjustments+@AdjustmentsSlidingFeeScale     
    
SELECT @ApplicationsForSlidingFee=COUNT(DISTINCT C.ClientId)    
FROM #ActiveClient C    
WHERE EXISTS (    
  SELECT 1    
  FROM dbo.ssf_RecodeValuesCurrent('XSLIDINGFEES')    
  WHERE C.CoveragePlanId = IntegerCodeId    
  )    
---Number of patient applications for Sliding Fee Scale approved    
SELECT @ApplicationsForSlidingFeeNotApproved = COUNT(DISTINCT C.ClientId)    
FROM #ActiveClient C    
WHERE EXISTS (    
  SELECT 1    
  FROM CustomClientfees CF    
  WHERE CF.ClientId = C.ClientId    
  AND CAST(CF.StartDate as DATE)>= cast(@DateRangeStartDate AS DATE)    
    AND CAST(CF.EndDate as DATE)<= cast(@DateRangeEndDate AS DATE)    
   AND ISNULL(CF.RecordDeleted, 'N') = 'N'    
  )    
  AND NOT  EXISTS (    
  SELECT 1    
  FROM ClientCoveragePlans CCP    
  WHERE CCP.ClientId = C.ClientId    
   AND ISNULL(CCP.RecordDeleted, 'N') = 'N'    
  )    
    
INSERT INTO #ResultSet (    
 SiteName    
 ,SiteAddress    
 ,DatePrepared    
 ,PreparedBy    
 ,RepotingPeriod    
 ,AnnualPatients    
 ,PatientsWithMedicare    
 ,PatientsWithMedicaid    
 ,PatientsPublicInsurance    
 ,PatientsPrivateInsurance    
 ,PatientsSlidingFeeSchedule    
 ,PatientsSelfPay    
 ,BilledToMedicare    
 ,ActualAmountMedicareCharges    
 ,BilledToMedicaid    
 ,ActualAmountMedicaidCharges    
 ,BilledToPublicInsurance    
 ,ActualAmountPublicInsuranceCharges    
 ,BilledToPrivateInsurance    
 ,ActualAmountPrivateInsuranceCharges    
 ,ActualAmountCollectedselfPay    
 ,ActualAmountselfPay    
 ,AdjustmentsSlidingFeeScale    
 ,SelfPayAdjustments    
 ,TotalSelfPayAdjustments    
 ,ApplicationsForSlidingFee    
 ,ApplicationsForSlidingFeeNotApproved    
 )    
SELECT @SiteName    
 ,@SiteAddress    
 ,@DatePrepared    
 ,@PreparedBy    
 ,@RepotingPeriod    
 ,@AnnualPatients    
 ,@PatientsWithMedicare    
 ,@PatientsWithMedicaid    
 ,@PatientsPublicInsurance    
 ,@PatientsPrivateInsurance    
 ,@PatientsSlidingFeeSchedule    
 ,@PatientsSelfPay    
 ,ISNULL(@BilledToMedicare,0)   
 ,ISNULL(@ActualAmountMedicareCharges,0)    
 ,ISNULL(@BilledToMedicaid,0)    
 ,ISNULL(@ActualAmountMedicaidCharges,0)   
 ,ISNULL(@BilledToPublicInsurance,0)    
 ,ISNULL(@ActualAmountPublicInsuranceCharges,0)   
 ,ISNULL(@BilledToPrivateInsurance,0)    
 ,ISNULL(@ActualAmountPrivateInsuranceCharges,0)   
 ,ISNULL(@ActualAmountCollectedselfPay,0)   
 ,ISNULL(@ActualAmountselfPay,0)    
 ,ISNULL(@AdjustmentsSlidingFeeScale,0)   
 ,ISNULL(@SelfPayAdjustments,0)   
 ,ISNULL(@TotalSelfPayAdjustments,0)    
 ,@ApplicationsForSlidingFee    
 ,@ApplicationsForSlidingFeeNotApproved    
    
SELECT SiteName    
 ,SiteAddress    
 ,DatePrepared    
 ,PreparedBy    
 ,RepotingPeriod    
 ,AnnualPatients    
 ,PatientsWithMedicare    
 ,PatientsWithMedicaid    
 ,PatientsPublicInsurance    
 ,PatientsPrivateInsurance    
 ,PatientsSlidingFeeSchedule    
 ,PatientsSelfPay    
 ,BilledToMedicare    
 ,ActualAmountMedicareCharges    
 ,BilledToMedicaid    
 ,ActualAmountMedicaidCharges    
 ,BilledToPublicInsurance    
 ,ActualAmountPublicInsuranceCharges    
 ,BilledToPrivateInsurance    
 ,ActualAmountPrivateInsuranceCharges    
 ,ActualAmountCollectedselfPay    
 ,ActualAmountselfPay    
 ,AdjustmentsSlidingFeeScale    
 ,SelfPayAdjustments    
 ,TotalSelfPayAdjustments    
 ,ApplicationsForSlidingFee    
 ,ApplicationsForSlidingFeeNotApproved    
FROM #ResultSet    
    
    
    
END TRY    
    
BEGIN CATCH    
 DECLARE @Error VARCHAR(8000)    
    
 SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE())    
  + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLNationalHealthServiceCorps')    
   + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
 RAISERROR (    
   @Error    
   ,-- Message text.    
   16    
   ,-- Severity.    
   1 -- State.    
   );    
END CATCH    
    
RETURN    
END    