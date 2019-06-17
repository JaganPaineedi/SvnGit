
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('ssp_UpdateChargeAllowedAmounts', 'P') IS NOT NULL
   DROP PROCEDURE ssp_UpdateChargeAllowedAmounts
GO

CREATE PROCEDURE [dbo].[ssp_UpdateChargeAllowedAmounts] @AdjustmentCode INT	-- adjustment global code to use in the AR Ledger Entry
/******************************************************************************
**
**  Name: ssp_UpdateChargeAllowedAmounts
**  Desc:
**  This procedure is used to adjustment the AR based on allowed amounts
**
**  Return values:
**
**  Called by:   ServiceDetails.cs
**
**  Parameters:   ssp_UpdateChargeAllowedAmounts @AdjustmentCode = 50049
**
**  Auth:
**  Date:
*******************************************************************************
**  Change History
*******************************************************************************
**  Date:     Author:   Description:
** 2/11/2013 JHB  Created
** 7/22/2014 - T.Remisoski - ensure only affected charges are flagged "not ready to bill"
** 8/04/2014 - T.Remisoski - exclude transfer amounts from adj calc
** 8/17/2015 - T.Remisoski - added check for RecordDeleted on the ExpectedPayment table.
* 12/17/2015 - T.Remisoski - added checks for 2 new tables
*							ExpectedPaymentProcedureCodes
*							ExpectedPaymentPlaceOfServices
* 03/03/2016 - NJain	   - Updated to remove the existing error before inserting the new one
* 04/07/2016 - NJain	   - Added System Config Key: REPORTERRORFORMISSINGBILLINGCODES	
* 05/20/2016 - dknewtson    - Added ChargeId for Charge Billing Code Override in ssp_PMClaimsGetBillingCodes
* 06/30/2016 - SFarber     Added logic for 'AllowedAmountNegativeAdjustment' system config key
* 07/11/2016 - Dknewtson   Updated expected payment on charge when the expected payment has changed but matches the current charge already.
* 08/09/2016 - NJain	   Added Case Statement in the Order by logic
* 09/28/2016 - Akwinass	   - What: As per the review with Nimesh, added Adjustment,AllowedAmountAdjustmentCode from CoveragePlans table and added AllowedAmountAdjustmentCode from ExpectedPayment table.
*						   - Why: Task #337 in Engineering Improvement Initiatives- NBL(I) (Auto Adjustment Process).
* 10/06/2016 - Akwinass	   - What: Added SET @EPAdjustmentCode = COALESCE(@EPAdjustmentCode, @CPAdjustmentCode, @AdjustmentCode) as per Tom review
*						   - Why: Task #337 in Engineering Improvement Initiatives- NBL(I) (Auto Adjustment Process).
* 11/22/2016 - Tremisoski  - What: Fix select to handle grouping expression; Why: Woods SGL #394
* 11/30/2016 - NJain	   - Updated Order By to do Priority First then match on Variables. Woods SGL #399
* 02/03/2017 - NJain	   - Updated to add ChargeId in the Order By as the first criteria to make sure the inserts in the #ChargeExpectedPayment table happen in 	the correct order
* 03/10/2017 - NJain	   - Updated to use Ranking when inserting into #ChargeExpectedPayment and use Rank = 1 to update #Charges with Allowed Amount. Woods SGL #566
* 07/25/2017 - NJain	   - Implemented Key: DONOTADJUSTSERVICESWITHCHARGEOVERRIDE. Woods SGL #658
* 01/29/2018 - MJensen		- Use place of service code from Services if available.  MSF SGL #319
* 05/29/2018 - NJain       - Updated to set Expected Adjustment in Charges to $0 when Charge Amount < Allowed Amount OR Charge Amount = Allowed Amount AND Current Adjustment is $0. Journey SGL #119
* 10/09/2018 - MJensen		Add defensive coding to not update services in error status.	CEI SGL 1046.1
*******************************************************************************/
AS
       BEGIN TRY

             CREATE TABLE #CoveragePlans
                    (
                      CoveragePlanId INT NOT NULL ,
                      TemplateCoveragePlanId INT NOT NULL ,
                      CPAdjustmentCode INT NULL ,
                      AutoAdjustment CHAR(2)
                    )

             CREATE TABLE #Charges
                    (
                      ChargeId INT NOT NULL ,
                      CoveragePlanId INT NOT NULL ,
                      TemplateCoveragePlanId INT NULL ,
                      ServiceId INT NULL ,
                      ClientId INT NULL ,
                      DateOfService DATETIME NULL ,
                      ServiceUnits DECIMAL(10, 2) NULL ,
                      ChargeAmount MONEY NULL ,
                      CurrentAdjustment MONEY NULL ,
                      BillingCode VARCHAR(25) NULL ,
                      Modifier1 VARCHAR(10) NULL ,
                      Modifier2 VARCHAR(10) NULL ,
                      Modifier3 VARCHAR(10) NULL ,
                      Modifier4 VARCHAR(10) NULL ,
                      RevenueCode VARCHAR(25) NULL ,
                      RevenueCodeDescription VARCHAR(1000) NULL ,
                      ClaimUnits INT NULL ,
                      ExpectedPayment MONEY NULL ,
                      AllowedAmount MONEY NULL ,
                      CPAdjustmentCode INT NULL ,
                      EPAdjustmentCode INT NULL
                    )


             CREATE TABLE #ChargeExpectedPayment
                    (
                      ChargeId INT NULL ,
                      ExpectedPayment DECIMAL(10, 2) NULL ,
                      AllowedAmount DECIMAL(10, 2) NULL ,
                      EPAdjustmentCode INT NULL ,
                      Rnk INT
                    )

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
                      ClaimUnits INT NULL
                    )

             DECLARE @ChargeAccountingPeriodByDateOfService CHAR(1)
             DECLARE @CurrentDate DATE

             SET @CurrentDate = GETDATE()

-- Check accounting period configuration
             SELECT @ChargeAccountingPeriodByDateOfService = ISNULL(ChargeAccountingPeriodByDateOfService, 'N')
             FROM   SystemConfigurations

             DECLARE @ChargeErrorGlobalCodeId INT

             SELECT @ChargeErrorGlobalCodeId = GlobalCodeId
             FROM   GlobalCodes
             WHERE  Category = 'CHARGEERRORTYPE'
                    AND CodeName = 'Unable to calculate allowed amount/expected payment'


-- Get a list of Coverage Plans that have Allowed Amounts setup
             INSERT INTO #CoveragePlans
                    ( CoveragePlanId ,
                      TemplateCoveragePlanId ,
                      CPAdjustmentCode ,
                      AutoAdjustment            
                    )
                    SELECT  a.CoveragePlanId ,
                            a.CoveragePlanId AS TemplateCoveragePlanId ,
                            a.AllowedAmountAdjustmentCode AS CPAdjustmentCode ,
                            a.Adjustment
                    FROM    CoveragePlans AS a
                    WHERE   ExpectedPaymentTemplate = 'T'
                            AND ISNULL(RecordDeleted, 'N') = 'N'
                    UNION
                    SELECT  a.CoveragePlanId ,
                            a.UseExpectedPaymentTemplateId ,
                            b.AllowedAmountAdjustmentCode AS CPAdjustmentCode ,
                            a.Adjustment
                    FROM    CoveragePlans AS a
                            JOIN CoveragePlans AS b ON b.CoveragePlanId = a.UseExpectedPaymentTemplateId
                    WHERE   ISNULL(a.ExpectedPaymentTemplate, '') <> 'T'
                            AND ISNULL(a.RecordDeleted, 'N') = 'N'
                            AND a.UseExpectedPaymentTemplateId IS NOT NULL

-- Get Charges Where Allowed Amount needs to be calculated
-- Open Charges that have a template for expected payment, or is linked to a template
-- Where expected payment has not been already calculated
-- also exlude charges where some payment has been applied
             INSERT INTO #Charges
                    ( ChargeId ,
                      CoveragePlanId ,
                      TemplateCoveragePlanId ,
                      ServiceId ,
                      ClientId ,
                      DateOfService ,
                      ServiceUnits ,
                      ChargeAmount ,
                      CurrentAdjustment ,
                      CPAdjustmentCode
                    )
                    SELECT  a.ChargeId ,
                            c.CoveragePlanId ,
                            d.TemplateCoveragePlanId ,
                            e.ServiceId ,
                            e.ClientId ,
                            e.DateOfService ,
                            e.Unit ,
                            e.Charge ,
                            SUM(AR.Amount) 
				-- when the charge is not primary, the original charge amount from the service has to be subtracted from the sum
                            + CASE WHEN NOT EXISTS ( SELECT *
                                                     FROM   ARLedger AS ar3
                                                     WHERE  ar3.ChargeId = a.ChargeId
                                                            AND ar3.LedgerType = 4201
                                                            AND ISNULL(ar3.RecordDeleted, 'N') <> 'Y' ) THEN -e.Charge
                                   ELSE 0.0
                              END ,
                          -- TRemisoski - 11/22/2016 - Woods SGL #394
                            MAX(d.CPAdjustmentCode)
                    FROM    OpenCharges a
                            JOIN Charges b ON a.ChargeId = b.ChargeId
                            JOIN ClientCoveragePlans c ON b.ClientCoveragePlanId = c.ClientCoveragePlanId
                            JOIN #CoveragePlans d ON c.CoveragePlanId = d.CoveragePlanId
                            JOIN Services e ON b.ServiceId = e.ServiceId
                            LEFT JOIN ARLedger AR ON a.ChargeId = AR.ChargeId
                                                     AND AR.LedgerType <> 4201
                                                     AND ISNULL(AR.RecordDeleted, 'N') <> 'Y'
                    WHERE   NOT EXISTS ( SELECT *
                                         FROM   ARLedger AS ar2
                                         WHERE  ar2.ChargeId = AR.ChargeId
                                                AND ar2.LedgerType = 4202  -- Payment
                                                AND ISNULL(ar2.RecordDeleted, 'N') = 'N' )
                            AND ( ( d.AutoAdjustment = 'CH' ) --"CH" On Charge Creation
                                  OR ( d.AutoAdjustment = 'CL' --"CL" On Claim Creation
                                       AND b.LastBilledDate IS NOT NULL
                                     )
                                )
                            AND ( ( ISNULL(e.OverrideCharge, 'N') = 'Y'
                                    AND EXISTS ( SELECT 1
                                                 FROM   dbo.SystemConfigurationKeys
                                                 WHERE  [Key] = 'DONOTADJUSTSERVICESWITHCHARGEOVERRIDE'
                                                        AND ISNULL(Value, 'N') = 'N' )
                                  )
                                  OR ( ISNULL(e.OverrideCharge, 'N') = 'N' )
                                )
							AND e.Status <> 76 -- 10/9/18 MJensen
                    GROUP BY a.ChargeId ,
                            c.CoveragePlanId ,
                            d.TemplateCoveragePlanId ,
                            e.ServiceId ,
                            e.ClientId ,
                            e.DateOfService ,
                            e.Unit ,
                            e.Charge

             UPDATE #Charges
             SET    ChargeAmount = ChargeAmount + ISNULL(CurrentAdjustment, 0)


-- Calculate Billing Code/Units for Charges
             INSERT INTO #ClaimLines
                    ( ClaimLineId ,
                      ChargeId ,
                      CoveragePlanId ,
                      ServiceId ,
                      ServiceUnits
                    )
                    SELECT  ChargeId ,
                            ChargeId ,
                            CoveragePlanId ,
                            ServiceId ,
                            ServiceUnits
                    FROM    #Charges



-- calculate Get Billing Code/Units
             EXEC ssp_PMClaimsGetBillingCodes

             UPDATE a
             SET    BillingCode = b.BillingCode ,
                    Modifier1 = b.Modifier1 ,
                    Modifier2 = b.Modifier2 ,
                    Modifier3 = b.Modifier3 ,
                    Modifier4 = b.Modifier4 ,
                    RevenueCode = b.RevenueCode ,
                    RevenueCodeDescription = b.RevenueCodeDescription ,
                    ClaimUnits = b.ClaimUnits
             FROM   #Charges a
                    JOIN #ClaimLines b ON a.ChargeId = b.ClaimLineId

-- Calculate Allowed Amount
             INSERT INTO #ChargeExpectedPayment
                    ( ChargeId ,
                      ExpectedPayment ,
                      AllowedAmount ,
                      EPAdjustmentCode ,
                      Rnk
                    )
                    SELECT  ch.ChargeId ,
                            EP.Payment * ch.ClaimUnits ,
                            EP.AllowedAmount * ch.ClaimUnits ,
                            EP.AllowedAmountAdjustmentCode ,
                            ROW_NUMBER() OVER ( PARTITION BY ch.ChargeId ORDER BY EP.Priority ASC , ( CASE
                                                                                                        WHEN EPP.ProgramId = s.ProgramId
                                                                                                        THEN 1
                                                                                                        ELSE 0
                                                                                                      END
                                                                                                      + CASE
                                                                                                        WHEN EPL.LocationId = s.LocationId
                                                                                                        THEN 1
                                                                                                        ELSE 0
                                                                                                        END
                                                                                                      + CASE
                                                                                                        WHEN EPPC.ProcedureCodeId = s.ProcedureCodeId
                                                                                                        THEN 1
                                                                                                        ELSE 0
                                                                                                        END
                                                                                                      + CASE
                                                                                                        WHEN EP.ClientId = S.ClientId
                                                                                                        THEN 1
                                                                                                        ELSE 0
                                                                                                        END
                                                                                                      + CASE
                                                                                                        WHEN EPD.Degree = ST.Degree
                                                                                                        THEN 1
                                                                                                        ELSE 0
                                                                                                        END
                                                                                                      + CASE
                                                                                                        WHEN EPS.StaffId = S.ClinicianId
                                                                                                        THEN 1
                                                                                                        ELSE 0
                                                                                                        END
                                                                                                      + CASE
                                                                                                        WHEN epsa.ServiceAreaId = pg.ServiceAreaId
                                                                                                        THEN 1
                                                                                                        ELSE 0
                                                                                                        END
                                                                                                      + CASE
                                                                                                        WHEN EPPOS.PlaceOfService = CASE
                                                                                                        WHEN s.PlaceOfServiceId IS NOT NULL
                                                                                                        THEN s.PlaceOfServiceId
                                                                                                        ELSE l.PlaceOfService
                                                                                                        END THEN 1
                                                                                                        ELSE 0
                                                                                                        END ) DESC )
                    FROM    #Charges ch
                            JOIN Services S ON ch.ServiceId = S.ServiceId
                            LEFT JOIN Locations AS l ON l.LocationId = S.LocationId
                            JOIN Staff ST ON S.ClinicianId = ST.StaffId
                            JOIN ExpectedPayment EP ON ch.TemplateCoveragePlanId = EP.CoveragePlanId
                                                       AND ( ISNULL(ch.BillingCode, '') = ISNULL(EP.BillingCode, '')
                                                             AND ISNULL(ch.RevenueCode, '') = ISNULL(EP.RevenueCode, '')
                                                           )
                            LEFT OUTER JOIN Programs AS pg ON pg.ProgramId = S.ProgramId
                                                              AND ISNULL(pg.RecordDeleted, 'N') = 'N'
                            LEFT OUTER JOIN ExpectedPaymentServiceAreas AS epsa ON epsa.ServiceAreaId = pg.ServiceAreaId
                                                                                   AND ISNULL(epsa.RecordDeleted, 'N') = 'N'
                            LEFT OUTER JOIN ExpectedPaymentPrograms EPP ON EP.ExpectedPaymentId = EPP.ExpectedPaymentId
                                                                           AND ISNULL(EPP.RecordDeleted, 'N') = 'N'
                            LEFT OUTER JOIN ExpectedPaymentLocations EPL ON EP.ExpectedPaymentId = EPL.ExpectedPaymentId
                                                                            AND ISNULL(EPL.RecordDeleted, 'N') = 'N'
                            LEFT OUTER JOIN ExpectedPaymentDegrees EPD ON EP.ExpectedPaymentId = EPD.ExpectedPaymentId
                                                                          AND ISNULL(EPD.RecordDeleted, 'N') = 'N'
                            LEFT OUTER JOIN ExpectedPaymentStaff EPS ON EP.ExpectedPaymentId = EPS.ExpectedPaymentId
                                                                        AND ISNULL(EPS.RecordDeleted, 'N') = 'N'
                            LEFT OUTER JOIN ExpectedPaymentPlaceOfServices EPPOS ON EP.ExpectedPaymentId = EPPOS.ExpectedPaymentId
                                                                                    AND ISNULL(EPPOS.RecordDeleted, 'N') = 'N'
                            LEFT OUTER JOIN ExpectedPaymentProcedureCodes EPPC ON EP.ExpectedPaymentId = EPPC.ExpectedPaymentId
                                                                                  AND ISNULL(EPPC.RecordDeleted, 'N') = 'N'
                    WHERE   ISNULL(ch.Modifier1, '') = ISNULL(EP.Modifier1, '')
                            AND ISNULL(ch.Modifier2, '') = ISNULL(EP.Modifier2, '')
                            AND ISNULL(ch.Modifier3, '') = ISNULL(EP.Modifier3, '')
                            AND ISNULL(ch.Modifier4, '') = ISNULL(EP.Modifier4, '')
                            AND ( ISNULL(EP.BillingCode, '') <> ''
                                  OR ISNULL(EP.RevenueCode, '') <> ''
                                )
                            AND EP.FromDate <= ch.DateOfService
                            AND ISNULL(EP.RecordDeleted, 'N') = 'N'
                            AND ( EP.ToDate IS NULL
                                  OR DATEADD(dd, 1, EP.ToDate) > ch.DateOfService
                                )
                            AND ( EP.ClientId = S.ClientId
                                  OR EP.ClientId IS NULL
                                )
                            AND ( EPP.ProgramId = S.ProgramId
                                  OR EPP.ProgramId IS NULL
                                )
                            AND ( EPL.LocationId = S.LocationId
                                  OR EPL.LocationId IS NULL
                                )
                            AND ( EPD.Degree = ST.Degree
                                  OR EPD.Degree IS NULL
                                )
                            AND ( EPS.StaffId = S.ClinicianId
                                  OR EPS.StaffId IS NULL
                                )
                            AND ( epsa.ServiceAreaId = pg.ServiceAreaId
                                  OR epsa.ServiceAreaId IS NULL
                                )
                            AND ( EPPOS.PlaceOfService = CASE WHEN S.PlaceOfServiceId IS NOT NULL
                                                              THEN S.PlaceOfServiceId
                                                              ELSE l.PlaceOfService
                                                         END
                                  OR EPPOS.PlaceOfService IS NULL
                                )
                            AND ( EPPC.ProcedureCodeId = S.ProcedureCodeId
                                  OR EPPC.ProcedureCodeId IS NULL
                                )
                
                        

             UPDATE ch
             SET    ExpectedPayment = cep.ExpectedPayment ,
                    AllowedAmount = cep.AllowedAmount ,
                    ch.EPAdjustmentCode = cep.EPAdjustmentCode
             FROM   #Charges ch
                    JOIN #ChargeExpectedPayment cep ON ch.ChargeId = cep.ChargeId
             WHERE  cep.Rnk = 1
        
        

		-- track affected charges to avoid having to re-query data
             DECLARE @ChargesFlaggedAsError TABLE ( ChargeId INT )


-- Remove the Existing Error
             DELETE FROM dbo.ChargeErrors
             WHERE  ChargeId IN ( SELECT DISTINCT
                                            ChargeId
                                  FROM      #Charges )
                    AND ErrorDescription = 'Unable to calculate allowed amount/expected payment'
		

-- REPORTERRORFORMISSINGBILLINGCODES

             IF EXISTS ( SELECT *
                         FROM   dbo.SystemConfigurationKeys
                         WHERE  [Key] = 'REPORTERRORFORMISSINGBILLINGCODES'
                                AND ISNULL(Value, 'N') = 'N' )
                BEGIN
                      DELETE    FROM #Charges
                      WHERE     ChargeId NOT IN ( SELECT DISTINCT
                                                            ChargeId
                                                  FROM      #ChargeExpectedPayment )
                END
    
		
-- Error Out Charges where Expected Payment cannot be calculated
             INSERT INTO ChargeErrors
                    ( ChargeId ,
                      ErrorType ,
                      ErrorDescription
                    )
             OUTPUT inserted.ChargeId
                    INTO @ChargesFlaggedAsError ( ChargeId )
                    SELECT  a.ChargeId ,
                            @ChargeErrorGlobalCodeId ,
                            'Unable to calculate allowed amount/expected payment'
                    FROM    #Charges AS a
                            JOIN Charges AS chg ON chg.ChargeId = a.ChargeId
                            JOIN Services AS s ON s.ServiceId = chg.ServiceId
                    WHERE   a.AllowedAmount IS NULL
                            AND s.DateOfService >= '6/1/2014'	-- requested by Harbor
                            AND a.ExpectedPayment IS NULL
                            AND NOT EXISTS ( SELECT *
                                             FROM   dbo.ChargeErrors AS b
                                             WHERE  b.ChargeId = a.ChargeId
                                                    AND b.ErrorType = @ChargeErrorGlobalCodeId
                                                    AND ISNULL(b.RecordDeleted, 'N') <> 'Y' )

		-- only update charges that are flagged in the prior statement
             UPDATE a
             SET    ReadyToBill = 'N' ,
                    BillingCode = b.BillingCode ,
                    Modifier1 = b.Modifier1 ,
                    Modifier2 = b.Modifier2 ,
                    Modifier3 = b.Modifier3 ,
                    Modifier4 = b.Modifier4 ,
                    Units = b.ClaimUnits ,
                    RevenueCode = b.RevenueCode ,
                    RevenueCodeDescription = b.RevenueCodeDescription
             FROM   Charges a
                    JOIN #Charges b ON a.ChargeId = b.ChargeId
                    JOIN @ChargesFlaggedAsError AS c ON c.ChargeId = b.ChargeId


-- For 0 Adjustments update Charges table
             UPDATE a
             SET    ExpectedPayment = b.ExpectedPayment ,
                    ExpectedAdjustment = 0 ,
                    BillingCode = b.BillingCode ,
                    Modifier1 = b.Modifier1 ,
                    Modifier2 = b.Modifier2 ,
                    Modifier3 = b.Modifier3 ,
                    Modifier4 = b.Modifier4 ,
                    Units = b.ClaimUnits ,
                    RevenueCode = b.RevenueCode ,
                    RevenueCodeDescription = b.RevenueCodeDescription ,
                    ModifiedDate = GETDATE() ,
                    ModifiedBy = 'ARALLOWEDAMT'
             FROM   Charges a
                    JOIN #Charges b ON a.ChargeId = b.ChargeId
             WHERE  ( b.ChargeAmount < b.AllowedAmount
                      OR ( b.ChargeAmount = b.AllowedAmount
                           AND ISNULL(b.CurrentAdjustment, 0) = 0
                         )
                    )


-- Loop through and update Allowed Amount on Charges
-- Post Adjustments
             DECLARE @ChargeId INT
             DECLARE @Adjustment DECIMAL(10, 2)
             DECLARE @CoveragePlanId INT
             DECLARE @ClientId INT
             DECLARE @DateOfService DATETIME
             DECLARE @FinancialActivityId INT
             DECLARE @FinancialActivityLineId INT
             DECLARE @CurrentAccountingPeriodId INT
             DECLARE @ServiceId INT
             DECLARE @AllowNegativeAdjustment CHAR(1)         
             DECLARE @EPAdjustmentCode INT
             DECLARE @CPAdjustmentCode INT


             SELECT @AllowNegativeAdjustment = sck.Value
             FROM   dbo.SystemConfigurationKeys sck
             WHERE  sck.[Key] = 'AllowedAmountNegativeAdjustment'
                    AND Value IN ( 'Y', 'N' )

             IF @AllowNegativeAdjustment IS NULL
                SET @AllowNegativeAdjustment = 'N'

             DECLARE cur_Adjustments CURSOR
             FOR
                     SELECT ChargeId ,
                            CoveragePlanId ,
                            ClientId ,
                            ServiceId ,
                            DateOfService ,
                            ChargeAmount - AllowedAmount ,
                            EPAdjustmentCode ,
                            CPAdjustmentCode
                     FROM   #Charges
                     WHERE  ( ( @AllowNegativeAdjustment = 'Y'
                                AND ChargeAmount <> AllowedAmount
                              )
                              OR ( @AllowNegativeAdjustment = 'N'
                                   AND ChargeAmount > AllowedAmount
                                 )
                            )

             OPEN cur_Adjustments

             FETCH cur_Adjustments INTO @ChargeId, @CoveragePlanId, @ClientId, @ServiceId, @DateOfService, @Adjustment,
                   @EPAdjustmentCode, @CPAdjustmentCode

             WHILE @@FETCH_STATUS = 0
                   BEGIN

                         IF @ChargeAccountingPeriodByDateOfService = 'Y'
                            BEGIN
	
                                  SELECT TOP 1
                                            @CurrentAccountingPeriodId = AccountingPeriodId
                                  FROM      AccountingPeriods
                                  WHERE     DATEADD(dd, 1, EndDate) > @DateOfService
                                            AND OpenPeriod = 'Y'
                                  ORDER BY  StartDate
	
                            END
                         ELSE
                            BEGIN
	
                                  SELECT    @CurrentAccountingPeriodId = AccountingPeriodId
                                  FROM      AccountingPeriods
                                  WHERE     StartDate <= @CurrentDate
                                            AND DATEADD(dd, 1, EndDate) > @CurrentDate
	
                            END
	
                         BEGIN TRAN

                         INSERT INTO FinancialActivities
                                ( CoveragePlanId ,
                                  ClientId ,
                                  ActivityType ,
                                  CreatedBy ,
                                  CreatedDate ,
                                  ModifiedBy ,
                                  ModifiedDate
                                )
                         VALUES ( @CoveragePlanId ,
                                  NULL ,
                                  4326 ,
                                  'ARALLOWEDAMT' ,
                                  GETDATE() ,
                                  'ARALLOWEDAMT' ,
                                  GETDATE()
                                )

                         SET @FinancialActivityId = @@identity
                
                         SET @EPAdjustmentCode = COALESCE(@EPAdjustmentCode, @CPAdjustmentCode, @AdjustmentCode)                

                         EXEC ssp_PMPaymentAdjustmentPost @UserCode = 'ARALLOWEDAMT',
                            @FinancialActivityId = @FinancialActivityId, @PaymentId = NULL, @Adjustment1 = @Adjustment,
                            @AdjustmentCode1 = @EPAdjustmentCode, @PostedAccountingPeriodId = @CurrentAccountingPeriodId,
                            @ChargeId = @ChargeId, @ServiceId = @ServiceId, @DateOfService = @DateOfService,
                            @ClientId = @ClientId, @CoveragePlanId = @CoveragePlanId, @ERTransferPosting = 'N',
                            @FinancialActivityLineId = NULL


                         UPDATE a
                         SET    ExpectedPayment = b.ExpectedPayment ,
                                ExpectedAdjustment = @Adjustment ,
                                BillingCode = b.BillingCode ,
                                Modifier1 = b.Modifier1 ,
                                Modifier2 = b.Modifier2 ,
                                Modifier3 = b.Modifier3 ,
                                Modifier4 = b.Modifier4 ,
                                Units = b.ClaimUnits ,
                                RevenueCode = b.RevenueCode ,
                                RevenueCodeDescription = b.RevenueCodeDescription
                         FROM   Charges a
                                JOIN #Charges b ON a.ChargeId = b.ChargeId
                         WHERE  a.ChargeId = @ChargeId

                         COMMIT TRAN


                         FETCH cur_Adjustments INTO @ChargeId, @CoveragePlanId, @ClientId, @ServiceId, @DateOfService,
                               @Adjustment, @EPAdjustmentCode, @CPAdjustmentCode


                   END

             CLOSE cur_Adjustments

             DEALLOCATE cur_Adjustments


             UPDATE a
             SET    ExpectedPayment = b.ExpectedPayment ,
                    ExpectedAdjustment = -b.CurrentAdjustment
             FROM   #Charges b
                    JOIN dbo.Charges a ON a.ChargeId = b.ChargeId
                                          AND ( a.ExpectedPayment <> b.ExpectedPayment
                                                OR ExpectedAdjustment <> -b.CurrentAdjustment
                                              )
             WHERE  b.ChargeAmount = b.ExpectedPayment
   
       END TRY

       BEGIN CATCH

             DECLARE @Error VARCHAR(8000)
             SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                 + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_UpdateChargeAllowedAmounts') + '*****'
                 + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
                 + CONVERT(VARCHAR, ERROR_STATE())

             IF @@trancount > 0
                ROLLBACK TRAN

             RAISERROR
 (
  @Error, -- Message text.
  16, -- Severity.
  1 -- State.
 );

       END CATCH

GO


