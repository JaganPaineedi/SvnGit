
/****** Object:  StoredProcedure [dbo].[ssp_CMGetClaimDetails]    Script Date: 11/16/2011 11:52:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetClaimDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetClaimDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO    
CREATE PROCEDURE [dbo].[ssp_CMGetClaimDetails]  
@ClaimID int        
AS        
        
/*********************************************************************/                      
/* Stored Procedure: dbo.ssp_GetClaimDetails                         */                      
/* Copyright: 2005 Provider Claim Management System                  */                      
/* Creation Date:  18/06/2014                                        */                      
/*                                                                   */                      
/* Purpose: it will get all Claim records of passed ClaimID          */                     
/*                                                                   */                    
/* Input Parameters: @ClaimID                                        */                    
/*                                                                   */                      
/* Output Parameters:                                                */                      
/*                                                                   */                      
/*                                                                   */                      
/* Called By:                                                        */                      
/*                                                                   */                      
/* Calls:                                                            */                      
/*                                                                   */                      
/* Data Modifications:                                               */                      
/*                                                                   */                      
/* Updates:                                                          */                      
/* Date   Author   Purpose                                          */      
/* June 18 2014     Shruthi.S Created for getdata of Professional and Institutional  */
/* Nov 19  2014     Shruthi.S Casted billingcodeid.Ref : #147 */


/* Nov 20  2014     Veena S Mani  Added AdjustmentAmount in Claims   Concurrency issue #151  */
/* Nov 27  2014     Shruthi.S Changed ProcedureCode to billingcodeid to get the procedurecode text.*/
/* Nov 28  2014     Arjun K R Joined GlobalCodes to ClaimLines to get the PlaceOfServiceText */
/* Dec 3   2014     Shruthi.S Added claimlienhistory.Ref #198 Env issues.        */
/* Dec 4   2014     Veena  Added TotalPreviousPayment,TotalPreviousAdjustment   */
/* Dec 5   2014     Veena Added new column PreviousAmtPaid in Claims to show the sum of all PreviousAmountPaid for the Claim   */
/* Dec 22  2014     Arjun K R  In claimline select statement query is changed to select billingcode instead of billingcodeId Task #286*/
-- Dec 31st 2014    Shruthi.S  Modified ProcedureCode condition and changed it to billingcodeid.Ref #325 CM Env Issues
-- Feb 11 2015      Shruthi.S  Modified to get the entry complete count make the Entry Complete checkbox checked and unchecked.Ref #492 Env Issues.
-- 26.fEB.2015		Rohith Uppin	OldStatus column added as it was used in Dataset to hold previous status. Task#467 CM to SC issues.
-- 14  Dec 2015     Arjun K R "StartTime" and "EndTime" columns are added to ClaimLines table select statement. Task #22 The ARC Customizations.
-- 01.July.2016     Basudev Sahu Modified to Get Organisation  As ClientName for task #684	Network 180 Environment Issues Tracking.
-- 27.AUG.2016      Shivanand Modified and checking the condition (ClientType, 'O') = 'O'   to Get Organisation  As ClientName for task #29	AspenPointe-Environment Issues
/* 29 AUG 2017      Manjunath K     Added Coumn in Select statement to fetch ProcedureCode + Modifiers as BillingCodeModifiers  */
/* 18 Dec 2017      Sunil.D   What:Added tabel called 'Claim line Drugs'  at the end and Added few columns to Calims and claimlines table
							  Why:Heartland East - Customizations #23  */
/* 17 Sept 2018     Neelima   What: Modified AdjustmentAmount calculation in Temp table to get the Adj amount on UI based on the charge values and Allowed values on save WHY: KCMHSAS - Support #1013 */
/* 11 Oct 2018     Neelima   What: Modified AdjustmentAmount calculation in Temp table to get the Adj amount on UI based on the charge values and Allowed values only when there is Adj or Allowed amount values entered on save WHY: KCMHSAS - Support #1195 */
/*********************************************************************/                    
begin  
BEGIN TRY      
  --Variable to get the Totalcount of ClaimLines with 2022 Enrty Complete 
  Declare @EntryCompleteCount INT
  set @EntryCompleteCount = 0
  select @EntryCompleteCount = count(*) from ClaimLines CL where Cl.ClaimId = @ClaimID and isnull(CL.RecordDeleted,'N')='N' and CL.[status]= 2022
  
  --for Claim Table Information  
  --To get searched providername 
     --To get ClaimStatus from claimlines
     Declare @ClaimStat int
     Declare @ClaimStatus char(1)
     set @ClaimStatus ='N'
     select top 1 @ClaimStat =   [Status] from ClaimLines CL inner join GlobalCodes GC on CL.[Status] = GC.GlobalCodeId
     where Cl.ClaimId = @ClaimID and isnull(CL.RecordDeleted,'N')='N' 
     
     --To set the temp variable for entrycomplete checkbox
     if(@EntryCompleteCount > 0)
     begin
     set @ClaimStat = 2022
     end
     
     
--2021 Entry Incomplete
--2022 Entry Complete
Declare @PreviousAmtPaid money
Set @PreviousAmtPaid =(select SUM(ClaimLineCOBPaymentAdjustments.PaidAmount)  
   from Claims  
   inner join ClaimLines on Claims.ClaimId=ClaimLines.ClaimId   
   left join ClaimLineCOBPaymentAdjustments on ClaimLineCOBPaymentAdjustments.ClaimLineId=ClaimLines.ClaimLineId  
   and isnull(ClaimLineCOBPaymentAdjustments.RecordDeleted,'N')='N'  
   where isnull(Claims.RecordDeleted,'N')='N'   
  and isnull(ClaimLines.RecordDeleted,'N')='N'  
  and Claims.ClaimID=@ClaimID) 
if(@ClaimStat = 2022)
begin
set @ClaimStatus = 'Y'
end

Select  ClaimId,
CS.ClientId,
CS.InsurerId,
CS.SiteId,
CS.ReceivedDate,
CS.CleanClaimDate,
CS.ClaimType,
CS.ClientAddress1,
CS.ClientAddress2,
CS.ClientCity,
CS.ClientState,
CS.ClientZip,
CS.AuthorizationNumber,
CS.PatientAccountNumber,
CS.OtherInsured,
CS.OtherInsuredName,
CS.OtherInsuredId,
CS.OtherInsuredDOB,
CS.OtherPlanName,
CS.Diagnosis1,
CS.Diagnosis2,
CS.Diagnosis3,
CS.TotalCharge,
CS.AmountPaid,
CS.BalanceDue,
CS.TaxIdType,
CS.StartDate,
CS.EndDate,
CS.AdmissionDate,
CS.AdmissionTime,
CS.DischargeTime,
CS.DiagnosisAdmission,
CS.DiagnosisPrincipal,
CS.OtherPayers,
CS.OtherPayerName1,
CS.OtherProviderNumber1,
CS.OtherPriorPayment1,
CS.OtherInsuredName1,
CS.OtherCertification1,
CS.OtherGroupNumber1,
CS.OtherPayerName2,
CS.OtherProviderNumber2,
CS.OtherPriorPayment2,
CS.OtherInsuredName2,
CS.OtherInsuredDOB2,
CS.OtherInsuredDOB1,
CS.OtherCertification2,
CS.OtherGroupNumber2,
CS.OtherPayerName3,
CS.OtherProviderNumber3,
CS.OtherPriorPayment3,
CS.OtherInsuredName3,
CS.OtherInsuredDOB3,
CS.OtherCertification3,
CS.OtherGroupNumber3,
CS.RenderingProviderId,
CS.RenderingProviderName,
CS.RenderingFacilityInfo,
CS.BillingProviderInfo,
CS.PreviouslyPaidAmount,
CS.Electronic,
CS.Comment,
--RowIdentifier,
CS.CreatedBy,
CS.CreatedDate,
CS.ModifiedBy,
CS.ModifiedDate,
CS.RecordDeleted,
CS.DeletedDate,
CS.DeletedBy,
--C.LastName As LastName,
--C.FirstName As FirstName,-- 01.July.2016  Basudev Sahu
CASE               
	WHEN ISNULL(C.ClientType, 'I') = 'I'          
	THEN ISNULL(C.LastName, '')      
	-- ELSE ISNULL(C.OrganizationName, '')          
	End AS LastName,   
CASE       
	WHEN ISNULL(C.ClientType, 'I') = 'I'      
	THEN ISNULL(C.FirstName, '')        
	--ELSE ISNULL(C.OrganizationName, '')          
	END  AS FirstName,
CASE  
    WHEN ISNULL(C.ClientType, 'O') = 'O'      
    THEN ISNULL(C.OrganizationName, '')        
  --ELSE ISNULL(C.OrganizationName, '')          
    END  AS OrganizationName,     
CASE P.ProviderType WHEN 'I' THEN P.ProviderName + ', ' + P.FirstName WHEN 'F' THEN P.ProviderName END AS SearchedProviderName,
P.ProviderId AS SearchedProviderId,
S.TaxID as TaxId,
S.SiteName As SiteName,
@ClaimStatus As ClaimStatus,
CS.AdjustmentAmount,
@PreviousAmtPaid as PreviousAmtPaid,
CS.SupervisingProviderId,
CS.SupervisingProviderName
from Claims  CS
Inner Join Clients C on C.ClientId = CS.ClientId
Left Join Sites S on CS.SiteId = S.SiteId
Left Join Providers P on P.ProviderId = S.ProviderId
Where ClaimID=@ClaimID and isnull(Cs.RecordDeleted,'N')='N'        

CREATE TABLE #tempClaimLineCOBPaymentAdjustments  
 (  
 ClaimLineId int,  
 TotalPreviousPayment money, 
 Charge money, 
 TotalPreviousAdjustment money,  
 )      
     
   insert into #tempClaimLineCOBPaymentAdjustments  
   select ClaimLines.ClaimLineId  
  ,SUM(ClaimLineCOBPaymentAdjustments.PaidAmount)  
  ,ClaimLines.Charge as Charge 
  ,case When EXISTS(SELECT * from ClaimLineCOBPaymentAdjustments CD WHERE CD.ClaimLineId = ClaimLineCOBPaymentAdjustments.ClaimLineId  and isnull(CD.RecordDeleted,'N')='N' 
  and ((SUM(ISNULL(ClaimLineCOBPaymentAdjustments.AdjustmentAmount,0)) <> 0 AND ISNULL(SUM(ClaimLineCOBPaymentAdjustments.AllowedAmount),0) <> 0) 
  OR (SUM(ISNULL(ClaimLineCOBPaymentAdjustments.AdjustmentAmount,0)) = 0 AND ISNULL(SUM(ClaimLineCOBPaymentAdjustments.AllowedAmount),0) <> 0)))  
    then (SUM(ISNULL(ClaimLineCOBPaymentAdjustments.AdjustmentAmount,0)) +  ( ISNull(ClaimLines.Charge,0) - ISNULL(SUM(ClaimLineCOBPaymentAdjustments.AllowedAmount),0)))        
	else
	SUM(ISNULL(ClaimLineCOBPaymentAdjustments.AdjustmentAmount,0) )
	end
	as AdjustmentAmount
   from Claims  
   inner join ClaimLines on Claims.ClaimId=ClaimLines.ClaimId   
   left join ClaimLineCOBPaymentAdjustments on ClaimLineCOBPaymentAdjustments.ClaimLineId=ClaimLines.ClaimLineId  
   and isnull(ClaimLineCOBPaymentAdjustments.RecordDeleted,'N')='N'  
   where isnull(Claims.RecordDeleted,'N')='N'   
  and isnull(ClaimLines.RecordDeleted,'N')='N'  
  and Claims.ClaimID=@ClaimID  
   Group By ClaimLineCOBPaymentAdjustments.ClaimLineId,ClaimLines.ClaimLineId, ClaimLines.Charge    
         
select 
cl.ClaimLineId,
cl.ClaimId,
cl.[Status],
cl.FromDate,
cl.ToDate,
cl.PlaceOfService,
cl.RevenueCode,
cl.ProcedureCode,
cl.BillingCodeId,
cl.Modifier1,
cl.Modifier2,
cl.Modifier3,
cl.Modifier4,
cl.Diagnosis1,
cl.Diagnosis2,
cl.Diagnosis3,
cl.Charge,
cl.Units,
cl.PaidAmount,
cl.ClaimedAmount,
cl.RenderingProviderId,
cl.RenderingProviderName,
cl.DoNotAdjudicate,
cl.NeedsToBeWorked,
cl.ToReadjudicate,
cl.PayableAmount,
cl.ManualApprovalReason,
cl.DenialReason,
cl.PendedReason,
cl.Comment,
cl.AuthorizationExistsAtEntry,
cl.EOBReceived,
cl.AllowedAmount,
cl.RowIdentifier,
cl.CreatedBy,
cl.CreatedDate,
cl.ModifiedBy,
cl.ModifiedDate,
cl.RecordDeleted,
cl.DeletedDate,
cl.DeletedBy,
cl.Diagnosis1,
cl.Diagnosis2,
cl.Diagnosis3,
(case when ISNULL(cl.Diagnosis1,'N')='Y'   and (ISNULL(cl.Diagnosis2,'N') <> 'Y' and ISNULL(cl.Diagnosis3,'N')<>'Y') then  '1' else ''  end ) +  
(case when ISNULL(cl.Diagnosis2,'N')='Y'   and (ISNULL(cl.Diagnosis1,'N') <> 'Y' and ISNULL(cl.Diagnosis3,'N')<>'Y') then  '2'  else ''  end )+  
(case when ISNULL(cl.Diagnosis3,'N')='Y'   and (ISNULL(cl.Diagnosis1,'N') <> 'Y' and ISNULL(cl.Diagnosis2,'N')<>'Y') then '3'  else ''  end )+  
(case when ISNULL(cl.Diagnosis1,'N')='Y'   and ISNULL(cl.Diagnosis2,'N')='Y' and ISNULL(cl.Diagnosis3,'N') <>'Y'     then '1,2' else ''  end)+  
(case when ISNULL(cl.Diagnosis1,'N')='Y'   and ISNULL(cl.Diagnosis3,'N')='Y' and ISNULL(cl.Diagnosis2,'N') <> 'Y'    then '1,3' else '' end)+  
(case when ISNULL(cl.Diagnosis2,'N')='Y'   and ISNULL(cl.Diagnosis3,'N')='Y' and ISNULL(cl.Diagnosis1,'N') <> 'Y'    then '2,3' else '' end)+  
(case when ISNULL(cl.Diagnosis1,'N')='Y'   and ISNULL(cl.Diagnosis2,'N')='Y' and ISNULL(cl.Diagnosis3,'N') ='Y'      then '1,2,3' else '' end) As DiagnosisComb,
Cl.ProcedureCode as ProcedureCode1Text,
--CASE P.ProviderType     
-- WHEN 'I' THEN P.ProviderName + ', ' + P.FirstName     
-- WHEN 'F' THEN P.ProviderName    
--END AS PlaceOfServiceText 
gc.CodeName as PlaceOfServiceText,
TotalPreviousPayment,  
  TotalPreviousAdjustment,
  cl.[Status] as OldStatus,
  
  --- Added By Arjun K R ON 14 DEC 2015
  cl.StartTime,
  cl.EndTime,
/* 29 AUG 2017      Manjunath K */
CASE 
WHEN ISNULL(cl.ProcedureCode, '') <> ''
THEN ISNULL(cl.ProcedureCode, '') + ' ' + ISNULL(cl.Modifier1, '') + ' ' + ISNULL(cl.Modifier2, '') + ' ' + 
	 ISNULL(cl.Modifier3, '') + ' ' + ISNULL(cl.Modifier4, '') ELSE ''	END AS BillingCodeModifiers
	,CD.NationalDrugCode as NDC
	,CD.Units as NDCUnits
	,CD.UnitType as NDCUnitType
	,cl.SupervisingProviderId
	,cl.SupervisingProviderName
	,cl.OrderingProviderId
	,cl.OrderingProviderName 
	,CD.DrugId as NDCDrugId
from 
ClaimLines cl 
LEFT JOIN #tempClaimLineCOBPaymentAdjustments ON #tempClaimLineCOBPaymentAdjustments.ClaimLineId=cl.ClaimLineId
Left join billingcodes bc on cl.BillingCodeID =bc.BillingCodeID 
--Left join Providers P on P.ProviderId = cl.RenderingProviderId
Left join GlobalCodes gc on cl.PlaceOfService=gc.GlobalCodeId
left join Claimlinedrugs CD on CD.ClaimLineId=cl.ClaimLineId
where cl.ClaimId = @ClaimID 
and   ISNULL(cl.RecordDeleted,'N')='N'  
and   ISNULL(bc.RecordDeleted,'N')='N'  
and   ISNULL(CD.RecordDeleted,'N')='N'  
--and   ISNULL(P.RecordDeleted,'N')='N'



 
          
 
    
    
  
  --    --Payments information     
  SELECT CP.ClaimLineCOBPaymentAdjustmentId,
CP.CreatedBy,
CP.CreatedDate,
CP.ModifiedBy,
CP.ModifiedDate,
CP.RecordDeleted,
CP.DeletedDate,
CP.DeletedBy,
CP.ClaimLineId,
CP.PayerId,
CP.PayerName,
CP.PayerIsClient,
CP.PaidAmount,
CP.AdjustmentGroupCode,
CP.AdjustmentReason,
--convert(varchar,cast(CP.AdjustmentAmount as money),10) as AdjustmentAmount,
CP.AdjustmentAmount,
CP.AdjustmentUnits,
CP.AllowedAmount
  FROM  ClaimLineCOBPaymentAdjustments CP Join ClaimLines CL on CP.ClaimLineId=CL.ClaimLineId       
  WHERE ClaimID=@ClaimID and isnull(CL.RecordDeleted,'N')='N' and  isnull(CP.RecordDeleted,'N')='N'       
  ORDER BY CP.claimlineid    
  


--Claim line history ---

select 
CH.ClaimLineHistoryId,
CH.CreatedBy,
CH.CreatedDate,
CH.ModifiedBy,
CH.ModifiedDate,
CH.RecordDeleted,
CH.DeletedDate,
CH.DeletedBy,
CH.ClaimLineId,
CH.Activity,
CH.ActivityDate,
CH.[Status],
CH.ActivityStaffId,
CH.ClaimLinePaymentId,
CH.ClaimLineCreditId,
CH.ClaimLineDenialId,
CH.AdjudicationId,
CH.Reason
from 
Claims C 
Join ClaimLines CL  on C.ClaimId = CL.ClaimId and C.ClaimID=@ClaimID
Join  ClaimLineHistory CH on CH.ClaimLineId = CL.ClaimLineId
 WHERE  isnull(CL.RecordDeleted,'N')='N' and  isnull(CH.RecordDeleted,'N')='N'       
  ORDER BY CL.ClaimLineId   
  
  --Claim line Drugs ---

select 
 CD.ClaimLineDrugId
,CD.CreatedBy
,CD.CreatedDate
,CD.ModifiedBy
,CD.ModifiedDate
,CD.RecordDeleted
,CD.DeletedBy
,CD.DeletedDate
,CD.ClaimLineId
,CD.DrugId
,CD.NationalDrugCode
,CD.Units
,CD.UnitType

from 
Claims C 
Join ClaimLines CL  on C.ClaimId = CL.ClaimId and C.ClaimID=@ClaimID
Join  Claimlinedrugs CD on CD.ClaimLineId = CL.ClaimLineId
 WHERE  isnull(CL.RecordDeleted,'N')='N' and  isnull(CD.RecordDeleted,'N')='N'       
  ORDER BY CL.ClaimLineId   
  
     END TRY
   BEGIN CATCH
   --Checking For Errors  
   DECLARE @Error varchar(8000)
    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE())
    + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_GetClaimDetails')
    + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY())
    + '*****' + CONVERT(varchar, ERROR_STATE())
    RAISERROR
    (
    @Error, -- Message text.  
    16,  -- Severity.  
    1  -- State.  
    );      
    
    END CATCH 
end 