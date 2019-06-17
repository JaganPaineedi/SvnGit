IF EXISTS (SELECT *
             FROM sys.objects
            WHERE object_id = OBJECT_ID(N'ssp_SCRDLConcurrentUsers')
              AND type IN ( N'P', N'PC' ))
BEGIN
    DROP PROCEDURE ssp_SCRDLConcurrentUsers;
END;
GO

CREATE PROCEDURE ssp_SCRDLConcurrentUsers (@RangeOption INT)
AS
/******************************************************************************
**		File: 
**		Name: ssp_SCRDLConcurrentUsers
**		Desc: 
**
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**
**		Auth: jcarlson
**		Date: 8/11/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      8/11/2017          jcarlson             created
*******************************************************************************/
BEGIN TRY

    --(M)onth
    --ExternalCode1 = Number of months in past ( 0 = current past )
    --ExternalCode2 = Number of years in past ( 0 = current year )
    --(Y)ear
    --ExternalCode1 = Number of years in past ( 0 = current year )
    --ExternalCode2 = Not used
    --(D)ay
    --ExternalCode1 = To Date - Number of days in the past ( 0 = current day )
    --ExternalCode2 = From Date - Number of days in the past ( 0 = current day )
    --(D)ate(T)ime
    --ExternalCode1 = To Date
    --ExternalCode2 = From Date

    --find the seed
    DECLARE @SystemMessage VARCHAR(MAX) = '';
    DECLARE @SystemError AS INT = 0;

    --Set the start and end date parameters based on the predefined range options
    DECLARE @FromDate DATETIME,
            @ToDate   DATETIME;
    DECLARE @RangeCode          VARCHAR(100),
            @RangeExternalCode1 VARCHAR(MAX),
            @RangeExternalCode2 VARCHAR(MAX);

    SELECT @RangeCode = Code, --Date Type ( (M)onth,(D)ay,(Y)ear,(D)ate(T)ime )
           @RangeExternalCode1 = ExternalCode1,
           @RangeExternalCode2 = ExternalCode2
      FROM GlobalCodes
     WHERE GlobalCodeId = @RangeOption;

    IF (@RangeCode IN ( 'D', 'M', 'DT', 'Y' ))
    BEGIN
        IF ( (  ISNULL(@RangeExternalCode1, '') = ''
           AND  @RangeCode IN ( 'D', 'M', 'Y', 'DT' ))
          OR ( ISNULL(@RangeExternalCode2, '') = ''
           AND @RangeCode IN ( 'D', 'M', 'DT' )))
        BEGIN
            SET @SystemMessage = 'The selected range is not set up correctly.';
            IF (@RangeCode = 'M')
            BEGIN
                SET @RangeExternalCode1 = CONVERT(VARCHAR(MAX), DATEPART(MONTH, GETDATE()));
                SET @RangeExternalCode2 = CONVERT(VARCHAR(MAX), DATEPART(YEAR, GETDATE()));
            END;
            IF (@RangeCode IN ( 'D' ))
            BEGIN
                SET @RangeExternalCode1 = '0';
                SET @RangeExternalCode2 = CONVERT(VARCHAR(MAX), DATEPART(YEAR, GETDATE()));
            END;
            IF (@RangeCode = 'Y')
            BEGIN
                SET @RangeExternalCode1 = '0';
            END;
            IF (@RangeCode = 'DT')
            BEGIN
                SET @RangeExternalCode1 = CONVERT(VARCHAR(MAX), GETDATE());
                SET @RangeExternalCode2 = CONVERT(VARCHAR(MAX), DATEADD(DAY, -1, GETDATE()));
            END;
        END;

        IF (@RangeCode IN ( 'D', 'M', 'Y' ))
        BEGIN
            IF (ISNULL(@RangeExternalCode1, '') <> '')
            BEGIN
                IF (ISNUMERIC(@RangeExternalCode1) = 0)
                BEGIN
                    SET @SystemMessage
                        = @SystemMessage + CHAR(13) + CHAR(10) + 'Range''s External Code 1 is not a number.';
                    SET @SystemError = 1;
                END;
            END;
            IF (ISNULL(@RangeExternalCode2, '') <> '')
            BEGIN
                IF (ISNUMERIC(@RangeExternalCode2) = 0)
                BEGIN
                    SET @SystemMessage
                        = @SystemMessage + CHAR(13) + CHAR(10) + 'Range''s External Code 2 is not a number.';
                    SET @SystemError = 1;
                END;
            END;

        END;

        IF (@RangeCode = 'DT')
        BEGIN

            IF (ISNULL(@RangeExternalCode1, '') <> '')
            BEGIN
                IF (ISDATE(@RangeExternalCode1) = 0)
                BEGIN
                    SET @SystemMessage
                        = @SystemMessage + CHAR(13) + CHAR(10) + 'Range''s External Code 1 is not a date.';
                    SET @SystemError = 1;
                END;
            END;
            IF (ISNULL(@RangeExternalCode2, '') <> '')
            BEGIN
                IF (ISDATE(@RangeExternalCode2) = 0)
                BEGIN
                    SET @SystemMessage
                        = @SystemMessage + CHAR(13) + CHAR(10) + 'Range''s External Code 2 is not a date.';
                    SET @SystemError = 1;
                END;
            END;
        END;

        IF (@SystemError = 0)
        BEGIN
            IF (@RangeCode = 'D')
            BEGIN
			   
                SET @ToDate = DATEADD(MILLISECOND,-3,DATEADD(dd, DATEDIFF(dd, CONVERT(INT,@RangeExternalCode1), GetDate() + 1),0));
                SET @FromDate = DATEADD(DAY, -CONVERT(INT, @RangeExternalCode2), GETDATE());
            END;

            IF (@RangeCode = 'DT')
            BEGIN
                SELECT @ToDate = DATEADD(ms, -3, DATEADD(dd, DATEDIFF(dd, 0, DATEADD(DAY,1,CONVERT(DATE,@RangeExternalCode1))), 0)) ;
                SELECT @FromDate = CONVERT(DATE, @RangeExternalCode2);
            END;

            IF (@RangeCode = 'M')
            BEGIN
                SELECT @ToDate = MAX(Date)
                  FROM Dates
                 WHERE Year  = DATEPART(YEAR, GETDATE()) - CONVERT(INT, @RangeExternalCode2)
                   AND Month = DATEPART(MONTH, GETDATE()) - CONVERT(INT, @RangeExternalCode1);

				   SET @ToDate = DATEADD(MILLISECOND, -3, DATEADD(dd, DATEDIFF(dd, 0, DATEADD(DAY,1,@ToDate)), 0))

                SELECT @FromDate = MIN(Date)
                  FROM Dates
                 WHERE Year  = DATEPART(YEAR, GETDATE()) - CONVERT(INT, @RangeExternalCode2)
                   AND Month = DATEPART(MONTH, GETDATE()) - CONVERT(INT, @RangeExternalCode1);
            END;

            IF (@RangeCode = 'Y')
            BEGIN
                SELECT @ToDate = DATEADD(MILLISECOND,-3,DATEADD(DAY,1,MAX(Date)))
                  FROM Dates
                 WHERE Year = DATEPART(YEAR, GETDATE()) - CONVERT(INT, @RangeExternalCode1);

				 SET @ToDate = DATEADD(MILLISECOND, -3, DATEADD(dd, DATEDIFF(dd, 0, DATEADD(DAY,1,@ToDate)), 0))

                SELECT @FromDate = MIN(Date)
                  FROM Dates
                 WHERE Year = DATEPART(YEAR, GETDATE()) - CONVERT(INT, @RangeExternalCode1);
            END;
        END;
    END;
    ELSE
    BEGIN
        SET @SystemError = 1;
        SET @SystemMessage = 'The selected range is not recognized.';
    END;
	SET @FromDate = CONVERT(DATE,@FromDate)
	PRINT @FromDate
	PRINT @ToDate
    IF (@SystemError = 0)
    BEGIN
        CREATE TABLE #cte_final (
            RowNumber INT,
            StaffId INT,
            InOrOut VARCHAR(MAX),
            [DateTime] DATETIME,
            Concurrent INT,
            MaxConcurrent INT,
            UserType VARCHAR(MAX),
            StaffName VARCHAR(MAX));
        INSERT INTO #cte_final
        EXEC dbo.ssp_SCGetConcurrentUsers @FromDate = @FromDate, -- datetime
        @ToDate = @ToDate; -- datetime


        IF (SELECT COUNT(*) FROM #cte_final) > 0
        BEGIN

            SELECT a.RowNumber,
                   a.StaffId,
                   a.InOrOut,
                   a.[DateTime],
                   a.Concurrent,
                   a.MaxConcurrent,
                   a.UserType,
                   a.StaffName,
                   @SystemMessage AS SystemMessage,
                   @SystemError AS SystemError,
                   CONVERT(VARCHAR(MAX), @FromDate, 101) AS FromDate,
                   CONVERT(VARCHAR(MAX), @ToDate, 101) AS ToDate,
                   1 AS HasRows
              FROM #cte_final AS a
             ORDER BY CASE a.UserType
                           WHEN 'Staff' THEN 1
                           WHEN 'Patient Portal User' THEN 2
                           WHEN 'Streamline Staff' THEN 3
                           ELSE 4 END,
                      a.DateTime;
        END;
        ELSE
        BEGIN
            SELECT -1 AS RowNumber,
                   -1 AS StaffId,
                   '' AS InOrOut,
                   GETDATE() AS [DateTime],
                   -1 AS Concurrent,
                   -1 AS MaxConcurrent,
                   '' AS UserType,
                   '' AS StaffName,
                   CASE
                        WHEN ISNULL(@SystemMessage, '') = '' THEN
                            'No data has been found for date range - ' + CONVERT(VARCHAR(MAX), @FromDate, 101) + ' to '
                            + CONVERT(VARCHAR(MAX), @ToDate, 101)
                        ELSE @SystemMessage END AS SystemMessage,
                   @SystemError AS SystemError,
                   CONVERT(VARCHAR(MAX), @FromDate, 101) AS FromDate,
                   CONVERT(VARCHAR(MAX), @ToDate, 101) AS ToDate,
                   0 AS HasRows;
        END;

    END;
    ELSE
    BEGIN

        SELECT -1 AS RowNumber,
               -1 AS StaffId,
               '' AS InOrOut,
               GETDATE() AS [DateTime],
               -1 AS Concurrent,
               -1 AS MaxConcurrent,
               '' AS UserType,
               '' AS StaffName,
               @SystemMessage AS SystemMessage,
               @SystemError AS SystemError,
               CONVERT(VARCHAR(MAX), @FromDate, 101) AS FromDate,
               CONVERT(VARCHAR(MAX), @ToDate, 101) AS ToDate,
               0 AS HasRows;

    END;


END TRY
BEGIN CATCH
    DECLARE @Error VARCHAR(8000);
    SELECT @Error
        = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
          + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCRDLConcurrentUsers') + '*****'
          + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
          + CONVERT(VARCHAR, ERROR_STATE());


    SELECT -1 AS RowNumber,
           -1 AS StaffId,
           '' AS InOrOut,
           GETDATE() AS [DateTime],
           -1 AS Concurrent,
           -1 AS MaxConcurrent,
           '' AS UserType,
           '' AS StaffName,
           'An unexpected error has occured. Please contact your system'' administrator' AS SystemMessage,
           @SystemError AS SystemError,
           CONVERT(VARCHAR(MAX), @FromDate, 101) AS FromDate,
           CONVERT(VARCHAR(MAX), @ToDate, 101) AS ToDate,
           0 AS HasRows;

END CATCH;