/****** Object:  StoredProcedure [dbo].[ssp_CheckCoveragePlanRules]    Script Date: 11/6/2017 2:01:22 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CheckCoveragePlanRules]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CheckCoveragePlanRules]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CheckCoveragePlanRules]    Script Date: 11/6/2017 2:01:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CheckCoveragePlanRules]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssp_CheckCoveragePlanRules] AS' 
END
GO


ALTER PROCEDURE [dbo].[ssp_CheckCoveragePlanRules]
    @ServiceId INT = NULL ,
    @CoveragePlanId INT = NULL ,
    @ChargeId INT = NULL ,
    @RuleTypeId INT = NULL                
/*********************************************************************                
-- Stored Procedure: dbo.ssp_CheckCoveragePlanRules                
--                
-- Copyright: 2006 Streamline Healthcare Solutions                
-- Creation Date:  10.01.2006                
--                
-- Purpose: Checks coverage plan rules                
--                
-- Data Modifications:                
--                
-- Updates:                 
--  Date         Author    Purpose                
-- 10.01.2006    SFarber   Created.                
-- 12.08.2006    SFarber   Modified code for rule #4263.                
-- 04.29.2008    SFerenz   Modified logic for rule #4263 finding Services Denied by Medicare   
-- 05.27.2013	 JHB       Modified logic for Procedure Code check, added ProgramPlans logic, added logic to handle Billing Rules templates            
-- 06.20.2013    SFarber   Added code for rule #4264 - Authorization is required  
-- 08.22.2013    SFarber   Modified spend down logic for rules #4557 and #4558
-- 10.07.2014    Akwinass  Removed columns @DSMCode1,@DSMCode2,@DSMCode3 and modified the logic based on 'ServiceDiagnosis' table  (Task #134 in Engineering Improvement Initiatives- NBL(I))
-- 07.31.2015    SFarber   Modified for ICD10 changes.
-- 08.29.2015    SFarber   Added code for rule #4272 - Non-billable primary diagnosis codes
-- 11.12.2015	 NJain	   Updated must have these Dx for these codes rule to validate for any one diagnosis in the rule to be on the service. Old Logic was validating for all diagnoses to be on the service.
-- 11.18.2015	 NJain	   Added Check for if the Service is ICD10 or ICD9. If both rules exist and the service has only one type of diagnosis, validation fails
-- 04.20.2016	 NJain	   Updated the Treatment Plan does not exist Rule to also include the Core Treatment Plan (DocumentCarePlans, CarePlanPrescribedServices). EII #415
						   This will work in addition to the MI Treatment Plan this rule was originally set up for. 
-- 08.07.2017	 NJain	   Removed join on DocumentCarePlans for the Tx Plan validation. It should work for most Tx Plans with these tables: DocumentCarePlans, CarePlanPrescribedService 			AP SGL #381	   
-- 11.06.2017	 tchen	   Added logic for Rule Type #4275 for MHP - Implementation #98
-- 01.21.2019    GSelvamani Changed table valued variables to temp tables and added scsp hook for custom rules - Childrens Services Center-Implementation: #20
-- 01.24.2019	 mjensen	Rule 4275 should not throw charge error if procedure code is not in the rules list.  MHP SGL #100.
-- 01.24.2019	 mjensen	Correct previous comment - Task should be BBT SGL #100
-- 01.24.2019	 mjensen	Rule 4275 not checking for all degrees flag.		BBT SGL #100
**********************************************************************/
AS
    CREATE TABLE #RulesToCheck
        (
          CoveragePlanRuleId INT NULL ,
          RuleTypeId INT NULL ,
          AppliesToAllProcedureCodes CHAR(1) ,
          AppliesToAllStaff CHAR(1) ,
          AppliesToAllDSMCodes CHAR(1) ,
          AppliesToAllICD9Codes CHAR(1) ,
          AppliesToAllICD10Codes CHAR(1) ,
          AppliesToAllCoveragePlans CHAR(1) ,
          RuleViolationAction INT
        )                 

    CREATE TABLE #RuleVariables
        (
          CoveragePlanRuleId INT NULL ,
          ProcedureCodeId INT NULL ,
          CoveragePlanId INT NULL ,
          StaffId INT NULL ,
          DiagnosisCode VARCHAR(20) NULL ,
          DiagnosisCodeType VARCHAR(10) NULL ,
		  DegreeId INT,
          AppliesToAllProcedureCodes CHAR(1) ,
          AppliesToAllStaff CHAR(1) ,
          AppliesToAllDSMCodes CHAR(1) ,
          AppliesToAllICD9Codes CHAR(1) ,
          AppliesToAllICD10Codes CHAR(1) ,
          AppliesToAllCoveragePlans CHAR(1),
		  AppliesToAllDegrees CHAR(1)
        )  
                
    CREATE TABLE #RuleErrors ( ErrorId INT NULL )            
                
    CREATE TABLE #RuleTreatmentPlan 
        (
          DocumentId INT NULL ,
          Signed CHAR(1) NULL ,
          ProcedureCodeId INT NULL
        )                
                
    CREATE TABLE #RuleLimits 
        (
          Daily DECIMAL(18, 2) NULL ,
          Weekly DECIMAL(18, 2) NULL ,
          Monthly DECIMAL(18, 2) NULL ,
          Yearly DECIMAL(18, 2) NULL
        )                
                
              
    DECLARE @ErrorNo INT                
    DECLARE @ErrorMessage VARCHAR(100)                
    DECLARE @ProcedureCodeId INT                
    DECLARE @ClinicianId INT                
    DECLARE @ClientId INT                
    DECLARE @Attendingid INT                
    DECLARE @DateOfService DATETIME                
    DECLARE @ChargePriority INT                
    DECLARE @DailyLimit DECIMAL(18, 2)                
    DECLARE @WeeklyLimit DECIMAL(18, 2)                
    DECLARE @MonthlyLimit DECIMAL(18, 2)                
    DECLARE @YearlyLimit DECIMAL(18, 2)                
    DECLARE @Units DECIMAL(18, 2)
    DECLARE @DSMCode VARCHAR(20)
    DECLARE @ICD10Code VARCHAR(20)
    DECLARE @ICD9Code VARCHAR(20)
    DECLARE @ICD10StartDate DATETIME
    DECLARE @IsICD10Service CHAR(1)
                
    DECLARE @ClientCoveragePlanId INT  
    DECLARE @BillingRulesCoveragePlanId INT             
                
-- Check arguments                
    IF @ServiceId IS NOT NULL
        AND @CoveragePlanId IS NULL
        BEGIN                
            SELECT  @ErrorNo = 50010 ,
                    @ErrorMessage = '@CoveragePlanId argument has not been specified.'                
            GOTO error                
        END                

    IF @ServiceId IS NULL
        AND @ChargeId IS NULL
        BEGIN                
            SELECT  @ErrorNo = 50020 ,
                    @ErrorMessage = 'Either @ServiceId or @ChargeId argument has to be specified.'                
            GOTO error                
        END                
              
    IF @ServiceId IS NULL
        BEGIN
            SELECT  @ServiceId = ServiceId ,
                    @CoveragePlanId = ccp.CoveragePlanId ,
                    @ClientCoveragePlanId = c.ClientCoveragePlanId
            FROM    Charges c
                    JOIN ClientCoveragePlans ccp ON ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
            WHERE   c.ChargeId = @ChargeId                
        END
                
    IF @ChargeId IS NULL
        BEGIN
            SELECT  @ChargeId = ChargeId ,
                    @ClientCoveragePlanId = c.ClientCoveragePlanId
            FROM    Charges c
                    JOIN ClientCoveragePlans ccp ON ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
            WHERE   c.ServiceId = @ServiceId
                    AND ccp.CoveragePlanId = @CoveragePlanId
                    AND ISNULL(c.RecordDeleted, 'N') = 'N'                
        END
                
    SELECT  @ChargePriority = Priority
    FROM    Charges
    WHERE   ChargeId = @ChargeId                
                
    SELECT  @ProcedureCodeId = s.ProcedureCodeId ,
            @ClinicianId = s.Clinicianid ,
            @ClientId = s.ClientId ,
            @AttendingId = s.AttendingId ,
            @DateOfService = s.DateOfService
    FROM    Services s
    WHERE   s.ServiceId = @ServiceId                
                
-- Determine if Billing Rules Template is different from Coverage Plan 
    SELECT  @BillingRulesCoveragePlanId = cp.UseBillingRulesTemplateId
    FROM    CoveragePlans cp
    WHERE   cp.CoveragePlanId = @CoveragePlanId
            AND cp.BillingRulesTemplate = 'O'

    IF @BillingRulesCoveragePlanId IS NULL
        SET @BillingRulesCoveragePlanId = @CoveragePlanId
	
	
	
    SELECT  @ICD10StartDate = CAST(ISNULL(ICD10StartDate, '10/1/2015') AS DATE)
    FROM    dbo.CoveragePlans
    WHERE   CoveragePlanId = @CoveragePlanId
	
	
    SELECT  @IsICD10Service = 'Y'
    FROM    dbo.Services
    WHERE   ServiceId = @ServiceId
            AND CAST(DateOfService AS DATE) >= CAST(@ICD10StartDate AS DATE)
	
    SELECT  @IsICD10Service = ISNULL(@IsICD10Service, 'N')
    
	
-- Get all the rules that need to be checked                
    INSERT  INTO #RulesToCheck
            ( CoveragePlanRuleId ,
              RuleTypeId ,
              AppliesToAllProcedureCodes ,
              AppliesToAllStaff ,
              AppliesToAllDSMCodes ,
              AppliesToAllICD9Codes ,
              AppliesToAllICD10Codes ,
              AppliesToAllCoveragePlans ,
              RuleViolationAction
            )
            SELECT  r.CoveragePlanRuleId ,
                    r.RuleTypeId ,
                    r.AppliesToAllProcedureCodes ,
                    r.AppliesToAllStaff ,
                    r.AppliesToAllDSMCodes ,
                    r.AppliesToAllICD9Codes ,
                    r.AppliesToAllICD10Codes ,
                    r.AppliesToAllCoveragePlans ,
                    r.RuleViolationAction
            FROM    CoveragePlanRules r
                    JOIN dbo.GlobalCodes rt ON rt.GlobalCodeId = r.RuleTypeId
            WHERE   r.CoveragePlanId = @BillingRulesCoveragePlanId
                    AND ( r.RuleTypeId = @RuleTypeId
                          OR @RuleTypeId IS NULL
                        )
                    AND rt.Active = 'Y'
                    AND ISNULL(r.RecordDeleted, 'N') = 'N'
                    AND ISNULL(rt.RecordDeleted, 'N') = 'N'


    INSERT  INTO #RuleVariables
            ( CoveragePlanRuleId ,
              ProcedureCodeId ,
              CoveragePlanId ,
              StaffId ,
              DiagnosisCode ,
              DiagnosisCodeType ,
			  DegreeId,
              AppliesToAllProcedureCodes ,
              AppliesToAllStaff ,
              AppliesToAllDSMCodes ,
              AppliesToAllICD9Codes ,
              AppliesToAllICD10Codes ,
              AppliesToAllCoveragePlans,
			  AppliesToAllDegrees
            )
            SELECT  rv.CoveragePlanRuleId ,
                    rv.ProcedureCodeId ,
                    rv.CoveragePlanId ,
                    rv.StaffId ,
                    rv.DiagnosisCode ,
                    rv.DiagnosisCodeType ,
					rv.DegreeId,
                    rv.AppliesToAllProcedureCodes ,
                    rv.AppliesToAllStaff ,
                    rv.AppliesToAllDSMCodes ,
                    rv.AppliesToAllICD9Codes ,
                    rv.AppliesToAllICD10Codes ,
                    rv.AppliesToAllCoveragePlans,
					rv.AppliesToAllDegrees
            FROM    #RulesToCheck r
                    JOIN dbo.CoveragePlanRuleVariables rv ON rv.CoveragePlanRuleId = r.CoveragePlanRuleId
            WHERE   ISNULL(rv.RecordDeleted, 'N') = 'N'

                
--                
-- Rule 4261 - Code must exist on a Treatment Plan before creating a charge                
--                
    IF EXISTS ( SELECT  *
                FROM    #RulesToCheck r
                WHERE   r.RuleTypeId = 4261
                        AND ( r.AppliesToAllProcedureCodes = 'Y'
                              OR EXISTS ( SELECT    *
                                          FROM      #RuleVariables rv
                                          WHERE     rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                                                    AND rv.ProcedureCodeId = @ProcedureCodeId )
                            ) )
        BEGIN                

            INSERT  INTO #RuleTreatmentPlan
                    ( DocumentId ,
                      Signed ,
                      ProcedureCodeId
                    )
                    SELECT  d.DocumentId ,
                            CASE WHEN d.SignedByAuthor = 'Y'
                                      OR d.SignedByAll = 'Y' THEN 'Y'
                                 ELSE 'N'
                            END ,
                            acpc.ProcedureCodeId
                    FROM    Documents d
                            JOIN TPGeneral tpg ON tpg.DocumentVersionId = d.CurrentDocumentVersionId
                            LEFT JOIN AuthorizationCodeProcedureCodes acpc ON acpc.ProcedureCodeId = @ProcedureCodeId
                                                                              AND ISNULL(acpc.RecordDeleted, 'N') = 'N'
                            LEFT JOIN TPProcedures tpp ON tpp.DocumentVersionId = d.CurrentDocumentVersionId
                                                          AND tpp.AuthorizationCodeId = acpc.AuthorizationCodeId
                                                          AND ISNULL(tpp.StartDate, @DateOfService) <= @DateOfService
                                                          AND ( DATEADD(dd, 1, tpp.EndDate) > @DateOfService
                                                                OR tpp.EndDate IS NULL
                                                              )
                                                          AND ISNULL(tpp.RecordDeleted, 'N') = 'N'
                    WHERE   d.ClientId = @ClientId
                            AND ISNULL(d.RecordDeleted, 'N') = 'N'
                            AND ISNULL(tpg.RecordDeleted, 'N') = 'N'
                    UNION
                    SELECT  d.DocumentId ,
                            CASE WHEN d.SignedByAuthor = 'Y'
                                      OR d.SignedByAll = 'Y' THEN 'Y'
                                 ELSE 'N'
                            END ,
                            acpc.ProcedureCodeId
                    FROM    Documents d
                            --JOIN DocumentCarePlans dcp ON dcp.DocumentVersionId = d.CurrentDocumentVersionId
                            JOIN CarePlanPrescribedServices cpps ON cpps.DocumentVersionId = d.CurrentDocumentVersionId
                            JOIN AuthorizationCodeProcedureCodes acpc ON cpps.AuthorizationCodeId = acpc.AuthorizationCodeId
                    WHERE   d.ClientId = @ClientId
                            AND acpc.ProcedureCodeId = @ProcedureCodeId
                            AND ISNULL(d.EffectiveDate, @DateOfService) <= @DateOfService
                            AND ISNULL(d.RecordDeleted, 'N') = 'N'
                            --AND ISNULL(dcp.RecordDeleted, 'N') = 'N'
                            AND ISNULL(acpc.RecordDeleted, 'N') = 'N'
                            AND ISNULL(cpps.RecordDeleted, 'N') = 'N'
                            
                            								          
                 
            IF @@rowcount = 0
                INSERT  INTO #RuleErrors
                        ( ErrorId )
                        SELECT  4552 -- Treatment Plan does not exist                
            ELSE
                IF NOT EXISTS ( SELECT  *
                                FROM    #RuleTreatmentPlan
                                WHERE   ProcedureCodeId IS NOT NULL )
                    INSERT  INTO #RuleErrors
                            ( ErrorId )
                            SELECT  4541 -- Code must exist on a treatment plan before creating a charge                
                ELSE
                    IF NOT EXISTS ( SELECT  *
                                    FROM    #RuleTreatmentPlan
                                    WHERE   Signed = 'Y' )
                        INSERT  INTO #RuleErrors
                                ( ErrorId )
                                SELECT  4555 -- Treatment Plan is not signed                    
        END                
                
--                
-- Rule 4262 - Attending must be specified on a service that uses this code                
--                
    IF EXISTS ( SELECT  *
                FROM    #RulesToCheck r
                WHERE   r.RuleTypeId = 4262
                        AND ( r.AppliesToAllProcedureCodes = 'Y'
                              OR EXISTS ( SELECT    *
                                          FROM      #RuleVariables rv
                                          WHERE     rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                                                    AND rv.ProcedureCodeId = @ProcedureCodeId )
                            ) )
        AND @AttendingId IS NULL
        BEGIN
            INSERT  INTO #RuleErrors
                    ( ErrorId )
                    SELECT  4542 -- Attending must be specified on a service that uses this code                
        END                
                
                            
--                
-- Rule 4265 - No more than x contacts per period                 
--                 
    SELECT TOP 1
            @DailyLimit = ISNULL(l.Daily, 0) ,
            @WeeklyLimit = ISNULL(l.Weekly, 0) ,
            @MonthlyLimit = ISNULL(l.Monthly, 0) ,
            @YearlyLimit = ISNULL(l.Yearly, 0)
    FROM    #RulesToCheck r
            JOIN CoveragePlanRuleLimits l ON l.CoveragePlanRuleId = r.CoveragePlanRuleId
    WHERE   r.RuleTypeId = 4265
            AND l.LimitType = 4141 -- Number of Services                
            AND l.ProcedureCodeId = @ProcedureCodeId
            AND ISNULL(l.RecordDeleted, 'N') = 'N'                
                
    IF @@rowcount > 0
        BEGIN                
            IF EXISTS ( SELECT  '*'
                        FROM    Services s
                        WHERE   s.ProcedureCodeId = @ProcedureCodeId
                                AND s.ServiceId <> @ServiceId
                                AND s.Status IN ( 71, 75 ) -- Show, Complete                
                                AND ISNULL(s.RecordDeleted, 'N') = 'N'
                                AND @DailyLimit > 0
                                AND CONVERT(CHAR(8), s.DateOfService, 112) = CONVERT(CHAR(8), @DateOfService, 112)
                        HAVING  COUNT(*) + 1 > @DailyLimit )
                OR EXISTS ( SELECT  '*'
                            FROM    Services s
                            WHERE   s.ProcedureCodeId = @ProcedureCodeId
                                    AND s.ServiceId <> @ServiceId
                                    AND s.Status IN ( 71, 75 )
                                    AND ISNULL(s.RecordDeleted, 'N') = 'N'
                                    AND @WeeklyLimit > 0
                                    AND DATEPART(week, s.DateOfService) = DATEPART(week, @DateOfService)
                                    AND DATEPART(year, s.DateOfService) = DATEPART(year, @DateOfService)
                            HAVING  COUNT(*) + 1 > @WeeklyLimit )
                OR EXISTS ( SELECT  '*'
                            FROM    Services s
                            WHERE   s.ProcedureCodeId = @ProcedureCodeId
                                    AND s.ServiceId <> @ServiceId
                                    AND s.Status IN ( 71, 75 )
                                    AND ISNULL(s.RecordDeleted, 'N') = 'N'
                                    AND @MonthlyLimit > 0
                                    AND DATEPART(month, s.DateOfService) = DATEPART(month, @DateOfService)
                                    AND DATEPART(year, s.DateOfService) = DATEPART(year, @DateOfService)
                            HAVING  COUNT(*) + 1 > @MonthlyLimit )
                OR EXISTS ( SELECT  '*'
                            FROM    Services s
                            WHERE   s.ProcedureCodeId = @ProcedureCodeId
                                    AND s.ServiceId <> @ServiceId
                                    AND s.Status IN ( 71, 75 )
                                    AND ISNULL(s.RecordDeleted, 'N') = 'N'
                                    AND @YearlyLimit > 0
                                    AND DATEPART(year, s.DateOfService) = DATEPART(year, @DateOfService)
                            HAVING  COUNT(*) + 1 > @YearlyLimit )
                INSERT  INTO #RuleErrors
                        ( ErrorId )
                        SELECT  4544 -- No more than x contacts per day/week/month/yr                
        END                 
                
--                
-- Rule 4266 - No more than x duration per period                
--                 
    SELECT TOP 1
            @DailyLimit = ISNULL(CASE pc.EnteredAs
                                   WHEN 111 THEN 60
                                   WHEN 112 THEN 1440
                                   ELSE 1
                                 END * l.Daily, 0) ,
            @WeeklyLimit = ISNULL(CASE pc.EnteredAs
                                    WHEN 111 THEN 60
                                    WHEN 112 THEN 1440
                                    ELSE 1
                                  END * l.Weekly, 0) ,
            @MonthlyLimit = ISNULL(CASE pc.EnteredAs
                                     WHEN 111 THEN 60
                                     WHEN 112 THEN 1440
                                     ELSE 1
                                   END * l.Monthly, 0) ,
            @YearlyLimit = ISNULL(CASE pc.EnteredAs
                                    WHEN 111 THEN 60
                                    WHEN 112 THEN 1440
                                    ELSE 1
                                  END * l.Yearly, 0)
    FROM    #RulesToCheck r
            JOIN CoveragePlanRuleLimits l ON l.CoveragePlanRuleId = r.CoveragePlanRuleId
            JOIN ProcedureCodes pc ON pc.ProcedureCodeId = l.ProcedureCodeId
    WHERE   r.RuleTypeId = 4266
            AND l.LimitType = 4142 -- Amount of time                
            AND l.ProcedureCodeId = @ProcedureCodeId
            AND ISNULL(l.RecordDeleted, 'N') = 'N'
            AND ISNULL(pc.RecordDeleted, 'N') = 'N'               
                
    IF @@rowcount > 0
        BEGIN                
            SELECT  @Units = CASE s.UnitType
                               WHEN 111 THEN 60
                               WHEN 112 THEN 1440
                               ELSE 1
                             END * s.Unit
            FROM    Services s
            WHERE   s.ServiceId = @ServiceId                
                
            IF EXISTS ( SELECT  '*'
                        FROM    Services s
                        WHERE   s.ProcedureCodeId = @ProcedureCodeId
                                AND s.ServiceId <> @ServiceId
                                AND s.Status IN ( 71, 75 ) -- Show, Complete                
                                AND ISNULL(s.RecordDeleted, 'N') = 'N'
                                AND @DailyLimit > 0
                                AND CONVERT(CHAR(8), s.DateOfService, 112) = CONVERT(CHAR(8), @DateOfService, 112)
                        HAVING  SUM(CASE s.UnitType
                                      WHEN 111 THEN 60
                                      WHEN 112 THEN 1440
                                      ELSE 1
                                    END * s.Unit) + @Units > @DailyLimit )
                OR EXISTS ( SELECT  '*'
                            FROM    Services s
                            WHERE   s.ProcedureCodeId = @ProcedureCodeId
                                    AND s.ServiceId <> @ServiceId
                                    AND s.Status IN ( 71, 75 )
                                    AND ISNULL(s.RecordDeleted, 'N') = 'N'
                                    AND @WeeklyLimit > 0
                                    AND DATEPART(WEEK, s.DateOfService) = DATEPART(WEEK, @DateOfService)
                                    AND DATEPART(YEAR, s.DateOfService) = DATEPART(YEAR, @DateOfService)
                            HAVING  SUM(CASE s.UnitType
                                          WHEN 111 THEN 60
                                          WHEN 112 THEN 1440
                                          ELSE 1
                                        END * s.Unit) + @Units > @WeeklyLimit )
                OR EXISTS ( SELECT  '*'
                            FROM    Services s
                            WHERE   s.ProcedureCodeId = @ProcedureCodeId
                                    AND s.ServiceId <> @ServiceId
                                    AND s.Status IN ( 71, 75 )
                                    AND ISNULL(s.RecordDeleted, 'N') = 'N'
                                    AND @MonthlyLimit > 0
                                    AND DATEPART(MONTH, s.DateOfService) = DATEPART(MONTH, @DateOfService)
                                    AND DATEPART(YEAR, s.DateOfService) = DATEPART(YEAR, @DateOfService)
                            HAVING  SUM(CASE s.UnitType
                                          WHEN 111 THEN 60
                                          WHEN 112 THEN 1440
                                          ELSE 1
                                        END * s.Unit) + @Units > @MonthlyLimit )
                OR EXISTS ( SELECT  '*'
                            FROM    Services s
                            WHERE   s.ProcedureCodeId = @ProcedureCodeId
                                    AND s.ServiceId <> @ServiceId
                                    AND s.Status IN ( 71, 75 )
                                    AND ISNULL(s.RecordDeleted, 'N') = 'N'
                                    AND @YearlyLimit > 0
                                    AND DATEPART(YEAR, s.DateOfService) = DATEPART(YEAR, @DateOfService)
                            HAVING  SUM(CASE s.UnitType
                                          WHEN 111 THEN 60
                                          WHEN 112 THEN 1440
                                          ELSE 1
                                        END * s.Unit) + @Units > @YearlyLimit )
                OR ( @DailyLimit > 0
                     AND @Units > @DailyLimit
                   )
                OR ( @WeeklyLimit > 0
                     AND @Units > @WeeklyLimit
                   )
                OR ( @MonthlyLimit > 0
                     AND @Units > @MonthlyLimit
                   )
                OR ( @YearlyLimit > 0
                     AND @Units > @YearlyLimit
                   )
                BEGIN
                    INSERT  INTO #RuleErrors
                            ( ErrorId )
                            SELECT  4545 -- No more than x duration per day/week/month/yr    
                END            
        END                 
                
--                
-- 4267 - These codes are not billable to this plan                
--                
    IF EXISTS ( SELECT  *
                FROM    #RulesToCheck r
                WHERE   r.RuleTypeId = 4267
                        AND ( r.AppliesToAllProcedureCodes = 'Y'
                              OR EXISTS ( SELECT    *
                                          FROM      #RuleVariables rv
                                          WHERE     rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                                                    AND rv.ProcedureCodeId = @ProcedureCodeId )
                            ) )
        INSERT  INTO #RuleErrors
                ( ErrorId )
                SELECT  4546 -- These codes are not billable to this plan                
                
--                
-- 4269 - Must have these dx's for these codes.                 
--                
    IF EXISTS ( SELECT  *
                FROM    #RulesToCheck r
                WHERE   r.RuleTypeId = 4269 )
        BEGIN
            IF ( ( EXISTS ( SELECT  *
                            FROM    #RulesToCheck r
                                    JOIN #RuleVariables rv ON rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                            WHERE   r.RuleTypeId = 4269
                                    AND rv.AppliesToAllDSMCodes = 'Y'
                                    AND @IsICD10Service = 'N'
                                    AND ( rv.AppliesToAllProcedureCodes = 'Y'
                                          OR rv.ProcedureCodeId = @ProcedureCodeId
                                        ) )
                   AND NOT EXISTS ( SELECT  *
                                    FROM    ServiceDiagnosis sd
                                    WHERE   sd.ServiceId = @ServiceId
                                            AND @IsICD10Service = 'N'
                                            AND sd.DSMCode IS NOT NULL
                                            AND ISNULL(sd.RecordDeleted, 'N') = 'N' )
                 )
                 OR ( EXISTS ( SELECT   *
                               FROM     #RulesToCheck r
                                        JOIN #RuleVariables rv ON rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                               WHERE    r.RuleTypeId = 4269
                                        AND rv.AppliesToAllICD9Codes = 'Y'
                                        AND @IsICD10Service = 'N'
                                        AND ( rv.AppliesToAllProcedureCodes = 'Y'
                                              OR rv.ProcedureCodeId = @ProcedureCodeId
                                            ) )
                      AND NOT EXISTS ( SELECT   *
                                       FROM     ServiceDiagnosis sd
                                       WHERE    sd.ServiceId = @ServiceId
                                                AND @IsICD10Service = 'N'
                                                AND sd.ICD9Code IS NOT NULL
                                                AND ISNULL(sd.RecordDeleted, 'N') = 'N' )
                    )
                 OR ( EXISTS ( SELECT   *
                               FROM     #RulesToCheck r
                                        JOIN #RuleVariables rv ON rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                               WHERE    r.RuleTypeId = 4269
                                        AND rv.AppliesToAllICD10Codes = 'Y'
                                        AND @IsICD10Service = 'Y'
                                        AND ( rv.AppliesToAllProcedureCodes = 'Y'
                                              OR rv.ProcedureCodeId = @ProcedureCodeId
                                            ) )
                      AND NOT EXISTS ( SELECT   *
                                       FROM     ServiceDiagnosis sd
                                       WHERE    sd.ServiceId = @ServiceId
                                                AND @IsICD10Service = 'Y'
                                                AND sd.ICD10Code IS NOT NULL
                                                AND ISNULL(sd.RecordDeleted, 'N') = 'N' )
                    )
                 OR ( EXISTS ( SELECT   *
                               FROM     #RulesToCheck r
                                        JOIN #RuleVariables rv ON rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                               WHERE    r.RuleTypeId = 4269
                                        AND ISNULL(rv.AppliesToAllDSMCodes, 'N') = 'N'
                                        AND rv.DiagnosisCode IS NOT NULL
                                        AND @IsICD10Service = 'N'
                                        AND rv.DiagnosisCodeType = 'DSMIV'
                                        AND ( rv.AppliesToAllProcedureCodes = 'Y'
                                              OR rv.ProcedureCodeId = @ProcedureCodeId
                                            ) )
                      AND NOT EXISTS ( SELECT   *
                                       FROM     ServiceDiagnosis sd
                                       WHERE    sd.ServiceId = @ServiceId
                                                --AND sd.DSMCode = rv.DiagnosisCode
                                                AND ISNULL(sd.RecordDeleted, 'N') = 'N'
                                                AND ISNULL(sd.DSMCode, '') <> ''
                                                AND @IsICD10Service = 'N'
                                                AND sd.DSMCode IN ( SELECT   DISTINCT
                                                                            rv.DiagnosisCode
                                                                    FROM    #RulesToCheck r
                                                                            JOIN #RuleVariables rv ON rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                                                                    WHERE   r.RuleTypeId = 4269
                                                                            AND ISNULL(rv.AppliesToAllDSMCodes, 'N') = 'N'
                                                                            AND rv.DiagnosisCode IS NOT NULL
                                                                            AND rv.DiagnosisCodeType = 'DSMIV'
                                                                            AND ( rv.AppliesToAllProcedureCodes = 'Y'
                                                                                  OR rv.ProcedureCodeId = @ProcedureCodeId
                                                                                ) ) )
                    )
                 OR ( EXISTS ( SELECT   *
                               FROM     #RulesToCheck r
                                        JOIN #RuleVariables rv ON rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                               WHERE    r.RuleTypeId = 4269
                                        AND ISNULL(rv.AppliesToAllICD9Codes, 'N') = 'N'
                                        AND rv.DiagnosisCode IS NOT NULL
                                        AND @IsICD10Service = 'N'
                                        AND rv.DiagnosisCodeType = 'ICD9'
                                        AND ( rv.AppliesToAllProcedureCodes = 'Y'
                                              OR rv.ProcedureCodeId = @ProcedureCodeId
                                            ) )
                      AND NOT EXISTS ( SELECT   *
                                       FROM     ServiceDiagnosis sd
                                       WHERE    sd.ServiceId = @ServiceId
                                                --AND sd.ICD9Code = rv.DiagnosisCode
                                                AND ISNULL(sd.RecordDeleted, 'N') = 'N'
                                                AND ISNULL(sd.ICD9Code, '') <> ''
                                                AND @IsICD10Service = 'N'
                                                AND sd.ICD9Code IN ( SELECT   DISTINCT
                                                                            rv.DiagnosisCode
                                                                     FROM   #RulesToCheck r
                                                                            JOIN #RuleVariables rv ON rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                                                                     WHERE  r.RuleTypeId = 4269
                                                                            AND ISNULL(rv.AppliesToAllDSMCodes, 'N') = 'N'
                                                                            AND rv.DiagnosisCode IS NOT NULL
                                                                            AND rv.DiagnosisCodeType = 'ICD9'
                                                                            AND ( rv.AppliesToAllProcedureCodes = 'Y'
                                                                                  OR rv.ProcedureCodeId = @ProcedureCodeId
                                                                                ) ) )
                    )
               )
                OR ( EXISTS ( SELECT    *
                              FROM      #RulesToCheck r
                                        JOIN #RuleVariables rv ON rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                              WHERE     r.RuleTypeId = 4269
                                        AND ISNULL(rv.AppliesToAllICD10Codes, 'N') = 'N'
                                        AND rv.DiagnosisCode IS NOT NULL
                                        AND @IsICD10Service = 'Y'
                                        AND rv.DiagnosisCodeType = 'ICD10'
                                        AND ( rv.AppliesToAllProcedureCodes = 'Y'
                                              OR rv.ProcedureCodeId = @ProcedureCodeId
                                            ) )
                     AND NOT EXISTS ( SELECT    *
                                      FROM      ServiceDiagnosis sd
                                      WHERE     sd.ServiceId = @ServiceId
                                                --AND sd.ICD10Code = rv.DiagnosisCode
                                                AND ISNULL(sd.RecordDeleted, 'N') = 'N'
                                                AND ISNULL(sd.ICD10Code, '') <> ''
                                                AND @IsICD10Service = 'Y'
                                                AND sd.ICD10Code IN ( SELECT   DISTINCT
                                                                                rv.DiagnosisCode
                                                                      FROM      #RulesToCheck r
                                                                                JOIN #RuleVariables rv ON rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                                                                      WHERE     r.RuleTypeId = 4269
                                                                                AND ISNULL(rv.AppliesToAllDSMCodes, 'N') = 'N'
                                                                                AND rv.DiagnosisCode IS NOT NULL
                                                                                AND rv.DiagnosisCodeType = 'ICD10'
                                                                                AND ( rv.AppliesToAllProcedureCodes = 'Y'
                                                                                      OR rv.ProcedureCodeId = @ProcedureCodeId
                                                                                    ) ) )
                   )
                BEGIN
  
                    INSERT  INTO #RuleErrors
                            ( ErrorId )
                            SELECT  4548 -- Must have these dx's for these codes. 
                            
                    
            
                END                
        END
                
--                
-- 4270 - Only these clinicians may provide billable services for these codes                
--    
    IF EXISTS ( SELECT  *
                FROM    #RulesToCheck r
                WHERE   r.RuleTypeId = 4270 )
        AND NOT EXISTS ( SELECT *
                         FROM   #RulesToCheck r
                                JOIN #RuleVariables rv ON rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                         WHERE  r.RuleTypeId = 4270
                                AND ( ( rv.AppliesToAllProcedureCodes = 'Y'
                                        AND rv.AppliesToAllStaff = 'Y'
                                      )
                                      OR ( rv.AppliesToAllProcedureCodes = 'Y'
                                           AND rv.StaffId = @ClinicianId
                                         )
                                      OR ( rv.ProcedureCodeId = @ProcedureCodeId
                                           AND rv.AppliesToAllStaff = 'Y'
                                         )
                                      OR ( rv.ProcedureCodeId = @ProcedureCodeId
                                           AND rv.StaffId = @ClinicianId
                                         )
                                    ) )
        BEGIN
    
            INSERT  INTO #RuleErrors
                    ( ErrorId )
                    SELECT  4549 -- Only these clinicians may provide billable services for these codes                
        END
            
                
--                
-- Rule 4263 - Not billable if previous payer is Medicare and it will deny the charge because of unauthorized clinician                
--    
    IF EXISTS ( SELECT  *
                FROM    #RulesToCheck r
                WHERE   r.RuleTypeId = 4263 )
        BEGIN		               
            IF EXISTS ( SELECT  *
                        FROM    Charges c
                                JOIN ChargeErrors ce ON ce.ChargeId = c.ChargeId
                        WHERE   c.serviceid = @ServiceId
                                AND c.Priority < @ChargePriority
                                AND ISNULL(c.recorddeleted, 'N') = 'N'
                                AND ce.ErrorType IN ( 4549 ) ) -- Only these clinicians may provide billable services for these codes                   
                AND EXISTS ( SELECT *
                             FROM   ( SELECT    c.ChargeId
                                      FROM      ARLedger arl
                                                JOIN Charges c ON c.ChargeId = arl.ChargeId
                                                JOIN ClientCoveragePlans ccp ON ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
                                                JOIN CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId
                                                                         AND cp.MedicarePlan = 'Y'
                                      WHERE     c.ServiceId = @ServiceId
                                                AND c.Priority <> 0
                                                AND c.Priority < @ChargePriority
                                                AND arl.LedgerType IN ( 4201, 4204 ) -- Charge, Transfer                
                                                AND ISNULL(c.RecordDeleted, 'N') = 'N'
                                                AND ISNULL(arl.RecordDeleted, 'N') = 'N'
                                                AND NOT EXISTS ( SELECT *
                                                                 FROM   ChargeErrors ce
                                                                 WHERE  ce.ChargeId = c.ChargeId
                                                                        AND ce.ErrorType IN ( 4546 ) ) -- These codes are not billable to this plan             
                                      GROUP BY  c.ChargeId
                                      HAVING    SUM(arl.amount) = 0
                                    ) AS dc )
                BEGIN                       
                    INSERT  INTO #RuleErrors
                            ( ErrorId )
                            SELECT  4554 -- Not billable if previous payer is Medicare and it will deny the charge because of unauthorized clinician                
                END
        END          
                
--                
-- 4271 - Non Billable Diagnosis Codes                
--                

    IF EXISTS ( SELECT  *
                FROM    #RulesToCheck r
                WHERE   r.RuleTypeId = 4271 )
        BEGIN			      
 
            IF EXISTS ( SELECT  *
                        FROM    ServiceDiagnosis sd
                        WHERE   sd.ServiceId = @ServiceId
                                AND ( sd.DSMCode IS NOT NULL
                                      OR sd.ICD9Code IS NOT NULL
                                      OR sd.ICD10Code IS NOT NULL
                                    )
                                AND ISNULL(sd.RecordDeleted, 'N') = 'N' )
                AND NOT EXISTS ( SELECT *
                                 FROM   ServiceDiagnosis sd
                                 WHERE  sd.ServiceId = @ServiceId
                                        AND sd.DSMCode IS NOT NULL
                                        AND ISNULL(sd.RecordDeleted, 'N') = 'N'
                                        AND NOT EXISTS ( SELECT *
                                                         FROM   #RulesToCheck r
                                                                LEFT JOIN #RuleVariables rv ON rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                                                         WHERE  r.RuleTypeId = 4271
                                                                AND ( r.AppliesToAllDSMCodes = 'Y'
                                                                      OR EXISTS ( SELECT    *
                                                                                  FROM      #RuleVariables rv
                                                                                  WHERE     rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                                                                                            AND rv.DiagnosisCode = sd.DSMCode
                                                                                            AND rv.DiagnosisCodeType = 'DSMIV' )
                                                                    ) ) )
                AND NOT EXISTS ( SELECT *
                                 FROM   ServiceDiagnosis sd
                                 WHERE  sd.ServiceId = @ServiceId
                                        AND sd.ICD9Code IS NOT NULL
                                        AND ISNULL(sd.RecordDeleted, 'N') = 'N'
                                        AND NOT EXISTS ( SELECT *
                                                         FROM   #RulesToCheck r
                                                                LEFT JOIN #RuleVariables rv ON rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                                                         WHERE  r.RuleTypeId = 4271
                                                                AND ( r.AppliesToAllICD9Codes = 'Y'
                                                                      OR EXISTS ( SELECT    *
                                                                                  FROM      #RuleVariables rv
                                                                                  WHERE     rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                                                                                            AND rv.DiagnosisCode = sd.ICD9Code
                                                                                            AND rv.DiagnosisCodeType = 'ICD9' )
                                                                    ) ) )
                AND NOT EXISTS ( SELECT *
                                 FROM   ServiceDiagnosis sd
                                 WHERE  sd.ServiceId = @ServiceId
                                        AND sd.ICD10Code IS NOT NULL
                                        AND ISNULL(sd.RecordDeleted, 'N') = 'N'
                                        AND NOT EXISTS ( SELECT *
                                                         FROM   #RulesToCheck r
                                                                LEFT JOIN #RuleVariables rv ON rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                                                         WHERE  r.RuleTypeId = 4271
                                                                AND ( r.AppliesToAllICD10Codes = 'Y'
                                                                      OR EXISTS ( SELECT    *
                                                                                  FROM      #RuleVariables rv
                                                                                  WHERE     rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                                                                                            AND rv.DiagnosisCode = sd.ICD10Code
                                                                                            AND rv.DiagnosisCodeType = 'ICD10' )
                                                                    ) ) )
                BEGIN
                    INSERT  INTO #RuleErrors
                            ( ErrorId )
                            SELECT  4550 -- Non-billable diagnosis codes 

                END
        END											  

--                
-- 4272 - Non-billable primary diagnosis codes
--                

    IF EXISTS ( SELECT  *
                FROM    #RulesToCheck r
                WHERE   r.RuleTypeId = 4272 )
        BEGIN			 

	;
            WITH    CTE_ServiceDiagnosis
                      AS ( SELECT   sd.DSMCode ,
                                    sd.ICD10Code ,
                                    sd.ICD9Code ,
                                    ROW_NUMBER() OVER ( ORDER BY ISNULL(sd.[Order], 100), sd.ServiceDiagnosisId ) AS DiagnosisOrder
                           FROM     ServiceDiagnosis sd
                           WHERE    sd.ServiceId = @ServiceId
                                    AND ( sd.DSMCode IS NOT NULL
                                          OR sd.ICD9Code IS NOT NULL
                                          OR sd.ICD10Code IS NOT NULL
                                        )
                                    AND ISNULL(sd.RecordDeleted, 'N') = 'N'
                         )
                SELECT  @DSMCode = sd.DSMCode ,
                        @ICD10Code = sd.ICD10Code ,
                        @ICD9Code = sd.ICD9Code
                FROM    CTE_ServiceDiagnosis sd
                WHERE   sd.DiagnosisOrder = 1


            IF ( EXISTS ( SELECT    *
                          FROM      #RulesToCheck r
                                    LEFT JOIN #RuleVariables rv ON rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                          WHERE     r.RuleTypeId = 4272
                                    AND ( r.AppliesToAllDSMCodes = 'Y'
                                          OR EXISTS ( SELECT    *
                                                      FROM      #RuleVariables rv
                                                      WHERE     rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                                                                AND rv.DiagnosisCode = @DSMCode
                                                                AND rv.DiagnosisCodeType = 'DSMIV' )
                                        ) )
                 OR EXISTS ( SELECT *
                             FROM   #RulesToCheck r
                                    LEFT JOIN #RuleVariables rv ON rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                             WHERE  r.RuleTypeId = 4272
                                    AND ( r.AppliesToAllICD9Codes = 'Y'
                                          OR EXISTS ( SELECT    *
                                                      FROM      #RuleVariables rv
                                                      WHERE     rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                                                                AND rv.DiagnosisCode = @ICD9Code
                                                                AND rv.DiagnosisCodeType = 'ICD9' )
                                        ) )
                 OR EXISTS ( SELECT *
                             FROM   #RulesToCheck r
                                    LEFT JOIN #RuleVariables rv ON rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                             WHERE  r.RuleTypeId = 4272
                                    AND ( r.AppliesToAllICD10Codes = 'Y'
                                          OR EXISTS ( SELECT    *
                                                      FROM      #RuleVariables rv
                                                      WHERE     rv.CoveragePlanRuleId = r.CoveragePlanRuleId
                                                                AND rv.DiagnosisCode = @ICD10Code
                                                                AND rv.DiagnosisCodeType = 'ICD10' )
                                        ) )
               )
                BEGIN
                    INSERT  INTO #RuleErrors
                            ( ErrorId )
                            SELECT  4560 -- Non-billable primary diagnosis code

                END
        END									
       
--                
-- 4557 - Charge cannot be processed until monthly deductible is updated               
--    
    IF EXISTS ( SELECT  *
                FROM    ClientMonthlyDeductibles cmd
                WHERE   cmd.ClientCoveragePlanId = @ClientCoveragePlanId
                        AND cmd.DeductibleYear = DATEPART(yy, @DateOfService)
                        AND cmd.DeductibleMonth = DATEPART(mm, @DateOfService)
                        AND ( cmd.DeductibleMet = 'U'
                              OR ( cmd.DeductibleMet = 'Y'
                                   AND cmd.DateMet IS NULL
                                 )
                            )
                        AND ISNULL(cmd.RecordDeleted, 'N') = 'N' )
        BEGIN
            INSERT  INTO #RuleErrors
                    ( ErrorId )
                    SELECT  4557                
        END

--
-- 4558 - Monthly deductible met after service date
--
    IF EXISTS ( SELECT  *
                FROM    ClientMonthlyDeductibles cmd
                WHERE   cmd.ClientCoveragePlanId = @ClientCoveragePlanId
                        AND cmd.DeductibleYear = DATEPART(yy, @DateOfService)
                        AND cmd.DeductibleMonth = DATEPART(mm, @DateOfService)
                        AND ( ( cmd.DeductibleMet = 'Y'
                                AND cmd.DateMet > CONVERT(DATE, @DateOfService)
                              )
                              OR cmd.DeductibleMet = 'N'
                            )
                        AND ISNULL(cmd.RecordDeleted, 'N') = 'N' )
        BEGIN
            INSERT  INTO #RuleErrors
                    ( ErrorId )
                    SELECT  4558                
        END
        
--
-- 4264	- Authorization is required
--        
    IF EXISTS ( SELECT  *
                FROM    #RulesToCheck
                WHERE   RuleTypeId = 4264 )
        AND @ClientCoveragePlanId IS NOT NULL
        BEGIN
    -- Do not check if there is already authorization attached
            IF NOT EXISTS ( SELECT  *
                            FROM    ServiceAuthorizations sa
                            WHERE   sa.ServiceId = @ServiceId
                                    AND sa.ClientCoveragePlanId = @ClientCoveragePlanId
                                    AND sa.AuthorizationId IS NOT NULL
                                    AND ISNULL(sa.RecordDeleted, 'N') = 'N' )
                BEGIN               
                    EXEC dbo.ssp_PMServiceAuthorizations @CurrentUser = 'READYTOBILL', @ServiceId = @ServiceId, @ClientCoveragePlanId = @ClientCoveragePlanId             
   
                    IF EXISTS ( SELECT  *
                                FROM    ServiceAuthorizations sa
                                WHERE   sa.ServiceId = @ServiceId
                                        AND sa.ClientCoveragePlanId = @ClientCoveragePlanId
                                        AND sa.AuthorizationId IS NULL
                                        AND ISNULL(sa.RecordDeleted, 'N') = 'N' )
                        BEGIN
                            INSERT  INTO #RuleErrors
                                    ( ErrorId )
                                    SELECT  4543 -- Authorization is required               
                        END  
                END           
        END
                

	--                
	-- 4275 - Only these degrees may provide billable services for these codes            
	-- 
	DECLARE @DegreeErrorId INT = (
			SELECT TOP 1 gc.GlobalCodeId
			FROM GlobalCodes AS gc
			WHERE ISNULL(gc.RecordDeleted, 'N') = 'N'
				AND gc.Active = 'Y'
				AND gc.Category = 'ChargeErrorType'
				AND gc.CodeName = 'Clinician on service is not billable to this plan'
			)

	IF @DegreeErrorId IS NULL
		SELECT @DegreeErrorId = 4275

	IF EXISTS (
			-- does the rule apply to this procedure code?
			SELECT 1
			FROM #RuleVariables AS rv
			JOIN #RulesToCheck r ON rv.CoveragePlanRuleId = r.CoveragePlanRuleId
				AND r.RuleTypeId = 4275
			WHERE rv.ProcedureCodeId = @ProcedureCodeId
				OR rv.AppliesToAllProcedureCodes = 'Y'
			)
		AND NOT EXISTS (
			SELECT 1
			FROM #RuleVariables AS rv
			JOIN #RulesToCheck AS rtc ON rv.CoveragePlanRuleId = rtc.CoveragePlanRuleId
				AND rtc.RuleTypeId = 4275
			WHERE (
					rv.ProcedureCodeId = @ProcedureCodeId
					OR rv.AppliesToAllProcedureCodes = 'Y'
					)
				AND (
					rv.DegreeId IN (
						SELECT sld.LicenseTypeDegree
						FROM StaffLicenseDegrees AS sld
						WHERE sld.StaffId = ISNULL(@Attendingid, @ClinicianId)
							AND ISNULL(sld.RecordDeleted, 'N') = 'N'
							AND (
								DATEDIFF(DAY, @DateOfService, sld.StartDate) <= 0
								OR sld.StartDate IS NULL
								)
							AND (
								DATEDIFF(DAY, @DateOfService, sld.EndDate) >= 0
								OR sld.EndDate IS NULL
								)
							AND sld.Billing = 'Y'
						)
					OR rv.AppliesToAllDegrees = 'Y'
					)
			)
	BEGIN
		INSERT INTO #RuleErrors (ErrorId)
		SELECT @DegreeErrorId -- Only these degrees may provide billable services for these codes  
	END

--
-- Begin - Childrens Services Center-Implementation: #20
--

IF OBJECT_ID('dbo.scsp_CheckCoveragePlanRules') IS NOT NULL
BEGIN
  EXEC scsp_CheckCoveragePlanRules 
    @ServiceId  = @ServiceId ,
    @CoveragePlanId  = @CoveragePlanId ,
    @ChargeId  = @ChargeId ,
    @RuleTypeId  = @RuleTypeId 
  END
--
-- End - Childrens Services Center-Implementation: #20
--




    SELECT  e.ErrorId ,
            gc.CodeName
    FROM    #RuleErrors e
            JOIN GlobalCodes gc ON gc.GlobalCodeId = e.ErrorId               
                
    RETURN                
                
    error:                
    RAISERROR ('@ErrorNo @ErrorMessage', 16, 1)

GO


