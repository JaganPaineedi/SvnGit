/****** Object:  StoredProcedure [dbo].[ssp_PMPaymentAdjustmentPost]    Script Date: 6/6/2018 10:10:42 AM ******/
DROP PROCEDURE [dbo].[ssp_PMPaymentAdjustmentPost]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMPaymentAdjustmentPost]    Script Date: 6/6/2018 10:10:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_PMPaymentAdjustmentPost] @UserCode VARCHAR(30)
	,-- User posting the payments/adjustments            
	@FinancialActivityId INT
	,-- Set only in case of correction, null otherwise            
	@PaymentId INT
	,-- Set only in case the financial activity is  Payment            
	@FinancialActivityLineId INT
	,-- Set only in case of correction            
	@ChargeId INT
	,-- Always  set             
	@ServiceId INT
	,-- Always set            
	@DateOfService DATETIME
	,-- Always set            
	@ClientId INT
	,-- Always set            
	@CoveragePlanId INT
	,-- Set to the CoveragePlanId for the @ChargeId, null if @ChargeId is for client            
	@PostedAccountingPeriodId INT = NULL
	,-- Accounting Period selected by the user    
	@Flagged CHAR(1) = NULL
	,@Comment VARCHAR(8000) = NULL
	,@Payment MONEY = NULL
	,@Adjustment1 MONEY = NULL
	,@AdjustmentCode1 INT = NULL
	,@Adjustment2 MONEY = NULL
	,@AdjustmentCode2 INT = NULL
	,@Adjustment3 MONEY = NULL
	,@AdjustmentCode3 INT = NULL
	,@Adjustment4 MONEY = NULL
	,@AdjustmentCode4 INT = NULL
	,@Transfer1 MONEY = NULL
	,@TransferTo1 INT = NULL
	,-- ClientCoveragePlanId (null in case of transfer to Client)            
	@TransferCode1 INT = NULL
	,@DoNotBill1 CHAR(1) = NULL
	,@Transfer2 MONEY = NULL
	,@TransferTo2 INT = NULL
	,-- ClientCoveragePlanId (null in case of transfer to Client)            
	@TransferCode2 INT = NULL
	,@DoNotBill2 CHAR(1) = NULL
	,@Transfer3 MONEY = NULL
	,@TransferTo3 INT = NULL
	,-- ClientCoveragePlanId (null in case of transfer to Client)            
	@TransferCode3 INT = NULL
	,@DoNotBill3 CHAR(1) = NULL
	,@Transfer4 MONEY = NULL
	,@TransferTo4 INT = NULL
	,-- ClientCoveragePlanId (null in case of transfer to Client)            
	@TransferCode4 INT = NULL
	,@DoNotBill4 CHAR(1) = NULL
	,@ERTransferPosting CHAR(1) = NULL
	,@ChargeStatus INT = NULL
	,@StatusComment VARCHAR(8000) = NULL
AS /*********************************************************************  
-- Stored Procedure: dbo.ssp_PMPaymentAdjustmentPost  
-- Creation Date:    10/8/06                          
--                                                    
-- Purpose: Posts payment and adjustments  
--                                 
--                                 
-- Updates:                        
--  Date        Author    Purpose  
--  10.08.2006  JHB       Created  
--  07.24.2013  SFarber   Removed code that set @TransferTo<N> to null if = @ClientId  
--  11/19/2013  Shruthi.S Added copay logic to apply for coverage plans whenever we transfer money.Ref #1829 Core bugs.  
--  10/13/2015  Sbhowmik  Changed the logic to not update FinancialActivityLines.Flagged also append FinancialActivityLines.Comment to Charges.Comments 
--  10/19/2015  SFarber   Added code to recalculate charge priorities
--  12/30/2015  jcarlson  set the charge to flagged so the financial activity line id on the payment/adjustment posting screen works correctly
--						  Valley Support Go Live 178
--  04/07/2016	 jcarlson	  when creating co payment records use the core co payment adjustment code for the adjustmentcode, when calculating the client balance use the core logic ssp_SCCalculateClientBalnssp_PMPaymentAdjustmentPost
--  07/21/2016  Dknewtson  Added System Configuration Key RecalculateChargePriorityWhenPostingToARLedger controlling call to ssp_SCRecalculateChargePriorities
--  10/24/2016  T.Remisoski Check @PostedAccountingPeriodId parameter against AccountingPeriods table
--	   				   Only use current accounting period if Accounting Period is closed.
--  10/26/2016  Shivanand  Calling one new sp ssp_UpdateBillingCodesForSecondaryCharge to show billing code information for Second charge on services.Ref #103 CEI - Support Go Live.
--  08/10/2017	Ponnin		Added  two new parameters to update ChargeStatus and StatusComments of Charges table and Update ChargeStatus as 'paid' if the chargeamount is 0. Created a new variable @TotalChargeAmount. Why :For task #44 of AHN Customizations.
--  06/06/2018 Robert Caffrey Added logic to use Accounting Period originally posted for the Reversing entry Logic - SpringRiver SGL #248
*********************************************************************************************************************************************************************************/
DECLARE @FinancialActivityVersion INT
DECLARE @CurrentDate DATETIME
DECLARE @OriginalPayment MONEY
DECLARE @ChargeAmount MONEY --to get charge amount of current service    
DECLARE @ClientCoveragePlanId INT --to get secondary cov plan  
DECLARE @ProcedureCodeId INT --to get procedurecodeid of current service  
DECLARE @ClinicianId INT --clinicianid  
DECLARE @ProcedureRateId INT
DECLARE @EndDate DATETIME
------------------------------  
DECLARE @ERROR NVARCHAR(max)
------------------------------   
IF @ChargeStatus = -1 set @ChargeStatus = null
   
--To fetch configurable key to apply copay when we transfer money  
DECLARE @CopayKey CHAR(1)

SELECT @CopayKey = [value]
FROM SystemConfigurationKeys
WHERE [KEY] = 'Autosecondarycopayment'

    DECLARE @CoPayAdjustmentCode INT
    SELECT  @CoPayAdjustmentCode = CONVERT(INT , Value)
    FROM    dbo.SystemConfigurationKeys sck
    WHERE   ISNULL(sck.RecordDeleted , 'N') = 'N'
            AND sck.[Key] = 'ClientCoPaymentAdjustmentCode'
            
--To check if there is a charge entry for coverage plans we are transferring to   
DECLARE @TransferTo1Count INT
DECLARE @TransferTo2Count INT
DECLARE @TransferTo3Count INT
DECLARE @TransferTo4Count INT

SELECT @TransferTo1Count = count(*)
FROM charges
WHERE ClientCoveragePlanId = @TransferTo1
	AND serviceid = @ServiceId
	AND isnull(RecordDeleted, 'N') <> 'Y'

SELECT @TransferTo2Count = count(*)
FROM charges
WHERE ClientCoveragePlanId = @TransferTo2
	AND serviceid = @ServiceId
	AND isnull(RecordDeleted, 'N') <> 'Y'

SELECT @TransferTo3Count = count(*)
FROM charges
WHERE ClientCoveragePlanId = @TransferTo3
	AND serviceid = @ServiceId
	AND isnull(RecordDeleted, 'N') <> 'Y'

SELECT @TransferTo4Count = count(*)
FROM charges
WHERE ClientCoveragePlanId = @TransferTo4
	AND serviceid = @ServiceId
	AND isnull(RecordDeleted, 'N') <> 'Y'

-- fetch the value for ClientCopay   
IF @@error <> 0
	GOTO error

--Calculate copay only if there is a transfer to a coverage plan not to the client.(For Transfer1).  
DECLARE @TransferToClient1 CHAR(1) = 'N'
DECLARE @ClientCopay1 MONEY

CREATE TABLE #ClientCopay1 (Copay MONEY)

SET @ClientCopay1 = 0

IF (
		@Transfer1 <> 0
		AND @TransferTo1 IS NULL
		)
	SET @TransferToClient1 = 'Y'

IF @CopayKey = 'Y'
	AND @TransferToClient1 = 'N'
BEGIN
	IF @Transfer1 > 0
		AND NOT EXISTS (
			SELECT *
			FROM Charges
			WHERE ClientCoveragePlanId = @TransferTo1
				AND Serviceid = @ServiceId
				AND isnull(RecordDeleted, 'N') <> 'Y'
			)
	BEGIN
		INSERT INTO #ClientCopay1
		EXEC ssp_PMCalculateCopay @ServiceId
			,@TransferTo1
			,'Y'

		SELECT @ClientCopay1 = nullif(Copay, 0)
		FROM #ClientCopay1

		IF @ClientCopay1 > @Transfer1
			SET @ClientCopay1 = @Transfer1

		TRUNCATE TABLE #ClientCopay1
	END
END

--Calculate copay only if there is a transfer to a coverage plan not to the client.(For Transfer2).  
DECLARE @TransferToClient2 CHAR(1) = 'N'
DECLARE @ClientCopay2 MONEY

CREATE TABLE #ClientCopay2 (Copay MONEY)

SET @ClientCopay2 = 0

IF (
		@Transfer2 <> 0
		AND @TransferTo2 IS NULL
		)
	SET @TransferToClient2 = 'Y'

IF @CopayKey = 'Y'
	AND @TransferToClient2 = 'N'
BEGIN
	IF @Transfer2 > 0
		AND NOT EXISTS (
			SELECT *
			FROM Charges
			WHERE ClientCoveragePlanId = @TransferTo2
				AND Serviceid = @ServiceId
				AND isnull(RecordDeleted, 'N') <> 'Y'
			)
	BEGIN
		INSERT INTO #ClientCopay2
		EXEC ssp_PMCalculateCopay @ServiceId
			,@TransferTo2
			,'Y'

		SELECT @ClientCopay2 = nullif(Copay, 0)
		FROM #ClientCopay2

		IF @ClientCopay2 > @Transfer2
			SET @ClientCopay2 = @Transfer2

		TRUNCATE TABLE #ClientCopay2
	END
END

--Calculate copay only if there is a transfer to a coverage plan not to the client.(For Transfer3).  
DECLARE @TransferToClient3 CHAR(1) = 'N'
DECLARE @ClientCopay3 MONEY

CREATE TABLE #ClientCopay3 (Copay MONEY)

SET @ClientCopay3 = 0

IF (
		@Transfer3 <> 0
		AND @TransferTo3 IS NULL
		)
	SET @TransferToClient3 = 'Y'

IF @CopayKey = 'Y'
	AND @TransferToClient3 = 'N'
BEGIN
	IF @Transfer3 > 0
		AND NOT EXISTS (
			SELECT *
			FROM Charges
			WHERE ClientCoveragePlanId = @TransferTo3
				AND Serviceid = @ServiceId
				AND isnull(RecordDeleted, 'N') <> 'Y'
			)
	BEGIN
		INSERT INTO #ClientCopay3
		EXEC ssp_PMCalculateCopay @ServiceId
			,@TransferTo3
			,'Y'

		SELECT @ClientCopay3 = nullif(Copay, 0)
		FROM #ClientCopay3

		IF @ClientCopay3 > @Transfer3
			SET @ClientCopay3 = @Transfer3

		TRUNCATE TABLE #ClientCopay3
	END
END

--Calculate copay only if there is a transfer to a coverage plan not to the client.(For Transfer4).  
DECLARE @TransferToClient4 CHAR(1) = 'N'
DECLARE @ClientCopay4 MONEY

CREATE TABLE #ClientCopay4 (Copay MONEY)

SET @ClientCopay4 = 0

IF (
		@Transfer4 <> 0
		AND @TransferTo4 IS NULL
		)
	SET @TransferToClient4 = 'Y'

IF @CopayKey = 'Y'
	AND @TransferToClient4 = 'N'
BEGIN
	IF @Transfer4 > 0
		AND NOT EXISTS (
			SELECT *
			FROM Charges
			WHERE ClientCoveragePlanId = @TransferTo4
				AND Serviceid = @ServiceId
				AND isnull(RecordDeleted, 'N') <> 'Y'
			)
	BEGIN
		INSERT INTO #ClientCopay4
		EXEC ssp_PMCalculateCopay @ServiceId
			,@TransferTo4
			,'Y'

		SELECT @ClientCopay4 = nullif(Copay, 0)
		FROM #ClientCopay4

		IF @ClientCopay4 > @Transfer4
			SET @ClientCopay4 = @Transfer4

		TRUNCATE TABLE #ClientCopay4
	END
END

-- RJN 10/13/2006 Remove generic 'comment' text from @comment            
SELECT @Comment = CASE 
		WHEN @Comment = 'Comment'
			THEN ''
		ELSE @Comment
		END

IF @@error <> 0
	GOTO error

-- fetch clientId, startDate & EndDate     
SELECT @ClientId = ClientId
	,@ProcedureCodeId = ProcedureCodeId
	,@DateOfService = DateOfService
	,@EndDate = EndDateOfService
	,@ClinicianId = ClinicianId
	,@ChargeAmount = nullif(Charge, 0)
	,@ProcedureRateId = ProcedureRateId
FROM Services
WHERE ServiceId = @ServiceId

--select @ClientCoveragePlanId           
-- Check for required fields            
IF @FinancialActivityId IS NULL
	OR @ChargeId IS NULL
	OR @ServiceId IS NULL
	OR @DateOfService IS NULL
	OR @ClientId IS NULL
BEGIN
	------------------------------------------------------------  
	--raiserror 30001 'FinancialActivityId, ChargeId, ServiceId, DateOfService and ClientId are required'  
	--Modified by: SWAPAN MOHAN   
	--Modified on: 4 July 2012  
	--Purpose: For implementing the Customizable Message Codes.   
	--The Function Ssf_GetMesageByMessageCode(Screenid,MessageCode,OriginalText) will return NVARCHAR(MAX) value.  
	SET @ERROR = dbo.Ssf_GetMesageByMessageCode(450, 'REQIDS_SSP', 'FinancialActivityId, ChargeId, ServiceId, DateOfService and ClientId are required')

	RAISERROR (@ERROR,16,1) 

	------------------------------------------------------------          
	RETURN - 1
END

-- Check for  Payment, Adjustment, Transfer activity            
IF @Payment IS NULL
	AND isnull(@Adjustment1, 0) = 0
	AND isnull(@Transfer1, 0) = 0
	RETURN 0

SELECT @CurrentDate = getdate()

--
 -- T.Remisoski - 10/24/2016 - If @PostedAccountingPeriodId is not open, set to null so the current accounting period will be chosen.
 --
  if not exists (
    select *
    from AccountingPeriods as ap
    where ap.AccountingPeriodId = @PostedAccountingPeriodId
	   and ap.OpenPeriod = 'Y'
	   and isnull(RecordDeleted, 'N') = 'N'
    )
  begin
    set @PostedAccountingPeriodId = null
  end

--JHB 10/4/07       
IF @PostedAccountingPeriodId IS NULL
BEGIN
	SELECT @PostedAccountingPeriodId = AccountingPeriodId
	FROM AccountingPeriods
	WHERE StartDate <= @CurrentDate
		AND dateadd(dd, 1, EndDate) > @CurrentDate

	IF @@error <> 0
		GOTO error
END

-- Corrections Logic            
IF @FinancialActivityLineId IS NOT NULL
	AND isnull(@ERTransferPosting, 'N') = 'N'
BEGIN
	-- Get Financial Activity Version            
	SELECT @FinancialActivityVersion = CurrentVersion
	FROM FinancialActivityLines
	WHERE FinancialActivityLineId = @FinancialActivityLineId

	IF @@error <> 0
		GOTO error

	-- Set ARLedger entries for current version to MarkedAsError            
	UPDATE ARLedger
	SET MarkedAsError = 'Y'
		,ModifiedBy = @UserCode
		,ModifiedDate = @CurrentDate
	WHERE FinancialActivityLineId = @FinancialActivityLineId
		AND FinancialActivityVersion = @FinancialActivityVersion

	IF @@error <> 0
		GOTO error

	-- Insert reversing entries in ARLedger             
	INSERT INTO ARLedger (
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
	SELECT ChargeId
		,FinancialActivityLineId
		,FinancialActivityVersion
		,LedgerType
		,- Amount
		,PaymentId
		,AdjustmentCode
		,CASE WHEN ap.OpenPeriod = 'Y' THEN ap.AccountingPeriodId
			ELSE @PostedAccountingPeriodId end
		,@CurrentDate
		,ClientId
		,CoveragePlanId
		,DateOfService
		,'Y'
		,@UserCode
		,@CurrentDate
		,@UserCode
		,@CurrentDate
	FROM ARLedger
	JOIN dbo.AccountingPeriods ap ON ap.AccountingPeriodId = ARLedger.AccountingPeriodId
	WHERE FinancialActivityLineId = @FinancialActivityLineId
		AND FinancialActivityVersion = @FinancialActivityVersion

	IF @@error <> 0
		GOTO error

	-- Increment the FinancialActivityVersion for new entries            
	SET @FinancialActivityVersion = @FinancialActivityVersion + 1

	IF @@error <> 0
		GOTO error

	-- Update Flag            
	IF (
			@Payment = 0
			AND isnull(@Adjustment1, 0) = 0
			AND isnull(@Transfer1, 0) = 0
			) -- Bhupinder Bajwa 19 Dec 2006 REF Task #94            
		SET @Flagged = 'Y'

	IF isnull(@Flagged, 'N') = 'N'
		AND EXISTS (
			SELECT *
			FROM FinancialActivityLinesFlagged
			WHERE FinancialActivityLineId = @FinancialActivityLineId
			)
	BEGIN
		DELETE
		FROM FinancialActivityLinesFlagged
		WHERE FinancialActivityLineId = @FinancialActivityLineId

		IF @@error <> 0
			GOTO error

		UPDATE FinancialActivityLines
		SET CurrentVersion = @FinancialActivityVersion
			,Flagged = NULL
			,Comment = @Comment
			,ModifiedBy = @UserCode
			,ModifiedDate = @CurrentDate
		WHERE FinancialActivityLineId = @FinancialActivityLineId

		IF @@error <> 0
			GOTO error
	END
	ELSE IF ISNULL(@Flagged, 'N') = 'Y'
		AND NOT EXISTS (
			SELECT *
			FROM FinancialActivityLinesFlagged
			WHERE FinancialActivityLineId = @FinancialActivityLineId
			)
	BEGIN
		UPDATE FinancialActivityLines
		SET CurrentVersion = @FinancialActivityVersion
			--,Flagged = 'Y'
			,Comment = @Comment
			,ModifiedBy = @UserCode
			,ModifiedDate = @CurrentDate
		WHERE FinancialActivityLineId = @FinancialActivityLineId

		IF @@error <> 0
			GOTO error

		--jcarlson 12/30/2015 set the charge to flagged so the financial activity line id on the payment/adjustment posting screen works correctly
		-- Valley Support Go Live 178
		update c
		set c.Flagged = 'Y'
			,c.Modifiedby = @UserCode
			,c.ModifiedDate = @CurrentDate
		From dbo.Charges c
		join FinancialActivityLines fal on c.ChargeId = fal.ChargeId
		and isnull(fal.RecordDeleted,'N')='N'
		and fal.FinancialActivityLineId = @FinancialActivityLineId
		where isnull(c.RecordDeleted,'N')='N'

		if @@error <> 0
			goto error


		INSERT INTO FinancialActivityLinesFlagged (
			FinancialActivityLineId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			)
		VALUES (
			@FinancialActivityLineId
			,@UserCode
			,@CurrentDate
			,@UserCode
			,@CurrentDate
			)

		IF @@error <> 0
			GOTO error
	END
	ELSE
	BEGIN
		UPDATE FinancialActivityLines
		SET CurrentVersion = @FinancialActivityVersion
			,Comment = @Comment
			,ModifiedBy = @UserCode
			,ModifiedDate = @CurrentDate
		WHERE FinancialActivityLineId = @FinancialActivityLineId

		IF @@error <> 0
			GOTO error
	END

	-- update comments on the charge by appending FinancialActivityLines.comment
	IF isnull(@Comment, '') <> ''
	BEGIN
		UPDATE Charges
		SET Comments = convert(VARCHAR(12), getdate(), 101) + ' - ' + @Comment + CHAR(13)  + isnull(Comments, '')
			,Flagged = @Flagged
		WHERE ChargeId = @ChargeId
	END

	--  08/10/2017	Ponnin	: updating ChargeStatus and StatusComments of Charges table. Why :For task #44 of AHN Customizations.
	IF (ISNULL(@ChargeStatus, -1) <> -1 OR ISNULL(@StatusComment, '') <> '')
	BEGIN
		UPDATE Charges
		SET ChargeStatus=@ChargeStatus, StatusComments = @StatusComment, StatusDate = getdate(),
			ModifiedBy = @UserCode, ModifiedDate = @CurrentDate
		WHERE ChargeId = @ChargeId

		IF (ISNULL(@ChargeStatus, -1) <> -1)
		BEGIN
				INSERT  INTO  ChargeStatusHistory
                ( ChargeId,
                  ChargeStatus,
				  StatusDate,
				  CreatedBy,
				  CreatedDate,
				  ModifiedBy,
				  ModifiedDate
				  )
				VALUES (@ChargeId
						,@ChargeStatus
						,GETDATE()
						,@UserCode
						,@CurrentDate
						,@UserCode
						,@CurrentDate)
		END
	END

END
ELSE -- Not a correction            
BEGIN
	IF isnull(@ERTransferPosting, 'N') = 'N'
	BEGIN
		--  Insert into Financial Activity Lines            
		INSERT INTO FinancialActivityLines (
			FinancialActivityId
			,ChargeId
			,CurrentVersion
			,Flagged
			,Comment
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			)
		VALUES (
			@FinancialActivityId
			,@ChargeId
			,1
			,NULL
			,@Comment
			,@UserCode
			,@CurrentDate
			,@UserCode
			,@CurrentDate
			)

		SET @FinancialActivityLineId = @@Identity

		IF @FinancialActivityLineId <= 0
		BEGIN
			------------------------------------------------------------  
			--raiserror 30001 'Failed creating financial activity line'  
			--Modified by: SWAPAN MOHAN   
			--Modified on: 4 July 2012  
			--Purpose: For implementing the Customizable Message Codes.   
			--The Function Ssf_GetMesageByMessageCode(Screenid,MessageCode,OriginalText) will return NVARCHAR(MAX) value.  
			SET @ERROR = dbo.Ssf_GetMesageByMessageCode(29, 'FAILEDCREATELINE_SSP', 'Failed creating financial activity line')

		RAISERROR (@ERROR,16,1) 

			------------------------------------------------------------              
			GOTO error
		END
	END

	SET @FinancialActivityVersion = 1

	-- Insert Flagged Activity Line            
	IF (
			@Flagged = 'Y'
			OR (
				@Payment = 0
				AND isnull(@Adjustment1, 0) = 0
				AND isnull(@Transfer1, 0) = 0
				)
			) -- OR condition added by Bhupinder Bajwa 19 Dec 2006 REF Task #94            
	BEGIN
		INSERT INTO FinancialActivityLinesFlagged (
			FinancialActivityLineId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			)
		VALUES (
			@FinancialActivityLineId
			,@UserCode
			,@CurrentDate
			,@UserCode
			,@CurrentDate
			)

		IF @@error <> 0
			GOTO error
	END

	-- update comments on the charge by appending FinancialActivityLines.comment
	IF isnull(@Comment, '') <> ''
	BEGIN
		UPDATE Charges
		SET Comments = convert(VARCHAR(12), getdate(), 101) + ' - ' + @Comment + CHAR(13)  + isnull(Comments, '')
			,Flagged = @Flagged
		WHERE ChargeId = @ChargeId
	END

	--  08/10/2017	Ponnin	: updating ChargeStatus and StatusComments of Charges table. Why :For task #44 of AHN Customizations.
	IF (ISNULL(@ChargeStatus, -1) <> -1 OR ISNULL(@StatusComment, '') <> '')
	BEGIN
		UPDATE Charges
		SET ChargeStatus=@ChargeStatus, StatusComments = @StatusComment, StatusDate = getdate(),
		ModifiedBy = @UserCode, ModifiedDate = @CurrentDate
		WHERE ChargeId = @ChargeId

			IF (ISNULL(@ChargeStatus, -1) <> -1)
			BEGIN
				INSERT  INTO  ChargeStatusHistory
                ( ChargeId,
                  ChargeStatus,
				  StatusDate,
				  CreatedBy,
				  CreatedDate,
				  ModifiedBy,
				  ModifiedDate
				  )
				VALUES (@ChargeId
						,@ChargeStatus
						,GETDATE()
						,@UserCode
						,@CurrentDate
						,@UserCode
						,@CurrentDate)
			END
	END
END

-- Calculate the amount of original payment            
IF @FinancialActivityVersion > 1
BEGIN
	SELECT @OriginalPayment = - Amount
	FROM ARLedger
	WHERE FinancialActivityLineId = @FinancialActivityLineId
		AND FinancialActivityVersion = @FinancialActivityVersion - 1
		AND ChargeId = @ChargeId
		AND isnull(MarkedAsError, 'N') = 'Y'
		AND PaymentId = @PaymentId -- Bhupinder Bajwa REF Task # 325           

	IF @@error <> 0
		GOTO error
END

-- Payment/Adjustment Posting Logic            
-- Post Payment            
IF @Payment IS NOT NULL
BEGIN
	INSERT INTO ARLedger (
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
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		)
	VALUES (
		@ChargeId
		,@FinancialActivityLineId
		,@FinancialActivityVersion
		,4202
		,- @Payment
		,@PaymentId
		,NULL
		,@PostedAccountingPeriodId
		,@CurrentDate
		,@ClientId
		,@CoveragePlanId
		,@DateOfService
		,@UserCode
		,@CurrentDate
		,@UserCode
		,@CurrentDate
		)

	IF @@error <> 0
		GOTO error
END

IF isnull(@Payment, 0) <> 0
	OR isnull(@OriginalPayment, 0) <> 0
BEGIN
	UPDATE Payments
	SET UnpostedAmount = UnpostedAmount - isnull(@Payment, 0) + isnull(@OriginalPayment, 0)
		,ModifiedBy = @UserCode
		,ModifiedDate = @CurrentDate
	WHERE Paymentid = @PaymentId

	IF @@error <> 0
		GOTO error
END

-- Post Adjustments            
IF @Adjustment1 <> 0
BEGIN
	INSERT INTO ARLedger (
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
	VALUES (
		@ChargeId
		,@FinancialActivityLineId
		,@FinancialActivityVersion
		,4203
		,- @Adjustment1
		,NULL
		,@AdjustmentCode1
		,@PostedAccountingPeriodId
		,@CurrentDate
		,@ClientId
		,@CoveragePlanId
		,@DateOfService
		,NULL
		,@UserCode
		,@CurrentDate
		,@UserCode
		,@CurrentDate
		)

	IF @@error <> 0
		GOTO error
END

IF @Adjustment2 <> 0
BEGIN
	INSERT INTO ARLedger (
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
	VALUES (
		@ChargeId
		,@FinancialActivityLineId
		,@FinancialActivityVersion
		,4203
		,- @Adjustment2
		,NULL
		,@AdjustmentCode2
		,@PostedAccountingPeriodId
		,@CurrentDate
		,@ClientId
		,@CoveragePlanId
		,@DateOfService
		,NULL
		,@UserCode
		,@CurrentDate
		,@UserCode
		,@CurrentDate
		)

	IF @@error <> 0
		GOTO error
END

IF @Adjustment3 <> 0
BEGIN
	INSERT INTO ARLedger (
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
	VALUES (
		@ChargeId
		,@FinancialActivityLineId
		,@FinancialActivityVersion
		,4203
		,- @Adjustment3
		,NULL
		,@AdjustmentCode3
		,@PostedAccountingPeriodId
		,@CurrentDate
		,@ClientId
		,@CoveragePlanId
		,@DateOfService
		,NULL
		,@UserCode
		,@CurrentDate
		,@UserCode
		,@CurrentDate
		)

	IF @@error <> 0
		GOTO error
END

IF @Adjustment4 <> 0
BEGIN
	INSERT INTO ARLedger (
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
	VALUES (
		@ChargeId
		,@FinancialActivityLineId
		,@FinancialActivityVersion
		,4203
		,- @Adjustment4
		,NULL
		,@AdjustmentCode4
		,@PostedAccountingPeriodId
		,@CurrentDate
		,@ClientId
		,@CoveragePlanId
		,@DateOfService
		,NULL
		,@UserCode
		,@CurrentDate
		,@UserCode
		,@CurrentDate
		)

	IF @@error <> 0
		GOTO error
END

-- Post Transfers     
----For Transfer1  
DECLARE @TransferToChargeId INT

IF (@ClientCopay1 > 0)
BEGIN
	SET @TransferToChargeId = NULL

	--Check if charge already exists  
	--Create one if one doesn't exist for a client.@TransferTo1 is passed null.Since,creating a charge for client.   
	EXEC ssp_PMCreateCharge @UserCode
		,@ServiceId
		,@DateOfService
		,NULL
		,@TransferToChargeId OUTPUT
		
--shivanand
	IF @TransferToChargeId IS NOT NULL
	   	EXEC ssp_UpdateBillingCodesForSecondaryCharge @TransferToChargeId		
		
END

DECLARE @GCLedgerTypeTransfer INT

SET @GCLedgerTypeTransfer = 4204 -- required to update in ARLedger table         

IF @@error <> 0
	GOTO error

-- Insert Into ARLedger table (2nd entry for Transfer with Positive Copay Amount & CoveragePlanId as null. Means for this copay amount client is payer)      for Transfer1  
-- Added @ClientCopay condition        
IF isnull(@ClientCopay1, 0) <> 0
	AND @Transfer1 > @ClientCopay1
BEGIN
	INSERT INTO ARLedger (
		FinancialActivityLineId
		,ChargeId
		,LedgerType
		,Amount
		,AccountingPeriodId
		,FinancialActivityVersion
		,PostedDate
		,CoveragePlanId
		,ClientId
		,DateOfService
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		, AdjustmentCode
		)
	VALUES (
		@FinancialActivityLineId
		,@TransferToChargeId
		,@GCLedgerTypeTransfer
		,@ClientCopay1
		,@PostedAccountingPeriodId
		,@FinancialActivityVersion
		,@CurrentDate
		,NULL
		,@ClientId
		,@DateOfService
		,@UserCode
		,@CurrentDate
		,@UserCode
		,@CurrentDate
		,@CoPayAdjustmentCode
		)
END

IF (@Transfer1 <> 0)
BEGIN
	SET @TransferToChargeId = NULL

	-- Check if Charge already exists            
	-- Create one if one doesn't exist       
	EXEC ssp_PMCreateCharge @UserCode
		,@ServiceId
		,@DateOfService
		,@TransferTo1
		,@TransferToChargeId OUTPUT
		
		
--shivanand
	if @TransferToChargeId IS NOT NULL
	   	EXEC ssp_UpdateBillingCodesForSecondaryCharge @TransferToChargeId 		

	IF @@error <> 0
		GOTO error

	IF @DoNotBill1 = 'Y'
	BEGIN
		UPDATE Charges
		SET DoNotBill = 'Y'
		WHERE ChargeId = @TransferToChargeId

		IF @@error <> 0
			GOTO error
	END

	-- Insert Ledgers for the current charge            
	INSERT INTO ARLedger (
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
	VALUES (
		@ChargeId
		,@FinancialActivityLineId
		,@FinancialActivityVersion
		,4204
		,- @Transfer1
		,NULL
		,@TransferCode1
		,@PostedAccountingPeriodId
		,@CurrentDate
		,@ClientId
		,@CoveragePlanId
		,@DateOfService
		,NULL
		,@UserCode
		,@CurrentDate
		,@UserCode
		,@CurrentDate
		)

	IF @@error <> 0
		GOTO error

	-- Insert Ledgers for the transfer to charge            
	IF @TransferTo1 IS NULL
		INSERT INTO ARLedger (
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
		VALUES (
			@TransferToChargeId
			,@FinancialActivityLineId
			,@FinancialActivityVersion
			,4204
			,@Transfer1
			,NULL
			,@TransferCode1
			,@PostedAccountingPeriodId
			,@CurrentDate
			,@ClientId
			,NULL
			,@DateOfService
			,NULL
			,@UserCode
			,@CurrentDate
			,@UserCode
			,@CurrentDate
			)
	ELSE --To check whether transfer1 money is 0 and apply copay only if there is a copy on transfer1 cov plan all other checks are applied initially   
		INSERT INTO ARLedger (
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
		SELECT @TransferToChargeId
			,@FinancialActivityLineId
			,@FinancialActivityVersion
			,4204
			,CASE 
				WHEN @Transfer1 = @ClientCopay1
					THEN @Transfer1
				ELSE @Transfer1 - ISNULL(NULLIF(@ClientCopay1, 0), 0)
				END
			,NULL
			,@TransferCode1
			,@PostedAccountingPeriodId
			,@CurrentDate
			,@ClientId
			,CoveragePlanId
			,@DateOfService
			,NULL
			,@UserCode
			,@CurrentDate
			,@UserCode
			,@CurrentDate
		FROM ClientCoveragePlans
		WHERE ClientCoveragePlanId = @TransferTo1
			AND ISNULL(@Transfer1, 0) <> 0

	IF @@error <> 0
		GOTO error
END

--For Transfer2  
IF (@ClientCopay2 > 0)
BEGIN
	SET @TransferToChargeId = NULL

	--Check if charge already exists  
	--Create one if one doesn't exist for a client.@TransferTo2 is passed null.Since,creating a charge for client.   
	EXEC ssp_PMCreateCharge @UserCode
		,@ServiceId
		,@DateOfService
		,NULL
		,@TransferToChargeId OUTPUT
		

--shivanand
	IF @TransferToChargeId IS NOT NULL
	   	EXEC ssp_UpdateBillingCodesForSecondaryCharge @TransferToChargeId 		
		
END

SET @GCLedgerTypeTransfer = 4204 -- required to update in ARLedger table         

IF @@error <> 0
	GOTO error

-- Insert Into ARLedger table (2nd entry for Transfer with Positive Copay Amount & CoveragePlanId as null. Means for this copay amount client is payer)  for Transfer2      
-- Added @ClientCopay condition        
IF isnull(@ClientCopay2, 0) <> 0
	AND @Transfer2 > @ClientCopay2
BEGIN
	INSERT INTO ARLedger (
		FinancialActivityLineId
		,ChargeId
		,LedgerType
		,Amount
		,AccountingPeriodId
		,FinancialActivityVersion
		,PostedDate
		,CoveragePlanId
		,ClientId
		,DateOfService
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		, AdjustmentCode
		)
	VALUES (
		@FinancialActivityLineId
		,@TransferToChargeId
		,@GCLedgerTypeTransfer
		,@ClientCopay2
		,@PostedAccountingPeriodId
		,@FinancialActivityVersion
		,@CurrentDate
		,NULL
		,@ClientId
		,@DateOfService
		,@UserCode
		,@CurrentDate
		,@UserCode
		,@CurrentDate
		,@CoPayAdjustmentCode
		)
END

IF (@Transfer2 <> 0)
BEGIN
	SET @TransferToChargeId = NULL

	EXEC ssp_PMCreateCharge @UserCode
		,@ServiceId
		,@DateOfService
		,@TransferTo2
		,@TransferToChargeId OUTPUT
		
		
--shivanand
	if @TransferToChargeId IS NOT NULL
	   	EXEC ssp_UpdateBillingCodesForSecondaryCharge @TransferToChargeId 		

	IF @@error <> 0
		GOTO error

	IF @DoNotBill2 = 'Y'
	BEGIN
		UPDATE Charges
		SET DoNotBill = 'Y'
		WHERE ChargeId = @TransferToChargeId

		IF @@error <> 0
			GOTO error
	END

	INSERT INTO ARLedger (
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
	VALUES (
		@ChargeId
		,@FinancialActivityLineId
		,@FinancialActivityVersion
		,4204
		,- @Transfer2
		,NULL
		,@TransferCode2
		,@PostedAccountingPeriodId
		,@CurrentDate
		,@ClientId
		,@CoveragePlanId
		,@DateOfService
		,NULL
		,@UserCode
		,@CurrentDate
		,@UserCode
		,@CurrentDate
		)

	IF @@error <> 0
		GOTO error

	IF @TransferTo2 IS NULL
		INSERT INTO ARLedger (
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
		VALUES (
			@TransferToChargeId
			,@FinancialActivityLineId
			,@FinancialActivityVersion
			,4204
			,@Transfer2
			,NULL
			,@TransferCode2
			,@PostedAccountingPeriodId
			,@CurrentDate
			,@ClientId
			,NULL
			,@DateOfService
			,NULL
			,@UserCode
			,@CurrentDate
			,@UserCode
			,@CurrentDate
			)
	ELSE --To check whether transfer1 money is 0 and apply copay only if there is a copy on transfer2 cov plan all other checks are applied initially       
		INSERT INTO ARLedger (
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
		SELECT @TransferToChargeId
			,@FinancialActivityLineId
			,@FinancialActivityVersion
			,4204
			,CASE 
				WHEN @Transfer2 = @ClientCopay2
					THEN @Transfer2
				ELSE @Transfer2 - ISNULL(NULLIF(@ClientCopay2, 0), 0)
				END
			,NULL
			,@TransferCode2
			,@PostedAccountingPeriodId
			,@CurrentDate
			,@ClientId
			,CoveragePlanId
			,@DateOfService
			,NULL
			,@UserCode
			,@CurrentDate
			,@UserCode
			,@CurrentDate
		FROM ClientCoveragePlans
		WHERE ClientCoveragePlanId = @TransferTo2
			AND ISNULL(@Transfer2, 0) <> 0

	IF @@error <> 0
		GOTO error
END

--For Transfer3  
IF (@ClientCopay3 > 0)
BEGIN
	SET @TransferToChargeId = NULL

	--Check if charge already exists  
	--Create one if one doesn't exist for a client.@TransferTo3 is passed null.Since,creating a charge for client.   
	EXEC ssp_PMCreateCharge @UserCode
		,@ServiceId
		,@DateOfService
		,NULL
		,@TransferToChargeId OUTPUT

--shivanand
	IF @TransferToChargeId IS NOT NULL
	   	EXEC ssp_UpdateBillingCodesForSecondaryCharge @TransferToChargeId 		
		
END

SET @GCLedgerTypeTransfer = 4204 -- required to update in ARLedger table         

IF @@error <> 0
	GOTO error

-- Insert Into ARLedger table (2nd entry for Transfer with Positive Copay Amount & CoveragePlanId as null. Means for this copay amount client is payer)      for Transfer3  
-- Added @ClientCopay condition        
IF isnull(@ClientCopay3, 0) <> 0
	AND @Transfer3 > @ClientCopay3
BEGIN
	INSERT INTO ARLedger (
		FinancialActivityLineId
		,ChargeId
		,LedgerType
		,Amount
		,AccountingPeriodId
		,FinancialActivityVersion
		,PostedDate
		,CoveragePlanId
		,ClientId
		,DateOfService
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		, AdjustmentCode
		)
	VALUES (
		@FinancialActivityLineId
		,@TransferToChargeId
		,@GCLedgerTypeTransfer
		,@ClientCopay3
		,@PostedAccountingPeriodId
		,@FinancialActivityVersion
		,@CurrentDate
		,NULL
		,@ClientId
		,@DateOfService
		,@UserCode
		,@CurrentDate
		,@UserCode
		,@CurrentDate
		,@CoPayAdjustmentCode
		)
END

IF (@Transfer3 <> 0)
BEGIN
	SET @TransferToChargeId = NULL

	EXEC ssp_PMCreateCharge @UserCode
		,@ServiceId
		,@DateOfService
		,@TransferTo3
		,@TransferToChargeId OUTPUT
		

--shivanand
	if @TransferToChargeId IS NOT NULL
	   	EXEC ssp_UpdateBillingCodesForSecondaryCharge @TransferToChargeId 		

	IF @@error <> 0
		GOTO error

	IF @DoNotBill3 = 'Y'
	BEGIN
		UPDATE Charges
		SET DoNotBill = 'Y'
		WHERE ChargeId = @TransferToChargeId

		IF @@error <> 0
			GOTO error
	END

	INSERT INTO ARLedger (
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
	VALUES (
		@ChargeId
		,@FinancialActivityLineId
		,@FinancialActivityVersion
		,4204
		,- @Transfer3
		,NULL
		,@TransferCode3
		,@PostedAccountingPeriodId
		,@CurrentDate
		,@ClientId
		,@CoveragePlanId
		,@DateOfService
		,NULL
		,@UserCode
		,@CurrentDate
		,@UserCode
		,@CurrentDate
		)

	IF @@error <> 0
		GOTO error

	IF @TransferTo3 IS NULL
		INSERT INTO ARLedger (
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
		VALUES (
			@TransferToChargeId
			,@FinancialActivityLineId
			,@FinancialActivityVersion
			,4204
			,@Transfer3
			,NULL
			,@TransferCode3
			,@PostedAccountingPeriodId
			,@CurrentDate
			,@ClientId
			,NULL
			,@DateOfService
			,NULL
			,@UserCode
			,@CurrentDate
			,@UserCode
			,@CurrentDate
			)
	ELSE --To check whether transfer3 money is 0 and apply copay only if there is a copy on transfer3 cov plan all other checks are applied initially  
		INSERT INTO ARLedger (
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
		SELECT @TransferToChargeId
			,@FinancialActivityLineId
			,@FinancialActivityVersion
			,4204
			,CASE 
				WHEN @Transfer3 = @ClientCopay3
					THEN @Transfer3
				ELSE @Transfer3 - ISNULL(NULLIF(@ClientCopay3, 0), 0)
				END
			,NULL
			,@TransferCode3
			,@PostedAccountingPeriodId
			,@CurrentDate
			,@ClientId
			,CoveragePlanId
			,@DateOfService
			,NULL
			,@UserCode
			,@CurrentDate
			,@UserCode
			,@CurrentDate
		FROM ClientCoveragePlans
		WHERE ClientCoveragePlanId = @TransferTo3
			AND ISNULL(@Transfer3, 0) <> 0

	IF @@error <> 0
		GOTO error
END

--For Transfer4  
IF (@ClientCopay4 > 0)
BEGIN
	SET @TransferToChargeId = NULL

	--Check if charge already exists  
	--Create one if one doesn't exist for a client.@TransferTo4 is passed null.Since,creating a charge for client.   
	EXEC ssp_PMCreateCharge @UserCode
		,@ServiceId
		,@DateOfService
		,NULL
		,@TransferToChargeId OUTPUT
		

--shivanand
	IF @TransferToChargeId IS NOT NULL
	   	EXEC ssp_UpdateBillingCodesForSecondaryCharge @TransferToChargeId 
	   			
END

SET @GCLedgerTypeTransfer = 4204 -- required to update in ARLedger table         

IF @@error <> 0
	GOTO error

-- Insert Into ARLedger table (2nd entry for Transfer with Positive Copay Amount & CoveragePlanId as null. Means for this copay amount client is payer)      for Transfer1  
-- Added @ClientCopay condition        
IF isnull(@ClientCopay4, 0) <> 0
	AND @Transfer4 > @ClientCopay4
BEGIN
	INSERT INTO ARLedger (
		FinancialActivityLineId
		,ChargeId
		,LedgerType
		,Amount
		,AccountingPeriodId
		,FinancialActivityVersion
		,PostedDate
		,CoveragePlanId
		,ClientId
		,DateOfService
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,AdjustmentCode
		)
	VALUES (
		@FinancialActivityLineId
		,@TransferToChargeId
		,@GCLedgerTypeTransfer
		,@ClientCopay4
		,@PostedAccountingPeriodId
		,@FinancialActivityVersion
		,@CurrentDate
		,NULL
		,@ClientId
		,@DateOfService
		,@UserCode
		,@CurrentDate
		,@UserCode
		,@CurrentDate
		,@CoPayAdjustmentCode
		)
END

IF (@Transfer4 <> 0)
BEGIN
	SET @TransferToChargeId = NULL

	EXEC ssp_PMCreateCharge @UserCode
		,@ServiceId
		,@DateOfService
		,@TransferTo4
		,@TransferToChargeId OUTPUT
		
--shivanand
	if @TransferToChargeId IS NOT NULL
	   	EXEC ssp_UpdateBillingCodesForSecondaryCharge @TransferToChargeId 
	   			

	IF @@error <> 0
		GOTO error

	IF @DoNotBill4 = 'Y'
	BEGIN
		UPDATE Charges
		SET DoNotBill = 'Y'
		WHERE ChargeId = @TransferToChargeId

		IF @@error <> 0
			GOTO error
	END

	INSERT INTO ARLedger (
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
	VALUES (
		@ChargeId
		,@FinancialActivityLineId
		,@FinancialActivityVersion
		,4204
		,- @Transfer4
		,NULL
		,@TransferCode4
		,@PostedAccountingPeriodId
		,@CurrentDate
		,@ClientId
		,@CoveragePlanId
		,@DateOfService
		,NULL
		,@UserCode
		,@CurrentDate
		,@UserCode
		,@CurrentDate
		)

	IF @@error <> 0
		GOTO error

	IF @TransferTo4 IS NULL
		INSERT INTO ARLedger (
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
		VALUES (
			@TransferToChargeId
			,@FinancialActivityLineId
			,@FinancialActivityVersion
			,4204
			,@Transfer4
			,NULL
			,@TransferCode4
			,@PostedAccountingPeriodId
			,@CurrentDate
			,@ClientId
			,NULL
			,@DateOfService
			,NULL
			,@UserCode
			,@CurrentDate
			,@UserCode
			,@CurrentDate
			)
	ELSE --To check whether transfer4 money is 0 and apply copay only if there is a copy on transfer4 cov plan all other checks are applied initially       
		INSERT INTO ARLedger (
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
		SELECT @TransferToChargeId
			,@FinancialActivityLineId
			,@FinancialActivityVersion
			,4204
			,CASE 
				WHEN @Transfer4 = @ClientCopay4
					THEN @Transfer4
				ELSE @Transfer4 - ISNULL(NULLIF(@ClientCopay4, 0), 0)
				END
			,NULL
			,@TransferCode4
			,@PostedAccountingPeriodId
			,@CurrentDate
			,@ClientId
			,CoveragePlanId
			,@DateOfService
			,NULL
			,@UserCode
			,@CurrentDate
			,@UserCode
			,@CurrentDate
		FROM ClientCoveragePlans
		WHERE ClientCoveragePlanId = @TransferTo4
			AND ISNULL(@Transfer4, 0) <> 0

	IF @@error <> 0
		GOTO error
END

-- Recalculate charge priorities     
IF ISNULL((
            SELECT  dbo.ssf_GetSystemConfigurationKeyValue('RecalculateChargePriorityWhenPostingToARLedger')
          ), 'N') = 'Y' 
   BEGIN     
         EXEC ssp_SCRecalculateChargePriorities @ServiceId = @ServiceId, @UserCode = @UserCode
   END

-- Recalculate Open Charges            
-- Delete Open Charges for updated charges            
DELETE b
FROM ARLedger a
JOIN OpenCharges b ON (a.ChargeId = b.ChargeId)
WHERE a.FinancialActivityLineId = @FinancialActivityLineId
	AND a.FinancialActivityVersion IN (
		@FinancialActivityVersion
		,@FinancialActivityVersion - 1
		)

IF @@error <> 0
	GOTO error

-- Create Open Charges for updated charges            
INSERT INTO OpenCharges (
	ChargeId
	,Balance
	,CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	)
SELECT a.ChargeId
	,sum(a.Amount)
	,@UserCode
	,@CurrentDate
	,@UserCode
	,@CurrentDate
FROM ARledger a
WHERE EXISTS (
		SELECT *
		FROM ARLedger b
		WHERE b.FinancialActivityLineId = @FinancialActivityLineId
			AND b.FinancialActivityVersion IN (
				@FinancialActivityVersion
				,@FinancialActivityVersion - 1
				)
			AND a.ChargeId = b.ChargeId
		)
GROUP BY a.ChargeId
HAVING sum(a.Amount) <> 0

IF @@error <> 0
	GOTO error

--  08/10/2017	Ponnin	: Updating ChargeStatus as 'paid' if the chargeamount is <= 0. Why :For task #44 of AHN Customizations.
	DECLARE @TotalChargeAmount MONEY

	  SELECT  @TotalChargeAmount = SUM(ar.Amount)
        FROM    Services s
                JOIN Charges c ON c.ServiceId = s.ServiceId
                JOIN ARLedger ar ON ar.ChargeId = c.ChargeId
        WHERE   c.ChargeId = @ChargeId
                AND ISNULL(ar.RecordDeleted, 'N') = 'N'
                AND ISNULL(s.RecordDeleted, 'N') = 'N'
                AND ISNULL(c.RecordDeleted, 'N') = 'N'

				IF (@TotalChargeAmount <= 0)
				BEGIN
				UPDATE Charges
				SET ChargeStatus=9456, StatusDate = getdate(), ModifiedBy = @UserCode, ModifiedDate = @CurrentDate
				WHERE ChargeId = @ChargeId

				INSERT  INTO  ChargeStatusHistory
                ( ChargeId,
                  ChargeStatus,
				  StatusDate,
				  CreatedBy,
				  CreatedDate,
				  ModifiedBy,
				  ModifiedDate
				  )
				VALUES (@ChargeId
						,9456 -- Paid
						,GETDATE()
						,@UserCode
						,@CurrentDate
						,@UserCode
						,@CurrentDate)
				END


---- Client Balance Change            
--DECLARE @ClientBalanceChange MONEY
EXEC ssp_SCCalculateClientBalance @ClientId = @ClientId -- int

---- Only include error correction and new ledgers (non payment)            
---- to compute the change in client balance            
--SELECT @ClientBalanceChange = sum(Amount)
--FROM ARLedger
--WHERE FinancialActivityLineId = @FinancialActivityLineId
--	AND FinancialActivityVersion IN (
--		@FinancialActivityVersion
--		,@FinancialActivityVersion - 1
--		)
--	AND CoveragePlanId IS NULL
--	AND LedgerType <> 4202 -- Exclude Payment            
--	AND isnull(MarkedAsError, 'N') = 'N'

IF @@error <> 0
	GOTO error

--IF isnull(@ClientBalanceChange, 0) <> 0
--BEGIN
--	UPDATE Clients
--	SET CurrentBalance = isnull(CurrentBalance, 0) + isnull(@ClientBalanceChange, 0)
--	WHERE ClientId = @ClientId

--	IF @@error <> 0
--		GOTO error
--END

RETURN 0

error:

RETURN - 1

GO


