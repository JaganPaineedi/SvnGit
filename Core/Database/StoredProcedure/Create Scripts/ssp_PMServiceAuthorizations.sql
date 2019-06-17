/****** Object:  StoredProcedure [dbo].[ssp_PMServiceAuthorizations]    Script Date: 01/18/2014 10:32:29 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_PMServiceAuthorizations]')
                    AND type IN ( N'P', N'PC' ) ) 
    DROP PROCEDURE [dbo].[ssp_PMServiceAuthorizations]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMServiceAuthorizations]    Script Date: 01/18/2014 10:32:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PMServiceAuthorizations]
    @CurrentUser VARCHAR(30) ,
    @ServiceId INT ,
    @ServiceDeleted CHAR(1) = NULL ,
    @ClientCoveragePlanId INT = NULL
AS /*********************************************************************              
-- Stored Procedure: dbo.ssp_PMServiceAuthorizations        
-- Creation Date:    1/9/07                                 
--                                                          
-- Purpose:  Finds authorizations for services                                               
--                                                          
-- Updates:                                                 
--   Date       Author     Purpose                           
--  01.09.2007  JHB        Created                           
--  06.02.2009  SFarber    Added check for RecordDeleted on ClientCoverageHistory          
--  04.20.2010  avoss      Modified unit calculation to use floor to not use a unit if time does not meet minimum unit requirement.       
--  07.30.2010  dharvey    Added record delete check on AuthorizationCodeProcedureCodes to exclude logical deletions      
--  11.10.2011  SFarber    Added code to exclude services    
-- 24-06-2012 Sonia Dhamija Made changes for Authorization Override rules as per discussion with Suma and Javed  
-- 6/26/2012 JHB - Added logic to check for authorizations only for the Service Area linked to Program
-- 07/05/2012 amitsr - Modified @Unit,@UnitsUsed,@UnitsScheduled,@NewAuthorizationTotalUnits, @NewAuthorizationUnitsUsed,@NewAuthorizationUnitsScheduled, @NewUnits  decimal(10,2) to @Unit decimal(18,2), Due to #1691, Harbor Go Live Issues,Service Detail: Exception on save after changing Status from Show to Comple
-- 5/13/2013 JHB - Added logic to check for custom Charge Types where unit should be based on range of minutes
-- 5/28/2013 JHB - Modified Logic for Billable Procedure and Program Check
-- 6/9/2013 JHB	 - Added logic for Completed Services to get priority over using authorizations over scheduled services
-- 06.20.2013  SFarber     Modified to support finding authorizations for a specific client coverage plan.
-- 07.03.2013  SFarber     Modified logic for checking coverage plan rules
-- 10.10.2013  Gautam	   What/Why : Allegan - Support #256 Service Completion - (Same change for 3.5x)Services where auth marked partially approve
--						   Modified the logic - partially denied / partially approved status added wherever Approved is used
--	JAN-18-2014	jwheeler	Replaced Temp table with Table variable to improve total run time
--	DEC-3-2014	dharvey		Added logic to handle CoveragePlanRules.AppliesToAllCoveragePlans column - Core #151
--	JAN-23-2015	dharvey		Revised changes based on feedback from Slavik
--  JUN-29-2015 Gautam     Modified to support authorizations to be tracked for specified # of dollars (UnitType='D'),Task#935, Valley - Customizations
--  Sept 15 2015 Shruthi.S Added two new rules 4272,4273.Ref #4 CEI - Customizations.
--  Sept 28 Sept 2016  PradeepT What:Added code to authorization process to exclude services that are created from the Services from Claims process from using
--                              an authorization for the General fund coverage plan which must have new rule
---                             "No authorization required if service is created from claim." a new rule 4274 
---                             Why:CEI Support Go Live-276 
/*  07 June 2017   Bernardin  What: Added query to update  UnitsScheduled = NULL in Authorizations table if the Service status is Cancel i.e., 73 Why: CEI - SGl# 659*/
/*08 Aug 2018   Kavya     Modified the recodes  hordcoded logic by taking the recodes from ssf_RecodeValuesCurrent_ Threshold Support#1042*/
*********************************************************************/
    DECLARE @ClientId INT ,
        @DateOfService DATETIME ,
        @Status INT ,
        @ProcedureCodeId INT ,
        @Unit DECIMAL(18, 2)
    DECLARE @UnitType INT ,
        @Priority INT ,
        @varClientCoveragePlanId INT ,
        @AuthorizationId INT
    DECLARE @UnitsUsed DECIMAL(18, 2) ,
        @UnitsScheduled DECIMAL(18, 2)
    DECLARE @NewAuthorizationId INT ,
        @NewAuthorizationTotalUnits DECIMAL(18, 2)
    DECLARE @NewAuthorizationUnitsUsed DECIMAL(18, 2) ,
        @NewAuthorizationUnitsScheduled DECIMAL(18, 2)
    DECLARE @NewAuthorizationStartDateUsed DATETIME ,
        @NewAuthorizationEndDateUsed DATETIME
    DECLARE @NewUnits DECIMAL(18, 2) ,
        @NewAuthorizationStatus INT ,
        @NewAuthorizationClientCoveragePlanId INT
    DECLARE @CurrentDate DATETIME ,
        @Billable CHAR(1)
    DECLARE @ServiceAreaId INT ,
        @ProgramId INT
    --JUN-29-2015 Gautam
    DECLARE @Charge DECIMAL(18, 2)
-- JHB 5/13/2013
    DECLARE @ProcedureRateId INT

    SET @CurrentDate = GETDATE()

    DECLARE @CoveragePlans TABLE
        (
          Priority INT NOT NULL ,
          ClientCoveragePlanId INT NOT NULL ,
          CoveragePlanId INT NOT NULL ,
          AuthorizationNeeded CHAR(1) NULL ,
          AuthorizationId INT NULL ,
          UnitsUsed DECIMAL(18, 2) NULL ,
          UnitsScheduled DECIMAL(18, 2) NULL ,
          NewAuthorizationId INT NULL ,
          NewAuthorizationTotalUnits DECIMAL(18, 2) NULL ,
          NewAuthorizationUnitsUsed DECIMAL(18, 2) NULL ,
          NewAuthorizationUnitsScheduled DECIMAL(18, 2) NULL ,
          NewAuthorizationStartDateUsed DATETIME NULL ,
          NewAuthorizationEndDateUsed DATETIME NULL ,
          NewUnits DECIMAL(18, 2) NULL ,
          NewAuthorizationStatus INT NULL ,
          NewAuthorizationClientCoveragePlanId INT NULL ,
          ReusedAuthorization CHAR(1) NULL ,
          RedistributeAuthorization CHAR(1) NULL ,
          AuthorizationRequiredOverride CHAR(1) NULL ,
          NoAuthorizationRequiredOverride CHAR(1) NULL
        )

    IF @@error <> 0 
        GOTO error

    DECLARE @AuthorizedClientCoveragePlans TABLE
        (
          ClientCoveragePlanId INT NOT NULL ,
          AuthorizedClientCoveragePlanId INT NOT NULL
        )

    IF @@error <> 0 
        GOTO error

    DECLARE @RecalculateAuthorizations TABLE
        (
          AuthorizationId INT NOT NULL ,
          CurrentUnitsUsed DECIMAL(18, 2) NULL ,
          CurrentUnitsScheduled DECIMAL(18, 2) NULL ,
          NewUnitsUsed DECIMAL(18, 2) NULL ,
          NewUnitsScheduled DECIMAL(18, 2) NULL
        )
    IF @@error <> 0 
        GOTO error

-- Get Service Information                
    SELECT  @ClientId = ClientId ,
            @DateOfService = DateOfService ,
            @ProcedureCodeId = ProcedureCodeId ,
            @Unit = Unit ,
            @UnitType = CASE UnitType
                          WHEN 110 THEN 120
                          WHEN 111 THEN 121
                          WHEN 112 THEN 122
                          WHEN 113 THEN 123
                          ELSE UnitType
                        END ,
            @Status = STATUS ,
            @Billable = Billable ,
            @ProgramId = ProgramId ,
            @ProcedureRateId = ProcedureRateId,
             --JUN-29-2015 Gautam
            @Charge = Charge
    FROM    Services
    WHERE   ServiceId = @ServiceId

    IF @@error <> 0 
        GOTO error

-- JHB 5/13/2013
-- In case the rate is linked to custom charge type e.g. 15 (7/7) 
-- then round of the service unit for auth unit calculation
    DECLARE @ChargeType INT ,
        @ChargeUnit INT ,
        @ChargeRange INT

    SELECT  @ChargeType = ChargeType
    FROM    ProcedureRates
    WHERE   ProcedureRateId = @ProcedureRateId

    IF @@error <> 0 
        GOTO error

    IF @ChargeType > 10000 
        BEGIN
            SELECT  @ChargeUnit = CONVERT(INT, ExternalCode1) ,
                    @ChargeRange = CONVERT(INT, ExternalCode2)
            FROM    GlobalCodes
            WHERE   GlobalCodeId = @ChargeType

            IF @@error <> 0 
                GOTO error

	-- Round the duration to the next unit if 
	-- e.g. 15 (7/7) is the charge type
	-- 7 minutes should be treated as 0 units and 8-22 treated as 1 unit and 23-37 as 2 units etc.
	-- so 7 rounded to 0, 8-22 rounded to 15, 23-37 rounded to 30 etc.
            IF @Unit % @ChargeUnit > @ChargeRange 
                SET @Unit = ( @Unit / @ChargeUnit ) * @ChargeUnit + @ChargeUnit
            ELSE 
                SET @Unit = ( @Unit / @ChargeUnit ) * @ChargeUnit

            IF @@error <> 0 
                GOTO error
        END

-- Look for authorizations on in case of scheduled, show and complete                
    IF ISNULL(@ServiceDeleted, 'N') = 'N'
        AND @Status IN ( 70, 71, 75 )
        AND ISNULL(@Billable, 'Y') = 'Y' 
        BEGIN
	-- Get a list of Client Coverage Plan Ids and determine which ones require authorization                
            INSERT  INTO @CoveragePlans
                    ( Priority ,
                      ClientCoveragePlanId ,
                      CoveragePlanId ,
                      AuthorizationRequiredOverride ,
                      NoAuthorizationRequiredOverride
		            )
                    SELECT  cch.COBOrder ,
                            cch.ClientCoveragePlanId ,
                            cp.CoveragePlanId ,
                            ccp.AuthorizationRequiredOverride ,
                            ccp.NoAuthorizationRequiredOverride
                    FROM    ClientCoverageHistory cch
                            JOIN ClientCoveragePlans ccp ON ccp.ClientCoveragePlanId = cch.ClientCoveragePlanId
                            JOIN CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId
                            JOIN Programs p ON p.ServiceAreaId = cch.ServiceAreaId
                    WHERE   ccp.ClientId = @ClientId
                            AND ( @ClientCoveragePlanId IS NULL
                                  OR ccp.ClientCoveragePlanId = @ClientCoveragePlanId
                                )
                            AND cch.StartDate <= @DateOfService
		--   and (cch.EndDate is null or dateadd(dd, 1, cch.EndDate) > @DateOfService)                
                            AND ( cch.EndDate IS NULL
                                  OR cch.EndDate > DATEADD(dd, -1, @DateOfService)
                                )
                            AND p.ProgramId = @ProgramId
                            AND ( ( ccp.RecordDeleted = 'N' )
                                  OR ( ccp.RecordDeleted IS NULL )
                                ) --and isnull(ccp.RecordDeleted, 'N') = 'N'                
                            AND ( ( cch.RecordDeleted = 'N' )
                                  OR ( cch.RecordDeleted IS NULL )
                                ) --and isnull(cch.RecordDeleted, 'N') = 'N'                
		-- Check if Authorization is required                
                            AND ( ccp.AuthorizationRequiredOverride = 'Y' -- Authorization is Required based on Client Coverage Plan
                                  OR ( ISNULL(ccp.NoAuthorizationRequiredOverride, 'N') = 'N'
                                       AND ISNULL(ccp.AuthorizationRequiredOverride, 'N') = 'N'
                                       AND EXISTS ( SELECT  *
                                                    FROM    CoveragePlanRules cpr
                                                    WHERE   ( ( cpr.CoveragePlanId = cp.CoveragePlanId
                                                                AND ISNULL(cp.BillingRulesTemplate, 'T') = 'T'
                                                              )
                                                              OR ( cpr.CoveragePlanId = cp.UseBillingRulesTemplateId
                                                                   AND ISNULL(cp.BillingRulesTemplate, 'T') = 'O'
                                                                 )
                                                            )
                                                            AND cpr.RuleTypeId in ( 4264,4272,4273)
                                                            AND ( ( cpr.RecordDeleted = 'N' )
                                                                  OR ( cpr.RecordDeleted IS NULL )
                                                                ) --and isnull(cpr.RecordDeleted, 'N') = 'N'              
                                                            AND ( cpr.AppliesToAllProcedureCodes = 'Y'
                                                                  OR EXISTS ( SELECT    *
                                                                              FROM      CoveragePlanRuleVariables cprv
                                                                              WHERE     cprv.CoveragePlanRuleId = cpr.CoveragePlanRuleId
                                                                                        AND cprv.ProcedureCodeId = @ProcedureCodeId
									/*and isnull(cprv.RecordDeleted, 'N') = 'N'*/
                                                                                        AND ( ( cprv.RecordDeleted = 'N' )
                                                                                              OR ( cprv.RecordDeleted IS NULL )
                                                                                            ) )
                                                                ) )
                                     )
                                )
		-- Check if procedure is billable
                            AND NOT EXISTS ( SELECT *
                                             FROM   CoveragePlanRules cpr
                                             WHERE  ( ( cpr.CoveragePlanId = cp.CoveragePlanId
                                                        AND ISNULL(cp.BillingRulesTemplate, 'T') = 'T'
                                                      )
                                                      OR ( cpr.CoveragePlanId = cp.UseBillingRulesTemplateId
                                                           AND ISNULL(cp.BillingRulesTemplate, 'T') = 'O'
                                                         )
                                                    )
                                                    AND cpr.RuleTypeId = 4267
                                                    AND ( ( cpr.RecordDeleted = 'N' )
                                                          OR ( cpr.RecordDeleted IS NULL )
                                                        ) --and isnull(cpr.RecordDeleted, 'N') = 'N'
                                                    AND ( cpr.AppliesToAllProcedureCodes = 'Y'
                                                          OR EXISTS ( SELECT    *
                                                                      FROM      CoveragePlanRuleVariables cprv
                                                                      WHERE     cprv.CoveragePlanRuleId = cpr.CoveragePlanRuleId
                                                                                AND cprv.ProcedureCodeId = @ProcedureCodeId
							/*and isnull(cprv.RecordDeleted, 'N') = 'N'*/
                                                                                AND ( ( cprv.RecordDeleted = 'N' )
                                                                                      OR ( cprv.RecordDeleted IS NULL )
                                                                                    ) )
                                                        ) )
		-- Check if Program is billable
                            AND NOT EXISTS ( SELECT *
                                             FROM   ProgramPlans pp
                                             WHERE  pp.CoveragePlanId = cp.CoveragePlanId
                                                    AND pp.ProgramId = p.ProgramId
				/*and isnull(pp.RecordDeleted,'N') = 'N'*/
                                                    AND ( ( pp.RecordDeleted = 'N' )
                                                          OR ( pp.RecordDeleted IS NULL )
                                                        ) )

            IF @@error <> 0 
                GOTO error
        END
----------Start changes on 28 Sept by Pradeep to exclude association of service to autorization when service is from claim
IF EXISTS (select * from ClaimLineServiceMappings cl where cl.ServiceId = @ServiceId and isnull(CL.RecordDeleted, 'N') = 'N' )
  BEGIN
    DELETE  a
    FROM @CoveragePlans a
            join CoveragePlans cp on cp.CoveragePlanId = a.CoveragePlanId
            join CoveragePlanRules cpr on ((cpr.CoveragePlanId = cp.CoveragePlanId
                                            and isnull(cp.BillingRulesTemplate, 'T') = 'T')
                                           or (cpr.CoveragePlanId = cp.UseBillingRulesTemplateId
                                              and isnull(cp.BillingRulesTemplate, 'T') = 'O'))
    WHERE   cpr.RuleTypeId = 4274
            AND ((cpr.RecordDeleted = 'N')
                 OR (cpr.RecordDeleted is null))

            AND (cpr.AppliesToAllProcedureCodes = 'Y'
                 OR EXISTS ( SELECT 1
                             FROM   CoveragePlanRuleVariables cprv
                             WHERE  cprv.CoveragePlanRuleId = cpr.CoveragePlanRuleId
                                    and cprv.ProcedureCodeId = @ProcedureCodeId
                                    and ((cprv.RecordDeleted = 'N')or (cprv.RecordDeleted is null))
                            )
                  )

 

 END
----------END changes on 28 Sept by Pradeep to exclude association of service to autorization when service is from claim
    UPDATE  a
    SET     AuthorizationId = b.AuthorizationId ,
            UnitsUsed = b.UnitsUsed ,
            UnitsScheduled = b.UnitsScheduled
    FROM    @CoveragePlans a
            JOIN ServiceAuthorizations b ON ( a.ClientCoveragePlanId = b.ClientCoveragePlanId )
    WHERE   b.ServiceId = @ServiceId
            AND ( ( b.RecordDeleted = 'N' )
                  OR ( b.RecordDeleted IS NULL )
                ) --and isnull(b.RecordDeleted, 'N') = 'N'                

    IF @@error <> 0 
        GOTO error

-- Determine which other Coverage Plan's authorizations can be used by these plans                
    INSERT  INTO @AuthorizedClientCoveragePlans
            ( ClientCoveragePlanId ,
              AuthorizedClientCoveragePlanId
	        )
            SELECT  ClientCoveragePlanId ,
                    ClientCoveragePlanId
            FROM    @CoveragePlans

    IF @@error <> 0 
        GOTO error

    INSERT  INTO @AuthorizedClientCoveragePlans
            ( ClientCoveragePlanId ,
              AuthorizedClientCoveragePlanId
	        )
            SELECT  cpa.ClientCoveragePlanId ,
                    ccp.ClientCoveragePlanId
            FROM    @CoveragePlans cpa
                    JOIN CoveragePlans cp ON cp.CoveragePlanid = cpa.CoveragePlanId
                    JOIN CoveragePlanRules cpr ON ( ( cpr.CoveragePlanId = cp.CoveragePlanId
                                                      AND ISNULL(cp.BillingRulesTemplate, 'T') = 'T'
                                                    )
                                                    OR ( cpr.CoveragePlanId = cp.UseBillingRulesTemplateId
                                                         AND ISNULL(cp.BillingRulesTemplate, 'T') = 'O'
                                                       )
                                                  )
                    JOIN ClientCoveragePlans ccp ON ccp.ClientId = @ClientId
            WHERE   cpr.RuleTypeId = 4268
                    AND cpa.ClientCoveragePlanId <> ccp.ClientCoveragePlanId
                    AND ( cpr.AppliesToAllCoveragePlans = 'Y'
                          OR EXISTS ( SELECT    1
                                      FROM      CoveragePlanRuleVariables cprv
                                      WHERE     cprv.CoveragePlanRuleId = cpr.CoveragePlanRuleId
                                                AND cprv.CoveragePlanId = ccp.CoveragePlanId
                                                AND ISNULL(cprv.RecordDeleted, 'N') = 'N' )
                        )
                    AND ISNULL(cpr.RecordDeleted, 'N') = 'N'
                    AND ISNULL(ccp.RecordDeleted, 'N') = 'N' 
    IF @@error <> 0 
        GOTO error

-- Check if Authorizations exist for them                
    DECLARE cur_PMServiceAuthorizations INSENSITIVE CURSOR
    FOR
        SELECT  Priority ,
                ClientCoveragePlanId ,
                AuthorizationId ,
                UnitsUsed ,
                UnitsScheduled
        FROM    @CoveragePlans
-- JHB 6/24/2012 Do not need this code anymore
--where AuthorizationNeeded = 'Y'                
ORDER BY        Priority

    IF @@error <> 0 
        GOTO error

    OPEN cur_PMServiceAuthorizations

    IF @@error <> 0 
        GOTO error

    FETCH cur_PMServiceAuthorizations
INTO @Priority, @varClientCoveragePlanId, @AuthorizationId, @UnitsUsed, @UnitsScheduled

    IF @@error <> 0 
        GOTO error

    WHILE @@fetch_status = 0 
        BEGIN
            SELECT  @NewAuthorizationId = NULL ,
                    @NewAuthorizationTotalUnits = NULL ,
                    @NewAuthorizationUnitsUsed = NULL ,
                    @NewAuthorizationUnitsScheduled = NULL ,
                    @NewAuthorizationStartDateUsed = NULL ,
                    @NewAuthorizationEndDateUsed = NULL ,
                    @NewUnits = NULL ,
                    @NewAuthorizationStatus = NULL ,
                    @NewAuthorizationClientCoveragePlanId = NULL

            IF @@error <> 0 
                GOTO error

	-- Check If authorization for another ClientCoveragePlanId can  be applied to current ClientCoveragePlanId                
            IF EXISTS ( SELECT  *
                        FROM    @AuthorizedClientCoveragePlans a
                                JOIN @CoveragePlans b ON ( a.AuthorizedClientCoveragePlanId = b.NewAuthorizationClientCoveragePlanId )
                        WHERE   a.ClientCoveragePlanId = @varClientCoveragePlanId ) 
                BEGIN
                    UPDATE  c
                    SET     NewAuthorizationId = b.NewAuthorizationId ,
                            NewAuthorizationTotalUnits = b.NewAuthorizationTotalUnits ,
                            NewAuthorizationUnitsUsed = b.NewAuthorizationUnitsUsed ,
                            NewAuthorizationUnitsScheduled = b.NewAuthorizationUnitsScheduled ,
                            NewAuthorizationStartDateUsed = b.NewAuthorizationStartDateUsed ,
                            NewAuthorizationEndDateUsed = b.NewAuthorizationEndDateUsed ,
                            NewUnits = b.NewUnits ,
                            NewAuthorizationStatus = b.NewAuthorizationStatus ,
                            NewAuthorizationClientCoveragePlanId = b.NewAuthorizationClientCoveragePlanId
                    FROM    @AuthorizedClientCoveragePlans a
                            JOIN @CoveragePlans b ON ( a.AuthorizedClientCoveragePlanId = b.NewAuthorizationClientCoveragePlanId )
                            JOIN @CoveragePlans c ON ( a.ClientCoveragePlanId = c.ClientCoveragePlanId )
                    WHERE   a.ClientCoveragePlanId = @varClientCoveragePlanId

                    IF @@error <> 0 
                        GOTO error
                END
            ELSE -- Look for another authorization                
                BEGIN
                    SELECT TOP 1
                            @NewAuthorizationId = b.AuthorizationId ,
                            @NewAuthorizationTotalUnits = CASE WHEN b.STATUS = 4242 THEN b.TotalUnitsRequested
                                                               ELSE b.TotalUnits
                                                          END ,
                            @NewAuthorizationUnitsUsed = b.UnitsUsed ,
                            @NewAuthorizationUnitsScheduled = b.UnitsScheduled ,
                            @NewAuthorizationStartDateUsed = b.StartDateUsed ,
                            @NewAuthorizationEndDateUsed = b.EndDateUsed ,
                             --JUN-29-2015 Gautam
                            @NewUnits = CASE when b.UnitType='D' then  @Charge
										else  ( CASE WHEN c.UnitType = 124 THEN 1
                                               ELSE FLOOR(( ( CASE @UnitType
                                                                WHEN 121 THEN 60
                                                                WHEN 122 THEN 1440
                                                                ELSE 1
                                                              END ) * @Unit ) / ( ( CASE c.UnitType
                                                                                      WHEN 121 THEN 60
                                                                                      WHEN 122 THEN 1440
                                                                                      ELSE 1
                                                                                    END ) * c.Units ))
                                          END ) END,
                            @NewAuthorizationStatus = b.STATUS ,
                            @NewAuthorizationClientCoveragePlanId = a.ClientCoveragePlanId
                    FROM    @AuthorizedClientCoveragePlans z
                            JOIN AuthorizationDocuments a ON ( a.ClientCoveragePlanId = z.AuthorizedClientCoveragePlanId )
                            JOIN Authorizations b ON ( a.AuthorizationDocumentId = b.AuthorizationDocumentId )
                            JOIN AuthorizationCodes c ON ( b.AuthorizationCodeId = c.AuthorizationCodeId )
                            JOIN AuthorizationCodeProcedureCodes d ON ( b.AuthorizationCodeId = d.AuthorizationCodeId )
                    WHERE   z.ClientCoveragePlanId = @varClientCoveragePlanId
                            AND d.ProcedureCodeId = @ProcedureCodeId
                            AND ( ( a.RecordDeleted = 'N' )
                                  OR ( a.RecordDeleted IS NULL )
                                ) --and isnull(a.RecordDeleted, 'N') = 'N'                
                            AND ( ( b.RecordDeleted = 'N' )
                                  OR ( b.RecordDeleted IS NULL )
                                ) --and isnull(b.RecordDeleted, 'N') = 'N'                
                            AND ( ( c.RecordDeleted = 'N' )
                                  OR ( c.RecordDeleted IS NULL )
                                ) --and isnull(c.RecordDeleted, 'N') = 'N'         
                            AND ( ( d.RecordDeleted = 'N' )
                                  OR ( d.RecordDeleted IS NULL )
                                ) --and isnull(d.RecordDeleted, 'N') = 'N'   
                            --JUN-29-2015 Gautam
                            AND (( b.UnitType='D' )
							or          
                             ( ( c.UnitType = @UnitType
                                    AND  @Unit >= c.Units
                                  )
                                  OR c.UnitType = 124
                                  OR  ( ( CASE @UnitType
                                           WHEN 121 THEN 60
                                           WHEN 122 THEN 1440
                                           ELSE 1
                                         END ) * @Unit >= ( CASE c.UnitType
                                                              WHEN 121 THEN 60
                                                              WHEN 122 THEN 1440
                                                              ELSE 1
                                                            END ) * c.Units )
                                     
                                ))
                            AND @DateOfService >= ( CASE WHEN b.STATUS = 4242 THEN b.StartDateRequested
                                                         ELSE b.StartDate
                                                    END )
                            AND @DateOfService < DATEADD(dd, 1, ( CASE WHEN b.STATUS = 4242 THEN b.EndDateRequested
                                                                       ELSE b.EndDate
                                                                  END ))
                            AND ( ISNULL(b.UnitsUsed, 0) + ISNULL(b.UnitsScheduled, 0) - ( CASE WHEN b.AuthorizationId = @AuthorizationId THEN ISNULL(@UnitsScheduled, 0) + ISNULL(@UnitsUsed, 0)
                                                                                                ELSE 0
                                                                                                 --JUN-29-2015 Gautam
                                                                                           END ) +   CASE when b.UnitType='D' then  @Charge 
																									else 
																										( CASE WHEN c.UnitType = 124 THEN 1
                                                                                                          ELSE FLOOR(( ( CASE @UnitType
                                                                                                                           WHEN 121 THEN 60
                                                                                                                           WHEN 122 THEN 1440
                                                                                                                           ELSE 1
                                                                                                                         END ) * @Unit ) / ( ( CASE c.UnitType
                                                                                                                                                 WHEN 121 THEN 60
                                                                                                                                                 WHEN 122 THEN 1440
                                                                                                                                                 ELSE 1
                                                                                                                                               END ) * c.Units ))
                                                                                                     END ) 
                                                                                                     end <= ( CASE WHEN b.STATUS = 4242 THEN b.TotalUnitsRequested
                                                                                                                       ELSE b.TotalUnits
                                                                                                                  END ))
                            AND NOT EXISTS ( SELECT *
                                             FROM   ServiceExcludeAuthorizations sea
                                             WHERE  sea.ServiceId = @ServiceId
                                                    AND sea.AuthorizationId = b.AuthorizationId
                                                    AND ( ( sea.RecordDeleted = 'N' )
                                                          OR ( sea.RecordDeleted IS NULL )
                                                        ) ) --and isnull(sea.RecordDeleted, 'N') = 'N')    
                    ORDER BY CASE WHEN exists ( select * from dbo.ssf_RecodeValuesCurrent('APPROVEDAUTHORIZATION') where IntegerCodeId = b.status ) THEN 1  --Added by Kavya #Thresholds Suport_1042
                                  ELSE 2
                             END ,
                            b.StartDate

                    IF @@error <> 0 
                        GOTO error

                    IF @NewAuthorizationId IS NOT NULL 
                        BEGIN
                            UPDATE  @CoveragePlans
                            SET     NewAuthorizationId = @NewAuthorizationId ,
                                    NewAuthorizationTotalUnits = @NewAuthorizationTotalUnits ,
                                    NewAuthorizationUnitsUsed = @NewAuthorizationUnitsUsed ,
                                    NewAuthorizationUnitsScheduled = @NewAuthorizationUnitsScheduled ,
                                    NewAuthorizationStartDateUsed = @NewAuthorizationStartDateUsed ,
                                    NewAuthorizationEndDateUsed = @NewAuthorizationEndDateUsed ,
                                    NewUnits = @NewUnits ,
                                    NewAuthorizationStatus = @NewAuthorizationStatus ,
                                    NewAuthorizationClientCoveragePlanId = @NewAuthorizationClientCoveragePlanId
                            WHERE   ClientCoveragePlanId = @varClientCoveragePlanId

                            IF @@error <> 0 
                                GOTO error
                        END
				-- Check if there are other scheduled services after the current date of service using authorizations              
                    ELSE 
                        IF @Status IN ( 70, 71 ) 
                            BEGIN
                                SELECT TOP 1
                                        @NewAuthorizationId = b.AuthorizationId ,
                                        @NewAuthorizationTotalUnits = CASE WHEN b.STATUS = 4242 THEN b.TotalUnitsRequested
                                                                           ELSE b.TotalUnits
                                                                      END ,
                                        @NewAuthorizationUnitsUsed = b.UnitsUsed ,
                                        @NewAuthorizationUnitsScheduled = b.UnitsScheduled ,
                                        @NewAuthorizationStartDateUsed = b.StartDateUsed ,
                                        @NewAuthorizationEndDateUsed = b.EndDateUsed ,
                                         --JUN-29-2015 Gautam
                                        @NewUnits = CASE when b.UnitType='D' then  @Charge 
													else
														( CASE WHEN c.UnitType = 124 THEN 1
                                                           ELSE FLOOR(( ( CASE @UnitType
                                                                            WHEN 121 THEN 60
                                                                            WHEN 122 THEN 1440
                                                                            ELSE 1
                                                                          END ) * @Unit ) / ( ( CASE c.UnitType
                                                                                                  WHEN 121 THEN 60
                                                                                                  WHEN 122 THEN 1440
                                                                                                  ELSE 1
                                                                                                END ) * c.Units ))
                                                      END )
                                                    end ,
                                        @NewAuthorizationStatus = b.STATUS ,
                                        @NewAuthorizationClientCoveragePlanId = a.ClientCoveragePlanId
                                FROM    @AuthorizedClientCoveragePlans z
                                        JOIN AuthorizationDocuments a ON ( a.ClientCoveragePlanId = z.AuthorizedClientCoveragePlanId )
                                        JOIN Authorizations b ON ( a.AuthorizationDocumentId = b.AuthorizationDocumentId )
                                        JOIN AuthorizationCodes c ON ( b.AuthorizationCodeId = c.AuthorizationCodeId )
                                        JOIN AuthorizationCodeProcedureCodes d ON ( b.AuthorizationCodeId = d.AuthorizationCodeId )
                                WHERE   z.ClientCoveragePlanId = @varClientCoveragePlanId
                                        AND d.ProcedureCodeId = @ProcedureCodeId
                                        AND ( ( a.RecordDeleted = 'N' )
                                              OR ( a.RecordDeleted IS NULL )
                                            ) --and isnull(a.RecordDeleted, 'N') = 'N'                
                                        AND ( ( b.RecordDeleted = 'N' )
                                              OR ( b.RecordDeleted IS NULL )
                                            ) --and isnull(b.RecordDeleted, 'N') = 'N'                
                                        AND ( ( c.RecordDeleted = 'N' )
                                              OR ( c.RecordDeleted IS NULL )
                                            ) --and isnull(c.RecordDeleted, 'N') = 'N'         
                                        AND ( ( d.RecordDeleted = 'N' )
                                              OR ( d.RecordDeleted IS NULL )
                                            ) --and isnull(d.RecordDeleted, 'N') = 'N'              
                                        AND (b.STATUS = 4242 OR  exists(select * from dbo.ssf_RecodeValuesCurrent('APPROVEDAUTHORIZATION') where IntegerCodeId = b.STATUS )) -- Approved/ Partially Denied / Partially Approved  --Added by Kavya #Thresholds Suport_1042              
                                         --JUN-29-2015 Gautam
                                        AND (( b.UnitType='D' )
										or  ( ( c.UnitType = @UnitType
                                                AND @Unit >= c.Units
                                              )
                                              OR c.UnitType = 124
                                              OR( ( CASE @UnitType
                                                       WHEN 121 THEN 60
                                                       WHEN 122 THEN 1440
                                                       ELSE 1
                                                     END ) * @Unit >= ( CASE c.UnitType
                                                                          WHEN 121 THEN 60
                                                                          WHEN 122 THEN 1440
                                                                          ELSE 1
                                                                        END ) * c.Units ))
                                              )
                                        AND @DateOfService >= ( CASE WHEN b.STATUS = 4242 THEN b.StartDateRequested
                                                                     ELSE b.StartDate
                                                                END )
                                        AND @DateOfService < DATEADD(dd, 1, ( CASE WHEN b.STATUS = 4242 THEN b.EndDateRequested
                                                                                   ELSE b.EndDate
                                                                              END ))
				-- Previous Used Units + Current Used Units should be <= Total Units on the Authorization                
				-- Do not count b.UnitsScheduled in this case              
                                        AND ( ISNULL(b.UnitsUsed, 0) - ( CASE WHEN b.AuthorizationId = @AuthorizationId THEN ISNULL(@UnitsScheduled, 0) + ISNULL(@UnitsUsed, 0)
                                                                              ELSE 0
                                                                               --JUN-29-2015 Gautam
                                                                         END ) + CASE when b.UnitType='D' then  @Charge 
																				ELSE 
																					( CASE WHEN c.UnitType = 124 THEN 1
                                                                                        ELSE FLOOR(( ( CASE @UnitType
                                                                                                         WHEN 121 THEN 60
                                                                                                         WHEN 122 THEN 1440
                                                                                                         ELSE 1
                                                                                                       END ) * @Unit ) / ( ( CASE c.UnitType
                                                                                                                               WHEN 121 THEN 60
                                                                                                                               WHEN 122 THEN 1440
                                                                                                                               ELSE 1
                                                                                                                             END ) * c.Units ))
                                                                                   END ) 
                                                                                  END 
                                                                                  <= ( CASE WHEN b.STATUS = 4242 THEN b.TotalUnitsRequested
                                                                                                     ELSE b.TotalUnits
                                                                                                END ))
                                        AND EXISTS ( SELECT *
                                                     FROM   ServiceAuthorizations y
                                                            JOIN Services x ON ( y.ServiceId = x.ServiceId )
                                                     WHERE  y.AuthorizationId = b.AuthorizationId
                                                            AND x.ClientId = @ClientId
                                                            AND x.DateOfService > @DateOfService
                                                            AND x.STATUS IN ( 70, 71 )
                                                            AND ( ( y.RecordDeleted = 'N' )
                                                                  OR ( y.RecordDeleted IS NULL )
                                                                ) --and isnull(y.RecordDeleted,'N') = 'N'                
                                                            AND ( ( x.RecordDeleted = 'N' )
                                                                  OR ( x.RecordDeleted IS NULL )
                                                                ) ) --and isnull(x.RecordDeleted,'N') = 'N')       
                                        AND NOT EXISTS ( SELECT *
                                                         FROM   ServiceExcludeAuthorizations sea
                                                         WHERE  sea.ServiceId = @ServiceId
                                                                AND sea.AuthorizationId = b.AuthorizationId
                                                                AND ( ( sea.RecordDeleted = 'N' )
                                                                      OR ( sea.RecordDeleted IS NULL )
                                                                    ) ) --and isnull(sea.RecordDeleted, 'N') = 'N')                                        
                                ORDER BY b.StartDate

                                IF @@error <> 0 
                                    GOTO error

                                IF @NewAuthorizationId IS NOT NULL 
                                    BEGIN
                                        UPDATE  @CoveragePlans
                                        SET     NewAuthorizationId = @NewAuthorizationId ,
                                                RedistributeAuthorization = 'Y'
                                        WHERE   ClientCoveragePlanId = @varClientCoveragePlanId

                                        IF @@error <> 0 
                                            GOTO error
                                    END
                            END -- @Status in (70. 71)            
				-- JHB 6/9/2103 
				-- Completed services get priority to use authorizations              
                        ELSE 
                            IF @Status = 75 
                                BEGIN
                                    SELECT TOP 1
                                            @NewAuthorizationId = b.AuthorizationId ,
                                            @NewAuthorizationTotalUnits = b.TotalUnits ,
                                            @NewAuthorizationUnitsUsed = b.UnitsUsed ,
                                            @NewAuthorizationUnitsScheduled = b.UnitsScheduled ,
                                            @NewAuthorizationStartDateUsed = b.StartDateUsed ,
                                            @NewAuthorizationEndDateUsed = b.EndDateUsed ,
                                             --JUN-29-2015 Gautam
                                            @NewUnits = CASE when b.UnitType='D' then  @Charge 
														ELSE
															( CASE WHEN c.UnitType = 124 THEN 1
                                                               ELSE FLOOR(( ( CASE @UnitType
                                                                                WHEN 121 THEN 60
                                                                                WHEN 122 THEN 1440
                                                                                ELSE 1
                                                                              END ) * @Unit ) / ( ( CASE c.UnitType
                                                                                                      WHEN 121 THEN 60
                                                                                                      WHEN 122 THEN 1440
                                                                                                      ELSE 1
                                                                                                    END ) * c.Units ))
                                                          END ) 
                                                        END,
                                            @NewAuthorizationStatus = b.STATUS ,
                                            @NewAuthorizationClientCoveragePlanId = a.ClientCoveragePlanId
                                    FROM    @AuthorizedClientCoveragePlans z
                                            JOIN AuthorizationDocuments a ON ( a.ClientCoveragePlanId = z.AuthorizedClientCoveragePlanId )
                                            JOIN Authorizations b ON ( a.AuthorizationDocumentId = b.AuthorizationDocumentId )
                                            JOIN AuthorizationCodes c ON ( b.AuthorizationCodeId = c.AuthorizationCodeId )
                                            JOIN AuthorizationCodeProcedureCodes d ON ( b.AuthorizationCodeId = d.AuthorizationCodeId )
                                    WHERE   z.ClientCoveragePlanId = @varClientCoveragePlanId
                                            AND d.ProcedureCodeId = @ProcedureCodeId
                                            AND ( ( a.RecordDeleted = 'N' )
                                                  OR ( a.RecordDeleted IS NULL )
                                                ) --and isnull(a.RecordDeleted, 'N') = 'N'                
                                            AND ( ( b.RecordDeleted = 'N' )
                                                  OR ( b.RecordDeleted IS NULL )
                                                ) --and isnull(b.RecordDeleted, 'N') = 'N'                
                                            AND ( ( c.RecordDeleted = 'N' )
                                                  OR ( c.RecordDeleted IS NULL )
                                                ) --and isnull(c.RecordDeleted, 'N') = 'N'         
                                            AND ( ( d.RecordDeleted = 'N' )
                                                  OR ( d.RecordDeleted IS NULL )
                                                ) --and isnull(d.RecordDeleted, 'N') = 'N'              
                                            AND exists( select * from dbo.ssf_RecodeValuesCurrent('APPROVEDAUTHORIZATION') where IntegerCodeId = b.STATUS ) -- Only Approved / Partially Denied / Partially Approved   --Added by Kavya #Thresholds Suport_1042         
                                             --JUN-29-2015 Gautam
                                            AND (( b.UnitType='D' )
											or  ( ( c.UnitType = @UnitType
																	AND  @Unit >= c.Units
																  )
																  OR c.UnitType = 124
																  OR ( ( CASE @UnitType
																		   WHEN 121 THEN 60
																		   WHEN 122 THEN 1440
																		   ELSE 1
																		 END ) * @Unit >= ( CASE c.UnitType
																							  WHEN 121 THEN 60
																							  WHEN 122 THEN 1440
																							  ELSE 1
																							END ) * c.Units )
																)
												)
                                            AND @DateOfService >= b.StartDate
                                            AND @DateOfService < DATEADD(dd, 1, b.EndDate)
				-- Previous Used Units + Current Used Units should be <= Total Units on the Authorization                
				-- Do not count b.UnitsScheduled in this case              
                                            AND ( ISNULL(b.UnitsUsed, 0) - ( CASE WHEN b.AuthorizationId = @AuthorizationId THEN ISNULL(@UnitsScheduled, 0) + ISNULL(@UnitsUsed, 0)
                                                                                  ELSE 0
                                                                                   --JUN-29-2015 Gautam
                                                                             END ) + CASE when b.UnitType='D' then  @Charge 
																					 ELSE
																						( CASE WHEN c.UnitType = 124 THEN 1
                                                                                            ELSE FLOOR(( ( CASE @UnitType
                                                                                                             WHEN 121 THEN 60
                                                                                                             WHEN 122 THEN 1440
                                                                                                             ELSE 1
                                                                                                           END ) * @Unit ) / ( ( CASE c.UnitType
                                                                                                                                   WHEN 121 THEN 60
                                                                                                                                   WHEN 122 THEN 1440
                                                                                                                                   ELSE 1
                                                                                                                                 END ) * c.Units ))
                                                                                       END ) 
                                                                                       END )<= b.TotalUnits
                                            AND NOT EXISTS ( SELECT *
                                                             FROM   ServiceExcludeAuthorizations sea
                                                             WHERE  sea.ServiceId = @ServiceId
                                                                    AND sea.AuthorizationId = b.AuthorizationId
                                                                    AND ( ( sea.RecordDeleted = 'N' )
                                                                          OR ( sea.RecordDeleted IS NULL )
                                                                        ) ) --and isnull(sea.RecordDeleted, 'N') = 'N')                                        
                                    ORDER BY b.StartDate

                                    IF @@error <> 0 
                                        GOTO error

                                    IF @NewAuthorizationId IS NOT NULL 
                                        BEGIN
                                            UPDATE  @CoveragePlans
                                            SET     NewAuthorizationId = @NewAuthorizationId ,
                                                    RedistributeAuthorization = 'Y'
                                            WHERE   ClientCoveragePlanId = @varClientCoveragePlanId

                                            IF @@error <> 0 
                                                GOTO error
                                        END
                                END -- @Status = 75                
                END -- Find another authorization                

            FETCH cur_PMServiceAuthorizations
	INTO @Priority, @varClientCoveragePlanId, @AuthorizationId, @UnitsUsed, @UnitsScheduled

            IF @@error <> 0 
                GOTO error
        END

    CLOSE cur_PMServiceAuthorizations

    IF @@error <> 0 
        GOTO error

    DEALLOCATE cur_PMServiceAuthorizations

    IF @@error <> 0 
        GOTO error

-- Check if the same authorization is being used for more than 1 coverage                
    UPDATE  a
    SET     ReusedAuthorization = 'Y'
    FROM    @CoveragePlans a
            JOIN @CoveragePlans b ON ( a.AuthorizationId = b.AuthorizationId )
    WHERE   a.Priority > b.Priority

    IF @@error <> 0 
        GOTO error

--  Update Tables                
    BEGIN TRAN

    IF @@error <> 0 
        GOTO error

-- Capture current units used and scheduled before any changes in service authorizations
-- One authorization can be used by 2 plans in the service so use the max units               
    INSERT  INTO @RecalculateAuthorizations
            ( AuthorizationId ,
              CurrentUnitsUsed ,
              CurrentUnitsScheduled
	        )
            SELECT  sa.AuthorizationId ,
                    MAX(sa.UnitsUsed) ,
                    MAX(sa.UnitsScheduled)
            FROM    ServiceAuthorizations sa
            WHERE   sa.ServiceId = @ServiceId
                    AND sa.AuthorizationId IS NOT NULL
                    AND ( ( sa.RecordDeleted = 'N' )
                          OR ( sa.RecordDeleted IS NULL )
                        ) --and isnull(sa.RecordDeleted,'N') = 'N' 
GROUP BY            sa.AuthorizationId

    IF @@error <> 0 
        GOTO error

-- Delete current service authorizations               
    DELETE  ServiceAuthorizations
    WHERE   ServiceId = @ServiceId
            AND ( @ClientCoveragePlanId IS NULL
                  OR ClientCoveragePlanId = @ClientCoveragePlanId
                )

    IF @@error <> 0 
        GOTO error

-- Insert recalculated service authorizations              
    INSERT  INTO ServiceAuthorizations
            ( ServiceId ,
              ClientCoveragePlanId ,
              AuthorizationId ,
              AuthorizationRequested ,
              UnitsUsed ,
              UnitsScheduled ,
              CreatedBy ,
              CreatedDate ,
              ModifiedBy ,
              ModifiedDate
	        )
            SELECT  @ServiceId ,
                    ClientCoveragePlanId ,
                    CASE WHEN RedistributeAuthorization = 'Y'
                              OR ( @Status = 75
                                   AND not exists( select * from dbo.ssf_RecodeValuesCurrent('APPROVEDAUTHORIZATION') where IntegerCodeId = NewAuthorizationStatus ) --Added by Kavya #Thresholds Suport_1042
                                 ) THEN NULL
                         ELSE NewAuthorizationId
                    END ,
                    CASE WHEN RedistributeAuthorization = 'Y' THEN 'N'
                         ELSE CASE WHEN exists ( select * from dbo.ssf_RecodeValuesCurrent('APPROVEDAUTHORIZATION') where IntegerCodeId = NewAuthorizationStatus )--Added by Kavya #Thresholds Suport_1042
                                        OR NewAuthorizationId IS NULL THEN 'N'
                                   ELSE 'Y'
                              END
                    END ,
                    CASE WHEN RedistributeAuthorization = 'Y' THEN NULL
                         ELSE CASE WHEN @Status = 75
                                        AND ( exists (select * from dbo.ssf_RecodeValuesCurrent('APPROVEDAUTHORIZATION') where IntegerCodeId = NewAuthorizationStatus) ) THEN NewUnits --Added by Kavya #Thresholds Suport_1042
                                   ELSE NULL
                              END
                    END ,
                    CASE WHEN RedistributeAuthorization = 'Y' THEN NULL
                         ELSE CASE WHEN @Status <> 75 THEN NewUnits
                                   ELSE NULL
                              END
                    END ,
                    @CurrentUser ,
                    @CurrentDate ,
                    @CurrentUser ,
                    @CurrentDate
            FROM    @CoveragePlans

    IF @@error <> 0 
        GOTO error

-- Capture new units used and scheduled
    MERGE @RecalculateAuthorizations AS target
        USING 
            ( SELECT    sa.AuthorizationId ,
                        MAX(sa.UnitsUsed) ,
                        MAX(sa.UnitsScheduled)
              FROM      ServiceAuthorizations sa
              WHERE     sa.ServiceId = @ServiceId
                        AND sa.AuthorizationId IS NOT NULL
                        AND ( ( sa.RecordDeleted = 'N' )
                              OR ( sa.RecordDeleted IS NULL )
                            ) --and isnull(sa.RecordDeleted,'N') = 'N' 
              GROUP BY  sa.AuthorizationId
            ) AS source ( AuthorizationId, NewUnitsUsed, NewUnitsScheduled )
        ON ( target.AuthorizationId = source.AuthorizationId )
        WHEN MATCHED 
            THEN
		UPDATE SET
                NewUnitsUsed = source.NewUnitsUsed ,
                NewUnitsScheduled = source.NewUnitsScheduled
        WHEN NOT MATCHED 
            THEN
		INSERT  (
                  AuthorizationId ,
                  NewUnitsUsed ,
                  NewUnitsScheduled
			    )
               VALUES
                ( source.AuthorizationId ,
                  source.NewUnitsUsed ,
                  source.NewUnitsScheduled
			    );

    IF @@error <> 0 
        GOTO error
		-- Update affected authorizations with units used and scheduled
		-- Also recalculate StartDateUsed and EndDateUsed                
		;

    WITH    CTE_AuthorizationUsed ( AuthorizationId, StartDateUsed, EndDateUsed )
              AS ( SELECT   ra.AuthorizationId ,
                            MIN(CONVERT(DATETIME, CONVERT(VARCHAR(10), s.DateOfService, 101))) ,
                            MAX(CONVERT(DATETIME, CONVERT(VARCHAR(10), s.DateOfService, 101)))
                   FROM     @RecalculateAuthorizations ra
                            JOIN ServiceAuthorizations sa ON sa.AuthorizationId = ra.AuthorizationId
                            JOIN Services s ON s.ServiceId = sa.ServiceId
                   WHERE    s.STATUS = 75
                            AND ( ( sa.RecordDeleted = 'N' )
                                  OR ( sa.RecordDeleted IS NULL )
                                ) --and isnull(sa.RecordDeleted, 'N') = 'N'              
                   GROUP BY ra.AuthorizationId
                 )
        UPDATE  a
        SET     UnitsUsed = ISNULL(a.UnitsUsed, 0) - ISNULL(ra.CurrentUnitsUsed, 0) + ISNULL(ra.NewUnitsUsed, 0) ,
                UnitsScheduled = ISNULL(a.UnitsScheduled, 0) - ISNULL(ra.CurrentUnitsScheduled, 0) + ISNULL(ra.NewUnitsScheduled, 0) ,
                StartDateUsed = au.StartDateUsed ,
                EndDateUsed = au.EndDateUsed ,
                ModifiedBy = @CurrentUser ,
                ModifiedDate = @CurrentDate
        FROM    Authorizations a
                JOIN @RecalculateAuthorizations ra ON ra.AuthorizationId = a.AuthorizationId
                LEFT JOIN CTE_AuthorizationUsed au ON au.AuthorizationId = a.AuthorizationId

 
    IF @@error <> 0 
        GOTO error
		-- Recalculate service authorization counters
		;

    WITH    CTE_ServiceAuthorizations ( ServiceId, AuthorizationsApproved, AuthorizationsNeeded, AuthorizationsRequested )
              AS ( SELECT   sa.ServiceId ,
                            COUNT(DISTINCT CASE WHEN a.Status is not null THEN a.AuthorizationId
                                                ELSE NULL
                                           END) ,
                            SUM(CASE WHEN a.AuthorizationId IS NULL THEN 1
                                     ELSE 0
                                END) ,
                            SUM(CASE WHEN sa.AuthorizationRequested = 'Y' THEN 1
                                     ELSE 0
                                END)
                   FROM     ServiceAuthorizations sa
                            LEFT JOIN Authorizations a ON a.AuthorizationId = sa.AuthorizationId
                            left JOIN dbo.ssf_RecodeValuesCurrent('APPROVEDAUTHORIZATION') r on r.IntegerCodeId = a.Status      --Added by Kavya #Thresholds Suport_1042
                   WHERE    sa.ServiceId = @ServiceId
                            AND ( ( sa.RecordDeleted = 'N' )
                                  OR ( sa.RecordDeleted IS NULL )
                                ) --and isnull(sa.RecordDeleted, 'N') = 'N'
                   GROUP BY sa.ServiceId
                 )
        UPDATE  s
        SET     AuthorizationsApproved = ISNULL(sa.AuthorizationsApproved, 0) ,
                AuthorizationsNeeded = ISNULL(sa.AuthorizationsNeeded, 0) ,
                AuthorizationsRequested = ISNULL(sa.AuthorizationsRequested, 0)
        FROM    Services s
                LEFT JOIN CTE_ServiceAuthorizations sa ON sa.ServiceId = s.ServiceId
        WHERE   s.ServiceId = @ServiceId

    IF @@error <> 0 
        GOTO error
        -- Modified by Bernardin for CEI - SGL#659
        IF @Status = 73
		BEGIN
		
			Update A
			set A.UnitsScheduled=A.UnitsScheduled - b.UnitsScheduled
			From Authorizations A Join (
			SELECT  SA.AuthorizationId,sum(Sa.UnitsScheduled) UnitsScheduled from ServiceAuthorizations SA where 
			Sa.ServiceId = @ServiceId and ( Sa.UnitsScheduled is not null)
			and exists(Select 1 from Services S where SA.ServiceId=S.ServiceId and S.Status=73
			and ISNULL(S.recorddeleted,'N')='N') and ISNULL(SA.recorddeleted,'N')='N'
			group by SA.AuthorizationId) B on A.AuthorizationId= B.AuthorizationId
		
		END
      -- Changes ends here
    COMMIT TRANSACTION

    IF @@error <> 0 
        GOTO error

    DECLARE cur_PMServiceAuthorizations2 CURSOR LOCAL
    FOR
        SELECT  NewAuthorizationId
        FROM    @CoveragePlans
        WHERE   RedistributeAuthorization = 'Y'

    IF @@error <> 0 
        GOTO error

    OPEN cur_PMServiceAuthorizations2

    IF @@error <> 0 
        GOTO error

    FETCH cur_PMServiceAuthorizations2
INTO @AuthorizationId

    IF @@error <> 0 
        GOTO error

    WHILE @@fetch_status = 0 
        BEGIN
            EXEC ssp_SCAuthorizationAssociateServices @CurrentUser, @AuthorizationId

            IF @@error <> 0 
                GOTO error

            FETCH cur_PMServiceAuthorizations2
	INTO @AuthorizationId

            IF @@error <> 0 
                GOTO error
        END

    CLOSE cur_PMServiceAuthorizations2

    IF @@error <> 0 
        GOTO error

    DEALLOCATE cur_PMServiceAuthorizations2

    IF @@error <> 0 
        GOTO error

    RETURN

    error:

    IF @@trancount > 0 
        ROLLBACK
GO