/****** Object:  StoredProcedure [dbo].[ssp_PM835PostBatch]    Script Date: 11/17/2018 6:11:41 PM ******/
DROP PROCEDURE [dbo].[ssp_PM835PostBatch]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PM835PostBatch]    Script Date: 11/17/2018 6:11:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

   
    
	CREATE PROCEDURE [dbo].[ssp_PM835PostBatch]
		@ERBatchId INT ,
		@PaymentId INT
	AS /*********************************************************************/      
/* Stored Procedure: ssp_835_post_batch                   */      
/* Creation Date:    8/07/01                                         */      
/*                                                                   */      
/* Purpose:                 */      
/*                                                                   */ /* Input Parameters:           */      
/*                                                                   */      
/* Output Parameters:                                                */      
/*                                                                   */      
/* Return Status:                                                    */      
/*                                                                   */      
/* Called By:        SQL Server task scheduler        */      
/*                                                                   */      
/* Calls:                                                            */      
/*                                                                   */      
/* Data Modifications:                                               */      
/*                                                                   */      
/* Updates:                                                          */      
/*   Date  Author      Purpose                                    */      
/*  8/07/01  JHB   Created                                    */      
/*  1/16/04  JHB   Modified to post refunds from current Payment */      
/*  8/15/06  TER   Added Adjustment posting logic.   */      
/*  03/28/12 MSuma  Fixed to correct incorrect FinancialActivityLines in Ledgers */      
/*  04/04/12 MSuma  Modified Custom table to core  */      
/*  04/09/12 MSuma  Modified ERErrorType */      
/*  08/15/12 Msuma Notnull check to avoid Invalid claimsLine item that does not exist in our system*/   
/*  02/22/17 Dknewtson Starting over with valley customizations as base.
					   if scsp_PM835PostBatch Exists execute that and return (Always)
					   implementing Cross overs when posting payments by payer.
					   implementing ERProcessingTemplateId in Coverage Plans.
					   Moved "Back out adjustments" code to run for all charges rather than just charges with adjustments per 835 configuration. (CEI Bug Fix)
					   ensured #LineItemOriginalCharge is populated by ERClaimLineItem rather than by ClaimLineItem and joins to this table in regards to back out adjustments opporate accordingly (CEI Bug Fix)*/   
/*  03/01/17 jcarlson  added in several new custom hooks, updated system configuration key names, changed #ImportStaging table to new core table - Core 835 Changes*/
/*	03/14/17 NJain	   added ClaimLineItemGroupId to process payments for entire claims*/
/*  04/05/17 NJain	   added Priority and Serivce in the group by criteria when inserting into #LineItemChargeAmount*/
/*					   corrected ambiguous COLUMN names	
					   changed CCP.ERProcessingTemplateId to CP.ERProcessingTemplateId
					   changed remaining #ImportStaging references to ERClaimLineItemImportStaging
	01/22/18 Dknewtson Filtering for @ERBatch on import staging when automatically posting from ERProcessing. 
					   Correcting an issue with the AllowERAutoPostLedgerTransactions check to prevent this from not being defaulted properly when the key doesn't exist.
	07/16/2018 Dknewtson Updated backout adjustments logic to handle claim line items being remitted with multiple charges. Spring River - Support Go live task #265
	08/16/2018 Dknewtson Included system configuration key to adjust automatic transfers when the client is the next billable payer. Also fixed an issue which prevented adjustments from posting to secondaries. Valley - Support Go Live 1435
	09/11/2018 Dknewtson Performance improvements for Valley - they have a LOT of billing history causing claim line lookups to take a while Valley - Support Go Live 1435
	09/21/2018 Dknewtson Updating processing action 4 error to check the processing action on the line item adjustment table instead of going through the ERProcessingTemplateRules - Harbor - Support Go live #1012
	11/07/2018 Dknewtson If the ClaimLineItemId is available to join to ClaimLineItems - use this instead of the ClaimLineItemGroupId. Journey - support go live 351
	11/07/2018 Dknewtson excluding ERFile created records from the backout adjustment process Journey - support go live 351
	11/07/2018 Dknewtson Fixing rounding errors on adjustments and payments when the amounts are off by .005 exactly. Journey - support go live 351
	11/07/2018 Dknewtson Removed code that did something with the paid amount and adjustment amount based on units. Journey - support go live 351
	11/08/2018 Dknewtson Fixing rounding in a different way from Slavik - Journey - Support Go live 351
	11/08/2018 Dknewtson Moved code to exclude adjustments from errored services to a Delete statement to accomodate part of a claim being errored - Journey Support Go Live 351
	11/12/2018 Dknewtson Adding if object_id('tempdb..') checks to drop temp tables to aid with debugging. Journey Support Go Live 351
	11/12/2018 Dknewtson Removed transfer reversing code. Not sure if this was ever decided to be usable. Journey - Support Go Live 351
	11/16/2018 Dknewtson Using #LineItemChargeAmount to limit operations to only ERClaimLineItems we are currently processing (for better recovery if we want to reprocess just part of a file.) - Journey Support Go Live 351
	12/17/2018 Dknewtson Adding System Configuration Key to toggle backing out adjustments.
*/
/*********************************************************************/      
      
	--  PRINT @ERBatchId
	--  PRINT @PaymentId
	--  PRINT '->'

		IF OBJECT_ID('scsp_PM835PostBatch') IS NOT NULL
			BEGIN
				EXEC dbo.scsp_PM835PostBatch @ERBatchId, @PaymentId;
				RETURN;
			END;
    
      
--     BEHAVIOR VARIABLES
-------------------------------------------------

		DECLARE	@ApplyAdjustments CHAR(1);      
		DECLARE	@ApplyTransfers CHAR(1);    
		DECLARE	@BackOutAdjustments CHAR(1);
		DECLARE	@DoNotAllowAdjustmentsWithoutAPaymentOnTheSameClaimLine CHAR(1) = 'N';
  
-------------------------------------------------

      
		DECLARE	@ClaimLineItemId INT;   
		DECLARE	@ClaimedAmount DECIMAL(10, 2); -- for checking for denials   
		DECLARE	@PayerClaimNumber VARCHAR(30);      
		DECLARE	@CoveragePlanId CHAR(10);    
		DECLARE	@ChargeId CHAR(10);        
		DECLARE	@ClientId CHAR(10);      
		DECLARE	@PaidAmount DECIMAL(10, 2);      
		DECLARE	@BalanceAmount DECIMAL(10, 2);
		DECLARE	@TransferAmount DECIMAL(10, 2);      
		DECLARE	@AdjustmentAmount DECIMAL(10, 2);      
		DECLARE	@CheckNo VARCHAR(30);    
		DECLARE	@FinancialActivityId INT;           
		DECLARE	@DateOfService DATETIME;      
		DECLARE	@UserCode VARCHAR(MAX); 
		DECLARE	@ServiceId INT;      
		DECLARE	@ClientCoveragePlanId INT;      
		DECLARE	@TransferTo INT;      
		DECLARE	@CurrentAccountingPeriodId INT;      
		DECLARE	@PaymentAccountingPeriodId INT;      
		DECLARE	@OpenPeriod CHAR(1);    
		DECLARE	@ARLedgerId CHAR(10);      
		DECLARE	@FinancialActivityLineId INT;      
		DECLARE	@ErrorNo INT;      
		DECLARE	@ProcedureCodeId INT;      
		DECLARE	@ErrorMessage VARCHAR(250);      
		DECLARE	@ClinicianId INT;      
		DECLARE	@AdjustmentGlobalCodeId INTEGER;  
		DECLARE	@TransferChargeToNextPayer CHAR(1);
		DECLARE	@AdjustCharge CHAR(1);
		DECLARE	@AdjustmentCode CHAR(10);
		DECLARE	@TransactionOpen CHAR(1) = 'N';
		DECLARE	@SaveClaimLineItemId INT;      
		DECLARE	@DateReceived DATE;    
		DECLARE	@CurrentDate DATETIME; 
		DECLARE	@AssignToClient CHAR(1);
		DECLARE	@ProcessingAction INTEGER;
		DECLARE	@IsNotPrimary BIT;
		DECLARE	@Flagged CHAR(1); 
       
		DECLARE	@ReverseFakeChargeAdjustAmount MONEY ,
			@NextChargeId INT ,
			@NextCoveragePlanId INT;
             
		DECLARE	@AutomaticTransferForSecondary CHAR(1);
		DECLARE	@AutomaticTransferForSecondaryAdjustmentCode INT;
		DECLARE	@AutomaticTransferForSecondaryAdjustWhenClientIsNextPayer CHAR(1);
		SELECT	@AutomaticTransferForSecondary = RIGHT(dbo.ssf_GetSystemConfigurationKeyValue('AllowERAutomaticTransferForSecondary'), 1);

		SELECT	@AutomaticTransferForSecondaryAdjustmentCode = dbo.ssf_GetSystemConfigurationKeyValue('SetERAutomaticTransferForSecondaryAdjustmentCode')
		WHERE	ISNUMERIC(dbo.ssf_GetSystemConfigurationKeyValue('SetERAutomaticTransferForSecondaryAdjustmentCode')) = 1;

		SELECT	@AutomaticTransferForSecondaryAdjustWhenClientIsNextPayer = RIGHT(dbo.ssf_GetSystemConfigurationKeyValue('SetERAutomaticTransferForSecondaryAdjustWhenClientIsNextPayer'),
																					1);
	   
		IF @AutomaticTransferForSecondary = 'Y'
			AND @AutomaticTransferForSecondaryAdjustmentCode IS NULL
			RAISERROR('Automatic Transfer for Secondary requires AutomaticTransferForSecondaryAdjustmentCode to be set.',16,1); 
 
		DECLARE	@VerboseMode CHAR(1) = 'N';
		DECLARE	@FalseChargeAdjustmentCode INT;

		SELECT	@VerboseMode = RIGHT(dbo.ssf_GetSystemConfigurationKeyValue('ELECTRONICREMITTANCEVERBOSEMODE'), 1);

		SELECT	@FalseChargeAdjustmentCode = dbo.ssf_GetSystemConfigurationKeyValue('FALSECHARGEADJUSTMENTCODE')
		WHERE	ISNUMERIC(dbo.ssf_GetSystemConfigurationKeyValue('FALSECHARGEADJUSTMENTCODE')) = 1;
	   
		IF @VerboseMode = 'Y'
			AND @FalseChargeAdjustmentCode IS NULL
			RAISERROR('Verbose Mode requires a FALSECHARGEADJUSTMENTCODE to be set.',16,1); 

		DECLARE	@PayerId INT;

		SELECT	@PayerId = ebp.PayerId
		FROM	dbo.ERFiles ef
				JOIN dbo.ERBatches eb ON ef.ERFileId = eb.ERFileId
				JOIN dbo.ERBatchPayments ebp ON eb.ERBatchId = ebp.ERBatchId
		WHERE	eb.ERBatchId = @ERBatchId
				AND ebp.PaymentId = @PaymentId;


		SET @UserCode = 'ERFILE';    
		SET @CurrentDate = GETDATE();
      
	   --TODO Fix Backout Adjustments logic later. (probably when we find a use case for it.)
	   -- Some customers might actually find this useful because they will never receive an electronic reversal.
	   -- but they may receive more than one EOB.  In those cases we will need to take preferences from the customer.
	   -- There's 4 options:
			-- Backout just adjustments and transfers and apply new EOB
			-- Backout payments, Adjustments and Transfers and apply new EOB
			-- Skip the ERClaim and mark as error "EOB already posted for this charge"
			-- Post the Duplicate EOB and hope there's a reversal EOB for the first one.
		-- In general only 1 EOB should be posted to a charge. Otherwise the 837 will be incorrect for other insured. (Will not balance)
		SET @BackOutAdjustments = 'Y' -- default behavior when the systemconfig key doesn't exist.
		SELECT	@BackOutAdjustments = LEFT(ISNULL(NULLIF(RTRIM(LTRIM(Value)),''),'Y'), 1)
		FROM	dbo.SystemConfigurationKeys sck
		WHERE	[key] = 'BackOutExistingAdjustmentsWhenPosting835'
			AND ISNULL(sck.RecordDeleted,'N') <> 'Y'

		SET @ApplyAdjustments = ISNULL(( SELECT	a.ApplyAdjustments
											FROM
												dbo.ERFiles a
												JOIN dbo.ERBatches b ON a.ERFileId = b.ERFileId
											WHERE
												b.ERBatchId = @ERBatchId
												AND ISNULL(a.RecordDeleted, 'N') = 'N'
												AND ISNULL(b.RecordDeleted, 'N') = 'N'
										), 'N');      
              
		SET @ApplyTransfers = ISNULL(( SELECT	a.ApplyTransfers
										FROM	dbo.ERFiles a
												JOIN dbo.ERBatches b ON a.ERFileId = b.ERFileId
										WHERE	b.ERBatchId = @ERBatchId
												AND ISNULL(a.RecordDeleted, 'N') = 'N'
												AND ISNULL(b.RecordDeleted, 'N') = 'N'
										), 'N');      

		DECLARE	@DefaultCopaymentAdjustmentCode INT; 

		SELECT	@DefaultCopaymentAdjustmentCode = gc.GlobalCodeId
		FROM	dbo.GlobalCodes gc
		WHERE	gc.Category = 'ADJUSTMENTCODE'
				AND gc.ExternalCode1 = '3'
				AND gc.ExternalCode2 = 'PR'
				AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'
				AND gc.Active = 'Y';

		SELECT	@DefaultCopaymentAdjustmentCode = gc.GlobalCodeId
		FROM	dbo.GlobalCodes gc
		WHERE	gc.Category = 'ADJUSTMENTCODE'
				AND gc.ExternalCode1 = '3'
				AND gc.ExternalCode2 = 'PR'
				AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'
				AND @DefaultCopaymentAdjustmentCode IS NULL;

		DECLARE	@835Source INT;

		SELECT	@835Source = gc.GlobalCodeId
		FROM	dbo.GlobalCodes AS gc
		WHERE	gc.Category = 'EXTERNALSOURCE'
				AND gc.CodeName = '835';


		IF OBJECT_ID('tempdb..#LineItemBalance') IS NOT NULL
			DROP TABLE #LineItemBalance;
-- For the amount owed at the ClaimLine Level, Sum(Charges) group by Claimline
		CREATE TABLE #LineItemBalance
			(
				ERClaimLineItemId INT ,
				ClaimLineItemId INT NOT NULL ,
				BalanceAmount DECIMAL(10, 2) NULL
			);      
		
		IF OBJECT_ID('tempdb..#LineItemOriginalCharge') IS NOT NULL
			DROP TABLE #LineItemOriginalCharge;
-- For the amount owed at the ClaimLine Level, Sum(Charges) group by Claimline
		CREATE TABLE #LineItemOriginalCharge
			(
				ERClaimLineItemId INT ,
				ClaimLineItemId INT NOT NULL ,
				RevenueAmount DECIMAL(10, 2) NULL
			);      

		
		IF OBJECT_ID('tempdb..#LineItemPaid') IS NOT NULL
			DROP TABLE #LineItemPaid;
-- PaidAmount = The amount of the check being payed to this claimline
		CREATE TABLE #LineItemPaid
			(
				ERClaimLineItemId INT ,
				ClaimLineItemId INT NOT NULL ,
				PaidAmount DECIMAL(10, 2) NOT NULL ,
				ClaimLineItemGroupId INT NULL
			);      
        
		
		IF OBJECT_ID('tempdb..#LineItemAdjustment') IS NOT NULL
			DROP TABLE #LineItemAdjustment;
-- Adjustment Codes are universal      
		CREATE TABLE #LineItemAdjustment
			(
				ERClaimLineItemId INT ,
				ClaimLineItemId INT NOT NULL ,
				AdjustmentAmount DECIMAL(10, 2) NOT NULL ,
				AdjustmentGroupCode VARCHAR(25) ,
				AdjustmentReasonCode VARCHAR(25) ,
				AdjustmentGlobalcode INTEGER ,
				ProcessingAction INT ,
				ClaimLineItemGroupId INT NULL
			);      
        
       
		IF OBJECT_ID('tempdb..#LineItemChargeAmount') IS NOT NULL
			DROP TABLE #LineItemChargeAmount;
		CREATE TABLE #LineItemChargeAmount
			(
				ERClaimLineItemId INT ,
				ClaimLineItemId INT NOT NULL ,
				ClaimLineItemGroupId INT NULL ,
				PayerClaimNumber VARCHAR(30) NULL ,
				ChargeId CHAR(10) NOT NULL ,
				BalanceAmount DECIMAL(10, 2) NOT NULL ,
				Payment DECIMAL(10, 2) NULL ,
				Transfer DECIMAL(10, 2) NULL ,
				Adjustment DECIMAL(10, 2) NULL ,
				PaymentId INT NULL ,
				StandardChargeId CHAR(10) NULL ,
				OriginalPaymentId INT NULL ,
				AdjustmentGlobalCode CHAR(10) NULL ,
				ClaimsOnThisLine INTEGER NULL ,
				EOBCharge DECIMAL(10, 2) NULL ,
				NextBillablePayer INT NULL ,
				BackOutAdjustments CHAR(1) NULL -- y/n
				,
				IsNotPrimary BIT NULL
			);   
              
		IF OBJECT_ID('tempdb..#ReverseTransfers') IS NOT NULL
			DROP TABLE #ReverseTransfers;
		CREATE TABLE #ReverseTransfers
			(
				rtid INT IDENTITY -- going to use this to remove duplicates.
				,
				ERClaimLineItemId INT ,
				ClaimLineItemId INT ,
				EOBChargeId INT ,
				ChargeId INT ,
				Amount DECIMAL(10, 2) ,
				ReverseAdjustmentCode INT
			);


		-- Calculate the paid amount on each ER Claim
		INSERT	INTO #LineItemPaid
				(	ERClaimLineItemId ,
					ClaimLineItemId ,
					PaidAmount ,
					ClaimLineItemGroupId
            
				)
		SELECT	ECL.ERClaimLineItemId ,
				ECL.ClaimLineItemId ,
				ISNULL(SUM(ECL.PaidAmount), 0.0) ,
				ECL.ClaimLineItemGroupId
		FROM	dbo.ERClaimLineItems ECL
				JOIN dbo.ERBatchPayments ERBP ON ( ECL.ERBatchPaymentId = ERBP.ERBatchPaymentId )
				JOIN dbo.ClaimLineItems CLI ON CLI.ClaimLineItemGroupId = ECL.ClaimLineItemGroupId
		WHERE	ECL.ERBatchId = @ERBatchId
				AND ERBP.PaymentId = @PaymentId
				AND ECL.ClaimLineItemId IS NULL
				AND ISNULL(ECL.Processed, 'N') = 'N'
				AND ISNULL(ECL.RecordDeleted, 'N') = 'N'
				AND ISNULL(ERBP.RecordDeleted, 'N') = 'N'
				AND ECL.ClaimLineItemGroupId IS NOT NULL
		GROUP BY ECL.ClaimLineItemId ,
				ECL.ERClaimLineItemId ,
				ECL.ClaimLineItemGroupId;

-- insert stuff not in the last query.
		INSERT	INTO #LineItemPaid
				(	ERClaimLineItemId ,
					ClaimLineItemId ,
					PaidAmount ,
					ClaimLineItemGroupId            
				)
		SELECT	ECL.ERClaimLineItemId ,
				ECL.ClaimLineItemId ,
				ISNULL(SUM(ECL.PaidAmount), 0.0) ,
				ECL.ClaimLineItemGroupId
		FROM	dbo.ERClaimLineItems ECL
				JOIN dbo.ERBatchPayments ERBP ON ( ECL.ERBatchPaymentId = ERBP.ERBatchPaymentId )
				JOIN dbo.ClaimLineItems CLI ON CLI.ClaimLineItemId = ECL.ClaimLineItemId
		WHERE	ECL.ERBatchId = @ERBatchId
				AND ERBP.PaymentId = @PaymentId
				AND ECL.ClaimLineItemId IS NOT NULL
				AND ISNULL(ECL.Processed, 'N') = 'N'
				AND ISNULL(ECL.RecordDeleted, 'N') = 'N'
				AND ISNULL(ERBP.RecordDeleted, 'N') = 'N'
		GROUP BY ECL.ClaimLineItemId ,
				ECL.ERClaimLineItemId ,
				ECL.ClaimLineItemGroupId;

    --Gather the adjustments at the ER Claim level
		INSERT	INTO #LineItemAdjustment
				(	ERClaimLineItemId ,
					ClaimLineItemId ,
					AdjustmentAmount ,
					AdjustmentGroupCode ,
					AdjustmentReasonCode ,
					ClaimLineItemGroupId
            
				)
		SELECT	ECLI.ERClaimLineItemId ,
				ECLI.ClaimLineItemId ,
				SUM(ISNULL(ECLIA.AdjustmentAmount, 0)) ,
				ECLIA.AdjustmentGroupCode ,
				ECLIA.AdjustmentReason ,
				ECLI.ClaimLineItemGroupId
		FROM	dbo.ERClaimLineItemAdjustments ECLIA
				JOIN dbo.ERClaimLineItems ECLI ON ECLIA.ERClaimLineItemId = ECLI.ERClaimLineItemId
				JOIN dbo.ERBatchPayments ERBP ON ( ECLI.ERBatchPaymentId = ERBP.ERBatchPaymentId )
												AND ERBP.ERBatchId = @ERBatchId
				JOIN dbo.ClaimLineItems CLI ON ECLI.ClaimLineItemGroupId = CLI.ClaimLineItemGroupId
		WHERE	ERBP.PaymentId = @PaymentId
				AND ECLI.ClaimLineItemId IS NULL
				AND ISNULL(ECLI.Processed, 'N') = 'N'
				AND ISNULL(ECLI.RecordDeleted, 'N') = 'N'
				AND ISNULL(ECLIA.RecordDeleted, 'N') = 'N'
				AND ISNULL(ERBP.RecordDeleted, 'N') = 'N'
				AND ECLI.ClaimLineItemGroupId IS NOT NULL
		GROUP BY ECLI.ClaimLineItemId ,
				ECLIA.AdjustmentGroupCode ,
				ECLIA.AdjustmentReason ,
				ECLI.ERClaimLineItemId ,
				ECLI.ClaimLineItemGroupId; 
				
		INSERT	INTO #LineItemAdjustment
				(	ERClaimLineItemId ,
					ClaimLineItemId ,
					AdjustmentAmount ,
					AdjustmentGroupCode ,
					AdjustmentReasonCode ,
					ClaimLineItemGroupId
            
				)
		SELECT	ECLI.ERClaimLineItemId ,
				ECLI.ClaimLineItemId ,
				SUM(ISNULL(ECLIA.AdjustmentAmount, 0)) ,
				ECLIA.AdjustmentGroupCode ,
				ECLIA.AdjustmentReason ,
				ECLI.ClaimLineItemGroupId
		FROM	dbo.ERClaimLineItemAdjustments ECLIA
				JOIN dbo.ERClaimLineItems ECLI ON ECLIA.ERClaimLineItemId = ECLI.ERClaimLineItemId
				JOIN dbo.ERBatchPayments ERBP ON ( ECLI.ERBatchPaymentId = ERBP.ERBatchPaymentId )
												AND ERBP.ERBatchId = @ERBatchId
				JOIN dbo.ClaimLineItems CLI ON ECLI.ClaimLineItemId = CLI.ClaimLineItemId
		WHERE	ERBP.PaymentId = @PaymentId
				AND ECLI.ClaimLineItemId IS NOT NULL
				AND ISNULL(ECLI.Processed, 'N') = 'N'
				AND ISNULL(ECLI.RecordDeleted, 'N') = 'N'
				AND ISNULL(ECLIA.RecordDeleted, 'N') = 'N'
				AND ISNULL(ERBP.RecordDeleted, 'N') = 'N'
		GROUP BY ECLI.ClaimLineItemId ,
				ECLIA.AdjustmentGroupCode ,
				ECLIA.AdjustmentReason ,
				ECLI.ERClaimLineItemId ,
				ECLI.ClaimLineItemGroupId; 
          				
			
-- Map AdjusmtentGroupCode and AdjustmentReasonCode to GlobalCode

		UPDATE	LIA
		SET		LIA.AdjustmentGlobalcode = GC.GlobalCodeId
		FROM	#LineItemAdjustment LIA
				JOIN dbo.GlobalCodes GC ON GC.ExternalCode2 = LIA.AdjustmentGroupCode
										AND GC.ExternalCode1 = LIA.AdjustmentReasonCode
										AND GC.Category LIKE 'ADJUSTMENTCODE'
										AND GC.ExternalSource1 = @835Source
		WHERE	ISNULL(GC.RecordDeleted, 'N') = 'N';
                                  
-- if PayerId is null we are not posting payment by payer therefore we need to use the old logic for this.
		IF @PayerId IS NULL
			BEGIN
				INSERT	INTO #LineItemChargeAmount
						(	ERClaimLineItemId ,
							ClaimLineItemId ,
							ClaimLineItemGroupId ,
							PayerClaimNumber ,
							ChargeId ,
							PaymentId ,
							BalanceAmount ,
							EOBCharge ,
							BackOutAdjustments ,
							IsNotPrimary
						)
				SELECT	a.ERClaimLineItemId ,
						a.ClaimLineItemId ,
						a.ClaimLineItemGroupId ,
						a.PayerClaimNumber ,
						c.ChargeId ,
						erbp.PaymentId ,
						SUM(c.Amount) ,
						a.ChargeAmount ,
						'N' ,
						CASE	WHEN NOT EXISTS ( SELECT	1
													FROM	dbo.Charges lowerp
													WHERE	lowerp.ServiceId = d.ServiceId
															AND ISNULL(lowerp.RecordDeleted, 'N') <> 'Y'
															AND lowerp.Priority < d.[Priority]
															AND lowerp.Priority <> 0 ) THEN 0
								ELSE 1
						END
				FROM	dbo.ERClaimLineItems a
						JOIN dbo.ERBatchPayments erbp ON ( a.ERBatchPaymentId = erbp.ERBatchPaymentId )
						JOIN dbo.ClaimLineItemCharges b ON ( a.ClaimLineItemId = b.ClaimLineItemId )
						JOIN dbo.ARLedger c ON ( c.ChargeId = b.ChargeId )
						JOIN dbo.Charges d ON ( b.ChargeId = d.ChargeId )
						JOIN dbo.Services e ON ( d.ServiceId = e.ServiceId )
				WHERE	e.Status <> 76
						AND a.ERBatchId = @ERBatchId
						AND erbp.PaymentId = @PaymentId    
--Added by MSuma to avoid Invalid claimsLine item that does not exist in our system
						AND a.ClaimLineItemId IS NOT NULL
						AND ISNULL(a.Processed, 'N') = 'N'
						AND NOT EXISTS ( SELECT	*
											FROM
												dbo.ERClaimLineItems z
												JOIN dbo.ERBatchPayments erbp2 ON ( a.ERBatchPaymentId = erbp2.ERBatchPaymentId )
											WHERE
												a.ClaimLineItemId = z.ClaimLineItemId
												AND erbp2.PaymentId = @PaymentId
												AND a.ERBatchId = z.ERBatchId
												AND z.ERClaimLineItemId < a.ERClaimLineItemId )
				GROUP BY a.ERClaimLineItemId ,
						a.ClaimLineItemId ,
						a.ClaimLineItemGroupId ,
						a.PayerClaimNumber ,
						c.ChargeId ,
						d.Priority ,
						d.ServiceId ,
						erbp.PaymentId ,
						a.ChargeAmount; 
			END;
		ELSE
			BEGIN
-- Calculate the Client Coverage Plan (Charge) the 835 transaction needs to be posted against.
-- Also gather that Client Coverage Plan's current balance for use later.   
				INSERT	INTO #LineItemChargeAmount
						(	ERClaimLineItemId ,
							ClaimLineItemId ,
							ClaimLineItemGroupId ,
							PayerClaimNumber ,
							ChargeId ,
							PaymentId ,
							BalanceAmount ,
							EOBCharge ,
							BackOutAdjustments ,
							IsNotPrimary
						)
				SELECT	ECLI.ERClaimLineItemId ,
						ECLI.ClaimLineItemId ,
						ECLI.ClaimLineItemGroupId ,
						ECLI.PayerClaimNumber ,
						AL.ChargeId ,
						erbp.PaymentId ,
						SUM(AL.Amount) ,
						ECLI.ChargeAmount ,
						'N' ,
						CASE	WHEN NOT EXISTS ( SELECT	1
													FROM	dbo.Charges lowerp
													WHERE	lowerp.ServiceId = cnext.ServiceId
															AND ISNULL(lowerp.RecordDeleted, 'N') <> 'Y'
															AND lowerp.Priority < cnext.[Priority]
															AND lowerp.Priority <> 0 ) THEN 0
								ELSE 1
						END -- IsNotPrimary 
				FROM	dbo.ERClaimLineItems ECLI
						JOIN dbo.ERBatchPayments erbp ON ( ECLI.ERBatchPaymentId = erbp.ERBatchPaymentId )
						JOIN dbo.ClaimLineItemCharges CLIC ON ( ECLI.ClaimLineItemId = CLIC.ClaimLineItemId )
						JOIN dbo.Charges Ch ON ( CLIC.ChargeId = Ch.ChargeId )
                -- we need to pull the next priority charge if the payment is cross over.
                -- so looking at all of the existing charges for the service 
                -- (If no charge exists we're going to error)
						JOIN dbo.Charges cnext ON cnext.ServiceId = Ch.ServiceId
													AND cnext.Priority >= Ch.Priority
													AND ISNULL(cnext.RecordDeleted, 'N') <> 'Y'
						JOIN dbo.ARLedger AL ON ( AL.ChargeId = cnext.ChargeId )
						JOIN dbo.ClientCoveragePlans ccp ON cnext.ClientCoveragePlanId = ccp.ClientCoveragePlanId
								--and ISNULL(ccp.RecordDeleted,'N') <> 'Y'
						JOIN dbo.CoveragePlans cp ON ccp.CoveragePlanId = cp.CoveragePlanId
														AND cp.PayerId = @PayerId
				WHERE	ECLI.ERBatchId = @ERBatchId
						AND erbp.PaymentId = @PaymentId
						AND ECLI.ClaimLineItemId IS NOT NULL
						AND ISNULL(ECLI.Processed, 'N') = 'N'
						AND ISNULL(ECLI.RecordDeleted, 'N') = 'N'
						AND ISNULL(erbp.RecordDeleted, 'N') = 'N'
						AND ISNULL(AL.RecordDeleted, 'N') = 'N'
						AND ISNULL(Ch.RecordDeleted, 'N') = 'N'
						AND ISNULL(CLIC.RecordDeleted, 'N') = 'N'
                -- and there isn't a higher priority charge that meets the conditions
						AND NOT EXISTS ( SELECT	1
											FROM
												dbo.Charges cnext2 -- this also removes client charges from consideration
												JOIN dbo.ClientCoveragePlans ccpnext2 ON cnext2.ClientCoveragePlanId = ccpnext2.ClientCoveragePlanId
                                                       --AND ISNULL(ccpnext2.RecordDeleted, 'N') <> 'Y'
												JOIN dbo.CoveragePlans cpnext2 ON ccpnext2.CoveragePlanId = cpnext2.CoveragePlanId
                                                       --AND ISNULL(cpnext2.RecordDeleted, 'N') <> 'Y'
																					AND cpnext2.PayerId = @PayerId
											WHERE
												ISNULL(cnext2.RecordDeleted, 'N') <> 'Y'
												AND cnext2.ServiceId = Ch.ServiceId
												-- priority is lower or equal to billed charge
												AND cnext2.Priority >= Ch.Priority
												-- priority is higher than what we're looking at right now.
												AND ( cnext2.Priority < cnext.Priority
													  -- or the priority is the same and chargeid is lower. (Shouldn't happen?)
														OR ( cnext2.Priority = cnext.Priority
																AND cnext.ChargeId > cnext2.ChargeId
															)
													) )
				GROUP BY ECLI.ClaimLineItemId ,
						ECLI.ClaimLineItemGroupId ,
						ECLI.ERClaimLineItemId ,
						ECLI.ChargeAmount ,
						ECLI.PayerClaimNumber ,
						AL.ChargeId ,
						erbp.PaymentId ,
						Ch.ChargeId ,
						cnext.ServiceId ,
						cnext.Priority;

			-- defensive coding for duplicate billed charges

				UPDATE	lica
				SET		lica.ChargeId = c2.ChargeId ,
						lica.IsNotPrimary = lica2.IsNotPrimary
				FROM	#LineItemChargeAmount lica
						JOIN dbo.Charges c ON c.ChargeId = lica.ChargeId
						JOIN #LineItemChargeAmount lica2 ON lica2.ERClaimLineItemId = lica.ERClaimLineItemId
						JOIN dbo.Charges c2 ON lica2.ChargeId = c2.ChargeId
												AND c2.Priority < c.Priority
												AND c2.ServiceId = c.ServiceId
												AND c2.ClientCoveragePlanId = c.ClientCoveragePlanId;

			END;

		IF EXISTS ( SELECT	*
					FROM	sys.objects
					WHERE	object_id = OBJECT_ID(N'scsp_PostBatchUpdateLineItemChargeAmount')
							AND type IN ( N'P', N'PC' ) )
			BEGIN
				EXEC scsp_PostBatchUpdateLineItemChargeAmount @ERBatchId = @ERBatchId, @PaymentId = @PaymentId, @CurrentUser = @UserCode,
					@CurrentDate = @CurrentDate;
			END;

-- map the adjustment code to the action
-- default to templateid 1 if the coverage plan can't be determined.
		UPDATE	lia
		SET		lia.ProcessingAction = EPTR.AdjustmentActionId
		FROM	#LineItemAdjustment lia
				JOIN #LineItemChargeAmount AS lica ON lica.ERClaimLineItemId = lia.ERClaimLineItemId
				LEFT JOIN dbo.Charges AS c ON c.ChargeId = lica.ChargeId
				LEFT JOIN dbo.ClientCoveragePlans AS ccp ON ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
				LEFT JOIN dbo.CoveragePlans AS cp ON cp.CoveragePlanId = ccp.CoveragePlanId
				JOIN dbo.ERProcessingTemplateRules EPTR ON EPTR.AdjustmentCodeId = lia.AdjustmentGlobalcode
														AND ISNULL(EPTR.RecordDeleted, 'N') = 'N'
				JOIN dbo.ERProcessingTemplates EPT ON EPTR.ERProcessingTemplateId = EPT.ERProcessingTemplateId
													AND ISNULL(cp.ERProcessingTemplateId, 1) = EPT.ERProcessingTemplateId
													AND ISNULL(EPT.RecordDeleted, 'N') = 'N';

         -- clean up and reapply.

		DELETE	ceclic
		FROM	dbo.ERClaimLineItemCharges ceclic
				JOIN #LineItemChargeAmount lica ON ceclic.ERClaimLineItemId = lica.ERClaimLineItemId;

		INSERT	INTO dbo.ERClaimLineItemCharges
				(	CreatedBy ,
					CreatedDate ,
					ModifiedBy ,
					ModifiedDate ,
					ERClaimLineItemId ,
					ChargeId
				)
		SELECT	@UserCode -- CreatedBy - type_CurrentUser
				,
				GETDATE()-- CreatedDate - type_CurrentDatetime
				,
				@UserCode-- ModifiedBy - type_CurrentUser
				,
				GETDATE()-- ModifiedDate - type_CurrentDatetime
				,
				lica.ERClaimLineItemId-- ERClaimLineItemId - int
				,
				lica.ChargeId-- ChargeId - int
		FROM	#LineItemChargeAmount lica;

  -- get all of the next billable payers
		DECLARE cur_NextBillablePayer INSENSITIVE CURSOR
		FOR
			SELECT DISTINCT
					s.ClientId ,
					s.ServiceId ,
					s.DateOfService ,
					s.ProcedureCodeId ,
					s.ClinicianId ,
					c.ClientCoveragePlanId ,
					lica.ChargeId
			FROM	#LineItemChargeAmount lica
					JOIN dbo.Charges c ON c.ChargeId = lica.ChargeId
					JOIN dbo.Services s ON s.ServiceId = c.ServiceId;
               --WHERE    EXISTS ( SELECT 1
               --                  FROM   #LineItemAdjustment lia
               --                  WHERE  ProcessingAction = 2
               --                         AND lia.ClaimLineItemId = lica.ClaimLineItemId )
                     

		OPEN cur_NextBillablePayer;

		FETCH NEXT FROM cur_NextBillablePayer INTO @ClientId, @ServiceId, @DateOfService, @ProcedureCodeId, @ClinicianId, @ClientCoveragePlanId, @ChargeId;

		WHILE @@Fetch_Status = 0
			BEGIN

				SET @TransferTo = NULL;
				EXEC dbo.ssp_PMGetNextBillablePayer @ClientId = @ClientId, @ServiceId = @ServiceId, @DateOfService = @DateOfService,
					@ProcedureCodeId = @ProcedureCodeId, @ClinicianId = @ClinicianId, @ClientCoveragePlanId = @ClientCoveragePlanId,
					@NextClientCoveragePlanId = @TransferTo OUTPUT;     

				UPDATE	#LineItemChargeAmount
				SET		NextBillablePayer = @TransferTo
				WHERE	ChargeId = @ChargeId;

				FETCH NEXT FROM cur_NextBillablePayer INTO @ClientId, @ServiceId, @DateOfService, @ProcedureCodeId, @ClinicianId, @ClientCoveragePlanId,
					@ChargeId;
			END;

		CLOSE cur_NextBillablePayer;
		DEALLOCATE cur_NextBillablePayer;

	   


		UPDATE	lia
		SET		lia.ProcessingAction = 1
		FROM	#LineItemAdjustment AS lia
				JOIN #LineItemChargeAmount AS lica ON lica.ERClaimLineItemId = lia.ERClaimLineItemId
		WHERE	lia.ProcessingAction = 2
				AND lica.NextBillablePayer IS NULL
				AND lia.AdjustmentGroupCode <> 'PR'
				AND ISNULL(dbo.ssf_GetSystemConfigurationKeyValue('835ONLYTRANSFERPRWHENCLIENTISNEXTPAYER'), 'N') = 'Y';
                
       
-- We'll need the claims per claimline on the off chance the ClaimLine Balance is 0. 
-- If there is no Claimline Balance to use in weighting we'll divide the payment across 
-- the charges equally
		UPDATE	LC
		SET		LC.ClaimsOnThisLine = LineCount.Tally
		FROM	#LineItemChargeAmount LC
				JOIN ( SELECT	LICA.ERClaimLineItemId ,
								COUNT(DISTINCT LICA.ChargeId) AS Tally
						FROM	#LineItemChargeAmount LICA
						GROUP BY LICA.ERClaimLineItemId
						) LineCount ON LC.ERClaimLineItemId = LineCount.ERClaimLineItemId;
      
-- The ClaimLineItemCharges isn't reliable in this case anymore since these could be cross overs.
      -- get the current revenue for each charge
		INSERT	INTO #LineItemOriginalCharge
				(	ERClaimLineItemId ,
					ClaimLineItemId ,
					RevenueAmount 
            
				)
		SELECT	lica.ERClaimLineItemId ,
				lica.ClaimLineItemId ,
				SUM(AL.Amount)
		FROM	#LineItemPaid LIP
				JOIN #LineItemChargeAmount lica ON lica.ERClaimLineItemId = LIP.ERClaimLineItemId
				JOIN dbo.ARLedger AL ON lica.ChargeId = AL.ChargeId
		WHERE	AL.LedgerType IN ( 4201, 4204 )
				AND ISNULL(AL.RecordDeleted, 'N') = 'N'
		GROUP BY lica.ClaimLineItemId ,
				lica.ERClaimLineItemId;   
            
		-- TODO this is wrong because if the charge was billed as a part of a bundle, the ChargeAmount will never equal the RevenueAmount for the charge
		-- If the charge is secondary it will never be true because the revenue never matches what is billed.
		-- I'm going to say this should not be executed for now and move on. 

		IF @BackOutAdjustments = 'Y'
			BEGIN
				UPDATE	LICA
				SET		LICA.BackOutAdjustments = 'Y'
				FROM	#LineItemChargeAmount LICA
						JOIN #LineItemOriginalCharge LIOC ON LICA.ERClaimLineItemId = LIOC.ERClaimLineItemId
						JOIN dbo.ERClaimLineItems ECLI ON ECLI.ERClaimLineItemId = LIOC.ERClaimLineItemId
				WHERE	LIOC.RevenueAmount = ECLI.ChargeAmount
						AND ISNULL(ECLI.RecordDeleted, 'N') = 'N';

-- Remove Adjustments from the charge if they are to be backed out.
				UPDATE	LICA
				SET		LICA.BalanceAmount = LICA.BalanceAmount - Adjustments.Adjustments
				FROM	#LineItemChargeAmount LICA
						JOIN ( SELECT	AL.ChargeId ,
										SUM(AL.Amount) AS Adjustments
								FROM	dbo.ARLedger AL
								WHERE	AL.LedgerType = 4203
										AND ISNULL(AL.MarkedAsError, 'N') = 'N'
										AND ISNULL(AL.ErrorCorrection, 'N') = 'N'
										AND AL.CreatedBy <> @UserCode
								GROUP BY AL.ChargeId
								) Adjustments ON Adjustments.ChargeId = LICA.ChargeId
													AND LICA.BackOutAdjustments = 'Y';
			END;     
-- Compute the expected Payments for each claimline (one level above the Charges)     
		INSERT	INTO #LineItemBalance
				(	ERClaimLineItemId ,
					ClaimLineItemId ,
					BalanceAmount
				)
		SELECT	ChargeOwed.ERClaimLineItemId ,
				ChargeOwed.ClaimLineItemId ,
				SUM(ISNULL(ChargeOwed.BalanceAmount, 0.0))
		FROM	#LineItemChargeAmount ChargeOwed
		GROUP BY ChargeOwed.ERClaimLineItemId ,
				ChargeOwed.ClaimLineItemId; 
                 --,ChargeOwed.IsNotPrimary
     
		UPDATE	#LineItemBalance
		SET		BalanceAmount = NULL  -- so we can use isnull if the line is paid off for a given erclaim
		WHERE	BalanceAmount <= 0;    -- simple average instead of a weighted average
    

--  ************************** Initialize Variables *******************************
--  *******************************************************************************    
--  A Financial Activity may have Many Financial Activity Lines  
		SELECT	@FinancialActivityId = FinancialActivityId ,
				@DateReceived = CAST(DateReceived AS DATE)
		FROM	dbo.Payments
		WHERE	PaymentId = @PaymentId;
 
   
		SELECT TOP 1
				@CurrentAccountingPeriodId = AccountingPeriodId
		FROM	dbo.AccountingPeriods
		WHERE	DATEADD(dd, 1, EndDate) > @DateReceived
				AND OpenPeriod = 'Y'
				AND ISNULL(RecordDeleted, 'N') = 'N'
		ORDER BY StartDate;        
    
    
		SELECT TOP 1
				@PaymentAccountingPeriodId = AccountingPeriodId
		FROM	dbo.AccountingPeriods
		WHERE	CAST(StartDate AS DATE) <= @DateReceived
				AND CAST(EndDate AS DATE) >= DATEADD(dd, 1, @DateReceived)
				AND ISNULL(RecordDeleted, 'N') = 'N';    
      
		SELECT	@OpenPeriod = ISNULL(OpenPeriod, 'N')
		FROM	dbo.AccountingPeriods
		WHERE	AccountingPeriodId = @PaymentAccountingPeriodId;    
      
		IF @OpenPeriod = 'Y'
			SET @CurrentAccountingPeriodId = @PaymentAccountingPeriodId;    
    
      
      
		IF @@error <> 0
			GOTO error;      
/* Check to ensure all coverage plans have Adjustment Rules set up */
		SET @ErrorMessage = NULL;


		IF @ErrorMessage IS NOT NULL
			GOTO error; 
		BEGIN TRANSACTION;  --  Capture Claimline Errors
    
    /* ************** Errors at the claimline level  ******************/
		--GlobalCodeId	CodeName	Active	Category
		--5231			Information	Y		ERMESSAGETYPE       
		--5232			Warning		Y		ERMESSAGETYPE       
		--5233			Error		Y		ERMESSAGETYPE  

	-- Clean up

		DELETE	elig
		FROM	dbo.ERClaimLineItemLog elig
				JOIN #LineItemChargeAmount lica ON lica.ERClaimLineItemId = elig.ERClaimLineItemId;
		
            
		INSERT	INTO dbo.ERClaimLineItemLog
				(	ERClaimLineItemId ,
					ErrorFlag ,
					ERMessageType ,
					ERMessage
            
				)
		SELECT	ECLI.ERClaimLineItemId ,
				'Y' ,
				5233 ,
				'Both Paid amount and Adjustment amount are 0'
		FROM	dbo.ERClaimLineItems ECLI
				JOIN dbo.ERBatchPayments ERBP ON ( ECLI.ERBatchPaymentId = ERBP.ERBatchPaymentId )
				LEFT JOIN #LineItemPaid Paid ON ( ( ECLI.ClaimLineItemId = Paid.ClaimLineItemId
													AND ECLI.ClaimLineItemGroupId IS NULL
													)
													OR ( ECLI.ClaimLineItemGroupId = Paid.ClaimLineItemGroupId
															AND ECLI.ClaimLineItemGroupId IS NOT NULL
														)
												)
				LEFT JOIN #LineItemAdjustment LIA ON ( ( ECLI.ClaimLineItemId = LIA.ClaimLineItemId
															AND ECLI.ClaimLineItemGroupId IS NULL
														)
														OR ( ECLI.ClaimLineItemGroupId = LIA.ClaimLineItemGroupId
																AND ECLI.ClaimLineItemGroupId IS NOT NULL
															)
														)
		WHERE	EXISTS ( SELECT	1
							FROM
								#LineItemChargeAmount lica
							WHERE
								lica.ERClaimLineItemId = ECLI.ERClaimLineItemId )
				AND ISNULL(LIA.AdjustmentAmount, 0) = 0
				AND ISNULL(Paid.PaidAmount, 0) = 0
		UNION ALL
		SELECT	ECLI.ERClaimLineItemId ,
				'Y' ,
				5233 ,
				'Adjustment is on a Claimline Without a Payment'
		FROM	dbo.ERClaimLineItems ECLI
				JOIN dbo.ERBatchPayments ERBP ON ( ECLI.ERBatchPaymentId = ERBP.ERBatchPaymentId )
				LEFT JOIN #LineItemPaid Paid ON ( ( ECLI.ClaimLineItemId = Paid.ClaimLineItemId
													AND ECLI.ClaimLineItemGroupId IS NULL
													)
													OR ( ECLI.ClaimLineItemGroupId = Paid.ClaimLineItemGroupId
															AND ECLI.ClaimLineItemGroupId IS NOT NULL
														)
												)
				LEFT JOIN #LineItemAdjustment LIA ON ( ( ECLI.ClaimLineItemId = LIA.ClaimLineItemId
															AND ECLI.ClaimLineItemGroupId IS NULL
														)
														OR ( ECLI.ClaimLineItemGroupId = LIA.ClaimLineItemGroupId
																AND ECLI.ClaimLineItemGroupId IS NOT NULL
															)
														)
		WHERE	EXISTS ( SELECT	1
							FROM
								#LineItemChargeAmount lica
							WHERE
								lica.ERClaimLineItemId = ECLI.ERClaimLineItemId )
				AND ISNULL(LIA.AdjustmentAmount, 0) <> 0
				AND ISNULL(Paid.PaidAmount, 0) = 0
				AND LIA.AdjustmentGlobalcode IS NOT NULL
				AND @DoNotAllowAdjustmentsWithoutAPaymentOnTheSameClaimLine = 'Y'
		UNION ALL
		SELECT	ECLI.ERClaimLineItemId ,
				'N' ,
				5233  -- error
				,
				'Adjustment Code is Flagged for Reporting: ' + ISNULL(LIA.AdjustmentGroupCode, '??') + ' : ' + ISNULL(LIA.AdjustmentReasonCode, '??')
		FROM	dbo.ERClaimLineItems ECLI
				JOIN dbo.ERBatchPayments ERBP ON ( ECLI.ERBatchPaymentId = ERBP.ERBatchPaymentId )
				JOIN #LineItemAdjustment LIA ON LIA.ERClaimLineItemId = ECLI.ERClaimLineItemId
												AND LIA.ProcessingAction = 4
		WHERE	ECLI.ERBatchId = @ERBatchId
				AND ERBP.PaymentId = @PaymentId
		UNION ALL
		SELECT	ECLI.ERClaimLineItemId ,
				'N' ,
				5233 ,
				'Adjustment code has no processing action: ' + ISNULL(LIA.AdjustmentGroupCode, '??') + ' : ' + ISNULL(LIA.AdjustmentReasonCode, '??')
		FROM	dbo.ERClaimLineItems ECLI
				JOIN dbo.ERBatchPayments ERBP ON ( ECLI.ERBatchPaymentId = ERBP.ERBatchPaymentId )
				JOIN #LineItemAdjustment LIA ON LIA.ERClaimLineItemId = ECLI.ERClaimLineItemId
		WHERE	ECLI.ERBatchId = @ERBatchId
				AND ERBP.PaymentId = @PaymentId
				AND LIA.ProcessingAction IS NULL
		UNION ALL
		SELECT	ecli.ERClaimLineItemId ,
				'N' ,
				5233 ,
				'There are Adjustment Codes not mapped in GlobalCodes: ' + LIA.AdjustmentGroupCode + '-' + LIA.AdjustmentReasonCode RC
		FROM	#LineItemAdjustment LIA
				JOIN dbo.ERClaimLineItems ecli ON ecli.ERClaimLineItemId = LIA.ERClaimLineItemId
				JOIN dbo.ERBatchPayments ERBP ON ecli.ERBatchPaymentId = ERBP.ERBatchPaymentId
		WHERE	LIA.AdjustmentGlobalcode IS NULL
				AND ecli.ERBatchId = @ERBatchId
				AND ERBP.PaymentId = @PaymentId
		UNION ALL
		SELECT	ecli.ERClaimLineItemId ,
				'Y' ,
				5233 ,
				'Unable to identify charge for claim line item. Check Client Coverage for Payer ' + p.PayerName
		FROM	dbo.ERClaimLineItems ecli
				JOIN dbo.ERBatchPayments ebp ON ecli.ERBatchPaymentId = ebp.ERBatchPaymentId
												AND ecli.ERBatchId = @ERBatchId
												AND ebp.PaymentId = @PaymentId
				JOIN dbo.Payers p ON p.PayerId = @PayerId
		WHERE	ecli.ClaimLineItemId IS NOT NULL
				AND ISNULL(ecli.RecordDeleted, 'N') <> 'Y'
				AND @PayerId IS NOT NULL
				AND ISNULL(ecli.Processed, 'N') <> 'Y'
				AND NOT EXISTS ( SELECT	1
									FROM
										#LineItemChargeAmount lica
									WHERE
										lica.ERClaimLineItemId = ecli.ERClaimLineItemId )
		UNION ALL
		SELECT	ecli.ERClaimLineItemId ,
				'Y' ,
				5233 ,
				'Service for this claim line marked as error Date Of Service: ' + CONVERT(VARCHAR, s.DateOfService, 100)
		FROM	dbo.ERClaimLineItems ecli
				JOIN dbo.ERClaimLineItemCharges eclic ON ecli.ERClaimLineItemId = eclic.ERClaimLineItemId
				JOIN dbo.Charges c ON c.ChargeId = eclic.ChargeId
				JOIN dbo.Services AS s ON s.ServiceId = c.ServiceId
											AND s.Status = 76
				JOIN dbo.SystemConfigurationKeys AS sck ON sck.[Key] = 'PostPaymentsToErrorServicesForElectronicRemittance'
															AND ISNULL(sck.Value, 'N') <> 'Y'
		WHERE	EXISTS ( SELECT	1
							FROM
								#LineItemChargeAmount lica
							WHERE
								lica.ERClaimLineItemId = ecli.ERClaimLineItemId );
		IF EXISTS ( SELECT	*
					FROM	sys.objects
					WHERE	object_id = OBJECT_ID(N'scsp_PM835PostBatchValidations')
							AND type IN ( N'P', N'PC' ) )
			BEGIN
				EXEC scsp_PM835PostBatchValidations @ERBatchId = @ERBatchId, @PaymentId = @PaymentId, @CurrentUser = @UserCode, @CurrentDate = @CurrentDate;
			END;

		UPDATE	LIA
		SET		LIA.ProcessingAction = 5
		FROM	dbo.ERClaimLineItems ECLI
				JOIN dbo.ERBatchPayments ERBP ON ( ECLI.ERBatchPaymentId = ERBP.ERBatchPaymentId )
				JOIN #LineItemAdjustment LIA ON LIA.ERClaimLineItemId = ECLI.ERClaimLineItemId
		WHERE	ECLI.ERBatchId = @ERBatchId
				AND ERBP.PaymentId = @PaymentId
				AND LIA.ProcessingAction IS NULL;

			-- action code 6 is "Adjust when the client is the next payer"
		UPDATE	lia
		SET		lia.ProcessingAction = CASE	WHEN lica.NextBillablePayer IS NULL THEN 1
											ELSE 2
										END
		FROM	#LineItemAdjustment AS lia
				JOIN #LineItemChargeAmount AS lica ON lica.ERClaimLineItemId = lia.ERClaimLineItemId
		WHERE	lia.ProcessingAction = 6;

	   --flag the charge          
		UPDATE	c
		SET		c.Flagged = 'Y'
		FROM	#LineItemChargeAmount LICA
				JOIN dbo.Charges c ON c.ChargeId = LICA.ChargeId
		WHERE	EXISTS ( SELECT	1
							FROM
								dbo.ERClaimLineItemLog EL
								JOIN dbo.ERClaimLineItems ECLI ON EL.ERClaimLineItemId = ECLI.ERClaimLineItemId
																AND ECLI.ERClaimLineItemId = LICA.ERClaimLineItemId
								JOIN dbo.ERBatchPayments ERBP ON ( ECLI.ERBatchPaymentId = ERBP.ERBatchPaymentId )
							WHERE
								ECLI.ERBatchId = @ERBatchId
								AND ERBP.PaymentId = @PaymentId
								AND EL.ErrorFlag = 'Y' );          
        
        -- Deleting based on ERClaimLineItem so we still post even if there's another claim in the file that has an issue.
        -- (at least both paid amount and adjustment amount are 0 errors need to only fail the ERClaimLineItem not the whole ClaimLineItem.
    
		DELETE	LICA
		FROM	#LineItemChargeAmount LICA
		WHERE	EXISTS ( SELECT	1
							FROM
								dbo.ERClaimLineItemLog EL
								JOIN dbo.ERClaimLineItems ECLI ON EL.ERClaimLineItemId = ECLI.ERClaimLineItemId
																AND ( ( ECLI.ClaimLineItemId = LICA.ClaimLineItemId
																		AND ECLI.ClaimLineItemGroupId IS NULL
																		)
																		OR ( ECLI.ClaimLineItemGroupId = LICA.ClaimLineItemGroupId
																				AND ECLI.ClaimLineItemGroupId IS NOT NULL
																			)
																	)
								JOIN dbo.ERBatchPayments ERBP ON ( ECLI.ERBatchPaymentId = ERBP.ERBatchPaymentId )
							WHERE
								ECLI.ERBatchId = @ERBatchId
								AND ERBP.PaymentId = @PaymentId
								AND EL.ErrorFlag = 'Y' );
    
                    
		IF @@error <> 0
			GOTO rollback_tran;             
------------------------------------------------------          
------------------------------------------------------          
------------------------------------------------------     
-- Need to trap adjustments with no reason codes, not just the unmappables     
------------------------------------------------------          
------------------------------------------------------          
------------------------------------------------------                
                      
		COMMIT;  -- Capture Claimline errors
       
	-- clean up

		DELETE	eis
		FROM	dbo.ERClaimLineItemImportStaging eis
				JOIN #LineItemChargeAmount lica ON lica.ERClaimLineItemId = eis.ERClaimLineItemId;
    
             
   
    /******************************************
    Spread the paid amount or the Adjustment amount over all claims on the claimline based on 
    The proportion Owed, or evenly if there is already a credit or zero balance.
    *******************************************/
		INSERT	INTO ERClaimLineItemImportStaging
				(	ERBatchId ,
					PaymentId ,
					SortOrder ,
					ERClaimLineItemId ,
					ClaimLineItemId ,
					ClaimedAmount ,
					PayerClaimNumber ,
					PaidAmount ,
					BalanceAmount ,
					chargeID ,
					ClientId ,
					CoveragePlanId ,
					ClientCoveragePlanId ,
					AdjustmentAmount ,
					ProcessingAction ,
					TransferAmount ,
					ReferenceNumber ,
					AdjustmentGlobalCode ,
					AdjustmentGroupCode ,
					AdjustmentReasonCode ,
					BackOutAdjustments ,
					IsNotPrimary ,
					NextBillablePayer
                
				)
               -- payments (this also includes reversals which should just be posted right away)
		SELECT	@ERBatchId ,
				@PaymentId ,
				2 ,
				LICA.ERClaimLineItemId ,
				LICA.ClaimLineItemId ,
				cli.ChargeAmount ,
				LICA.PayerClaimNumber
                   /******************************************
                   Spread the paid amount or the Adjustment amount over all claims on the claimline based on 
                   The proportion Owed, or evenly if there is already a credit or zero balance.
                   *******************************************/ ,
				CAST(LIP.PaidAmount AS DECIMAL(10, 2)) * ISNULL(CAST(S.Charge AS DECIMAL(10, 2)) / CAST(cli.ChargeAmount AS DECIMAL(10, 2)),
																1 / CAST(LICA.ClaimsOnThisLine AS DECIMAL(10, 2))) AS PaidAmount ,
				LICA.BalanceAmount ,
				LICA.ChargeId ,
				S.ClientId ,
				CCP.CoveragePlanId ,
				CCP.ClientCoveragePlanId ,
				0 AS AdjustmentAmount ,
				NULL -- Processing Action
				,
				0 AS TransferAmount ,
				P.ReferenceNumber ,
				-1 AS AdjustmentGlobalCode -- negative one marks a payment
				,
				'??' AS AdjustmentGroupCode ,
				'??' AS AdjustmentReasonCode ,
				LICA.BackOutAdjustments ,
				LICA.IsNotPrimary ,
				LICA.NextBillablePayer -- Next Billable Payer
		FROM	#LineItemChargeAmount LICA
				JOIN #LineItemBalance LIB ON LIB.ERClaimLineItemId = LICA.ERClaimLineItemId
				JOIN #LineItemPaid LIP ON LIP.ERClaimLineItemId = LICA.ERClaimLineItemId
				JOIN dbo.Payments P ON ( LICA.PaymentId = P.PaymentId )
				JOIN dbo.Charges C ON ( LICA.ChargeId = C.ChargeId )
				JOIN dbo.Services S ON ( C.ServiceId = S.ServiceId )
				JOIN dbo.ClientCoveragePlans CCP ON CCP.ClientCoveragePlanId = C.ClientCoveragePlanId
				JOIN dbo.ClaimLineItems cli ON cli.ClaimLineItemId = LICA.ClaimLineItemId
		WHERE	NOT ( CAST(LIP.PaidAmount AS DECIMAL(10, 2)) * ISNULL(( CAST(S.Charge AS DECIMAL(10, 2)) / CAST(cli.ChargeAmount AS DECIMAL(10, 2)) ),
																		( 1 / CAST(LICA.ClaimsOnThisLine AS DECIMAL(10, 2)) )) < 0.01
						AND CAST(LIP.PaidAmount AS DECIMAL(10, 2)) * ISNULL(( CAST(S.Charge AS DECIMAL(10, 2)) / CAST(cli.ChargeAmount AS DECIMAL(10, 2)) ),
																			( 1 / CAST(LICA.ClaimsOnThisLine AS DECIMAL(10, 2)) )) > -0.01
					)
						   
     
				--Adjustments / Transfers 
		UNION ALL
		SELECT	@ERBatchId ,
				@PaymentId ,
				4 ,
				LICA.ERClaimLineItemId ,
				LICA.ClaimLineItemId ,
				cli.ChargeAmount ,
				LICA.PayerClaimNumber ,
				0 ,
				LICA.BalanceAmount ,
				LICA.ChargeId ,
				S.ClientId ,
				CCP.CoveragePlanId ,
				CCP.ClientCoveragePlanId ,
				LIA.AdjustmentAmount * ISNULL(( CAST(S.Charge AS DECIMAL(10, 2)) / CAST(cli.ChargeAmount AS DECIMAL(10, 2)) ),
												( 1 / CAST(LICA.ClaimsOnThisLine AS DECIMAL(10, 2)) )) ,
				LIA.ProcessingAction ,
				0 ,
				P.ReferenceNumber ,
				LIA.AdjustmentGlobalcode AS AdjustmentGlobalCode ,
				LIA.AdjustmentGroupCode AS AdjustmentGroupCode ,
				LIA.AdjustmentReasonCode AS AdjustmentReasonCode ,
				LICA.BackOutAdjustments ,
				LICA.IsNotPrimary ,
				LICA.NextBillablePayer
		FROM	#LineItemChargeAmount LICA
				JOIN #LineItemBalance LIB ON LIB.ERClaimLineItemId = LICA.ERClaimLineItemId
				JOIN #LineItemAdjustment LIA ON LIA.ERClaimLineItemId = LICA.ERClaimLineItemId
				JOIN dbo.Payments P ON ( LICA.PaymentId = P.PaymentId )
				JOIN dbo.Charges C ON ( LICA.ChargeId = C.ChargeId )
				JOIN dbo.Services S ON C.ServiceId = S.ServiceId
				JOIN dbo.ClientCoveragePlans CCP ON CCP.ClientCoveragePlanId = C.ClientCoveragePlanId
				JOIN dbo.ClaimLineItems cli ON cli.ClaimLineItemId = LICA.ClaimLineItemId
				-- for secondary coverage we will need to do something special for transfers.
		WHERE	( LICA.IsNotPrimary = 0
					OR ( LICA.NextBillablePayer IS NULL
							AND LIA.ProcessingAction IN ( 2, 3 )
						)
				);

	-- do not post adjustments /transfers on errored services.
		DELETE	eis
		FROM	dbo.ERClaimLineItemImportStaging eis
				JOIN #LineItemOriginalCharge lica ON lica.ERClaimLineItemId = eis.ERClaimLineItemId
				JOIN dbo.Charges c ON c.ChargeId = eis.ChargeId
				JOIN dbo.Services s ON s.ServiceId = c.ServiceId
										AND s.Status = 76
		WHERE	AdjustmentAmount <> 0.00
				AND PaidAmount = 0.00; 
					 --Identify records that need to be rounded

	-- more bull*** to cover bad data. - We shouldn't have more than one payment per charge, so if we do, something weird is going on and we need to sum them here.
	-- I already tried to cover this by removing the second record earlier but the logic above would halve the payment amount. so we need to fix it here
		UPDATE	eis1
		SET		eis1.PaidAmount = eis1.PaidAmount + eis2.PaidAmount
		FROM	dbo.ERClaimLineItemImportStaging eis1
				JOIN dbo.ERClaimLineItemImportStaging eis2 ON eis1.ERClaimLineItemId = eis2.ERClaimLineItemId
																AND eis1.ChargeId = eis2.ChargeId
																AND eis1.ERBatchId = eis2.ERBatchId
																AND eis1.PaymentId = eis2.PaymentId
																AND eis2.PaidAmount <> 0.00
																AND eis1.ERClaimLineItemImportStagingId < eis2.ERClaimLineItemImportStagingId
		WHERE	eis1.PaidAmount <> 0.00
				AND EXISTS ( SELECT	1
								FROM
									#LineItemChargeAmount lica
								WHERE
									lica.ERClaimLineItemId = eis1.ERClaimLineItemId )
				AND NOT EXISTS ( SELECT	1
									FROM
										dbo.ERClaimLineItemImportStaging eis3
									WHERE
										eis1.ERClaimLineItemId = eis3.ERClaimLineItemId
										AND eis1.ChargeId = eis3.ChargeId
										AND eis1.ERBatchId = eis3.ERBatchId
										AND eis1.PaymentId = eis3.PaymentId
										AND eis3.PaidAmount <> 0.00
										AND eis3.ERClaimLineItemImportStagingId < eis1.ERClaimLineItemImportStagingId );

		DELETE	eis2
		FROM	dbo.ERClaimLineItemImportStaging eis1
				JOIN dbo.ERClaimLineItemImportStaging eis2 ON eis1.ERClaimLineItemId = eis2.ERClaimLineItemId
																AND eis1.ChargeId = eis2.ChargeId
																AND eis1.ERBatchId = eis2.ERBatchId
																AND eis1.PaymentId = eis2.PaymentId
																AND eis2.PaidAmount <> 0.00
																AND eis1.ERClaimLineItemImportStagingId < eis2.ERClaimLineItemImportStagingId
		WHERE	eis1.PaidAmount <> 0.00
				AND EXISTS ( SELECT	1
								FROM
									#LineItemChargeAmount lica
								WHERE
									lica.ERClaimLineItemId = eis1.ERClaimLineItemId );

		UPDATE	eis1
		SET		eis1.AdjustmentAmount = eis1.AdjustmentAmount + eis2.AdjustmentAmount
		FROM	dbo.ERClaimLineItemImportStaging eis1
				JOIN dbo.ERClaimLineItemImportStaging eis2 ON eis1.ERClaimLineItemId = eis2.ERClaimLineItemId
																AND eis1.ChargeId = eis2.ChargeId
																AND eis1.ERBatchId = eis2.ERBatchId
																AND eis1.PaymentId = eis2.PaymentId
																AND eis1.AdjustmentGlobalCode = eis2.AdjustmentGlobalCode
																AND eis2.AdjustmentAmount <> 0.00
																AND eis1.ERClaimLineItemImportStagingId < eis2.ERClaimLineItemImportStagingId
		WHERE	eis1.AdjustmentAmount <> 0.00
				AND EXISTS ( SELECT	1
								FROM
									#LineItemChargeAmount lica
								WHERE
									lica.ERClaimLineItemId = eis1.ERClaimLineItemId )
				AND NOT EXISTS ( SELECT	1
									FROM
										dbo.ERClaimLineItemImportStaging eis3
									WHERE
										eis1.ERClaimLineItemId = eis3.ERClaimLineItemId
										AND eis1.ChargeId = eis3.ChargeId
										AND eis1.AdjustmentGlobalCode = eis3.AdjustmentGlobalCode
										AND eis1.ERBatchId = eis3.ERBatchId
										AND eis1.PaymentId = eis3.PaymentId
										AND eis3.AdjustmentAmount <> 0.00
										AND eis3.ERClaimLineItemImportStagingId < eis1.ERClaimLineItemImportStagingId );

		DELETE	eis2
		FROM	dbo.ERClaimLineItemImportStaging eis1
				JOIN dbo.ERClaimLineItemImportStaging eis2 ON eis1.ERClaimLineItemId = eis2.ERClaimLineItemId
																AND eis1.ChargeId = eis2.ChargeId
																AND eis1.ERBatchId = eis2.ERBatchId
																AND eis1.PaymentId = eis2.PaymentId
																AND eis1.AdjustmentGlobalCode = eis2.AdjustmentGlobalCode
																AND eis2.AdjustmentAmount <> 0.00
																AND eis1.ERClaimLineItemImportStagingId < eis2.ERClaimLineItemImportStagingId
		WHERE	eis1.AdjustmentAmount <> 0.00
				AND EXISTS ( SELECT	1
								FROM
									#LineItemChargeAmount lica
								WHERE
									lica.ERClaimLineItemId = eis1.ERClaimLineItemId )
				AND eis1.ERBatchId = @ERBatchId
				AND eis1.PaymentId = @PaymentId;


--

-- Rounding logic

--

 

--Identify records that need to be rounded

		IF OBJECT_ID('tempdb..#Rounding') IS NOT NULL
			DROP TABLE #Rounding;

		CREATE TABLE #Rounding
			(
				ERClaimLineItemId INT ,
				ChargeId INT ,
				ChargeNumber INT
			);

      

		WITH	CTE_ClaimLineItemCharges
					AS ( SELECT DISTINCT
								s.ERClaimLineItemId ,
								s.ChargeId
							FROM
								dbo.ERClaimLineItemImportStaging s
							WHERE EXISTS (SELECT 1 FROM #LineItemChargeAmount lica WHERE lica.ERClaimLineItemId = s.ERClaimLineItemId)
							AND EXISTS ( SELECT	*
												FROM
													dbo.ERClaimLineItemImportStaging s2
												WHERE
													s2.ERBatchId = s.ERBatchId
													AND s2.PaymentId = s.PaymentId
													AND s2.ClaimLineItemId = s.ClaimLineItemId
													AND ( ( ( s2.PaidAmount - ROUND(s2.PaidAmount, 2) ) <> 0 )
															OR ( s2.AdjustmentAmount - ROUND(s2.AdjustmentAmount, 2) ) <> 0
														) )
						)
			INSERT	INTO #Rounding
					( ERClaimLineItemId ,
						ChargeId ,
						ChargeNumber
					)
			SELECT	c.ERClaimLineItemId ,
					c.ChargeId ,
					ROW_NUMBER() OVER ( PARTITION BY c.ERClaimLineItemId ORDER BY c.ChargeId ) AS ChargeNumber
			FROM	CTE_ClaimLineItemCharges c;

 

-- Round payments: round up odd rows and round down even rows

		UPDATE	s
		SET		s.PaidAmount = CASE	WHEN r.ChargeNumber % 2 = 1 THEN ROUND(s.PaidAmount, 2, 1) + CASE	WHEN s.PaidAmount > 0 THEN 0.01
																										ELSE -0.01
																									END -- Round up odd rows
									ELSE CASE	WHEN ( s.PaidAmount - ROUND(s.PaidAmount, 2) ) = 0
												THEN ROUND(s.PaidAmount, 2, 1) - CASE	WHEN s.PaidAmount > 0 THEN 0.01
																						ELSE -0.01
																					END
												ELSE ROUND(s.PaidAmount, 2, 1)
											END -- Round down even rows
								END
		FROM	dbo.ERClaimLineItemImportStaging s
				JOIN #Rounding r ON r.ERClaimLineItemId = s.ERClaimLineItemId
									AND r.ChargeId = s.ChargeId
		WHERE	s.AdjustmentGlobalCode = -1;

 

-- Round adjustments: the opposite of payments - round down odd rows and round up even rows

		UPDATE	s
		SET		s.AdjustmentAmount = CASE	WHEN r.ChargeNumber % 2 = 1
											THEN CASE	WHEN ( s.AdjustmentAmount - ROUND(s.AdjustmentAmount, 2) ) = 0
														THEN ROUND(s.AdjustmentAmount, 2, 1) - CASE	WHEN s.AdjustmentAmount > 0 THEN 0.01
																									ELSE -0.01
																								END
														ELSE ROUND(s.AdjustmentAmount, 2, 1)
													END -- Round down odd rows
											ELSE ROUND(s.AdjustmentAmount, 2, 1) + CASE	WHEN s.AdjustmentAmount > 0 THEN 0.01
																						ELSE -0.01
																					END -- Round up even rows
										END
		FROM	dbo.ERClaimLineItemImportStaging s
				JOIN #Rounding r ON r.ERClaimLineItemId = s.ERClaimLineItemId
									AND r.ChargeId = s.ChargeId
		WHERE	s.AdjustmentGlobalCode <> -1;

 

-- Final rounding: because of rounding some totals can go over or under the total paid or adjustment amount

-- The final adjustemt amount will be applied only to one payment record and one adjustment record per ERClaimLineItemId

 

-- Fix the balances first in cases where possible

		UPDATE	sp
		SET		sp.PaidAmount = sp.BalanceAmount - ISNULL(sa.AdjustmentAmount, 0)
		FROM	ERClaimLineItemImportStaging sp
				LEFT JOIN ( SELECT	s.ERClaimLineItemId ,
									s.ChargeId ,
									SUM(s.AdjustmentAmount) AS AdjustmentAmount
							FROM	ERClaimLineItemImportStaging s
							WHERE	s.ERBatchId = @ERBatchId
									AND s.PaymentId = @PaymentId
									AND s.AdjustmentGlobalCode <> -1
							GROUP BY s.ERClaimLineItemId ,
									s.ChargeId
							) sa ON sa.ERClaimLineItemId = sp.ERClaimLineItemId
									AND sa.ChargeId = sp.ChargeId
		WHERE	EXISTS (SELECT 1 FROM #LineItemChargeAmount lica WHERE lica.ERClaimLineItemId = sp.ERClaimLineItemId)
				AND sp.AdjustmentGlobalCode = -1
				AND sp.BalanceAmount <> 0
				AND ABS(sp.PaidAmount + ISNULL(sa.AdjustmentAmount, 0) - sp.BalanceAmount) = 0.01;

 

		UPDATE	sa
		SET		AdjustmentAmount = sa.BalanceAmount - ISNULL(sp.PaidAmount, 0)
		FROM	ERClaimLineItemImportStaging sa
				LEFT JOIN ERClaimLineItemImportStaging sp ON sp.ERClaimLineItemId = sa.ERClaimLineItemId
																AND sp.ChargeId = sa.ChargeId
																AND sp.AdjustmentGlobalCode = -1
		WHERE	EXISTS (SELECT 1 FROM #LineItemChargeAmount lica WHERE lica.ERClaimLineItemId = sa.ERClaimLineItemId)
				AND sa.AdjustmentGlobalCode <> -1
				AND sa.BalanceAmount <> 0
				AND ABS(sp.PaidAmount + ISNULL(sa.AdjustmentAmount, 0) - sa.BalanceAmount) = 0.01;

 

		IF OBJECT_ID('tempdb..#FinalRounding') IS NOT NULL
			DROP TABLE #FinalRounding;

 

		CREATE TABLE #FinalRounding
			(
				ERClaimLineItemId INT ,
				PaymentRecordId INT ,
				AdjustmentRecordId INT ,
				AmountDifference MONEY
			);

 

		INSERT	INTO #FinalRounding
				( ERClaimLineItemId ,
					AmountDifference
				)
		SELECT	i.ERClaimLineItemId ,
				MAX(i.PaidAmount) - SUM(s.PaidAmount)
		FROM	dbo.ERClaimLineItemImportStaging s
				JOIN dbo.ERClaimLineItems i ON i.ERClaimLineItemId = s.ERClaimLineItemId
		WHERE	EXISTS(SELECT 1 FROM #LineItemChargeAmount lica WHERE lica.ERClaimLineItemId = s.ERClaimLineItemId)
				AND s.AdjustmentGlobalCode = -1
		GROUP BY i.ERClaimLineItemId
		HAVING	SUM(s.PaidAmount) <> MAX(i.PaidAmount);

 

		UPDATE	fr
		SET		fr.PaymentRecordId = sp.ERClaimLineItemImportStagingId ,
				fr.AdjustmentRecordId = sa.ERClaimLineItemImportStagingId
		FROM	#FinalRounding fr
				JOIN dbo.ERClaimLineItemImportStaging sp ON sp.ERClaimLineItemId = fr.ERClaimLineItemId
															AND sp.AdjustmentGlobalCode = -1
				JOIN dbo.ERClaimLineItemImportStaging sa ON sa.ERClaimLineItemId = fr.ERClaimLineItemId
															AND sa.ChargeId = sp.ChargeId
															AND sa.AdjustmentGlobalCode <> -1;

-- Payments with no corresponding adjustments

		UPDATE	fr
		SET		fr.PaymentRecordId = sp.ERClaimLineItemImportStagingId
		FROM	#FinalRounding fr
				JOIN dbo.ERClaimLineItemImportStaging sp ON sp.ERClaimLineItemId = fr.ERClaimLineItemId
															AND sp.AdjustmentGlobalCode = -1
		WHERE	fr.PaymentRecordId IS NULL;

 

-- Add adjustments with no corresponding payments

		INSERT	INTO #FinalRounding
				( ERClaimLineItemId ,
					AdjustmentRecordId ,
					AmountDifference
				)
		SELECT	s.ERClaimLineItemId ,
				MIN(s.ERClaimLineItemImportStagingId) ,
				SUM(s.AdjustmentAmount) - MAX(a.AdjustmentAmount) -- reverse the difference that will cause these adjustments to be adjusted up
		FROM	dbo.ERClaimLineItemImportStaging s
				JOIN ( SELECT	ERClaimLineItemId ,
								SUM(AdjustmentAmount) AS AdjustmentAmount
						FROM	#LineItemAdjustment
						group by ERClaimLineItemId) a ON a.ERClaimLineItemId = s.ERClaimLineItemId
		WHERE	s.ERBatchId = @ERBatchId
				AND s.PaymentId = @PaymentId
				AND s.AdjustmentGlobalCode <> -1
				AND NOT EXISTS ( SELECT	*
									FROM
										#FinalRounding fr
									WHERE
										fr.ERClaimLineItemId = s.ERClaimLineItemId )
		GROUP BY s.ERClaimLineItemId
		HAVING	ABS(SUM(s.AdjustmentAmount) - MAX(a.AdjustmentAmount)) = 0.01;

 

-- Payments are adjusted up

		UPDATE	s
		SET		s.PaidAmount = s.PaidAmount + fr.AmountDifference
		FROM	dbo.ERClaimLineItemImportStaging s
				JOIN #FinalRounding fr ON fr.PaymentRecordId = s.ERClaimLineItemImportStagingId;

 

-- The corresponding adjustments are adjusted down by the same amount

		UPDATE	s
		SET		s.AdjustmentAmount = s.AdjustmentAmount - fr.AmountDifference
		FROM	dbo.ERClaimLineItemImportStaging s
				JOIN #FinalRounding fr ON fr.AdjustmentRecordId = s.ERClaimLineItemImportStagingId;

 

--

-- End of rounding logic

--
 
		-- For secondaries, Smartcare doesn't work properly if there are more transfer dollars than there is revenue (Charges + Transfers)
		-- But we still need to transfer any remaining revenue.
		-- So we are going to use a specified Transfer Code and transfer the full revenue on the charge less the payment from the EOB.
		INSERT	INTO ERClaimLineItemImportStaging
				(	ERBatchId ,
					PaymentId ,
					SortOrder ,
					ClaimLineItemId ,
					ERClaimLineItemId ,
					ClaimedAmount ,
					PayerClaimNumber ,
					PaidAmount ,
					BalanceAmount ,
					ChargeId ,
					ClientId ,
					CoveragePlanId ,
					ClientCoveragePlanId ,
					AdjustmentAmount ,
					ProcessingAction ,
					TransferAmount ,
					ReferenceNumber ,
					AdjustmentGlobalCode ,
					AdjustmentGroupCode ,
					AdjustmentReasonCode ,
					BackoutAdjustments ,
					IsNotPrimary ,
					NextBillablePayer
				)
		SELECT	@ERBatchId ,
				@PaymentId ,
				5 -- SortOrder - int
				,
				ist.ClaimLineItemId-- ClaimLineItemId - integer
				,
				ist.ERClaimLineItemId-- ERClaimLineItemId - int
				,
				ist.ClaimedAmount-- ClaimedAmount - decimal
				,
				ist.PayerClaimNumber-- PayerClaimNumber - varchar(50)
				,
				0.00-- PaidAmount - decimal
				,
				ist.BalanceAmount-- BalanceAmount - decimal
				,
				ist.ChargeId-- chargeID - char(10)
				,
				ist.ClientId-- ClientId - char(10)
				,
				ist.CoveragePlanId-- CoveragePlanId - integer
				,
				ist.ClientCoveragePlanId-- ClientCoveragePlanId - integer
			   -- The revenue on the charge less the payment (and any adjustments for this charge already being included)
				,
				revenue.amount - ISNULL(adjustments.amount, 0.00) - ist.PaidAmount -- AdjustmentAmount - decimal
				,
				CASE	WHEN ist.NextBillablePayer IS NULL THEN CASE ISNULL(@AutomaticTransferForSecondaryAdjustWhenClientIsNextPayer, 'N')
																	WHEN 'Y' THEN 1
																	ELSE 2
																END
						ELSE 2
				END-- ProcessingAction - int
				,
				0-- TransferAmount - decimal
				,
				ist.ReferenceNumber-- ReferenceNumber - varchar(30)
				,
				gc.GlobalCodeId-- AdjustmentGlobalCode - integer
				,
				gc.ExternalCode2-- AdjustmentGroupCode - varchar(50)
				,
				gc.ExternalCode1-- AdjustmentReasonCode - varchar(50)
				,
				ist.BackoutAdjustments-- BackOutAdjustments - char(1)
				,
				ist.IsNotPrimary-- IsNotPrimary - bit
				,
				ist.NextBillablePayer-- NextBillablePayer - int
		FROM	ERClaimLineItemImportStaging AS ist -- need this per charge which we haven't calculated in another table.
				-- so just cross apply for everything, I guess.
				CROSS APPLY ( SELECT	SUM(al.Amount)
								FROM	dbo.ARLedger AS al
								WHERE	al.ChargeId = ist.ChargeId
										AND ISNULL(al.RecordDeleted, 'N') <> 'Y'
										AND al.LedgerType IN ( 4204, 4201 )
							) revenue ( amount )
					-- since we're going to be transfering in some cases (Read: when the client is the next payer) we need to include staged adjustments for this charge.
				CROSS APPLY ( SELECT	SUM(ist2.AdjustmentAmount)
								FROM	ERClaimLineItemImportStaging AS ist2
								WHERE	ist.ChargeId = ist2.ChargeId
										AND ist.ERClaimLineItemId = ist2.ERClaimLineItemId
										AND ISNULL(ist2.AdjustmentAmount, 0.00) <> 0.00
										AND ISNULL(ist2.RecordDeleted, 'N') <> 'Y'
										AND ist2.ERBatchId = @ERBatchId
										AND ist2.PaymentId = @PaymentId
							) adjustments ( amount )
				JOIN dbo.GlobalCodes AS gc ON gc.GlobalCodeId = @AutomaticTransferForSecondaryAdjustmentCode
				JOIN dbo.Charges AS c ON c.ChargeId = ist.ChargeId
						-- do not post for errored services
				JOIN dbo.Services AS s ON s.ServiceId = c.ServiceId
											AND s.Status <> 76
		WHERE	ISNULL(ist.PaidAmount, 0.00) > 0.00
				AND ist.IsNotPrimary = 1
				AND EXISTS ( SELECT	1
								FROM
									#LineItemChargeAmount lica
								WHERE
									lica.ERClaimLineItemId = ist.ERClaimLineItemId )
				AND @AutomaticTransferForSecondary = 'Y'
				AND revenue.amount - ISNULL(adjustments.amount, 0.00) - ist.PaidAmount > 0.00;

				-- If there is no payment, we need to transfer, but instead of a fixed adjustment code we will need to use one from the EOB
				-- minus any transfers adjustments already being posted for the secondary.
		INSERT	INTO ERClaimLineItemImportStaging
				(	ERBatchId ,
					PaymentId ,
					SortOrder ,
					ClaimLineItemId ,
					ERClaimLineItemId ,
					ClaimedAmount ,
					PayerClaimNumber ,
					PaidAmount ,
					BalanceAmount ,
					chargeID ,
					ClientId ,
					CoveragePlanId ,
					ClientCoveragePlanId ,
					AdjustmentAmount ,
					ProcessingAction ,
					TransferAmount ,
					ReferenceNumber ,
					AdjustmentGlobalCode ,
					AdjustmentGroupCode ,
					AdjustmentReasonCode ,
					BackOutAdjustments ,
					IsNotPrimary ,
					NextBillablePayer
				
				)
		SELECT	@ERBatchId ,
				@PaymentId ,
				5-- SortOrder - int
				,
				LICA.ClaimLineItemId-- ClaimLineItemId - integer
				,
				LICA.ERClaimLineItemId-- ERClaimLineItemId - int
				,
				cli.ChargeAmount-- ClaimedAmount - decimal
				,
				LICA.PayerClaimNumber-- PayerClaimNumber - varchar(50)
				,
				0.00-- PaidAmount - decimal
				,
				LICA.BalanceAmount-- BalanceAmount - decimal
				,
				LICA.ChargeId-- chargeID - char(10)
				,
				S.ClientId-- ClientId - char(10)
				,
				CCP.CoveragePlanId-- CoveragePlanId - integer
				,
				CCP.ClientCoveragePlanId-- ClientCoveragePlanId - integer
				,
				revenue.amount - ISNULL(adjustments.amount, 0.00)-- AdjustmentAmount - decimal
				,
				CASE	WHEN LICA.NextBillablePayer IS NULL THEN CASE ISNULL(@AutomaticTransferForSecondaryAdjustWhenClientIsNextPayer, 'N')
																	WHEN 'Y' THEN 1
																	ELSE 2
																	END
						ELSE 2
				END-- ProcessingAction - int
				,
				0.00-- TransferAmount - decimal
				,
				P.ReferenceNumber-- ReferenceNumber - varchar(30)
				,
				gc.GlobalCodeId-- AdjustmentGlobalCode - integer
				,
				gc.ExternalCode2-- AdjustmentGroupCode - varchar(50)
				,
				gc.ExternalCode1-- AdjustmentReasonCode - varchar(50)
				,
				LICA.BackOutAdjustments-- BackOutAdjustments - char(1)
				,
				LICA.IsNotPrimary-- IsNotPrimary - bit
				,
				LICA.NextBillablePayer-- NextBillablePayer - int                
		FROM	#LineItemChargeAmount AS LICA -- pull the adjustment code
				CROSS APPLY ( SELECT	MIN(lia.AdjustmentGlobalcode)
								FROM	#LineItemAdjustment AS lia
								WHERE	lia.ERClaimLineItemId = LICA.ERClaimLineItemId
										  -- unless we're already using that one.
										AND NOT EXISTS ( SELECT	1
															FROM
																ERClaimLineItemImportStaging ist3
															WHERE
																ist3.AdjustmentGlobalCode = lia.AdjustmentGlobalcode
																AND ist3.ERClaimLineItemId = LICA.ERClaimLineItemId
																AND ist3.ChargeId = LICA.ChargeId
																AND ist3.ERBatchId = @ERBatchId
																AND ist3.PaymentId = @PaymentId
																AND ISNULL(ist3.RecordDeleted, 'N') <> 'Y' )
							) adjustmentcode ( code )
				CROSS APPLY ( SELECT	SUM(ist2.AdjustmentAmount)
								FROM	ERClaimLineItemImportStaging AS ist2
								WHERE	LICA.ChargeId = ist2.chargeId
										AND LICA.ERClaimLineItemId = ist2.ERClaimLineItemId
										AND ISNULL(ist2.adjustmentAmount, 0.00) <> 0.00
										AND ISNULL(ist2.recordDeleted, 'N') <> 'Y'
										AND ist2.erbatchid = @ERBatchId
										AND ist2.PaymentId = @PaymentId
							) adjustments ( amount )
				CROSS APPLY ( SELECT	SUM(al.Amount)
								FROM	dbo.ARLedger AS al
								WHERE	al.ChargeId = LICA.ChargeId
										AND ISNULL(al.RecordDeleted, 'N') <> 'Y'
										AND al.LedgerType IN ( 4204, 4201 )
							) revenue ( amount )
				JOIN dbo.GlobalCodes AS gc -- otherwise default to configured code.
				ON ISNULL(adjustmentcode.code, @AutomaticTransferForSecondaryAdjustmentCode) = gc.GlobalCodeId
				JOIN dbo.ClaimLineItems cli ON cli.ClaimLineItemId = LICA.ClaimLineItemId
				JOIN dbo.Charges C ON LICA.ChargeId = C.ChargeId
				JOIN dbo.ClientCoveragePlans CCP ON CCP.ClientCoveragePlanId = C.ClientCoveragePlanId
				JOIN dbo.Services S ON C.ServiceId = S.ServiceId
										AND S.Status <> 76
				JOIN dbo.Payments P ON LICA.PaymentId = P.PaymentId
		WHERE	NOT EXISTS ( SELECT	1
								FROM
									ERClaimLineItemImportStaging AS ist
								WHERE
									ist.chargeID = LICA.ChargeId
									AND ist.ERBatchId = @ERBatchId
									AND ist.PaymentId = @PaymentId
									AND ISNULL(ist.PaidAmount, 0.00) <> 0.00 ) -- <> 0.00 because if there is a reversal we don't want to do this.
											-- If the EOB is a reversal, the automatic transfer reversal process above should cover any transfers on the secondary.
				AND LICA.IsNotPrimary = 1
				AND revenue.amount - ISNULL(adjustments.amount, 0.00) > 0.00
				AND ISNULL(@AutomaticTransferForSecondary, 'N') = 'Y';
					
		-- Payers of Last Resort - should only ever adjust
		UPDATE	ist
		SET		ist.ProcessingAction = 1
		FROM	ERClaimLineItemImportStaging AS ist
				JOIN dbo.ssf_RecodeValuesCurrent('X835PayersOfLastResort') AS plr ON plr.IntegerCodeId = ist.CoveragePlanId
		WHERE	ist.ProcessingAction = 2;                                
                 

		IF @@error <> 0
			GOTO error;        

		  

		IF EXISTS ( SELECT	*
					FROM	sys.objects
					WHERE	object_id = OBJECT_ID(N'scsp_PM835PostBatchUpdateImportStaging')
							AND type IN ( N'P', N'PC' ) )
			BEGIN
				EXEC scsp_PM835PostBatchUpdateImportStaging @ERBatchId = @ERBatchId, @PaymentId = @PaymentId, @CurrentUser = @UserCode,
					@CurrentDate = @CurrentDate;
			END;


		IF ( ISNULL(NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('AllowERAutoPostLedgerTransactions'), ''), 'Y') = 'Y' )
			BEGIN                           
				IF CURSOR_STATUS('global', 'cur_import') >= -1
					BEGIN      
						CLOSE cur_import;      
						DEALLOCATE cur_import;      
					END;      
        
 -- Cursor loop is at the Charge Level, but we're sorting by Claimline Item so we
 -- can do a transaction for each claimline.             
                        
				DECLARE cur_import CURSOR
				FOR
					SELECT	[IS].ClaimLineItemId ,
							[IS].ClaimedAmount ,
							[IS].PayerClaimNumber ,
							[IS].PaidAmount ,
							[IS].BalanceAmount ,
							[IS].chargeID ,
							[IS].ClientId ,
							[IS].CoveragePlanId ,
							[IS].ClientCoveragePlanId ,
							[IS].AdjustmentAmount ,
							[IS].ProcessingAction ,
							[IS].TransferAmount ,
							[IS].ReferenceNumber ,
							[IS].AdjustmentGlobalCode ,
							[IS].BackOutAdjustments ,
							[IS].IsNotPrimary ,
							[IS].NextBillablePayer
					FROM	ERClaimLineItemImportStaging [IS]
					WHERE	EXISTS ( SELECT	1
										FROM
											#LineItemChargeAmount lica
										WHERE
											lica.ERClaimLineItemId = [IS].ERClaimLineItemId )
					ORDER BY [IS].ClaimLineItemId ,
							SortOrder; 
                    
				OPEN cur_import;      

				FETCH NEXT FROM cur_import      
INTO @ClaimLineItemId, @ClaimedAmount, @PayerClaimNumber, @PaidAmount, @BalanceAmount, @ChargeId, @ClientId, @CoveragePlanId, @ClientCoveragePlanId,
					@AdjustmentAmount, @ProcessingAction, @TransferAmount, @CheckNo, @AdjustmentGlobalCodeId, @BackOutAdjustments, @IsNotPrimary, @TransferTo;
      
				IF @@error <> 0
					GOTO error;      
      
				WHILE @@fetch_status = 0
					BEGIN       
        
						IF @TransactionOpen = 'N' -- One transaction for one charge
							BEGIN
								BEGIN TRANSACTION;
								SET @TransactionOpen = 'Y';
								IF @BackOutAdjustments = 'Y'
									BEGIN                
        							-- Insert reversing entries in ARLedger           
										INSERT	INTO dbo.ARLedger
												(	ChargeId ,
													FinancialActivityLineId ,
													FinancialActivityVersion ,
													LedgerType ,
													Amount ,
													PaymentId ,
													AdjustmentCode ,
													AccountingPeriodId ,
													PostedDate ,
													ClientId ,
													CoveragePlanId ,
													DateOfService ,
													ErrorCorrection ,
													CreatedBy ,
													CreatedDate ,
													ModifiedBy ,
													ModifiedDate
			                                        
												
												)
										SELECT	AR.ChargeId ,
												AR.FinancialActivityLineId ,
												AR.FinancialActivityVersion ,
												AR.LedgerType ,
												-AR.Amount ,
												AR.PaymentId ,
												AR.AdjustmentCode ,
												@CurrentAccountingPeriodId ,
												@CurrentDate ,
												AR.ClientId ,
												AR.CoveragePlanId ,
												AR.DateOfService ,
												'Y' ,
												@UserCode ,
												@CurrentDate ,
												@UserCode ,
												@CurrentDate
										FROM	dbo.ARLedger AR
												JOIN dbo.ERClaimLineItemCharges AS eclic ON eclic.ChargeId = AR.ChargeId
												JOIN dbo.ERClaimLineItems AS ecli ON ecli.ERClaimLineItemId = eclic.ERClaimLineItemId
										WHERE	ecli.ClaimLineItemId = @ClaimLineItemId
												AND ecli.ERBatchId = @ERBatchId
												AND AR.LedgerType = 4203
												AND AR.CreatedBy <> @UserCode
												AND ISNULL(AR.MarkedAsError, 'N') = 'N'
												AND ISNULL(AR.ErrorCorrection, 'N') = 'N';
                                                            
											-- Set ARLedger entries for current version to MarkedAsError          
										UPDATE	AR
										SET		AR.MarkedAsError = 'Y' ,
												AR.ModifiedBy = @UserCode ,
												AR.ModifiedDate = @CurrentDate
										FROM	dbo.ARLedger AR
												JOIN dbo.ERClaimLineItemCharges AS eclic ON eclic.ChargeId = AR.ChargeId
												JOIN dbo.ERClaimLineItems AS ecli ON ecli.ERClaimLineItemId = eclic.ERClaimLineItemId
										WHERE	ecli.ClaimLineItemId = @ClaimLineItemId
												AND ecli.ERBatchId = @ERBatchId
												AND AR.CreatedBy <> @UserCode
												AND AR.LedgerType = 4203
												AND ISNULL(AR.MarkedAsError, 'N') = 'N'
												AND ISNULL(AR.ErrorCorrection, 'N') = 'N';
										IF @@error <> 0
											GOTO error;          

									END; -- Backout Adjustment
        
        
							END;
						SET @FinancialActivityLineId = NULL;      
						SET @ARLedgerId = NULL;      
						SET @DateOfService = NULL;      
						SET @TransferChargeToNextPayer = 'N';
						SET @AdjustCharge = 'N';
						SET @AssignToClient = 'N';
						SET @Flagged = 'N';
            
--Find DateOfService      
						SET @DateOfService = ( SELECT TOP 1
														S.DateOfService
												FROM	dbo.Services S
														JOIN dbo.Charges ch ON ch.ServiceId = S.ServiceId
												WHERE	ch.ChargeId = @ChargeId
														AND ISNULL(ch.RecordDeleted, 'N') = 'N'
														AND ISNULL(S.RecordDeleted, 'N') = 'N'
												);      

						IF @PaidAmount = 0
							AND @AdjustmentAmount = 0 -- No activity on this ERClaimlineItem
							BEGIN
								UPDATE	dbo.Charges
								SET		Flagged = 'Y'
								WHERE	ChargeId = @ChargeId; 
								SET @Flagged = 'Y';
							END;
						IF NOT EXISTS ( SELECT	1
										FROM	ERClaimLineItemImportStaging
										WHERE	PaidAmount <> 0
												AND ClaimLineItemId = @ClaimLineItemId )-- Possible denial
							BEGIN
								UPDATE	dbo.Charges
								SET		Flagged = 'Y'
								WHERE	ChargeId = @ChargeId;       
								SET @Flagged = 'Y';
							END;      
      -- if the amount on the claim equals the adjustment, the claim was denied
						IF @AdjustmentAmount = @ClaimedAmount
							BEGIN
								UPDATE	dbo.Charges
								SET		Flagged = 'Y'
								WHERE	ChargeId = @ChargeId; 
								SET @Flagged = 'Y';      
							END;
						IF @PaidAmount <> 0
							BEGIN       
								SELECT	@ClientId = s.ClientId ,
										@ServiceId = s.ServiceId ,
										@ProcedureCodeId = s.ProcedureCodeId ,
										@DateOfService = s.DateOfService ,
										@ClinicianId = s.ClinicianId
								FROM	dbo.Services s
										JOIN dbo.Charges ch ON ch.ServiceId = s.ServiceId
								WHERE	ch.ChargeId = @ChargeId
										AND ISNULL(s.RecordDeleted, 'N') = 'N'
										AND ISNULL(ch.RecordDeleted, 'N') = 'N';      
      
								EXEC dbo.ssp_PMPaymentAdjustmentPost @UserCode = @UserCode, @FinancialActivityId = @FinancialActivityId, @PaymentId = @PaymentId,
									@Payment = @PaidAmount, @PostedAccountingPeriodId = @CurrentAccountingPeriodId, @Flagged = @Flagged, @ChargeId = @ChargeId,
									@ServiceId = @ServiceId, @DateOfService = @DateOfService, @ClientId = @ClientId, @CoveragePlanId = @CoveragePlanId,
									@ERTransferPosting = 'N', @FinancialActivityLineId = NULL;    
            
								IF @@error <> 0
									GOTO rollback_tran;      
      
							END; -- @PaidAmount <> 0      
      
						IF @AdjustmentAmount <> 0
							AND @ApplyAdjustments = 'Y'
							BEGIN       
                
                
-- If we identified a charge for which we had already posted an adjustment before billing.  IE. we charge 100 but they have an allowed amount of 80, we will have posted an adjustment of 20, **IF** we bill them the allowed amount.                
                  
								SELECT	@ClientId = s.ClientId ,
										@ServiceId = s.ServiceId ,
										@ProcedureCodeId = s.ProcedureCodeId ,
										@DateOfService = s.DateOfService ,
										@ClinicianId = s.ClinicianId
								FROM	dbo.Services s
										JOIN dbo.Charges ch ON ch.ServiceId = s.ServiceId
								WHERE	ch.ChargeId = @ChargeId
										AND ISNULL(s.RecordDeleted, 'N') = 'N'
										AND ISNULL(ch.RecordDeleted, 'N') = 'N';      


                    
								SELECT	@TransferChargeToNextPayer = 'Y'
								WHERE	@ProcessingAction = 2;  -- Value in ERProcessingActions
                    
								SELECT	@AssignToClient = 'Y'
								WHERE	@ProcessingAction = 3; -- Value in ERProcessingActions
                
                                                                   
								SELECT	@AdjustCharge = 'Y'
								WHERE	@ProcessingAction = 1; -- Value in ERProcessingActions

								IF @TransferChargeToNextPayer = 'Y'
									OR @AssignToClient = 'Y'
									BEGIN  -- It is a transfer
										IF @ApplyTransfers = 'Y'
											BEGIN
                                        
												IF @AssignToClient = 'Y'
													BEGIN
														SET @CoveragePlanId = NULL;  -- This will assign charge to a client.
														SET @TransferTo = NULL;
													END;         
												EXEC dbo.ssp_PMPaymentAdjustmentPost @UserCode = @UserCode, @FinancialActivityId = @FinancialActivityId,
													@PaymentId = NULL, @FinancialActivityLineId = NULL, @ChargeId = @ChargeId, @ServiceId = @ServiceId,
													@DateOfService = @DateOfService, @ClientId = @ClientId, @CoveragePlanId = @CoveragePlanId,
													@Flagged = @Flagged, @Transfer1 = @AdjustmentAmount, @TransferTo1 = @TransferTo,
													@TransferCode1 = @AdjustmentGlobalCodeId;           

											END;
									END;
								ELSE
									BEGIN  -- it is not a transfer, just an adjustment
                           
										IF @ApplyAdjustments = 'Y'
											AND @AdjustCharge = 'Y'
											BEGIN

												EXEC dbo.ssp_PMPaymentAdjustmentPost @UserCode = @UserCode, @FinancialActivityId = @FinancialActivityId,
													@PaymentId = NULL, @Adjustment1 = @AdjustmentAmount, @AdjustmentCode1 = @AdjustmentGlobalCodeId  --1000288  what was this?
													, @PostedAccountingPeriodId = @CurrentAccountingPeriodId, @Flagged = @Flagged, @ChargeId = @ChargeId,
													@ServiceId = @ServiceId, @DateOfService = @DateOfService, @ClientId = @ClientId,
													@CoveragePlanId = @CoveragePlanId, @ERTransferPosting = 'N', @FinancialActivityLineId = NULL;    
											END;
										ELSE
											IF @ProcessingAction <> 5-- It's an error 
																   -- Processing action 5 is "Skip Adjustment/Transfer"
																   -- so don't flag the charge.
												BEGIN
													UPDATE	dbo.Charges
													SET		Flagged = 'Y'
													WHERE	ChargeId = @ChargeId; 
													SET @Flagged = 'Y';
												END;
									END;               

                        
								IF @@error <> 0
									GOTO rollback_tran;      
      
							END; -- @AdjustmentAmount <> 0  
      
 
      
						IF @@error <> 0
							GOTO rollback_tran;      
                
						SET @SaveClaimLineItemId = @ClaimLineItemId;
      
						FETCH NEXT FROM cur_import      
INTO @ClaimLineItemId, @ClaimedAmount, @PayerClaimNumber, @PaidAmount, @BalanceAmount, @ChargeId, @ClientId, @CoveragePlanId, @ClientCoveragePlanId,
							@AdjustmentAmount, @ProcessingAction, @TransferAmount, @CheckNo, @AdjustmentGlobalCodeId, @BackOutAdjustments, @IsNotPrimary,
							@TransferTo;
						IF @@error <> 0
							GOTO rollback_tran;   
                
						IF @@FETCH_STATUS <> 0
							OR @ClaimLineItemId <> @SaveClaimLineItemId -- claimline changed
							BEGIN
								UPDATE	dbo.ERClaimLineItems  -- not setting modified?
								SET		Processed = 'Y' ,
										ProcessedDate = GETDATE()
								FROM	dbo.ERClaimLineItems
								WHERE	ClaimLineItemId = @SaveClaimLineItemId
										AND ERBatchId = @ERBatchId;
								COMMIT TRANSACTION; -- Write the claimline information out 
								SET @TransactionOpen = 'N';
        
							END; -- @@fetch_status = 0 for cur_import        

					END; 

				CLOSE cur_import;      
				DEALLOCATE cur_import;  
			END;

		IF EXISTS ( SELECT	*
					FROM	sys.objects
					WHERE	object_id = OBJECT_ID(N'scsp_PM835PostBatchPostPosting')
							AND type IN ( N'P', N'PC' ) )
			BEGIN
				EXEC scsp_PM835PostBatchPostPosting @ERBatchId = @ERBatchId, @PaymentId = @PaymentId, @CurrentUser = @UserCode, @CurrentDate = @CurrentDate;
			END;
                     
  -- Flag charges that have been flagged by the process
      
		IF @@error <> 0
			GOTO error;      
  
		RETURN;      
      
		rollback_tran:      
      
		ROLLBACK TRAN;      
      
		error:      
      
		SET @ErrorMessage = ISNULL(@ErrorMessage + ' [ssp_PM835PostBatch]', '[ssp_PM835PostBatch]');
      
		RAISERROR (@ErrorMessage,16,1);

      
		RETURN;

GO


