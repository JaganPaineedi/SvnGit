IF OBJECT_ID('dbo.ssp_PMRetroactiveChargeReallocation') IS NOT NULL
    DROP PROCEDURE dbo.ssp_PMRetroactiveChargeReallocation;
GO

SET QUOTED_IDENTIFIER ON 
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.ssp_PMRetroactiveChargeReallocation /******************************************************************************        
**   
**  Name: ssp_PMRetroactiveChargeReallocation        
**  Desc:         
**  This procedure is used to adjustment the AR based on MACSIS/MITS billing       
**        
**  Called by:   SQL Job       
**                      
**  Auth:         
**  Date:         
*******************************************************************************        
**  Change History        
*******************************************************************************        
**  Date:     Author:   Description:        
** 05/05/2013 JHB       Created 
** 06/18/2013 SFarber   Modified to check for ClientCoverageHistory.EndDate is null  
** 06/20/2013 SFarber   Added code to recalculate service authorizations.
** 06/26/2013 SFarber   Added check for billable in case of 'CHHIGHERPRIORITY'
** 06/27/2013 SFarber   Added code to remove $0 charges from processing
** 07/29/2013 JHB       Added spenddown logic
** 08/14/2013 DKnewtson	3.x ssp_PMServiceAuthorizations procedure missing specificity for ClientCoveragePlanId
						Modified logic - Removed Cursor and Parameter from procedure call.
** 08/22/2013 SFarber   Changed spenddown logic.				
** 09/03/2013 SFarber   Changed 'CHFORCLIENT' logic.		
** 09/06/2013 SFarber   Added service area ID check for 'CHLOWERPRIORITY'
** 09/26/2013 SFarber   Removed ChargeErrors check for 'CHLOWERPRIORITY', 'CHFORCLIENT' and 'CHHIGHERPRIORITY'
** 12/16/2013 SFarber   Fixed delete from #Adjustments
** 06/22/2015 SFarber   Added 'COVDELETED' logic to check for procedure code not billable or program not billable 
** 09/24/2015 SFarber   Added check for errors that forced charge to be cascaded.
** 10/15/2015 SFarber   Modified to ignore payments for capitated charges.
** 11/02/2015 SFarber   Modified logic for calculating NextChargePriority for 'CHLOWERPRIORITY'
** 11/02/2015 SFarber   Modified check for no payments/adjustments to look for total amount <> $0 
** 11/05/2015 SFarber   Added logic to check for client copay when calculating adjustments
** 12/30/2015 jcarlson  Valley Support Go Live 178 
						retroactive process was not properly reversing payments, added an Id int identity column to #Adjustments to accamdate
						changes made in the for statement of the Adjustment_Cursor

						Modified logic in the Adjustment_Cursor in how it executes ssp_PMPaymentAdjustmentPost and populates parameters
** 12/21/2015 jcarlson  Added in recode category ExcludeProcedureCodesReallocation to exlcude services from being reallocated with specific procedure codes
** 1/12/2016  jcarlson  Fixed bad if else statement in adjustments cursor which could cause 0.00 payments to be created when they should be
** 1/29/2016  jcarlson  added delete from #Services where NextChargePiority is null and Reason = 'CHLOWERPRIORITY' 
** 2/16/2016  jcarlson  added in logic to handle if the charge is a co pay and to not reallocate co pay
** 3/7/2016	  jcarlson	do not reallocate a service if it has been billed using configuration key  ExcludeBilledServicesFromReallocation
** 3/14/2016  jcarlson	added in custom valley billing rules, will not affect other clients, valley has to have these for this process to work for them
** 3/16/2016  njain		Added config key ExcludePaidServicesFromReallocation to not process paid services
** 3/28/2016  jcarlson  fixed bug where reallocation would move the charge to the same coverageplan it was moving it from
** 3/28/2016  jcarlson  fixed bug where reallocation would move the charge to a coverage that was not billable
** 3/28/2016  jcarlson  added in AND ISNULL(ar.MarkedAsError,'N') = 'N' any time we are looking at ARLedger
** 4/8/2016   jcarlson  removed logic that would limit the adjustments cursor to only doing payments the first time it ran and the rest of the charge the next time reallocation runs, this works fine as long as the spp is run twice, which is standard
** 05/04/2016 jcarlson  removed isnull(ar.MarkedAsError,'N')='N' any time we are looking at ARLedger 
** 5/20/2016  Dknewtson Added chargeid to #ClaimLines for addition to PMClaimsGetBillingCodes for Charge Billing Code Override.
** 6/02/2016  Dknewtson Removed restriction on Payed charges and added code to void any billed claim line items.
** 6/06/2016  Dknewtson restricting billed but not payed claims.
** 6/09/2016  Dknewtson For CovDeleted reason - ensuring the charge determined as the next charge is for the client coverage plan determined to be the next client coverage plan.
** 6/17/2016  Dknewtson For Charge on Client reason, ignoring transfers created by service complete.
** 07/01/2016 jcarlson  loop process until there is nothing left to do, removed valley specifc rules
** 07/05/2016 jcarlson  changed charge errors from hardcoded to using core recode category CascadePayerChargeErrors
** 7/11/2016  Dknewtson Including SCSP hooks for modifying the #Services table after building, and Post reallocation operations.
** 7/12/2016  Dknewtson Including recode for Coverages that will cover copayments CoveragePlanWillCoverCopay - Some coverages will cover commercial copayments (Medicaid)
** 9/19/2016  Dknewtson Including rollback of payments by configuration (Including configuration for capitated only)
						Excluding certain adjustment codes from being reallocated based on recode.
** 1/5/2017   Dknewtson Changed rule for "Collect Upfront" Copay exclusions to exclude the whole charge if one exists rather than just the Collect Upfront copay.
						This was causing negative transfers from the client to higher priority coverage in certain cases.
** 1/5/2017   Dknewtson Correcting Correction for "Collect Upfront" copay exclusions. Incorrect logic operators.
** 1/12/2017  Dknewtson Including System Configuration key and defaulting to not exclude collect upfront copayments (must default to existing behavior)
** 3/21/2017  NJain		Updated the DELETE FROM #Services TO ONLY ignore paid services WHEN the Payment is ON the Charge being identified AS TO be reallocated. Philhaven Support #156
						Also added INPUT parameters TO the scsp call
** 10/6/2017  Dknewtson Added defensive coding to prevent multiple charges/client coverage histories with the same Priority / COB Order from causing charge amounts to inflate. Aspen Point - Support Go Live 742
** 10/12/2017 NJain		Updated TO look at SERVICE LEVEL payments INSTEAD OF charge LEVEL payments WHEN deleting FROM #Services. Bradford SGL #533	
** 03/12/2018 Dknewtson Removed charge priority calculation and included a call to recalculate charge priorities. - Charge Priorities were incorrectly calculated which was causing problems with medicaid payment posting. Camino SGL 602			
** 03/14/2018 Dknewtson Calculating the next billable coverage for COVDELETED reason. CEI - Support Go Live 851
** 08/10/2018 MJensen	Get ProcedureCodeId for call to ssp_PMGetNextBillablePayer so that a charge does not reallocate to the same plan.  Aspen Pointe Support #854
** 06/20/2018 MJensen	Use start/end dates and days to retro bill from CoveragePlans.  Valley Enhancements #978
** 07/25/2018 MJensen	Modified date comparison per code review.	Valley Enhancements #978
** Aug 8/18 - Reid Abel - fix a bug with cursor variables CEI - Support Go Live #851 (Approved by Dknewtson)
** 05/07/2018 Dknewtson Changing JOIN to LEFT JOIN to client coverage plans to prevent the exclude payments sytem from excluding paid client charges. AC - Support Go Live 60
** 09/06/2018 Dknewtson Including System Configuration Key ConsiderZeroDollarPaymentsWhenExcludingPaidServicesFromReallocation to allow users to prevent reallocation with 0$ payments - AHN Support Go Live #337
*******************************************************************************/
    @TransferAdjustmentCode INT ,
    @DaysRetroBill INT = NULL ,
    @ClientId INT = NULL ,
    @ServiceId INT = NULL ,
    @StartDate DATETIME = NULL ,
    @EndDate DATETIME = NULL
AS
    BEGIN TRY 
		--DECLARE	@Loop BIT = 1;
    /************************************
    * Loop Reallocation until there are no service left to act on
    ************************************/
		--WHILE @Loop = 1
		--	BEGIN
		DECLARE @Today DATE = GETDATE();
        IF OBJECT_ID('tempdb..#Services') IS NOT NULL
            BEGIN 
                DROP TABLE #Services;
            END; 
        CREATE TABLE #Services
            (
              ServiceId INT NULL ,
              ClientId INT NULL ,
              DateOfService DATETIME NULL ,
              ServiceUnits DECIMAL(10, 2) NULL ,
              Reason VARCHAR(100) NULL ,
              ClientCoveragePlanId INT NULL ,
              CoveragePlanId INT NULL ,
              COBOrder INT NULL ,
              [PRIORITY] INT NULL ,
              ChargeId INT NULL ,
              NextChargeId INT NULL ,
              NextChargePriority INT NULL ,
              MaxChargePriority INT NULL ,
              NextClientCoveragePlanId INT NULL ,
              NextClientCoveragePlanCOBOrder INT NULL
            );
		IF OBJECT_ID('tempdb..#ServiceBillableCharges') IS NOT NULL
			DROP TABLE #ServiceBillableCharges
		CREATE TABLE #ServiceBillableCharges
		(ServiceBillableChargeId INT PRIMARY KEY IDENTITY
        ,ServiceId int
		,ChargeId int 
		,ChargePriority int 
		,ClientCoveragePlanId INT
        ,SpendHasBeenMet CHAR(1)
		)
        IF OBJECT_ID('tempdb..#ClaimLines') IS NOT NULL
            BEGIN 
                DROP TABLE #ClaimLines;
            END; 
        CREATE TABLE #ClaimLines
            (
              ClaimLineId INT NOT NULL ,
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
            );  

        IF OBJECT_ID('tempdb..#ReallocateAuthorizations') IS NOT NULL
            BEGIN 
                DROP TABLE #ReallocateAuthorizations;
            END; 
        CREATE TABLE #ReallocateAuthorizations
            (
              ClientCoveragePlanId INT
            );


        IF @StartDate IS NULL
            SET @StartDate = DATEADD(dd, -ISNULL(@DaysRetroBill, 90), CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)));

-- Coverage removed from History
-- There is charge for the coverage and not record in coverage history for the coverage
        INSERT  INTO #Services
                ( ServiceId ,
                  ClientId ,
                  DateOfService ,
                  ServiceUnits ,
                  Reason ,
                  ChargeId ,
                  [PRIORITY] ,
                  CoveragePlanId
						
                )
                SELECT  s.ServiceId ,
                        s.ClientId ,
                        s.DateOfService ,
                        s.Unit ,
                        'COVDELETED' ,
                        ch.ChargeId ,
                        ch.Priority ,
                        ccp.CoveragePlanId
                FROM    dbo.Services s
                        JOIN dbo.Programs p ON s.ProgramId = p.ProgramId
                        JOIN dbo.Charges ch ON s.ServiceId = ch.ServiceId
                        JOIN dbo.ClientCoveragePlans ccp ON s.ClientId = ccp.ClientId
                                                            --AND ISNULL(ccp.RecordDeleted, 'N') = 'N'
                                                            AND ch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                        JOIN dbo.CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId
                        JOIN dbo.ARLedger arl ON ch.ChargeId = arl.ChargeId
                                                 AND arl.LedgerType IN ( 4201, 4204 )
                WHERE   (
							(	-- ReallocationStartDate has priority
								cp.ReallocationStartDate IS NOT NULL 
								AND s.DateOfService >= CAST(cp.ReallocationStartDate AS DATE)
								) 
							OR (	-- DaysToRetroBill is secondary
								cp.ReallocationStartDate IS NULL 
								AND cp.DaysToRetroBill IS NOT NULL
								AND s.DateOfService >= DATEADD(DAY, - cp.DaysToRetroBill, @Today)
								)
							OR (	-- Default start date is tertiary
								cp.ReallocationStartDate IS NULL -- Default start date is tertiary
								AND cp.DaysToRetroBill IS NULL
								AND s.DateOfService >= @StartDate
								)
							)
                        AND ( @ClientId IS NULL
                              OR s.ClientId = @ClientId
                            )
                        AND ( @ServiceId IS NULL
                              OR s.ServiceId = @ServiceId
                            )
                        AND (
								(	-- ReallocationEndDate is primary
									cp.ReallocationEndDate IS NOT NULL
									AND CAST(s.DateOfService AS DATE) <= CAST(cp.ReallocationEndDate AS DATE)
									)
								OR (	-- Default end date is secondary
									cp.ReallocationEndDate IS NULL
									AND @EndDate IS NULL
									)
								OR (
									cp.ReallocationEndDate IS NULL
									AND s.DateOfService < DATEADD(dd, 1, @EndDate)
									)
								)
                        AND s.Status = 75
                        AND ISNULL(s.RecordDeleted, 'N') = 'N'
                        AND ISNULL(ch.RecordDeleted, 'N') = 'N'
                        AND ISNULL(arl.RecordDeleted, 'N') = 'N'
-- Coverage History record does not exist
                        AND ( NOT EXISTS ( SELECT   *
                                           FROM     dbo.ClientCoverageHistory cch
                                           WHERE    cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                                                    AND cch.ServiceAreaId = p.ServiceAreaId
                                                    AND s.DateOfService >= cch.StartDate
                                                    AND ( s.DateOfService < DATEADD(dd, 1, cch.EndDate)
                                                          OR cch.EndDate IS NULL
                                                        )
                                                    AND ISNULL(cch.RecordDeleted, 'N') = 'N' 
													-- moved record delete check for client coverage plans here
													AND ISNULL(ccp.RecordDeleted,'N') <> 'Y' )
                              OR
     -- or Client has monthly deductible and it was not met on the date of service
                              EXISTS ( SELECT   *
                                       FROM     dbo.ClientMonthlyDeductibles cmd
                                       WHERE    cmd.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                                                AND DATEPART(yy, s.DateOfService) = cmd.DeductibleYear
                                                AND DATEPART(mm, s.DateOfService) = cmd.DeductibleMonth
                                                AND ( ( cmd.DeductibleMet = 'Y'
                                                        AND cmd.DateMet > CONVERT(DATE, s.DateOfService)
                                                      )
                                                      OR cmd.DeductibleMet = 'N'
                                                    )
                                                AND ISNULL(cmd.RecordDeleted, 'N') = 'N' )
    -- or Program is not billable to the coverage plan  
    -- or Service is not billable to the coverage plan
    -- and no payment or adjustment posted against the charge
                              OR ( NOT EXISTS ( SELECT  '*'
                                                FROM    dbo.ARLedger arl2
                                                WHERE   arl2.ChargeId = ch.ChargeId
				      --and arl2.LedgerType in (4202, 4203)
                                                        AND ( ( arl2.LedgerType = 4202
                                                                AND ISNULL(cp.Capitated, 'N') <> 'Y'
                                                              )
                                                              OR arl2.LedgerType = 4203
                                                            )
                                                        AND ISNULL(arl2.RecordDeleted, 'N') = 'N'
                                                GROUP BY arl2.ChargeId
                                                HAVING  ( SUM(CASE WHEN arl2.LedgerType = 4202 THEN arl2.Amount
                                                                   ELSE 0
                                                              END) <> 0
                                                          OR SUM(CASE WHEN arl2.LedgerType = 4203 THEN arl2.Amount
                                                                      ELSE 0
                                                                 END) <> 0
                                                        ) )
                                   AND ( EXISTS ( SELECT    *
                                                  FROM      dbo.ProgramPlans pp
                                                  WHERE     pp.CoveragePlanId = ccp.CoveragePlanId
                                                            AND pp.ProgramId = s.ProgramId
                                                            AND ISNULL(pp.RecordDeleted, 'N') = 'N' )
                                         OR EXISTS ( SELECT *
                                                     FROM   dbo.CoveragePlanRules cpr
                                                     WHERE  ( ( cpr.CoveragePlanId = cp.CoveragePlanId
                                                                AND ISNULL(cp.BillingRulesTemplate, 'T') = 'T'
                                                              )
                                                              OR ( cpr.CoveragePlanId = cp.UseBillingRulesTemplateId
                                                                   AND ISNULL(cp.BillingRulesTemplate, 'T') = 'O'
                                                                 )
                                                            )
                                                            AND cpr.RuleTypeId = 4267
                                                            AND ISNULL(cpr.RecordDeleted, 'N') = 'N'
                                                            AND ( cpr.AppliesToAllProcedureCodes = 'Y'
                                                                  OR EXISTS ( SELECT    *
                                                                              FROM      dbo.CoveragePlanRuleVariables cprv
                                                                              WHERE     cprv.CoveragePlanRuleId = cpr.CoveragePlanRuleId
                                                                                        AND cprv.ProcedureCodeId = s.ProcedureCodeId
                                                                                        AND ISNULL(cprv.RecordDeleted, 'N') = 'N' )
                                                                ) )
                                       )
                                 )
                            )
                GROUP BY s.ServiceId ,
                        s.ClientId ,
                        s.DateOfService ,
                        s.Unit ,
                        ch.ChargeId ,
                        ch.Priority ,
                        ccp.CoveragePlanId
                HAVING  SUM(arl.Amount) <> 0;

-- If there are multiple deleted coverages deleted the lowest priority first
DELETE   s1
FROM     #Services s1
WHERE    s1.Reason = 'COVDELETED'
         AND EXISTS ( SELECT  *
                      FROM    #Services s2
                      WHERE   s1.ServiceId = s2.ServiceId
                              AND (
                                    s2.[Priority] > s1.[Priority]
                                    OR (
                                         s2.[Priority] = s1.[Priority]
                                         AND s2.ChargeId < s1.ChargeId
                                       )
                                  ) );
								  
-- Find the Next Charge Id when coverage is deleted
-- Make sure that the charge is still in the Coverage History
		INSERT INTO #ServiceBillableCharges
		         (
		           ServiceId
		         , ChargeId
		         , ChargePriority
		         , ClientCoveragePlanId
				 , SpendHasBeenMet
		         )
		Select
		      s.ServiceId      -- ServiceId - int
			,ch.chargeId-- ChargeId - int
			,ch.Priority-- ChargePriority - int
			,ch.ClientCoveragePlanId-- ClientCoveragePlanId - int
			,CASE WHEN NOT EXISTS ( SELECT *
                                 FROM   dbo.ClientMonthlyDeductibles cmd
                                 WHERE  cmd.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                                        AND DATEPART(yy, s.DateOfService) = cmd.DeductibleYear
                                        AND DATEPART(mm, s.DateOfService) = cmd.DeductibleMonth
                                        AND ( ( cmd.DeductibleMet = 'Y'
                                                AND ( cmd.DateMet > CONVERT(DATE, s.DateOfService)
                                                      OR cmd.DateMet IS NULL
                                                    )
                                              )
                                              OR cmd.DeductibleMet IN ( 'N', 'U' ))
                                        AND ISNULL(cmd.RecordDeleted, 'N') = 'N' )

										 THEN 'Y' ELSE 'N' END
        FROM    #Services se
                JOIN dbo.Services s ON s.ServiceId = se.ServiceId
                JOIN dbo.Charges ch ON s.ServiceId = ch.ServiceId
                JOIN dbo.Programs p ON s.ProgramId = p.ProgramId
                JOIN dbo.ClientCoveragePlans ccp ON ch.ClientCoveragePlanId = ccp.ClientCoveragePlanId 
					AND ISNULL(ccp.RecordDeleted,'N') <> 'Y'
                JOIN dbo.CoveragePlans cp ON ccp.CoveragePlanId = cp.CoveragePlanId
        WHERE   se.Reason = 'COVDELETED'
                AND ISNULL(ch.RecordDeleted, 'N') = 'N'
				 -- Coverage History record exists
                AND EXISTS ( SELECT *
                             FROM   dbo.ClientCoverageHistory cch
                             WHERE  cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                                    AND cch.ServiceAreaId = p.ServiceAreaId
                                    AND s.DateOfService >= cch.StartDate
                                    AND ( s.DateOfService < DATEADD(dd, 1, cch.EndDate)
                                          OR cch.EndDate IS NULL
                                        )
                                    AND ISNULL(cch.RecordDeleted, 'N') = 'N' ) 
-- Program is billable to the coverage plan
                AND NOT EXISTS ( SELECT *
                                 FROM   dbo.ProgramPlans pp
                                 WHERE  pp.CoveragePlanId = ccp.CoveragePlanId
                                        AND pp.ProgramId = s.ProgramId
                                        AND ISNULL(pp.RecordDeleted, 'N') = 'N' )
-- Service is billable to the coverage plan
                AND NOT EXISTS ( SELECT *
                                 FROM   dbo.CoveragePlanRules cpr
                                 WHERE  ( ( cpr.CoveragePlanId = cp.CoveragePlanId
                                            AND ISNULL(cp.BillingRulesTemplate, 'T') = 'T'
                                          )
                                          OR ( cpr.CoveragePlanId = cp.UseBillingRulesTemplateId
                                               AND ISNULL(cp.BillingRulesTemplate, 'T') = 'O'
                                             )
                                        )
                                        AND cpr.RuleTypeId = 4267
                                        AND ISNULL(cpr.RecordDeleted, 'N') = 'N'
                                        AND ( cpr.AppliesToAllProcedureCodes = 'Y'
                                              OR EXISTS ( SELECT    *
                                                          FROM      dbo.CoveragePlanRuleVariables cprv
                                                          WHERE     cprv.CoveragePlanRuleId = cpr.CoveragePlanRuleId
                                                                    AND cprv.ProcedureCodeId = s.ProcedureCodeId
                                                                    AND ISNULL(cprv.RecordDeleted, 'N') = 'N' )
                                            ) );                

        UPDATE s
        SET    s.NextChargeId = sbc.ChargeId
             , s.NextClientCoveragePlanId = sbc.ClientCoveragePlanId
        FROM   #Services AS s
               JOIN #ServiceBillableCharges AS sbc
                  ON sbc.ServiceId = s.ServiceId
					AND sbc.SpendHasBeenMet = 'Y'
        WHERE  sbc.ChargePriority = s.[PRIORITY] + 1
				

-- get the maximum priority for charges as it will be used for the deleted coverage
        UPDATE  s
        SET     s.MaxChargePriority = ch.[Priority]
        FROM    #Services s
                JOIN dbo.Charges ch ON s.ServiceId = ch.ServiceId
        WHERE   s.Reason = 'COVDELETED'
                AND ISNULL(ch.RecordDeleted, 'N') = 'N'
                AND NOT EXISTS ( SELECT *
                                 FROM   dbo.Charges ch1
                                 WHERE  s.ServiceId = ch1.ServiceId
                                        AND ch1.[Priority] > ch.[Priority]
                                        AND ISNULL(ch1.RecordDeleted, 'N') = 'N' );

-- Charge exists for lower priority coverage plan
        INSERT  INTO #Services
                ( ServiceId ,
                  ClientId ,
                  DateOfService ,
                  ServiceUnits ,
                  Reason ,
                  ClientCoveragePlanId ,
                  COBOrder ,
                  CoveragePlanId
						
                )
                SELECT  s.ServiceId ,
                        s.ClientId ,
                        s.DateOfService ,
                        s.Unit ,
                        'CHLOWERPRIORITY' ,
                        ccp.ClientCoveragePlanId ,
                        cch.COBOrder ,
                        ccp.CoveragePlanId
                FROM    dbo.Services s
                        JOIN dbo.Programs p ON s.ProgramId = p.ProgramId
                        JOIN dbo.ClientCoveragePlans ccp ON s.ClientId = ccp.ClientId
                                                            AND ISNULL(ccp.RecordDeleted, 'N') = 'N'
                        JOIN dbo.CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId
                        JOIN dbo.ClientCoverageHistory cch ON ccp.ClientCoveragePlanId = cch.ClientCoveragePlanId
                                                              AND cch.ServiceAreaId = p.ServiceAreaId
                                                              AND s.DateOfService >= cch.StartDate
                                                              AND ( s.DateOfService < DATEADD(dd, 1, cch.EndDate)
                                                                    OR cch.EndDate IS NULL
                                                                  )
                                                              AND ISNULL(cch.RecordDeleted, 'N') = 'N'
                WHERE   (
							(	-- ReallocationStartDate has priority
								cp.ReallocationStartDate IS NOT NULL 
								AND CAST(s.DateOfService AS DATE) >= CAST(cp.ReallocationStartDate AS DATE)
								) 
							OR (	-- DaysToRetroBill is secondary
								cp.ReallocationStartDate IS NULL 
								AND cp.DaysToRetroBill IS NOT NULL
								AND s.DateOfService >= DATEADD(DAY, - cp.DaysToRetroBill, @Today)
								)
							OR (	-- Default start date is tertiary
								cp.ReallocationStartDate IS NULL -- Default start date is tertiary
								AND cp.DaysToRetroBill IS NULL
								AND s.DateOfService >= @StartDate
								)
							)
                        AND ( @ClientId IS NULL
                              OR s.ClientId = @ClientId
                            )
                        AND ( @ServiceId IS NULL
                              OR s.ServiceId = @ServiceId
                            )
                        AND (
								(	-- ReallocationEndDate is primary
									cp.ReallocationEndDate IS NOT NULL
									AND CAST(s.DateOfService AS DATE) <= CAST(cp.ReallocationEndDate AS DATE)
									)
								OR (	-- Default end date is secondary
									cp.ReallocationEndDate IS NULL
									AND @EndDate IS NULL
									)
								OR (
									cp.ReallocationEndDate IS NULL
									AND s.DateOfService < DATEADD(dd, 1, @EndDate)
									)
								)
                        AND s.Status = 75 -- Completed
                        AND s.Billable = 'Y'
                        AND ISNULL(s.RecordDeleted, 'N') = 'N'
-- Check if coverage is not spenddown
                        AND NOT EXISTS ( SELECT *
                                         FROM   dbo.ClientMonthlyDeductibles cmd
                                         WHERE  cmd.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                                                AND DATEPART(yy, s.DateOfService) = cmd.DeductibleYear
                                                AND DATEPART(mm, s.DateOfService) = cmd.DeductibleMonth
                                                AND ( ( cmd.DeductibleMet = 'Y'
                                                        AND ( cmd.DateMet > CONVERT(DATE, s.DateOfService)
                                                              OR cmd.DateMet IS NULL
                                                            )
                                                      )
                                                      OR cmd.DeductibleMet IN ( 'N', 'U' )
                                                    )
                                                AND ISNULL(cmd.RecordDeleted, 'N') = 'N' )
-- Program is billable to the coverage plan
                        AND NOT EXISTS ( SELECT *
                                         FROM   dbo.ProgramPlans pp
                                         WHERE  pp.CoveragePlanId = ccp.CoveragePlanId
                                                AND pp.ProgramId = s.ProgramId
                                                AND ISNULL(pp.RecordDeleted, 'N') = 'N' )
-- Service is billable to the coverage plan
                        AND NOT EXISTS ( SELECT *
                                         FROM   dbo.CoveragePlanRules cpr
                                         WHERE  ( ( cpr.CoveragePlanId = cp.CoveragePlanId
                                                    AND ISNULL(cp.BillingRulesTemplate, 'T') = 'T'
                                                  )
                                                  OR ( cpr.CoveragePlanId = cp.UseBillingRulesTemplateId
                                                       AND ISNULL(cp.BillingRulesTemplate, 'T') = 'O'
                                                     )
                                                )
                                                AND cpr.RuleTypeId = 4267
                                                AND ISNULL(cpr.RecordDeleted, 'N') = 'N'
                                                AND ( cpr.AppliesToAllProcedureCodes = 'Y'
                                                      OR EXISTS ( SELECT    *
                                                                  FROM      dbo.CoveragePlanRuleVariables cprv
                                                                  WHERE     cprv.CoveragePlanRuleId = cpr.CoveragePlanRuleId
                                                                            AND cprv.ProcedureCodeId = s.ProcedureCodeId
                                                                            AND ISNULL(cprv.RecordDeleted, 'N') = 'N' )
                                                    ) )
-- Charge does not exist for current client coverage plan
-- Check for charges that do not have any payments/adjustments 
-- dk removed check for payments and adjustments 02 jun 2016
                        AND NOT EXISTS ( SELECT 1
                                         FROM   dbo.Charges ch
                                                JOIN dbo.ARLedger al ON ch.ChargeId = al.ChargeId
                                                                        AND al.LedgerType IN ( 4204, 4201 )
                                                                        AND ISNULL(al.RecordDeleted, 'N') <> 'Y'
                                         WHERE  ch.ServiceId = s.ServiceId
                                                AND ch.ClientCoveragePlanId = cch.ClientCoveragePlanId
                                                AND ISNULL(ch.RecordDeleted, 'N') <> 'Y'
                                         GROUP BY al.ChargeId
                                         HAVING SUM(al.Amount) <> 0 )
                   --     AND NOT EXISTS ( SELECT '* '
                   --                      FROM   Charges ch
                   --                             JOIN ARLedger ar ON ch.ChargeId = ar.ChargeId
                   --                      WHERE  ch.ServiceId = s.ServiceId
                   --                             AND ch.ClientCoveragePlanId = cch.ClientCoveragePlanId
                   ----and ar.LedgerType in (4202, 4203)
                   --                             AND ( ( ar.LedgerType = 4202
                   --                                     AND ISNULL(cp.Capitated, 'N') <> 'Y'
                   --                                   )
                   --                                   OR ar.LedgerType = 4203
                   --                                 )
                   --                             AND ISNULL(ch.RecordDeleted, 'N') = 'N'
                   --                             AND ISNULL(ar.RecordDeleted, 'N') = 'N'
                   --                      GROUP BY ar.ChargeId
                   --                      HAVING ( SUM(CASE WHEN ar.LedgerType = 4202 THEN ar.Amount
                   --                                        ELSE 0
                   --                                   END) <> 0
                   --                               OR SUM(CASE WHEN ar.LedgerType = 4203 THEN ar.Amount
                   --                                           ELSE 0
                   --                                      END) <> 0
                   --                             ) )
-- Also make sure there are no Charge Errors that forced the charge to be cascaded for this charge
                        AND NOT EXISTS ( SELECT *
                                         FROM   dbo.Charges ch
                                                JOIN dbo.ChargeErrors ce ON ch.ChargeId = ce.ChargeId
                                                JOIN dbo.ssf_RecodeValuesCurrent('CascadePayerChargeErrors') AS rel ON ce.ErrorType = rel.IntegerCodeId
                                         WHERE  ch.ServiceId = s.ServiceId
                                                AND ch.ClientCoveragePlanId = cch.ClientCoveragePlanId
                                                AND ISNULL(ch.RecordDeleted, 'N') = 'N'
                                                AND ISNULL(ce.RecordDeleted, 'N') = 'N' )
-- Also make sure charge is not open                   
                        AND NOT EXISTS ( SELECT *
                                         FROM   dbo.OpenCharges oc
                                                JOIN dbo.Charges ch ON ch.ChargeId = oc.ChargeId
                                         WHERE  ch.ServiceId = s.ServiceId
                                                AND ch.ClientCoveragePlanId = cch.ClientCoveragePlanId
                                                AND ISNULL(ch.RecordDeleted, 'N') = 'N' )
-- And Charge exists for a lower priority coverage plan
                        AND EXISTS ( SELECT *
                                     FROM   dbo.Charges ch2
                                            JOIN dbo.ClientCoverageHistory cch2 ON ch2.ClientCoveragePlanId = cch2.ClientCoveragePlanId
                                            JOIN dbo.ClientCoveragePlans ccp2 ON ch2.ClientCoveragePlanId = ccp2.ClientCoveragePlanId
                                     WHERE  ch2.ServiceId = s.ServiceId
                                            AND ccp2.ClientId = s.ClientId
                                            AND cch2.ServiceAreaId = p.ServiceAreaId
                                            AND s.DateOfService >= cch2.StartDate
                                            AND ( s.DateOfService < DATEADD(dd, 1, cch2.EndDate)
                                                  OR cch2.EndDate IS NULL
                                                )
                                            AND cch2.COBOrder > cch.COBOrder
                                            AND ISNULL(ch2.RecordDeleted, 'N') = 'N'
                                            AND ISNULL(cch2.RecordDeleted, 'N') = 'N' )
                        AND NOT EXISTS ( SELECT *
                                         FROM   #Services s2
                                         WHERE  s.ServiceId = s2.ServiceId );
			
-- If there are multiple new coverages add the highest priority first
        DELETE  s1
        FROM    #Services s1
        WHERE   s1.Reason = 'CHLOWERPRIORITY'
                AND EXISTS ( SELECT *
                             FROM   #Services s2
                             WHERE  s1.ServiceId = s2.ServiceId
                                    AND ( s2.COBOrder < s1.COBOrder OR (
                                         s2.COBOrder = s1.COBOrder
                                         AND s2.ChargeId < s1.ChargeId
                                       )
                                  ) );

-- get the charge priority for next COB Order charge 
        UPDATE  s
        SET     s.NextChargePriority = ch.Priority
        FROM    #Services s
                JOIN dbo.Services se ON s.ServiceId = se.ServiceId
                JOIN dbo.Charges ch ON s.ServiceId = ch.ServiceId
                JOIN dbo.Programs p ON se.ProgramId = p.ProgramId
                JOIN dbo.ClientCoveragePlans ccp ON ch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                                                    AND ISNULL(ccp.RecordDeleted, 'N') = 'N'
                JOIN dbo.ClientCoverageHistory cch ON ccp.ClientCoveragePlanId = cch.ClientCoveragePlanId
                                                      AND cch.ServiceAreaId = p.ServiceAreaId
                                                      AND s.DateOfService >= cch.StartDate
                                                      AND ( s.DateOfService < DATEADD(dd, 1, cch.EndDate)
                                                            OR cch.EndDate IS NULL
                                                          )
                                                      AND cch.COBOrder > s.COBOrder
                                                      AND ISNULL(cch.RecordDeleted, 'N') = 'N'
        WHERE   s.Reason = 'CHLOWERPRIORITY'
                AND ISNULL(ch.RecordDeleted, 'N') = 'N'
                AND EXISTS ( SELECT '*'
                             FROM   dbo.ARLedger a
                             WHERE  a.ChargeId = ch.ChargeId
                                    AND a.LedgerType IN ( 4201, 4204 )
                                    AND ISNULL(a.RecordDeleted, 'N') = 'N'
                             GROUP BY a.ChargeId
                             HAVING SUM(a.Amount) > 0 )
                AND NOT EXISTS ( SELECT *
                                 FROM   dbo.Charges ch1
                                        JOIN dbo.ClientCoveragePlans ccp1 ON ch1.ClientCoveragePlanId = ccp1.ClientCoveragePlanId
                                                                             AND ISNULL(ccp1.RecordDeleted, 'N') = 'N'
                                        JOIN dbo.ClientCoverageHistory cch1 ON ccp1.ClientCoveragePlanId = cch1.ClientCoveragePlanId
                                                                               AND cch1.ServiceAreaId = p.ServiceAreaId
                                                                               AND s.DateOfService >= cch1.StartDate
                                                                               AND ( s.DateOfService < DATEADD(dd, 1, cch1.EndDate)
                                                                                     OR cch1.EndDate IS NULL
                                                                                   )
                                                                               AND cch1.COBOrder > s.COBOrder
                                                                               AND ISNULL(cch1.RecordDeleted, 'N') = 'N'
                                                                               AND cch1.COBOrder < cch.COBOrder
                                 WHERE  s.ServiceId = ch1.ServiceId
                                        AND ISNULL(ch1.RecordDeleted, 'N') = 'N'
                                        AND EXISTS ( SELECT '*'
                                                     FROM   dbo.ARLedger a
                                                     WHERE  a.ChargeId = ch1.ChargeId
                                                            AND a.LedgerType IN ( 4201, 4204 )
                                                            AND ISNULL(a.RecordDeleted, 'N') = 'N'
                                                     GROUP BY a.ChargeId
                                                     HAVING SUM(a.Amount) > 0 ) );


--jcarlson 1/29/2016
        DELETE  FROM #Services
        WHERE   NextChargePriority IS NULL
                AND Reason = 'CHLOWERPRIORITY';


-- Charge for Client but no charge for any other coverage
        INSERT  INTO #Services
                ( ServiceId ,
                  ClientId ,
                  DateOfService ,
                  ServiceUnits ,
                  Reason ,
                  ClientCoveragePlanId ,
                  COBOrder ,
                  CoveragePlanId
						
                )
                SELECT  s.ServiceId ,
                        s.ClientId ,
                        s.DateOfService ,
                        s.Unit ,
                        'CHFORCLIENT' ,
                        ccp.ClientCoveragePlanId ,
                        cch.COBOrder ,
                        ccp.CoveragePlanId
                FROM    dbo.Services s
                        JOIN dbo.Programs p ON s.ProgramId = p.ProgramId
                        JOIN dbo.ClientCoveragePlans ccp ON s.ClientId = ccp.ClientId
                                                            AND ISNULL(ccp.RecordDeleted, 'N') = 'N'
                        JOIN dbo.CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId
                        JOIN dbo.ClientCoverageHistory cch ON ccp.ClientCoveragePlanId = cch.ClientCoveragePlanId
                                                              AND cch.ServiceAreaId = p.ServiceAreaId
                                                              AND s.DateOfService >= cch.StartDate
                                                              AND ( s.DateOfService < DATEADD(dd, 1, cch.EndDate)
                                                                    OR cch.EndDate IS NULL
                                                                  )
                                                              AND ISNULL(cch.RecordDeleted, 'N') = 'N'
                WHERE   (
							(	-- ReallocationStartDate has priority
								cp.ReallocationStartDate IS NOT NULL 
								AND CAST(s.DateOfService AS DATE) >= CAST(cp.ReallocationStartDate AS DATE)
								) 
							OR (	-- DaysToRetroBill is secondary
								cp.ReallocationStartDate IS NULL 
								AND cp.DaysToRetroBill IS NOT NULL
								AND s.DateOfService >= DATEADD(DAY, - cp.DaysToRetroBill, @Today)
								)
							OR (	-- Default start date is tertiary
								cp.ReallocationStartDate IS NULL -- Default start date is tertiary
								AND cp.DaysToRetroBill IS NULL
								AND s.DateOfService >= @StartDate
								)
							)
                        AND ( @ClientId IS NULL
                              OR s.ClientId = @ClientId
                            )
                        AND ( @ServiceId IS NULL
                              OR s.ServiceId = @ServiceId
                            )
                        AND (
								(	-- ReallocationEndDate is primary
									cp.ReallocationEndDate IS NOT NULL
									AND CAST(s.DateOfService AS DATE) <= CAST(cp.ReallocationEndDate AS DATE)
									)
								OR (	-- Default end date is secondary
									cp.ReallocationEndDate IS NULL
									AND @EndDate IS NULL
									)
								OR (
									cp.ReallocationEndDate IS NULL
									AND s.DateOfService < DATEADD(dd, 1, @EndDate)
									)
								)
                        AND s.Status = 75 -- Completed
                        AND s.Billable = 'Y'
                        AND ISNULL(s.RecordDeleted, 'N') = 'N'
-- Check if coverage is not spenddown
                        AND NOT EXISTS ( SELECT *
                                         FROM   dbo.ClientMonthlyDeductibles cmd
                                         WHERE  cmd.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                                                AND DATEPART(yy, s.DateOfService) = cmd.DeductibleYear
                                                AND DATEPART(mm, s.DateOfService) = cmd.DeductibleMonth
                                                AND ( ( cmd.DeductibleMet = 'Y'
                                                        AND ( cmd.DateMet > CONVERT(DATE, s.DateOfService)
                                                              OR cmd.DateMet IS NULL
                                                            )
                                                      )
                                                      OR cmd.DeductibleMet IN ( 'N', 'U' )
                                                    )
                                                AND ISNULL(cmd.RecordDeleted, 'N') = 'N' )
-- Program is billable to the coverage plan
                        AND NOT EXISTS ( SELECT *
                                         FROM   dbo.ProgramPlans pp
                                         WHERE  pp.CoveragePlanId = ccp.CoveragePlanId
                                                AND pp.ProgramId = s.ProgramId
                                                AND ISNULL(pp.RecordDeleted, 'N') = 'N' )
-- Service is billable to the coverage plan
                        AND NOT EXISTS ( SELECT *
                                         FROM   dbo.CoveragePlanRules cpr
                                         WHERE  ( ( cpr.CoveragePlanId = cp.CoveragePlanId
                                                    AND ISNULL(cp.BillingRulesTemplate, 'T') = 'T'
                                                  )
                                                  OR ( cpr.CoveragePlanId = cp.UseBillingRulesTemplateId
                                                       AND ISNULL(cp.BillingRulesTemplate, 'T') = 'O'
                                                     )
                                                )
                                                AND cpr.RuleTypeId = 4267
                                                AND ISNULL(cpr.RecordDeleted, 'N') = 'N'
                                                AND ( cpr.AppliesToAllProcedureCodes = 'Y'
                                                      OR EXISTS ( SELECT    *
                                                                  FROM      dbo.CoveragePlanRuleVariables cprv
                                                                  WHERE     cprv.CoveragePlanRuleId = cpr.CoveragePlanRuleId
                                                                            AND cprv.ProcedureCodeId = s.ProcedureCodeId
                                                                            AND ISNULL(cprv.RecordDeleted, 'N') = 'N' )
                                                    ) )
-- Charge does not exist for current client coverage plan
-- Check for charges that do not have any payments/adjustments 
-- dk removed check for payments and adjustments 02 jun 2016
                        AND NOT EXISTS ( SELECT 1
                                         FROM   dbo.Charges ch
                                                JOIN dbo.ARLedger al ON ch.ChargeId = al.ChargeId
                                                                        AND al.LedgerType IN ( 4204, 4201 )
                                                                        AND ISNULL(al.RecordDeleted, 'N') <> 'Y'
                                         WHERE  ch.ServiceId = s.ServiceId
                                                AND ch.ClientCoveragePlanId = cch.ClientCoveragePlanId
                                                AND ISNULL(ch.RecordDeleted, 'N') <> 'Y'
                                         GROUP BY al.ChargeId
                                         HAVING SUM(al.Amount) <> 0 )
                   --     AND NOT EXISTS ( SELECT '*'
                   --                      FROM   Charges ch
                   --                             JOIN ARLedger ar ON ch.ChargeId = ar.ChargeId
                   --                      WHERE  ch.ServiceId = s.ServiceId
                   --                             AND ch.ClientCoveragePlanId = cch.ClientCoveragePlanId
                   ----and ar.LedgerType in (4202, 4203)
                   --                             AND ( ( ar.LedgerType = 4202
                   --                                     AND ISNULL(cp.Capitated, 'N') <> 'Y'
                   --                                   )
                   --                                   OR ar.LedgerType = 4203
                   --                                 )
                   --                             AND ISNULL(ch.RecordDeleted, 'N') = 'N'
                   --                             AND ISNULL(ar.RecordDeleted, 'N') = 'N'
                   --                      GROUP BY ar.ChargeId
                   --                      HAVING ( SUM(CASE WHEN ar.LedgerType = 4202 THEN ar.Amount
                   --                                        ELSE 0
                   --                                   END) <> 0
                   --                               OR SUM(CASE WHEN ar.LedgerType = 4203 THEN ar.Amount
                   --                                           ELSE 0
                   --                                      END) <> 0
                   --                             ) )
-- Also make sure there are no Charge Errors that forced the charge to be cascaded for this charge
                        AND NOT EXISTS ( SELECT *
                                         FROM   dbo.Charges ch
                                                JOIN dbo.ChargeErrors ce ON ch.ChargeId = ce.ChargeId
                                                JOIN dbo.ssf_RecodeValuesCurrent('CascadePayerChargeErrors') AS rel ON ce.ErrorType = rel.IntegerCodeId
                                         WHERE  ch.ServiceId = s.ServiceId
                                                AND ch.ClientCoveragePlanId = cch.ClientCoveragePlanId
                                                AND ISNULL(ch.RecordDeleted, 'N') = 'N'
                                                AND ISNULL(ce.RecordDeleted, 'N') = 'N' )
-- Also make sure charge is not open                   
                        AND NOT EXISTS ( SELECT *
                                         FROM   dbo.OpenCharges oc
                                                JOIN dbo.Charges ch ON ch.ChargeId = oc.ChargeId
                                         WHERE  ch.ServiceId = s.ServiceId
                                                AND ch.ClientCoveragePlanId = cch.ClientCoveragePlanId
                                                AND ISNULL(ch.RecordDeleted, 'N') = 'N' )
-- And Charge exists for the Client
-- dk excluding transfers created by ServiceComplete (Client Copayments)
                        AND NOT EXISTS ( SELECT '*'
                                         FROM   dbo.Charges ch2
                                                JOIN dbo.ARLedger arl2 ON arl2.ChargeId = ch2.ChargeId
                                                --JOIN dbo.FinancialActivityLines fal ON fal.FinancialActivityLineId = arl2.FinancialActivityLineId
                                                --   AND ISNULL(fal.RecordDeleted,'N') <> 'Y'
                                                --JOIN dbo.FinancialActivities fa ON fa.FinancialActivityId = fal.FinancialActivityId
                                                --   AND ISNULL(fa.RecordDeleted,'N') <> 'Y'
                                                --   AND NOT (fa.ActivityType <> 4321 AND arl2.LedgerType = 4204)
                                         WHERE  ch2.ServiceId = s.ServiceId
                                                AND ch2.Priority > 0
                                                AND arl2.LedgerType IN ( 4201, 4204 )
                                                AND ISNULL(ch2.RecordDeleted, 'N') = 'N'
                                                AND ISNULL(arl2.RecordDeleted, 'N') = 'N'
                                         GROUP BY ch2.ChargeId
                                         HAVING SUM(arl2.Amount) <> 0 )
                        AND NOT EXISTS ( SELECT *
                                         FROM   #Services s2
                                         WHERE  s.ServiceId = s2.ServiceId );

-- If there are multiple new coverages add the highest priority first
        DELETE  s1
        FROM    #Services s1
        WHERE   s1.Reason = 'CHFORCLIENT'
                AND EXISTS ( SELECT *
                             FROM   #Services s2
                             WHERE  s1.ServiceId = s2.ServiceId
                                    AND ( s2.COBOrder < s1.COBOrder OR (
                                         s2.COBOrder = s1.COBOrder
                                         AND s2.ChargeId < s1.ChargeId
                                       )
                                  ) );

-- Charge for all higher priority coverage plans
-- There are charges for all lesser COB order coverages and client has an adjustment and the procedure code is billable to coverage plan
        INSERT  INTO #Services
                ( ServiceId ,
                  ClientId ,
                  DateOfService ,
                  ServiceUnits ,
                  Reason ,
                  ClientCoveragePlanId ,
                  COBOrder ,
                  CoveragePlanId
						
                )
                SELECT  s.ServiceId ,
                        s.ClientId ,
                        s.DateOfService ,
                        s.Unit ,
                        'CHHIGHERPRIORITY' ,
                        ccp.ClientCoveragePlanId ,
                        cch.COBOrder ,
                        ccp.CoveragePlanId
                FROM    dbo.Services s
                        JOIN dbo.Programs p ON s.ProgramId = p.ProgramId
                        JOIN dbo.ClientCoveragePlans ccp ON s.ClientId = ccp.ClientId
                                                            AND ISNULL(ccp.RecordDeleted, 'N') = 'N'
                        JOIN dbo.CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId
                        JOIN dbo.ClientCoverageHistory cch ON ccp.ClientCoveragePlanId = cch.ClientCoveragePlanId
                                                              AND cch.ServiceAreaId = p.ServiceAreaId
                                                              AND s.DateOfService >= cch.StartDate
                                                              AND ( s.DateOfService < DATEADD(dd, 1, cch.EndDate)
                                                                    OR cch.EndDate IS NULL
                                                                  )
                                                              AND ISNULL(cch.RecordDeleted, 'N') = 'N'
                WHERE   (
							(	-- ReallocationStartDate has priority
								cp.ReallocationStartDate IS NOT NULL 
								AND CAST(s.DateOfService AS DATE) >= CAST(cp.ReallocationStartDate AS DATE)
								) 
							OR (	-- DaysToRetroBill is secondary
								cp.ReallocationStartDate IS NULL 
								AND cp.DaysToRetroBill IS NOT NULL
								AND s.DateOfService >= DATEADD(DAY, - cp.DaysToRetroBill, @Today)
								)
							OR (	-- Default start date is tertiary
								cp.ReallocationStartDate IS NULL -- Default start date is tertiary
								AND cp.DaysToRetroBill IS NULL
								AND s.DateOfService >= @StartDate
								)
							)
                        AND ( @ClientId IS NULL
                              OR s.ClientId = @ClientId
                            )
                        AND ( @ServiceId IS NULL
                              OR s.ServiceId = @ServiceId
                            )
                        AND (
								(	-- ReallocationEndDate is primary
									cp.ReallocationEndDate IS NOT NULL
									AND CAST(s.DateOfService AS DATE) <= CAST(cp.ReallocationEndDate AS DATE)
									)
								OR (	-- Default end date is secondary
									cp.ReallocationEndDate IS NULL
									AND @EndDate IS NULL
									)
								OR (
									cp.ReallocationEndDate IS NULL
									AND s.DateOfService < DATEADD(dd, 1, @EndDate)
									)
								)
                        AND s.Status = 75 -- Completed
                        AND s.Billable = 'Y'
                        AND ISNULL(s.RecordDeleted, 'N') = 'N'
-- Check if coverage is not spenddown
                        AND NOT EXISTS ( SELECT *
                                         FROM   dbo.ClientMonthlyDeductibles cmd
                                         WHERE  cmd.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                                                AND DATEPART(yy, s.DateOfService) = cmd.DeductibleYear
                                                AND DATEPART(mm, s.DateOfService) = cmd.DeductibleMonth
                                                AND ( ( cmd.DeductibleMet = 'Y'
                                                        AND ( cmd.DateMet > CONVERT(DATE, s.DateOfService)
                                                              OR cmd.DateMet IS NULL
                                                            )
                                                      )
                                                      OR cmd.DeductibleMet IN ( 'N', 'U' )
                                                    )
                                                AND ISNULL(cmd.RecordDeleted, 'N') = 'N' )
-- Program is billable to the coverage plan
                        AND NOT EXISTS ( SELECT *
                                         FROM   dbo.ProgramPlans pp
                                         WHERE  pp.CoveragePlanId = ccp.CoveragePlanId
                                                AND pp.ProgramId = s.ProgramId
                                                AND ISNULL(pp.RecordDeleted, 'N') = 'N' )
-- Service is billable to the coverage plan
                        AND NOT EXISTS ( SELECT *
                                         FROM   dbo.CoveragePlanRules cpr
                                         WHERE  ( ( cpr.CoveragePlanId = cp.CoveragePlanId
                                                    AND ISNULL(cp.BillingRulesTemplate, 'T') = 'T'
                                                  )
                                                  OR ( cpr.CoveragePlanId = cp.UseBillingRulesTemplateId
                                                       AND ISNULL(cp.BillingRulesTemplate, 'T') = 'O'
                                                     )
                                                )
                                                AND cpr.RuleTypeId = 4267
                                                AND ISNULL(cpr.RecordDeleted, 'N') = 'N'
                                                AND ( cpr.AppliesToAllProcedureCodes = 'Y'
                                                      OR EXISTS ( SELECT    *
                                                                  FROM      dbo.CoveragePlanRuleVariables cprv
                                                                  WHERE     cprv.CoveragePlanRuleId = cpr.CoveragePlanRuleId
                                                                            AND cprv.ProcedureCodeId = s.ProcedureCodeId
                                                                            AND ISNULL(cprv.RecordDeleted, 'N') = 'N' )
                                                    ) )
-- Charge does not exist for current client coverage plan
-- Check for charges that do not have any payments/adjustments 
-- dk removed check for payments and adjustments 02 jun 2016
                        AND NOT EXISTS ( SELECT 1
                                         FROM   dbo.Charges ch
                                                JOIN dbo.ARLedger al ON ch.ChargeId = al.ChargeId
                                                                        AND al.LedgerType IN ( 4204, 4201 )
                                                                        AND ISNULL(al.RecordDeleted, 'N') <> 'Y'
                                         WHERE  ch.ServiceId = s.ServiceId
                                                AND ch.ClientCoveragePlanId = cch.ClientCoveragePlanId
                                                AND ISNULL(ch.RecordDeleted, 'N') <> 'Y'
                                         GROUP BY al.ChargeId
                                         HAVING SUM(al.Amount) <> 0 )
                   --     AND NOT EXISTS ( SELECT '*'
                   --                      FROM   Charges ch
                   --                             JOIN ARLedger ar ON ch.ChargeId = ar.ChargeId
                   --                      WHERE  ch.ServiceId = s.ServiceId
                   --                             AND ch.ClientCoveragePlanId = cch.ClientCoveragePlanId
                   ----and ar.LedgerType in (4202, 4203)
                   --                             AND ( ( ar.LedgerType = 4202
                   --                                     AND ISNULL(cp.Capitated, 'N') <> 'Y'
                   --                                   )
                   --                                   OR ar.LedgerType = 4203
                   --                                 )
                   --                             AND ISNULL(ch.RecordDeleted, 'N') = 'N'
                   --                             AND ISNULL(ar.RecordDeleted, 'N') = 'N'
                   --                      GROUP BY ar.ChargeId
                   --                      HAVING ( SUM(CASE WHEN ar.LedgerType = 4202 THEN ar.Amount
                   --                                        ELSE 0
                   --                                   END) <> 0
                   --                               OR SUM(CASE WHEN ar.LedgerType = 4203 THEN ar.Amount
                   --                                           ELSE 0
                   --                                      END) <> 0
                   --                             ) )
-- Also make sure there are no Charge Errors that forced the charge to be cascaded for this charge
                        AND NOT EXISTS ( SELECT *
                                         FROM   dbo.Charges ch
                                                JOIN dbo.ChargeErrors ce ON ch.ChargeId = ce.ChargeId
                                                JOIN dbo.ssf_RecodeValuesCurrent('CascadePayerChargeErrors') AS rel ON ce.ErrorType = rel.IntegerCodeId
                                         WHERE  ch.ServiceId = s.ServiceId
                                                AND ch.ClientCoveragePlanId = cch.ClientCoveragePlanId
                                                AND ISNULL(ch.RecordDeleted, 'N') = 'N'
                                                AND ISNULL(ce.RecordDeleted, 'N') = 'N' )
-- Also make sure charge is not open                   
                        AND NOT EXISTS ( SELECT *
                                         FROM   dbo.OpenCharges oc
                                                JOIN dbo.Charges ch ON ch.ChargeId = oc.ChargeId
                                         WHERE  ch.ServiceId = s.ServiceId
                                                AND ch.ClientCoveragePlanId = cch.ClientCoveragePlanId
                                                AND ISNULL(ch.RecordDeleted, 'N') = 'N' )
-- Charge exists for all client coverages that have higher priority
-- i.e. no higher priority coverage does not have a charge
                        AND NOT EXISTS ( SELECT *
                                         FROM   dbo.ClientCoveragePlans ccp1
                                                JOIN dbo.ClientCoverageHistory cch1 ON ccp1.ClientCoveragePlanId = cch1.ClientCoveragePlanId
                                         WHERE  ccp1.ClientId = s.ClientId
                                                AND cch1.ServiceAreaId = p.ServiceAreaId
                                                AND s.DateOfService >= cch1.StartDate
                                                AND ( s.DateOfService < DATEADD(dd, 1, cch1.EndDate)
                                                      OR cch1.EndDate IS NULL
                                                    )
                                                AND ISNULL(ccp1.RecordDeleted, 'N') = 'N'
                                                AND ISNULL(cch1.RecordDeleted, 'N') = 'N'
                                                AND cch1.COBOrder < cch.COBOrder
                                                AND NOT EXISTS ( SELECT *
                                                                 FROM   dbo.Charges ch1
                                                                 WHERE  ch1.ServiceId = s.ServiceId
                                                                        AND ch1.ClientCoveragePlanId = ccp1.ClientCoveragePlanId
                                                                        AND ISNULL(ch1.RecordDeleted, 'N') = 'N' ) )
                        AND NOT EXISTS ( SELECT *
                                         FROM   #Services s2
                                         WHERE  s.ServiceId = s2.ServiceId );

			
			
		
			
-- If there are multiple new coverages add the highest priority first
        DELETE  s1
        FROM    #Services s1
        WHERE   s1.Reason = 'CHHIGHERPRIORITY'
                AND EXISTS ( SELECT *
                             FROM   #Services s2
                             WHERE  s1.ServiceId = s2.ServiceId
                                    AND ( s2.COBOrder < s1.COBOrder OR (
                                         s2.COBOrder = s1.COBOrder
                                         AND s2.ChargeId < s1.ChargeId
                                       )
                                  ) );

-- get the maximum priority for charges as it will be used for the deleted coverage
        UPDATE  s
        SET     s.MaxChargePriority = ch.Priority
        FROM    #Services s
                JOIN dbo.Charges ch ON s.ServiceId = ch.ServiceId
        WHERE   s.Reason = 'CHHIGHERPRIORITY'
                AND NOT EXISTS ( SELECT *
                                 FROM   dbo.Charges ch1
                                 WHERE  ch1.ServiceId = s.ServiceId
                                        AND ch1.Priority > ch.Priority
                                        AND ISNULL(ch1.RecordDeleted, 'N') = 'N' );

/*
Scenario 3 - Coverage moved to lesser COB Priority

a) There is a charge for greater COB order coverage but not for new coverage and procedure code is billable

-- This is covered in previous cases
*/
		
		
		
		
--Delete services from #services if the services procedure code is in the recode category ExcludeProcedureCodesReallocation
        DELETE  stemp
        FROM    #Services stemp
                JOIN dbo.Services s2 ON stemp.ServiceId = s2.ServiceId
                                        AND ISNULL(s2.RecordDeleted, 'N') = 'N'
                JOIN dbo.ssf_RecodeValuesCurrent('ExcludeProcedureCodesReallocation') AS rel ON s2.ProcedureCodeId = rel.IntegerCodeId;

-- delete paid services from reallocation (Per configuration)
				-- except Capitated Payments
        DELETE  FROM stemp
        FROM    #Services stemp
                JOIN dbo.Charges ch ON ch.ServiceId = stemp.ServiceId
                                       AND ISNULL(ch.RecordDeleted, 'N') = 'N'
                JOIN dbo.ClientCoveragePlans AS ccp ON ccp.ClientCoveragePlanId = ch.ClientCoveragePlanId
                JOIN dbo.CoveragePlans AS cp ON cp.CoveragePlanId = ccp.CoveragePlanId
        WHERE   EXISTS ( SELECT 1
                         FROM   dbo.ARLedger ar
                                JOIN dbo.Charges ch2 ON ch2.ChargeId = ar.ChargeId
                         WHERE  ch2.ServiceId = stemp.ServiceId
                                AND ar.LedgerType = 4202
                                AND ISNULL(ar.RecordDeleted, 'N') = 'N'
								AND ISNULL(ar.ErrorCorrection,'N') = 'N'
								AND ISNULL(ar.MarkedAsError,'N') = 'N'
                         GROUP BY ch2.ServiceId
                         HAVING CASE WHEN ISNULL(NULLIF(RIGHT(dbo.ssf_GetSystemConfigurationKeyValue('ConsiderZeroDollarPaymentsWhenExcludingPaidServicesFromReallocation'),1),
                                                                  ''), 'N') = 'Y' THEN -1
                                               ELSE SUM(ar.Amount)
                                          END <> 0 )
                AND ISNULL(dbo.ssf_GetSystemConfigurationKeyValue('ExcludePaidServicesFromReallocation'), 'Y') = 'Y'
                AND ( cp.Capitated = 'N'
                      OR ISNULL(dbo.ssf_GetSystemConfigurationKeyValue('ExcludeCapitationPaidServicesFromReallocation'), 'N') = 'Y'
                    )

        DECLARE @AdjustmentCodeExclusionLevel VARCHAR(MAX) = dbo.ssf_GetSystemConfigurationKeyValue('EXCLUDEREALLOCATIONADJUSTMENTCODEBYLEVEL')

        IF @AdjustmentCodeExclusionLevel = 'Service'
            BEGIN
                DELETE  stemp
                FROM    #Services stemp
                        JOIN dbo.Charges AS c ON c.ServiceId = stemp.ServiceId
                                                 AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
                        JOIN ARLedger al ON al.ChargeId = c.ChargeId
                                            AND ISNULL(al.RecordDeleted, 'N') <> 'Y'
                                            AND ISNULL(al.MarkedAsError, 'N') <> 'Y'
                                            AND ISNULL(al.ErrorCorrection, 'N') <> 'Y'
                                            AND AdjustmentCode IS NOT NULL
                        JOIN dbo.ssf_RecodeValuesCurrent('ReallocationExcludeAdjustmentTransferCodes') AS srvc ON srvc.IntegerCodeId = al.AdjustmentCode


            END

        DECLARE @ExcludeCopayCollectUpfrontClientCharges CHAR(1) = 'N'

        IF ISNULL(dbo.ssf_GetSystemConfigurationKeyValue('ExcludeCopayCollectUpfrontClientChargesFromReallocation'), '') <> ''
            SELECT  @ExcludeCopayCollectUpfrontClientCharges = dbo.ssf_GetSystemConfigurationKeyValue('ExcludeCopayCollectUpfrontClientChargesFromReallocation')
                
		
		
		
		
		
        IF OBJECT_ID('scsp_PMRetroactiveChargeReallocationUpdateServices') IS NOT NULL
            BEGIN
                EXEC scsp_PMRetroactiveChargeReallocationUpdateServices;
            END;      

        IF OBJECT_ID('tempdb..#Adjustments') IS NOT NULL
            BEGIN 
                DROP TABLE #Adjustments;
            END;         
        CREATE TABLE #Adjustments
            (
              Id INT IDENTITY(1, 1) , --added jcarlson , needed a unique id for use with modifications made in the Adujstment_Cursor
              ServiceId INT NULL ,
              ChargeId INT NULL ,
              ClientCoveragePlanId INT NULL ,
              Priority INT NULL ,
              Charges DECIMAL(10, 2) NULL ,
              Adjustments DECIMAL(10, 2) NULL ,
              Payments DECIMAL(10, 2) NULL ,
              PaymentId INT NULL ,
              AdjustmentCode INT NULL
            );


        INSERT  INTO #Adjustments
                ( ServiceId ,
                  ChargeId ,
                  ClientCoveragePlanId ,
                  Priority ,
                  Charges ,
                  Adjustments ,
                  Payments ,
                  PaymentId ,
                  AdjustmentCode
						
                )
                SELECT  s.ServiceId ,
                        ch.ChargeId ,
                        ch.ClientCoveragePlanId ,
                        ch.Priority ,
                        SUM(CASE WHEN arl.LedgerType IN ( 4201, 4204 ) THEN arl.Amount
                                 ELSE 0
                            END) ,
                        SUM(CASE WHEN arl.LedgerType IN ( 4203 ) THEN arl.Amount
                                 ELSE 0
                            END) ,
                        SUM(CASE WHEN arl.LedgerType IN ( 4202 ) THEN arl.Amount
                                 ELSE 0
                            END) ,
                        arl.PaymentId ,
                        CASE WHEN arl.LedgerType IN ( 4203 ) THEN arl.AdjustmentCode
                             ELSE NULL
                        END
                FROM    #Services s
                        JOIN dbo.ClientCoveragePlans ccp ON s.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                        JOIN dbo.Charges ch ON s.ServiceId = ch.ServiceId
                                               AND ( ch.Priority >= s.NextChargePriority
                                                     OR ch.Priority = 0
                                                   )
                        JOIN dbo.ARLedger arl ON ch.ChargeId = arl.ChargeId
                        JOIN dbo.Services AS s2 ON s.ServiceId = s2.ServiceId
                WHERE   s.Reason IN ( 'CHLOWERPRIORITY', 'CHHIGHERPRIORITY' )
                        AND ISNULL(ch.RecordDeleted, 'N') = 'N'
                        AND ISNULL(arl.RecordDeleted, 'N') = 'N'
								-- exclude charges with specific adjustment codes
                        AND NOT EXISTS ( SELECT 1
                                         FROM   dbo.ssf_RecodeValuesCurrent('ReallocationExcludeAdjustmentTransferCodes') AS srvc
                                                JOIN dbo.ARLedger al ON al.ChargeId = ch.ChargeId
                                                                        AND al.AdjustmentCode = srvc.IntegerCodeId
                                                                        AND @AdjustmentCodeExclusionLevel = 'Charge'
                                                                        AND ISNULL(al.RecordDeleted, 'N') <> 'Y'
                                                                        AND ISNULL(al.MarkedAsError, 'N') <> 'Y'
                                                                        AND ISNULL(al.ErrorCorrection, 'N') <> 'Y' )
                        AND ( @ExcludeCopayCollectUpfrontClientCharges = 'N'
                              OR NOT EXISTS ( SELECT    1
                                              FROM      dbo.ARLedger al2
                                                        JOIN dbo.FinancialActivityLines fal ON al2.FinancialActivityLineId = fal.FinancialActivityLineId
                                                                                               AND ISNULL(fal.RecordDeleted, 'N') <> 'Y'
                                                        JOIN dbo.FinancialActivities fa ON fal.FinancialActivityId = fa.FinancialActivityId
                                                                                           AND ISNULL(fa.RecordDeleted, 'N') <> 'Y'
                                              WHERE     fa.ActivityType = 4321
                                                        AND al2.LedgerType = 4204
                                                        AND al2.Amount > 0
                                                            -- Some Coverage Plans will cover commercial copays. (Medicaid)
                                                        AND NOT EXISTS ( SELECT 1
                                                                         FROM   dbo.ssf_RecodeValuesAsOfDate('CoveragePlanWillCoverCopay', s.DateOfService) copaycov
                                                                         WHERE  copaycov.IntegerCodeId = ccp.CoveragePlanId )
                                                        AND al2.ChargeId = ch.ChargeId
                                                        AND ISNULL(al2.RecordDeleted, 'N') <> 'Y'
                                                        AND ISNULL(al2.MarkedAsError, 'N') <> 'Y'
                                                        AND ISNULL(al2.ErrorCorrection, 'N') <> 'Y' )
                            )
                GROUP BY s.ServiceId ,
                        ch.ChargeId ,
                        ch.ClientCoveragePlanId ,
                        ch.Priority ,
                        arl.PaymentId ,
                        CASE WHEN arl.LedgerType IN ( 4203 ) THEN arl.AdjustmentCode
                             ELSE NULL
                        END;

        INSERT  INTO #Adjustments
                ( ServiceId ,
                  ChargeId ,
                  ClientCoveragePlanId ,
                  Priority ,
                  Charges ,
                  Adjustments ,
                  Payments ,
                  PaymentId ,
                  AdjustmentCode
						
                )
                SELECT  s.ServiceId ,
                        ch.ChargeId ,
                        ch.ClientCoveragePlanId ,
                        ch.Priority ,
                        SUM(CASE WHEN arl.LedgerType IN ( 4201, 4204 ) THEN arl.Amount
                                 ELSE 0
                            END) ,
                        SUM(CASE WHEN arl.LedgerType IN ( 4203 ) THEN arl.Amount
                                 ELSE 0
                            END) ,
                        SUM(CASE WHEN arl.LedgerType IN ( 4202 ) THEN arl.Amount
                                 ELSE 0
                            END) ,
                        arl.PaymentId ,
                        CASE WHEN arl.LedgerType IN ( 4203 ) THEN arl.AdjustmentCode
                             ELSE NULL
                        END
                FROM    #Services s -- dk Client Coverage Plan we're transfering to.
                        JOIN dbo.ClientCoveragePlans ccp ON s.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                        JOIN dbo.Charges ch ON s.ServiceId = ch.ServiceId
                                               AND ch.Priority = 0
                        JOIN dbo.ARLedger arl ON ch.ChargeId = arl.ChargeId
                        JOIN dbo.Services AS s2 ON s.ServiceId = s2.ServiceId
                WHERE   s.Reason = 'CHFORCLIENT'
                        AND ISNULL(ch.RecordDeleted, 'N') = 'N'
                        AND ISNULL(arl.RecordDeleted, 'N') = 'N'
								-- exclude charges with specific adjustment codes
                        AND NOT EXISTS ( SELECT 1
                                         FROM   dbo.ssf_RecodeValuesCurrent('ReallocationExcludeAdjustmentTransferCodes') AS srvc
                                                JOIN dbo.ARLedger al ON al.ChargeId = ch.ChargeId
                                                                        AND al.AdjustmentCode = srvc.IntegerCodeId
                                                                        AND @AdjustmentCodeExclusionLevel = 'Charge'
                                                                        AND ISNULL(al.RecordDeleted, 'N') <> 'Y'
                                                                        AND ISNULL(al.MarkedAsError, 'N') <> 'Y'
                                                                        AND ISNULL(al.ErrorCorrection, 'N') <> 'Y' )
                        AND ( @ExcludeCopayCollectUpfrontClientCharges = 'N'
                              OR NOT EXISTS ( SELECT    1
                                              FROM      dbo.ARLedger al2
                                                        JOIN dbo.FinancialActivityLines fal ON al2.FinancialActivityLineId = fal.FinancialActivityLineId
                                                                                               AND ISNULL(fal.RecordDeleted, 'N') <> 'Y'
                                                        JOIN dbo.FinancialActivities fa ON fal.FinancialActivityId = fa.FinancialActivityId
                                                                                           AND ISNULL(fa.RecordDeleted, 'N') <> 'Y'
                                              WHERE     fa.ActivityType = 4321
                                                        AND al2.LedgerType = 4204
                                                        AND al2.Amount > 0
                                                            -- Some Coverage Plans will cover commercial copays. (Medicaid)
                                                        AND NOT EXISTS ( SELECT 1
                                                                         FROM   dbo.ssf_RecodeValuesAsOfDate('CoveragePlanWillCoverCopay', s.DateOfService) copaycov
                                                                         WHERE  copaycov.IntegerCodeId = ccp.CoveragePlanId )
                                                        AND al2.ChargeId = ch.ChargeId
                                                        AND ISNULL(al2.RecordDeleted, 'N') <> 'Y'
                                                        AND ISNULL(al2.MarkedAsError, 'N') <> 'Y'
                                                        AND ISNULL(al2.ErrorCorrection, 'N') <> 'Y' )
                            )
                GROUP BY s.ServiceId ,
                        ch.ChargeId ,
                        ch.ClientCoveragePlanId ,
                        ch.Priority ,
                        arl.PaymentId ,
                        CASE WHEN arl.LedgerType IN ( 4203 ) THEN arl.AdjustmentCode
                             ELSE NULL
                        END;

        -- dk excluding client copayments 
        INSERT  INTO #Adjustments
                ( ServiceId ,
                  ChargeId ,
                  ClientCoveragePlanId ,
                  Priority ,
                  Charges ,
                  Adjustments ,
                  Payments ,
                  PaymentId ,
                  AdjustmentCode
						
				)
                SELECT  s.ServiceId ,
                        ch.ChargeId ,
                        ch.ClientCoveragePlanId ,
                        ch.Priority ,
                        SUM(CASE WHEN arl.LedgerType IN ( 4201, 4204 ) THEN arl.Amount
                                 ELSE 0
                            END) ,
                        SUM(CASE WHEN arl.LedgerType IN ( 4203 ) THEN arl.Amount
                                 ELSE 0
                            END) ,
                        SUM(CASE WHEN arl.LedgerType IN ( 4202 ) THEN arl.Amount
                                 ELSE 0
                            END) ,
                        arl.PaymentId ,
                        CASE WHEN arl.LedgerType IN ( 4203 ) THEN arl.AdjustmentCode
                             ELSE NULL
                        END
                FROM    #Services s
                        JOIN dbo.Charges ch ON s.ServiceId = ch.ServiceId
                                               AND ch.Priority = s.PRIORITY
                        JOIN dbo.ARLedger arl ON ch.ChargeId = arl.ChargeId
                        JOIN dbo.FinancialActivityLines fal ON arl.FinancialActivityLineId = fal.FinancialActivityLineId
                                                               AND ISNULL(fal.RecordDeleted, 'N') <> 'Y'
                WHERE   s.Reason = 'COVDELETED'
                        AND ISNULL(ch.RecordDeleted, 'N') = 'N'
                        AND ISNULL(arl.RecordDeleted, 'N') = 'N'
						-- exclude charges with specific adjustment codes
                        AND NOT EXISTS ( SELECT 1
                                         FROM   dbo.ssf_RecodeValuesCurrent('ReallocationExcludeAdjustmentTransferCodes') AS srvc
                                                JOIN dbo.ARLedger al ON al.ChargeId = ch.ChargeId
                                                                        AND al.AdjustmentCode = srvc.IntegerCodeId
                                                                        AND @AdjustmentCodeExclusionLevel = 'Charge'
                                                                        AND ISNULL(al.RecordDeleted, 'N') <> 'Y'
                                                                        AND ISNULL(al.MarkedAsError, 'N') <> 'Y'
                                                                        AND ISNULL(al.ErrorCorrection, 'N') <> 'Y' )
                GROUP BY s.ServiceId ,
                        ch.ChargeId ,
                        ch.ClientCoveragePlanId ,
                        ch.Priority ,
                        arl.PaymentId ,
                        CASE WHEN arl.LedgerType IN ( 4203 ) THEN arl.AdjustmentCode
                             ELSE NULL
                        END;


-- Do not reallocate if Charge amount is $0
        DELETE  FROM #Adjustments
        WHERE   ISNULL(Charges, 0) = 0
                AND ISNULL(Adjustments, 0) = 0
                AND ISNULL(Payments, 0) = 0;

        DELETE  s
        FROM    #Services s
        WHERE   NOT EXISTS ( SELECT *
                             FROM   #Adjustments a
                             WHERE  a.ServiceId = s.ServiceId
                                    AND ISNULL(a.Charges, 0) <> 0 );
		
/*********************************
* If no services to reallocate, stop looping
*********************************/
				--IF ( SELECT COUNT (*) FROM #Services AS s
				--   ) = 0
				--	BEGIN

				--		SET @Loop = 0;

				--	END;


-- Create Charges and Adjustments
        DECLARE @ChargeId INT ,
            @Adjustment DECIMAL(10, 2);    
        DECLARE @CoveragePlanId INT ,
            @RecordClientId INT ,
            @RecordDateOfService DATETIME;    
        DECLARE @FinancialActivityId INT ,
            @FinancialActivityLineId INT;    
        DECLARE @CurrentAccountingPeriodId INT ,
            @ARLedgerId INT;    
        DECLARE @RecordServiceId INT;
        DECLARE @RecordChargeId INT ,
            @RecordReason VARCHAR(100);
        DECLARE @RecordClientCoveragePlanId INT ,
            @RecordNextChargeId INT ,
            @RecordPriority INT;
        DECLARE @CurrentDate DATETIME ,
            @RecordServiceUnits DECIMAL(10, 2);
        DECLARE @RecordNextChargePriority INT ,
            @RecordMaxChargePriority INT;
        DECLARE @RecordCoveragePlanId INT ,
            @RecordNextClientCoveragePlanId INT;
        DECLARE @Charges DECIMAL(10, 2) ,
            @Adjustments DECIMAL(10, 2) ,
            @Payments DECIMAL(10, 2);
        DECLARE @AdjustmentChargeId INT ,
            @AdjustmentCoveragePlanId INT ,
            @AdjustmentAdjustmentCode INT;
        DECLARE @AdjustmentPaymentId INT ,
            @AdjustmentClientCoveragePlanId INT;
        DECLARE @NewChargePriority INT;	
		DECLARE @LowestPriorityClientCoveragePlan INT,
				@ProcedureCodeId INT 
				,@ClinicianId INT 	
				
        SET @CurrentDate = GETDATE();
    
        SELECT  @CurrentAccountingPeriodId = AccountingPeriodId
        FROM    dbo.AccountingPeriods
        WHERE   StartDate <= GETDATE()
                AND DATEADD(dd, 1, EndDate) > GETDATE();       
    
        DECLARE cur_Reallocations CURSOR
        FOR
            SELECT  s.ServiceId ,
                    s.ClientId ,
                    s.DateOfService ,
                    s.ServiceUnits ,
                    s.Reason ,
                    s.ClientCoveragePlanId ,
                    s.ChargeId ,
                    s.PRIORITY ,
                    s.NextChargeId ,
                    s.NextChargePriority ,
                    s.MaxChargePriority ,
                    s.CoveragePlanId ,
                    s.NextClientCoveragePlanId
            FROM    #Services s;

        OPEN cur_Reallocations; 

        FETCH cur_Reallocations INTO @RecordServiceId, @RecordClientId, @RecordDateOfService, @RecordServiceUnits, @RecordReason, @RecordClientCoveragePlanId, @RecordChargeId, @RecordPriority, @RecordNextChargeId, @RecordNextChargePriority, @RecordMaxChargePriority, @RecordCoveragePlanId, @RecordNextClientCoveragePlanId;

        WHILE @@FETCH_STATUS = 0
            BEGIN

                BEGIN TRAN;

				-- for COVDELETED Reason need to calculate where we will send the charge if the nextClientCoveragePlanId is null (Meaning there is not a charge with the deleted coverage's priority + 1)
				-- We will find the next billable payer after the lowest priority billable coverage with a charge.
				IF @RecordReason = 'COVDELETED' AND @RecordNextClientCoveragePlanId IS NULL 
				BEGIN 
					SET @LowestPriorityClientCoveragePlan = NULL
					SET @ProcedureCodeId = NULL
					SET @ClinicianId = NULL
				
				-- Get procedure code and clinician in case there is no data in #ServiceBillableCharges 
					SELECT @ProcedureCodeId = s.ProcedureCodeId
						,@ClinicianId = s.ClinicianId
						FROM Services s
						WHERE s.ServiceId = @RecordServiceId

					-- This will be NULL if the client is the only available charge. 
					-- Which means next billable payer will return the current or new primary coverage.
					-- otherwise we will calculate the next billable plan from the set of charges that currently exist.
                    SELECT @LowestPriorityClientCoveragePlan = sbc.ClientCoveragePlanId
							,@ProcedureCodeId = s.ProcedureCodeId
							,@ClinicianId = s.ClinicianId
                    FROM   #ServiceBillableCharges AS sbc
							JOIN Services s ON s.ServiceId = sbc.ServiceId
                    WHERE  sbc.ServiceId = @RecordServiceId--@ServiceId--Aug 7/18 - Reid Abel - use the cursor ServiceId value here
                           AND NOT EXISTS ( SELECT 1
                                            FROM   #ServiceBillableCharges AS sbc2
                                            WHERE  sbc2.ServiceId = sbc.ServiceId 
												   AND (sbc.ChargePriority < sbc2.ChargePriority
													   OR (
															sbc.ChargePriority = sbc2.ChargePriority
															AND sbc.ChargeId < sbc2.ChargeId
														  ) 
													) )

					EXEC dbo.ssp_PMGetNextBillablePayer @ClientId = @RecordClientId, -- int
					   @ServiceId = @RecordServiceId, -- int
					   @DateOfService = @RecordDateOfService, -- datetime
					   @ProcedureCodeId = @ProcedureCodeId, -- int
					   @ClinicianId = @ClinicianId, -- int
					   @ClientCoveragePlanId = @LowestPriorityClientCoveragePlan, -- int
					   @NextClientCoveragePlanId = @RecordNextClientCoveragePlanId OUTPUT -- int
					

				END 

                             -- set all billed claim line items to void.

	-- Post Adjustment Ledgers
	
                DECLARE cur_Adjustments CURSOR
                FOR
                    SELECT  a.ChargeId ,
                            a.ClientCoveragePlanId ,
                            c.CoveragePlanId ,
                            a.Charges ,
                            a.Adjustments ,
                            a.Payments ,
                            a.PaymentId ,
                            a.AdjustmentCode
                    FROM    #Adjustments a
                            JOIN dbo.Charges b ON a.ChargeId = b.ChargeId
                            LEFT JOIN dbo.ClientCoveragePlans c ON b.ClientCoveragePlanId = c.ClientCoveragePlanId
                    WHERE   a.ServiceId = @RecordServiceId
                    ORDER BY CASE WHEN a.PaymentId IS NULL THEN 2
                                  ELSE 1
                             END;
	
                OPEN cur_Adjustments;
	
                FETCH cur_Adjustments INTO @AdjustmentChargeId, @AdjustmentClientCoveragePlanId, @AdjustmentCoveragePlanId, @Charges, @Adjustments, @Payments, @AdjustmentPaymentId, @AdjustmentAdjustmentCode;
	
                WHILE @@Fetch_Status = 0
                    BEGIN
	--we need to find the financial activtiy line id of the payment we are backing out so that it appears correctly on the front end
					
					--if the row that is being processesd has a paymentid, then we need to grab the financial activity id for that payment
					--we need this id to allow the front end to properly display any adjustments made to the payment
                        IF @AdjustmentPaymentId IS NOT NULL
                            AND @Payments < 0.00 -- negative payments means the service has a payment
							-- shouldn't have total payment amount be a credit for any given payment, unless something funky is going on. In which case we don't want to do anything.
                            AND ( ISNULL(dbo.ssf_GetSystemConfigurationKeyValue('PostPaymentReversalsWhenReallocatingPaidCharges'), 'N') = 'Y'
								  -- or the plan is capitated and we can post reversals to capitation paid services (default to yes)
                                  OR EXISTS ( SELECT    1
                                              FROM      dbo.CoveragePlans AS cp
                                              WHERE     cp.CoveragePlanId = @RecordCoveragePlanId
                                                        AND cp.Capitated = 'Y'
                                                        AND ISNULL(dbo.ssf_GetSystemConfigurationKeyValue('PostPaymentReversalsWhenReallocatingCapitationPaidServices'), 'Y') = 'Y' )
                                )
                            BEGIN
									-- post a negative payment on the original financial activity and payment
                                SELECT  @FinancialActivityId = p.FinancialActivityId
                                FROM    dbo.Payments AS p
                                WHERE   p.PaymentId = @AdjustmentPaymentId

                                EXEC dbo.ssp_PMPaymentAdjustmentPost @UserCode = 'REALLOCATION', -- varchar(30)
                                    @FinancialActivityId = @FinancialActivityId, -- int
                                    @PaymentId = @AdjustmentPaymentId, -- int
                                    @ChargeId = @AdjustmentChargeId, -- int
                                    @ServiceId = @RecordServiceId, -- int
                                    @DateOfService = @RecordDateOfService, -- datetime
                                    @ClientId = @RecordClientId, -- int
                                    @CoveragePlanId = @RecordCoveragePlanId, -- int
                                    @PostedAccountingPeriodId = @CurrentAccountingPeriodId, -- int
                                    @Payment = @Payments, -- money -- Should already be a negative because of the way we are summing.
                                    @ERTransferPosting = 'N', -- char(1)
                                    @FinancialActivityLineId = NULL
								
                            END
                        ELSE
                            BEGIN--if it is null then create a new Finnacial activity Id and allow the ssp_PMPaymentAdjustmentPost to create a new Financial Activity Line Id

                                INSERT  INTO dbo.FinancialActivities
                                        ( CoveragePlanId ,
                                          ClientId ,
                                          ActivityType ,
                                          CreatedBy ,
                                          CreatedDate ,
                                          ModifiedBy ,
                                          ModifiedDate
												
                                        )
                                VALUES  ( NULL ,
                                          @RecordClientId ,
                                          4326 ,
                                          'REALLOCATION' ,
                                          @CurrentDate ,
                                          'REALLOCATION' ,
                                          @CurrentDate
												
                                        );   
                                SET @FinancialActivityId = SCOPE_IDENTITY();   
	
                                SET @FinancialActivityLineId = NULL;
                           -- END
                                IF @AdjustmentPaymentId IS NULL --only run if this is not a payment, if this runs and an adjustment row for the service that has a payment runs bad things happen
                                    BEGIN
                                        IF ISNULL(@Charges, 0) <> 0
                                            BEGIN
                                                IF @RecordReason IN ( 'CHLOWERPRIORITY', 'CHHIGHERPRIORITY', 'CHFORCLIENT' ) 
                                                    EXEC dbo.ssp_PMPaymentAdjustmentPost @UserCode = 'REALLOCATION', @FinancialActivityId = @FinancialActivityId, @PaymentId = NULL, @ChargeId = @AdjustmentChargeId, @ServiceId = @RecordServiceId, @DateOfService = @RecordDateOfService, @ClientId = @RecordClientId, @CoveragePlanId = @AdjustmentCoveragePlanId, @ERTransferPosting = 'N', @FinancialActivityLineId = NULL, @Transfer1 = @Charges, @TransferTo1 = @RecordClientCoveragePlanId, @TransferCode1 = @TransferAdjustmentCode;  
                                                ELSE
                                                    EXEC dbo.ssp_PMPaymentAdjustmentPost @UserCode = 'REALLOCATION', @FinancialActivityId = @FinancialActivityId, @PaymentId = NULL, @ChargeId = @AdjustmentChargeId, @ServiceId = @RecordServiceId, @DateOfService = @RecordDateOfService, @ClientId = @RecordClientId, @CoveragePlanId = @AdjustmentCoveragePlanId, @ERTransferPosting = 'N', @FinancialActivityLineId = NULL, @Transfer1 = @Charges, @TransferTo1 = @RecordNextClientCoveragePlanId, @TransferCode1 = @TransferAdjustmentCode;  
                                            END;
                                        IF ISNULL(@Adjustments, 0) <> 0
                                            BEGIN
                                                EXEC dbo.ssp_PMPaymentAdjustmentPost @UserCode = 'REALLOCATION', @FinancialActivityId = @FinancialActivityId, @PaymentId = NULL, @Adjustment1 = @Adjustments, @AdjustmentCode1 = @AdjustmentAdjustmentCode, @PostedAccountingPeriodId = @CurrentAccountingPeriodId, @ChargeId = @AdjustmentChargeId, @ServiceId = @RecordServiceId, @DateOfService = @RecordDateOfService, @ClientId = @RecordClientId, @CoveragePlanId = @AdjustmentCoveragePlanId, @ERTransferPosting = 'N', @FinancialActivityLineId = NULL;    

                                            END;
                                    END;
                            END;    

                        FETCH cur_Adjustments INTO @AdjustmentChargeId, @AdjustmentClientCoveragePlanId, @AdjustmentCoveragePlanId, @Charges, @Adjustments, @Payments, @AdjustmentPaymentId, @AdjustmentAdjustmentCode;
  
                    END;
                CLOSE cur_Adjustments;    
                DEALLOCATE cur_Adjustments;  
			-- need to recalculate charge priorities based on the COB Order and Rules.
				EXEC dbo.ssp_SCRecalculateChargePriorities @ServiceId = @RecordServiceId, -- int
				   @UserCode = 'REALLOCATION' -- varchar(30)


	-- Reallocate service authorizations
                INSERT  INTO #ReallocateAuthorizations
                        ( ClientCoveragePlanId
								
                        )
                        SELECT  c.ClientCoveragePlanId
                        FROM    #Services s
                                JOIN dbo.Charges c ON c.ChargeId = s.ChargeId
                        WHERE   s.ServiceId = @RecordServiceId
                                AND c.ClientCoveragePlanId IS NOT NULL
                                AND NOT EXISTS ( SELECT *
                                                 FROM   #ReallocateAuthorizations r
                                                 WHERE  r.ClientCoveragePlanId = c.ClientCoveragePlanId )
                        UNION
                        SELECT  c.ClientCoveragePlanId
                        FROM    #Services s
                                JOIN dbo.Charges c ON c.ChargeId = s.NextChargeId
                        WHERE   s.ServiceId = @RecordServiceId
                                AND c.ClientCoveragePlanId IS NOT NULL
                                AND NOT EXISTS ( SELECT *
                                                 FROM   #ReallocateAuthorizations r
                                                 WHERE  r.ClientCoveragePlanId = c.ClientCoveragePlanId )
                        UNION
                        SELECT  c.ClientCoveragePlanId
                        FROM    #Adjustments a
                                JOIN dbo.Charges c ON c.ChargeId = a.ChargeId
                        WHERE   a.ServiceId = @RecordServiceId
                                AND c.ClientCoveragePlanId IS NOT NULL
                                AND NOT EXISTS ( SELECT *
                                                 FROM   #ReallocateAuthorizations r
                                                 WHERE  r.ClientCoveragePlanId = c.ClientCoveragePlanId );

                DECLARE cur_ReallocateAuthorizations CURSOR
                FOR
                    SELECT  ClientCoveragePlanId
                    FROM    #ReallocateAuthorizations;
 
                OPEN cur_ReallocateAuthorizations; 
                FETCH cur_ReallocateAuthorizations INTO @RecordClientCoveragePlanId;

                WHILE @@FETCH_STATUS = 0
                    BEGIN
   
                        EXEC dbo.ssp_PMServiceAuthorizations @CurrentUser = 'REALLOCATION', @ServiceId = @RecordServiceId, @ClientCoveragePlanId = @RecordClientCoveragePlanId;    

	
                        FETCH cur_ReallocateAuthorizations INTO @RecordClientCoveragePlanId;
                    END;   

                CLOSE cur_ReallocateAuthorizations;
                DEALLOCATE cur_ReallocateAuthorizations;   

                DELETE  FROM #ReallocateAuthorizations;
	
    -- Reallocation log
                INSERT  INTO dbo.RetroactiveReallocationLog
                        ( ServiceId ,
                          ClientId ,
                          DateOfService ,
                          ServiceUnits ,
                          Reason ,
                          ClientCoveragePlanId ,
                          CoveragePlanId ,
                          COBOrder ,
                          [Priority] ,
                          ChargeId ,
                          NextChargeId ,
                          NextChargePriority ,
                          MaxChargePriority ,
                          NextClientCoveragePlanId ,
                          NextClientCoveragePlanCOBOrder
								
                        )
                        SELECT  ServiceId ,
                                ClientId ,
                                DateOfService ,
                                ServiceUnits ,
                                Reason ,
                                ClientCoveragePlanId ,
                                CoveragePlanId ,
                                COBOrder ,
                                [PRIORITY] ,
                                ChargeId ,
                                NextChargeId ,
                                NextChargePriority ,
                                MaxChargePriority ,
                                NextClientCoveragePlanId ,
                                NextClientCoveragePlanCOBOrder
                        FROM    #Services
                        WHERE   ServiceId = @RecordServiceId;

                COMMIT TRAN;    
	    
                FETCH cur_Reallocations INTO @RecordServiceId, @RecordClientId, @RecordDateOfService, @RecordServiceUnits, @RecordReason, @RecordClientCoveragePlanId, @RecordChargeId, @RecordPriority, @RecordNextChargeId, @RecordNextChargePriority, @RecordMaxChargePriority, @RecordCoveragePlanId, @RecordNextClientCoveragePlanId;

            END;

        CLOSE cur_Reallocations;
        DEALLOCATE cur_Reallocations;  
           
        IF OBJECT_ID('scsp_PMRetroactiveChargeReallocationPostReallocation') IS NOT NULL
            BEGIN      
                EXEC scsp_PMRetroactiveChargeReallocationPostReallocation @ClientId, @ServiceId, @StartDate, @EndDate, @TransferAdjustmentCode
            END; 
			--END; 
    END TRY    
    
    BEGIN CATCH        
    
        DECLARE @Error VARCHAR(8000);        
        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMRetroactiveChargeReallocation') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());        
          
        IF @@trancount > 0
            ROLLBACK TRAN;    
     
        RAISERROR        
 (        
  @Error, -- Message text.        
  16, -- Severity.        
  1 -- State.        
 );        
    
    END CATCH;      
  
GO