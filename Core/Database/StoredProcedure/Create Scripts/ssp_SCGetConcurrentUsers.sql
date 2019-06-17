IF EXISTS (SELECT *
             FROM sys.objects
            WHERE object_id = OBJECT_ID(N'ssp_SCGetConcurrentUsers')
              AND type IN ( N'P', N'PC' ))
BEGIN
    DROP PROCEDURE ssp_SCGetConcurrentUsers;
END;
GO
SET QUOTED_IDENTIFIER OFF;
SET ANSI_NULLS ON;
GO
CREATE PROCEDURE ssp_SCGetConcurrentUsers (@FromDate DATETIME,@ToDate DATETIME)
AS /**********************************************************************************/
--Stored Procedure: ssp_SCGetConcurrentUsers	                       
-- Updates:                                                            
-- Date			Author			Purpose                                                
-- 09-08-2016	Wasif Butt		Concurrent user reporting based on StaffLoginHistory 
-- 03/01/2017   jcarlson		updated UserType Name
--								    Patient >> Patient Portal User
--									Streamline >> Streamline Staff
--									Staff >> Staff
-- 03/27/2017   jcarlson		converted CTE's to temp tables for performance increase
-- 03/27/2017   jcarlson		added in seeding logic
-- 08/09/2017	jcarlson		EII 542 - removed start and end date options these have been replaced with predefined options
-- 08/10/2017	jcarlson		EII 542 - moved new logic to ssp_SCRDLConcurrentUsers, added back from and to date parameters
/**********************************************************************************/
BEGIN TRY

    --(M)onth
    --ExternalCode1 = Number of months in past ( 0 = current past )
    --ExternalCode2 = Number of years in past ( 0 = current year )
    --(Y)ear
    --ExternalCode1 = Number of years in past ( 0 = current year )
    --ExternalCode2 = Not used
    --(D)ay
    --ExternalCode1 = Number of days in the past ( 0 = current day )
    --ExternalCode2 = Number of days in the past ( 0 = current day )
    --(D)ate(T)ime
    --ExternalCode1 = Start Date
    --ExternalCode2 = End Date

    --find the seed
    DECLARE @StaffSeed INT = 0;
    DECLARE @StreamlineSeed INT = 0;
    DECLARE @PatientPortalSeed INT = 0;

     SELECT a.StaffId,
               st.DisplayAs AS StaffName,
               a.LoginTime,
               a.RemoteLogin,
               a.SessionId,
               a.LogoutTime,
               CASE
                    WHEN ISNULL(st.NonStaffUser, 'N') = 'Y' THEN 'Patient Portal User'
                    WHEN ISNULL(sp.StreamlineStaff, 'N') = 'Y' THEN 'Streamline Staff'
                    ELSE 'Staff' END AS UserType
        INTO   #SessionTemp1
          FROM dbo.StaffLoginHistory AS a
          JOIN Staff AS st
            ON a.StaffId  = st.StaffId
          JOIN dbo.StaffPreferences AS sp
            ON st.StaffId = sp.StaffId
         WHERE -- Logged In Before the interval, log out sometime after the interval starts 
               ( (       a.LoginTime                  <  @FromDate
               AND       ISNULL(a.LogoutTime, @ToDate) >  @FromDate)
              OR (       a.LoginTime                          >=  @FromDate
               AND       a.LoginTime                    <=  @ToDate
               AND       ISNULL(a.LogoutTime, @ToDate)   >=  @FromDate))
           AND ISNULL(a.SessionId, '')                                 <> '';
        --meets
        /*
				-----------------|---------------------|---------------
                           |----------|
						   |-------------------------------|
				
			                         |----------|
						             |-------------------------------|
				
				*/
        SELECT StaffId,
               StaffName,
               LoginTime,
               RemoteLogin,
               SessionId,
               LogoutTime,
               UserType,
               ROW_NUMBER() OVER (PARTITION BY StaffId ORDER BY LoginTime) AS rowNumber
        INTO   #SessionBadData1
          FROM #SessionTemp1;

        SELECT a.StaffId,
               a.StaffName,
               a.LoginTime,
               a.RemoteLogin,
               a.SessionId,
               ISNULL(a.LogoutTime, DATEADD(SECOND, -1, b.LoginTime)) AS LogoutTime,
               a.UserType,
               a.rowNumber
        INTO   #SeedSessions
          FROM #SessionBadData1 AS a
          LEFT JOIN #SessionBadData1 AS b
            ON a.StaffId   = b.StaffId
           AND b.rowNumber = a.rowNumber + 1;
        --find the most recent login of each, so we do don't double count
        -- only want what starts before the interval starts
        SELECT @StaffSeed = COUNT(*)
          FROM #SeedSessions AS a
         WHERE a.UserType   = 'Staff'
           AND NOT EXISTS (SELECT 1
                             FROM #SeedSessions AS b
                            WHERE a.StaffId    = b.StaffId
                              AND a.rowNumber  < b.rowNumber
                              AND a.UserType   = b.UserType
                              AND b.LoginTime  < @FromDate
                              AND a.LogoutTime > @FromDate)
           AND a.LoginTime  < @FromDate
           AND a.LogoutTime > @FromDate;

        SELECT @StreamlineSeed = COUNT(*)
          FROM #SeedSessions AS a
         WHERE a.UserType   = 'Streamline Staff'
           AND NOT EXISTS (SELECT 1
                             FROM #SeedSessions AS b
                            WHERE a.StaffId    = b.StaffId
                              AND a.rowNumber  < b.rowNumber
                              AND a.UserType   = b.UserType
                              AND b.LoginTime  < @FromDate
                              AND a.LogoutTime > @FromDate)
           AND a.LoginTime  < @FromDate
           AND a.LogoutTime > @FromDate;

        SELECT @PatientPortalSeed = COUNT(*)
          FROM #SeedSessions AS a
         WHERE a.UserType   = 'Patient Portal User'
           AND NOT EXISTS (SELECT 1
                             FROM #SeedSessions AS b
                            WHERE a.StaffId    = b.StaffId
                              AND a.rowNumber  < b.rowNumber
                              AND a.UserType   = b.UserType
                              AND b.LoginTime  < @FromDate
                              AND a.LogoutTime > @FromDate)
           AND a.LoginTime  < @FromDate
           AND a.LogoutTime > @FromDate;


        SELECT StaffId,
               1 AS InOrOut,
               LoginTime AS DateTime,
               s.UserType,
               StaffName
        INTO #cte_log_in_out
          FROM #SeedSessions AS s
         WHERE s.LoginTime >= @FromDate -- only want what is in the interval 
        UNION ALL
        SELECT StaffId,
               -1,
               s.LogoutTime,
               s.UserType,
               StaffName
          FROM #SeedSessions AS s
         WHERE s.LogoutTime IS NOT NULL --no logout time means they are still logged in
           --include the log outs from the seed
           --dont include logout times before @fromdate
           AND s.LogoutTime >= @FromDate;


        CREATE TABLE #cte_RNo (
            RowNumber INT,
            StaffId INT,
            InOrOut INT,
            [DateTime] DATETIME,
            UserType VARCHAR(50),
            StaffName VARCHAR(500));
        INSERT INTO #cte_RNo (RowNumber,
                              StaffId,
                              InOrOut,
                              [DateTime],
                              UserType,
                              StaffName)
        SELECT ROW_NUMBER() OVER (PARTITION BY UserType ORDER BY cte_log_in_out.[DateTime]) AS RowNumber,
               cte_log_in_out.StaffId,
               cte_log_in_out.InOrOut,
               cte_log_in_out.DateTime,
               cte_log_in_out.UserType,
               StaffName
          FROM #cte_log_in_out AS cte_log_in_out
         ORDER BY [cte_log_in_out].[DateTime];

        CREATE NONCLUSTERED INDEX a
        ON #cte_RNo (RowNumber);
        CREATE NONCLUSTERED INDEX a1
        ON #cte_RNo (RowNumber, UserType);
        CREATE NONCLUSTERED INDEX a2
        ON #cte_RNo (RowNumber, UserType, InOrOut);

        CREATE TABLE #cte_concurrent (
            RowNumber INT,
            UserType VARCHAR(50),
            Concurrent INT);

        CREATE NONCLUSTERED INDEX a2
        ON #cte_concurrent (RowNumber);
        CREATE NONCLUSTERED INDEX a3
        ON #cte_concurrent (Concurrent, UserType);
        --456
        INSERT INTO #cte_concurrent (RowNumber,
                                     Concurrent,
                                     UserType)
        SELECT t.RowNumber,
               @StaffSeed + SUM(t2.InOrOut) AS Concurrent,
               t.UserType
          FROM #cte_RNo AS t
          JOIN #cte_RNo AS t2
            ON t.UserType  = t2.UserType
           AND t2.UserType = 'Staff'
         WHERE t.RowNumber >= t2.RowNumber
         GROUP BY t.RowNumber,
                  t.UserType
         ORDER BY t.RowNumber;
        --0
        INSERT INTO #cte_concurrent (RowNumber,
                                     Concurrent,
                                     UserType)
        SELECT t.RowNumber,
               @PatientPortalSeed + SUM(t2.InOrOut) AS Concurrent,
               t.UserType
          FROM #cte_RNo AS t
          JOIN #cte_RNo AS t2
            ON t.UserType  = t2.UserType
           AND t2.UserType = 'Patient Portal User'
         WHERE t.RowNumber >= t2.RowNumber
         GROUP BY t.RowNumber,
                  t.UserType
         ORDER BY t.RowNumber;
        --3
        INSERT INTO #cte_concurrent (RowNumber,
                                     Concurrent,
                                     UserType)
        SELECT t.RowNumber,
               @StreamlineSeed + SUM(t2.InOrOut) AS Concurrent,
               t.UserType
          FROM #cte_RNo AS t
          JOIN #cte_RNo AS t2
            ON t.UserType  = t2.UserType
           AND t2.UserType = 'Streamline Staff'
         WHERE t.RowNumber >= t2.RowNumber
         GROUP BY t.RowNumber,
                  t.UserType
         ORDER BY t.RowNumber;


        DECLARE @MaxStaff      INT,
                @MaxStreamline INT,
                @MaxPatient    INT;


        SELECT @MaxStaff = MAX(Concurrent)
          FROM #cte_concurrent
         WHERE UserType = 'Staff';

        SELECT @MaxStreamline = MAX(Concurrent)
          FROM #cte_concurrent
         WHERE UserType = 'Streamline Staff';

        SELECT @MaxPatient = MAX(Concurrent)
          FROM #cte_concurrent
         WHERE UserType = 'Patient Portal User';

        SELECT a.RowNumber,
               a.StaffId,
               a.InOrOut,
               a.DateTime,
               b.Concurrent,
               a.UserType,
               a.StaffName
        INTO   #cte_final
          FROM #cte_RNo AS a
          JOIN #cte_concurrent AS b
            ON b.RowNumber = a.RowNumber
           AND b.UserType  = a.UserType;

      
            SELECT a.RowNumber,
                   a.StaffId,
                   CASE a.InOrOut
                        WHEN 1 THEN 'Logged In'
                        WHEN-1 THEN 'Logged Out'
                        ELSE 'Unknown' END AS InOrOut,
                   a.[DateTime],
                   a.Concurrent,
                   CASE a.UserType
                        WHEN 'Staff' THEN @MaxStaff
                        WHEN 'Streamline Staff' THEN @MaxStreamline
                        ELSE @MaxPatient END AS MaxConcurrent,
                   a.UserType,
                   a.StaffName
              FROM #cte_final AS a
             ORDER BY CASE a.UserType
                           WHEN 'Staff' THEN 1
                           WHEN 'Patient Portal User' THEN 2
                           WHEN 'Streamline Staff' THEN 3
                           ELSE 4 END,
                      a.DateTime;
   

END TRY
BEGIN CATCH
    DECLARE @Error VARCHAR(8000);
    DECLARE @CurrentDate DATETIME = GETDATE();
    SET @Error
        = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
          + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                   'ssp_SCGetConcurrentUsers') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
          + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());

    EXEC dbo.ssp_SCLogError @ErrorMessage = @Error, -- text
                            @VerboseInfo = '', -- text
                            @ErrorType = 'ssp_SCGetConcurrentUsers', -- varchar(50)
                            @CreatedBy = 'ssp_SCGetConcurrentUsers', -- varchar(30)
                            @CreatedDate = @CurrentDate, -- datetime
                            @DatasetInfo = ''; -- text

END CATCH;
GO