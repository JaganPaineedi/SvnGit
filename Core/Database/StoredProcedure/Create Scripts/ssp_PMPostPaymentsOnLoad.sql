IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'[ssp_PMPostPaymentsOnLoad]')
			AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1
		)
	DROP PROCEDURE [dbo].[ssp_PMPostPaymentsOnLoad]
GO

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[ssp_PMPostPaymentsOnLoad] @ParamPaymentId INT
	,@ParamFinancialActivityId INT
AS
BEGIN
	BEGIN TRY
		/****************************************************************************** 
** File: ssp_PMPostPaymentsOnLoad.sql
** Name: ssp_PMPostPaymentsOnLoad
** Desc: This SP returns the drop down values for posting Payments
** 
** This template can be customized: 
** 
** Return values: 
** 
** Called by: 
** 
** Parameters: 
** Input Output 
** ---------- ----------- 
** 
** Auth: Mary Suma
** Date: 10/05/2011
******************************************************************************* 
** Change History 
******************************************************************************* 
** Date: 			Author: 			Description: 
** 
-------- 			-------- 			--------------- 
-- 24 Aug 2011		Girish				Removed References to Rowidentifier and/or ExternalReferenceId
-- 27 Aug 2011		Girish				Readded References to Rowidentifier and ExternalReferenceId
-- 28 Sep 2011		MSuma				Included Corrections OnLoad on this Main Load
-- 20 Jan 2012      MSuma               Included additional Logic when @ParamPaymentId=0 (correction for an Adjustment)
-- 03.05.2012		PSelvan				For the Ace task #30 of Development Phase III (Offshore)
-- 16.07.2014		PSelvan				For task #135 Philhaven development added new column TypeOfPosting and CopayAllocated in payments table
-- 19 Oct 2015		Revathi				what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.        
--										why:task #609, Network180 Customization 
-- 24/03/2016       Bernardin		    what:Changed code to display Clients LastName and FirstName and removed null check for LastName and FirstName when ClientType=''I'' else  OrganizationName. Core Bugs Task# 2052             
-- 16 DEC 2016      Akwinass            Added RefundAdjustmentTo, RefundAdjustmentAddress, RefundSent, RefundsAdjustment to Refunds table and implemented case statement for Refund column (Task #391 in Philhaven Development)					
*******************************************************************************/
		--***************************************************************            
		--Table 01 Financial Activities            
		--***************************************************************            
		SELECT F.[FinancialActivityId]
			,F.[PayerId]
			,F.[CoveragePlanId]
			,F.[ClientId]
			,F.[ActivityType]
			,F.[RowIdentifier]
			,F.[CreatedBy]
			,F.[CreatedDate]
			,F.[ModifiedBy]
			,F.[ModifiedDate]
			,F.[RecordDeleted]
			,F.[DeletedDate]
			,F.[DeletedBy]
			,F.ClientId
			,case when  ISNULL(C.ClientType,'I')='I' then C.LastName + ', ' + C.FirstName else ISNULL(C.OrganizationName,'') end  as  ClientName
		FROM FinancialActivities F
		LEFT JOIN Clients C ON C.ClientId = F.ClientId
		WHERE FinancialActivityid = @ParamFinancialActivityId

		--***************************************************************  
		--Table 02 payments            
		--***************************************************************  
		SELECT P.PaymentId
			,P.FinancialActivityId
			,P.PayerId
			,P.CoveragePlanId
			,P.ClientId
			,case when  ISNULL(C.ClientType,'I')='I' then C.LastName + ', ' + C.FirstName else ISNULL(C.OrganizationName,'') end  as  ClientName
			--convert(varchar,P.DateReceived,101) as DateReceived, 
			,P.DateReceived
			,P.NameIfNotClient
			,P.ElectronicPayment
			,P.PaymentMethod
			,P.ReferenceNumber
			,P.CardNumber
			,P.ExpirationDate
			,P.Amount
			,P.LocationId
			,P.PaymentSource
			,P.UnpostedAmount
			,P.Comment
			,p.FundsNotReceived
			,p.TypeOfPosting
			,(
				SELECT SUM(pc.Copayment)
				FROM PaymentCopayments pc
				WHERE pc.PaymentId = @ParamPaymentId
					AND ISNULL(pc.RecordDeleted, 'N') = 'N'
				) AS CopayAllocated
			,P.RowIdentifier
			,P.CreatedBy
			,P.CreatedDate
			,P.ModifiedBy
			,P.ModifiedDate
			,P.RecordDeleted
			,P.DeletedDate
			,P.DeletedBy
		FROM Payments P
		LEFT JOIN Clients C ON C.ClientId = P.ClientId
		WHERE P.PaymentId = @ParamPaymentId
			AND P.FinancialActivityId = @ParamFinancialActivityId

		--*************************************************************            
		--Table 03 Refunds            
		--*************************************************************   
		SELECT RefundId AS RefundId
			,PaymentId AS PaymentId
			,CASE WHEN ISNULL(RefundsAdjustment,'') = 'A' THEN 'Adjustment' ELSE 'Refund' END Refund -- 16 DEC 2016      Akwinass
			,Amount AS Amount
			,CreatedBy AS [User]
			,CONVERT(VARCHAR, RefundDate, 101) AS NewDate
			,RefundDate
			,Comment AS Comment
			,[Correction]
			,[Amount]
			,[RefundDate]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedDate]
			,[DeletedBy]
			,RowIdentifier
			,Amount AS Amounts
			,RefundType
			,dbo.csf_GetGlobalCodeNameById(RefundType) AS RefundTypeText
			-- 16 DEC 2016      Akwinass
			,RefundAdjustmentTo
			,RefundAdjustmentAddress
			,RefundSent
			,RefundsAdjustment
		FROM Refunds
		WHERE (
				RecordDeleted = 'N'
				OR RecordDeleted IS NULL
				)
			AND PaymentId = @ParamPaymentId

		--Table 4 List Of Services
		--Table 5 ARLedger
		--EXEC [ssp_PMPostPaymentsAdjServiceTab] @ParamFinancialActivityId
		--***************************************************************            
		--Table 06 ARLedger            
		--***************************************************************            
		--SELECT 
		--	 ARL.ARLedgerId,ARL.ChargeId,ARL.FinancialActivityLineId,            
		--	 ARL.FinancialActivityVersion,ARL.LedgerType,ARL.Amount,ARL.PaymentId,            
		--	 ARL.AdjustmentCode,ARL.AccountingPeriodId,ARL.PostedDate,ARL.ClientId,            
		--	 ARL.CoveragePlanId,convert(varchar(10),ARL.DateOfService,101) as DateOfService,            
		--	 ARL.MarkedAsError,ARL.ErrorCorrection
		--     ,ARL.RowIdentifier
		--     ,ARL.CreatedBy,            
		--     ARL.CreatedDate,ARL.ModifiedBy,ARL.ModifiedDate,ARL.RecordDeleted,            
		--     ARL.DeletedDate,ARL.DeletedBy, GC.CodeName,            
		-- CASE            
		--  WHEN C.ClientCoveragePlanId is NOT NULL then            
		--   (CP.DisplayAs)            
		--  ELSE            
		--   (CL.LastName +', ' + CL.FirstName)            
		-- END  as TransferedTo, C.DoNotBill ,
		-- S.Status --Included for testng      Gayathiri's changes
		--FROM  arledger ARL            
		--	LEFT OUTER JOIN GlobalCodes GC ON ARL.AdjustmentCode=GC.GlobalCodeId            
		--	LEFT OUTER JOIN Charges C ON ARL.ChargeId=C.ChargeId            
		--	LEFT OUTER JOIN clientcoverageplans CCP ON C.ClientCoveragePlanId=CCP.ClientCoveragePlanId            
		--	LEFT OUTER JOIN CoveragePlans CP ON CCP.CoveragePlanId=CP.CoveragePlanId            
		--	LEFT OUTER JOIN Services S ON C.ServiceId=S.ServiceId            
		--	LEFT OUTER JOIN Clients CL ON S.ClientId=CL.ClientId   
		--WHERE 
		--	ARL.PaymentId=@ParamPaymentId         
		DECLARE @CountARLedger INT

		SELECT @CountARLedger = COUNT(*)
		FROM ARLEdger
		WHERE PaymentId = @ParamPaymentId
			AND ISNULL(RecordDeleted, 'N') = 'N'

		IF (@CountARLedger > 0)
			SELECT '1' AS Ledger
		ELSE
			SELECT '0' AS Ledger

		----***************************************************************            
		----Table 7 OpenCharges            
		----***************************************************************            
		--SET FMTONLY ON             
		--SELECT 
		--	ChargeId,
		--	Balance,
		--	RowIdentifier,
		--	CreatedBy,
		--	CreatedDate,
		--	ModifiedBy,
		--	ModifiedDate,
		--	RecordDeleted,
		--	DeletedDate,
		--	DeletedBy             
		--FROM OpenCharges            
		--SET FMTONLY OFF        
		----***************************************************************            
		----Table 8 Clients            
		----*************************************************************** 
		--SELECT *            
		--FROM Clients            
		--WHERE             
		-- (RecordDeleted ='N' or RecordDeleted is null)            
		--and Clients.ClientId in(select ClientId from FinancialActivities where 
		--Financialactivityid=@ParamFinancialActivityId)  
		--***************************************************************            
		--Table 9 Payer Type
		--*************************************************************** 
		DECLARE @Payer INT
		DECLARE @PayerType VARCHAR(15)
		DECLARE @PayerName VARCHAR(150)

		IF (@ParamPaymentId <> 0)
		BEGIN
			SELECT @Payer = CASE 
					WHEN (
							PAyerID IS NULL
							AND CoveragePlanId IS NULL
							)
						THEN ClientID
					WHEN (
							PAyerID IS NULL
							AND CLientID IS NULL
							)
						THEN CoveragePlanId
					WHEN (
							CoveragePlanId IS NULL
							AND ClientId IS NULL
							)
						THEN PayerId
					END
			FROM Payments P
			WHERE PaymentId = @ParamPaymentId

			SELECT @PayerType = CASE 
					WHEN (
							PAyerID IS NULL
							AND CoveragePlanId IS NULL
							)
						THEN 'Client'
					WHEN (
							PAyerID IS NULL
							AND CLientID IS NULL
							)
						THEN 'CoveragePlan'
					WHEN (
							CoveragePlanId IS NULL
							AND ClientId IS NULL
							)
						THEN 'Payer'
					END
			FROM Payments P
			WHERE PaymentId = @ParamPaymentId

			SELECT @PayerName = CASE 
					WHEN (
							P.PAyerID IS NULL
							AND P.CoveragePlanId IS NULL
							)
						THEN CASE --Added by Revathi 19 Oct 2015
								WHEN ISNULL(C.ClientType, 'I') = 'I'
									THEN ISNULL(C.LastName,'') + ', ' +ISNULL(C.FirstName,'')
								ELSE ISNULL(C.OrganizationName,'')
								END
					WHEN (
							P.PAyerID IS NULL
							AND P.CLientID IS NULL
							)
						THEN CP.DisplayAs
					WHEN (
							P.CoveragePlanId IS NULL
							AND P.ClientId IS NULL
							)
						THEN PA.PayerName
					END
			FROM Payments P
			LEFT JOIN CoveragePlans CP ON P.CoveragePlanId = CP.CoveragePlanId
			LEFT JOIN Clients C ON C.ClientId = P.ClientId
			LEFT JOIN Payers PA ON P.PayerId = PA.PayerId
			WHERE PaymentId = @ParamPaymentId
		END

		IF (@ParamPaymentId = 0)
		BEGIN
			SELECT @Payer = CASE 
					WHEN (
							PAyerID IS NULL
							AND CoveragePlanId IS NULL
							)
						THEN ClientID
					WHEN (
							PAyerID IS NULL
							AND CLientID IS NULL
							)
						THEN CoveragePlanId
					WHEN (
							CoveragePlanId IS NULL
							AND ClientId IS NULL
							)
						THEN PayerId
					END
			FROM FinancialActivities P
			WHERE FinancialActivityId = @ParamFinancialActivityId

			SELECT @PayerType = CASE 
					WHEN (
							PAyerID IS NULL
							AND CoveragePlanId IS NULL
							)
						THEN 'Client'
					WHEN (
							PAyerID IS NULL
							AND CLientID IS NULL
							)
						THEN 'CoveragePlan'
					WHEN (
							CoveragePlanId IS NULL
							AND ClientId IS NULL
							)
						THEN 'Payer'
					END
			FROM FinancialActivities P
			WHERE FinancialActivityId = @ParamFinancialActivityId

			SELECT @PayerName = CASE 
					WHEN (
							P.PAyerID IS NULL
							AND P.CoveragePlanId IS NULL
							)
						THEN CASE 
								WHEN ISNULL(C.ClientType, 'I') = 'I'
									THEN C.LastName + ', ' + C.FirstName
								ELSE C.OrganizationName
								END
					WHEN (
							P.PAyerID IS NULL
							AND P.CLientID IS NULL
							)
						THEN CP.DisplayAs
					WHEN (
							P.CoveragePlanId IS NULL
							AND P.ClientId IS NULL
							)
						THEN PA.PayerName
					END
			FROM FinancialActivities P
			LEFT JOIN CoveragePlans CP ON P.CoveragePlanId = CP.CoveragePlanId
			LEFT JOIN Clients C ON C.ClientId = P.ClientId
			LEFT JOIN Payers PA ON P.PayerId = PA.PayerId
			WHERE FinancialActivityId = @ParamFinancialActivityId
		END

		SELECT @Payer AS PayerId
			,@PayerType AS PayerType
			,@PayerName AS PayerName
			--Tables for Corrections
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
		+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' 
		+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMPostPaymentsOnLoad') 
		+ '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
		+ '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
		+ '*****' + CONVERT(VARCHAR, ERROR_STATE())

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
GO

