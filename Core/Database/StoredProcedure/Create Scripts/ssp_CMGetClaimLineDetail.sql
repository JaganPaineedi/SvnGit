
/****** Object:  StoredProcedure [dbo].[ssp_CMGetClaimLineDetail]    Script Date: 06/21/2016 16:07:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetClaimLineDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetClaimLineDetail]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CMGetClaimLineDetail]    Script Date: 06/21/2016 16:07:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_CMGetClaimLineDetail] @ClaimLineID INT  
 /*********************************************************************          
-- Stored Procedure: ssp_GetClaimLineDetail          
--          
-- Copyright: 2005 Streamline Healthcare Solutions           
--          
-- Creation Date:    12/27/05                                
--                                                           
-- Purpose:  Returns claim line details          
--           
-- Updates:                                                
--  Date       Author            Purpose              
--  12.27.2005 Bhupinder Bajwa   Created                  
--  04.01.2008 Amrik Singh       Modified          
--  04.26.2007 Sukhbir Singh     Modified as per task 49 for fetching planid             
--  04.14.2008 Amrik Singh       Modified for custom fields data                       
--  08.28.2008 SFarber           Modified to support the Unvoid Check activity          
--  05.04.2012 Sanjay Bhardewaj  Modified as per task 21 for multiple denail/pended reasons         
--  07.30.2014 Manju P           Modified for CM To Sc Task#25 Claimline list page & claimline detail page  
--  09.29.2014 Vichee Humane     Modified code for CM to SC env. Issues Tracking #25.1 as it was giving error in claim list page   
                                 while selecting Payment Overdue filter and click Applyfilter button   
--  10.Oct.2014 Rohith Uppin  Update ClaimPlanes & Plans table to ClaimLineCoveragePlans & CoveragePlans. Task#25 CM to SC.  
--  21/12/2014  Shruthi.S        Added oldstatus field.To save the current status correctly if claim is reverted or approved from the popup.Ref #239 Care Management to SmartCare Env. Issues Tracking.  
--  01.28.2015  SFarber          Removed check for CoveragePlans.Active when selecting Plan Alllocation list  
--  02.09.2015  Vichee           Modified for Adjudication tabel as it was not reteriving ContractRate.Task#486 CM to SC.  
--  02.09.2015  SFarber          Removed substitution of Procedure Code with Revenue Code when Procedure Code is null   
--  02.10.2015  Vichee           Modified for Adjudication tabel as it was not reteriving ContractRate.Task#486 CM to SC.  
--  24.Feb.2015 Rohith Uppin  All Denial & pended reason are selected and seperated by '#' symbol. Task#547 CM to SC issues tracking.  
/*   20 Oct 2015 Revathi   what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */   
/*          why:task #609, Network180 Customization  */   
-- 21.Dec.2015 Rohith Uppin  Record deleted check added while updating denied reasons. Task#409 Newaygo Support.  
--  01.Feb.2016 Shruthi.S        Added UnderReview concatenation for checknumber.Ref : #708 Network180-Customizations.  
-- 06/21/2016 Gautam	Performance Improvement, SWMBH - Support 1010
-- 20-July-2016 Basudev Sahu	Removed Casting of Units to int for task #559 Network180 Environment Issue Tracking . 
-- 13-September Aravind        Added StartTime,EndTime in ClaimLines table since Modified Data was not updating to the Database
								Why:Task #17 - AspenPointe - Support Go Live - Claims: Saving deletes data, unable to work claims effectively */
--31-Aug-2017  SuryaBalan    In Claimline Detail page customer needs Authorizations label to be hyperlinked for that ProvicerAuthorizationDocumentid column is needed So I have added that column for KCMHSAS - Support #900.97
--21-May-2018  Alok Kumar	 Added order by clause for #ClaimLineHistory result set to sort the records based on descending order of ActivityDate column.	Ref: Task#1232 SWMBH - Enhancements.
--07/09/2018  K.Soujanya     Added column OverridePendedReason to the ClaimLines table Ref #13 Partner Solutions - Enhancements
--10/29/2018  K.Soujanya     Added ClaimLineUnderReview, FinalStatus columns to the ClaimLines table Ref #591 SWMBH - Enhancements 
/***************************************************************************************************************************************/  
AS -- Variables declared to hold different Activity values                  
DECLARE @Payment INT  
 ,@Credit INT  
 ,@Refund INT  
 ,@Adjudication INT  
 ,@Reversal INT  
 ,@Approval INT  
 ,@Deny INT  
 ,@VoidCheck INT  
 ,@UnvoidCheck INT  
  
SET @Payment = 2003  
SET @Credit = 2005  
SET @Refund = 2006  
SET @Adjudication = 2002  
SET @Reversal = 2004  
SET @Approval = 2007  
SET @Deny = 2009  
SET @VoidCheck = 2011  
SET @UnvoidCheck = 2012  
  
-- Query returns the ClaimLine with fields needs to be updated                 
SELECT cl.ClaimLineId  
 ,cl.ClaimId  
 ,cl.STATUS as 'Status'   
 ,cl.FromDate  
 ,cl.ToDate  
 ,cl.PlaceOfService  
 ,cl.RevenueCode  
 ,cl.ProcedureCode  
 ,cl.BillingCodeId  
 ,cl.Modifier1  
 ,cl.Modifier2  
 ,cl.Modifier3  
 ,cl.Modifier4  
 ,cl.Diagnosis1  
 ,cl.Diagnosis2  
 ,cl.Diagnosis3  
 ,cl.Charge  
 ,cl.Units  
 ,cl.PaidAmount  
 ,cl.ClaimedAmount  
 ,cl.RenderingProviderId  
 ,cl.RenderingProviderName  
 ,cl.DoNotAdjudicate  
 ,cl.NeedsToBeWorked  
 ,cl.ToReadjudicate  
 ,cl.PayableAmount  
 ,cl.ManualApprovalReason  
 ,cl.DenialReason  
 ,cl.PendedReason  
 ,cl.Comment  
 ,cl.AuthorizationExistsAtEntry  
 ,cl.EOBReceived  
 ,cl.AllowedAmount  
 ,cl.RowIdentifier  
 ,cl.CreatedBy  
 ,cl.CreatedDate  
 ,cl.ModifiedBy  
 ,cl.ModifiedDate  
 ,cl.RecordDeleted  
 ,cl.DeletedDate  
 ,cl.DeletedBy  
 ,cl.[Status] AS OldStatus
 ,cl.StartTime  
 ,cl.EndTime  
 ,cl.OverridePendedReason  -- K.Soujanya 07/09/2018 
 ,cl.ClaimLineUnderReview  -- K.Soujanya 10/29/2018 
 ,cl.FinalStatus
--,cl.Comment   
FROM ClaimLines cl  
WHERE cl.ClaimLineId = @ClaimLineID  
 AND isnull(cl.RecordDeleted, 'N') <> 'Y'  
  
-- Query returns Claim Line Information as Table                  
SELECT cl.ClaimLineId  
 ,c.ClaimId  
 ,c.ClientId  
 -- Modified by   Revathi   20 Oct 2015   
 ,CASE   
  WHEN ISNULL(ce.ClientType, 'I') = 'I'  
   THEN CASE   
     WHEN len(ce.LastName + ' ' + ce.FirstName) > 18  
      THEN substring(ce.LastName + ', ' + ce.FirstName, 1, 15) + '...'  
     ELSE ce.LastName + ', ' + ce.FirstName  
     END  
  ELSE CASE   
    WHEN len(ce.OrganizationName) > 18  
     THEN substring(ce.OrganizationName, 1, 15) + '...'  
    ELSE ce.OrganizationName  
    END  
  END AS ClientName  
 ,p.ProviderId  
 ,CASE   
  WHEN len(p.ProviderName) > 18  
   THEN substring(p.ProviderName, 1, 15) + '...'  
  ELSE p.ProviderName  
  END AS ProviderName  
 ,p.NonNetwork  
 ,s.SiteId  
 ,CASE   
  WHEN len(s.SiteName) > 18  
   THEN substring(s.SiteName, 1, 15) + '...'  
  ELSE s.SiteName  
  END AS SiteName  
 ,s.TaxID  
 ,i.InsurerId  
 ,CASE   
  WHEN len(i.InsurerName) > 18  
   THEN substring(i.InsurerName, 1, 15) + '...'  
  ELSE i.InsurerName  
  END AS InsurerName  
 ,cl.STATUS AS STATUS  
 ,g.CodeName AS CodeName  
 ,cl.ProcedureCode  
 --,convert(DECIMAL(18, 0), cl.Units) AS Units  
 ,cl.Units AS Units   -- 20-July-2016 Basudev Sahu removed casting of units to int 
 ,rtrim(isnull(cl.Modifier1, '') + ' ' + isnull(cl.Modifier2, '') + ' ' + isnull(cl.Modifier3, '') + ' ' + isnull(cl.Modifier4, '')) AS Modifiers  
 ,cl.RevenueCode  
 ,cl.charge  
 ,cl.PayableAmount  
 ,cl.ClaimedAmount  
 ,cl.PaidAmount  
 ,isnull(cl.DoNotAdjudicate, 'N') AS DoNotAdjudicate  
 ,isnull(cl.NeedsToBeWorked, 'N') AS NeedsToBeWorked  
 ,isnull(cl.ToReadjudicate, 'N') AS ToReadjudicate  
 ,convert(VARCHAR(10), cl.FromDate, 101) AS DOSFrom  
 ,convert(VARCHAR(10), cl.ToDate, 101) AS DOSTo  
 ,convert(VARCHAR(10), c.ReceivedDate, 101) AS ReceivedDate  
 ,convert(VARCHAR(10), c.CleanClaimDate, 101) AS CleanClaimDate  
 ,isnull(c.Electronic, 'N') AS Electronic  
 ,cl.Comment  
 ,(  
  SELECT gc.CodeName  
  FROM GlobalCodes gc  
  WHERE gc.GlobalCodeId = s.SiteType  
   AND isnull(gc.RecordDeleted, 'N') <> 'Y'  
   AND gc.Active = 'Y'  
  ) AS SiteType  
 ,(  
  SELECT gc.CodeName  
  FROM GlobalCodes gc  
  WHERE gc.GlobalCodeId = c.ClaimType  
   AND isnull(gc.RecordDeleted, 'N') <> 'Y'  
   AND gc.Active = 'Y'  
  ) AS ClaimType  
 ,(  
  SELECT gc.CodeName  
  FROM GlobalCodes gc  
  WHERE gc.GlobalCodeId = cl.PlaceOfService  
   AND isnull(gc.RecordDeleted, 'N') <> 'Y'  
   AND gc.Active = 'Y'  
  ) AS POS  
 ,cl.ModifiedDate  
 ,'' AS BlankColumn  
FROM ClaimLines AS cl  
INNER JOIN GlobalCodes AS g ON g.GlobalCodeId = cl.STATUS  
INNER JOIN Claims AS c ON cl.ClaimId = c.ClaimId  
INNER JOIN Clients AS ce ON ce.ClientId = c.Clientid  
INNER JOIN Insurers AS i ON i.InsurerId = c.InsurerId  
INNER JOIN Sites AS s ON s.SiteId = c.SiteId  
INNER JOIN Providers AS p ON p.ProviderId = s.ProviderId  
WHERE isnull(cl.RecordDeleted, 'N') <> 'Y'  
 AND isnull(c.RecordDeleted, 'N') <> 'Y'  
 AND isnull(ce.RecordDeleted, 'N') <> 'Y'  
 AND isnull(i.RecordDeleted, 'N') <> 'Y'  
 AND isnull(s.RecordDeleted, 'N') <> 'Y'  
 AND isnull(p.RecordDeleted, 'N') <> 'Y'  
 AND isnull(g.RecordDeleted, 'N') <> 'Y'  
 AND cl.ClaimLineId = @ClaimLineID  
  
--Checking For Errors                  
IF (@@error != 0)  
BEGIN  
 RAISERROR ('ssp_GetClaimLineDetail: An Error Occured ',16,1);  
  
 RETURN  
END  
  
--Query returns Claim Line Status and Payment History as Table   
CREATE TABLE #ClaimLineHistory (  
 ClaimLineHistoryId INT  
 ,ClaimLineId INT  
 ,ActivityDate DATETIME  
 ,Activity INT  
 ,ActivityName VARCHAR(250)  
 ,STATUS INT  
 ,StatusName VARCHAR(250)  
 ,ApprovedAmount DECIMAL(16, 2)  
 ,DeniedAmount DECIMAL(16, 2)  
 ,PaidAmount DECIMAL(16, 2)  
 ,CreditAmount DECIMAL(16, 2)  
 ,Denial# VARCHAR(max)  
 ,Check# VARCHAR(100)  
 ,ActivityStaffId INT  
 ,[Reason] VARCHAR(max)  
 ,UserName VARCHAR(250)  
 ,BatchId INT  
 ,PaymentCheckId INT  
 ,CreditCheckId INT  
 ,ProviderRefundId INT  
 ,AdjudicationId INT  
 ,MultipleDenialCount INT  
 ,RecordDeleted CHAR(1)  
 )  
  
INSERT INTO #ClaimLineHistory  
SELECT clh.ClaimLineHistoryId  
 ,clh.ClaimLineId  
 ,clh.ActivityDate  
 ,clh.Activity  
 ,(  
  SELECT gc.CodeName  
  FROM GlobalCodes gc  
  WHERE gc.GlobalCodeId = clh.Activity  
   AND isnull(gc.RecordDeleted, 'N') = 'N'  
  ) AS ActivityName  
 ,clh.STATUS  
 ,g.CodeName AS StatusName  
 ,CASE   
  WHEN clh.Activity IN (  
    @Adjudication  
    ,@Reversal  
    ,@Approval  
    )  
   THEN ad.ApprovedAmount  
  ELSE NULL  
  END AS ApprovedAmount  
 ,CASE   
  WHEN clh.Activity IN (  
    @Adjudication  
    ,@Reversal  
    ,@Approval  
    ,@Deny  
    )  
   THEN ad.DeniedAmount  
  ELSE NULL  
  END AS DeniedAmount  
 ,CASE   
  WHEN clh.Activity IN (  
    @Payment  
    ,@VoidCheck  
    ,@UnvoidCheck  
    )  
   THEN clp.Amount  
  ELSE NULL  
  END AS PaidAmount  
 ,CASE   
  WHEN clh.Activity IN (  
    @Credit  
    ,@Refund  
    )  
   THEN clc.Amount  
  ELSE NULL  
  END AS CreditAmount  
 ,CASE   
  WHEN clh.Activity = @Deny  
   THEN (  
     SELECT cast(DenialReason AS VARCHAR)  
     FROM ClaimLineDenials cld  
     WHERE cld.ClaimLineDenialId = clh.ClaimLineDenialId  
      AND clh.STATUS = 2024  
     )  
  ELSE ''  
  END AS Denial#  
 ,    case when clh.Activity in (@Payment, @VoidCheck, @UnvoidCheck)   
          then (select   
     CASE WHEN  ch.ReleaseToProvider='N'  
     THEN Isnull(cast(ch.CheckNumber as varchar),'')+' - Under Review'   
     ELSE  
     cast(ch.CheckNumber as varchar)  
     END AS checknumber   
                    from   Checks ch  
                    where  ch.CheckId = clp.CheckId  
                    and isnull(ch.RecordDeleted, 'N') <> 'Y' )  
                                                                                 
                                                                                      
             when clh.Activity = @Refund then (select CASE WHEN  C.ReleaseToProvider='N'  
                  THEN Isnull(cast(pr.CheckNumber as varchar),'')+' - Under Review'   
                  ELSE  
               cast(pr.CheckNumber as varchar)  
               END AS checknumber   
                                               from   ProviderRefunds pr  
                                                      left join Checks C on C.CheckId= pr.ReturnedCheckId  
                                               where  pr.ProviderRefundId = clc.ProviderRefundId  
                                                      and isnull(pr.RecordDeleted, 'N') <> 'Y')  
             when clh.Activity = @Credit then (select CASE WHEN  ch.ReleaseToProvider='N'  
               THEN Isnull(cast(ch.CheckNumber as varchar),'')+' - Under Review'   
                  ELSE  
               cast(ch.CheckNumber as varchar)  
               END AS checknumber   
                                               from   Checks ch  
                                               where  ch.CheckId = clc.CheckId  
                                                      and isnull(ch.RecordDeleted, 'N') <> 'Y')  
  ELSE NULL  
  END AS Check#  
 ,clh.ActivityStaffId  
 ,isnull(clh.Reason, '') AS [Reason]  
 ,s.UserCode AS UserName  
 ,CASE   
  WHEN clh.Activity = @Adjudication  
   THEN ad.BatchId  
  ELSE NULL  
  END AS BatchId  
 ,clp.CheckId AS PaymentCheckId  
 ,clc.CheckId AS CreditCheckId  
 ,clc.ProviderRefundId  
 ,clh.adjudicationid 
 ,0 as MultipleDenialCount 
 -- 06/21/2016 Gautam
 --,(  
 -- SELECT count(*)  
 -- FROM AdjudicationDenialPendedReasons adpr  
 -- WHERE adpr.AdjudicationId = clh.adjudicationid  
 -- ) AS MultipleDenialCount  
 ,clh.RecordDeleted  
FROM ClaimLineHistory clh  
INNER JOIN GlobalCodes g ON g.GlobalCodeId = clh.STATUS  
INNER JOIN Staff s ON s.StaffId = clh.ActivityStaffId  
LEFT JOIN Adjudications ad ON clh.AdjudicationId = ad.AdjudicationId  
 AND isnull(ad.RecordDeleted, 'N') <> 'Y'  
LEFT JOIN ClaimLinePayments clp ON clh.ClaimLinePaymentId = clp.ClaimLinePaymentId  
 AND isnull(clp.RecordDeleted, 'N') <> 'Y'  
LEFT JOIN ClaimLineCredits clc ON clh.ClaimLineCreditId = clc.ClaimLineCreditId  
 AND isnull(clc.RecordDeleted, 'N') <> 'Y'  
--task#21left outer join AdjudicationDenialPendedReasons adpr on clh.AdjudicationId = adpr.AdjudicationId and IsNull(adpr.RecordDeleted,'N') <>'Y'  --task #21      
WHERE clh.ClaimLineId = @ClaimLineID  
 AND isnull(clh.RecordDeleted, 'N') <> 'Y' -- and IsNull(u.RecordDeleted,'N') <>'Y' (No need to check RecordDeleted flag for ActivityUser as per Task # 1324)                  
 AND isnull(g.RecordDeleted, 'N') <> 'Y'  
ORDER BY clh.ActivityDate DESC  
  
UPDATE CL  
SET Reason = (  
  SELECT REPLACE(REPLACE(STUFF((  
       SELECT ', #' + ISNULL(APR.Reason, '')  
       FROM AdjudicationDenialPendedReasons APR  
       WHERE APR.AdjudicationId = CL.AdjudicationId  
        AND ISNULL(APR.RecordDeleted, 'N') = 'N'  
       FOR XML PATH('')  
       ), 1, 1, ''), '&lt;', '<'), '&gt;', '>')  
  )  
FROM #ClaimLineHistory CL  
WHERE EXISTS (  
  SELECT 1  
  FROM AdjudicationDenialPendedReasons APR1  
  WHERE APR1.AdjudicationId = CL.AdjudicationId  
   AND ISNULL(APR1.RecordDeleted, 'N') = 'N'  
  )  
-- -- 06/21/2016 Gautam
UPDATE CL  
SET MultipleDenialCount = (SELECT count(*)  
  FROM AdjudicationDenialPendedReasons adpr  
  WHERE adpr.AdjudicationId = CL.adjudicationid )
FROM #ClaimLineHistory CL  

    
SELECT ClaimLineHistoryId  
 ,ClaimLineId  
 ,ActivityDate  
 ,Activity  
 ,ActivityName  
 ,STATUS  
 ,StatusName  
 ,ApprovedAmount  
 ,DeniedAmount  
 ,PaidAmount  
 ,CreditAmount  
 ,Denial#  
 ,Check#  
 ,ActivityStaffId  
 ,[Reason]  
 ,UserName  
 ,BatchId  
 ,PaymentCheckId  
 ,CreditCheckId  
 ,ProviderRefundId  
 ,AdjudicationId  
 ,MultipleDenialCount  
 ,RecordDeleted  
FROM #ClaimLineHistory  
ORDER BY ActivityDate DESC			--21-May-2018  Alok Kumar
  
--Drop Table  
DROP TABLE #ClaimLineHistory  
  
--Checking For Errors                  
IF (@@error != 0)  
BEGIN  
    RAISERROR ('ssp_GetClaimLineDetail: An Error Occured ',16,1);  
  
 RETURN  
END  
  
-- Query returns Plan Alllocation list                  
SELECT p.CoveragePlanId AS PlanId  
 ,p.CoveragePlanName AS PlanName  
 ,'$' + convert(VARCHAR, sum(clp.PaidAmount), 1) AS PaidAmount  
FROM ClaimLineCoveragePlans clp  
INNER JOIN CoveragePlans p ON clp.CoveragePlanId = p.CoveragePlanId  
WHERE clp.ClaimLineId = @ClaimLineID  
 AND isnull(clp.RecordDeleted, 'N') <> 'Y'  
 AND isnull(p.RecordDeleted, 'N') <> 'Y'  
GROUP BY p.CoveragePlanId  
 ,p.CoveragePlanName  
HAVING sum(clp.PaidAmount) > 0  
ORDER BY p.CoveragePlanName  
  
--Checking For Errors                  
IF (@@error != 0)  
BEGIN  
 RAISERROR ('ssp_GetClaimLineDetail: An Error Occured ',16,1);  
  
 RETURN  
END  
  
-- Query returns the Authorization Numbers for the ClaimLineId                  
SELECT cla.ProviderAuthorizationId  
 ,a.AuthorizationNumber 
 ,a.ProviderAuthorizationDocumentId --31-Aug-2017  SuryaBalan
FROM ClaimLineAuthorizations cla  
INNER JOIN ProviderAuthorizations a ON cla.ProviderAuthorizationId = a.ProviderAuthorizationId  
WHERE cla.ClaimLineId = @ClaimLineID  
 AND isnull(cla.RecordDeleted, 'N') <> 'Y'  
 AND isnull(a.RecordDeleted, 'N') <> 'Y'  
  
--Checking For Errors                  
IF (@@error != 0)  
BEGIN  
 RAISERROR ('ssp_GetClaimLineDetail: An Error Occured ',16,1);  
 RETURN  
END  
  
-- Query returns the Contract Rate information for the ClaimLineId (added on 01/07/2006 as per Task # 1238)                  
SELECT TOP 1 ad.ClaimLineId  
 ,ad.ContractId  
 ,c.ContractName  
 ,c.StartDate  
 ,c.EndDate  
 ,ad.ContractRateId  
 ,cr.ContractRate AS ContractRates  
 ,c.ProviderId  
 ,c.InsurerId  
 ,i.InsurerName  
FROM Adjudications ad  
LEFT JOIN ContractRates cr ON ad.ContractRateId = cr.ContractRateId  
 AND isnull(cr.RecordDeleted, 'N') = 'N'  
LEFT JOIN Contracts c ON ad.ContractId = c.ContractId  
 AND isnull(c.RecordDeleted, 'N') = 'N'  
LEFT JOIN Insurers i ON c.InsurerId = i.InsurerId  
 AND isnull(i.RecordDeleted, 'N') = 'N'  
WHERE ad.ClaimLineId = @ClaimLineID  
 AND isnull(ad.RecordDeleted, 'N') = 'N'  
ORDER BY ad.CreatedDate DESC  
  
--Checking For Errors                  
IF (@@error != 0)  
BEGIN  
 RAISERROR ('ssp_GetClaimLineDetail: An Error Occured ',16,1);  
  
 RETURN  
END  
  
-- Query returns the ClaimLine with fields needs to be updated                  
--Select cl.ClaimLineId, cl.ClaimId, cl.Status, cl.DoNotAdjudicate, cl.NeedsToBeWorked,                   
--            cl.ToReadjudicate, cl.EOBReceived, cl.Comment, cl.ModifiedBy, cl.ModifiedDate from ClaimLines cl                   
--where cl.ClaimLineId = @ClaimLineID and IsNull(cl.RecordDeleted,'N') <> 'Y'           
--Checking For Errors                  
IF (@@error != 0)  
BEGIN  
 RAISERROR ('ssp_GetClaimLineDetail: An Error Occured ',16,1);  
  
 RETURN  
END  
  
RETURN  
GO


