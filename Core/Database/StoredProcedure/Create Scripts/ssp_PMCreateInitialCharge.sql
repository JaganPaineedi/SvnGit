IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   name = 'ssp_PMCreateInitialCharge'
                    AND type = 'P' ) 
    DROP PROCEDURE dbo.ssp_PMCreateInitialCharge
GO



SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[ssp_PMCreateInitialCharge]
    @UserCode VARCHAR(30)
  , @ServiceId INT
AS /*********************************************************************
-- Stored Procedure: dbo.ssp_PMCreateInitialCharge
-- Creation Date:    10/26/2006
--                             
-- Purpose:  This procedure is called from Service Details when service status becomes complete
--                                                  
-- Updates:                                         
-- Date        Author          Purpose                  
-- 10/26/2006  Bhupinder Bajwa Created          
-- 06/08/2012  Saurav Pande    Modified with ref. to Task# 1702 in PM Web Bugs to Get modifiers from procedure rates    
-- 07/03/2012  J. Hussain      Added AlwaysCreateClientChargeOnServiceCompletion logic    
-- 08/14/2012  J. Hussain      Changed amount datatypes to decimal(18,2) to implement implicit rounding.
-- 11/02/2012  Jagdeep Hundal  Modify check nullif(Charge,0) to isnull(Charge,0) and if (isnull(@ChargeAmount,0)-isnull(@ClientCopay,0)>0) to if (isnull(@ChargeAmount,0)-isnull(@ClientCopay,0)>=0) for inserting values in OpenCharges table for $0 charge service as per task #12-5 IG: PM: Ability to bill $0 charge on an 837     Interact Development Implementation
-- 01/10/2013  SFarber         Defaulted AlwaysCreateClientChargeOnServiceCompletion to 'N'
-- 27/03/2013  Ponnin			Updating billing code, modifiers and units to the charge by adding #ClaimLines. For 3.5x Issues of Task #278
-- 13-06-2013  Javed			Included the condition to avoid charge calculation if the Service is non billable
-- 06/17/2013  SFarber         Replaced '@ChargeAmount is not null' with 'isnull(@ChargeAmount, 0) <> 0'
-- 10/13/2014  NJain		   Added ssp for creating Add On Charges
-- 03/28/2016  jcarlson		   added in setting of adjustment code for client copayment transfer, based on systemconfiguration key "ClientCoPaymentAdjustmentCode"
-- 03/28/2016  jcarlson		   when updating clients.currentbalance, changed logic to use core ssp_SCCalculateClientBalance
-- 05/20/2016  Dknewtson       Added chargeId column to #ClaimLines for charge billing code override logic.
-- 08/30/2016  Dknewtson	   Moved insert into Financial Activity Lines for Copayment transfers to prior to the first transfer record in the AR Ledger.
-- 08/10/2017  Ponnin		   To update ChargeStatus as 'Charge Created' on creation of charge and updating ChargeStatus history as well. Why :For task #44 of AHN Customizations.
-- 12/06/2018  BobB	(@Denton)  (Approved by dknewtson) Changed table #ClaimLines ClaimUnits from Int to decimal(10,2).  This caused fractional units from the Procedure Code Rate table from being set correctly. Texas - Go Live Build Issues 416
*********************************************************************/ 
    DECLARE @CurrentDate DATETIME    
    DECLARE @Priority INT    
    DECLARE @COBOrder INT    
    DECLARE @FinancialActivityId INT    
    DECLARE @FinancialActivityLineId INT    
    DECLARE @CoveragePlanId INT     
    DECLARE @ClientCoveragePlanId INT     
    DECLARE @ProcedureCodeId INT    
    DECLARE @ClientId INT
      , @ChargeId INT
      , @ClinicianId INT
      , @DateOfService DATETIME
      , @EndDate DATETIME    
    DECLARE @ChargeAmount DECIMAL(18 , 2)
      , @ClientCopay DECIMAL(18 , 2)    
    DECLARE @AlwaysCreateClientChargeOnServiceCompletion CHAR(1) 
    DECLARE @ChargeAccountingPeriodByDateOfService CHAR(1)
    DECLARE @Billable CHAR(1)

    DECLARE @CoPayAdjustmentCode INT
    SELECT  @CoPayAdjustmentCode = CONVERT(INT , Value)
    FROM    dbo.SystemConfigurationKeys sck
    WHERE   ISNULL(sck.RecordDeleted , 'N') = 'N'
            AND sck.[Key] = 'ClientCoPaymentAdjustmentCode'
   
    DECLARE @CurrentAccountingPeriodId INT    
    DECLARE @FinancialActivityVersion INT    
    
-- Added w.r.f to task 1702 in PM Web Bugs to insert modifiers in charges table    
    DECLARE @ProcedureRateId AS INT    
    DECLARE @Modifier1 AS VARCHAR(10)    
    DECLARE @Modifier2 AS VARCHAR(10)    
    DECLARE @Modifier3 AS VARCHAR(10)    
    DECLARE @Modifier4 AS VARCHAR(10)    
    DECLARE @BillingCodeUnits DECIMAL    
    DECLARE @BillingCode VARCHAR(25)    
    DECLARE @RevenueCode VARCHAR(10)    
    DECLARE @RevenueCodeDescription VARCHAR(100)    
-- Chnages end here     
    DECLARE @ServiceUnits DECIMAL
    DECLARE @GCActivityTypeServiceComplete INT
      , @GCLedgerTypeCharge INT
      , @GCLedgerTypeTransfer INT    
    
    SET @GCActivityTypeServiceComplete = 4321       -- required to update in FinancialActivities table    
    SET @GCLedgerTypeCharge = 4201                                       -- required to update in ARLedger table    
    SET @GCLedgerTypeTransfer = 4204                                       -- required to update in ARLedger table    
    SET @FinancialActivityVersion = 1    
    SET @CoveragePlanId = NULL    
    SET @ClientCoveragePlanId = NULL    
    SELECT  @CurrentDate = GETDATE()    


----- Added By Ponnin - Starts Here
--SELECT @ServiceUnits= Unit FROM Services where ServiceId=@ServiceId
-----------------------------
    CREATE TABLE #ClaimLines
        (
          ClaimLineId INT NOT NULL ,
          ChargeId INT NULL ,
          CoveragePlanId INT NOT NULL ,
          ServiceId INT NULL ,
          ServiceUnits DECIMAL(10, 2) NULL ,
          BillingCode VARCHAR(25) NULL ,
          Modifier1 VARCHAR(10) NULL ,
          Modifier2 VARCHAR(10) NULL ,
          Modifier3 VARCHAR(10) NULL ,
          Modifier4 VARCHAR(10) NULL ,
          RevenueCode VARCHAR(25) NULL ,
          RevenueCodeDescription VARCHAR(1000) NULL ,
		  ClaimUnits decimal(10, 2) NULL
        )
----- Changes By Ponnin - Ends Here


-- fetch clientId, startDate & EndDate    
    SELECT  @ClientId = ClientId
          , @ProcedureCodeId = ProcedureCodeId
          , @DateOfService = DateOfService
          , @EndDate = EndDateOfService
          , @ClinicianId = ClinicianId
          ,    
 --@ChargeAmount = nullif(Charge,0),@ProcedureRateId = ProcedureRateId  from Services where ServiceId=@ServiceId    
            @ChargeAmount = ISNULL(Charge , 0)
          , @ProcedureRateId = ProcedureRateId
          , @ServiceUnits = Unit
          , @Billable = Billable
    FROM    Services
    WHERE   ServiceId = @ServiceId
 
    
    IF @@error <> 0
        GOTO error  

-- If non billable service then return
    IF ISNULL(@Billable, 'N') = 'N'
        RETURN

-- fetch the first billable plan    
    EXEC ssp_PMGetNextBillablePayer @ClientId, @ServiceId, @DateOfService, @ProcedureCodeId, @ClinicianId, NULL, @NextClientCoveragePlanId = @ClientCoveragePlanId OUTPUT    
    
    IF @@error <> 0
        GOTO error    
    
-- fetch the value for ClientCopay    
    CREATE TABLE #ClientCopay ( Copay DECIMAL(18, 2) )    
    INSERT  INTO #ClientCopay
            EXEC ssp_PMCalculateCopay @ServiceId, @ClientCoveragePlanId, 'Y'    
    
    SELECT  @ClientCopay = NULLIF(Copay, 0)
    FROM    #ClientCopay    
    
    IF @@error <> 0
        GOTO error    
    
-- JHB 3/22/07    
-- If Client Copay is calculated to be greater than charge amount    
-- then it should be set to the charge amount    
    IF @ClientCopay > @ChargeAmount
        SET @ClientCopay = @ChargeAmount    
     
    IF @@error <> 0
        GOTO error    
    
-- JHB 7/3/2012 Added @AlwaysCreateClientChargeOnServiceCompletion logic    
    SELECT  @ChargeAccountingPeriodByDateOfService = ISNULL(ChargeAccountingPeriodByDateOfService, 'N')
    FROM    SystemConfigurations    
    
    IF @@error <> 0
        GOTO error     
    
 
    IF @ChargeAccountingPeriodByDateOfService = 'Y'
        BEGIN    
    
            SELECT TOP 1
                    @CurrentAccountingPeriodId = AccountingPeriodId
            FROM    AccountingPeriods
            WHERE   DATEADD(dd, 1, EndDate) > @DateOfService
                    AND OpenPeriod = 'Y'
            ORDER BY StartDate    
    
        END    
    ELSE
        BEGIN    
    
            SELECT  @CurrentAccountingPeriodId = AccountingPeriodId
            FROM    AccountingPeriods
            WHERE   StartDate <= @CurrentDate
                    AND DATEADD(dd, 1, EndDate) > @CurrentDate    
    
    
        END    
    
    IF @@error <> 0
        GOTO error    
    
    
-- Determine priority    
    IF @ClientCoveragePlanId IS NULL
        SET @Priority = 0    
    ELSE
        BEGIN    
            SET @Priority = 1    
 -- retreive CoveragePlanId from ClientCoveragePlans. CoveragePlanId field is updated in FinancialActivities & ARLedger table    
            SELECT  @CoveragePlanId = CoveragePlanId
            FROM    ClientCoveragePlans
            WHERE   ClientCoveragePlanId = @ClientCoveragePlanId     
        END    
    BEGIN TRAN    
    
    BEGIN    
--Modified by saurav Pande on 8th June 2012 with ref. to Task# 1702 in PM Web Bugs to modifiers into Charges table    
 -- Create New Charge    
        INSERT  INTO Charges
                ( ServiceId
                , ClientCoveragePlanId
                , Priority
                , ClientCopay
                , CreatedBy
                , CreatedDate
                , ModifiedBy
                , ModifiedDate
                , Modifier1
                , Modifier2
                , Modifier3
                , Modifier4
                , BillingCode
                , Units
                , RevenueCode
                , RevenueCodeDescription
                 -- Added by ponnin. For task #44 of AHN-Customizations
                , ChargeStatus
                , StatusDate
                )
        VALUES  ( @ServiceId
                , @ClientCoveragePlanId
                , @Priority
                , @ClientCopay
                , @UserCode
                , @CurrentDate
                , @UserCode
                , @CurrentDate
                , @Modifier1
                , @Modifier2
                , @Modifier3
                , @Modifier4
                , @BillingCode
                , @BillingCodeUnits
                , @RevenueCode
                , @RevenueCodeDescription
                 -- Added by ponnin. For task #44 of AHN-Customizations
                , 9454 -- Charge Created
                , getdate()
                )    
                
            
     
        SET @ChargeId = @@Identity    
        IF @ChargeId <= 0
            BEGIN
		------------------------------------------------------------
	    --raiserror 30001 'Charge creation failed'
		--Modified by: SWAPAN MOHAN 
		--Modified on: 4 July 2012
		--Purpose: For implementing the Customizable Message Codes. 
		--The Function Ssf_GetMesageByMessageCode(Screenid,MessageCode,OriginalText) will return NVARCHAR(MAX) value.
                DECLARE @ERROR NVARCHAR(MAX)
                SET @ERROR = ( SELECT   dbo.Ssf_GetMesageByMessageCode(29 , 'CHARGECREATIONFAILED_SSP' , 'Charge creation failed') )
                RAISERROR(@ERROR,16,1)
------------------------------------------------------------
                GOTO error
            END  
     
 -- JHB 7/3/2012 Added @AlwaysCreateClientChargeOnServiceCompletion logic    
        SELECT  @AlwaysCreateClientChargeOnServiceCompletion = ISNULL(AlwaysCreateClientChargeOnServiceCompletion, 'N')
        FROM    SystemConfigurations    
    
        IF @@error <> 0
            GOTO error    
    
	 -- Added by ponnin: To update the ChargeStatus History. For task #44 of AHN-Customizations
    -- Update the chargeStatus History
        INSERT  INTO  ChargeStatusHistory
                ( ChargeId,
                  ChargeStatus,
				  StatusDate
				  )
				Values (@ChargeId
						,9454 -- Charge Created
						,getdate())
                
----- Added By Ponnin - Starts Here
        IF ( @ChargeId > 0
             AND @CoveragePlanId IS NOT NULL
           )
            BEGIN
    
                DELETE  FROM #ClaimLines

                INSERT  INTO #ClaimLines
                        ( ClaimLineId ,
                          ChargeId ,
                          CoveragePlanId ,
                          ServiceId ,
                          ServiceUnits
                        )
                VALUES  ( @ChargeId ,
                          @ChargeId ,
                          @CoveragePlanId ,
                          @ServiceId ,
                          @ServiceUnits
                        )

		-- calculate Get Billing Code/Units
                EXEC ssp_PMClaimsGetBillingCodes
		
		--select * from #ClaimLines
                UPDATE  a
                SET     BillingCode = b.BillingCode
                      , Modifier1 = b.Modifier1
                      , Modifier2 = b.Modifier2
                      , Modifier3 = b.Modifier3
                      , Modifier4 = b.Modifier4
                      , RevenueCode = b.RevenueCode
                      , RevenueCodeDescription = b.RevenueCodeDescription
                      , Units = b.ClaimUnits
                FROM    Charges a
                        JOIN #ClaimLines b ON a.ChargeId = b.ClaimLineId
                DELETE  FROM #ClaimLines
            END
----- Changes By Ponnin - Ends Here

    
 -- If charge always needs to be created treat the process as if there is 0 copay to be collected upfront    
        IF @AlwaysCreateClientChargeOnServiceCompletion = 'Y'
            AND @ClientCopay IS NULL
            AND @ClientCoveragePlanId IS NOT NULL
            SET @ClientCopay = 0    
      
        IF @ClientCopay IS NULL  -- Without Copay    
            BEGIN    
  -- Insert Into FinancialActivities    
                INSERT  INTO FinancialActivities
                        ( CoveragePlanId
                        , ClientId
                        , ActivityType
                        , CreatedBy
                        , CreatedDate
                        , ModifiedBy
                        , ModifiedDate
                        )
                VALUES  ( @CoveragePlanId
                        , CASE WHEN @ClientCoveragePlanId IS NULL THEN @ClientId
                               ELSE NULL
                          END
                        , @GCActivityTypeServiceComplete
                        , @UserCode
                        , @CurrentDate
                        , @UserCode
                        , @CurrentDate
                        )      
                IF @@error <> 0
                    GOTO error    
      
                SET @FinancialActivityId = @@identity    
      
      
  -- Insert Into FinancialActivityLines table    
                INSERT  INTO FinancialActivityLines
                        ( FinancialActivityId
                        , ChargeId
                        , CurrentVersion
                        , CreatedBy
                        , CreatedDate
                        , ModifiedBy
                        , ModifiedDate
                        )
                VALUES  ( @FinancialActivityId
                        , @ChargeId
                        , @FinancialActivityVersion
                        , @UserCode
                        , @CurrentDate
                        , @UserCode
                        , @CurrentDate
                        )    
      
                IF @@error <> 0
                    GOTO error    
      
                SET @FinancialActivityLineId = @@identity    
      
  -- Insert Into ARLedger table    
                INSERT  INTO ARLedger
                        ( FinancialActivityLineId
                        , ChargeId
                        , LedgerType
                        , Amount
                        , AccountingPeriodId
                        , FinancialActivityVersion
                        , PostedDate
                        , CoveragePlanId
                        , ClientId
                        , DateOfService
                        , CreatedBy
                        , CreatedDate
                        , ModifiedBy
                        , ModifiedDate
                        )
                VALUES  ( @FinancialActivityLineId
                        , @ChargeId
                        , @GCLedgerTypeCharge
                        , ISNULL(@ChargeAmount , 0)
                        , @CurrentAccountingPeriodId
                        , @FinancialActivityVersion
                        , @CurrentDate
                        , @CoveragePlanId
                        , @ClientId
                        , @DateOfService
                        , @UserCode
                        , @CurrentDate
                        , @UserCode
                        , @CurrentDate
                        )    
      
                IF @@error <> 0
                    GOTO error    
      
  -- Insert Into OpenCharges table    
                IF ( ISNULL(@ChargeAmount, 0) <> 0 )
                    BEGIN    
                        INSERT  INTO OpenCharges
                                ( ChargeId
                                , Balance
                                , CreatedBy
                                , CreatedDate
                                , ModifiedBy
                                , ModifiedDate
                                )
                        VALUES  ( @ChargeId
                                , @ChargeAmount
                                , @UserCode
                                , @CurrentDate
                                , @UserCode
                                , @CurrentDate
                                )    
      
                        IF @@error <> 0
                            GOTO error    
       
   -- Update Client Balance for Client Charge    
                        IF ( @ClientCoveragePlanId IS NULL )
                            BEGIN    
                            --jcarlson 3/28/2016
                                EXEC ssp_SCCalculateClientBalance @ClientId = @ClientId -- int                             
                            END    
       
                    END    
    
            END    
    
        ELSE     -- With Copay    
            BEGIN    
  -- Insert Into FinancialActivities    
                INSERT  INTO FinancialActivities
                        ( CoveragePlanId
                        , ClientId
                        , ActivityType
                        , CreatedBy
                        , CreatedDate
                        , ModifiedBy
                        , ModifiedDate
                        )
                VALUES  ( @CoveragePlanId
                        , @ClientId
                        , @GCActivityTypeServiceComplete
                        , @UserCode
                        , @CurrentDate
                        , @UserCode
                        , @CurrentDate
                        )    
      
                IF @@error <> 0
                    GOTO error    
      
                SET @FinancialActivityId = @@identity    
      
  -- Start of block to Insert records into FinancialAcitivityLines, ARLedger & OpenCharges table for 1st Charge Entry    
      
  -- Insert Into FinancialActivityLines table (for 1st Charge Entry)    
                INSERT  INTO FinancialActivityLines
                        ( FinancialActivityId
                        , ChargeId
                        , CurrentVersion
                        , CreatedBy
                        , CreatedDate
                        , ModifiedBy
                        , ModifiedDate
                        )
                VALUES  ( @FinancialActivityId
                        , @ChargeId
                        , @FinancialActivityVersion
                        , @UserCode
                        , @CurrentDate
                        , @UserCode
                        , @CurrentDate
                        )    
      
                IF @@error <> 0
                    GOTO error    
      
                SET @FinancialActivityLineId = @@identity    
      
  -- Insert Into ARLedger table (1st entry for Charge)    
                INSERT  INTO ARLedger
                        ( FinancialActivityLineId
                        , ChargeId
                        , LedgerType
                        , Amount
                        , AccountingPeriodId
                        , FinancialActivityVersion
                        , PostedDate
                        , CoveragePlanId
                        , ClientId
                        , DateOfService
                        , CreatedBy
                        , CreatedDate
                        , ModifiedBy
                        , ModifiedDate
                        )
                VALUES  ( @FinancialActivityLineId
                        , @ChargeId
                        , @GCLedgerTypeCharge
                        , ISNULL(@ChargeAmount , 0)
                        , @CurrentAccountingPeriodId
                        , @FinancialActivityVersion
                        , @CurrentDate
                        , @CoveragePlanId
                        , @ClientId
                        , @DateOfService
                        , @UserCode
                        , @CurrentDate
                        , @UserCode
                        , @CurrentDate
                        )    
      
                IF @@error <> 0
                    GOTO error    
      
  -- Insert Into ARLedger table (2nd entry for Transfer with Negative Copay Amount)    
      
  -- JHB 7/3/2012 Added @ClientCopay condition    
                IF ISNULL(@ClientCopay, 0) <> 0
                    BEGIN    

	  -- Insert Into FinancialActivityLines table (for Copayment Charge Entry)    
					INSERT  INTO FinancialActivityLines
							( FinancialActivityId
							, ChargeId
							, CurrentVersion
							, CreatedBy
							, CreatedDate
							, ModifiedBy
							, ModifiedDate
							)
					VALUES  ( @FinancialActivityId
							, @ChargeId
							, @FinancialActivityVersion
							, @UserCode
							, @CurrentDate
							, @UserCode
							, @CurrentDate
							)    
      
					IF @@error <> 0
						GOTO error    
      
					SET @FinancialActivityLineId = @@identity    
      
                        INSERT  INTO ARLedger
                                ( FinancialActivityLineId
                                , ChargeId
                                , LedgerType
                                , Amount
                                , AccountingPeriodId
                                , FinancialActivityVersion
                                , PostedDate
                                , CoveragePlanId
                                , ClientId
                                , DateOfService
                                , CreatedBy
                                , CreatedDate
                                , ModifiedBy
                                , ModifiedDate
                                , AdjustmentCode --jcarlson 3/28/2016
                                )
                        VALUES  ( @FinancialActivityLineId
                                , @ChargeId
                                , @GCLedgerTypeTransfer
                                , 0 - @ClientCopay
                                , @CurrentAccountingPeriodId
                                , @FinancialActivityVersion
                                , @CurrentDate
                                , @CoveragePlanId
                                , @ClientId
                                , @DateOfService
                                , @UserCode
                                , @CurrentDate
                                , @UserCode
                                , @CurrentDate
                                , @CoPayAdjustmentCode --jcarlson 3/28/2016
                                )    
      
                        IF @@error <> 0
                            GOTO error    
                    END    
    
  -- Insert Into OpenCharges table (with charge minus copay amount for 1st Charge Entry)    
                IF ( ISNULL(@ChargeAmount, 0) <> 0 )
                    BEGIN    
   --if (isnull(@ChargeAmount,0)-isnull(@ClientCopay,0)>0)        -- Insert into Opencharges only If difference is greater than zero    
                        IF ( ISNULL(@ChargeAmount, 0) - ISNULL(@ClientCopay, 0) > 0 )
                            BEGIN    
                                INSERT  INTO OpenCharges
                                        ( ChargeId
                                        , Balance
                                        , CreatedBy
                                        , CreatedDate
                                        , ModifiedBy
                                        , ModifiedDate
                                        )
                                VALUES  ( @ChargeId
                                        , ISNULL(@ChargeAmount , 0) - ISNULL(@ClientCopay , 0)
                                        , @UserCode
                                        , @CurrentDate
                                        , @UserCode
                                        , @CurrentDate
                                        )    
      
                                IF @@error <> 0
                                    GOTO error    
                            END    
                    END      
    
  -- Insert New row into Charge table    
  --Modified by saurav Pande on 8th June 2012 with ref. to Task# 1702 in PM Web Bugs to modifiers into Charges table    
                INSERT  INTO Charges
                        ( ServiceId
                        , ClientCoveragePlanId
                        , Priority
                        , ClientCopay
                        , CreatedBy
                        , CreatedDate
                        , ModifiedBy
                        , ModifiedDate
                        , Modifier1
                        , Modifier2
                        , Modifier3
                        , Modifier4
                        , BillingCode
                        , Units
                        , RevenueCode
                        , RevenueCodeDescription
                         -- Added by ponnin. For task #44 of AHN-Customizations
                        , ChargeStatus
						, StatusDate
                        )
                VALUES  ( @ServiceId
                        , NULL
                        , 0
                        , NULL
                        , @UserCode
                        , @CurrentDate
                        , @UserCode
                        , @CurrentDate
                        , @Modifier1
                        , @Modifier2
                        , @Modifier3
                        , @Modifier4
                        , @BillingCode
                        , @BillingCodeUnits
                        , @RevenueCode
                        , @RevenueCodeDescription
                        -- Added by ponnin. For task #44 of AHN-Customizations
                        , 9454 -- Charge Created
						, getdate()
                        )    
      
                SET @ChargeId = @@Identity  

         -- Added by ponnin: To update the ChargeStatus History. For task #44 of AHN-Customizations        
        -- Update the chargeStatus History
        INSERT  INTO  ChargeStatusHistory
                ( ChargeId,
                  ChargeStatus,
				  StatusDate
				  )
				Values (@ChargeId
						,9454 -- Charge Created
						,getdate())
                
      
  -- Insert Into ARLedger table (2nd entry for Transfer with Positive Copay Amount & CoveragePlanId as null. Means for this copay amount client is payer)    
  -- JHB 7/3/2012 Added @ClientCopay condition    
                IF ISNULL(@ClientCopay, 0) <> 0
                    BEGIN    
      
                        INSERT  INTO ARLedger
                                ( FinancialActivityLineId
                                , ChargeId
                                , LedgerType
                                , Amount
                                , AccountingPeriodId
                                , FinancialActivityVersion
                                , PostedDate
                                , CoveragePlanId
                                , ClientId
                                , DateOfService
                                , CreatedBy
                                , CreatedDate
                                , ModifiedBy
                                , ModifiedDate
                                , AdjustmentCode--jcarlson 3/28/2016
                                )
                        VALUES  ( @FinancialActivityLineId
                                , @ChargeId
                                , @GCLedgerTypeTransfer
                                , @ClientCopay
                                , @CurrentAccountingPeriodId
                                , @FinancialActivityVersion
                                , @CurrentDate
                                , NULL
                                , @ClientId
                                , @DateOfService
                                , @UserCode
                                , @CurrentDate
                                , @UserCode
                                , @CurrentDate
                                , @CoPayAdjustmentCode --jcarlson 3/28/2016
                                )    
      
                        IF @@error <> 0
                            GOTO error    
      
                    END    
    
  -- Insert Into OpenCharges table (with copay amount for 2nd Charge Entry)    
  -- JHB 7/3/2012 Added @ClientCopay condition    
                IF ( ISNULL(@ChargeAmount, 0) <> 0
                     AND ISNULL(@ClientCopay, 0) <> 0
                   )
                    BEGIN    
                        INSERT  INTO OpenCharges
                                ( ChargeId
                                , Balance
                                , CreatedBy
                                , CreatedDate
                                , ModifiedBy
                                , ModifiedDate
                                )
                        VALUES  ( @ChargeId
                                , @ClientCopay
                                , @UserCode
                                , @CurrentDate
                                , @UserCode
                                , @CurrentDate
                                )    
       
                        IF @@error <> 0
                            GOTO error    
                    END    
  -- End of block to Insert records into FinancialAcitivityLines, ARLedger & OpenCharges table for 2nd Charge Entry    
    
      
  -- Update Client Balance with ClientCopay Amount    
       
                EXEC ssp_SCCalculateClientBalance @ClientId = @ClientId -- int  
                    END     
    
    
-- Added 10/13/2014 NJain

        EXEC ssp_PMCreateInitialChargeAddOnServices @ServiceId, @UserCode
        IF @@ERROR <> 0
            GOTO error

		  IF EXISTS ( SELECT  *
                    FROM    sys.procedures
                    WHERE   name = 'scsp_PMCreateInitialCharge' )
            BEGIN
		
                EXEC scsp_PMCreateInitialCharge @ChargeId
		
            END
			
            IF @@ERROR <> 0 
            GOTO error
			
            END
    
    COMMIT TRAN    
    RETURN 0    
    
    error:    
    
    ROLLBACK TRAN    
    RETURN -1    

GO

