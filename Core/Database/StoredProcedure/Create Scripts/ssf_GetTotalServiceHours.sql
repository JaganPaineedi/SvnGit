IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssf_GetTotalServiceHours]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[ssf_GetTotalServiceHours]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[ssf_GetTotalServiceHours] (
	@StaffID INT
	,@DayOfService DATETIME
	)
RETURNS DECIMAL(10, 2)
AS
/*********************************************************************/
/* Function: [ssf_GetTotalServiceHours]               */
/* Creation Date:  17/OCT/2016                                   */
/* Input Parameters:   @StaffID,@DayOfService*/
/*Author:Vamsi N*/
/*Purpose:To get duriation of services for a day WRT Bear River - Support Go Live #97*/
/*********************************************************************/
BEGIN
 -- BEGIN TRY
	DECLARE @ServiceHours DECIMAL(10, 2)
	DECLARE @Day DATE

	SET @Day = DATEADD(dd, DATEDIFF(dd, 0, @DayOfService), 0)

	DECLARE @Duration1 DECIMAL(10, 2)
		,@Duration2 DECIMAL(10, 2)
		,@Duration3 DECIMAL(10, 2)

	SELECT @Duration1 = SUM(DURATION)
	FROM (
		SELECT
			--DATEDIFF(minute, DateTimeIn, DateTimeOut) DURATION      
			CONVERT(DECIMAL(10, 2), DATEDIFF(minute, SR.DateTimeIn, SR.DateTimeOut) / 60.0) DURATION
		FROM SERVICES SR
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = SR.STATUS
		WHERE SR.ClinicianId = @StaffID
			AND (GC.Category) = 'SERVICESTATUS'
			AND GC.ExternalCode1 IN (
				'SHOW'
				,'COMPLETE'
				)
			AND @Day BETWEEN DATEADD(dd, DATEDIFF(dd, 0, SR.DateTimeIn), 0)
				AND SR.DateTimeOut
			AND ISNULL(SR.DateTimeIn, '') != ''
			AND ISNULL(SR.DateTimeOut, '') != ''
			AND ISNULL(SR.RecordDeleted, 'N') = 'N'
			AND ISNULL(SR.GROUPSERVICEID, 0) = 0
		) A

	--------------------------------------         
	SELECT @Duration2 = SUM(DURATION)
	FROM (
		SELECT CASE 
				WHEN GCU.ExternalCode1 = 'MINUTES'
					THEN
						--'MI'      
						-- DATEDIFF(minute, DateTimeIn, DATEADD(mi,SR.Unit,DateTimeIn))      
						CONVERT(DECIMAL(10, 2), DATEDIFF(minute, SR.DateTimeIn, DATEADD(mi, SR.Unit, SR.DateTimeIn)) / 60.0)
				WHEN GCU.ExternalCode1 = 'HOURS'
					THEN
						-- 'HH'      
						-- DATEDIFF(minute, DateTimeIn, DATEADD(hh,SR.Unit,DateTimeIn))      
						CONVERT(DECIMAL(10, 2), DATEDIFF(minute, SR.DateTimeIn, DATEADD(hh, SR.Unit, SR.DateTimeIn)) / 60.0)
				WHEN GCU.ExternalCode1 = 'DAYS'
					THEN
						-- 'DD'      
						--  DATEDIFF(minute, DateTimeIn, DATEADD(dd,SR.Unit,DateTimeIn))      
						CONVERT(DECIMAL(10, 2), DATEDIFF(minute, SR.DateTimeIn, DATEADD(dd, SR.Unit, SR.DateTimeIn)) / 60.0)
				END DURATION
		FROM SERVICES SR
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = SR.STATUS
		LEFT JOIN GlobalCodes GCU ON GCU.GlobalCodeId = SR.UnitType
		WHERE ClinicianId = @StaffID
			AND (GC.Category) = 'SERVICESTATUS'
			AND GC.ExternalCode1 IN (
				'SHOW'
				,'COMPLETE'
				)
			AND @Day = DATEADD(dd, DATEDIFF(dd, 0, SR.DateTimeIn), 0)
			AND ISNULL(SR.DateTimeIn, '') != ''
			AND ISNULL(SR.DateTimeOut, '') = ''
			AND ISNULL(SR.RecordDeleted, 'N') = 'N'
			AND ISNULL(SR.GROUPSERVICEID, 0) = 0
		) B

	---------------------------------------------      
	SELECT @Duration3 = SUM(DURATION)
	FROM (
		SELECT
			-- DATEDIFF(minute, @Day, DateTimeOut) DURATION      
			CONVERT(DECIMAL(10, 2), DATEDIFF(minute, @Day, SR.DateTimeOut) / 60.0) DURATION
		FROM SERVICES SR
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = SR.STATUS
		WHERE ClinicianId = @StaffID
			AND (GC.Category) = 'SERVICESTATUS'
			AND GC.ExternalCode1 IN (
				'SHOW'
				,'COMPLETE'
				)
			AND @Day > DATEADD(dd, DATEDIFF(dd, 0, DateTimeIn), 0)
			AND @Day <= DateTimeOut
			AND ISNULL(SR.DateTimeIn, '') != ''
			AND ISNULL(SR.DateTimeOut, '') != ''
			AND ISNULL(SR.RecordDeleted, 'N') = 'N'
			AND ISNULL(SR.GROUPSERVICEID, 0) = 0
		) C

	-------------Group Service Calculation  
	DECLARE @GroupServiceDuration1 DECIMAL(10, 2)
		,@GroupServiceDuration2 DECIMAL(10, 2)
	DECLARE @TEMP TABLE (
		GroupServiceId INT
		,DateTimeIn DATETIME
		,DateTimeOut DATETIME
		)

	INSERT INTO @TEMP
	SELECT sr.GroupServiceId
		,DateTimeIn
		,DateTimeOut
	FROM SERVICES SR
	LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = SR.STATUS
	WHERE ClinicianId = @StaffID
		AND (GC.Category) = 'SERVICESTATUS'
		AND GC.ExternalCode1 IN (
			'SHOW'
			,'COMPLETE'
			)
		AND @Day BETWEEN DATEADD(dd, DATEDIFF(dd, 0, DateTimeIn), 0)
			AND DateTimeOut
		AND ISNULL(DateTimeIn, '') != ''
		AND ISNULL(DateTimeOut, '') != ''
		AND ISNULL(SR.RecordDeleted, 'N') = 'N'
		AND ISNULL(SR.GROUPSERVICEID, 0) != 0
	GROUP BY GroupServiceId
		,DateTimeIn
		,DateTimeOut

	--- returns groupservices with same timein and timeout   
	DECLARE @GroupServiceWithSameTimeInTimeOut TABLE (
		GroupServiceId INT
		,DateTimeIn DATETIME
		,DateTimeOut DATETIME
		)

	INSERT INTO @GroupServiceWithSameTimeInTimeOut
	SELECT T1.*
	FROM @TEMP T1
	JOIN (
		SELECT Groupserviceid
		FROM @TEMP
		GROUP BY gROUPSERVICEID
		HAVING COUNT(GROUPSERVICEID) = 1
		) T2 ON T1.GROUPSERVICEID = T2.GROUPSERVICEID

	----Calculate groyp service time  
	SELECT @GroupServiceDuration1 = SUM(DURATION)
	FROM (
		SELECT CONVERT(DECIMAL(10, 2), DATEDIFF(minute, DateTimeIn, DateTimeOut) / 60.0) DURATION
		FROM @GroupServiceWithSameTimeInTimeOut
		GROUP BY DateTimeIn
			,DateTimeOut
		) AS GS1

	--- Group service with same group, with different time in and time out irrespective of procedure code  
	DECLARE @GroupServiceWithDifferentTimeInTimeOut TABLE (
		GroupServiceId INT
		,DateTimeIn DATETIME
		,DateTimeOut DATETIME
		)

	-- return groupservice with different timein and time out  
	INSERT INTO @GroupServiceWithDifferentTimeInTimeOut
	SELECT T1.*
	FROM @TEMP T1
	JOIN (
		SELECT Groupserviceid
		FROM @TEMP
		GROUP BY gROUPSERVICEID
		HAVING COUNT(GROUPSERVICEID) > 1
		) T2 ON T1.GROUPSERVICEID = T2.GROUPSERVICEID

	SELECT @GroupServiceDuration2 = SUM(DURATION)
	FROM (
		SELECT CONVERT(DECIMAL(10, 2), DATEDIFF(minute, TIMEIN, TIMEOUT) / 60.0) DURATION
		FROM (
			SELECT GROUPSERVICEID
				,MIN(DATETIMEIN) TIMEIN
				,MAX(DATETIMEOUT) TIMEOUT
			FROM @GroupServiceWithDifferentTimeInTimeOut
			GROUP BY GROUPSERVICEID
			) AS GS2
		) AS F

	--------------------------------------  
	DECLARE @Duration DECIMAL(10, 2)

	SET @Duration = ISNULL(@Duration1, 0) + ISNULL(@Duration2, 0) + ISNULL(@Duration3, 0) + ISNULL(@GroupServiceDuration1, 0) + ISNULL(@GroupServiceDuration2, 0)

	SELECT @ServiceHours = @Duration -- CAST(SUM(@Duration)/60 + (SUM(@Duration)  % 60) /100.0 AS DECIMAL(10,2))       

	RETURN @ServiceHours
	--END TRY
 --  BEGIN CATCH
 --  --Checking For Errors  
 --  DECLARE @Error varchar(8000)
 --   SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE())
 --   + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_TimeSheetEntryList')
 --   + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY())
 --   + '*****' + CONVERT(varchar, ERROR_STATE())
 --   RAISERROR
 --   (
 --   @Error, -- Message text.  
 --   16,  -- Severity.  
 --   1  -- State.  
 --   );      
    
 --   END CATCH      
END
