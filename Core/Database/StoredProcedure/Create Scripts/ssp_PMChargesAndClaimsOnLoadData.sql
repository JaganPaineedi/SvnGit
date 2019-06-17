IF EXISTS 
( 
       SELECT * 
       FROM   sys.objects 
       WHERE  object_id = Object_id(N'[ssp_PMChargesAndClaimsOnLoadData]') 
       AND    type IN (N'P', 
                       N'PC')) 
DROP PROCEDURE [ssp_PMChargesAndClaimsOnLoadData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[ssp_PMChargesAndClaimsOnLoadData] @ChargeId INT
AS /******************************************************************************   
** File: ssp_PMChargesAndClaimsOnLoadData.sql  
** Name: ssp_PMChargesAndClaimsOnLoadData  
** Desc:    
**   
**   
** This template can be customized:   
**   
** Return values: Filter Values - BillingCodes Tab  
**   
** Called by:   
**   
** Parameters:   
** Input Output   
** ---------- -----------   
** N/A   Dropdown values  
** Auth: Mary Suma  
** Date: 06/06/2011  
*******************************************************************************   
** Change History   
*******************************************************************************   
** Date:    Author:    Description:   
** 06/06/2011  Mary Suma   Query to get Charges and Claims Details page data  
--------    --------    ---------------   
-- 24 Aug 2011  Girish  Removed References to Rowidentifier and/or ExternalReferenceId  
-- 27 Aug 2011  Girish  Readded References to Rowidentifier and ExternalReferenceId  
-- 20 June 2012  MSuma  Retrieve Billing History Information   
-- 10 Oct 2013  Deej  Removed the Timestamp from ProcessedDate  
-- 07 Jan 2014  Venkatesh MR Get the Claimline ItemId based on chargeId w.r.t Task #1329 Core bugs  
-- 10 Jul 2014      Venkatesh MR    Move the Recored deleted functionality in to Left Join condition w.r.t Task #1565 Core bugs    
-- 10 Oct 2015      Shankha   Task #226 Engineering Improvements  
/* 16 Oct 2015		Revathi			what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.         
									why:task #609, Network180 Customization*/
-- 06 Jun 2016		NJain		Modified to append complete Error Description to Global Code Name in Charge Errors	
-- 10 Feb 2017 Vithobha  Added InternalCollections columns in Clients table & ExternalCollectionStatus in Charges table Renaissance - Dev Items #830 
-- 07 Jul 2017     Ajay         Added columns in Charges table and added ChargeStatusHistory table.  AHN - Customization #Task:44								
-- 07 Jul 2017	Malathi Shiva   Included a select Query for Action History tab of Charge Details screen - AHN - Customization #Task:44	
-- 23 Nov 2017  Kishore Kumar Das        Commented (ISNULL(P.RecordDeleted, 'N') = 'N') and
											      (ISNULL(L.RecordDeleted, 'N') = 'N') and
												  (ISNULL(PC.RecordDeleted, 'N') = 'N') these three statement for the task Renaissance - Dev Items #830
--11 Dec 2017  Veena Mani			Added record deleted check for   CEI - Support Go Live #881 -Billing history showing deleted records.

*******************************************************************************/
    DECLARE @PayerPayment MONEY

    BEGIN
        BEGIN TRY
		--Table 1 Charge & Plan Data      
            SELECT  C.ChargeId ,
                    C.ServiceId ,
                    C.ClientCoveragePlanId ,
                    C.Priority ,
                    C.ReadyToBill ,
                    C.Rebill ,
                    C.Flagged ,
                    C.ExpectedPayment ,
                    C.ExpectedAdjustment ,
                    C.ClientCopay ,
                    C.FirstBilledDate ,
                    C.LastBilledDate ,
                    C.BillingCode ,
                    C.Modifier1 ,
                    C.Modifier2 ,
                    C.Modifier3 ,
                    C.Modifier4 ,
                    C.RevenueCode ,
                    C.RevenueCodeDescription ,
                    C.Units ,
                    C.DoNotBill ,
                    C.CreatedBy ,
                    C.CreatedDate ,
                    C.ModifiedBy ,
                    C.ModifiedDate ,
                    C.RecordDeleted ,
                    C.DeletedDate ,
                    C.DeletedBy ,
                    C.RowIdentifier ,
                    CP.DisplayAs AS PlanName ,
                    C.Comments ,
                    C.OverrideBillingCodes ,
                    C.OverrideBy ,
                    C.OverrideDate
                    -- 10 Feb 2017 Vithobha
                    ,dbo.csf_GetGlobalCodeNameById(C.ExternalCollectionStatus) as ExternalCollectionStatus
                    ,C.ChargeStatus       --Added by Ajay 
					,C.StatusDate
					,C.ExcludeChargeFromQueue 
					,C.StatusComments
					,C.DoNotCountTowardProductivity -- End
            FROM    Charges C --Modified by Venkatesh for task Core Bugs 1565  
                    LEFT OUTER JOIN ClientCoveragePlans CCP ON C.ClientCoveragePlanId = CCP.ClientCoveragePlanId
                                                               AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
                    LEFT JOIN CoveragePlans CP ON CCP.CoveragePlanId = CP.CoveragePlanId
                                                  AND ISNULL(CP.RecordDeleted, 'N') = 'N'
            WHERE   ChargeId = @ChargeId
                    AND ISNULL(C.RecordDeleted, 'N') = 'N'

		--Checking For Errors      
		--If (@@error!=0)   Begin RAISERROR  20006   'ssp_PMChargesAndClaimsOnLoadData: An Error Occured'  Return  End      
		-- Table 2 Client & Services Data      
            SELECT  S.ClientId --Added by Revathi 16 Oct 2015
                    ,
                    CAST(C.ClientId AS VARCHAR) + ' - ' + CASE WHEN ISNULL(C.ClientType, 'I') = 'I' THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
                                                               ELSE C.OrganizationName
                                                          END AS ClientName ,
                    CASE WHEN ISNULL(C.ClientType, 'I') = 'I' THEN ISNULL(C.LastName, '') + ' , ' + ISNULL(C.FirstName, '')
                         ELSE C.OrganizationName
                    END AS DisplayClientName ,
                    S.ServiceId ,
			--S.DateOfService,      
                    CONVERT(VARCHAR(19), s.DateOfService, 101) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), s.DateOfService, 100), 12, 6)) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), s.DateOfService, 100), 18, 2)) AS DateOfService ,
                    S.ProcedureCodeId ,
                    S.ClinicianId ,
                    S.ProgramId ,
                    S.LocationId ,
                    PC.DisplayAs + ' - ' + CAST(S.Unit AS VARCHAR) + '  ' + GCUnitType.CodeName AS ProcedureCode ,
                    St.LastName + ', ' + St.FirstName AS ClinicianName ,
                    P.ProgramCode AS Program ,
                    L.LocationCode AS Location ,
                    '$' + CONVERT(VARCHAR, S.Charge, 25) AS Charge ,
                    S.ProcedureRateId
                    -- 10 Feb 2017 Vithobha
                    ,CASE WHEN C.InternalCollections = 'Y' THEN 'Yes'  
                     ELSE 'No'  
                     END AS InternalCollections
            FROM    Clients C
                    INNER JOIN Services S ON C.ClientId = S.ClientId
                    INNER JOIN Charges CH ON CH.ServiceId = S.ServiceId
                    INNER JOIN ProcedureCodes PC ON S.ProcedureCodeId = PC.ProcedureCodeId
                    INNER JOIN GlobalCodes GCUnitType ON S.UnitType = GCUnitType.GlobalCodeId
                    LEFT OUTER JOIN Staff St ON St.StaffId = S.ClinicianId
                    LEFT OUTER JOIN Programs P ON P.ProgramId = S.ProgramId
                    LEFT OUTER JOIN Locations L ON L.LocationId = S.LocationId
            WHERE   CH.ChargeId = @ChargeId
                    AND ISNULL(S.RecordDeleted, 'N') = 'N'
                    AND ISNULL(C.RecordDeleted, 'N') = 'N'
                    AND ISNULL(CH.RecordDeleted, 'N') = 'N'
			-- AND ISNULL(St.RecordDeleted, 'N') = 'N'  
                   -- AND ISNULL(P.RecordDeleted, 'N') = 'N'
                   -- AND ISNULL(L.RecordDeleted, 'N') = 'N'
                  --  AND ISNULL(PC.RecordDeleted, 'N') = 'N'
                    AND ISNULL(GCUnitType.RecordDeleted, 'N') = 'N'

		--Checking For Errors      
		--If (@@error!=0)   Begin RAISERROR  20006   'ssp_PMChargesAndClaimsOnLoadData: An Error Occured'  Return  End      
		--Table 3 Payer Payment  and Payment is combined to handle datasets   
            SELECT  @PayerPayment = 0 - ISNULL(SUM(ARL.amount), 0)
            FROM    ARLedger ARL
            WHERE   ARL.LedgerType = 4202
                    AND ARL.ChargeId = @ChargeId
                    AND ISNULL(ARL.RecordDeleted, 'N') = 'N'
            GROUP BY ARL.Chargeid

            SELECT  '$' + CONVERT(VARCHAR, @PayerPayment, 25) AS PayerPayment

		--Table 4 Payment Id   
            SELECT  ARL.PaymentId AS PaymentId ,
                    FAL.FinancialActivityId AS FinancialActivityId
            FROM    ARLedger ARL
                    INNER JOIN FinancialActivityLines FAL ON ARL.FinancialActivityLineId = FAL.FinancialActivityLineId
            WHERE   FAL.FinancialActivityLineId = ( SELECT  MAX(FinancialActivityLineId)
                                                    FROM    ARLedger
                                                    WHERE   ChargeId = @ChargeId
                                                            AND ISNULL(RecordDeleted, 'N') = 'N'
                                                            AND LedgerType = 4202
                                                  )
                    AND LedgerType = 4202
                    AND ISNULL(ARL.RecordDeleted, 'N') = 'N'
                    AND ISNULL(FAL.RecordDeleted, 'N') = 'N'
			--Checking For Errors      
			--If (@@error!=0)   Begin RAISERROR  20006   'ssp_PMChargesAndClaimsOnLoadData: An Error Occured'  Return  End      
			--Table 5 Billing History Data     
			-- SELECT     
			-- BH.ChargeId,     
			-- BH.BilledDate,   
			-- CONVERT(VARCHAR,BH.BilledDate,101)  AS BilledDateFormatted,    
			-- BH.ClaimBatchId,     
			-- CB.ClaimProcessId ,     
			-- CB.ProcessedDate,  
			-- CONVERT(VARCHAR,CB.ProcessedDate,101) AS ProcessedDateFormatted,    
			-- BH.CreatedBy,Electronic         
			-- FROM     
			-- BillingHistory BH     
			--LEFT OUTER JOIN ClaimBatches CB ON  BH.ClaimBatchId = CB.ClaimBatchId        
			--LEFT OUTER JOIN ClaimFormats CF on CF.ClaimFormatId = CB.ClaimFormatId        
			-- WHERE     
			--ChargeId = @ChargeId     
			--AND ISNULL(BH.RecordDeleted,'N')='N'     
			--AND ISNULL(CB.RecordDeleted,'N')='N'     
			--AND ISNULL(CF.RecordDeleted,'N')='N'    
			;

            WITH    ClaimLineItem
                      AS ( SELECT   CLIG.ClaimBatchId ,
                                    CI.ClaimLineItemId ,
                                    CLIC.ChargeId ,
                                    CI.RevenueCode ,
                                    CI.ChargeAmount ,
                                    RTRIM(LTRIM(ISNULL(CI.BillingCode, '') + ' ' + ISNULL(CI.Modifier1, '') + ' ' + ISNULL(CI.Modifier2, '') + ' ' + ISNULL(CI.Modifier3, '') + ' ' + ISNULL(CI.Modifier4, ''))) AS BillingCodeModifiers
                           FROM     ClaimLineItemCharges CLIC
                                    JOIN dbo.ClaimLineItems CI ON CI.ClaimLineItemId = CLIC.ClaimLineItemId
                                                                  AND CLIC.ChargeId = @ChargeId
                                    JOIN dbo.ClaimLineItemGroups CLIG ON CLIG.ClaimLineItemGroupId = CI.ClaimLineItemGroupId
                         )
                SELECT  BH.ChargeId ,
                        BH.BilledDate ,
                        CONVERT(VARCHAR, BH.BilledDate, 101) AS BilledDateFormatted ,
                        BH.ClaimBatchId ,
                        CB.ClaimProcessId ,
                        CB.ProcessedDate ,
                        CONVERT(VARCHAR, CB.ProcessedDate, 101) AS ProcessedDateFormatted ,
                        BH.CreatedBy ,
                        Electronic ,
                        CLI.ClaimLineItemId ,
                        CLI.ChargeAmount ,
                        CLI.RevenueCode ,
                        CLI.BillingCodeModifiers
                FROM    BillingHistory BH
                        LEFT OUTER JOIN ClaimBatches CB ON BH.ClaimBatchId = CB.ClaimBatchId
                                                           AND ISNULL(CB.RecordDeleted, 'N') = 'N'
                        LEFT OUTER JOIN ClaimFormats CF ON CF.ClaimFormatId = CB.ClaimFormatId
                                                           AND ISNULL(CF.RecordDeleted, 'N') = 'N'
                        LEFT OUTER JOIN ClaimLineItem CLI ON CLI.ClaimBatchId = BH.ClaimBatchId
                WHERE   BH.ChargeId = @ChargeId 
                --Condition added by Veena on 12/11/2017 for CEI - Support Go Live #881 -Billing history showing deleted records.
                and ISNULL(BH.RecordDeleted, 'N') = 'N' 

		--AND ISNULL(CB.RecordDeleted, 'N') = 'N'  
		--Checking For Errors      
		-- IF (@@error!=0)     
		--BEGIN RAISERROR  20006   'ssp_PMChargesAndClaimsOnLoadData: An Error Occured'  Return  End      
		--Table 6 Charge Error Data       
            SELECT  ChargeErrorId ,
                    CE.ChargeId ,
                    CE.ErrorType ,
                    GC.CodeName + ' - ' + ErrorDescription AS CodeName,
                    CE.ErrorDescription ,
                    CE.RowIdentifier ,
                    CE.CreatedBy ,
                    CE.CreatedDate ,
                    CE.ModifiedBy ,
                    CE.ModifiedDate ,
                    CE.RecordDeleted ,
                    CE.DeletedDate ,
                    CE.DeletedBy
            FROM    ChargeErrors CE
                    INNER JOIN GlobalCodes GC ON CE.ErrorType = GC.GlobalCodeId
            WHERE   ISNULL(GC.RecordDeleted, 'N') = 'N'
                    AND ISNULL(CE.RecordDeleted, 'N') = 'N'
                    AND ChargeId = @ChargeId

		/******************************************************************************        
 **      Table: 07 ArLedger Entries.        
 ******************************************************************************/
            IF OBJECT_ID('#FinancialActivitySummary') IS NOT NULL
                BEGIN
                    DROP TABLE #FinancialActivitySummary;
                END

            SELECT  A.ArLedgerId ,
                    FA.FinancialActivityId ,
                    FAL.FinancialActivityLineId ,
                    P.PaymentId ,
                    CH.ServiceId AS ServiceId ,
                    A.ChargeId ,
                    PostedDate ,
                    GC.GlobalCodeId ,
                    GC.CodeName AS Activity ,
                    ISNULL(RTRIM(Cp.DisplayAs) + ' ' + ISNULL(CCP.InsuredId, ''), 'Client') AS Payer ,
                    GCL.CodeName AS Type ,
                    A.Amount ,
                    P.ReferenceNumber ,
                    FAL.Comment ,
                    ISNULL(MarkedAsError, 'N') AS MarkedAsError ,
                    A.CreatedBy ,
                    A.CreatedDate ,
                    CH.ClientCoveragePlanId ,
                    ISNULL(ErrorCorrection, 'N') AS ErrorCorrection ,
                    A.RecordDeleted ,
                    A.AccountingPeriodId ,
                    CASE WHEN FAL.Flagged = 'Y' THEN 1
                         ELSE 0
                    END AS FlaggedButton ,
                    FAL.CurrentVersion ,
                    S.ClientId
            INTO    #FinancialActivitySummary
            FROM    ArLedger A
                    LEFT JOIN FinancialActivityLines FAL ON FAL.FinancialActivityLineId = A.FinancialActivityLineId
                    LEFT JOIN FinancialActivities FA ON FA.FinancialActivityId = FAL.FinancialActivityId
                    LEFT JOIN Payments P ON FA.FinancialActivityId = P.FinancialActivityId
                    LEFT JOIN GlobalCodes GC ON FA.ActivityType = GC.GlobalCodeID
                    LEFT JOIN GlobalCodes GCL ON A.LedgerType = GCL.GlobalCodeID
                    LEFT JOIN Charges CH ON A.ChargeId = CH.ChargeId
                    LEFT JOIN Services S ON S.ServiceId = CH.ServiceId
                    LEFT JOIN ClientCoveragePlans CCP ON CH.ClientCoveragePlanId = CCP.ClientCoveragePlanId
                    LEFT JOIN CoveragePlans Cp ON CP.CoveragePlanId = CCP.CoveragePlanId
            WHERE   A.ChargeId = @ChargeId
                    AND ( A.RecordDeleted IS NULL
                          OR A.RecordDeleted = 'N'
                        )
            ORDER BY PostedDate DESC ,
                    LedgerType DESC

            SELECT  *
            FROM    #FinancialActivitySummary
            
            select                       
			CSH.ChargeStatusHistoryId
			,CSH.CreatedBy
			,CSH.CreatedDate
			,CSH.ModifiedBy
			,CSH.ModifiedDate
			,CSH.RecordDeleted
			,CSH.DeletedBy
			,CSH.DeletedDate
			,CSH.ChargeId
			,CSH.StatusDate
			,CSH.ChargeStatus 
			,gc.CodeName as ChargeStatusText
			from ChargeStatusHistory CSH
			LEFT JOIN GlobalCodes gc ON CSH.ChargeStatus= gc.GlobalCodeId AND ISNULL(gc.RecordDeleted,'N')='N'  
			Where CSH.ChargeId = @ChargeId
			AND ISNULL(CSH.RecordDeleted,'N')='N' 
			order by ModifiedDate DESC 
			
    SELECT                        
    RWQMWQ.RWQMWorkQueueId   
	,RWQMWQ.CreatedBy
	,RWQMWQ.CreatedDate
	,RWQMWQ.ModifiedBy
	,RWQMWQ.ModifiedDate
	,RWQMWQ.RecordDeleted
	,RWQMWQ.DeletedBy
	,RWQMWQ.DeletedDate
	,RWQMWQ.ChargeId
	,RWQMWQ.FinancialAssignmentId
	,RWQMWQ.RWQMRuleId
	,RWQMWQ.RWQMActionId
	,RWQMWQ.ClientContactNoteId
	,RWQMWQ.CompletedBy
	,RWQMWQ.DueDate
	,RWQMWQ.OverdueDate
	,RWQMWQ.CompletedDate
	,RWQMWQ.ActionComments
   ,SAssigned.LastName + ', ' + SAssigned.FirstName AS AssignedStaff  
   ,SBackup.LastName + ', ' + SBackup.FirstName AS BackUpStaff  
   ,Rules.RWQMRuleName  
   ,Actions.ActionName  
   ,CCN.ContactDateTime   
   ,SCompletedBy.LastName + ', ' + SCompletedBy.FirstName AS CompletedByName 
   ,S.ClientId  
FROM RWQMWorkQueue RWQMWQ
			LEFT JOIN RWQMRules Rules on Rules.RWQMRuleId = RWQMWQ.RWQMRuleId AND ISNULL(Rules.RecordDeleted,'N')='N'
			LEFT JOIN FinancialAssignments FA on FA.FinancialAssignmentId = RWQMWQ.FinancialAssignmentId
			LEFT JOIN Staff SAssigned on SAssigned.StaffId = FA.RWQMAssignedId
			LEFT JOIN Staff SBackup on SBackup.StaffId = FA.RWQMAssignedBackupId   
            LEFT JOIN Staff SCompletedBy on SCompletedBy.StaffId = RWQMWQ.CompletedBy 
			LEFT JOIN RWQMActions Actions on Actions.RWQMActionId = RWQMWQ.RWQMActionId AND ISNULL(Actions.RecordDeleted,'N')='N'
			LEFT JOIN ClientContactNotes CCN on CCN.ClientContactNoteId = RWQMWQ.ClientContactNoteId AND ISNULL(CCN.RecordDeleted,'N')='N'
   INNER JOIN Charges Ch On  RWQMWQ.ChargeId= Ch.ChargeId AND ISNULL(Ch.RecordDeleted,'N')='N'
   INNER JOIN Services S ON Ch.ServiceId=S.ServiceId AND ISNULL(S.RecordDeleted,'N')='N'
			WHERE RWQMWQ.ChargeId = @ChargeId
			AND ISNULL(RWQMWQ.RecordDeleted,'N')='N'
			ORDER BY RWQMWQ.CreatedDate DESC
     
    
        END TRY  
  
        BEGIN CATCH  
            DECLARE @Error VARCHAR(8000)  
  
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMChargesAndClaimsOnLoadData') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' 
+ CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
            RAISERROR (  
    @Error  
    ,-- Message text.    
    16  
    ,-- Severity.    
    1 -- State.    
    );  
        END CATCH  
    END  
  
GO
