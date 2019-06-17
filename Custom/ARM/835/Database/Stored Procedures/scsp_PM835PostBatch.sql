IF OBJECT_ID('scsp_PM835PostBatch','P') IS NOT NULL
DROP PROC scsp_PM835PostBatch
Go

/****** Object:  StoredProcedure [dbo].[scsp_PM835PostBatch]    Script Date: 8/9/2018 3:29:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[scsp_PM835PostBatch]
       @ERBatchId INT
      ,@PaymentId INT
AS -- Stored Procedure: ssp_835_post_batch                         
-- Creation Date:    80701                                               
--                                                                         
-- Purpose:   Handles the posting of charges and adjustments from an 835 file.          
--				          
--				          
--				          
-- Input Parameters: @ERbatchId, @PaymentID                
--                                                                         
-- Output Parameters:                                                      
--                                                                         
-- Return Status:                                                          
--                                                                         
-- Called By:        ssp_PM835PaymentPosting              
--                                                                         
---                                                                         
-- Updates:                                                                
--   Date  Author      Purpose                                          
--  80701  JHB	Created                                          
--  11604  JHB   Modified to post refunds from current Payment       
--  81506  TER   Added Adjustment posting logic.         
--  032812 MSuma  Fixed to correct incorrect FinancialActivityLines in Ledgers       
--  040412 MSuma  Modified Custom table to core        
--  040912 MSuma  Modified ERErrorType       
--  012814 jwheeler	Modified to allocate payments / adjustments across all claims on a claimline 
--  120215 dknewtson Included logic to roll back transfers to the next payer or the client if any before applying 
--  120615 dknewtson What: Moved validatoin on missing adjustment codes from GlobalCodes to ClaimLineItem level
--                   Why:  The system used to back out the whole payment requiring the whole file being rolled back and reapplied.
--                   Instead, the customer can review the error report to find these cases.
--  120715 dknewtson What: Included validation for claim line items that have already been sent and processed being included on the EOB.
--  120915 dknewtson What: Removed validation for claim line items that have already been sent and processed being included on the EOB.
--  012716 dknewtson What: Implementing Cross overs - Identify charge by Payer ALWAYS ignore ClaimLineItemCharges
--                         Removed validation for "Total Paid exceeded expected payment".  We want to pay first and deal with imbalance later.
--                         Implementing Class of Contract for 835s
--  033116 dknewtson What: Including system configuration key to prevent posting when payment is zero.
--  052317 dknewtson What: Setting up Back out adjustments and correcting a typo in previous change.
--	080918 MJensen	 What:	Output to ERClaimLineItemCharges rather than CustomERClaimLineItemCharges.  ARM support #960
--      
-- Transfers are not yet set up
 -- called by      exec ssp_PM835PaymentPosting
      --    exec [scsp_PM835PostBatch] 17, null
      --    exec [scsp_PM835PostBatch] 18, null
      --    exec [scsp_PM835PostBatch] 17, 263
      
      
      
/*********************************************************************/      


--     BEHAVIOR VARIABLES
-------------------------------------------------

       DECLARE @ApplyAdjustments CHAR(1)      
       DECLARE @ApplyTransfers CHAR(1)    
       DECLARE @BackOutAdjustments CHAR(1)
       DECLARE @DoNotAllowAdjustmentsWithoutAPaymentOnTheSameClaimLine CHAR(1) = 'N'
  
-------------------------------------------------

      
       DECLARE @ClaimLineItemId INT   
       DECLARE @ClaimedAmount DECIMAL(10, 2) -- for checking for denials   
       DECLARE @PayerClaimNumber VARCHAR(30)      
       DECLARE @CoveragePlanId CHAR(10)    
       DECLARE @ChargeId CHAR(10)        
       DECLARE @ClientId CHAR(10)      
       DECLARE @PaidAmount DECIMAL(10, 2)      
       DECLARE @BalanceAmount DECIMAL(10, 2)
       DECLARE @TransferAmount DECIMAL(10, 2)      
       DECLARE @AdjustmentAmount DECIMAL(10, 2)      
       DECLARE @CheckNo VARCHAR(30)    
       DECLARE @FinancialActivityId INT           
       DECLARE @DateOfService DATETIME      
       DECLARE @UserCode VARCHAR(MAX) 
       DECLARE @ServiceId INT      
       DECLARE @ClientCoveragePlanId INT      
       DECLARE @TransferTo INT      
       DECLARE @CurrentAccountingPeriodId INT      
       DECLARE @PaymentAccountingPeriodId INT      
       DECLARE @OpenPeriod CHAR(1)    
       DECLARE @ARLedgerId CHAR(10)      
       DECLARE @FinancialActivityLineId INT      
       DECLARE @ErrorNo INT      
       DECLARE @ProcedureCodeId INT      
       DECLARE @ErrorMessage VARCHAR(250)      
       DECLARE @ClinicianId INT      
       DECLARE @AdjustmentGlobalCodeId INTEGER  
       DECLARE @TransferChargeToNextPayer CHAR(1)
       DECLARE @AdjustCharge CHAR(1)
       DECLARE @AdjustmentCode CHAR(10)
       DECLARE @TransactionOpen CHAR(1) = 'N'
       DECLARE @SaveClaimLineItemId INT      
       DECLARE @DateReceived DATE    
       DECLARE @CurrentDate DATETIME 
       DECLARE @AssignToClient CHAR(1)
       DECLARE @ClaimLineAdjustmentCheckDone CHAR(1) 
       --DECLARE @ClaimLineTransferCheckDone CHAR(1)
       DECLARE @ProcessingAction INTEGER
       DECLARE @IsNotPrimary BIT
       DECLARE @Flagged CHAR(1) 
  -- additional variables for Rollback of transfers
       --DECLARE @ClientTransferAmount MONEY
       --       ,@ClientChargeId INT
       --       ,@CurrentCoveragePlanId INT
       --       ,@TransferBackTo INT
       --       ,@ReverseTransferAdjustmentCode INT  
       
       DECLARE @ReverseFakeChargeAdjustAmount MONEY
              ,@NextChargeId INT
              ,@NextCoveragePlanId INT
             
	   DECLARE @AutomaticTransferForSecondary CHAR(1)
	   DECLARE @AutomaticTransferForSecondaryAdjustmentCode INT
	   SELECT   @AutomaticTransferForSecondary = RIGHT(dbo.ssf_GetSystemConfigurationKeyValue('AutomaticTransferForSecondary'), 1)
   
       SELECT   @AutomaticTransferForSecondaryAdjustmentCode = dbo.ssf_GetSystemConfigurationKeyValue('AutomaticTransferForSecondaryAdjustmentCode')
       WHERE    ISNUMERIC(dbo.ssf_GetSystemConfigurationKeyValue('AutomaticTransferForSecondaryAdjustmentCode')) = 1

       IF @AutomaticTransferForSecondary = 'Y'
          AND @AutomaticTransferForSecondaryAdjustmentCode IS NULL 
          RAISERROR('Automatic Transfer for Secondary requires AutomaticTransferForSecondaryAdjustmentCode to be set.',16,1) 
 
       DECLARE @VerboseMode CHAR(1) = 'N'
       DECLARE @FalseChargeAdjustmentCode INT
       DECLARE @DoNotPostWithoutPayment CHAR(1) = 'N'     

       SELECT   @VerboseMode = RIGHT(dbo.ssf_GetSystemConfigurationKeyValue('ELECTRONICREMITTANCEVERBOSEMODE'), 1)

       SELECT   @FalseChargeAdjustmentCode = dbo.ssf_GetSystemConfigurationKeyValue('FALSECHARGEADJUSTMENTCODE')
       WHERE    ISNUMERIC(dbo.ssf_GetSystemConfigurationKeyValue('FALSECHARGEADJUSTMENTCODE')) = 1

       SELECT   @DoNotPostWithoutPayment = ISNULL(RIGHT(dbo.ssf_GetSystemConfigurationKeyValue('ELECTRONICREMITTANCEDONOTPOSTWITHOUTPAYMENT'),
                                                        1), 'N')

       
       IF @VerboseMode = 'Y'
          AND @FalseChargeAdjustmentCode IS NULL 
          RAISERROR('Verbose Mode requires a FALSECHARGEADJUSTMENTCODE to be set.',16,1) 

       DECLARE @PayerId INT

       SELECT   @PayerId = ebp.PayerId
       FROM     ERFiles ef
                JOIN dbo.ERBatches eb
                    ON ef.ERFileId = eb.ERFileId
                JOIN dbo.ERBatchPayments ebp
                    ON eb.ERBatchId = ebp.ERBatchId
       WHERE    eb.ERBatchId = @ERBatchId
                AND ebp.PaymentId = @PaymentId


       SET @UserCode = 'ERFILE'    
       SET @CurrentDate = GETDATE()
      
	   --TODO Fix Backout Adjustments logic later. (probably when we find a use case for it.)
	   -- Some customers might actually find this useful because they will never receive an electronic reversal.
	   -- but they may receive more than one EOB.  In those cases we will need to take preferences from the customer.
	   -- There's 4 options:
			-- Backout just adjustments and transfers and apply new EOB
			-- Backout payments, Adjustments and Transfers and apply new EOB
			-- Skip the ERClaim and mark as error "EOB already posted for this charge"
			-- Post the Duplicate EOB and hope there's a reversal EOB for the first one.
		-- In general only 1 EOB should be posted to a charge. Otherwise the 837 will be incorrect for other insured. (Will not balance)
          SET @BackOutAdjustments = 'Y'

       SET @ApplyAdjustments = ISNULL((
                                        SELECT  a.ApplyAdjustments
                                        FROM    ERFiles a
                                                JOIN ERBatches b
                                                    ON a.ERFileId = b.ERFileId
                                        WHERE   b.ERBatchId = @ERBatchId
                                                AND ISNULL(a.RecordDeleted, 'N') = 'N'
                                                AND ISNULL(b.RecordDeleted, 'N') = 'N'
                                      ), 'N')      
              
       SET @ApplyTransfers = ISNULL((
                                      SELECT    a.ApplyTransfers
                                      FROM      ERFiles a
                                                JOIN ERBatches b
                                                    ON a.ERFileId = b.ERFileId
                                      WHERE     b.ERBatchId = @ERBatchId
                                                AND ISNULL(a.RecordDeleted, 'N') = 'N'
                                                AND ISNULL(b.RecordDeleted, 'N') = 'N'
                                    ), 'N')      

       DECLARE @DefaultCopaymentAdjustmentCode INT 

       SELECT   @DefaultCopaymentAdjustmentCode = gc.GlobalCodeId
       FROM     GlobalCodes gc
       WHERE    gc.Category = 'ADJUSTMENTCODE'
                AND gc.ExternalCode1 = '3'
                AND gc.ExternalCode2 = 'PR'
                AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'
                AND gc.Active = 'Y'

       SELECT   @DefaultCopaymentAdjustmentCode = gc.GlobalCodeId
       FROM     GlobalCodes gc
       WHERE    gc.Category = 'ADJUSTMENTCODE'
                AND gc.ExternalCode1 = '3'
                AND gc.ExternalCode2 = 'PR'
                AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'
                AND @DefaultCopaymentAdjustmentCode IS NULL


-- For the amount owed at the ClaimLine Level, Sum(Charges) group by Claimline
       CREATE TABLE #LineItemBalance
              (
               ERClaimLineItemId INT
              ,ClaimLineItemId INT NOT NULL
              ,BalanceAmount DECIMAL(10, 2) NULL
              )      

-- For the amount owed at the ClaimLine Level, Sum(Charges) group by Claimline
       CREATE TABLE #LineItemOriginalCharge
              (
               ERClaimLineItemId INT
              ,ClaimLineItemId INT NOT NULL
              ,RevenueAmount DECIMAL(10, 2) NULL
              )      


-- PaidAmount = The amount of the check being payed to this claimline
       CREATE TABLE #LineItemPaid
              (
               ERClaimLineItemId INT
              ,ClaimLineItemId INT NOT NULL
              ,PaidAmount DECIMAL(10, 2) NOT NULL
              )      
        

-- Adjustment Codes are universal      
       CREATE TABLE #LineItemAdjustment
              (
               ERClaimLineItemId INT
              ,ClaimLineItemId INT NOT NULL
              ,AdjustmentAmount DECIMAL(10, 2) NOT NULL
              ,AdjustmentGroupCode VARCHAR(25)
              ,AdjustmentReasonCode VARCHAR(25)
              ,AdjustmentGlobalcode INTEGER
              ,ProcessingAction INT
              )      
        
       
       CREATE TABLE #LineItemChargeAmount
              (
               ERClaimLineItemId INT
              ,ClaimLineItemId INT NOT NULL
              ,PayerClaimNumber VARCHAR(30) NULL
              ,ChargeId CHAR(10) NOT NULL
              ,BalanceAmount DECIMAL(10, 2) NOT NULL
              ,Payment DECIMAL(10, 2) NULL
              ,Transfer DECIMAL(10, 2) NULL
              ,Adjustment DECIMAL(10, 2) NULL
              ,PaymentId INT NULL
              ,StandardChargeId CHAR(10) NULL
              ,OriginalPaymentId INT NULL
              ,AdjustmentGlobalCode CHAR(10) NULL
              ,ClaimsOnThisLine INTEGER NULL
              ,EOBCharge DECIMAL(10, 2) NULL
              ,NextBillablePayer INT NULL
              ,BackOutAdjustments CHAR(1) NULL -- y/n
              ,IsNotPrimary BIT NULL
              )   
              
       CREATE TABLE #ReverseTransfers
              (
               rtid INT IDENTITY -- going to use this to remove duplicates.
              ,ERClaimLineItemId INT
              ,ClaimLineItemId INT
              ,EOBChargeId INT
              ,ChargeId INT
              ,Amount DECIMAL(10, 2)
              ,ReverseAdjustmentCode INT
              )


		-- Calculate the paid amount on each ER Claim
       INSERT   INTO #LineItemPaid
                ( 
                 ERClaimLineItemId
                ,ClaimLineItemId
                ,PaidAmount
            
                )
                SELECT  ecl.ERClaimLineItemId
                       ,ECL.ClaimLineItemId
                       ,ISNULL(SUM(ECL.PaidAmount), 0.0)
                FROM    ERClaimLineItems ECL
                        JOIN ERBatchPayments ERBP
                            ON ( ECL.ERBatchPaymentId = ERBP.ERBatchPaymentid )
                WHERE   ECL.ERBatchId = @ERBatchId
                        AND ERBP.PaymentId = @PaymentId
                        AND ECL.ClaimLineItemId IS NOT NULL
                        AND ISNULL(ECL.Processed, 'N') = 'N'
                        AND ISNULL(ECL.RecordDeleted, 'N') = 'N'
                        AND ISNULL(ERBP.RecordDeleted, 'N') = 'N'
                GROUP BY ECL.ClaimLineItemId
                       ,ecl.ERClaimLineItemId    


   
    --Gather the adjustments at the ER Claim level
       INSERT   INTO #LineItemAdjustment
                ( 
                 ERClaimLineItemId
                ,ClaimLineItemId
                ,AdjustmentAmount
                ,AdjustmentGroupCode
                ,AdjustmentReasonCode
            
                )
                SELECT  ECLI.ERClaimLineItemId
                       ,ECLI.ClaimLineItemId
                       ,SUM(ISNULL(ECLIA.AdjustmentAmount, 0))
                       ,ECLIA.AdjustmentGroupCode
                       ,ECLIA.AdjustmentReason
                FROM    ERClaimLineItemAdjustments ECLIA
                        JOIN ERClaimLineItems ECLI
                            ON ECLIA.ERClaimLineItemId = ECLI.ERClaimLineItemId
                        JOIN ERBatchPayments ERBP
                            ON ( ECLI.ERBatchPaymentId = ERBP.ERBatchPaymentid )
                               AND ERBP.ERBatchId = @ERBatchId
                WHERE   ERBP.PaymentId = @PaymentId
                        AND ECLI.ClaimLineItemId IS NOT NULL
                        AND ISNULL(ECLI.Processed, 'N') = 'N'
                        AND ISNULL(ECLI.RecordDeleted, 'N') = 'N'
                        AND ISNULL(ECLIA.RecordDeleted, 'N') = 'N'
                        AND ISNULL(ERBP.RecordDeleted, 'N') = 'N'
                GROUP BY ECLI.ClaimLineItemId
                       ,ECLIA.AdjustmentGroupCode
                       ,ECLIA.AdjustmentReason
                       ,ecli.ERClaimLineItemId    
          

-- Map AdjusmtentGroupCode and AdjustmentReasonCode to GlobalCode
          
       UPDATE   LIA
       SET      AdjustmentGlobalcode = GC.GlobalCodeId
       FROM     #LineItemAdjustment LIA
                JOIN Globalcodes GC
                    ON GC.ExternalCode2 = LIA.AdjustmentGroupCode
                       AND GC.ExternalCode1 = LIA.AdjustmentReasonCode
                       AND GC.Category LIKE 'ADJUSTMENTCODE'
       WHERE    ISNULL(GC.Active, 'Y') <> 'N'
                AND ISNULL(GC.RecordDeleted, 'N') = 'N'
                                  
   
-- map the adjustment code to the action
-- Templates not implemented yet.
       UPDATE   lia
       SET      ProcessingAction = EPTR.AdjustmentActionId
       FROM     #LineItemAdjustment lia
                JOIN ERProcessingTemplateRules EPTR
                    ON eptr.AdjustmentCodeId = AdjustmentGlobalcode
                       AND ISNULL(EPTR.RecordDeleted, 'N') = 'N'
                JOIN ERProcessingTemplates EPT
                    ON EPTR.ERProcessingTemplateId = EPT.ERProcessingTemplateId
--#############################################################################
-- Hard Code Removal of CP.ERProcessingTemplateId for Thresholds
--############################################################################# 
       WHERE    ISNULL(EPT.RecordDeleted, 'N') = 'N'
                AND ept.ERProcessingTemplateId = 1
  
   
       
-- Calculate the Client Coverage Plan (Charge) the 835 transaction needs to be posted against.
-- Also gather that Client Coverage Plan's current balance for use later.   
       INSERT   INTO #LineItemChargeAmount
                ( 
                 ERClaimLineItemId
                ,ClaimLineItemId
                ,PayerClaimNumber
                ,ChargeId
                ,PaymentId
                ,BalanceAmount
                ,EOBCharge
                ,BackOutAdjustments
                ,IsNotPrimary
                )
                SELECT  ecli.ERClaimLineItemId
                       ,ECLI.ClaimLineItemId
                       ,ECLI.PayerClaimNumber
                       ,al.ChargeId
                       ,erbp.PaymentId
                       ,SUM(Al.Amount)
                       ,ecli.ChargeAmount
                       ,'N'
                       ,CASE WHEN NOT EXISTS ( SELECT   1
                                               FROM     Charges lowerp
                                               WHERE    lowerp.ServiceId = cnext.ServiceId
                                                        AND ISNULL(lowerp.RecordDeleted, 'N') <> 'Y'
                                                        AND lowerp.[Priority] < cnext.[Priority]
                                                        AND lowerp.[Priority] <> 0 ) THEN 0
                             ELSE 1
                        END
                FROM    ERClaimLineItems ECLI
                        LEFT JOIN dbo.CustomERClaimLineCustomFields ceclcf
                            ON ECLI.ERClaimLineItemId = ceclcf.ERClaimLineItemId
                        JOIN ERBatchPayments erbp
                            ON ( ECLI.ERBatchPaymentId = erbp.ERBatchPaymentid )
                        JOIN ClaimLineItemCharges CLIC
                            ON ( ECLI.ClaimLineItemId = CLIC.ClaimLineItemId )
                        JOIN Charges Ch
                            ON ( CLIC.ChargeId = Ch.ChargeId )
                -- we need to pull the next priority charge if the payment is cross over.
                -- so looking at all of the existing charges for the service 
                -- (If no charge exists we're going to error)
                        JOIN dbo.Charges cnext
                            ON cnext.ServiceId = ch.ServiceId
                               AND cnext.[Priority] >= Ch.[Priority]
                               AND ISNULL(cnext.RecordDeleted, 'N') <> 'Y'
                        JOIN ARLedger AL
                            ON ( AL.ChargeId = cnext.ChargeId )
                        JOIN dbo.ClientCoveragePlans ccp
                            ON cnext.ClientCoveragePlanId = ccp.ClientCoveragePlanId
								--and ISNULL(ccp.RecordDeleted,'N') <> 'Y'
                        JOIN dbo.CoveragePlans cp
                            ON ccp.CoveragePlanId = cp.CoveragePlanId
                               AND cp.PayerId = @PayerId
								--and ISNULL(cp.RecordDeleted,'N') <> 'Y'
                       -- either the coverage plan is mapped and the class of contract code matches
                               AND ( EXISTS ( SELECT    1
                                              FROM      dbo.CustomPayerClassOfContractCoveragePlans contr
                                              WHERE     ISNULL(contr.ClassOfContractCode, '') = ISNULL(ceclcf.ClassOfContractCode,
                                                                                                       '')
                                                        AND contr.PayerId = @PayerId
                                                        AND contr.CoveragePlanId = cp.CoveragePlanId
                                                        AND ISNULL(contr.RecordDeleted, 'N') <> 'Y'
                                                        AND DATEDIFF(DAY, contr.StartDate, GETDATE()) >= 0
                                                        AND ( contr.EndDate IS NULL
                                                              OR DATEDIFF(DAY, GETDATE(), contr.EndDate) >= 0
                                                            ) )
                           -- or the class of contract isn't mapped for the payer.
                                     OR NOT EXISTS ( SELECT 1
                                                     FROM   dbo.CustomPayerClassOfContractCoveragePlans contr2
                                                     WHERE  ISNULL(contr2.ClassOfContractCode, '') = ISNULL(ceclcf.ClassOfContractCode,
                                                                                                        '')
                                                            AND contr2.PayerId = @PayerId
                                                    --AND contr2.CoveragePlanId = cp.CoveragePlanId
                                                            AND ISNULL(contr2.RecordDeleted, 'N') <> 'Y'
                                                            AND DATEDIFF(DAY, contr2.StartDate, GETDATE()) >= 0
                                                            AND ( contr2.EndDate IS NULL
                                                                  OR DATEDIFF(DAY, GETDATE(), contr2.EndDate) >= 0
                                                                ) )
                                   )
                WHERE   ECLI.ERBatchId = @ERBatchId
                        AND erbp.PaymentId = @PaymentId    
                        AND ECLI.ClaimLineItemId IS NOT NULL
                        AND ISNULL(ECLI.Processed, 'N') = 'N'
                        AND ISNULL(ECLI.RecordDeleted, 'N') = 'N'
                        AND ISNULL(ERBP.RecordDeleted, 'N') = 'N'
                        AND ISNULL(AL.RecordDeleted, 'N') = 'N'
                        AND ISNULL(Ch.RecordDeleted, 'N') = 'N'
                        AND ISNULL(CLIC.RecordDeleted, 'N') = 'N'
                -- and there isn't a higher priority charge that meets the conditions
                        AND NOT EXISTS ( SELECT 1
                                         FROM   dbo.Charges cnext2
												-- this also removes client charges from consideration
                                                JOIN dbo.ClientCoveragePlans ccpnext2
                                                    ON cnext2.ClientCoveragePlanId = ccpnext2.ClientCoveragePlanId
                                                       --AND ISNULL(ccpnext2.RecordDeleted, 'N') <> 'Y'
                                                JOIN dbo.CoveragePlans cpnext2
                                                    ON ccpnext2.CoveragePlanId = cpnext2.CoveragePlanId
                                                       --AND ISNULL(cpnext2.RecordDeleted, 'N') <> 'Y'
                                                       AND cpnext2.PayerId = @PayerId
                                            -- either the coverage plan is mapped and the class of contract code matches
                                                       AND ( EXISTS ( SELECT    1
                                                                      FROM      dbo.CustomPayerClassOfContractCoveragePlans contr3
                                                                      WHERE     ISNULL(contr3.ClassOfContractCode, '') = ISNULL(ceclcf.ClassOfContractCode,
                                                                                                        '')
                                                                                AND contr3.PayerId = @PayerId
                                                                                AND contr3.CoveragePlanId = cpnext2.CoveragePlanId
                                                                                AND ISNULL(contr3.RecordDeleted, 'N') <> 'Y'
                                                                                AND DATEDIFF(DAY, contr3.StartDate,
                                                                                             GETDATE()) >= 0
                                                                                AND ( contr3.EndDate IS NULL
                                                                                      OR DATEDIFF(DAY, GETDATE(),
                                                                                                  contr3.EndDate) >= 0
                                                                                    ) )
                                                     -- or the class of contract code isn't configured.
                                                             OR NOT EXISTS ( SELECT 1
                                                                             FROM   dbo.CustomPayerClassOfContractCoveragePlans contr4
                                                                             WHERE  ISNULL(contr4.ClassOfContractCode,
                                                                                           '') = ISNULL(ceclcf.ClassOfContractCode,
                                                                                                        '')
                                                                                    AND contr4.PayerId = @PayerId
                                                                            --AND contr4.CoveragePlanId = cpnext2.CoveragePlanId
                                                                                    AND ISNULL(contr4.RecordDeleted, 'N') <> 'Y'
                                                                                    AND DATEDIFF(DAY, contr4.StartDate,
                                                                                                 GETDATE()) >= 0
                                                                                    AND ( contr4.EndDate IS NULL
                                                                                          OR DATEDIFF(DAY, GETDATE(),
                                                                                                      contr4.EndDate) >= 0
                                                                                        ) )
                                                           )
                                         WHERE  ISNULL(cnext2.RecordDeleted, 'N') <> 'Y'
                                                AND cnext2.ServiceId = ch.ServiceId
												-- priority is lower or equal to billed charge
                                                AND cnext2.[Priority] >= ch.[Priority]
												-- priority is higher than what we're looking at right now.
                                                AND ( cnext2.[Priority] < cnext.[Priority]
													  -- or the priority is the same and chargeid is lower. (Shouldn't happen?)
                                                      OR ( cnext2.[Priority] = cnext.[Priority]
                                                           AND cnext.[ChargeId] > cnext2.ChargeId
                                                         )
                                                    ) )
                GROUP BY ECLI.ClaimLineItemId
                       ,ecli.ERClaimLineItemId
                       ,ecli.ChargeAmount
                       ,ECLI.PayerClaimNumber
                       ,AL.ChargeId
                       ,erbp.PaymentId
                       ,ch.ChargeId
                       ,cnext.ServiceId
                       ,cnext.[Priority]

         -- clean up and reapply.

       DELETE   Ceclic
       FROM     --dbo.CustomERClaimLineItemCharges ceclic
				ERClaimLineItemCharges ceclic
                JOIN #LineItemChargeAmount lica
                    ON ceclic.ERClaimLineItemId = lica.ERClaimLineItemId

       INSERT   INTO ERClaimLineItemCharges -- dbo.CustomERClaimLineItemCharges
                ( 
                 CreatedBy
                ,CreatedDate
                ,ModifiedBy
                ,ModifiedDate
                ,ERClaimLineItemId
                ,ChargeId
                 
                )
                SELECT  @UserCode -- CreatedBy - type_CurrentUser
                       ,GETDATE()-- CreatedDate - type_CurrentDatetime
                       ,@UserCode-- ModifiedBy - type_CurrentUser
                       ,GETDATE()-- ModifiedDate - type_CurrentDatetime
                       ,lica.ERClaimLineItemId-- ERClaimLineItemId - int
                       ,lica.ChargeId-- ChargeId - int
                FROM    #LineItemChargeAmount lica

  
  -- get all of the next billable payers
       DECLARE cur_NextBillablePayer INSENSITIVE CURSOR
       FOR
               SELECT DISTINCT
                        s.ClientId
                       ,s.ServiceId
                       ,s.DateOfService
                       ,s.ProcedureCodeId
                       ,s.ClinicianId
                       ,c.ClientCoveragePlanId
                       ,lica.ChargeId
               FROM     #LineItemChargeAmount lica
                        JOIN dbo.Charges c
                            ON c.ChargeId = lica.ChargeId
                        JOIN Services s
                            ON s.ServiceId = c.ServiceId
               --WHERE    EXISTS ( SELECT 1
               --                  FROM   #LineItemAdjustment lia
               --                  WHERE  ProcessingAction = 2
               --                         AND lia.ClaimLineItemId = lica.ClaimLineItemId )
                     

       OPEN cur_NextBillablePayer

       FETCH NEXT FROM cur_NextBillablePayer INTO @ClientId, @ServiceId, @DateOfService, @ProcedureCodeId, @ClinicianId,
             @ClientCoveragePlanId, @ChargeId

       WHILE @@Fetch_Status = 0 
             BEGIN

                   SET @TransferTo = NULL
                   EXEC ssp_PMGetNextBillablePayer @ClientId = @ClientId, @ServiceId = @ServiceId,
                    @DateOfService = @DateOfService, @ProcedureCodeId = @ProcedureCodeId, @ClinicianId = @ClinicianId,
                    @ClientCoveragePlanId = @ClientCoveragePlanId, @NextClientCoveragePlanId = @TransferTo OUTPUT     

                   UPDATE   #LineItemChargeAmount
                   SET      NextBillablePayer = @TransferTo
                   WHERE    ChargeId = @ChargeId

                   FETCH NEXT FROM cur_NextBillablePayer INTO @ClientId, @ServiceId, @DateOfService, @ProcedureCodeId,
                         @ClinicianId, @ClientCoveragePlanId, @ChargeId
             END

       CLOSE cur_NextBillablePayer
       DEALLOCATE cur_NextBillablePayer
       

-- We'll need the claims per claimline on the off chance the ClaimLine Balance is 0. 
-- If there is no Claimline Balance to use in weighting we'll divide the payment across 
-- the charges equally
       UPDATE   LC
       SET      ClaimsOnThisLine = LineCount.Tally
       FROM     #LineItemChargeAmount LC
                JOIN (
                       SELECT   ERClaimLineItemId
                               ,COUNT(DISTINCT LICA.ChargeId) AS Tally
                       FROM     #LineItemChargeAmount LICA
                       GROUP BY LICA.ERClaimLineItemId
                     ) LineCount
                    ON LC.ERClaimLineItemId = LineCount.ERClaimLineItemId
      
-- The ClaimLineItemCharges isn't reliable in this case anymore since these could be cross overs.
      -- get the current revenue for each charge
       INSERT   INTO #LineItemOriginalCharge
                ( 
                 ERClaimLineItemId
                ,ClaimLineItemId
                ,RevenueAmount 
            
                )
                SELECT  lica.ERClaimLineItemId
                       ,lica.claimlineitemid
                       ,SUM(al.amount)
                FROM    #LineItemPaid LIP
                        JOIN #LineItemChargeAmount lica
                            ON lica.ClaimLineItemId = LIP.ClaimLineItemId
                        JOIN ARLedger AL
                            ON lica.ChargeId = AL.ChargeId
                WHERE   AL.LedgerType IN ( 4201, 4204 )
                        AND ISNULL(al.RecordDeleted, 'N') = 'N'
                GROUP BY lica.ClaimLineItemId
                       ,lica.ERClaimLineItemId   
            
		-- TODO this is wrong because if the charge was billed as a part of a bundle, the ChargeAmount will never equal the RevenueAmount for the charge
		-- If the charge is secondary it will never be true because the revenue never matches what is billed.
		-- I'm going to say this should not be executed for now and move on. 
       IF @BackOutAdjustments = 'y' 
          BEGIN
                UPDATE  LICA
                SET     BackOutAdjustments = 'Y'
                FROM    #LineItemChargeAmount LICA
                        JOIN #LineItemOriginalCharge LIOC
                            ON LICA.ERClaimLineItemId = LIOC.ERClaimLineItemId
                        JOIN ERClaimLineItems ECLI
                            ON ECLI.ERClaimLineItemId = LIOC.ERClaimLineItemId
                WHERE   LIOC.RevenueAmount = ECLI.ChargeAmount
                        AND ISNULL(ECLI.RecordDeleted, 'N') = 'N'

-- Remove Adjustments from the charge if they are to be backed out.
                UPDATE  LICA
                SET     BalanceAmount = BalanceAmount - Adjustments.Adjustments
                FROM    #LineItemChargeAmount LICA
                        JOIN (
                               SELECT   al.chargeid
                                       ,SUM(Al.amount) AS Adjustments
                               FROM     ARLedger AL
                               WHERE    AL.LedgerType = 4203
                                        AND ISNULL(AL.MarkedAsError, 'N') = 'N'
                                        AND ISNULL(AL.ErrorCorrection, 'N') = 'N'
                               GROUP BY al.chargeID
                             ) Adjustments
                            ON Adjustments.chargeid = LICA.ChargeID
                               AND LICA.BackOutAdjustments = 'Y'
          END     
-- Compute the expected Payments for each claimline (one level above the Charges)     
       INSERT   INTO #LineItemBalance
                ( 
                 ERClaimLineItemId
                ,ClaimLineItemid
                ,BalanceAmount
                )
                SELECT  ChargeOwed.ERClaimLineItemId
                       ,ChargeOwed.ClaimLineItemId
                       ,SUM(ISNULL(ChargeOwed.BalanceAmount, 0.0))
                FROM    #LineItemChargeAmount ChargeOwed
                GROUP BY ChargeOwed.ERClaimLineItemId
                       ,ChargeOwed.ClaimLineItemId 
                 --,ChargeOwed.IsNotPrimary
     
       UPDATE   #LineItemBalance
       SET      BalanceAmount = NULL  -- so we can use isnull if the line is paid off for a given erclaim
       WHERE    BalanceAmount <= 0    -- simple average instead of a weighted average
    
    
--  ************************** Initialize Variables *******************************
--  *******************************************************************************    
--  A Financial Activity may have Many Financial Activity Lines  
       SELECT   @FinancialActivityId = FinancialActivityId
               ,@DateReceived = CAST(DateReceived AS DATE)
       FROM     Payments
       WHERE    PaymentId = @PaymentId
 
   
       SELECT TOP 1
                @CurrentAccountingPeriodId = AccountingPeriodId
       FROM     AccountingPeriods
       WHERE    DATEADD(dd, 1, EndDate) > @DateReceived
                AND OpenPeriod = 'Y'
                AND ISNULL(RecordDeleted, 'N') = 'N'
       ORDER BY StartDate        
    
    
       SELECT TOP 1
                @PaymentAccountingPeriodId = AccountingPeriodId
       FROM     AccountingPeriods
       WHERE    CAST(StartDate AS DATE) <= @DateReceived
                AND CAST(EndDate AS DATE) >= DATEADD(dd, 1, @DateReceived)
                AND ISNULL(RecordDeleted, 'N') = 'N'    
      
       SELECT   @OpenPeriod = ISNULL(OpenPeriod, 'N')
       FROM     AccountingPeriods
       WHERE    AccountingPeriodID = @PaymentAccountingPeriodId    
      
       IF @OpenPeriod = 'Y' 
          SET @CurrentAccountingPeriodId = @PaymentAccountingPeriodId    
    
      
      
       IF @@error <> 0 
          GOTO error      
/* Check to ensure all coverage plans have Adjustment Rules set up */
       SET @ErrorMessage = NULL


       IF @ErrorMessage IS NOT NULL 
          GOTO error 
       BEGIN TRANSACTION  --  Capture Claimline Errors
    
    /* ************** Errors at the claimline level  ******************/
		--GlobalCodeId	CodeName	Active	Category
		--5231			Information	Y		ERMESSAGETYPE       
		--5232			Warning		Y		ERMESSAGETYPE       
		--5233			Error		Y		ERMESSAGETYPE  
            
       INSERT   INTO ERClaimLineItemLog
                ( 
                 ERClaimLineItemId
                ,ErrorFlag
                ,ERMessageType
                ,ERMessage
            
                )
          -- For cross overs, the total paid amount is always going to be greater than the expected Payment unless we've received the primary claim already.
          -- so we need to except those cases.
          --SELECT  ERClaimLineItemId
          --       ,'Y'
          --       ,5233
          --       ,'Total Paid amount is greater than expected Payment'
          --FROM    ERClaimLineItems ECLI
          --        JOIN ERBatchPayments ERBP ON (ECLI.ERBatchPaymentId = ERBP.ERBatchPaymentid)
          --        JOIN #LineItemBalance Owed ON (ECLI.ClaimLineItemId = Owed.ClaimLineItemId)
          --        JOIN #LineItemPaid Paid ON (Owed.ClaimLineItemId = Paid.ClaimLineItemId)
          --WHERE   ECLI.ERBatchId = @ERBatchId
          --        AND ERBP.PaymentId = @PaymentId
          --        AND Paid.PaidAmount > Owed.BalanceAmount
          --        AND Paid.PaidAmount > 0
          --        -- only if the claim wasn't crossed over.
          --        AND owed.IsNotPrimary = 0 
          --UNION ALL
                SELECT  ecli.ERClaimLineItemId
                       ,'Y'
                       ,5233
                       ,'Both Paid amount and Adjustment amount are 0'
                FROM    ERClaimLineItems ECLI
                        JOIN ERBatchPayments ERBP
                            ON ( ECLI.ERBatchPaymentId = ERBP.ERBatchPaymentid )
                        LEFT JOIN #LineItemPaid Paid
                            ON ( ECLI.ERClaimLineItemId = Paid.ERClaimLineItemId )
                        LEFT JOIN #LineItemAdjustment LIA
                            ON LIA.ERClaimLineItemId = ECLI.ERClaimLineItemId
                WHERE   ECLI.ERBatchId = @ERBatchId
                        AND ERBP.PaymentId = @PaymentId
                        AND ISNULL(LIA.AdjustmentAmount, 0) = 0
                        AND ISNULL(Paid.PaidAmount, 0) = 0
                UNION ALL
                SELECT  ecli.ERClaimLineItemId
                       ,'Y'
                       ,5233
                       ,'Adjustment is on a Claimline Without a Payment'
                FROM    ERClaimLineItems ECLI
                        JOIN ERBatchPayments ERBP
                            ON ( ECLI.ERBatchPaymentId = ERBP.ERBatchPaymentid )
                        LEFT JOIN #LineItemPaid Paid
                            ON ( ECLI.ERClaimLineItemId = Paid.ERClaimLineItemId )
                        LEFT JOIN #LineItemAdjustment LIA
                            ON LIA.ERClaimLineItemId = ECLI.ERClaimLineItemId
                WHERE   ECLI.ERBatchId = @ERBatchId
                        AND ERBP.PaymentId = @PaymentId
                        AND ISNULL(LIA.AdjustmentAmount, 0) <> 0
                        AND ISNULL(Paid.PaidAmount, 0) = 0
                        AND LIA.AdjustmentGlobalcode IS NOT NULL
                        AND @DoNotAllowAdjustmentsWithoutAPaymentOnTheSameClaimLine = 'Y'
         --Dknewtson - duplicate.  below validation is more accurate
          --UNION ALL
          --SELECT  ERClaimLineItemId
          --       ,'Y'
          --       ,5233  -- Does this need to change?  Currently set to raise error elsewhere
          --       ,'Unknown Adjustment Code: ' + ISNULL(LIA.AdjustmentGroupCode, '??') + ' : ' + ISNULL(LIA.AdjustmentReasonCode, '??')
          --FROM    ERClaimLineItems ECLI
          --        JOIN #LineItemAdjustment LIA ON LIA.ClaimLineItemId = ECLI.ClaimLineItemId
          --WHERE   ECLI.ERBatchId = @ERBatchId
          --        AND LIA.AdjustmentGlobalcode IS NULL
                UNION ALL
                SELECT  ecli.ERClaimLineItemId
                       ,'Y'
                       ,5233  -- error
                       ,'Adjustment Code is Flagged for Reporting: ' + ISNULL(LIA.AdjustmentGroupCode, '??') + ' : '
                        + ISNULL(LIA.AdjustmentReasonCode, '??')
                FROM    ERClaimLineItems ECLI
                        JOIN ERBatchPayments ERBP
                            ON ( ECLI.ERBatchPaymentId = ERBP.ERBatchPaymentid )
                        JOIN #LineItemAdjustment LIA
                            ON LIA.ERClaimLineItemId = ECLI.ERClaimLineItemId
                WHERE   ECLI.ERBatchId = @ERBatchId
                        AND ERBP.PaymentId = @PaymentId
                        AND lia.ProcessingAction = 4 -- Flagged For Reporting
                UNION ALL
                SELECT  ecli.ERClaimLineItemId
                       ,'Y'
                       ,5233
                       ,'Adjustment code has no processing action: ' + ISNULL(LIA.AdjustmentGroupCode, '??') + ' : '
                        + ISNULL(LIA.AdjustmentReasonCode, '??')
                FROM    ERClaimLineItems ECLI
                        JOIN ERBatchPayments ERBP
                            ON ( ECLI.ERBatchPaymentId = ERBP.ERBatchPaymentid )
                        JOIN #LineItemAdjustment LIA
                            ON LIA.ERClaimLineItemId = ECLI.ERClaimLineItemId
                WHERE   ECLI.ERBatchId = @ERBatchId
                        AND ERBP.PaymentId = @PaymentId
                        AND lia.ProcessingAction IS NULL -- Flagged For Reporting               
                UNION ALL
                SELECT  ecli.ERClaimLineItemId
                       ,'Y'
                       ,5233
                       ,'There are Adjustment Codes not mapped in GlobalCodes: ' + lia.AdjustmentGroupCode + '-'
                        + lia.AdjustmentReasonCode RC
                FROM    #LineItemAdjustment LIA
                        JOIN ERClaimLineItems ecli
                            ON ecli.ERClaimLineItemId = lia.ERClaimLineItemId
                        JOIN ERBatchPayments ERBP
                            ON ecli.ERBatchPaymentId = erbp.ERBatchPaymentId
                WHERE   lia.AdjustmentGlobalcode IS NULL
                        AND ECLI.ERBatchId = @ERBatchId
                        AND ERBP.PaymentId = @PaymentId
                UNION ALL
                SELECT  ecli.ERClaimLineItemId
                       ,'Y'
                       ,5233
                       ,'Unable to identify charge for claim line item. Check Client Coverage for Payer ' + p.PayerName
                FROM    dbo.ERClaimLineItems ecli
                        JOIN dbo.ERBatchPayments ebp
                            ON ecli.ERBatchPaymentId = ebp.ERBatchPaymentId
                               AND ecli.ERBatchId = @ERBatchId
                               AND ebp.PaymentId = @PaymentId
                        JOIN dbo.Payers p
                            ON p.PayerId = @PayerId
                WHERE   ecli.ClaimLineItemId IS NOT NULL
                        AND ISNULL(ecli.RecordDeleted, 'N') <> 'Y'
                        AND NOT EXISTS ( SELECT 1
                                         FROM   #LineItemChargeAmount lica
                                         WHERE  lica.ClaimLineItemId = ecli.ClaimLineItemId )
                --UNION ALL
                --SELECT  ecli.ERClaimLineItemId
                --       ,'Y'
                --       ,5233
                --       ,'Unable to find payments for reversal.'
                --FROM    dbo.ERClaimLineItems ecli
                --        JOIN dbo.ERBatchPayments ebp
                --            ON ecli.ERBatchPaymentId = ebp.ERBatchPaymentId
                --               AND ecli.ERBatchId = @ERBatchId
                --               AND ebp.PaymentId = @PaymentId
                --        JOIN #LineItemPaid lip
                --            ON lip.ERClaimLineItemId = ecli.ERClaimLineItemId
                --WHERE   lip.PaidAmount < 0.00
                --        AND PaymentIdToReverse IS NULL
                UNION ALL
                SELECT  ecli.ERClaimLineItemId
                       ,'Y'
                       ,5233
                       ,'Paid Amount is Zero.'
                FROM    dbo.ERClaimLineItems ecli
                        JOIN dbo.ERBatchPayments ebp
                            ON ecli.ERBatchPaymentId = ebp.ERBatchPaymentId
                               AND ecli.ERBatchId = @ERBatchId
                               AND ebp.PaymentId = @PaymentId
                WHERE   ecli.PaidAmount = 0.00
                        AND ISNULL(@DoNotPostWithoutPayment,'N') = 'Y'
                                                                                 
	   --flag the charge          
       UPDATE   c
       SET      c.Flagged = 'Y'
       FROM     #LineItemChargeAmount LICA
                JOIN Charges c
                    ON c.ChargeId = lica.ChargeId
       WHERE    EXISTS ( SELECT 1
                         FROM   ERClaimLineItemLog EL
                                JOIN ERClaimLineItems ECLI
                                    ON EL.ERClaimLineItemId = ECLI.ERClaimLineItemId
                                       AND ECLI.ERClaimLineItemId = LICA.ERClaimLineItemId
                                JOIN ERBatchPayments ERBP
                                    ON ( ECLI.ERBatchPaymentId = ERBP.ERBatchPaymentid )
                         WHERE  ECLI.ERBatchId = @ERBatchId
                                AND ERBP.PaymentId = @PaymentId
                                AND el.ErrorFlag = 'Y' )          
        
        -- Deleting based on ERClaimLineItem so we still post even if there's another claim in the file that has an issue.
        -- (at least both paid amount and adjustment amount are 0 errors need to only fail the ERClaimLineItem not the whole ClaimLineItem.
       DELETE   LICA
       FROM     #LineItemChargeAmount LICA
       WHERE    EXISTS ( SELECT 1
                         FROM   ERClaimLineItemLog EL
                                JOIN ERClaimLineItems ECLI
                                    ON EL.ERClaimLineItemId = ECLI.ERClaimLineItemId
                                       AND ECLI.ERClaimLineItemId = LICA.ERClaimLineItemId
                                JOIN ERBatchPayments ERBP
                                    ON ( ECLI.ERBatchPaymentId = ERBP.ERBatchPaymentid )
                         WHERE  ECLI.ERBatchId = @ERBatchId
                                AND ERBP.PaymentId = @PaymentId
                                AND el.ErrorFlag = 'Y' )
    
                    
       IF @@error <> 0 
          GOTO rollback_tran             
------------------------------------------------------          
------------------------------------------------------          
------------------------------------------------------     
-- Need to trap adjustments with no reason codes, not just the unmappables     
------------------------------------------------------          
------------------------------------------------------          
------------------------------------------------------                
                      
       COMMIT  -- Capture Claimline errors


       CREATE TABLE #ImportStaging
              (
               SortOrder INT
              ,[ClaimLineItemId] INTEGER
              ,ERClaimLineItemId INT
              ,[ClaimedAmount] DECIMAL(10, 2)
              ,[PayerClaimNumber] VARCHAR(50)
              ,[PaidAmount] DECIMAL(10, 2)
              ,[BalanceAmount] DECIMAL(10, 2)
              ,[chargeID] CHAR(10)
              ,[ClientId] CHAR(10)
              ,[CoveragePlanId] INTEGER
              ,[ClientCoveragePlanId] INTEGER
              ,[AdjustmentAmount] DECIMAL(10, 2)
              ,ProcessingAction INT
              ,[TransferAmount] DECIMAL(10, 2)
              ,[ReferenceNumber] VARCHAR(30)
              ,[AdjustmentGlobalCode] INTEGER
              ,[AdjustmentGroupCode] VARCHAR(50)-- needed to keep the unmappable adjustments (to globalcodeid) identifiable
              ,[AdjustmentReasonCode] VARCHAR(50)
              ,BackOutAdjustments CHAR(1) -- y/n
              ,IsNotPrimary BIT
              ,NextBillablePayer INT
              )
   
    /******************************************
    Spread the paid amount or the Adjustment amount over all claims on the claimline based on 
    The proportion Owed, or evenly if there is already a credit or zero balance.
    *******************************************/
       INSERT   INTO #ImportStaging
                ( 
                 SortOrder
                ,ERClaimLineItemId
                ,ClaimLineItemId
                ,ClaimedAmount
                ,PayerClaimNumber
                ,PaidAmount
                ,BalanceAmount
                ,chargeID
                ,ClientId
                ,CoveragePlanId
                ,ClientCoveragePlanId
                ,AdjustmentAmount
                ,ProcessingAction
                ,TransferAmount
                ,ReferenceNumber
                ,AdjustmentGlobalCode
                ,AdjustmentGroupCode
                ,AdjustmentReasonCode
                ,BackOutAdjustments
                ,IsNotPrimary
                ,NextBillablePayer
                
                )
               -- payments (this also includes reversals which should just be posted right away)
                SELECT  2
                       ,lica.ERClaimLineItemId
                       ,LICA.ClaimLineItemId
                       ,cli.ChargeAmount
                       ,LICA.PayerClaimNumber
                   /******************************************
                   Spread the paid amount or the Adjustment amount over all claims on the claimline based on 
                   The proportion Owed, or evenly if there is already a credit or zero balance.
                   *******************************************/
                       ,LIP.PaidAmount * ISNULL(( CAST(s.Charge AS DECIMAL(10,2)) / CAST(cli.ChargeAmount AS DECIMAL(10,2)) ),
                                                ( 1 / CAST(LICA.ClaimsOnThisLine AS DECIMAL(10, 2)) )) AS PaidAmount
                       ,LICA.BalanceAmount
                       ,LICA.chargeID
                       ,S.ClientId
                       ,CCP.CoveragePlanId
                       ,CCP.ClientCoveragePlanId
                       ,0 AS AdjustmentAmount
                       ,NULL -- Processing Action
                       ,0 AS TransferAmount
                       ,P.ReferenceNumber
                       ,-1 AS AdjustmentGlobalCode -- negative one marks a payment
                       ,'??' AS AdjustmentGroupCode
                       ,'??' AS AdjustmentReasonCode
                       ,LICA.BackOutAdjustments
                       ,LICA.IsNotPrimary
                       ,lica.NextBillablePayer -- Next Billable Payer
                FROM    #LineItemChargeAmount LICA
                        JOIN #LineItemBalance LIB
                            ON LIB.ERClaimLineItemId = LICA.ERClaimLineItemId
                        JOIN #LineItemPaid LIP
                            ON LIP.ERClaimLineItemId = LICA.ERClaimLineItemId
                        JOIN Payments P
                            ON ( LICA.PaymentId = P.PaymentId )
                        JOIN Charges C
                            ON ( LICA.ChargeId = C.ChargeId )
                        JOIN Services S
                            ON ( C.ServiceId = S.ServiceId )
                        JOIN ClientCoveragePlans CCP
                            ON CCP.ClientCoveragePlanId = C.ClientCoveragePlanId
                        JOIN dbo.ClaimLineItems cli
                            ON cli.ClaimLineItemId = LICA.ClaimLineItemId
     
				--Adjustments / Transfers 
                UNION ALL
                SELECT  4
                       ,lica.ERClaimLineItemId
                       ,LICA.ClaimLineItemId
                       ,cli.ChargeAmount
                       ,LICA.PayerClaimNumber
                       ,0
                       ,LICA.BalanceAmount
                       ,LICA.chargeID
                       ,S.ClientId
                       ,CCP.CoveragePlanId
                       ,CCP.ClientCoveragePlanId
                       ,LIA.AdjustmentAmount * ISNULL(( CAST(s.Charge AS DECIMAL(10,2)) / CAST(cli.ChargeAmount AS DECIMAL(10,2)) ),
                                                      ( 1 / CAST(LICA.ClaimsOnThisLine AS DECIMAL(10, 2)) ))
                       ,Lia.ProcessingAction
                       ,0
                       ,P.ReferenceNumber
                       ,LIA.AdjustmentGlobalCode AS AdjustmentGlobalCode
                       ,LIA.AdjustmentGroupCode AS AdjustmentGroupCode
                       ,LIA.AdjustmentReasonCode AS AdjustmentReasonCode
                       ,LICA.BackOutAdjustments
                       ,LICA.IsNotPrimary
                       ,lica.NextBillablePayer
                FROM    #LineItemChargeAmount LICA
                        JOIN #LineItemBalance LIB
                            ON LIB.ERClaimLineItemId = LICA.ERClaimLineItemId
                        JOIN #LineItemAdjustment LIA
                            ON LIA.ERClaimLineItemId = LICA.ERClaimLineItemId
                        JOIN Payments P
                            ON ( LICA.PaymentId = P.PaymentId )
                        JOIN Charges C
                            ON ( LICA.ChargeId = C.ChargeId )
                        JOIN Services S
                            ON  C.ServiceId = S.ServiceId 
								AND s.Status <> 76 -- do not post adjustments/transfers on errored services
                        JOIN ClientCoveragePlans CCP
                            ON CCP.ClientCoveragePlanId = C.ClientCoveragePlanId
                        JOIN dbo.ClaimLineItems cli
                            ON cli.ClaimLineItemId = LICA.ClaimLineItemId
				-- for secondary coverage we will need to do something special for transfers.
				WHERE Lica.IsNotPrimary = 0

         -- find transfers that need to be backed out of the ARLedger automatically.
         -- this is hard because we have to take into account transfers that are already happening in the file as well as transfers that have happened in the arledger
         -- and if we have ALREADY reversed a transfer we don't want to reverse it again. (

       CREATE TABLE #Transfers
       (
         NumMatchingTransfers INT
         ,AdjustmentCode INT
         ,Amount DECIMAL(10,2)
         ,ToCharge INT
         ,FromCharge INT
         ,NumReversingTransfers INT       
       )
       
       INSERT   INTO #Transfers
                ( 
                 NumMatchingTransfers
                ,AdjustmentCode
                ,Amount
                ,ToCharge
                ,FromCharge
                )
                SELECT  COUNT(DISTINCT al.ARLedgerId)
                       ,al.AdjustmentCode
                       ,al.Amount
                       ,al.ChargeId AS ToCharge
                       ,al2.ChargeId AS FromCharge
                FROM    #LineItemChargeAmount lica
                        JOIN dbo.Charges c
                            ON c.ChargeId = lica.ChargeId
                        JOIN dbo.ARLedger al
                            ON c.ChargeId = al.ChargeId
                               AND ISNULL(al.RecordDeleted, 'N') <> 'Y'
                               AND al.Amount <> 0
                               AND al.LedgerType = 4204
                        JOIN dbo.FinancialActivityLines fal
                            ON al.FinancialActivityLineId = fal.FinancialActivityLineId
                               AND ISNULL(fal.RecordDeleted, 'N') <> 'Y'
                        JOIN dbo.ARLedger al2
                            ON al2.FinancialActivityLineId = al.FinancialActivityLineId
                               AND ISNULL(al2.RecordDeleted, 'N') <> 'Y'
                               AND al2.Amount = -al.Amount
                               AND al2.LedgerType = 4204
                               AND ISNULL(al2.AdjustmentCode, -1) = ISNULL(al.AdjustmentCode, -1)
                GROUP BY al.AdjustmentCode
                       ,al.Amount
                       ,al.ChargeId
                       ,al2.ChargeId

         -- I immediately regret all these subqueries...

         UPDATE t SET NumReversingTransfers = revcount.num
         FROM   #Transfers t
                CROSS APPLY (
                              SELECT    COUNT(DISTINCT al.ARLedgerId)
                              FROM      dbo.ARLedger al
                                        JOIN dbo.FinancialActivityLines fal
                                            ON al.FinancialActivityLineId = fal.FinancialActivityLineId
                                        JOIN dbo.ARLedger al2
                                            ON al2.FinancialActivityLineId = al.FinancialActivityLineId
                                               AND ISNULL(al2.RecordDeleted, 'N') <> 'Y'
                                               AND al2.Amount = -al.Amount
                                               AND ISNULL(al2.AdjustmentCode, -1) = ISNULL(al.AdjustmentCode, -1)
                                               AND al2.LedgerType = 4204
                              WHERE     al.ChargeId = t.ToCharge
                                        AND al.Amount = -t.Amount
                                        AND ISNULL(al.AdjustmentCode, -1) = ISNULL(t.AdjustmentCode, -1)
                                        AND ISNULL(al.RecordDeleted, 'N') <> 'Y'
                                        AND al.LedgerType = 4204
                                        AND al2.ChargeId = t.FromCharge
                            ) AS revcount (num)

       -- before we decide how to reverse
       -- we need to take into account the transfers that are going to happen as part of the file.
       

       -- reversing transfers (match the reverse transfer amount)
       UPDATE   t
       SET      NumReversingTransfers = ISNULL(NumReversingTransfers, 0) + revcount.num
       FROM     #Transfers t
                CROSS APPLY (
                              SELECT    COUNT(*)
                              FROM      #ImportStaging [is]
                                        JOIN Charges c
                                            ON c.ChargeId = t.FromCharge
                              WHERE     [is].Chargeid = t.ToCharge
                                        AND t.Amount = [is].AdjustmentAmount
                                        AND ISNULL(t.AdjustmentCode, -1) = ISNULL([is].AdjustmentGlobalCode, -1)
                                        AND ( ( [is].ProcessingAction = 2
                                                AND ISNULL(c.ClientCoveragePlanId, -1) = ISNULL([is].NextBillablePayer,
                                                                                                -1)
                                              )
                                              OR ( [is].ProcessingAction = 3
                                                   AND c.ClientCoveragePlanId IS NULL
                                                 )
                                            )
                            ) AS revcount ( num )

       -- matching transfers (matches negative reverse transfer amount)
       UPDATE   t
       SET      NumMatchingTransfers = ISNULL(NumMatchingTransfers, 0) + revcount.num
       FROM     #Transfers t
                CROSS APPLY (
                              SELECT    COUNT(*)
                              FROM      #ImportStaging [is]
                                        JOIN Charges c
                                            ON c.ChargeId = t.FromCharge
                              WHERE     [is].Chargeid = t.ToCharge
                                        AND t.Amount = -[is].AdjustmentAmount
                                        AND ISNULL(t.AdjustmentCode, -1) = ISNULL([is].AdjustmentGlobalCode, -1)
                                        AND ( ( [is].ProcessingAction = 2
                                                AND ISNULL(c.ClientCoveragePlanId, -1) = ISNULL([is].NextBillablePayer,
                                                                                                -1)
                                              )
                                              OR ( [is].ProcessingAction = 3
                                                   AND c.ClientCoveragePlanId IS NULL
                                                 )
                                            )
                            ) AS revcount ( num )
                                 
       INSERT   INTO #ReverseTransfers
                ( 
                 ERClaimLineItemId
                ,ClaimLineItemId
                ,EOBChargeId
                ,ChargeId
                ,Amount
                ,ReverseAdjustmentCode
                )
                SELECT  lica.ERClaimLineItemId
                       ,lica.ClaimLineItemId
                       ,t.ToCharge
                       ,t.FromCharge
                       ,t.Amount * ( ISNULL(NumMatchingTransfers,0) - ISNULL(NumReversingTransfers,0) )
                       ,ISNULL(t.AdjustmentCode, @DefaultCopaymentAdjustmentCode)
                FROM    #Transfers t
                        -- we just need one of these for each charge.
                        CROSS APPLY (
                                      SELECT TOP ( 1 )
                                                ERClaimLineItemId
                                               ,ClaimLineItemId
                                      FROM      #LineItemChargeAmount c
                                      WHERE     c.ChargeId = t.FromCharge
                                    ) lica ( ERClaimLineItemId, ClaimLineItemId )

-- remove duplicates
-- this will also remove duplicates due to multiple instances of the same claim line item in the ER File.
       DELETE   rt
       FROM     #ReverseTransfers rt
       WHERE    EXISTS ( SELECT 1
                         FROM   #ReverseTransfers rt2
                         WHERE  rt2.EOBChargeId = rt.EOBChargeId
                                AND rt2.Amount = rt.Amount
                                AND rt2.ReverseAdjustmentCode = rt.ReverseAdjustmentCode
                                AND rt2.rtid < rt.rtid )

       INSERT   INTO #ImportStaging
                ( 
                 SortOrder
                ,ERClaimLineItemId
                ,ClaimLineItemId
                ,ClaimedAmount
                ,PayerClaimNumber
                ,PaidAmount
                ,BalanceAmount
                ,chargeID
                ,ClientId
                ,CoveragePlanId
                ,ClientCoveragePlanId
                ,AdjustmentAmount
                ,ProcessingAction
                ,TransferAmount
                ,ReferenceNumber
                ,AdjustmentGlobalCode
                ,AdjustmentGroupCode
                ,AdjustmentReasonCode
                ,BackOutAdjustments
                ,IsNotPrimary
                ,NextBillablePayer
                
                )
                SELECT  3
                       ,lica.ERClaimLineItemId
                       ,rt.ClaimLineItemId
                       ,cli.ChargeAmount
                       ,lica.PayerClaimNumber
                       ,0 -- Paid Amount
                       ,lica.BalanceAmount
                       ,rt.EOBChargeId
                       ,s.ClientId
                       ,ccp2.CoveragePlanId
                       ,ccp2.ClientCoveragePlanId
                       ,-rt.Amount
                       ,2 -- transfer to next payer
                       ,0
                       ,p.ReferenceNumber
                       ,gc.GlobalCodeId AS AdjustmentGlobalCode
                       ,gc.ExternalCode2 AS AdjustmentGroupCode
                       ,gc.ExternalCode1 AS AdjustmentReasonCode
                       ,lica.BackOutAdjustments
                       ,Lica.IsNotPrimary
                       ,ccp.ClientCoveragePlanId
                FROM    #ReverseTransfers rt
                        JOIN #LineItemChargeAmount lica
                            ON rt.ERClaimLineItemId = lica.ERClaimLineItemId
                               AND rt.EOBChargeId = lica.ChargeId
                        JOIN Charges c
                            ON rt.ChargeId = c.ChargeId
                        JOIN Services s
                            ON s.ServiceId = c.ServiceId
                        JOIN GlobalCodes gc
                            ON rt.ReverseAdjustmentCode = gc.GlobalCodeId
                        JOIN Payments P
                            ON LICA.PaymentId = P.PaymentId
                        LEFT JOIN dbo.ClientCoveragePlans ccp
                            ON c.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                        JOIN dbo.Charges c2
                            ON c2.ChargeId = rt.EOBChargeId
                        JOIN dbo.ClientCoveragePlans ccp2
                            ON ccp2.ClientCoveragePlanId = c2.ClientCoveragePlanId
                        JOIN dbo.ClaimLineItems cli
                            ON cli.ClaimLineItemId = LICA.ClaimLineItemId

	   -- fix rounding errors.
   
       UPDATE   [IS]
       SET      [IS].PaidAmount = ISNULL([IS].PaidAmount, 0) + ( ISNULL(LIP.PaidAmount, 0) - ISNULL(TotalPay.PaidAmount,
                                                                                                    0) )
       FROM     #ImportStaging [IS]
                LEFT JOIN #LineItemPaid LIP
                    ON LIP.ERClaimLineItemId = [IS].ERClaimLineItemId
                LEFT JOIN (
                            SELECT  [IS4].ERClaimLineItemId
                                   ,[IS4].AdjustmentGroupCode
                                   ,[IS4].AdjustmentReasonCode
                                   ,SUM([IS4].PaidAmount) AS PaidAmount
                            FROM    #ImportStaging [IS4]
                            GROUP BY [IS4].ERClaimLineItemId
                                   ,[IS4].AdjustmentGroupCode
                                   ,[IS4].AdjustmentReasonCode
                          ) TotalPay
                    ON TotalPay.ERClaimLineItemId = [IS].ERClaimLineItemId
                       AND TotalPay.AdjustmentGroupCode = [IS].AdjustmentGroupCode
                       AND TotalPay.AdjustmentReasonCode = [IS].AdjustmentReasonCode
       WHERE    NOT EXISTS ( SELECT 1
                             FROM   #ImportStaging [IS2]
                             WHERE  [IS].ERClaimLineItemId = [IS2].ERClaimLineItemId
                                    AND [IS].chargeID > [IS2].ChargeId )
                AND [IS].AdjustmentGlobalCode = -1 -- payment line of [IS], not an adjustment
                                
		-- For secondaries, Smartcare doesn't work properly if there are more transfer dollars than there is revenue (Charges + Transfers)
		-- But we still need to transfer any remaining revenue.
		-- So we are going to use a specified Transfer Code and transfer the full revenue on the charge less the payment from the EOB.
        INSERT  INTO #ImportStaging
                ( SortOrder
                , ClaimLineItemId
                , ERClaimLineItemId
                , ClaimedAmount
                , PayerClaimNumber
                , PaidAmount
                , BalanceAmount
                , chargeID
                , ClientId
                , CoveragePlanId
                , ClientCoveragePlanId
                , AdjustmentAmount
                , ProcessingAction
                , TransferAmount
                , ReferenceNumber
                , AdjustmentGlobalCode
                , AdjustmentGroupCode
                , AdjustmentReasonCode
                , BackOutAdjustments
                , IsNotPrimary
                , NextBillablePayer
		        )
                SELECT  5 -- SortOrder - int
                      , ist.ClaimLineItemId-- ClaimLineItemId - integer
                      , ist.ERClaimLineItemId-- ERClaimLineItemId - int
                      , ist.ClaimedAmount-- ClaimedAmount - decimal
                      , ist.PayerClaimNumber-- PayerClaimNumber - varchar(50)
                      , 0.00-- PaidAmount - decimal
                      , ist.BalanceAmount-- BalanceAmount - decimal
                      , ist.chargeID-- chargeID - char(10)
                      , ist.ClientId-- ClientId - char(10)
                      , ist.CoveragePlanId-- CoveragePlanId - integer
                      , ist.ClientCoveragePlanId-- ClientCoveragePlanId - integer
			   -- The revenue on the charge less the payment.
                      , revenue.amount - ist.PaidAmount -- AdjustmentAmount - decimal
                      , 2-- ProcessingAction - int
                      , 0-- TransferAmount - decimal
                      , ist.ReferenceNumber-- ReferenceNumber - varchar(30)
                      , gc.GlobalCodeId-- AdjustmentGlobalCode - integer
                      , gc.ExternalCode2-- AdjustmentGroupCode - varchar(50)
                      , gc.ExternalCode1-- AdjustmentReasonCode - varchar(50)
                      , ist.BackOutAdjustments-- BackOutAdjustments - char(1)
                      , ist.IsNotPrimary-- IsNotPrimary - bit
                      , ist.NextBillablePayer-- NextBillablePayer - int
                FROM    #ImportStaging AS ist -- need this per charge which we haven't calculated in another table.
				-- so just cross apply for everything, I guess.
                        CROSS APPLY ( SELECT    SUM(al.Amount)
                                      FROM      dbo.ARLedger AS al
                                      WHERE     al.ChargeId = ist.chargeID
                                                AND ISNULL(al.RecordDeleted,
                                                           'N') <> 'Y'
                                                AND al.LedgerType IN ( 4204,
                                                              4201 )
                                    ) revenue ( amount )
                        JOIN dbo.GlobalCodes AS gc
                            ON gc.GlobalCodeId = @AutomaticTransferForSecondaryAdjustmentCode
                        JOIN dbo.Charges AS c
                            ON c.ChargeId = ist.chargeID
						-- do not post for errored services
                        JOIN dbo.Services AS s
                            ON s.ServiceId = c.ServiceId
                               AND s.Status <> 76
                WHERE   ISNULL(ist.PaidAmount, 0.00) > 0.00
                        AND ist.IsNotPrimary = 1
                        AND @AutomaticTransferForSecondary = 'Y'
                        AND revenue.amount - ist.PaidAmount > 0
                 

				-- If there is no payment, we need to transfer, but instead of a fixed adjustment code we will need to use one from the EOB
                INSERT  INTO #ImportStaging
                        ( SortOrder
                        , ClaimLineItemId
                        , ERClaimLineItemId
                        , ClaimedAmount
                        , PayerClaimNumber
                        , PaidAmount
                        , BalanceAmount
                        , chargeID
                        , ClientId
                        , CoveragePlanId
                        , ClientCoveragePlanId
                        , AdjustmentAmount
                        , ProcessingAction
                        , TransferAmount
                        , ReferenceNumber
                        , AdjustmentGlobalCode
                        , AdjustmentGroupCode
                        , AdjustmentReasonCode
                        , BackOutAdjustments
                        , IsNotPrimary
                        , NextBillablePayer
				        )
                        SELECT  5-- SortOrder - int
                              , LICA.ClaimLineItemId-- ClaimLineItemId - integer
                              , LICA.ERClaimLineItemId-- ERClaimLineItemId - int
                              , cli.ChargeAmount-- ClaimedAmount - decimal
                              , LICA.PayerClaimNumber-- PayerClaimNumber - varchar(50)
                              , 0.00-- PaidAmount - decimal
                              , LICA.BalanceAmount-- BalanceAmount - decimal
                              , LICA.ChargeId-- chargeID - char(10)
                              , S.ClientId-- ClientId - char(10)
                              , CCP.CoveragePlanId-- CoveragePlanId - integer
                              , CCP.ClientCoveragePlanId-- ClientCoveragePlanId - integer
                              , revenue.amount-- AdjustmentAmount - decimal
                              , 2-- ProcessingAction - int
                              , 0.00-- TransferAmount - decimal
                              , P.ReferenceNumber-- ReferenceNumber - varchar(30)
                              , gc.GlobalCodeId-- AdjustmentGlobalCode - integer
                              , gc.ExternalCode2-- AdjustmentGroupCode - varchar(50)
                              , gc.ExternalCode1-- AdjustmentReasonCode - varchar(50)
                              , LICA.BackOutAdjustments-- BackOutAdjustments - char(1)
                              , LICA.IsNotPrimary-- IsNotPrimary - bit
                              , LICA.NextBillablePayer-- NextBillablePayer - int                
                        FROM    #LineItemChargeAmount AS LICA
                                CROSS APPLY ( SELECT    MIN(lia.AdjustmentGlobalcode)
                                              FROM      #LineItemAdjustment AS lia
                                              WHERE     lia.ERClaimLineItemId = LICA.ERClaimLineItemId
                                            ) adjustmentcode ( code )
                                CROSS APPLY ( SELECT    SUM(al.Amount)
                                              FROM      dbo.ARLedger AS al
                                              WHERE     al.ChargeId = LICA.ChargeId
                                                        AND ISNULL(al.RecordDeleted,
                                                              'N') <> 'Y'
                                                        AND al.LedgerType IN (
                                                        4204, 4201 )
                                            ) revenue ( amount )
                                JOIN dbo.GlobalCodes AS gc
                                    ON adjustmentcode.code = gc.GlobalCodeId
                                JOIN dbo.ClaimLineItems cli
                                    ON cli.ClaimLineItemId = LICA.ClaimLineItemId
                                JOIN dbo.Charges C
                                    ON LICA.ChargeId = C.ChargeId
                                JOIN dbo.ClientCoveragePlans CCP
                                    ON CCP.ClientCoveragePlanId = C.ClientCoveragePlanId
                                JOIN dbo.Services S
                                    ON C.ServiceId = S.ServiceId
                                       AND S.Status <> 76
                                JOIN dbo.Payments P
                                    ON LICA.PaymentId = P.PaymentId
                        WHERE   NOT EXISTS ( SELECT 1
                                             FROM   #ImportStaging AS ist
                                             WHERE  ist.chargeID = LICA.ChargeId
                                                    AND ISNULL(ist.PaidAmount,
                                                              0.00) <> 0.00 ) -- <> 0.00 because if there is a reversal we don't want to do this.
											-- If the EOB is a reversal, the automatic transfer reversal process above should cover any transfers on the secondary.
                                AND LICA.IsNotPrimary = 1
								
                                
                 
       IF @@error <> 0 
          GOTO error          
                            
                            
       IF CURSOR_STATUS('global', 'cur_import') >= -1 
          BEGIN      
                CLOSE cur_import      
                DEALLOCATE cur_import      
          END      
        
 -- Cursor loop is at the Charge Level, but we're sorting by Claimline Item so we
 -- can do a transaction for each claimline.             
                        
       DECLARE cur_import CURSOR
       FOR
               SELECT   [IS].ClaimLineItemId
                       ,[IS].ClaimedAmount
                       ,[IS].PayerClaimNumber
                       ,[IS].PaidAmount
                       ,[IS].BalanceAmount
                       ,[IS].chargeID
                       ,[IS].ClientId
                       ,[IS].CoveragePlanId
                       ,[IS].ClientCoveragePlanId
                       ,[IS].AdjustmentAmount
                       ,[IS].ProcessingAction
                       ,[IS].TransferAmount
                       ,[IS].ReferenceNumber
                       ,[IS].AdjustmentGlobalCode
                       ,[IS].BackOutAdjustments
                       ,[IS].IsNotPrimary
                       ,[is].NextBillablePayer
               FROM     #ImportStaging [IS]
               ORDER BY [IS].ClaimLineItemId
                       ,SortOrder 
                    
       OPEN cur_import      

       FETCH NEXT FROM cur_import      
INTO @ClaimLineItemId, @ClaimedAmount, @PayerClaimNumber, @PaidAmount, @BalanceAmount, @ChargeId, @ClientId,
             @CoveragePlanId, @ClientCoveragePlanId, @AdjustmentAmount, @ProcessingAction, @TransferAmount, @CheckNo,
             @AdjustmentGlobalCodeID, @BackOutAdjustments, @IsNotPrimary, @TransferTo
      
       IF @@error <> 0 
          GOTO error      
      
       WHILE @@fetch_status = 0 
             BEGIN       
        
                   IF @TransactionOpen = 'N' -- One transaction for one claimline but multiple charges
                      BEGIN
                            BEGIN TRANSACTION
                            SET @TransactionOpen = 'Y'
                            SET @ClaimLineAdjustmentCheckDone = 'N'
                            --SET @ClaimLineTransferCheckDone = 'N'
          
                      END
                   SET @FinancialActivityLineId = NULL      
                   SET @ARLedgerId = NULL      
                   SET @DateOfService = NULL      
                   SET @TransferChargeToNextPayer = 'N'
                   SET @AdjustCharge = 'N'
                   SET @AssignToClient = 'N'
                   SET @Flagged = 'N'
            
--Find DateOfService      
                   SET @DateOfService = (
                                          SELECT TOP 1
                                                    s.DateOfService
                                          FROM      Services S
                                                    JOIN Charges ch
                                                        ON ch.ServiceId = s.ServiceId
                                          WHERE     ChargeId = @ChargeId
                                                    AND ISNULL(ch.RecordDeleted, 'N') = 'N'
                                                    AND ISNULL(s.RecordDeleted, 'N') = 'N'
                                        )      

                   IF @PaidAmount = 0
                      AND @Adjustmentamount = 0 -- No activity on this ERClaimlineItem
                      BEGIN
                            UPDATE  Charges
                            SET     Flagged = 'Y'
                            WHERE   ChargeId = @ChargeId 
                            SET @Flagged = 'Y'
                      END
                   IF NOT EXISTS ( SELECT   1
                                   FROM     #ImportStaging
                                   WHERE    PaidAmount <> 0
                                            AND ClaimLineItemId = @ClaimLineItemId )-- Possible denial
                      BEGIN
                            UPDATE  dbo.Charges
                            SET     Flagged = 'Y'
                            WHERE   ChargeId = @ChargeId       
                            SET @Flagged = 'Y'
                      END      
      -- if the amount on the claim equals the adjustment, the claim was denied
                   IF @AdjustmentAmount = @ClaimedAmount 
                      BEGIN
                            UPDATE  dbo.Charges
                            SET     Flagged = 'Y'
                            WHERE   ChargeId = @ChargeId 
                            SET @Flagged = 'Y'      
                      END
                   IF @PaidAmount <> 0 
                      BEGIN       
                            SELECT  @ClientId = s.ClientId
                                   ,@ServiceId = s.ServiceId
                                   ,@ProcedureCodeId = s.ProcedureCodeId
                                   ,@DateOfService = s.DateOfService
                                   ,@ClinicianId = s.ClinicianId
                            FROM    Services s
                                    JOIN Charges ch
                                        ON ch.ServiceId = s.ServiceId
                            WHERE   ch.ChargeId = @ChargeId
                                    AND ISNULL(s.RecordDeleted, 'N') = 'N'
                                    AND ISNULL(ch.RecordDeleted, 'N') = 'N'      
      
                            EXEC ssp_PMPaymentAdjustmentPost @UserCode = @UserCode,
                                @FinancialActivityId = @FinancialActivityId, @PaymentId = @PaymentId,
                                @Payment = @PaidAmount, @PostedAccountingPeriodId = @CurrentAccountingPeriodId,
                                @Flagged = @Flagged, @ChargeId = @ChargeId, @ServiceId = @ServiceId,
                                @DateOfService = @DateOfService, @ClientId = @ClientId,
                                @CoveragePlanId = @CoveragePlanId, @ERTransferPosting = 'N',
                                @FinancialActivityLineId = NULL    
            
                            IF @@error <> 0 
                               GOTO rollback_tran      
      
                      END -- @PaidAmount <> 0      
      
                   IF @AdjustmentAmount <> 0
                      AND @ApplyAdjustments = 'Y' 
                      BEGIN       
                
                
-- If we identified a charge for which we had already posted an adjustment before billing.  IE. we charge 100 but they have an allowed amount of 80, we will have posted an adjustment of 20, **IF** we bill them the allowed amount.                
                  
                            SELECT  @ClientId = s.ClientId
                                   ,@ServiceId = s.ServiceId
                                   ,@ProcedureCodeId = s.ProcedureCodeId
                                   ,@DateOfService = s.DateOfService
                                   ,@ClinicianId = s.ClinicianId
                            FROM    Services s
                                    JOIN Charges ch
                                        ON ch.ServiceId = s.ServiceId
                            WHERE   ch.ChargeId = @ChargeId
                                    AND ISNULL(s.RecordDeleted, 'N') = 'N'
                                    AND ISNULL(ch.RecordDeleted, 'N') = 'N'      


                    
                            SELECT  @TransferChargeToNextPayer = 'Y'
                            WHERE   @ProcessingAction = 2  -- Value in ERProcessingActions
                    
                            SELECT  @AssignToClient = 'Y'
                            WHERE   @ProcessingAction = 3 -- Value in ERProcessingActions
                
                                                                   
                            SELECT  @AdjustCharge = 'Y'
                            WHERE   @ProcessingAction = 1 -- Value in ERProcessingActions
                                    AND ( @IsNotPrimary = 0
                                          OR @VerboseMode = 'Y'
                                        )
           
          
                        
                            IF @TransferChargeToNextPayer = 'Y'
                               OR @AssignToClient = 'Y' 
                               BEGIN  -- It is a transfer
                                     IF @ApplyTransfers = 'Y' 
                                        BEGIN
                                        
                                              IF @AssignToClient = 'Y' 
                                                 BEGIN
                                                       SET @CoveragePlanId = NULL  -- This will assign charge to a client.
                                                       SET @TransferTo = NULL
                                                 END                  
                -- don't need to do the claim line transfer check anymore.
                -- if there's already a transfer to the next payer (or the client), apply a reverse entry for the transfer and reapply
                    --                          IF @ClaimLineTransferCheckDone = 'N' 
                    --                             BEGIN
                    --                                   SET @ClaimLineTransferCheckDone = 'Y'              
                    --                                   SET @ClientTransferAmount = NULL
                    --                                   SET @ClientChargeId = NULL
                    --                                   SET @CurrentCoveragePlanId = NULL 
                    --                                   SET @TransferBackTo = NULL
                    --                                   SET @ReverseTransferAdjustmentCode = NULL

                    --                                   SELECT   @ClientTransferAmount = SUM(Amount)
                    --                                           ,@ClientChargeId = c.ChargeId
                    --                                           ,@ReverseTransferAdjustmentCode = MAX(al.AdjustmentCode)
                    --                                   FROM     Services s
                    --                                            JOIN dbo.Charges c
                    --                                                ON s.ServiceId = c.ServiceId
                    --                                                   AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
                    --                                                   AND ISNULL(@TransferTo, -1) = ISNULL(c.ClientCoveragePlanId,
                    --                                                                                    -1)
                    --                                            JOIN dbo.ARLedger al
                    --                                                ON c.ChargeId = al.ChargeId
                    --                                                   AND ISNULL(al.RecordDeleted, 'N') <> 'Y'
                    --                                                   AND al.LedgerType = 4204
                    --                                            JOIN dbo.FinancialActivityLines fal
                    --                                                ON al.FinancialActivityLineId = fal.FinancialActivityLineId
                    --                                                   AND ISNULL(fal.RecordDeleted, 'N') <> 'Y'
                    --                                   WHERE    s.ServiceId = @ServiceId
                    --                                            AND EXISTS ( SELECT 1
                    --                                                         FROM   dbo.ARLedger al2
                    --                                                                JOIN dbo.FinancialActivityLines fal2
                    --                                                                    ON al2.FinancialActivityLineId = fal2.FinancialActivityLineId
                    --                                                                       AND fal.FinancialActivityId = fal2.FinancialActivityId
                    --                                                                       AND ISNULL(fal2.RecordDeleted,
                    --                                                                                  'N') <> 'Y'
                    --                                                         WHERE  al2.ChargeId = @ChargeId
                    --                                                                AND al2.LedgerType = 4204
                    --                                                                AND al.Amount = -al2.Amount
                    --                                                                AND ISNULL(al2.RecordDeleted, 'N') <> 'Y' )
                    --                                   GROUP BY c.ChargeId

                    --                                   SELECT   @CurrentCoveragePlanId = ccp.CoveragePlanId
                    --                                           ,@TransferBackTo = ccp.ClientCoveragePlanId
                    --                                   FROM     dbo.Charges c
                    --                                            JOIN dbo.ClientCoveragePlans ccp
                    --                                                ON c.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                    --                                   WHERE    c.ChargeId = @ChargeId
                    
                     
                    ----SELECT @ClientTransferAmount,@CurrentCoveragePlanId,@ReverseTransferAdjustmentCode,@ClientChargeId,@TransferBackTo
                    
                    --                                   IF ISNULL(@ClientTransferAmount, 0) <> 0 
                    --   -- and a transfer isn't already being done. (i.e. if the adjustment amount is going to cause the reversal already.)
                    --   -- since we're going backwards, this check needs to be negative.
                    --                                      AND (NOT EXISTS (SELECT 1 FROM #ImportStaging [is] WHERE -[is].AdjustmentAmount = ISNULL(@ClientTransferAmount, 0) AND [is].ChargeId = @ChargeId))
                    --                                      BEGIN
                    --                                            EXEC ssp_PMPaymentAdjustmentPost @UserCode = @UserCode,
                    --                                                @FinancialActivityId = @FinancialActivityId,
                    --                                                @PaymentId = NULL, @FinancialActivityLineId = NULL,
                    --                                                @ChargeId = @ClientChargeId, @ServiceId = @ServiceId,
                    --                                                @DateOfService = @DateOfService,
                    --                                                @ClientId = @ClientId,
                    --                                                @CoveragePlanId = @CurrentCoveragePlanId,
                    --                                                @Flagged = @Flagged,
                    --                                                @Transfer1 = @ClientTransferAmount,
                    --                                                @TransferTo1 = @TransferBackTo,
                    --                                                @TransferCode1 = @ReverseTransferAdjustmentCode

                    --                                                -- if we're in verbose mode, reduce the false charge by the reversal amount
                    --                                                UPDATE #ImportStaging
                    --                                                 SET AdjustmentAmount = AdjustmentAmount - @ClientTransferAmount
                    --                                                 WHERE ChargeId = @ChargeId
                    --                                                    AND AdjustmentGlobalCode = @FalseChargeAdjustmentCode
                    --                                                    AND @VerboseMode = 'Y'
                    --                                                    AND @FalseChargeAdjustmentCode IS NOT NULL

                    --                                      END
                                                 --END                                 
                 
                                      
                                              EXEC ssp_PMPaymentAdjustmentPost @UserCode = @UserCode,
                                                @FinancialActivityId = @FinancialActivityId, @PaymentId = NULL,
                                                @FinancialActivityLineId = NULL, @ChargeId = @ChargeId,
                                                @ServiceId = @ServiceId, @DateOfService = @DateOfService,
                                                @ClientId = @ClientId, @CoveragePlanId = @CoveragePlanId,
                                                @Flagged = @Flagged, @Transfer1 = @AdjustmentAmount,
                                                @TransferTo1 = @TransferTo, @TransferCode1 = @AdjustmentGlobalCodeID

                                                -- we'll need to enter a reversing entry on the second charge for the False Charge Adjustment code if there's a payment and there's a false charge adjustment
                                                -- handling this by not applying the false charge on top of payments/transfers on secondary charges.

             --                                IF @VerboseMode = 'Y'
             --                                   AND EXISTS ( SELECT 1
             --                                                FROM   dbo.Charges c
             --                                                       JOIN dbo.ARLedger al
             --                                                           ON c.ChargeId = al.ChargeId
             --                                                WHERE  c.ClientCoveragePlanId = @TransferTo
             --                                                       AND c.ServiceId = @ServiceId
             --                                                       AND LedgerType = 4202
             --                                                GROUP BY al.ChargeId
             --                                                HAVING SUM(Amount) > 0 ) 
             --                                   AND EXISTS (SELECT 1
             --                                                FROM   dbo.Charges c
             --                                                       JOIN dbo.ARLedger al
             --                                                           ON c.ChargeId = al.ChargeId
             --                                                WHERE  c.ClientCoveragePlanId = @TransferTo
             --                                                       AND LedgerType = 4203
             --                                                       AND c.ServiceId = @ServiceId
             --                                                       AND AdjustmentCode = @FalseChargeAdjustmentCode)
             --                                   BEGIN


             ----                                               DECLARE @ReverseFakeChargeAdjustAmount MONEY
             ----,@NextChargeId INT
             ----,@NextCoveragePlanId
             --                                         SET @ReverseFakeChargeAdjustAmount = NULL
             --                                         SET @NextChargeId = NULL
             --                                         SET @NextCoveragePlanId = NULL   
                                                                                                           
             --                                         SELECT @ReverseFakeChargeAdjustAmount = -@AdjustmentAmount
             --                                                ,@NextChargeId = c.ChargeId
             --                                                ,@NextCoveragePlanId = ccp.CoveragePlanId
             --                                         FROM dbo.Charges c
             --                                              LEFT JOIN dbo.ClientCoveragePlans ccp ON c.ClientCoveragePlanId = ccp.ClientCoveragePlanId
             --                                              WHERE ISNULL(c.ClientCoveragePlanId,-1) = ISNULL(@TransferTo,-1)
             --                                                     AND c.ServiceId = @ServiceId
                                                      
             --                                          IF @NextChargeId IS NOT NULL
             --                                             AND ISNULL(@ReverseFakeChargeAdjustAmount,0.00) <> 0.00

             --                                         EXEC ssp_PMPaymentAdjustmentPost @UserCode = @UserCode,
             --                                           @FinancialActivityId = @FinancialActivityId, @PaymentId = NULL,
             --                                           @Adjustment1 = @ReverseFakeChargeAdjustAmount,
             --                                           @AdjustmentCode1 = @FalseChargeAdjustmentCode,
             --                                           @PostedAccountingPeriodId = @CurrentAccountingPeriodId,
             --                                           @Flagged = @Flagged, @ChargeId = @NextChargeId,
             --                                           @ServiceId = @ServiceId, @DateOfService = @DateOfService,
             --                                           @ClientId = @ClientId, @CoveragePlanId = @NextCoveragePlanId,
             --                                           @ERTransferPosting = 'N', @FinancialActivityLineId = NULL                                                
             --                                   END                                                

                                        END
                               END
                            ELSE 
                               BEGIN  -- it is not a transfer, just an adjustment
                           
                                     IF @ApplyAdjustments = 'Y'
                                        AND @AdjustCharge = 'Y' 
                                        BEGIN
                                                                                   
            
                                              IF @BackOutAdjustments = 'Y'
                                                 AND @ClaimLineAdjustmentCheckDone = 'N' 
                                                 BEGIN                
                                                       SET @ClaimLineAdjustmentCheckDone = 'Y'
        
        	 -- Insert reversing entries in ARLedger           
                                                       INSERT   INTO ARLedger
                                                                ( 
                                                                 ChargeId
                                                                ,FinancialActivityLineId
                                                                ,FinancialActivityVersion
                                                                ,LedgerType
                                                                ,Amount
                                                                ,PaymentId
                                                                ,AdjustmentCode
                                                                ,AccountingPeriodId
                                                                ,PostedDate
                                                                ,ClientId
                                                                ,CoveragePlanId
                                                                ,DateOfService
                                                                ,ErrorCorrection
                                                                ,CreatedBy
                                                                ,CreatedDate
                                                                ,ModifiedBy
                                                                ,ModifiedDate
			                                        
                                                                )
                                                                SELECT  AR.ChargeId
                                                                       ,FinancialActivityLineId
                                                                       ,FinancialActivityVersion
                                                                       ,LedgerType
                                                                       ,-Amount
                                                                       ,AR.PaymentId
                                                                       ,AdjustmentCode
                                                                       ,@CurrentAccountingPeriodId
                                                                       ,@CurrentDate
                                                                       ,ClientId
                                                                       ,CoveragePlanId
                                                                       ,DateOfService
                                                                       ,'Y'
                                                                       ,@UserCode
                                                                       ,@CurrentDate
                                                                       ,@UserCode
                                                                       ,@CurrentDate
                                                                FROM    ARLedger AR
                                                                WHERE   AR.ChargeId = @ChargeID
                                                                        AND AR.LedgerType = 4203
                                                                        AND ISNULL(ar.MarkedAsError, 'N') = 'N'
                                                                        AND ISNULL(ar.ErrorCorrection, 'N') = 'N'
                                                            
                                                            -- Set ARLedger entries for current version to MarkedAsError          
                                                       UPDATE   AR
                                                       SET      MarkedAsError = 'Y'
                                                               ,ModifiedBy = @UserCode
                                                               ,ModifiedDate = @CurrentDate
                                                       FROM     ARLedger AR
                                                       WHERE    AR.ChargeId = @ChargeId
                                                                AND AR.LedgerType = 4203
                                                                AND ISNULL(ar.MarkedAsError, 'N') = 'N'
                                                                AND ISNULL(ar.ErrorCorrection, 'N') = 'N'
                                                       IF @@error <> 0 
                                                          GOTO error          

                                                 END -- Backout Adjustment
        
        
        
        
                                              EXEC ssp_PMPaymentAdjustmentPost @UserCode = @UserCode,
                                                @FinancialActivityId = @FinancialActivityId, @PaymentId = NULL,
                                                @Adjustment1 = @AdjustmentAmount,
                                                @AdjustmentCode1 = @AdjustmentGlobalCodeID  --1000288  what was this?
                                                , @PostedAccountingPeriodId = @CurrentAccountingPeriodId,
                                                @Flagged = @Flagged, @ChargeId = @ChargeId, @ServiceId = @ServiceId,
                                                @DateOfService = @DateOfService, @ClientId = @ClientId,
                                                @CoveragePlanId = @CoveragePlanId, @ERTransferPosting = 'N',
                                                @FinancialActivityLineId = NULL    
                                        END
                                     ELSE IF @ProcessingAction <> 5-- It's an error 
                                        BEGIN
                                              UPDATE    Charges
                                              SET       Flagged = 'Y'
                                              WHERE     ChargeId = @ChargeId 
                                              SET @Flagged = 'Y'
                                        END
                               END               

                        
                            IF @@error <> 0 
                               GOTO rollback_tran      
      
                      END -- @AdjustmentAmount <> 0  
      
 
      
                   IF @@error <> 0 
                      GOTO rollback_tran      
                
                   SET @SaveClaimLineItemID = @ClaimLineItemId
      
                   FETCH NEXT FROM cur_import      
INTO @ClaimLineItemId, @ClaimedAmount, @PayerClaimNumber, @PaidAmount, @BalanceAmount, @ChargeId, @ClientId,
                         @CoveragePlanId, @ClientCoveragePlanId, @AdjustmentAmount, @ProcessingAction, @TransferAmount,
                         @CheckNo, @AdjustmentGlobalCodeID, @BackOutAdjustments, @IsNotPrimary, @TransferTo
                   IF @@error <> 0 
                      GOTO rollback_tran   
                
                   IF @@FETCH_STATUS <> 0
                      OR @ClaimLineItemID <> @SaveClaimLineItemID -- claimline changed
                      BEGIN
                            UPDATE  ERClaimLineItems  -- not setting modified?
                            SET     Processed = 'Y'
                                   ,ProcessedDate = GETDATE()
                            FROM    ERClaimLineItems
                            WHERE   ClaimLineItemId = @SaveClaimLineItemID
                                    AND ERBatchId = @ERBatchId
                            COMMIT TRANSACTION -- Write the claimline information out 
                            --SET @ClaimLineTransferCheckDone = 'N'
                            SET @ClaimLineAdjustmentCheckDone = 'N'
                            SET @TransactionOpen = 'N'
        
                      END -- @@fetch_status = 0 for cur_import        

             END 

       CLOSE cur_import      
       DEALLOCATE cur_import  
  
  -- Flag charges that have been flagged by the process
      
       IF @@error <> 0 
          GOTO error      
  
       RETURN      
      
       rollback_tran:      
      
       ROLLBACK TRAN      
      
       error:      
      
       SET @ErrorMessage = ISNULL(@ErrorMessage + ' [scsp_PM835PostBatch]', '[scsp_PM835PostBatch]')
      
   
	     RAISERROR ('@ErrorNo @ErrorMessage ', 16, 1);

      
       RETURN

GO


