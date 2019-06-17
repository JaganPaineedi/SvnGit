IF OBJECT_ID('[SSP_SCGetClaimLineItemDetails]') IS NOT NULL
	DROP PROCEDURE [dbo].[SSP_SCGetClaimLineItemDetails]
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetClaimLineItemDetails] @ClaimLineItemId BIGINT
AS
-- =============================================        
-- Author:  Pradeep        
-- Create date: Oct 12, 2015        
-- Description: Get the ClaimLineItem details   
/*        
 Author   Modified Date   Reason        
--- 19/10/2015 Vkhare  Modified for task Engineering Improvement Initiatives- NBL(I) #233  
    11/11/2015 Seema   Why:Modified for task Engineering Improvement Initiatives- NBL(I) #226 
					   What:Formatting Amount Column 
 -- 29-MAR-2016 Akwinass What:Included columns into ClaimLineItems and ClaimLineItemGroups
 --					     Why:task #226.2 Engineering Improvement Initiatives- NBL(I)  
--01-APRIL-2016 Akwinass What:Included ClientId,ServiceId columns into ClaimLineItems
 --					     Why:task #226.2 Engineering Improvement Initiatives- NBL(I)       
 -- JUL-05-2016 Dknewtson What: Removed ServiceId from initial result set, pulling MAX(DOS) instead of DOS
                              Why:task #623 Valley Support Go Live - Unable to save to be voided checkbox.  
 -- DEC-01-2016 Chethan N What: Casting DateOfService from Date to DateTime.
                          Why: Bradford - Support Go Live task #279.    
*/
-- =============================================        
BEGIN
	BEGIN TRY
		CREATE TABLE #Payments (
			ChargeId INT
			,PaidAmount MONEY
			,PaymentId INT
			,FinancialActivityId INT
			,FinancialActivityLineId INT
			)

		INSERT INTO #Payments (
			ChargeId
			,PaidAmount
			,FinancialActivityLineId
			)
		SELECT CLIC.ChargeId
			,- SUM(arl.Amount)
			,MAX(arl.FinancialActivityLineId)
		FROM ClaimLineItems CLI
		LEFT JOIN ClaimLineItemCharges CLIC ON CLIC.ClaimLineItemId = CLI.ClaimLineItemId
		INNER JOIN ARLedger arl ON arl.ChargeId = CLIC.ChargeId
		WHERE arl.LedgerType = 4202
			AND CLI.ClaimLineItemId = @ClaimLineItemId
			AND ISNULL(arl.RecordDeleted, 'N') = 'N'
		GROUP BY CLIC.ChargeId

		SELECT DISTINCT CLI.ClaimLineItemId
			,CLI.CreatedBy
			,CLI.CreatedDate
			,CLI.ModifiedBy
			,CLI.ModifiedDate
			,CLI.RecordDeleted
			,CLI.DeletedDate
			,CLI.DeletedBy
			,CLI.ClaimLineItemGroupId
			,CLI.BillingCode
			,CLI.Modifier1
			,CLI.Modifier2
			,CLI.Modifier3
			,CLI.Modifier4
			,CLI.RevenueCode
			,CLI.RevenueCodeDescription
			,CLI.Units
			,CLI.DateOfService
			,MAX(CONVERT(VARCHAR(19), S.DateOfService, 101) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), S.DateOfService, 100), 12, 6)) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), S.DateOfService, 100), 18, 2))) AS DOS
			,CLI.ChargeAmount
			,CLI.VoidedClaim
			,CLI.OriginalClaimLineItemId
			,CLI.ToBeVoided
			,CLI.ToBeResubmitted
			,CLI.ResubmittedClaim
			,CLI.Comments
			,CLI.OverrideClaimLineItems
			,CLI.OverrideBy
			,CLI.OverrideDate
			,CLIG.ClaimBatchId
			,P.PayerName
			-- 29-MAR-2016 Akwinass
			,CLI.OverrideBillingCodes
			,CLI.BillingCodesOverrideBy
			,CLI.BillingCodesOverrideDate
			,ccp.ClientId
			,NULL AS ServiceId
		FROM ClaimLineItems CLI
		INNER JOIN ClaimLineItemGroups CLIG ON CLIG.ClaimLineItemGroupId = CLI.ClaimLineItemGroupId
		LEFT JOIN ClaimLineItemCharges CLIC ON CLIC.ClaimLineItemId = CLI.ClaimLineItemId
		LEFT JOIN Charges CH ON CH.ChargeId = CLIC.ChargeId
		LEFT JOIN Services S ON CH.ServiceId = S.ServiceId
		LEFT JOIN ClientCoveragePlans CCP ON CCP.ClientCoveragePlanId = CH.ClientCoveragePlanId
		LEFT JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
		LEFT JOIN Payers P ON P.PayerId = CP.PayerId
		WHERE CLI.ClaimLineItemId = @ClaimLineItemId
			AND ISNULL(CLI.RecordDeleted, 'N') = 'N'
		GROUP BY CLI.ClaimLineItemId
			,CLI.CreatedBy
			,CLI.CreatedDate
			,CLI.ModifiedBy
			,CLI.ModifiedDate
			,CLI.RecordDeleted
			,CLI.DeletedDate
			,CLI.DeletedBy
			,CLI.ClaimLineItemGroupId
			,CLI.BillingCode
			,CLI.Modifier1
			,CLI.Modifier2
			,CLI.Modifier3
			,CLI.Modifier4
			,CLI.RevenueCode
			,CLI.RevenueCodeDescription
			,CLI.Units
			,CLI.DateOfService
			,CLI.ChargeAmount
			,CLI.VoidedClaim
			,CLI.OriginalClaimLineItemId
			,CLI.ToBeVoided
			,CLI.ToBeResubmitted
			,CLI.ResubmittedClaim
			,CLI.Comments
			,CLI.OverrideClaimLineItems
			,CLI.OverrideBy
			,CLI.OverrideDate
			,CLIG.ClaimBatchId
			,P.PayerName
			-- 29-MAR-2016 Akwinass
			,CLI.OverrideBillingCodes
			,CLI.BillingCodesOverrideBy
			,CLI.BillingCodesOverrideDate
			,ccp.ClientId

		SELECT DISTINCT CLIC.ClaimLineItemChargeId
			,CLIC.ClaimLineItemId
			,CLIC.ChargeId
			,CLIC.RowIdentifier
			,CLIC.CreatedBy
			,CLIC.CreatedDate
			,CLIC.ModifiedBy
			,CLIC.ModifiedDate
			,CLIC.RecordDeleted
			,CLIC.DeletedDate
			,CLIC.DeletedBy
			,CASE CH.Flagged
				WHEN 'Y'
					THEN 'Yes'
				ELSE ''
				END AS Flagged
			,CP.CoveragePlanName
			,S.Charge AS ChargeAmount
			,OC.Balance AS Balance
			,CASE 
				WHEN ch.LastBilledDate IS NULL
					AND ch.Priority <> 0
					AND ISNULL(CP.Capitated, 'N') <> 'Y'
					AND OC.Balance > 0
					THEN OC.Balance
				ELSE NULL
				END AS UnbilledAmount
			,p.PaidAmount AS PaidAmount
			,Convert(VARCHAR(10), CH.LastBilledDate, 101) AS BillDate
			,C.LastName + ', ' + C.FirstName AS DisplayClientName
			,convert(VARCHAR(19), s.DateOfService, 101) + ' ' + ltrim(substring(convert(VARCHAR(19), s.DateOfService, 100), 12, 6)) + ' ' + ltrim(substring(convert(VARCHAR(19), s.DateOfService, 100), 18, 2)) AS DOS
			,St.LastName + ', ' + St.FirstName AS ClinicianName
			,PC.ProcedureCodeName
			,C.ClientId
			,S.ServiceId
			,CH.Comments
		FROM ClaimLineItemCharges CLIC
		INNER JOIN ClaimLineItems CLI ON CLI.ClaimLineItemId = CLIC.ClaimLineItemId
		INNER JOIN Charges CH ON CH.ChargeId = CLIC.ChargeId
		LEFT JOIN #Payments p ON P.ChargeId = CH.ChargeId
		LEFT JOIN OpenCharges OC ON OC.ChargeId = CH.ChargeId
		LEFT JOIN ARLedger ARL ON ARL.FinancialActivityLineId = P.FinancialActivityLineId
		LEFT JOIN ClientCoveragePlans CCP ON CCP.ClientCoveragePlanId = CH.ClientCoveragePlanId
		LEFT JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
		LEFT JOIN Clients C ON C.ClientId = CCP.ClientId
		LEFT JOIN Services S ON S.ServiceId = CH.ServiceId
		LEFT JOIN Staff St ON St.StaffId = S.ClinicianId
		LEFT JOIN ProcedureCodes PC ON PC.ProcedureCodeId = S.ProcedureCodeId
		WHERE CLIC.ClaimLineItemId = @ClaimLineItemId
			AND ISNULL(CLIC.RecordDeleted, 'N') = 'N'

		SELECT A.ArLedgerId
			,FA.FinancialActivityId
			,FAL.FinancialActivityLineId
			,P.PaymentId
			,CH.ServiceId AS ServiceId
			,A.ChargeId
			,Convert(VARCHAR(10), PostedDate) AS PostedDate
			,GC.GlobalCodeId
			,GC.CodeName AS Activity
			,isnull(RTRIM(Cp.DisplayAs) + ' ' + isnull(CCP.InsuredId, ''), 'Client') AS Payer
			,GCL.CodeName AS [Type]
			--11/11/2015 Modified by Seema
			,CASE 
				WHEN A.Amount < 0
					THEN '$(' + Convert(VARCHAR(10), ABS(A.Amount)) + ')'
				ELSE '$' + Convert(VARCHAR(10), ABS(A.Amount))
				END AS Amount
			,P.ReferenceNumber AS [Check]
			,FAL.Comment AS Reason
			,isnull(MarkedAsError, 'N') AS MarkedAsError
			,A.CreatedBy
			,Convert(VARCHAR(10), A.CreatedDate) AS CreatedDate
			,CH.ClientCoveragePlanId
			,isnull(ErrorCorrection, 'N') AS ErrorCorrection
			,A.RecordDeleted
			,A.AccountingPeriodId
			,Convert(VARCHAR(10), CASE 
					WHEN FAL.Flagged = 'Y'
						THEN 1
					ELSE 0
					END) AS FlaggedButton
			,Convert(VARCHAR(10), FAL.CurrentVersion) AS CurrentVersion
			,S.ClientId
			,St.LastName + ', ' + St.FirstName AS Clinician
			,ProcedureCodeName AS [Procedure]
			,S.Unit AS Units
			,convert(VARCHAR(19), s.DateOfService, 101) + ' ' + ltrim(substring(convert(VARCHAR(19), s.DateOfService, 100), 12, 6)) + ' ' + ltrim(substring(convert(VARCHAR(19), s.DateOfService, 100), 18, 2)) AS DOS
			,'' AS AdjCode
		INTO #FinancialActivitySummary
		FROM ArLedger A
		LEFT JOIN FinancialActivityLines FAL ON FAL.FinancialActivityLineId = A.FinancialActivityLineId
		LEFT JOIN FinancialActivities FA ON FA.FinancialActivityId = FAL.FinancialActivityId
		LEFT JOIN Payments P ON FA.FinancialActivityId = P.FinancialActivityId
		LEFT JOIN GlobalCodes GC ON FA.ActivityType = GC.GlobalCodeID
		LEFT JOIN GlobalCodes GCL ON A.LedgerType = GCL.GlobalCodeID
		LEFT JOIN Charges CH ON A.ChargeId = CH.ChargeId
		LEFT JOIN ClaimLineItemCharges CLI ON CLI.ChargeId = CH.ChargeId
		LEFT JOIN Services S ON S.ServiceId = CH.ServiceId
		LEFT JOIN ClientCoveragePlans CCP ON CH.ClientCoveragePlanId = CCP.ClientCoveragePlanId
		LEFT JOIN CoveragePlans Cp ON CP.CoveragePlanId = CCP.CoveragePlanId
		LEFT JOIN ProcedureCodes PR ON PR.ProcedureCodeId = S.ProcedureCodeId
		LEFT JOIN Staff ST ON St.StaffId = S.ClinicianId
		WHERE CLI.ClaimLineItemId = @ClaimLineItemId
			AND (
				A.RecordDeleted IS NULL
				OR A.RecordDeleted = 'N'
				)
		ORDER BY PostedDate DESC
			,LedgerType DESC

		SELECT *
		FROM #FinancialActivitySummary

		SELECT C.ChargeId
			,Convert(VARCHAR(100), C.ChargeId) + '-' + + CONVERT(VARCHAR(19), s.DateOfService, 101) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), s.DateOfService, 100), 12, 6)) + ' ' + ltrim(substring(convert(VARCHAR(19), s.DateOfService, 100), 18, 2)) + ',' + + convert(VARCHAR, convert(DECIMAL(8, 2), S.Unit)) + ',' + + PC.ProcedureCodeName + ',' + + (St.LastName + ', ' + St.FirstName) AS ChargeFilterTableText
		FROM Charges C
		INNER JOIN Services S ON C.ServiceId = S.ServiceId
		LEFT JOIN ProcedureCodes PC ON S.ProcedureCodeId = PC.ProcedureCodeId
		LEFT JOIN Staff ST ON ST.StaffId = S.ClinicianId
		LEFT JOIN ClaimLineItemCharges CLIC ON CLIC.ChargeId = C.ChargeId
		WHERE CLIC.ClaimLineItemId = @ClaimLineItemId

		-- 29-MAR-2016 Akwinass
		DECLARE @PayerClaimNumber835 VARCHAR(30)

		SELECT TOP 1 @PayerClaimNumber835 = PayerClaimNumber
		FROM ERClaimLineItems
		WHERE ClaimLineItemId = @ClaimLineItemId
			AND ISNULL(RecordDeleted, 'N') = 'N'

		-- Section 1 (Claim Details Tab)   
		SELECT TOP 1 CLIG.ClaimLineItemGroupId
			,CLIG.ClaimBatchId
			,CLIG.ClientId
			,CLIG.RowIdentifier
			,CLIG.CreatedBy
			,CLIG.CreatedDate
			,CLIG.ModifiedBy
			,CLIG.ModifiedDate
			,CLIG.RecordDeleted
			,CLIG.DeletedDate
			,CLIG.DeletedBy
			-- 29-MAR-2016 Akwinass
			,CLIG.PayerClaimNumber
			,@PayerClaimNumber835 AS PayerClaimNumber835
		FROM ClaimLineItemGroups CLIG
		INNER JOIN ClaimLineItems CLI ON CLIG.ClaimLineItemGroupId = CLI.ClaimLineItemGroupId
		WHERE CLI.ClaimLineItemId = @ClaimLineItemId
			AND ISNULL(CLIG.RecordDeleted, 'N') = 'N'
			AND ISNULL(CLI.RecordDeleted, 'N') = 'N'

		DECLARE @ClaimLineItemGroupId INT = 0

		SELECT @ClaimLineItemGroupId = CLIG.ClaimLineItemGroupId
		FROM ClaimLineItemGroups CLIG
		INNER JOIN ClaimLineItems CLI ON CLIG.ClaimLineItemGroupId = CLI.ClaimLineItemGroupId
		WHERE CLI.ClaimLineItemId = @ClaimLineItemId
			AND ISNULL(CLI.RecordDeleted, 'N') = 'N'
			AND ISNULL(CLIG.RecordDeleted, 'N') = 'N'

		SELECT CLI.ClaimLineItemId
			,RTRIM(LTRIM(Isnull(CLI.BillingCode, '') + ' ' + Isnull(CLI.Modifier1, '') + ' ' + Isnull(CLI.Modifier2, '') + ' ' + Isnull(CLI.Modifier3, '') + ' ' + Isnull(CLI.Modifier4, ''))) AS BillingCodeModifiers
			,CLI.RevenueCode
			,CLI.RevenueCodeDescription
			,CLI.Units
			,CAST(CLI.DateOfService AS DATETIME) AS DateOfService
			,CLI.ChargeAmount
			,CASE IsNull(CLI.VoidedClaim, 'N')
				WHEN 'Y'
					THEN 'Yes'
				ELSE ''
				END AS VoidedClaim
			,CLI.OriginalClaimLineItemId
			,CASE IsNull(CLI.ToBeVoided, 'N')
				WHEN 'Y'
					THEN 'Yes'
				ELSE ''
				END AS ToBeVoided
			,CASE IsNull(CLI.ToBeResubmitted, 'N')
				WHEN 'Y'
					THEN 'Yes'
				ELSE ''
				END AS ToBeResubmitted
			,CASE IsNull(CLI.ResubmittedClaim, 'N')
				WHEN 'Y'
					THEN 'Yes'
				ELSE ''
				END AS ResubmittedClaim
			,CLI.Comments
			,CASE IsNull(CLI.OverrideClaimLineItems, 'N')
				WHEN 'Y'
					THEN 'Yes'
				ELSE ''
				END AS OverrideClaimLineItems
			,S.DisplayAs OverrideBy
			,CLI.OverrideDate
			,Convert(VARCHAR(10), CLI.OverrideDate) AS OverrideDate
		FROM ClaimLineItems CLI
		INNER JOIN ClaimLineItemGroups CLIG ON CLIG.ClaimLineItemGroupId = CLI.ClaimLineItemGroupId
		LEFT JOIN Staff S ON S.Usercode = CLI.OverrideBy
		WHERE CLIG.ClaimLineItemGroupId = @ClaimLineItemGroupId
			AND ISNULL(CLIG.RecordDeleted, 'N') = 'N'
			AND ISNULL(CLI.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCGetClaimLineItemDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


