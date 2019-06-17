
/****** Object:  StoredProcedure [dbo].[smsp_PMAppointmentSearch]    Script Date: 1/11/2018 12:23:47 PM ******/

IF EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[smsp_PMAppointmentSearch]')
          AND type IN(N'P', N'PC')
)
    DROP PROCEDURE [dbo].[smsp_PMAppointmentSearch];
GO

/****** Object:  StoredProcedure [dbo].[smsp_PMAppointmentSearch]    Script Date: 1/11/2018 12:23:47 PM ******/

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[smsp_PMAppointmentSearch] @SessionId  VARCHAR(30),
                                                  @ClientId   INT,
                                                  @StaffId    INT,
                                                  @Duration   INT,
                                                  @FromTime   TIME(0),
                                                  @ToTime     TIME(0),
                                                  @StartDate  DATETIME,
                                                  @JsonResult VARCHAR(MAX) OUTPUT  
  
/********************************************************************************        
-- Purpose: Query to return data for the Appointments Search. Mobile Version of ssp_PMAppointmentSearch        
--        
-- Author:  Pradeep        
-- Date:    11 Jan 2018        
--        
-- *****History****         
*********************************************************************************/  
  
WITH RECOMPILE
AS
    BEGIN TRY
        DELETE FROM ListPagePMAppointments
        WHERE SessionId = @SessionId;
        SET DATEFIRST 7;
        DECLARE @CurDay VARCHAR(10);
        DECLARE @NewStartDate CHAR(1)= 'N';
        DECLARE @SearchEndDate DATETIME;
        DECLARE @NewSearchStartDateDate DATETIME;
        DECLARE @ResetDate CHAR(1)= 'Y';
        DECLARE @NextStartDate DATETIME;
        DECLARE @SearchStartDate DATETIME;
        DECLARE @SearchEndTime DATETIME;
        DECLARE @ValidStaffCount INT;
        DECLARE @StaffAvailableCount INT;
        DECLARE @MaxAllowedEndDateSearch DATETIME;
        DECLARE @CurrentSearchStartDate1 DATETIME;
        DECLARE @BillingRulesCoveragePlanId INT;
        DECLARE @InstanceId INT= 1, @CoveragePlanId INT= -1, @License INT= -1, @CategoryId INT= -1, @LicenseGroupId INT= -1, @OnlyShowFree CHAR(1)= 'N', @Specialty INT= -1, @Sex VARCHAR(10)= '', @ServiceAreaId INT= -1, @ProgramId INT= -1, @IgnoreAgeRange CHAR(1)= 'Y', @OverbookingCount INT= 0, @LocationId INT= -1, @Monday CHAR(1)= 'N', @Tuesday CHAR(1)= 'N', @Wednesday CHAR(1)= 'N', @Thursday CHAR(1)= 'N', @Friday CHAR(1)= 'N', @Saturday CHAR(1)= 'N', @Sunday CHAR(1)= 'N', @AppointmentType INT= -1, @SortExpression VARCHAR(100)= 'AvailableDateTime', @PageNumber INT= 1, @PageSize INT= 1000;  
  
        -- Search End date cannot be greater than RecurringAppointmentsExpandedTo      
        SET @SearchEndDate = DATEADD(week, 2, @StartDate);
        SELECT @MaxAllowedEndDateSearch = isnull(RecurringAppointmentsExpandedTo, @SearchEndDate)
        FROM SystemConfigurations;
        IF(@SearchEndDate > @MaxAllowedEndDateSearch)
            BEGIN
                SET @SearchEndDate = @MaxAllowedEndDateSearch;
            END;
        SELECT @SearchEndDate = CONVERT(DATETIME, CONVERT(CHAR(10), @SearchEndDate, 101)+'  '+CONVERT(CHAR(8), @ToTime, 120));
        IF OBJECT_ID('tempdb..#OverlappingAppointment') IS NOT NULL
            DROP TABLE #OverlappingAppointment;
        CREATE TABLE #OverlappingAppointment
(AppointmentId     INT,
 DURATION          INT,
 StaffId           INT,
 AppointmentType   VARCHAR(100),
 StartTime         DATETIME,
 ParentAppointment VARCHAR(10),
 ParentId          INT,
 EndTime           DATETIME
);
        CREATE TABLE #NextTwoWEeks(NextTwoStartDate DATETIME);
        WHILE(@StartDate <= @SearchEndDate
              AND @ResetDate = 'Y')
            BEGIN
                SET @SearchStartDate = CONVERT(DATETIME, CONVERT(CHAR(10), @StartDate, 101)+'  '+CONVERT(CHAR(8), @FromTime, 120));
                SET @StartDate = @SearchStartDate;
                SELECT @SearchEndTime = CONVERT(DATETIME, CONVERT(CHAR(10), @StartDate, 101)+'  '+CONVERT(CHAR(8), @ToTime, 120));      
    
      --DROP TEMP Tables      

                IF OBJECT_ID('tempdb..#MinuteOfDay') IS NOT NULL
                    DROP TABLE #MinuteOfDay;
                IF OBJECT_ID('tempdb..#AvailableResultSet') IS NOT NULL
                    DROP TABLE #AvailableResultSet;
                IF OBJECT_ID('tempdb..#OverlappingResultSet') IS NOT NULL
                    DROP TABLE #OverlappingResultSet;
                IF OBJECT_ID('tempdb..#ValidStaff') IS NOT NULL
                    DROP TABLE #ValidStaff;
                IF OBJECT_ID('tempdb..#SchedulingParameters') IS NOT NULL
                    DROP TABLE #SchedulingParameters;
                IF OBJECT_ID('tempdb..#StaffAvailable') IS NOT NULL
                    DROP TABLE #StaffAvailable;
                IF OBJECT_ID('tempdb..#ServicetoRemove') IS NOT NULL
                    DROP TABLE #ServicetoRemove;
                IF OBJECT_ID('tempdb..#Staff') IS NOT NULL
                    DROP TABLE #Staff;
                IF OBJECT_ID('tempdb..#TwoWeeks') IS NOT NULL
                    DROP TABLE #TwoWeeks;
                IF OBJECT_ID('tempdb..#FreeAppointments') IS NOT NULL
                    DROP TABLE #FreeAppointments;
                IF OBJECT_ID('tempdb..#RemoveSlots') IS NOT NULL
                    DROP TABLE #RemoveSlots;
                IF OBJECT_ID('tempdb..#VacationDays') IS NOT NULL
                    DROP TABLE #VacationDays;
                WITH #MinuteOfDay
                     AS (
                     SELECT CAST('2011-01-01' AS DATETIME) Date --Start Date       
                     UNION ALL
                     SELECT DATEADD(MINUTE, 1, Date)
                     FROM #MinuteOfDay
                     WHERE DATEADD(MINUTE, 1, Date) < '2011-01-02' --End date       
                     )
                     SELECT ROW_NUMBER() OVER(ORDER BY Date) AS TimeId,
                            CAST(Date AS TIME) AS [Time]--,
                            --(DATEPART(HOUR, Date) + 1) * DATEPART(MINUTE, Date) AS #MinuteOfDay,
                            --DATEPART(MINUTE, Date) AS MinuteOfHour
                     INTO #MinuteOfDay
                     FROM #MinuteOfDay OPTION(MAXRECURSION 0);
                CREATE clustered INDEX XIE1_#MinuteOfDay ON #MinuteOfDay([Time]);
                
                DECLARE @Age INT= NULL;
                SELECT @Age = (YEAR(GETDATE()) - YEAR(DOB))
                FROM Clients
                WHERE ClientId = @ClientId
                      AND @ClientId IS NOT NULL;      
  
      -- Determine if Billing Rules Template is different from Coverage Plan   
                IF @CoveragePlanId <> -1
                    BEGIN
                        SELECT @BillingRulesCoveragePlanId = cp.UseBillingRulesTemplateId
                        FROM CoveragePlans cp
                        WHERE cp.CoveragePlanId = @CoveragePlanId
                              AND cp.BillingRulesTemplate = 'O';
                        IF @BillingRulesCoveragePlanId IS NULL
                            SET @BillingRulesCoveragePlanId = @CoveragePlanId;
                    END;
					
					 create table #FreeAppointments (AppointmentId int,
                                      StartTime datetime,
                                      EndTime datetime,
                                      LocationId int,
                                      StaffId int)        
  
      create table #VacationDays (VacationStartDAte date,
                                  VacationEndDAte date,
                                  StartTime datetime,
                                  EndTime datetime,
                                  StaffId int)  
CREATE TABLE #Staff(StaffId INT);								  
                INSERT INTO #Staff
                       SELECT DISTINCT
                              S.StaffId
                       FROM Staff S
                            LEFT JOIN StaffPrograms SP ON S.StaffId = SP.StaffId
                            LEFT JOIN Programs P ON SP.ProgramId = P.ProgramId
                            LEFT JOIN StaffLicenseDegrees SD ON S.StaffId = SD.StaffId
                                                                AND isnull(SD.RecordDeleted, 'N') = 'N'
                            LEFT JOIN LicenseAndDegreeGroupItems SG ON S.Degree = SG.LicenseTypeDegreeId
                                                                       AND isnull(SG.RecordDeleted, 'N') = 'N'  
              ----Added by MSuma for Clinician check      
                            JOIN ViewStaffPermissions vsp ON vsp.StaffId = S.StaffId  
                                                             AND vsp.PermissionTemplateType = 5704  
                                                             AND vsp.PermissionItemId = 5721  
                       WHERE(@CoveragePlanId = -1
                             OR EXISTS
(
    SELECT *
    FROM CoveragePlanRules cpr
         JOIN dbo.CoveragePlanRuleVariables cprv ON cprv.CoveragePlanRuleId = cpr.CoveragePlanRuleId
    WHERE cpr.CoveragePlanId = @BillingRulesCoveragePlanId
          AND cpr.RuleTypeId = 4270 -- Only these clinicians may provide billable services for these codes  
          AND (cprv.AppliesToAllStaff = 'Y'
               OR cprv.StaffId = S.StaffId)
          AND isnull(cpr.RecordDeleted, 'N') = 'N'
          AND isnull(cprv.RecordDeleted, 'N') = 'N'
)
    OR (NOT EXISTS
(
    SELECT *
    FROM CoveragePlanRules cpr
    WHERE cpr.CoveragePlanId = @BillingRulesCoveragePlanId
          AND cpr.RuleTypeId = 4270 -- Only these clinicians may provide billable services for these codes  
          AND isnull(cpr.RecordDeleted, 'N') = 'N'
)
        AND (EXISTS
(
    SELECT *
    FROM StaffCredentialing sc
         JOIN CoveragePlans cp ON cp.PayerId = sc.PayerId
		-- join dbo.ssf_RecodeValuesAsOfDate('RECODECREDENTIALINGSTATUSFORAPPTSEARCH', @SearchStartDate) r on r.IntegerCodeId = sc.CredentialingStatus
    WHERE sc.StaffId = S.StaffId
          AND sc.PayerOrCoveragePlan = 'P' 
AND EXISTS (select r.IntegerCodeId  
                  from dbo.Recodes as r    
                  join dbo.RecodeCategories as rc on rc.RecodeCategoryId = r.RecodeCategoryId    
                  where rc.CategoryCode = 'RECODECREDENTIALINGSTATUSFORAPPTSEARCH'   
                  AND sc.CredentialingStatus=r.IntegerCodeId  
                  and ((r.FromDate is null) or (DATEDIFF(DAY, r.FromDate, @SearchStartDate) >= 0))    
                  and ((r.ToDate is null) or (DATEDIFF(DAY, r.ToDate, @SearchStartDate) <= 0))    
                  and ISNULL(rc.RecordDeleted, 'N') <> 'Y'    
                  and ISNULL(r.RecordDeleted, 'N') <> 'Y'   
                  )  		  
                  --and sc.CredentialingStatus = 2642 -- Completed  
          AND cp.CoveragePlanId = @CoveragePlanId
		   and ((sc.EffectiveFrom is null)
                                             or (datediff(day, sc.EffectiveFrom, @SearchStartDate) >= 0))
                                        and ((sc.ExpirationDate is null)
                                             or (datediff(day, sc.ExpirationDate, @SearchStartDate) <= 0))
          AND isnull(sc.RecordDeleted, 'N') = 'N'
)
    OR EXISTS
(
    SELECT *
    FROM StaffCredentialing sc
	--join dbo.ssf_RecodeValuesAsOfDate('RECODECREDENTIALINGSTATUSFORAPPTSEARCH', @SearchStartDate) r on r.IntegerCodeId = sc.CredentialingStatus
    WHERE sc.StaffId = S.StaffId
          AND sc.PayerOrCoveragePlan = 'C' 
 AND EXISTS (select r.IntegerCodeId  
                   from dbo.Recodes as r    
                   join dbo.RecodeCategories as rc on rc.RecodeCategoryId = r.RecodeCategoryId    
                   where rc.CategoryCode = 'RECODECREDENTIALINGSTATUSFORAPPTSEARCH'   
                   AND sc.CredentialingStatus=r.IntegerCodeId  
                   and ((r.FromDate is null) or (DATEDIFF(DAY, r.FromDate, @SearchStartDate) >= 0))    
                   and ((r.ToDate is null) or (DATEDIFF(DAY, r.ToDate, @SearchStartDate) <= 0))    
                   and ISNULL(rc.RecordDeleted, 'N') <> 'Y'    
                   and ISNULL(r.RecordDeleted, 'N') <> 'Y'   
                   )   
                     		  
                    --and sc.CredentialingStatus = 2642 -- Completed  
          AND sc.CoveragePlanId = @CoveragePlanId
		  -- 23 Feb 2018 Ravi 
                                            and ((sc.EffectiveFrom is null)
                                                 or (datediff(day, sc.EffectiveFrom, @SearchStartDate) >= 0))
                                            and ((sc.ExpirationDate is null)
                                                 or (datediff(day, sc.ExpirationDate, @SearchStartDate) <= 0))
          AND isnull(sc.RecordDeleted, 'N') = 'N'
))))
    AND (@StaffId = -1
         OR S.StaffId = @StaffId)
    AND (@StaffId <> -1
         OR @License = -1
         OR SD.LicenseTypeDegree = @License)
    AND (@StaffId <> -1
         OR @LicenseGroupId = -1
         OR SG.LicenseAndDegreeGroupId = @LicenseGroupId)
    AND (@StaffId <> -1
         OR @Specialty = -1
         OR S.TaxonomyCode = @Specialty)
    AND (@StaffId <> -1
         OR ((@Sex = ''
              OR (S.Sex = 'M'
                  AND @Sex = '5555')
              OR (@Sex = '5556'
                  AND S.Sex = 'F'))))
    AND (@ServiceAreaId = -1
         OR P.ServiceAreaId = @ServiceAreaId)
    AND (@StaffId <> -1
         OR ((@ProgramId = -1
              AND @ServiceAreaId = -1)
             OR SP.ProgramId = @ProgramId))
    AND (@StaffId <> -1
         OR (@CategoryId = -1
             OR EXISTS
(
    SELECT *
    FROM StaffCategories SC
    WHERE SC.StaffId = S.StaffId
          AND SC.CategoryId = @CategoryId
          AND isnull(SC.RecordDeleted, 'N') = 'N'
)))
    AND (@IgnoreAgeRange = 'Y'
         OR @ClientId <= 0
         OR (@IgnoreAgeRange = 'N'
             AND @Age >= 0
             AND EXISTS
(
    SELECT *
    FROM StaffAgePreferences AP
    WHERE AP.StaffId = S.StaffId
          AND @Age BETWEEN isnull(AP.FromAge, 0) AND isnull(AP.ToAge, 150)
          AND isnull(AP.RecordDeleted, 'N') = 'N'
)))
    AND (@StaffId <> -1
         OR isnull(S.RecordDeleted, 'N') = 'N')
    AND (@StaffId <> -1
         OR S.Active = 'Y')
    AND (@StaffId <> -1
         OR isnull(SP.RecordDeleted, 'N') = 'N');
                create index XIE1_#Staff on #Staff(StaffId)
                IF @OnlyShowFree = 'Y'
                    BEGIN
                        INSERT INTO #FreeAppointments
(AppointmentId,
 StartTime,
 EndTime,
 StaffId,
 LocationId
)
                               SELECT DISTINCT
                                      b.AppointmentId,
                                      b.StartTime,
                                      b.EndTime,
                                      b.StaffId,
                                      b.LocationId
                               FROM #Staff a
                                    JOIN Appointments b ON(a.StaffId = b.StaffId)
                                    CROSS JOIN #MinuteOfDay AS md
                               WHERE((@OverbookingCount <= 0
                                      AND b.ShowTimeAs = 4341)
                                     OR (@OverbookingCount > 0
                                         AND (b.AppointmentType = 4761
                                              OR b.ShowTimeAs = 4341)))
                                    AND (@LocationId = -1
                                         OR b.LocationId = @LocationId)
                                    AND (@AppointmentType = -1
                                         OR b.AppointmentType = @AppointmentType)
                                    AND (@StaffID = -1
                                         OR b.StaffID = @StaffId)
                                    AND CAST(b.StartTime AS DATE) >= CAST(@SearchStartDate AS DATE)
                                    AND CAST(b.StartTime AS DATE) <= CAST(DATEADD(dd, 14, @SearchStartDate) AS DATE)
                                    AND  md.[Time] >= case when cast(b.StartTime as time) = '00:00:00'
                                                         THEN '00:00:01'
                                                         ELSE CAST(b.StartTime AS TIME)
                                                     END
                                    AND md.[Time] < CASE
                                                        WHEN(b.StartTime = b.EndTime
                                                             AND CAST(b.EndTime AS TIME) = '00:00:00')
                                                        THEN CAST('23:59:59' AS TIME)
                                                        ELSE CAST(b.EndTime AS TIME)
                                                    END
                                    AND md.[Time] >= @FromTime
                                    AND md.[Time] < @ToTime
                                    AND (@OverbookingCount > 0
                                         OR (@OverbookingCount <= 0
                                             AND b.AppointmentType <> 4761))
                                    AND isnull(b.RecordDeleted, 'N') = 'N'      
                          --Added by MSuma to avoid Timeout 02/08/2012      
                                    AND DATEDIFF(MINUTE, b.StartTime, b.EndTime) >= @Duration         
                          --Added to check Days for StartDate  
                                    AND ((@Monday = 'Y'
                                          AND datename(dw, CAST(b.StartTime AS DATE)) = 'Monday')
                                         OR (@Tuesday = 'Y'
                                             AND datename(dw, CAST(b.StartTime AS DATE)) = 'Tuesday')
                                         OR (@Wednesday = 'Y'
                                             AND datename(dw, CAST(b.StartTime AS DATE)) = 'Wednesday')
                                         OR (@Thursday = 'Y'
                                             AND datename(dw, CAST(b.StartTime AS DATE)) = 'Thursday')
                                         OR (@Friday = 'Y'
                                             AND datename(dw, CAST(b.StartTime AS DATE)) = 'Friday')
                                         OR (@Saturday = 'Y'
                                             AND datename(dw, CAST(b.StartTime AS DATE)) = 'Saturday')
                                         OR (@Sunday = 'Y'
                                             AND datename(dw, CAST(b.StartTime AS DATE)) = 'Sunday')
                                         OR (@Monday = 'N'
                                             AND @Tuesday = 'N'
                                             AND @Wednesday = 'N'
                                             AND @Thursday = 'N'
                                             AND @Friday = 'N'
                                             AND @Saturday = 'N'
                                             AND @Sunday = 'N'))
											  --and ((b.RecurringAppointment = 'Y'
                       -- and b.RecurringAppointmentId is not null)
                       --or isnull(b.RecurringAppointment, 'N') = 'N')
                        SELECT b.AppointmentId,
                               b.StartTime,
                               b.EndTime,
                               b.StaffId,
                               b.LocationId
                        INTO #RemoveSlots
                        FROM #Staff a
                             JOIN Appointments b ON(a.StaffId = b.StaffId)
                                                   AND b.AppointmentType <> 4761
                                                   AND b.ShowTimeAs = 4342
                                                   AND isnull(b.RecordDeleted, 'N') = 'N'
                                                   AND CAST(b.StartTime AS DATE) >= CAST(@SearchStartDate AS DATE)
                                                   AND CAST(b.StartTime AS DATE) <= CAST(DATEADD(dd, 14, @SearchStartDate) AS DATE)
                                                   AND (@LocationId = -1
                                                        OR b.LocationId = @LocationId)
                                                   AND (@AppointmentType = -1
                                                        OR b.AppointmentType = @AppointmentType)
                                                   AND DATEDIFF(MINUTE, b.StartTime, b.EndTime) >= @Duration
									 --and ((b.RecurringAppointment = 'Y'
                                             --  and b.RecurringAppointmentId is not null)
                                            --  or isnull(b.RecurringAppointment, 'N') = 'N')			   
                        IF(@OverbookingCount <= 0)
                            DELETE FA
                            FROM #FreeAppointments FA
                                 JOIN Appointments A ON A.StaffId = FA.StaffId
                            WHERE FA.StartTime = A.StartTime
                                  AND FA.EndTime = A.EndTime
                                  AND A.AppointmentType = 4761
                                  AND isnull(A.RecordDeleted, 'N') = 'N'
                                  AND A.LocationId = FA.LocationId
								 -- and ((A.RecurringAppointment = 'Y'
                          --and A.RecurringAppointmentId is not null)
                        -- or isnull(A.RecurringAppointment, 'N') = 'N')
                        DELETE FA
                        FROM #FreeAppointments FA
                             JOIN #RemoveSlots A ON FA.StartTime >= A.StartTime
                                                    AND FA.EndTime <= A.EndTime
                        WHERE(A.LocationId IS NULL
                              OR A.LocationId = FA.LocationId)
                             AND (@StaffId <> -1  
                       or A.StaffId = FA.StaffId);
                        WITH VacationCTE
                             AS (
                             SELECT DISTINCT
                                    CAST(A.StartTime AS DATE) AS VacationStartDAte,
                                    CAST(A.EndTime AS DATE) AS VacationEndDAte,
                                    A.StartTime as StartTime,
									A.EndTime as EndTime,
									A.StaffId as StaffId
                             FROM Appointments A
                                    LEFT JOIN #FreeAppointments FA ON A.StaffID = FA.StaffID
                             WHERE CAST(FA.StartTime AS DATE) >= CAST(A.StartTime AS DATE)
                                   AND CAST(FA.StartTime AS DATE) <= CAST(A.EndTime AS DATE)
                                   AND CAST(A.EndTime AS DATE) > CAST(A.StartTime AS DATE)
                                   AND isnull(A.RecordDeleted, 'N') = 'N'
                                   AND A.ShowTimeAs = 4342
                                   AND (@StaffID = -1
                                        OR A.StaffId = @StaffId)   
                                   --Added by Venkatesh for task 61 in Valley Go Live Support  
                                   AND (ISNULL(A.RecurringAppointment, 'N') = 'N'
                                        OR (A.RecurringAppointment = 'Y'
                                            AND A.RecurringAppointmentId IS NOT NULL)))
                             INSERT INTO #VacationDays
(VacationStartDAte,
 VacationEndDAte,
 StartTime,
 EndTime,
 StaffId
)
                                    SELECT VacationStartDAte,
                                           VacationEndDAte,
                                           StartTime,
                                           EndTime,
                                           StaffId
                                    FROM VacationCTE;
                        DELETE FA
                        FROM #FreeAppointments FA
                             JOIN #VacationDays VC ON FA.StaffId = VC.StaffId
                        WHERE CAST(FA.StartTime AS DATE) > CAST(VC.VacationStartDAte AS DATE)
                              AND CAST(FA.EndTime AS DATE) < CAST(VC.VacationEndDAte AS DATE);  
    
          --Delete startAnd End date for All day event  
                        DELETE FA
                        FROM #FreeAppointments FA
                             JOIN #VacationDays VC ON FA.StaffId = VC.StaffId
                        WHERE CAST(FA.StartTime AS DATE) >= CAST(VC.VacationStartDAte AS DATE)
                              AND CAST(FA.EndTime AS DATE) <= CAST(VC.VacationEndDAte AS DATE)
                              AND CAST(VC.StartTime AS TIME) = '00:00:00'
                              AND CAST(VC.StartTime AS TIME) = '00:00:00';
                        SELECT @CurrentSearchStartDate1 = MIN(b.StartTime)
                        FROM #FreeAppointments b;
                        IF @CurrentSearchStartDate1 IS NOT NULL
                            SET @StartDate = @CurrentSearchStartDate1;
                            ELSE
                        SET @StartDate = @SearchEndDate;
                    END;
                IF @OnlyShowFree = 'N'
                    BEGIN
                        WITH VacationCTE1
                             AS (
                             SELECT DISTINCT
                                    CAST(A.StartTime AS DATE) AS VacationStartDAte,
                                    CAST(A.EndTime AS DATE) AS VacationEndDAte,
                                    A.StartTime as StartTime,
									A.EndTime as EndTime,
									A.StaffId as StaffId
                             FROM Appointments A
                             WHERE((CAST(A.StartTime AS DATE) <= CAST(@StartDate AS DATE)
                                    AND CAST(A.EndTime AS DATE) >= CAST(@StartDate AS DATE))
                                   OR CAST(A.StartTime AS DATE) >= CAST(@StartDate AS DATE)
                                   AND CAST(A.StartTime AS DATE) <= CAST(DATEADD(DD, 14, @StartDate) AS DATE))
                                  AND CAST(A.EndTime AS DATE) > CAST(A.StartTime AS DATE)
                                  AND isnull(A.RecordDeleted, 'N') = 'N'
                                  AND A.ShowTimeAs = 4342
                                  AND (@StaffID = -1
                                       OR A.StaffId = @StaffId)  
                                   --Added by Venkatesh for task 61 in Valley Go Live Support  
                                  AND (ISNULL(A.RecurringAppointment, 'N') = 'N'
                                       OR (A.RecurringAppointment = 'Y'
                                           AND A.RecurringAppointmentId IS NOT NULL)))
                             INSERT INTO #VacationDays
(VacationStartDAte,
 VacationEndDAte,
 StartTime,
 EndTime,
 StaffId
)
                                    SELECT VacationStartDAte,
                                           VacationEndDAte,
                                           StartTime,
                                           EndTime,
                                           StaffId
                                    FROM VacationCTE1;
                        DECLARE @StaffCred INT;
                        SELECT @StaffCred = COUNT(*)
                        FROM #Staff St
                             JOIN StaffCredentialing SC ON St.StaffId = SC.StaffId;
                        IF(@StaffCred <= 0
                           AND @CoveragePlanId <> -1)
                            SET @StartDate = @SearchEndDate;
                    END;
                SET @CurDay = datename(dw, @StartDate);
                SET @ResetDate = 'N';
                IF(@Monday <> 'Y'
                   AND @Friday <> 'Y'
                   AND @Tuesday <> 'Y'
                   AND @Wednesday <> 'Y'
                   AND @Thursday <> 'Y'
                   AND @Saturday <> 'Y'
                   AND @Sunday <> 'Y')
                    BEGIN
                        SET @NewStartDate = 'N';
                    END;
                    ELSE
                    BEGIN
                        IF @CurDay = 'Monday'
                           AND @Monday <> 'Y'
                            SET @NewStartDate = 'Y';
                            ELSE
                        IF @CurDay = 'Tuesday'
                           AND @Tuesday <> 'Y'
                            SET @NewStartDate = 'Y';
                            ELSE
                        IF @CurDay = 'Wednesday'
                           AND @Wednesday <> 'Y'
                            SET @NewStartDate = 'Y';
                            ELSE
                        IF @CurDay = 'Thursday'
                           AND @Thursday <> 'Y'
                            SET @NewStartDate = 'Y';
                            ELSE
                        IF @CurDay = 'Friday'
                           AND @Friday <> 'Y'
                            SET @NewStartDate = 'Y';
                            ELSE
                        IF @CurDay = 'Saturday'
                           AND @Saturday <> 'Y'
                            SET @NewStartDate = 'Y';
                            ELSE
                        IF @CurDay = 'Sunday'
                           AND @Sunday <> 'Y'
                            SET @NewStartDate = 'Y';
                    END;
                IF @NewStartDate = 'Y'
                    SET @StartDate = [dbo].[fn_GetNextStartDateForAppointmentSearch](@StartDate, @Monday, @Tuesday, @Wednesday, @Thursday, @Friday, @Saturday, @Sunday);
                DECLARE @ApplyFilterClicked CHAR(1);
                SET @SortExpression = RTRIM(LTRIM(@SortExpression));
                IF isnull(@SortExpression, '') = ''
                    SET @SortExpression = 'StaffName';
                CREATE TABLE #AvailableResultSet
(RowNumber           INT,
 PageNumber          INT,
 StaffId             INT,
 StaffName           VARCHAR(250),
 AvailableDateTime   DATETIME,
 Duration            INT,
 DurationFormat      VARCHAR(20),
 AppointmentType     INT,
 AppointmentTypeDesc VARCHAR(250),
 LocationId          INT,
 LocationCode        VARCHAR(30),
 ServiceId           INT
);
                CREATE TABLE #OverlappingResultSet
(ListPagePMAppointmentId BIGINT,
 StaffId                 INT,
 StartTime               DATETIME,
 Duration                INT,
 DisplayMessage          VARCHAR(100)
);                                           
       
      --      
      -- If a specific page was requested, goto GetPage and retrieve this page of the previously selected data      
      --      
                IF @PageNumber > 0
                   AND EXISTS
(
    SELECT *
    FROM ListPagePMAppointments
    WHERE SessionId = @SessionId
          AND InstanceId = @InstanceId
)
                    BEGIN
                        SET @ApplyFilterClicked = 'N';
                        GOTO GetPage;
                    END;      
       
      --      
      -- New retrieve - the request came by clicking on the Apply Filter button      
      --   
                SET @ApplyFilterClicked = 'Y';
                SET @PageNumber = 1;
				    create table #ValidStaff (StaffId int)      
       
      select  @Age = (year(getdate()) - year(DOB))  
      from    Clients  
      where   ClientId = @ClientId  
              and @ClientId is not null      
          
      insert  into #ValidStaff  
      select distinct  
              S.StaffId  
      from    Staff S  
              left join StaffPrograms SP on S.StaffId = SP.StaffId  
              left join Programs P on SP.ProgramId = P.ProgramId    
                      --Added by MSuma for Clinician check      
              join ViewStaffPermissions vsp on vsp.StaffId = S.StaffId  
                                               and vsp.PermissionTemplateType = 5704  
                                               and vsp.PermissionItemId = 5721  
              left join StaffLicenseDegrees SD on S.StaffId = SD.StaffId  
                                                  and isnull(SD.RecordDeleted, 'N') = 'N'  
              left join LicenseAndDegreeGroupItems SG on S.Degree = SG.LicenseTypeDegreeId  
                                                         and isnull(SG.RecordDeleted, 'N') = 'N'  
      where   (@CoveragePlanId = -1  
               or exists ( select *  
                           from   CoveragePlanRules cpr  
                                  join dbo.CoveragePlanRuleVariables cprv on cprv.CoveragePlanRuleId = cpr.CoveragePlanRuleId  
                           where  cpr.CoveragePlanId = @BillingRulesCoveragePlanId  
                                  and cpr.RuleTypeId = 4270 -- Only these clinicians may provide billable services for these codes  
                                  and (cprv.AppliesToAllStaff = 'Y'  
                                       or cprv.StaffId = S.StaffId)  
                                  and isnull(cpr.RecordDeleted, 'N') = 'N'  
                                  and isnull(cprv.RecordDeleted, 'N') = 'N' )  
               or (not exists ( select  *                                  from    CoveragePlanRules cpr  
                                where   cpr.CoveragePlanId = @BillingRulesCoveragePlanId  
                                        and cpr.RuleTypeId = 4270 -- Only these clinicians may provide billable services for these codes  
                                        and isnull(cpr.RecordDeleted, 'N') = 'N' )  
                   and (exists ( select *  
                                 from   StaffCredentialing sc  
                                        join CoveragePlans cp on cp.PayerId = sc.PayerId  
                                 where  sc.StaffId = S.StaffId  
                                        and sc.PayerOrCoveragePlan = 'P'  
                                        -- 23 Feb 2018 Ravi start  
          AND EXISTS (select r.IntegerCodeId  
                  from dbo.Recodes as r    
                  join dbo.RecodeCategories as rc on rc.RecodeCategoryId = r.RecodeCategoryId    
                  where rc.CategoryCode = 'RECODECREDENTIALINGSTATUSFORAPPTSEARCH'   
                  AND sc.CredentialingStatus=r.IntegerCodeId  
                  and ((r.FromDate is null) or (DATEDIFF(DAY, r.FromDate, @SearchStartDate) >= 0))    
                  and ((r.ToDate is null) or (DATEDIFF(DAY, r.ToDate, @SearchStartDate) <= 0))    
                  and ISNULL(rc.RecordDeleted, 'N') <> 'Y'    
                  and ISNULL(r.RecordDeleted, 'N') <> 'Y'   
                  )   
           -- 23 Feb 2018 Ravi end  
                                          
                  --and sc.CredentialingStatus = 2642 -- Completed  
                                        and cp.CoveragePlanId = @CoveragePlanId  
                                        -- 23 Feb 2018 Ravi   
                                        and ((sc.EffectiveFrom is null) or (DATEDIFF(DAY, sc.EffectiveFrom, @SearchStartDate) >= 0))    
          and ((sc.ExpirationDate is null) or (DATEDIFF(DAY, sc.ExpirationDate, @SearchStartDate) <= 0))    
                                        and isnull(sc.RecordDeleted, 'N') = 'N' )  
                        or exists ( select  *  
                                    from    StaffCredentialing sc  
                                    where   sc.StaffId = S.StaffId  
                                            and sc.PayerOrCoveragePlan = 'C'  
                                            -- 23 Feb 2018 Ravi start  
           AND EXISTS (select r.IntegerCodeId  
                   from dbo.Recodes as r    
                   join dbo.RecodeCategories as rc on rc.RecodeCategoryId = r.RecodeCategoryId    
                   where rc.CategoryCode = 'RECODECREDENTIALINGSTATUSFORAPPTSEARCH'   
                   AND sc.CredentialingStatus=r.IntegerCodeId  
                   and ((r.FromDate is null) or (DATEDIFF(DAY, r.FromDate, @SearchStartDate) >= 0))    
                   and ((r.ToDate is null) or (DATEDIFF(DAY, r.ToDate, @SearchStartDate) <= 0))    
                   and ISNULL(rc.RecordDeleted, 'N') <> 'Y'    
                   and ISNULL(r.RecordDeleted, 'N') <> 'Y'   
                   )   
                      -- 23 Feb 2018 Ravi end  
                    --and sc.CredentialingStatus = 2642 -- Completed  
                                            and sc.CoveragePlanId = @CoveragePlanId  
                                            -- 23 Feb 2018 Ravi   
                                            and ((sc.EffectiveFrom is null) or (DATEDIFF(DAY, sc.EffectiveFrom, @SearchStartDate) >= 0))    
           and ((sc.ExpirationDate is null) or (DATEDIFF(DAY, sc.ExpirationDate, @SearchStartDate) <= 0))    
                                            and isnull(sc.RecordDeleted, 'N') = 'N' ))))  
              and (@StaffId = -1  
                   or S.StaffId = @StaffId)  
              and (@StaffId <> -1  
                   or @License = -1  
                   or SD.LicenseTypeDegree = @License)  
              and (@StaffId <> -1  
                   or @LicenseGroupId = -1  
or SG.LicenseAndDegreeGroupId = @LicenseGroupId)  
              and (@StaffId <> -1  
                   or @Specialty = -1  
                   or S.TaxonomyCode = @Specialty)  
              and (@StaffId <> -1  
                   or ((@Sex = ''  
                       or (S.Sex = 'M'  
                           and @Sex = '5555')  
                       or (@Sex = '5556'  
                           and S.Sex = 'F'))))  
              and (@ServiceAreaId = -1  
                   or P.ServiceAreaId = @ServiceAreaId)  
              and (@StaffId <> -1  
                   or ((@ProgramId = -1  
                        and @ServiceAreaId = -1)  
                       or SP.ProgramId = @ProgramId))  
              and (@StaffId <> -1  
                   or (@CategoryId = -1  
                       or exists ( select *  
                                   from   StaffCategories SC  
                                   where  SC.StaffId = S.StaffId  
                                          and SC.CategoryId = @CategoryId  
                                          and isnull(SC.RecordDeleted, 'N') = 'N' )))  
              and (@IgnoreAgeRange = 'Y'  
                   or @ClientId <= 0  
                   or (@IgnoreAgeRange = 'N'  
                       and @Age >= 0  
                       and exists ( select  *  
                                    from    StaffAgePreferences AP  
                                    where   AP.StaffId = S.StaffId  
                                            and @Age between isnull(AP.FromAge, 0)  
                                                     and     isnull(AP.ToAge, 150)  
                                            and isnull(AP.RecordDeleted, 'N') = 'N' )))  
              and (@StaffId <> -1  
                   or isnull(S.RecordDeleted, 'N') = 'N')  
              and (@StaffId <> -1  
                   or S.Active = 'Y')  
              and (@StaffId <> -1  
                   or isnull(SP.RecordDeleted, 'N') = 'N')      
  
      create index XIE1_#ValidStaff on #ValidStaff(StaffId)  
                 
  
      --Added condition to skip when there are no valid staffs for performance      
                IF(@OnlyShowFree = 'N')
                    BEGIN
                        SELECT @ValidStaffCount = COUNT(*)
                        FROM #ValidStaff;
                        IF(@ValidStaffCount <= 0)
                            SET @StartDate = @SearchEndDate;
                    END;
                CREATE TABLE #SchedulingParameters
(CurrentSearchStartDate DATETIME,
 CurrentSearchEndDate   DATETIME,
 FromTime               TIME(0),
 ToTime                 TIME(0),
 Duration               INT,
 OverbookingCount       INT,
 OnlyShowFree           CHAR(1),
 LocationId             INT,
 AppointmentType        INT,
 Monday                 CHAR(1),
 Tuesday                CHAR(1),
 Wednesday              CHAR(1),
 Thursday               CHAR(1),
 Friday                 CHAR(1),
 Saturday               CHAR(1),
 Sunday                 CHAR(1)
);
                INSERT INTO #SchedulingParameters
(CurrentSearchStartDate,
 CurrentSearchEndDate,
 FromTime,
 ToTime,
 Duration,
 OverbookingCount,
 OnlyShowFree,
 LocationId,
 AppointmentType,
 Monday,
 Tuesday,
 Wednesday,
 Thursday,
 Friday,
 Saturday,
 Sunday
)
                VALUES
(@StartDate,
 DATEADD(YEAR, 1, @StartDate),
 @FromTime,
 CASE
     WHEN @ToTime = CAST('00:00:00' AS TIME(0))
     THEN CAST('23:59:59' AS TIME(0))
     ELSE @ToTime
 END,
 @Duration,
 @OverbookingCount,
 @OnlyShowFree,
 @LocationId,
 @AppointmentType,
 CASE
     WHEN @Monday = 'N'
          AND @Tuesday = 'N'
          AND @Wednesday = 'N'
          AND @Thursday = 'N'
          AND @Friday = 'N'
          AND @Saturday = 'N'
          AND @Sunday = 'N'
     THEN NULL
     ELSE @Monday
 END,
 CASE
     WHEN @Monday = 'N'
          AND @Tuesday = 'N'
          AND @Wednesday = 'N'
          AND @Thursday = 'N'
          AND @Friday = 'N'
          AND @Saturday = 'N'
          AND @Sunday = 'N'
     THEN NULL
     ELSE @Tuesday
 END,
 CASE
     WHEN @Monday = 'N'
          AND @Tuesday = 'N'
          AND @Wednesday = 'N'
          AND @Thursday = 'N'
          AND @Friday = 'N'
          AND @Saturday = 'N'
          AND @Sunday = 'N'
     THEN NULL
     ELSE @Wednesday
 END,
 CASE
     WHEN @Monday = 'N'
          AND @Tuesday = 'N'
          AND @Wednesday = 'N'
          AND @Thursday = 'N'
          AND @Friday = 'N'
          AND @Saturday = 'N'
          AND @Sunday = 'N'
     THEN NULL
     ELSE @Thursday
 END,
 CASE
     WHEN @Monday = 'N'
          AND @Tuesday = 'N'
          AND @Wednesday = 'N'
          AND @Thursday = 'N'
          AND @Friday = 'N'
          AND @Saturday = 'N'
          AND @Sunday = 'N'
     THEN NULL
     ELSE @Friday
 END,
 CASE
     WHEN @Monday = 'N'
          AND @Tuesday = 'N'
          AND @Wednesday = 'N'
          AND @Thursday = 'N'
          AND @Friday = 'N'
          AND @Saturday = 'N'
          AND @Sunday = 'N'
     THEN NULL
     ELSE @Saturday
 END,
 CASE
     WHEN @Monday = 'N'
          AND @Tuesday = 'N'
          AND @Wednesday = 'N'
          AND @Thursday = 'N'
          AND @Friday = 'N'
          AND @Saturday = 'N'
          AND @Sunday = 'N'
     THEN NULL
     ELSE @Sunday
 END
);
                DECLARE @currentStartDate DATETIME;
                SET @currentStartDate = @StartDate;
                SET @SearchStartDate = @StartDate;
                CREATE TABLE #StaffAvailable
				(--StaffAvailableId int identity not null,
				[MinTime]       TIME(0),
				[MaxTime]       TIME(0),
				StaffId         INT,
				AppointmentId   INT,
				StartDate       DATE,
				AppointmentType INT
				);
                CREATE TABLE #TwoWeeks(ApptDate DATETIME);
                DECLARE @TwostartDate DATETIME;
                SET @TwostartDate = CAST(@SearchStartDate AS DATE);
                DECLARE @TwoEndDate DATETIME;
                SET @TwoEndDate = CAST(DATEADD(dd, 14, @SearchStartDate) AS DATE);
                WHILE(@TwostartDate <= @TwoEndDate)
                    BEGIN
                        INSERT INTO #TwoWeeks
                               SELECT @TwostartDate;
                        SET @TwostartDate = DATEADD(dd, 1, @TwostartDate);
                    END;
                INSERT INTO #StaffAvailable
                      SELECT DISTINCT
                              MIN(md.[Time]),
                            --  MAX(DATEADD(MINUTE, 1, CAST(md.[Time] AS TIME))),
							 -- (MinTime,
               -- MaxTime,
               -- StaffId,
               -- AppointmentId,
               -- StartDate,
               -- AppointmentType)
      -- select  case when sp.OnlyShowFree = 'Y'
                        -- and cast(appt.StartTime as time) >= sp.FromTime then cast(appt.StartTime as time)
                   -- else sp.FromTime
              -- end,
              -- case when sp.OnlyShowFree = 'Y'
                        -- and case when (cast(appt.EndTime as time) = '00:00:00') then cast('23:59:59' as time)
                                 -- else cast(appt.EndTime as time)
                            -- end <= sp.ToTime then cast(appt.EndTime as time)
                   -- else sp.ToTime
              -- end,
                               max(dateadd(MINUTE, 1, cast(md.[Time] as time))),
							  appt.StaffId,
                              appt.AppointmentId,
                              CAST(appt.StartTime AS DATE) AS StartDate,
                              appt.AppointmentType
                       FROM dbo.Appointments appt
                            JOIN #ValidStaff AS vs ON vs.StaffId = appt.StaffId
                           CROSS JOIN #MinuteOfDay AS md
                            CROSS JOIN #SchedulingParameters AS sp
                       WHERE   --Next two weeks changes      
                       CAST(appt.StartTime AS DATE) >= CAST(sp.CurrentSearchStartDate AS DATE)
                       AND CAST(appt.StartTime AS DATE) <= CAST(DATEADD(dd, 14, sp.CurrentSearchStartDate) AS DATE)
                       AND (sp.OnlyShowFree = 'Y'
                            AND (sp.AppointmentType <= 0
                                 OR appt.AppointmentType = sp.AppointmentType))
                       AND (sp.OnlyShowFree = 'Y'
                            AND @StaffId <> -1
                            OR (sp.LocationId <= 0
                                OR sp.LocationId = appt.LocationId))      
                      --Added by MSuma to filter based on Free slots or Start Time      
                       AND ((sp.OnlyShowFree = 'N'
                             AND md.[Time] >= sp.FromTime
                             AND md.[Time] < sp.ToTime
                             )
                            OR (sp.OnlyShowFree = 'Y'
                                -- AND md.[Time] >= CASE
                                                     -- WHEN CAST(appt.StartTime AS TIME) = '00:00:00'
												   -- and exists ( select  *
                                    -- from    #MinuteOfDay as md
                                    -- where   md.Time >= case when cast(appt.StartTime as time) = '00:00:00'
                                                     -- THEN '00:00:01'
                                                     -- ELSE CAST(appt.StartTime AS TIME)
                                                 -- END
												 and md.[Time] >= case when cast(appt.StartTime as time) = '00:00:00' then '00:00:01'  
                                                     else cast(appt.StartTime as time)  
                                                end  
                                AND md.Time < (CASE
                                                   WHEN(CAST(appt.EndTime AS TIME) = '00:00:00')
                                                   THEN CAST('23:59:59' AS TIME)
                                                   ELSE CAST(appt.EndTime AS TIME)
                                               END)
                                AND md.[Time] >= sp.FromTime
                                AND md.[Time] < sp.ToTime))
                       AND isnull(appt.RecordDeleted, 'N') = 'N'
					   -- and ((appt.RecurringAppointment = 'Y'
					    -- and appt.RecurringAppointmentId is not null)
                   -- or isnull(appt.RecurringAppointment, 'N') = 'N'))
                       group by appt.staffid,
                                appt.appointmentid,
                                appt.starttime,
                                appt.endtime,
                                appt.appointmenttype      
       
              --Added to remove busy slots for with different start and end date      
                       UNION
					    --insert  into #StaffAvailable
                       SELECT DISTINCT
                              MIN(md.[Time]),
                              MAX(DATEADD(MINUTE, 1, CAST(md.[Time] AS TIME))),
                              vs.StaffId,
                              NULL,
                              tw.ApptDate,
                              NULL
                       FROM #ValidStaff vs --LEFT JOIN Appointments Appt on Appt.StaffId = Vs.StaffId and vs.StaffId IS NULL      
                            CROSS JOIN #TwoWeeks tw
                            CROSS JOIN #MinuteOfDay AS md
                            CROSS JOIN #SchedulingParameters AS sp
                       WHERE sp.OnlyShowFree = 'N'
                             AND md.[Time] >= sp.FromTime
                             AND md.[Time] < sp.ToTime
                       GROUP BY vs.StaffId,
                                tw.ApptDate;
                UPDATE SA
                  SET
                      MaxTime = CAST(VC.StartTime AS TIME)--CASE WHEN CAST(VC.EndTime AS TIME) > SA.MinTime THEN  CAST(VC.EndTime AS TIME) ELSE SA.MinTime END    
                FROM #StaffAvailable SA
                     JOIN #VacationDays VC ON VC.StaffId = SA.StaffId
                WHERE StartDate = VC.VacationStartDate
                      AND @OnlyShowFree = 'N';  
     
        
      --Delete appointments on that start on the same day as vacation  

                DELETE FA
                FROM #StaffAvailable FA
                     JOIN #VacationDays VC ON FA.StaffId = VC.StaffId
                WHERE CAST(FA.StartDate AS DATE) = CAST(VC.VacationStartDAte AS DATE)
                      AND CAST(VC.VacationEndDAte AS DATE) > CAST(FA.StartDate AS DATE)
                      AND MinTime >= CAST(VC.StartTime AS TIME);  
            
      --Delte all days between vacation StartDAte and End Date  
                DELETE FA
                FROM #StaffAvailable FA
                     JOIN #VacationDays VC ON FA.StaffId = VC.StaffId
                WHERE CAST(FA.StartDate AS DATE) > CAST(VC.VacationStartDAte AS DATE)
                      AND CAST(FA.StartDate AS DATE) < CAST(VC.VacationEndDAte AS DATE);  
    
      --Delete startAnd End date for All day event  
      --Delete startAnd End date for All day event    
                DELETE FA
                FROM #StaffAvailable FA
                     JOIN #VacationDays VC ON FA.StaffId = VC.StaffId
                WHERE CAST(FA.StartDate AS DATE) >= CAST(VC.VacationStartDAte AS DATE)
                      AND CAST(FA.StartDate AS DATE) <= CAST(VC.VacationEndDAte AS DATE)
                      AND CAST(VC.StartTime AS TIME) = '00:00:00'
                      AND CAST(VC.StartTime AS TIME) = '00:00:00';
                UPDATE SA
                  SET
                      MinTime = CASE
                                    WHEN CAST(VC.EndTime AS TIME) > SA.MinTime
                                    THEN CAST(VC.EndTime AS TIME)
                                    ELSE SA.MinTime
                                END
                FROM #StaffAvailable SA
                     JOIN #VacationDays VC ON VC.StaffId = SA.StaffId
                WHERE StartDate = VC.VacationEndDate;
                CREATE TABLE #ServicetoRemove
(MinTime       TIME(0),
 MaxTime       TIME(0),
 StaffId       INT,
 AppointmentId INT,
 StartDate     DATE,
 StartDateTIme DATETIME
);
                INSERT INTO #ServicetoRemove
                       --SELECT MIN(md.[Time]),
                            --  MAX(DATEADD(MINUTE, 1, CAST(md.[Time] AS TIME))),
-- select  case when cast(appt.StartTime as time) = '00:00:00' then '00:01:00'
                   -- else cast(appt.StartTime as time)
              -- end,
              -- max(case when (cast(appt.EndTime as time) = '00:00:00') then cast('23:59:59' as time)
                       -- else cast(appt.EndTime as time)
                  -- end),                             
							 select  min(md.[Time]),  
                      max(dateadd(MINUTE, 1, cast(md.[Time] as time))), 
							 appt.StaffId,
                              CAST(NULL AS INT), --appt.AppointmentId,      
                              min(CAST(appt.StartTime AS DATE)),
                              appt.StartTime
                       FROM dbo.Appointments appt
                            JOIN #ValidStaff AS vs ON vs.StaffId = appt.StaffId      
                      --Added by MSuma to avoid Timeout 02/08/2012      
                      --JOIN #StaffAvailable sa on sa.AppointmentId = appt.AppointmentId      
                            CROSS JOIN #MinuteOfDay AS md
                            CROSS JOIN #SchedulingParameters AS sp
                       WHERE   --CAST(appt.StartTime AS DATE) = CAST(sp.CurrentSearchStartDate AS DATE) AND      
                       CAST(appt.StartTime AS DATE) >= CAST(sp.CurrentSearchStartDate AS DATE)
                       AND CAST(appt.StartTime AS DATE) <= CAST(DATEADD(dd, 14, sp.CurrentSearchStartDate) AS DATE)
                       --AND md.[Time] >= CASE
                                          --  WHEN CAST(appt.StartTime AS TIME) = '00:00:00'
                                          --  THEN '00:00:01'
                                           -- ELSE CAST(appt.StartTime AS TIME)
										-- AND  exists ( select *
                           --from   #MinuteOfDay md
                          -- where  
						 AND md.Time >= case when cast(appt.StartTime as time) = '00:00:00' then '00:00:01'
                                                  else cast(appt.StartTime as time)
                                        END
                       AND md.[Time] < (CASE
                                            WHEN(CAST(appt.EndTime AS TIME) = '00:00:00')
                                            THEN CAST('23:59:59' AS TIME)
                                            ELSE CAST(appt.EndTime AS TIME)
                                        END)       
        
                      --Modified by MSuma to remove busy time slots      
                       AND ((@OverbookingCount <= 0
                             AND appt.ShowTimeAs <> 4341)
                            OR (@OverbookingCount > 0
                                AND (appt.AppointmentType <> 4761
                                     AND appt.ShowTimeAs <> 4341)))
                       AND isnull(appt.RecordDeleted, 'N') = 'N'      
                      --Added by MSuma to avoid Timeout 02/08/2012      
                       AND ((@OnlyShowFree = 'Y')
                            OR @OnlyShowFree = 'N')
							-- and ((appt.RecurringAppointment = 'Y'
                    -- and appt.RecurringAppointmentId is not null)
                   -- or isnull(appt.RecurringAppointment, 'N') = 'N')
                       GROUP BY appt.StaffId,
                                sp.OverbookingCount,
                                appt.StartTime
                       HAVING COUNT(*) > sp.OverbookingCount
                       UNION ALL
                       SELECT CAST(appt.StartTime AS TIME),
                              CAST(appt.EndTime AS TIME),
                              appt.StaffId,
                              CAST(NULL AS INT), --appt.AppointmentId,    
                              min(CAST(appt.StartTime AS DATE)),
                              appt.StartTime
                       FROM dbo.Appointments appt
                            JOIN #ValidStaff AS vs ON vs.StaffId = appt.StaffId
                            CROSS JOIN #MinuteOfDay AS md
                            CROSS JOIN #SchedulingParameters AS sp
                       WHERE CAST(appt.StartTime AS DATE) <= CAST(sp.CurrentSearchStartDate AS DATE)
                             AND CAST(appt.EndTime AS DATE) >= CAST(sp.CurrentSearchStartDate AS DATE)
                             --AND md.[Time] >= CAST(appt.StartTime AS TIME)
                             --AND md.[Time] < CAST(appt.EndTime AS TIME)
							 -- and exists ( select *
                           -- from   #MinuteOfDay as md
                           -- where  
						  AND md.[Time] >= cast(appt.StartTime as time)
                                  and md.[Time] < cast(appt.EndTime as time) 
                             AND ((@OverbookingCount <= 0
                                   AND appt.ShowTimeAs <> 4341)
                                  OR (@OverbookingCount > 0
                                      AND (appt.AppointmentType <> 4761
                                           AND appt.ShowTimeAs <> 4341)))
                             AND isnull(appt.RecordDeleted, 'N') = 'N'
                             AND @OnlyShowFree = 'N'
							  -- and ((appt.RecurringAppointment = 'Y'
                    -- and appt.RecurringAppointmentId is not null)
                   -- or isnull(appt.RecurringAppointment, 'N') = 'N')
                       GROUP BY appt.StaffId,
                                sp.OverbookingCount,
                                appt.StartTime,
                                appt.EndTime
                       HAVING COUNT(*) > sp.OverbookingCount
                INSERT INTO #StaffAvailable
                       SELECT DISTINCT
                              SA.MinTime,
                              SR.MinTime,
                              sa.StaffId,
                              sa.AppointmentId,
                              sa.StartDate,
                              sa.AppointmentType
                       FROM #StaffAvailable SA
                            JOIN #ServicetoRemove SR ON SA.StaffId = SR.StaffId
                                                        AND SA.StartDate = SR.StartDate
                                                        AND SR.MinTime >= SA.MInTime
                                                        AND SR.MaxTime <= SA.MAxTime;
                INSERT INTO #StaffAvailable
                       SELECT DISTINCT
                              SR.MaxTime,
                              SA.MaxTime,
                              sa.StaffId,
                              sa.AppointmentId,
                              sa.StartDate,
                              sa.AppointmentType
                       FROM #StaffAvailable SA
                            JOIN #ServicetoRemove SR ON SA.StaffId = SR.StaffId
                                                        AND SA.StartDate = SR.StartDate
                                                        AND SR.MinTime >= SA.MInTime
                                                        AND SR.MaxTime <= SA.MAxTime;
                DELETE SA
                FROM #StaffAvailable SA
                     JOIN #ServicetoRemove SR ON SA.StaffId = SR.StaffId
                                                 AND SA.StartDate = SR.StartDate
                                                 AND SR.MinTime >= SA.MInTime
                                                 AND SR.MaxTime <= SA.MAxTime;
                DELETE SA
                FROM #StaffAvailable SA
                     JOIN #ServicetoRemove SR ON SA.StaffId = SR.StaffId
                                                 AND SA.StartDate = SR.StartDate
                                                 AND SA.MinTime >= SR.MInTime
                                                 AND SA.MaxTime <= SR.MAxTime;
                UPDATE SA
                  SET
                      MaxTime = SR.MinTime
                FROM #StaffAvailable SA
				-- join (select  StaffAvailableId,
                            -- min(SR.MinTime) as MinTime
                    -- from    #StaffAvailable SA
                     JOIN #ServicetoRemove SR ON SA.StaffId = SR.StaffId
                                                 AND SA.StartDate = SR.StartDate
                                                 AND SA.MinTime <= SR.MinTime
                                                 AND (SA.MaxTime <= SR.MaxTime
                                                      AND SA.MaxTime >= SR.MinTime)
													 -- group by SA.StaffAvailableId) SR on SR.StaffAvailableId = SA.StaffAvailableId 
                UPDATE SA
                  SET
                      MinTime = SR.MaxTime
                FROM #StaffAvailable SA
				-- join (select  SA.StaffAvailableId,
                            -- max(SR.MaxTime) as MaxTime
                    -- from    #StaffAvailable SA
                     JOIN #ServicetoRemove SR ON SA.StaffId = SR.StaffId
                                                 AND SA.StartDate = SR.StartDate
                                                 AND (SA.MinTime >= SR.MinTime
                                                      AND SA.MinTime <= SR.MaxTime)
                                                 AND SA.MaxTime >= SR.MaxTime
												 --group by SA.StaffAvailableId) SR on SR.StaffAvailableId = SA.StaffAvailableId
                DELETE SA
                FROM #StaffAvailable SA
                     JOIN Appointments A ON sa.AppointmentId = A.AppointmentId
                                            AND A.AppointmentType = 4761
                                             AND StartTime = EndTime;
                UPDATE SA
                  SET
                      MaxTime = SR.MinTime
                FROM #StaffAvailable SA
				 --join (select  SA.StaffAvailableId,
     --                       min(SR.MinTime) as MinTime
     --               from    #StaffAvailable SA
                     JOIN #ServicetoRemove SR ON SA.StaffId = SR.StaffId
                                                 AND SA.StartDate = SR.StartDate
                                                 AND SR.MinTime >= SA.MinTime
                                                 AND SR.MaxTime <= SA.MaxTime
                                                 AND @OnlyShowFree = 'N'
 -- group by SA.StaffAvailableId) SR on SR.StaffAvailableId = SA.StaffAvailableId												 
     --Delete start and to date of ALl day event    
                IF(@OnlyShowFree = 'N')
                    BEGIN
                        DELETE SA
                        FROM #StaffAvailable SA
                             JOIN #VacationDays VC ON SA.StaffId = VC.StaffId
                                                      AND VC.VacationStartDate = SA.StartDate
                                                      AND CAST(VC.StartTime AS TIME) = '00:00:00'
                                                      AND CAST(VC.EndTime AS TIME) = '00:00:00';
                        DELETE SA
                        FROM #StaffAvailable SA
                             JOIN #VacationDays VC ON SA.StaffId = VC.StaffId
                                                      AND VC.VacationEndDate = SA.StartDate
                                                      AND CAST(VC.StartTime AS TIME) = '00:00:00'
                                                      AND CAST(VC.EndTime AS TIME) = '00:00:00';
                    END;
                SELECT @StaffAvailableCount = COUNT(*)
                FROM #StaffAvailable;
                IF(@StaffAvailableCount <= 0)
                    SET @StartDate = @SearchEndDate;        
                
      --Added by MSuma      
      --Need to have a seperate condifion for ShowOnlyFree , sicne we need to retrieve AppointmentType and Id        
                IF(@OnlyShowFree = 'Y')
                    BEGIN
                        INSERT INTO #AvailableResultSet
(StaffId,
 StaffName,
 AvailableDateTime,
 Duration,
 DurationFormat,
 AppointmentType,
 AppointmentTypeDesc,
 LocationId,
 LocationCode
)
                               SELECT DISTINCT
                                      sea.StaffId,
                                      MIN(st.LastName)+', '+MIN(st.FirstName),
                                      CAST(CAST(CAST(sea.StartDate AS DATE) AS VARCHAR)+' '+SUBSTRING(CAST(sea.MinTime AS VARCHAR), 1, 8) AS DATETIME),
                                      DATEDIFF(minute, sea.MinTime, sea.MaxTime),
                                      CAST(DATEDIFF(minute, sea.MinTime, sea.MaxTime) AS VARCHAR(4))+' mins',
                                      a.AppointmentType,
                                      gcApptType.CodeName,
                                      l.LocationId,
                                      l.LocationCode
                               FROM #StaffAvailable sea
                                    JOIN dbo.Staff AS st ON st.StaffId = sea.StaffId
                                    LEFT JOIN dbo.Appointments AS a ON a.AppointmentId = sea.AppointmentId
                                    LEFT JOIN dbo.GlobalCodes AS gcApptType ON gcApptType.GlobalCodeId = a.AppointmentType
                                    LEFT JOIN dbo.Locations AS l ON l.LocationId = a.LocationId
                                    CROSS JOIN #SchedulingParameters AS sp
                               WHERE DATEDIFF(MINUTE, sea.MinTime, sea.MaxTime) >= sp.Duration  -- Only returns time slots within given duration      
                                     AND isnull(a.RecordDeleted, 'N') = 'N'
                                     AND ((@locationID <> -1
                                           AND a.LocationId = l.LocationId
                                           AND a.LocationId = @locationID)
                                          OR (@LocationId = -1))
                                     AND ((@Monday = 'Y'
                                           AND datename(dw, sea.StartDate) = 'Monday')
                                          OR (@Tuesday = 'Y'
                                              AND datename(dw, sea.StartDate) = 'Tuesday')
                                          OR (@Wednesday = 'Y'
                                              AND datename(dw, sea.StartDate) = 'Wednesday')
                                          OR (@Thursday = 'Y'
                                              AND datename(dw, sea.StartDate) = 'Thursday')
                                          OR (@Friday = 'Y'
                                              AND datename(dw, sea.StartDate) = 'Friday')
                                          OR (@Saturday = 'Y'
                                              AND datename(dw, sea.StartDate) = 'Saturday')
                                          OR (@Sunday = 'Y'
                                              AND datename(dw, sea.StartDate) = 'Sunday')
                                          OR (@Monday = 'N'
                                              AND @Tuesday = 'N'
                                              AND @Wednesday = 'N'
                                              AND @Thursday = 'N'
                                              AND @Friday = 'N'
                                              AND @Saturday = 'N'
                                              AND @Sunday = 'N'))
                               GROUP BY sea.StaffId,
                                        sea.StartDate,
                                        sea.MinTime,
                                        sea.MaxTime,
                                        a.AppointmentType,
                                        gcApptType.CodeName,
                                        l.LocationId,
                                        l.LocationCode;
                    END;       
      
      --Need to have a seperate condifion for All available Slots , sicne we do need AppointmentType and Id      
                IF @OnlyShowFree = 'N'
                    BEGIN
                        INSERT INTO #AvailableResultSet
(StaffId,
 StaffName,
 AvailableDateTime,
 Duration,
 DurationFormat,
 AppointmentType,
 AppointmentTypeDesc,
 LocationId,
 LocationCode
)
                               SELECT DISTINCT
                                      sea.StaffId,
                                      st.LastName+', '+st.FirstName,
                                      CAST(CAST(CAST(sea.StartDate AS DATE) AS VARCHAR)+' '+SUBSTRING(CAST(sea.MinTime AS VARCHAR), 1, 8) AS DATETIME),
                                      DATEDIFF(minute, sea.MinTime, sea.MaxTime),
                                      CAST(DATEDIFF(minute, sea.MinTime, sea.MaxTime) AS VARCHAR(4))+' mins',
                                      -1,
                                      '',
                                      -1,
                                      ''
                               FROM #StaffAvailable sea
                                    JOIN Staff St ON St.StaffId = sea.StaffId
                                                     AND ((@Monday = 'Y'
                                                           AND datename(dw, sea.StartDate) = 'Monday')
                                                          OR (@Tuesday = 'Y'
                                                              AND datename(dw, sea.StartDate) = 'Tuesday')
                                                          OR (@Wednesday = 'Y'
                                                              AND datename(dw, sea.StartDate) = 'Wednesday')
                                                          OR (@Thursday = 'Y'
                                                              AND datename(dw, sea.StartDate) = 'Thursday')
                                                          OR (@Friday = 'Y'
                                                              AND datename(dw, sea.StartDate) = 'Friday')
                                                          OR (@Saturday = 'Y'
                                                              AND datename(dw, sea.StartDate) = 'Saturday')
                                                          OR (@Sunday = 'Y'
                                                              AND datename(dw, sea.StartDate) = 'Sunday')
                                                          OR (@Monday = 'N'
                                                              AND @Tuesday = 'N'
                                                              AND @Wednesday = 'N'
                                                              AND @Thursday = 'N'
                                                              AND @Friday = 'N'
                                                              AND @Saturday = 'N'
                                                              AND @Sunday = 'N'))
                               WHERE DATEDIFF(MINUTE, sea.minTime, sea.MaxTime) >= @Duration;      
             --GROUP BY sea.StaffId,sea.StartDate,sea.MinTime,sea.MaxTime      
             --ORDER BY sea.StaffId,MinTime      
                    END;
                GetPage:
                IF @ApplyFilterClicked = 'N'
                   AND EXISTS
(
    SELECT *
    FROM ListPagePMAppointments
    WHERE SessionId = @SessionId
          AND InstanceId = @InstanceId
          AND SortExpression = @SortExpression
)
                    GOTO Final;
                SET @PageNumber = 1;
                IF @ApplyFilterClicked = 'N'
                    BEGIN
                        INSERT INTO #AvailableResultSet
(StaffId,
 StaffName,
 AvailableDateTime,
 Duration,
 DurationFormat,
 AppointmentType,
 AppointmentTypeDesc,
 LocationId,
 LocationCode
)
                               SELECT DISTINCT
                                      StaffId,
                                      StaffName,
                                      AvailableDateTime,
                                      Duration,
                                      DurationFormat,
                                      AppointmentType,
                                      AppointmentTypeDesc,
                                      LocationId,
                                      LocationCode
                               FROM ListPagePMAppointments
                               WHERE SessionId = @SessionId
                                     AND InstanceId = @InstanceId;
                    END;
                UPDATE d
                  SET
                      RowNumber = rn.RowNumber,
                      PageNumber = CASE
                                       WHEN @pageSize = 1
                                       THEN 1
                                       ELSE(rn.RowNumber / @PageSize) + CASE
                                                                            WHEN rn.RowNumber % @PageSize = 0
                                                                            THEN 0
                                                                            ELSE 1
                                                                        END
                                   END --09 OCT 2016 Vamsi  
                FROM #AvailableResultSet d
                     JOIN
(
    SELECT StaffId,
           isnull(LocationId, -1) AS LocationId,
           AvailableDateTime,
           ROW_NUMBER() OVER(ORDER BY CASE
                                          WHEN @SortExpression = 'StaffName'
                                          THEN StaffName
                                      END,
                                      CASE
                                          WHEN @SortExpression = 'StaffName DESC'
                                          THEN StaffName
                                      END DESC,
                                      CASE
                                          WHEN @SortExpression = 'AvailableDateTime'
                                          THEN AvailableDateTime
                                      END,
                                      CASE
                                          WHEN @SortExpression = 'AvailableDateTime DESC'
                                          THEN AvailableDateTime
                                      END DESC,
                                      CASE
                                          WHEN @SortExpression = 'Duration'
                                          THEN Duration
                                      END,
                                      CASE
                                          WHEN @SortExpression = 'Duration DESC'
                                          THEN Duration
                                      END DESC,
                                      CASE
                                          WHEN @SortExpression = 'AppointmentType'
                                          THEN AppointmentType
                                      END,
                                      CASE
                                          WHEN @SortExpression = 'AppointmentType DESC'
                                          THEN AppointmentType
                                      END DESC,
                                      CASE
                                          WHEN @SortExpression = 'LocationCode'
                                          THEN LocationCode
                                      END,
                                      CASE
                                          WHEN @SortExpression = 'LocationCode DESC'
                                          THEN LocationCode
                                      END DESC,
                                      StaffId) AS RowNumber
    FROM #AvailableResultSet
) rn ON rn.StaffId = d.StaffId
        AND rn.LocationId = isnull(d.LocationId, -1)
        AND rn.AvailableDateTime = d.AvailableDateTime;
        select * from #AvailableResultSet;
                DELETE FROM ListPagePMAppointments
                WHERE SessionId = @SessionId -- StaffId = @StaffId;
                      AND InstanceId = @InstanceId;  
                INSERT INTO ListPagePMAppointments
(SessionId,
 InstanceId,
 RowNumber,
 PageNumber,
 SortExpression,
 StaffId,
 StaffName,
 AvailableDateTime,
 Duration,
 DurationFormat,
 AppointmentType,
 AppointmentTypeDesc,
 LocationId,
 LocationCode
)
                       SELECT @SessionId,
                              @InstanceId,
                              RowNumber,
                              PageNumber,
                              @SortExpression,
                              StaffId,
                              StaffName,
                              AvailableDateTime,
                              Duration,
                              DurationFormat,
                              AppointmentType,
                              AppointmentTypeDesc,
                              LocationId,
                              LocationCode
                       FROM #AvailableResultSet;
                Final:
                DECLARE @COUNT INT;
                SELECT @COUNT = COUNT(*)
                FROM ListPagePMAppointments
                WHERE SessionId = @SessionId
                      AND InstanceId = @InstanceId;
                IF(@COUNT = 0)
                    BEGIN
                        SET @StartDate = [dbo].[fn_GetNextStartDateForAppointmentSearch](@StartDate, @Monday, @Tuesday, @Wednesday, @Thursday, @Friday, @Saturday, @Sunday);
                        SET @ResetDate = 'Y';
                    END;
            END;  
          
/*SELECT @PageNumber AS PageNumber,  
               isnull(MAX(PageNumber), 0) AS NumberOfPages,  
               isnull(MAX(RowNumber), 0) AS NumberOfRows  
        FROM ListPagePMAppointments  
        WHERE SessionId = @SessionId  
              AND InstanceId = @InstanceId;  
        DECLARE @NextWeekStartDate DATETIME;  
        SELECT @NextWeekStartDate = isnull(MAX(AvailableDateTime), @SearchEndDate)  
        FROM ListPagePMAppointments  
        WHERE SessionId = @SessionId  
              AND InstanceId = @InstanceId;  
        SET @NextStartDate = [dbo].[fn_GetNextStartDateForAppointmentSearch](@NextWeekStartDate, @Monday, @Tuesday, @Wednesday, @Thursday, @Friday, @Saturday, @Sunday);  
        SELECT @NextStartDate AS StartDate;*/

        SELECT @JsonResult = dbo.smsf_FlattenedJSON
(
(
    SELECT --LP.ListPagePMAppointmentId,  
               --LP.StaffId,  
    LP.StaffName AS ClinicianName,
    LP.AvailableDateTime,
    LP.Duration,
    LP.DurationFormat--,  
               --LP.AppointmentType,  
               --LP.AppointmentTypeDesc,  
               --LP.LocationId,  
               --LP.LocationCode  
    FROM ListPagePMAppointments LP
    WHERE SessionId = @SessionId
          AND InstanceId = @InstanceId
          AND PageNumber = @PageNumber
    ORDER BY RowNumber,
             AvailableDateTime FOR XML PATH, ROOT
)
);  
          
SELECT OA.AppointmentId AppointmentId,  
               OA.StaffId StaffId,  
               OA.StartTime StartTime,  
               OA.DURATION Duration,  
               'Appointment at '+CONVERT(VARCHAR(5), OA.StartTime, 108)+' for '+CONVERT(VARCHAR, OA.DURATION)+' minutes: Location:'+L.LocationCode+'('+Gc.CodeName+')' AS DisplayMessage,  
               ParentAppointment,  
               ParentId  
        FROM #OverlappingAppointment OA  
             JOIN GlobalCodes GC ON OA.AppointmentType = GC.GlobalCodeId  
             JOIN Appointments A ON A.AppointmentId = OA.AppointmentId  
             JOIN Locations L ON L.LocationId = A.LocationId;
  
    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000);
        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER())+'*****'+CONVERT(VARCHAR(4000), ERROR_MESSAGE())+'*****'+isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'smsp_PMAppointmentSearch')+'*****'+CONVERT(VARCHAR, ERROR_LINE())+'*****'+CONVERT(VARCHAR, ERROR_SEVERITY())+'*****'+CONVERT(VARCHAR, ERROR_STATE());
        RAISERROR(@Error, -- Message text.      
        16, -- Severity.      
        1  -- State.      
        );
    END CATCH;
GO


