IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssf_GetAllDatesforAttendanceAssignmentRecurring]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[ssf_GetAllDatesforAttendanceAssignmentRecurring]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[ssf_GetAllDatesforAttendanceAssignmentRecurring] (
	@UserCode VARCHAR(50)
	,@FromDate DATE
	,@ToDate DATE
	,@Monday CHAR(1)
	,@Tuesday CHAR(1)
	,@Wednesday CHAR(1)
	,@Thursday CHAR(1)
	,@Friday CHAR(1)
	,@Saturday CHAR(1)
	,@Sunday CHAR(1)
	,@AssignmentDate DATE
	,@GroupServiceId VARCHAR(max)
	)
/****************************************************************************/
/*                                                                          */
/*-------------Modification History--------------------------               */
/*-------Date-----------Author------------Purpose---------------------------*/
/*       09-June-2015  Revathi           Created(Task #829 in Woods - Customizations).*/
/****************************************************************************/	
RETURNS @TempScheduleDates TABLE (
	GroupServiceId INT
	,AssignmentDate DATETIME
	,RecurringDate DATE
	,weekdays VARCHAR(max)
	)
AS
BEGIN
		;WITH DateTemp AS 
		(SELECT MyCounter = 0		
		UNION ALL		
		SELECT MyCounter + 1
		FROM DateTemp
		WHERE MyCounter < DATEDIFF(d, @FromDate, @ToDate)
		)
		,GroupServiceIds AS (
		SELECT item AS GroupServiceId
		FROM dbo.fnSplit(@GroupServiceId, ',')
		)
	INSERT INTO @TempScheduleDates (
		GroupServiceId
		,AssignmentDate
		,RecurringDate
		,weekdays
		)
	SELECT GS.GroupServiceId
		,@AssignmentDate
		,(DATEADD(d, D.MyCounter, @FromDate))
		,(DATENAME(dw, DATEADD(d, D.MyCounter, @FromDate)))
	FROM DateTemp D
	CROSS APPLY GroupServiceIds GS
	WHERE (	(SELECT LEFT(DATENAME(weekday, DATEADD(d, MyCounter, @FromDate)), 3)) = CASE WHEN @Monday = 'Y'	THEN 'MON'	END
			OR (SELECT LEFT(DATENAME(weekday, DATEADD(d, MyCounter, @FromDate)), 3)) = CASE WHEN @Tuesday = 'Y'	THEN 'TUE'	END
			OR (SELECT LEFT(DATENAME(weekday, DATEADD(d, MyCounter, @FromDate)), 3)) = CASE WHEN @Wednesday = 'Y' THEN 'WED' END
			OR (SELECT LEFT(DATENAME(weekday, DATEADD(d, MyCounter, @FromDate)), 3)) = CASE WHEN @Thursday = 'Y' THEN 'THU'	END
			OR (SELECT LEFT(DATENAME(weekday, DATEADD(d, MyCounter, @FromDate)), 3)) = CASE WHEN @Friday = 'Y' THEN 'FRI'	END
			OR (SELECT LEFT(DATENAME(weekday, DATEADD(d, MyCounter, @FromDate)), 3)) = CASE WHEN @Saturday = 'Y' THEN 'SAT'	END
			OR (SELECT LEFT(DATENAME(weekday, DATEADD(d, MyCounter, @FromDate)), 3)) = CASE WHEN @sunday = 'Y' THEN 'SUN' END
			)
		AND (DATEADD(d, D.MyCounter, @FromDate) <> @AssignmentDate)
	OPTION (MAXRECURSION 0)

	RETURN
END
GO

