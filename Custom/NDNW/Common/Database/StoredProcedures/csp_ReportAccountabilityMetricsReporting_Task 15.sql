SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[csp_ReportAccountabilityMetricsReporting]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[csp_ReportAccountabilityMetricsReporting]
GO



/************************************************************************************************
 Stored Procedure: dbo.csp_ReportAccountabilityMetricsReporting                                     
                                                                                                 
 Created By: Jay                                                                                    
 Purpose:                        
                                                                                                 
 Test Call:  
      Exec csp_ReportAccountabilityMetricsReporting @BlockName = 'Number of Individuals Served', @FromDate='1/1/16', @ToDate= '5/1/16'
      Exec csp_ReportAccountabilityMetricsReporting @BlockName = 'Percent of individuals served within 14 days of initiation', @FromDate='1/1/16', @ToDate= '5/1/16'
      Exec csp_ReportAccountabilityMetricsReporting @BlockName = 'percent of individuals reporting same or better housing', @FromDate='1/1/16', @ToDate= '5/1/16'
                                                                                               
                                                                                                 
 Change Log:         
    use document code 64225 (discharge) instead of episode discharge                                                                            
                                                                                                 
                                                                                                 
****************************************************************************************************/


CREATE PROCEDURE [dbo].csp_ReportAccountabilityMetricsReporting
    @BlockName VARCHAR(MAX)
,   @FromDate DATETIME
,   @ToDate DATETIME
,   @CoveragePlans VARCHAR(MAX) = NULL
,   @ProgramType VARCHAR(MAX) = NULL
,   @Location VARCHAR(MAX) = NULL
--,   @JusticeSystemInvolvement VARCHAR(MAX) = NULL
AS
    BEGIN
        DECLARE @JusticeSystemInvolvement VARCHAR(MAX) = NULL
        DECLARE @ErrorMessage VARCHAR(MAX) = ''
        DECLARE @ValidDocumentCodesForAssessments VARCHAR(MAX) = '10018'


        BEGIN TRY

            SELECT  @ToDate = CAST(DATEADD(dd, 1, @ToDate) AS DATE) -- Remove Time Stamp


            --DECLARE @location VARCHAR(MAX)
            IF @Location IS NULL
                SELECT  @Location = STUFF(( SELECT  ','
                                                    + CAST(LocationId AS VARCHAR)
                                            FROM    Locations L
                                            WHERE   ISNULL(L.RecordDeleted,
                                                           'N') = 'N'
                                          FOR
                                            XML PATH('')
                                          ), 1, 1, '')

            --DECLARE @CoveragePlans VARCHAR(MAX)
            IF @CoveragePlans IS NULL
                SELECT  @CoveragePlans = STUFF(( SELECT ','
                                                        + CAST(CoveragePlanId AS VARCHAR)
                                                 FROM   CoveragePlans
                                                 WHERE  ISNULL(RecordDeleted,
                                                              'N') = 'N'
                                               FOR
                                                 XML PATH('')
                                               ), 1, 1, '')
           
            --DECLARE @ProgramType VARCHAR(MAX)
            IF @ProgramType IS NULL
                SELECT  @ProgramType = STUFF(( SELECT   ','
                                                        + CAST(ProgramId AS VARCHAR)
                                               FROM     Programs
                                               WHERE    ISNULL(RecordDeleted,
                                                              'N') = 'N'
                                                        AND ProgramType = 25163
                                             FOR
                                               XML PATH('')
                                             ), 1, 1, '')

            --DECLARE @JusticeSystemInvolvement VARCHAR(MAX)
            IF @JusticeSystemInvolvement IS NULL
                SELECT  @JusticeSystemInvolvement = '-1,'
                        + STUFF(( SELECT    ','
                                            + CAST(GlobalCodeId AS VARCHAR)
                                  FROM      GlobalCodes
                                  WHERE     ISNULL(RecordDeleted, 'N') = 'N'
                                            AND Category LIKE 'XJUSTICESYSTEMINVOLV'
                                FOR
                                  XML PATH('')
                                ), 1, 1, '')
     

            --#############################################################################
            -- Number of Individuals Served
            --
            -- From Services where there is a service provided within the reporting period 
            -- searched and the client CoveragePlan – Medicaid = No or Null. 
            --
            --  EXEC csp_ReportAccountabilityMetricsReporting @BlockName = 'Number of Individuals Served', @FromDate='1/1/16', @ToDate= '5/1/16'
            --
            --############################################################################# 
            IF @BlockName = 'Number of Individuals Served'
                BEGIN
                    CREATE TABLE #NumberOfIndividualsServed
                        (
                         id INT IDENTITY
                                NOT NULL
                        ,BlockTitle VARCHAR(MAX)
                        ,BlockScore VARCHAR(MAX)
                        ,ClientId INTEGER
                        ,ClientNameAndId VARCHAR(MAX)
                        ,ServiceDate DATE
                        ,ServiceId INTEGER
                        ,Location VARCHAR(MAX)
                        ,StaffName VARCHAR(MAX)
                        ,ChargeId INTEGER
                        ,CoveragePlanName VARCHAR(MAX) -- added this, may need to remove
                        ,Charge MONEY
                        ,Units VARCHAR(MAX) -- Not sure if this will always be int.  Remember to format in code.
                        ,Duration VARCHAR(MAX)
                        )
                --#############################################################################
                -- cte
                --############################################################################# 
             ;
                    WITH    CTE_NonMedicaidServiceCharges
                              AS ( SELECT   S.ServiceId
                                   ,        C.ChargeId
                                   ,        SUM(AL.Amount) AS ChargeAmount
                                   FROM     Services S
                                            LEFT JOIN CustomClients CC ON CC.ClientId = S.ClientId
                                            JOIN Charges C ON C.ServiceId = S.ServiceId
                                            JOIN ARLedger AL ON AL.ChargeId = C.ChargeId
                                            JOIN ClientCoveragePlans CCP ON CCP.ClientCoveragePlanId = C.ClientCoveragePlanId
                                            JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
                                            JOIN ( SELECT   CAST(item AS INTEGER) AS i
                                                   FROM     dbo.fnSplit(@CoveragePlans,
                                                              ',')
                                                 ) cplimiter ON CP.CoveragePlanId = cplimiter.i
                                            JOIN ( SELECT   CAST(item AS INTEGER) AS i
                                                   FROM     dbo.fnSplit(@Location,
                                                              ',')
                                                 ) LocLimiter ON S.LocationId = LocLimiter.i
                                            JOIN ( SELECT   CAST(item AS INTEGER) AS i
                                                   FROM     dbo.fnSplit(@ProgramType,
                                                              ',')
                                                 ) ProgLimiter ON S.ProgramId = ProgLimiter.i
                                            JOIN ( SELECT   CAST(item AS INTEGER) AS i
                                                   FROM     dbo.fnSplit(@JusticeSystemInvolvement,
                                                              ',')
                                                 ) jLimiter ON ISNULL(CC.JusticeSystemInvolvement,
                                                              -1) = jLimiter.i
                                   WHERE    ISNULL(S.RecordDeleted, 'N') = 'N'
                                            AND ISNULL(C.RecordDeleted, 'N') = 'N'
                                            AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
                                            AND ISNULL(CP.RecordDeleted, 'N') = 'N'
                                            AND S.DateOfService >= @FromDate
                                            AND S.DateOfService < @ToDate
                                            AND ISNULL(CP.MedicaidPlan, 'Y') = 'Y'
                                   GROUP BY S.ServiceId
                                   ,        C.ChargeId
                                   HAVING   SUM(AL.Amount) <> 0
                                 )
                        INSERT  INTO #NumberOfIndividualsServed
                                (BlockTitle
                      --  ,BlockScore  *** Calculate Later ***
                                ,ClientId
                                ,ClientNameAndId
                                ,ServiceDate
                                ,ServiceId
                                ,Location
                                ,StaffName
                                ,ChargeId
                                ,CoveragePlanName
                                ,Charge
                                ,Units
                                ,Duration
                                )
                                SELECT  'Number of Individuals Served'
                                ,       Cl.ClientId
                                ,       Cl.LastName + ', ' + Cl.FirstName
                                        + ' (' + CAST(Cl.ClientId AS VARCHAR)
                                        + ')'
                                ,       s.DateOfService
                                ,       s.ServiceId
                                ,       L.LocationName
                                ,       st.LastName + ', ' + st.FirstName
                                ,       C.ChargeId
                                ,       CP.CoveragePlanName
                                ,       cte.ChargeAmount
                                ,       CAST(ROUND(s.Unit, 2) AS VARCHAR)
                                ,       gc.CodeName
                                FROM    Services s
                                        JOIN GlobalCodes gc ON s.UnitType = gc.GlobalCodeId
                                        JOIN Staff st ON st.StaffId = s.ClinicianId
                                        JOIN Locations L ON L.LocationId = s.LocationId
                                        JOIN Clients Cl ON Cl.ClientId = s.ClientId
                                        JOIN Charges C ON C.ServiceId = s.ServiceId
                                        JOIN ClientCoveragePlans CCP ON CCP.ClientCoveragePlanId = C.ClientCoveragePlanId
                                        JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
                                        JOIN CTE_NonMedicaidServiceCharges cte ON cte.ChargeId = C.ChargeId
                                ORDER BY Cl.ClientId
                                ,       s.ServiceId
                                ,       C.ChargeId
      
                    DECLARE @BlockScore INTEGER
                    SELECT  @BlockScore = COUNT(DISTINCT ClientId)
                    FROM    #NumberOfIndividualsServed N

                    UPDATE  #NumberOfIndividualsServed
                    SET     BlockScore = @BlockScore

            

                    SELECT  *
                    FROM    #NumberOfIndividualsServed n

                    IF OBJECT_ID('tempdb..#NumberOfIndividualsServed') IS NOT NULL
                        DROP TABLE #NumberOfIndividualsServed
         
                    RETURN
                END
            --#############################################################################
            -- Timely follow up (Percent of individuals served within 14 days of initiation)
            --
            -- System will search for clients where there is a registration date within the 
            -- reporting period, and a date of service within 14 days of that registration 
            -- date / total number of clients with a registration date within the reporting
            -- period
            --
            --#############################################################################
            -- Total number of days between services
            --
            -- From Client record –date of assessment (or initial appointment) and date of 
            -- next scheduled service – calculate number of days between the two 
            --
            --############################################################################# 
            IF @BlockName = 'Percent of individuals served within 14 days of initiation'
                BEGIN
                   
   --      exec  csp_ReportAccountabilityMetricsReporting_Percent14Days      @FromDate='1/1/16', @ToDate= '5/1/16'    
   --   Exec csp_ReportAccountabilityMetricsReporting @BlockName = 'Percent of individuals served within 14 days of initiation', @FromDate='1/1/16', @ToDate= '5/1/16'
                                      
                    CREATE TABLE #PercentOfIndividualsServedWithin14DaysOfInitiation
                        (
                         BlockTitle VARCHAR(MAX)
                        ,BlockScore VARCHAR(MAX)
                        ,ClientId INTEGER
                        ,EpisodeNumber INTEGER
                        ,ClientNameAndId VARCHAR(MAX)
                        ,RegistrationDate DATE
                        ,AssessmentDate DATE
                        ,DaysBeforeContact INTEGER
                        ,StaffName VARCHAR(MAX)
                        ,Reason VARCHAR(MAX)
                        ,NextScheduledServiceDate DATE  -- if this isn't enough change to store ID and then add pertinant info
                        ,TotalNumberOfDaysBetweenServices INTEGER
                        )

                    --#############################################################################
                    -- CTE Clients With Registration Date in Range
                    --############################################################################# 
                    ;
                    WITH    cte_Clients
                              AS ( SELECT   C.ClientId
                                   ,        CE.EpisodeNumber
                                   ,        CE.RegistrationDate
                                   FROM     Clients C
                                            JOIN ClientEpisodes CE ON CE.ClientId = C.ClientId
                                   WHERE    CE.RegistrationDate >= @FromDate
                                            AND CE.RegistrationDate < @ToDate
                                            AND ISNULL(CE.RecordDeleted, 'N') = 'N'
                                            AND ISNULL(C.RecordDeleted, 'N') = 'N'
                                 )
                        INSERT  INTO #PercentOfIndividualsServedWithin14DaysOfInitiation
                                ( BlockTitle
                                       --  ,BlockScore
                                ,ClientId
                                ,EpisodeNumber
                                ,ClientNameAndId
                                ,RegistrationDate
                              --  ,AssessmentDate need to update
                                ,DaysBeforeContact
                                ,StaffName
                                ,Reason
                                ,NextScheduledServiceDate
                                ,TotalNumberOfDaysBetweenServices
                                )
                                SELECT  'Percent of individuals served within 14 days of initiation'  -- BlockTitle - varchar(max)
                                ,       Cl.ClientId  -- ClientId - integer
                                ,       cte.EpisodeNumber
                                ,       Cl.LastName + ', ' + Cl.FirstName
                                        + ' (' + CAST(Cl.ClientId AS VARCHAR)
                                        + ')'
                                ,       cte.RegistrationDate
                                ,       NULL  -- DaysBeforeContact - integer
                                ,       ISNULL(s.LastName,
                                               'No Primary Clinician Assigned')
                                        + ISNULL(', ' + s.FirstName, '') -- StaffName - varchar(max)
                                ,       ''  -- Reason - varchar(max)
                                ,       NULL  -- NextScheduledServiceDate - date
                                ,       NULL  -- TotalNumberOfDaysBetweenServices - integer
                                FROM    cte_Clients cte
                                        JOIN Clients Cl ON Cl.ClientId = cte.ClientId
                                        LEFT JOIN Staff s ON ( Cl.PrimaryClinicianId = s.StaffId
                                                              AND ISNULL(s.RecordDeleted,
                                                              'N') = 'N'
                                                             )
                    --#############################################################################
                    -- find most recent assessment for each line with respect to Client, RegistrationDate
                    --############################################################################# 
                    
                    UPDATE  P
                    SET     AssessmentDate = ( SELECT   D.EffectiveDate
                                               FROM     Documents D
                                               WHERE    D.ClientId = P.ClientId
                                                        AND D.DocumentCodeId IN (
                                                        SELECT
                                                              *
                                                        FROM  dbo.fnSplit(@ValidDocumentCodesForAssessments,
                                                              ',') )
                                                        AND D.EffectiveDate >= P.RegistrationDate
                                                        AND ISNULL(D.RecordDeleted,
                                                              'N') = 'N'
                                                        AND D.Status = 22
                                                        AND NOT EXISTS ( SELECT
                                                              d2.DocumentId
                                                              FROM
                                                              Documents AS d2
                                                              WHERE
                                                              d2.ClientId = D.ClientId
                                                              AND d2.DocumentCodeId IN (
                                                              SELECT
                                                              *
                                                              FROM
                                                              dbo.fnSplit(@ValidDocumentCodesForAssessments,
                                                              ',') )
                                                              AND d2.Status = 22
                                                              AND ( d2.EffectiveDate > D.EffectiveDate
                                                              OR ( d2.EffectiveDate = D.EffectiveDate
                                                              AND d2.DocumentId > D.DocumentId
                                                              )
                                                              )
                                                              AND ISNULL(d2.RecordDeleted,
                                                              'N') = 'N' )
                                             )
                    FROM    #PercentOfIndividualsServedWithin14DaysOfInitiation P
                   
                    UPDATE  P
                    SET     P.NextScheduledServiceDate = ( SELECT
                                                              s.DateOfService
                                                           FROM
                                                              Services s
                                                              JOIN ProcedureCodes PC ON PC.ProcedureCodeId = s.ProcedureCodeId
                                                           WHERE
                                                              s.ClientId = P.ClientId
                                                              AND ISNULL(s.RecordDeleted,
                                                              'N') = 'N'
                                                              AND s.DateOfService > ISNULL(P.AssessmentDate,
                                                              P.RegistrationDate)
                                                              AND s.Status IN (
                                                              70, 75 ) -- scheduled
                                                              AND NOT EXISTS ( SELECT
                                                              s2.ServiceId
                                                              FROM
                                                              Services AS s2
                                                              WHERE
                                                              s2.ClientId = s.ClientId
                                                              AND s2.Status IN (
                                                              70, 75 )
                                                              AND s2.DateOfService > ISNULL(P.AssessmentDate,
                                                              P.RegistrationDate)
                                                              AND ( s2.DateOfService > s.DateOfService
                                                              OR ( s2.DateOfService = s.DateOfService
                                                              AND s2.ServiceId > s.ServiceId
                                                              )
                                                              )
                                                              AND ISNULL(s2.RecordDeleted,
                                                              'N') = 'N' )
                                                         )
                    FROM    #PercentOfIndividualsServedWithin14DaysOfInitiation P


                    UPDATE  P
                    SET     P.DaysBeforeContact = DATEDIFF(dd,
                                                           RegistrationDate,
                                                           AssessmentDate)
                    ,       P.TotalNumberOfDaysBetweenServices = DATEDIFF(dd,
                                                              AssessmentDate,
                                                              NextScheduledServiceDate)
                    FROM    #PercentOfIndividualsServedWithin14DaysOfInitiation P

   --   Exec csp_ReportAccountabilityMetricsReporting_Percent14days '7/1/15','8/1/15'
                            
                    UPDATE  #PercentOfIndividualsServedWithin14DaysOfInitiation
                    SET     BlockScore = CAST(CAST(( 1.0
                                                     * ( SELECT
                                                              COUNT(*)
                                                         FROM #PercentOfIndividualsServedWithin14DaysOfInitiation POISWDOI
                                                         WHERE
                                                              ISNULL(DaysBeforeContact,
                                                              99) <= 14
                                                       )
                                                     / ( SELECT
                                                              COUNT(*)
                                                         FROM #PercentOfIndividualsServedWithin14DaysOfInitiation POISWDOI2
                                                       ) * 100 ) AS DECIMAL(10,
                                                              2)) AS VARCHAR)
                            + '%'
                    SELECT  *
                    FROM    #PercentOfIndividualsServedWithin14DaysOfInitiation

                    
                    IF OBJECT_ID('tempdb..#PercentOfIndividualsServedWithin14DaysOfInitiation') IS NOT NULL
                        DROP TABLE #PercentOfIndividualsServedWithin14DaysOfInitiation
         
         
                    RETURN
                END

            --#############################################################################
            -- Treatment Service Engagement (Percent of individuals who received two 
            -- or more services within 30 days of admission
            --
            -- System will search for clients where there is an admission document with 
            -- effective date and two or more services within 30 days of that 
            -- admission date/ number of individuals with an admission document for the 
            -- reporting period
            --
            --############################################################################# 
            IF @BlockName = 'Percent of individuals who received two or more services within 30 days of admission'
                BEGIN
   --   Exec csp_ReportAccountabilityMetricsReporting_PercentServices30Days   @FromDate='6/1/15', @ToDate= '12/1/16'
   
                    CREATE TABLE #PercentOfIndividualsReceiving2ServicesWithin30Days
                        (
                         BlockTitle VARCHAR(MAX)
                        ,BlockScore VARCHAR(MAX)
                        ,ClientId INTEGER
                        ,FirstServiceId INTEGER
                        ,SecondServiceId INTEGER
                        ,ClientNameAndId VARCHAR(MAX)
                        ,AdmissionDate DATE
                        ,DischargeDate DATE
                        ,FirstServiceDate DATETIME
                        ,SecondServiceDate DATETIME
                        ,DaysBetweenContact INTEGER
                        ,StaffName VARCHAR(MAX)
                        )
            --#############################################################################
            -- Grab clients with registration in date range
            --############################################################################# 
             ;
                    WITH    cte_Clients
                              AS ( SELECT   C.ClientId
                                   ,        CE.EpisodeNumber
                                   ,        CE.RegistrationDate
                               --    ,        CE.DischargeDate
                                   FROM     Clients C
                                            JOIN ClientEpisodes CE ON CE.ClientId = C.ClientId
                                   WHERE    CE.RegistrationDate >= @FromDate
                                            AND CE.RegistrationDate < @ToDate
                                            AND ISNULL(CE.RecordDeleted, 'N') = 'N'
                                            AND ISNULL(C.RecordDeleted, 'N') = 'N'
                                 )
                        INSERT  INTO #PercentOfIndividualsReceiving2ServicesWithin30Days
                                (BlockTitle
                                ,ClientId
                                ,ClientNameAndId
                                ,AdmissionDate
                               -- ,DischargeDate  -- Using Episode Dicharge.  Use Document instead?
                                ,StaffName
                                )
                                SELECT  'Percent of individuals who received two or more services within 30 days of admission'  -- BlockTitle - varchar(max)
                                ,       Cl.ClientId  -- ClientId - integer
                                ,       Cl.LastName + ', ' + Cl.FirstName
                                        + ' (' + CAST(Cl.ClientId AS VARCHAR)
                                        + ')'
                                ,       cte.RegistrationDate
                             --   ,       cte.DischargeDate
                                ,       ISNULL(s.LastName,
                                               'No Primary Clinician Assigned')
                                        + ISNULL(', ' + s.FirstName, '') -- StaffName - varchar(max)
                                FROM    cte_Clients cte
                                        JOIN Clients Cl ON Cl.ClientId = cte.ClientId
                                        LEFT JOIN Staff s ON ( Cl.PrimaryClinicianId = s.StaffId
                                                              AND ISNULL(s.RecordDeleted,
                                                              'N') = 'N'
                                                             )
                    UPDATE  p
                    SET     p.DischargeDate = d.EffectiveDate
                    FROM    #PercentOfIndividualsReceiving2ServicesWithin30Days p
                            JOIN Documents d ON d.ClientId = p.ClientId
                    WHERE   d.Status = 22
                            AND ISNULL(d.RecordDeleted, 'N') = 'N'
                            AND d.DocumentCodeId = 46225
                            AND NOT EXISTS ( SELECT d2.DocumentId
                                             FROM   Documents AS d2
                                             WHERE  d2.ClientId = d.ClientId
                                                    AND d2.DocumentCodeId = d.DocumentCodeId
                                                    AND d2.Status = 22
                                                    AND ( d2.EffectiveDate > d.EffectiveDate
                                                          OR ( d2.EffectiveDate = d.EffectiveDate
                                                              AND d2.DocumentId > d.DocumentId
                                                             )
                                                        )
                                                    AND ISNULL(d2.RecordDeleted,
                                                              'N') = 'N' )
                    --#############################################################################
                    -- find first service after admission
                    --############################################################################# 
         
                    UPDATE  P
                    SET     P.FirstServiceDate = S.DateOfService
                    ,       P.FirstServiceId = S.ServiceId
                    FROM    #PercentOfIndividualsReceiving2ServicesWithin30Days P
                            JOIN Services S ON S.ClientId = P.ClientId
                    WHERE   ISNULL(S.RecordDeleted, 'N') = 'N'
                            AND S.Status = 75
                            AND S.DateOfService >= P.AdmissionDate
                            AND S.DateOfService <= ISNULL(P.DischargeDate,
                                                          '9/9/9999')
                            AND NOT EXISTS ( SELECT s2.ServiceId
                                             FROM   Services AS s2
                                             WHERE  s2.ClientId = S.ClientId
                                                    AND s2.DateOfService >= P.AdmissionDate
                                                    AND s2.DateOfService <= ISNULL(P.DischargeDate,
                                                              '9/9/9999')
                                                    AND s2.Status = 75
                                                    AND ( s2.DateOfService < S.DateOfService
                                                          OR ( s2.DateOfService = S.DateOfService
                                                              AND s2.ServiceId < S.ServiceId
                                                             )
                                                        )
                                                    AND ISNULL(s2.RecordDeleted,
                                                              'N') = 'N' )
   --   Exec csp_ReportAccountabilityMetricsReporting_PercentServices30Days @FromDate='1/1/16', @ToDate= '1/17/16'

                    --#############################################################################
                    -- find second service
                    --############################################################################# 
                    SELECT  P.BlockTitle
                    ,       P.BlockScore
                    ,       P.ClientId
                    ,       P.FirstServiceId
                    ,       S.ServiceId AS SecondServiceId
                    ,       P.ClientNameAndId
                    ,       P.AdmissionDate
                    ,       P.DischargeDate
                    ,       P.FirstServiceDate
                    ,       S.DateOfService AS SecondServiceDate
                    ,       P.DaysBetweenContact
                    ,       P.StaffName
                    --SET     P.SecondServiceDate = S.DateOfService
                    --,       P.SecondServiceId = S.ServiceId
                    INTO    #PercentOfIndividualsReceiving2ServicesWithin30DaysOut -- Don't even ask why I had to do this...  Trying to update in place was taking 15x times as long
                    FROM    #PercentOfIndividualsReceiving2ServicesWithin30Days P   -- https://blogs.msdn.microsoft.com/psssql/2012/09/21/t-sql-update-takes-much-longer-than-the-matching-select-statement/
                            JOIN Services S ON S.ClientId = P.ClientId
                    WHERE   ISNULL(S.RecordDeleted, 'N') = 'N'
                            AND S.Status = 75
                            AND S.DateOfService >= P.FirstServiceDate
                            AND S.ServiceId <> P.FirstServiceId
                            AND S.DateOfService <= ISNULL(P.DischargeDate,
                                                          '9/9/9999')
                            AND NOT EXISTS ( SELECT s2.ServiceId
                                             FROM   Services AS s2
                                             WHERE  s2.ClientId = S.ClientId
                                                    AND s2.DateOfService >= P.FirstServiceDate
                                                    AND s2.ServiceId <> P.FirstServiceId
                                                    AND s2.DateOfService <= ISNULL(P.DischargeDate,
                                                              '9/9/9999')
                                                    AND s2.Status = 75
                                                    AND ( s2.DateOfService < S.DateOfService
                                                          OR ( s2.DateOfService = S.DateOfService
                                                             AND s2.ServiceId < S.ServiceId
                                                             )
                                                        )
                                                    AND ISNULL(s2.RecordDeleted,
                                                              'N') = 'N' )
                    UPDATE  #PercentOfIndividualsReceiving2ServicesWithin30DaysOut
                    SET     DaysBetweenContact = DATEDIFF(dd, FirstServiceDate,
                                                          SecondServiceDate)

                    UPDATE  #PercentOfIndividualsReceiving2ServicesWithin30DaysOut
                    SET     BlockScore = CAST(CAST(( 1.0
                                                     * ( SELECT
                                                              COUNT(*)
                                                         FROM #PercentOfIndividualsReceiving2ServicesWithin30DaysOut
                                                         WHERE
                                                              ISNULL(DaysBetweenContact,
                                                              0) >= 2
                                                       )
                                                     / ( SELECT
                                                              COUNT(*)
                                                         FROM #PercentOfIndividualsReceiving2ServicesWithin30DaysOut
                                                       ) * 100 ) AS DECIMAL(10,
                                                              2)) AS VARCHAR)
                            + '%'
                            
                    SELECT  *
                    FROM    #PercentOfIndividualsReceiving2ServicesWithin30DaysOut
                    IF OBJECT_ID('tempdb..#PercentOfIndividualsReceiving2ServicesWithin30Days') IS NOT NULL
                        DROP TABLE #PercentOfIndividualsReceiving2ServicesWithin30Days
                    IF OBJECT_ID('tempdb..#PercentOfIndividualsReceiving2ServicesWithin30DaysOut') IS NOT NULL
                        DROP TABLE #PercentOfIndividualsReceiving2ServicesWithin30DaysOut
        
                END
            --#############################################################################
            -- Percent of individuals who received follow-up visit within 7 days after hospitalization
            --
            -- System will search for clients with a hospital discharge date 
            -- (Client Information – Hospitalizations – Discharge date) and have a service 
            -- within 7 days of discharge date/total number of clients who had a hospital
            -- discharge during the reporting period
            --
            --  ClientHospitalizations contains the hospitalization info
            --############################################################################# 
            IF @BlockName = 'Percent of individuals who received follow-up visit within 7 days after hospitalization'
                BEGIN
   --   Exec csp_ReportAccountabilityMetricsReporting_HospitalDischarge @FromDate='1/1/15', @ToDate= '9/1/16'
   
         
                    CREATE TABLE #PercentOfIndividualsWithFollowUpWithin7Days
                        (
                         BlockTitle VARCHAR(MAX)
                         ,BlockScore VARCHAR(MAX)
                        ,BlockScore7 VARCHAR(MAX)
                        ,BlockScore30 VARCHAR(MAX)
                        ,BlockScore180 VARCHAR(MAX)
                        ,ClientId INTEGER
                        ,ClientNameAndId VARCHAR(MAX)
                        ,DischargeDate DATE
                        ,FollowUpVisitDate DATE
                        ,ReAdmissionDate DATE
                        ,DaysBetweenDischargeAndFollowUp INTEGER
                        ,DaysBetweenDischargeAndReadmission INTEGER
                        ,StaffName VARCHAR(MAX)
                        ,Reason VARCHAR(MAX)
                        );
                    WITH    cte_Discharges
                              AS ( SELECT   d.ClientId
                                   ,        d.EffectiveDate AS DischargeDate
                                   FROM     Documents d
                                   WHERE    d.Status = 22
                                            AND ISNULL(d.RecordDeleted, 'N') = 'N'
                                            AND d.DocumentCodeId = 46225
                                            AND CAST(d.EffectiveDate AS DATE) BETWEEN @FromDate
                                                              AND
                                                              @ToDate
                                            AND NOT EXISTS ( SELECT
                                                              d2.DocumentId
                                                             FROM
                                                              Documents AS d2
                                                             WHERE
                                                              d2.ClientId = d.ClientId
                                                              AND CAST(d2.EffectiveDate AS DATE) BETWEEN @FromDate
                                                              AND
                                                              @ToDate
                                                              AND d2.DocumentCodeId = d.DocumentCodeId
                                                              AND d2.Status = 22
                                                              AND ( d2.EffectiveDate > d.EffectiveDate
                                                              OR ( d2.EffectiveDate = d.EffectiveDate
                                                              AND d2.DocumentId > d.DocumentId
                                                              )
                                                              )
                                                              AND ISNULL(d2.RecordDeleted,
                                                              'N') = 'N' )
                                 )
                        INSERT  INTO #PercentOfIndividualsWithFollowUpWithin7Days
                                (BlockTitle
                                ,ClientId
                                ,ClientNameAndId
                                ,DischargeDate
                               -- ,DischargeDate  -- Using Episode Dicharge.  Use Document instead?
                                ,StaffName
                                )
                                SELECT  'Percent of individuals who received two or more services within 30 days of admission'  -- BlockTitle - varchar(max)
                                ,       Cl.ClientId  -- ClientId - integer
                                ,       Cl.LastName + ', ' + Cl.FirstName
                                        + ' (' + CAST(Cl.ClientId AS VARCHAR)
                                        + ')'
                                ,       cte.DischargeDate
                                ,       ISNULL(s.LastName,
                                               'No Primary Clinician Assigned')
                                        + ISNULL(', ' + s.FirstName, '') -- StaffName - varchar(max)
                                FROM    cte_Discharges cte
                                        JOIN Clients Cl ON Cl.ClientId = cte.ClientId
                                        LEFT JOIN Staff s ON ( Cl.PrimaryClinicianId = s.StaffId
                                                              AND ISNULL(s.RecordDeleted,
                                                              'N') = 'N'
                                                             )
                    --#############################################################################
                    -- Get Next Admission Date
                    --############################################################################# 
                    UPDATE  P
                    SET     P.ReAdmissionDate = CE.RegistrationDate
                    FROM    #PercentOfIndividualsWithFollowUpWithin7Days P
                            JOIN ClientEpisodes CE ON CE.ClientId = P.ClientId
                    WHERE   ISNULL(CE.RecordDeleted, 'N') = 'N'
                            AND CE.RegistrationDate > P.DischargeDate
                            AND NOT EXISTS ( SELECT 1
                                             FROM   ClientEpisodes CE2
                                             WHERE  CE.ClientId = CE2.ClientId
                                                    AND ( CE2.RegistrationDate < CE.RegistrationDate
                                                          OR ( CE2.RegistrationDate = CE.RegistrationDate
                                                              AND CE2.ClientEpisodeId < CE.ClientEpisodeId
                                                             )
                                                        )
                                                    AND CE2.RegistrationDate > P.DischargeDate
                                                    AND ISNULL(CE2.RecordDeleted,
                                                              'N') = 'N' )
                    --#############################################################################
                    -- Get Followup Visit Date
                    --############################################################################# 
                    UPDATE  P
                    SET     P.FollowUpVisitDate = S.DateOfService
                    FROM    #PercentOfIndividualsWithFollowUpWithin7Days P
                            JOIN Services S ON S.ClientId = P.ClientId
                    WHERE   ISNULL(S.RecordDeleted, 'N') = 'N'
                            AND S.DateOfService >= DATEADD(dd,1, P.DischargeDate)
                            AND NOT EXISTS ( SELECT 1
                                             FROM   Services s2
                                             WHERE  s2.ClientId = S.ClientId
                                                    AND s2.DateOfService > daTEADD(dd,1, P.DischargeDate)
                                                    AND ( s2.DateOfService < S.DateOfService
                                                          OR ( s2.DateOfService = S.DateOfService
                                                              AND s2.ServiceId < S.ServiceId
                                                             )
                                                        ) )
   
                    --#############################################################################
                    -- Calc Days / Contact numbers and scores
                    --############################################################################# 

                    UPDATE  #PercentOfIndividualsWithFollowUpWithin7Days
                    SET     DaysBetweenDischargeAndFollowUp = DATEDIFF(dd,
                                                              DischargeDate,
                                                              FollowUpVisitDate)
                    ,       DaysBetweenDischargeAndReadmission = DATEDIFF(dd,
                                                              DischargeDate,
                                                              ReAdmissionDate)

                    UPDATE #PercentOfIndividualsWithFollowUpWithin7Days
                     SET     BlockScore7 = CAST(CAST(( 1.0
                                                     * ( SELECT
                                                              COUNT(*)
                                                         FROM #PercentOfIndividualsWithFollowUpWithin7Days  
                                                         WHERE
                                                              ISNULL(DaysBetweenDischargeAndFollowUp,
                                                              99) <=7
                                                       )
                                                     / ( SELECT
                                                              COUNT(*)
                                                         FROM #PercentOfIndividualsWithFollowUpWithin7Days  
                                                       ) * 100 ) AS DECIMAL(10,
                                                              2)) AS VARCHAR)
                            + '%'
                            , BlockScore30 = CAST(CAST(( 1.0
                                                     * ( SELECT
                                                              COUNT(*)
                                                         FROM #PercentOfIndividualsWithFollowUpWithin7Days  
                                                         WHERE
                                                              ISNULL(DaysBetweenDischargeAndReadmission,
                                                              99) <=30
                                                       )
                                                     / ( SELECT
                                                              COUNT(*)
                                                         FROM #PercentOfIndividualsWithFollowUpWithin7Days  
                                                       ) * 100 ) AS DECIMAL(10,
                                                              2)) AS VARCHAR)
                            + '%'
                            , BlockScore180 = CAST(CAST(( 1.0
                                                     * ( SELECT
                                                              COUNT(*)
                                                         FROM #PercentOfIndividualsWithFollowUpWithin7Days  
                                                         WHERE
                                                              ISNULL(DaysBetweenDischargeAndReadmission,
                                                              990) <=180
                                                       )
                                                     / ( SELECT
                                                              COUNT(*)
                                                         FROM #PercentOfIndividualsWithFollowUpWithin7Days  
                                                       ) * 100 ) AS DECIMAL(10,
                                                              2)) AS VARCHAR)
                            + '%'

                            UPDATE #PercentOfIndividualsWithFollowUpWithin7Days SET BlockScore = 
                            'Individuals With Follow Up within 7 Days: ' + BlockScore7 + CHAR(13) + CHAR(10)
                            +'Readmission rates Returning within 30 Days: ' + BlockScore30 + CHAR(13) + CHAR(10)
                            +'Readmission rates Returning within 180 Days: ' + BlockScore180 

                    SELECT  *
                    FROM    #PercentOfIndividualsWithFollowUpWithin7Days
                    
                    IF OBJECT_ID('tempdb..#PercentOfIndividualsWithFollowUpWithin7Days') IS NOT NULL
                        DROP TABLE #PercentOfIndividualsWithFollowUpWithin7Days
 
                END
 
            --#############################################################################
            -- Readmission rates (percent of individuals returning within 30 days)
            --
            -- System will search for clients with a hospital discharge date
            -- (Client Information – Hospitalizations – Discharge Date) where there is
            -- another hospital admission within 30 days of discharge date 
            -- (Client Information – Hospitalizations – Admission date) / total number
            -- of hospital discharges reported during the reporting period
            --
            --############################################################################# 
     
              --############################################################################# 
            IF @BlockName = 'percent of individuals returning within 30 days'
                BEGIN
   --   Exec csp_ReportAccountabilityMetricsReporting @BlockName = 'percent of individuals returning within 30 days', @FromDate='1/1/16', @ToDate= '5/1/16'


                    CREATE TABLE #ReadmissionRatesReturningWithin30DaysofDischarge
                        (
                         BlockTitle VARCHAR(MAX)
                        ,BlockScore VARCHAR(MAX)
                        ,ClientId INTEGER
                        ,ClientNameAndId VARCHAR(MAX)
                        ,HospitalDischargeDate DATE
                        ,NewAdmissionDate DATE
                        ,DaysBetweenContact INTEGER
                        ,StaffName VARCHAR(MAX)
                        ,Reason VARCHAR(MAX)
                        )


                    SELECT  *
                    FROM    #ReadmissionRatesReturningWithin30DaysofDischarge
                    IF OBJECT_ID('tempdb..#ReadmissionRatesReturningWithin30DaysofDischarge') IS NOT NULL
                        DROP TABLE #ReadmissionRatesReturningWithin30DaysofDischarge
 
                END
 
            IF @BlockName = 'percent of individuals returning within 180 days'
                BEGIN
   --   Exec csp_ReportAccountabilityMetricsReporting @BlockName = 'percent of individuals returning within 180 days', @FromDate='1/1/16', @ToDate= '5/1/16'


                    CREATE TABLE #ReadmissionRatesReturningWithin180DaysofDischarge
                        (
                         BlockTitle VARCHAR(MAX)
                        ,BlockScore VARCHAR(MAX)
                        ,ClientId INTEGER
                        ,ClientNameAndId VARCHAR(MAX)
                        ,HospitalDischargeDate DATE
                        ,NewAdmissionDate DATE
                        ,DaysBetweenContact INTEGER
                        ,StaffName VARCHAR(MAX)
                        ,Reason VARCHAR(MAX)
                        )
     

                    SELECT  *
                    FROM    #ReadmissionRatesReturningWithin180DaysofDischarge
                    IF OBJECT_ID('tempdb..#ReadmissionRatesReturningWithin180DaysofDischarge') IS NOT NULL
                        DROP TABLE #ReadmissionRatesReturningWithin180DaysofDischarge
 

                END

            --#############################################################################
            -- the next set of report blocks take information from Admission and Discharge
            -- documents.  Store a list of these so we don't have to repull.
            --############################################################################# 

--jhere
            CREATE TABLE #AdmissionAndDischargeDocuments
                (
                 DocumentType VARCHAR(MAX)
                ,ClientId INTEGER
                ,EffectiveDate DATE
                ,LivingArangement VARCHAR(MAX)
                ,EmploymentStatus VARCHAR(MAX)
                ,EducationStatus VARCHAR(MAX)
                ,JusticeSystemInvolvement VARCHAR(MAX)
                ,NumberOfArrestPast12Months VARCHAR(MAX)
                ,NumberOfArrestsLast30Days VARCHAR(MAX)
                ,NumberOfEmployersLast12Months VARCHAR(MAX)
                ,NumberOfEmployers VARCHAR(MAX)
                ,NumberOfMonthsEmployed VARCHAR(MAX)
                )


            INSERT  INTO #AdmissionAndDischargeDocuments
                    ( DocumentType
                    ,ClientId
                    ,EffectiveDate
                    ,LivingArangement
                    ,EmploymentStatus
                    ,EducationStatus
                    ,JusticeSystemInvolvement
                    ,NumberOfArrestPast12Months
                    ,NumberOfArrestsLast30Days
                    ,NumberOfEmployersLast12Months
                    ,NumberOfEmployers
                    ,NumberOfMonthsEmployed
                    )
                    SELECT  DC.DocumentName
                    ,       D.ClientId
                    ,       D.EffectiveDate
                    ,       ISNULL(dbo.GetGlobalCodeName(admis.LivingArrangments),
                                   dbo.GetGlobalCodeName(dis.LivingArrangement))
                    ,       ISNULL(dbo.GetGlobalCodeName(admis.EmploymentStatus),
                                   dbo.GetGlobalCodeName(dis.EmploymentStatus))
                    ,       ISNULL(dbo.GetGlobalCodeName(admis.EducationStatus),
                                   dbo.GetGlobalCodeName(dis.EducationStatus))
                    ,       ISNULL(dbo.GetGlobalCodeName(admis.JusticeSystemInvolvement),
                                   dbo.GetGlobalCodeName(dis.JusticeSystem))
                    ,       CASE WHEN admis.DocumentVersionId IS NOT NULL
                                 THEN ISNULL(CAST(admis.NumberOfArrestPast12Months AS VARCHAR),
                                             'NA')
                                 ELSE 'NA'
                            END
                    ,       CASE WHEN admis.DocumentVersionId IS NOT NULL
                                 THEN ISNULL(CAST(admis.NumberOfArrestsLast30Days AS VARCHAR),
                                             'NA')
                                 ELSE 'NA'
                            END
                    ,       CASE WHEN admis.DocumentVersionId IS NOT NULL
                                 THEN ISNULL(CAST(admis.NumberOfEmployersLast12Months AS VARCHAR),
                                             'NA')
                                 ELSE 'NA'
                            END
                    ,       CASE WHEN dis.DocumentVersionId IS NOT NULL
                                 THEN ISNULL(CAST(dis.NumberOfEmployers AS VARCHAR),
                                             'NA')
                                 ELSE 'NA'
                            END
                    ,       CASE WHEN dis.DocumentVersionId IS NOT NULL
                                 THEN ISNULL(CAST(dis.NumberOfMonthsEmployed AS VARCHAR),
                                             'NA')
                                 ELSE 'NA'
                            END
                    FROM    Documents D
                            JOIN DocumentCodes DC ON DC.DocumentCodeId = D.DocumentCodeId
                            LEFT JOIN CustomDocumentDischarges dis ON D.CurrentDocumentVersionId = dis.DocumentVersionId
                                                              AND ISNULL(dis.RecordDeleted,
                                                              'N') = 'N'
                            LEFT JOIN CustomDocumentRegistrations admis ON D.CurrentDocumentVersionId = admis.DocumentVersionId
                                                              AND ISNULL(admis.RecordDeleted,
                                                              'N') = 'N'
                    WHERE   D.Status = 22
                            AND ISNULL(D.RecordDeleted, 'N') = 'N'
                            AND D.DocumentCodeId IN ( 10500, 46225 ) -- admission, discharge
                            AND D.EffectiveDate >= @FromDate
                            AND D.EffectiveDate < @ToDate


            IF @BlockName = 'percent of individuals reporting same or better housing'
                BEGIN
   --   Exec csp_ReportAccountabilityMetricsReporting @BlockName = 'percent of individuals reporting same or better housing', @FromDate='1/1/16', @ToDate= '5/1/16'

                    CREATE TABLE #PercentOfIndividualsReportingSameOrBetterHousing
                        (
                         BlockTitle VARCHAR(MAX)
                        ,ClientId INTEGER
                        ,ClientNameAndId VARCHAR(MAX)
                        ,DataSource VARCHAR(MAX)
                        ,SourceDate DATE
                        ,HousingStatus VARCHAR(MAX)
                        )

                    INSERT  INTO #PercentOfIndividualsReportingSameOrBetterHousing
                            (BlockTitle
                            ,ClientId
                            ,ClientNameAndId
                            ,DataSource
                            ,SourceDate
                            ,HousingStatus
                            )
                            SELECT  @BlockName
                            ,       AADD.ClientId
                            ,       Cl.LastName + ', ' + Cl.FirstName + ' ('
                                    + CAST(Cl.ClientId AS VARCHAR) + ')'
                            ,       AADD.DocumentType
                            ,       AADD.EffectiveDate
                            ,       ISNULL(AADD.LivingArangement, 'NA')
                            FROM    #AdmissionAndDischargeDocuments AADD
                                    JOIN Clients Cl ON Cl.ClientId = AADD.ClientId
                
                    SELECT  *
                    FROM    #PercentOfIndividualsReportingSameOrBetterHousing
                    IF OBJECT_ID('tempdb..#PercentOfIndividualsReportingSameOrBetterHousing') IS NOT NULL
                        DROP TABLE #PercentOfIndividualsReportingSameOrBetterHousing
 

                END



            IF @BlockName = 'percent of individuals reporting same or better Employment'
                BEGIN
   --   Exec csp_ReportAccountabilityMetricsReporting @BlockName = 'percent of individuals reporting same or better Employment', @FromDate='1/1/16', @ToDate= '5/1/16'


                    CREATE TABLE #PercentOfIndividualsReportingSameOrBetterEmployemnt
                        (
                         BlockTitle VARCHAR(MAX)
                        ,ClientId INTEGER
                        ,ClientNameAndId VARCHAR(MAX)
                        ,DataSource VARCHAR(MAX)
                        ,SourceDate DATE
                        ,EmploymentStatus VARCHAR(MAX)
                        ,NumberOfEmployersLast12Months VARCHAR(MAX)
                        ,NumberOfEmployers VARCHAR(MAX)
                        ,NumberOfMonthsEmployed VARCHAR(MAX)
                        )

                    INSERT  INTO #PercentOfIndividualsReportingSameOrBetterEmployemnt
                            (BlockTitle
                            ,ClientId
                            ,ClientNameAndId
                            ,DataSource
                            ,SourceDate
                            ,EmploymentStatus
                            ,NumberOfEmployersLast12Months
                            ,NumberOfEmployers
                            ,NumberOfMonthsEmployed
                            )
                            SELECT  @BlockName
                            ,       AADD.ClientId
                            ,       Cl.LastName + ', ' + Cl.FirstName + ' ('
                                    + CAST(Cl.ClientId AS VARCHAR) + ')'
                            ,       AADD.DocumentType
                            ,       AADD.EffectiveDate
                            ,       ISNULL(AADD.EmploymentStatus, 'NA')
                            ,       ISNULL(AADD.NumberOfArrestPast12Months,
                                           'NA')
                            ,       ISNULL(AADD.NumberOfEmployers, 'NA')
                            ,       ISNULL(AADD.NumberOfMonthsEmployed, 'NA')
                            FROM    #AdmissionAndDischargeDocuments AADD
                                    JOIN Clients Cl ON Cl.ClientId = AADD.ClientId



                    SELECT  *
                    FROM    #PercentOfIndividualsReportingSameOrBetterEmployemnt
                    IF OBJECT_ID('tempdb..#PercentOfIndividualsReportingSameOrBetterEmployemnt') IS NOT NULL
                        DROP TABLE #PercentOfIndividualsReportingSameOrBetterEmployemnt
 

                END


            IF @BlockName = 'percent of individuals reporting same or better School Performance'
                BEGIN
   --   Exec csp_ReportAccountabilityMetricsReporting @BlockName = 'percent of individuals reporting same or better School Performance', @FromDate='1/1/16', @ToDate= '5/1/16'

  
                    CREATE TABLE #PercentOfIndividualsReportingSameOrBetterSchoolPerformance
                        (
                         BlockTitle VARCHAR(MAX)
                        ,ClientId INTEGER
                        ,ClientNameAndId VARCHAR(MAX)
                        ,DataSource VARCHAR(MAX)
                        ,SourceDate DATE
                        ,EducationStatus VARCHAR(MAX)
                        )
                    INSERT  INTO #PercentOfIndividualsReportingSameOrBetterSchoolPerformance
                            (BlockTitle
                            ,ClientId
                            ,ClientNameAndId
                            ,DataSource
                            ,SourceDate
                            ,EducationStatus
                            )
                            SELECT  @BlockName
                            ,       AADD.ClientId
                            ,       Cl.LastName + ', ' + Cl.FirstName + ' ('
                                    + CAST(Cl.ClientId AS VARCHAR) + ')'
                            ,       AADD.DocumentType
                            ,       AADD.EffectiveDate
                            ,       ISNULL(AADD.EducationStatus, 'NA')
                            FROM    #AdmissionAndDischargeDocuments AADD
                                    JOIN Clients Cl ON Cl.ClientId = AADD.ClientId
                


                    SELECT  *
                    FROM    #PercentOfIndividualsReportingSameOrBetterSchoolPerformance
                    IF OBJECT_ID('tempdb..#PercentOfIndividualsReportingSameOrBetterSchoolPerformance') IS NOT NULL
                        DROP TABLE #PercentOfIndividualsReportingSameOrBetterSchoolPerformance
 

                END


            IF @BlockName = 'percent of individuals reporting Decrease in Criminal Justice Involvement '
                BEGIN
   --   Exec csp_ReportAccountabilityMetricsReporting @BlockName = 'percent of individuals reporting Decrease in Criminal Justice Involvement', @FromDate='1/1/16', @ToDate= '5/1/16'

             
                    CREATE TABLE #PercentOfIndividualsReportingDecreaseInCriminalJusticeInvolvement
                        (
                         BlockTitle VARCHAR(MAX)
                        ,ClientId INTEGER
                        ,ClientNameAndId VARCHAR(MAX)
                        ,DataSource VARCHAR(MAX)
                        ,SourceDate DATE
                        ,JusticeSystemInvolvement VARCHAR(MAX)
                        ,NumberOfArrestsLast30Days VARCHAR(MAX)
                        ,NumberOfArrestPast12Months VARCHAR(MAX)
                        )

                    INSERT  INTO #PercentOfIndividualsReportingDecreaseInCriminalJusticeInvolvement
                            (BlockTitle
                            ,ClientId
                            ,ClientNameAndId
                            ,DataSource
                            ,SourceDate
                            ,JusticeSystemInvolvement
                            ,NumberOfArrestsLast30Days
                            ,NumberOfArrestPast12Months
                            )
                            SELECT  @BlockName
                            ,       AADD.ClientId
                            ,       Cl.LastName + ', ' + Cl.FirstName + ' ('
                                    + CAST(Cl.ClientId AS VARCHAR) + ')'
                            ,       AADD.DocumentType
                            ,       AADD.EffectiveDate
                            ,       ISNULL(AADD.JusticeSystemInvolvement, 'NA')
                            ,       AADD.NumberOfArrestsLast30Days
                            ,       AADD.NumberOfArrestPast12Months
                            FROM    #AdmissionAndDischargeDocuments AADD
                                    JOIN Clients Cl ON Cl.ClientId = AADD.ClientId

                    SELECT  *
                    FROM    #PercentOfIndividualsReportingDecreaseInCriminalJusticeInvolvement
                    IF OBJECT_ID('tempdb..#PercentOfIndividualsReportingDecreaseInCriminalJusticeInvolvement') IS NOT NULL
                        DROP TABLE #PercentOfIndividualsReportingDecreaseInCriminalJusticeInvolvement
 

                END



        END TRY
        BEGIN CATCH
            IF @@Trancount > 0
                ROLLBACK TRAN
            DECLARE @ThisProcedureName VARCHAR(255) = ISNULL(OBJECT_NAME(@@PROCID),
                                                             'Testing')
            DECLARE @ErrorProc VARCHAR(4000) = CONVERT(VARCHAR(4000), ISNULL(ERROR_PROCEDURE(),
                                                              @ThisProcedureName))
            SET @ErrorMessage = @ThisProcedureName
                + ' Reports Error Thrown by: ' + @ErrorProc --+ CHAR(13)

            SET @ErrorMessage += ISNULL(CONVERT(VARCHAR(4000), ERROR_MESSAGE()),
                                        'Unknown') + CHAR(13)
                + @ThisProcedureName + ' Variable dump:' + CHAR(13)
                --+ '@SourceTableName:' + ISNULL(@SourceTableName, 'Null')
                --+ CHAR(13) + '@LocalKeyValue:'
                --+ ISNULL(CAST(@LocalKeyValue AS VARCHAR(25)), 'Null')
                --+ CHAR(13)

            RAISERROR(@ErrorMessage, -- Message.   
             16, -- Severity.   
             1 -- State.   
             );
        END CATCH
    END

GO
--#############################################################################
-- hooks for the idividual report blocks
--############################################################################# 


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].csp_ReportAccountabilityMetricsReporting_Housing')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].csp_ReportAccountabilityMetricsReporting_Housing
GO


CREATE PROCEDURE [dbo].csp_ReportAccountabilityMetricsReporting_Housing
    @FromDate DATETIME
,   @ToDate DATETIME
,   @CoveragePlans VARCHAR(MAX) = NULL
,   @ProgramType VARCHAR(MAX) = NULL
,   @Location VARCHAR(MAX) = NULL
--,   @JusticeSystemInvolvement VARCHAR(MAX) = NULL
AS
    BEGIN
        EXEC csp_ReportAccountabilityMetricsReporting @BlockName = 'percent of individuals reporting same or better housing',
            @FromDate = @FromDate, @ToDate = @ToDate,
            @CoveragePlans = @CoveragePlans, @ProgramType = @ProgramType,
            @Location = @Location -- varchar(max)
      --  @JusticeSystemInvolvement = '' -- varchar(max)
    
    END
GO


IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].csp_ReportAccountabilityMetricsReporting_School')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].csp_ReportAccountabilityMetricsReporting_School
GO

CREATE PROCEDURE [dbo].csp_ReportAccountabilityMetricsReporting_School
    @FromDate DATETIME
,   @ToDate DATETIME
,   @CoveragePlans VARCHAR(MAX) = NULL
,   @ProgramType VARCHAR(MAX) = NULL
,   @Location VARCHAR(MAX) = NULL
--,   @JusticeSystemInvolvement VARCHAR(MAX) = NULL
AS
    BEGIN
        EXEC csp_ReportAccountabilityMetricsReporting @BlockName = 'percent of individuals reporting same or better School Performance',
            @FromDate = @FromDate, @ToDate = @ToDate,
            @CoveragePlans = @CoveragePlans, @ProgramType = @ProgramType,
            @Location = @Location -- varchar(max)
      --  @JusticeSystemInvolvement = '' -- varchar(max)
    
    END
GO



IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].csp_ReportAccountabilityMetricsReporting_Employment')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].csp_ReportAccountabilityMetricsReporting_Employment
GO

CREATE PROCEDURE [dbo].csp_ReportAccountabilityMetricsReporting_Employment
    @FromDate DATETIME
,   @ToDate DATETIME
,   @CoveragePlans VARCHAR(MAX) = NULL
,   @ProgramType VARCHAR(MAX) = NULL
,   @Location VARCHAR(MAX) = NULL
--,   @JusticeSystemInvolvement VARCHAR(MAX) = NULL
AS
    BEGIN
        EXEC csp_ReportAccountabilityMetricsReporting @BlockName = 'percent of individuals reporting same or better Employment',
            @FromDate = @FromDate, @ToDate = @ToDate,
            @CoveragePlans = @CoveragePlans, @ProgramType = @ProgramType,
            @Location = @Location -- varchar(max)
      --  @JusticeSystemInvolvement = '' -- varchar(max)
    
    END
GO



IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].csp_ReportAccountabilityMetricsReporting_Justice')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].csp_ReportAccountabilityMetricsReporting_Justice
GO

CREATE PROCEDURE [dbo].csp_ReportAccountabilityMetricsReporting_Justice
    @FromDate DATETIME
,   @ToDate DATETIME
,   @CoveragePlans VARCHAR(MAX) = NULL
,   @ProgramType VARCHAR(MAX) = NULL
,   @Location VARCHAR(MAX) = NULL
--,   @JusticeSystemInvolvement VARCHAR(MAX) = NULL
AS
    BEGIN
        EXEC csp_ReportAccountabilityMetricsReporting @BlockName = 'percent of individuals reporting Decrease in Criminal Justice Involvement',
            @FromDate = @FromDate, @ToDate = @ToDate,
            @CoveragePlans = @CoveragePlans, @ProgramType = @ProgramType,
            @Location = @Location -- varchar(max)
      --  @JusticeSystemInvolvement = '' -- varchar(max)
    
    END
GO




IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].csp_ReportAccountabilityMetricsReporting_NumberIndividualsServed')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].csp_ReportAccountabilityMetricsReporting_NumberIndividualsServed
GO

CREATE PROCEDURE [dbo].csp_ReportAccountabilityMetricsReporting_NumberIndividualsServed
    @FromDate DATETIME
,   @ToDate DATETIME
,   @CoveragePlans VARCHAR(MAX) = NULL
,   @ProgramType VARCHAR(MAX) = NULL
,   @Location VARCHAR(MAX) = NULL
--,   @JusticeSystemInvolvement VARCHAR(MAX) = NULL
AS
    BEGIN
        EXEC csp_ReportAccountabilityMetricsReporting @BlockName = 'Number of Individuals Served',
            @FromDate = @FromDate, @ToDate = @ToDate,
            @CoveragePlans = @CoveragePlans, @ProgramType = @ProgramType,
            @Location = @Location -- varchar(max)
      --  @JusticeSystemInvolvement = '' -- varchar(max)
    
    END
GO



IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].csp_ReportAccountabilityMetricsReporting_Percent14Days')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].csp_ReportAccountabilityMetricsReporting_Percent14Days
GO

CREATE PROCEDURE [dbo].csp_ReportAccountabilityMetricsReporting_Percent14Days
    @FromDate DATETIME
,   @ToDate DATETIME
,   @CoveragePlans VARCHAR(MAX) = NULL
,   @ProgramType VARCHAR(MAX) = NULL
,   @Location VARCHAR(MAX) = NULL
--,   @JusticeSystemInvolvement VARCHAR(MAX) = NULL
AS
    BEGIN
        EXEC csp_ReportAccountabilityMetricsReporting @BlockName = 'Percent of individuals served within 14 days of initiation',
            @FromDate = @FromDate, @ToDate = @ToDate,
            @CoveragePlans = @CoveragePlans, @ProgramType = @ProgramType,
            @Location = @Location -- varchar(max)
      --  @JusticeSystemInvolvement = '' -- varchar(max)
    
    END
GO


IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].csp_ReportAccountabilityMetricsReporting_PercentServices30Days')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].csp_ReportAccountabilityMetricsReporting_PercentServices30Days
GO

CREATE PROCEDURE [dbo].csp_ReportAccountabilityMetricsReporting_PercentServices30Days
    @FromDate DATETIME
,   @ToDate DATETIME
,   @CoveragePlans VARCHAR(MAX) = NULL
,   @ProgramType VARCHAR(MAX) = NULL
,   @Location VARCHAR(MAX) = NULL
--,   @JusticeSystemInvolvement VARCHAR(MAX) = NULL
AS
    BEGIN
        EXEC csp_ReportAccountabilityMetricsReporting @BlockName = 'Percent of individuals who received two or more services within 30 days of admission',
            @FromDate = @FromDate, @ToDate = @ToDate,
            @CoveragePlans = @CoveragePlans, @ProgramType = @ProgramType,
            @Location = @Location -- varchar(max)
      --  @JusticeSystemInvolvement = '' -- varchar(max)
    
    END
GO


IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].csp_ReportAccountabilityMetricsReporting_HospitalDischarge')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].csp_ReportAccountabilityMetricsReporting_HospitalDischarge
GO

CREATE PROCEDURE [dbo].csp_ReportAccountabilityMetricsReporting_HospitalDischarge
    @FromDate DATETIME
,   @ToDate DATETIME
,   @CoveragePlans VARCHAR(MAX) = NULL
,   @ProgramType VARCHAR(MAX) = NULL
,   @Location VARCHAR(MAX) = NULL
--,   @JusticeSystemInvolvement VARCHAR(MAX) = NULL
AS
    BEGIN
        EXEC csp_ReportAccountabilityMetricsReporting @BlockName = 'Percent of individuals who received follow-up visit within 7 days after hospitalization',
            @FromDate = @FromDate, @ToDate = @ToDate,
            @CoveragePlans = @CoveragePlans, @ProgramType = @ProgramType,
            @Location = @Location -- varchar(max)
      --  @JusticeSystemInvolvement = '' -- varchar(max)
    
    END
GO


RETURN
   --   Exec csp_ReportAccountabilityMetricsReporting @BlockName = 'percent of individuals reporting Decrease in Criminal Justice Involvement', @FromDate='1/1/16', @ToDate= '5/1/16'
   --   Exec csp_ReportAccountabilityMetricsReporting @BlockName = 'percent of individuals reporting same or better School Performance', @FromDate='1/1/16', @ToDate= '5/1/16'

   --   Exec csp_ReportAccountabilityMetricsReporting @BlockName = 'percent of individuals reporting same or better Employment', @FromDate='1/1/16', @ToDate= '5/1/16'


EXEC csp_ReportAccountabilityMetricsReporting_Percent14Days '1/1/15', '7/1/15'

   



   SELECT TOP 10 * FROM reports order by 1 desc