/****** Object:  StoredProcedure [dbo].[csp_Report_school_attendance]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_school_attendance]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_school_attendance]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_school_attendance]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE	[dbo].[csp_Report_school_attendance]
	@start_date	datetime,
	@end_date	datetime,
	@location	varchar(20)

AS
--*/

/*
DECLARE	@start_date	datetime,
	@end_date	datetime,
	@location	varchar(20)

SELECT	@start_date = 	''6/01/12'',
	@end_date = 	''7/30/12'',
	@location =	''we''
--*/

/********************************************************/
/* Stored Procedure: csp_Report_school_attendance		*/
/*			(formerly csp_MAP_room_attendance)			*/
/* Creation Date:    10/03/2006							*/
/*														*/
/* Updates:												*/
/* Date			Author		Purpose						*/
/* 10/03/2006	Jess		Created - WO 4568			*/
/* 08/27/2010	Jess		Modified - WO 15509			*/
/* 08/30/2011	Jess		Modified - WO 18944			*/
/* 06/27/2012	Jess		Converted From PsychConsult	*/
/********************************************************/

SELECT	@location =	CASE	WHEN	@location like ''r%''
							THEN	''Robinson''
							WHEN	@location like ''w%''
							THEN	''Westfield''
							ELSE	''%''
					END

DECLARE	@initial_results TABLE
	(
	ClientId		int,
	Status			char(2),
	DateOfService	datetime,
	Location		varchar(25),
	Room			varchar(35),
	Duration		int
	)	

DECLARE	@final_results TABLE
	(
	count			int,
	DateOfService	datetime,
	Location		varchar(25),
	Room			varchar(35),
	Duration		varchar(30),
	order_num		int
	)	

DECLARE	@totals TABLE
(
	DateOfService datetime,
	range1 int,
	range2 int,
	range3 int,
	range4 int
)

DECLARE	@grand_totals TABLE
(
	DateOfService datetime,
	count	int
)


INSERT	INTO	@initial_results
SELECT	DISTINCT
		S.ClientId, 
		S.Status, 
		CONVERT(varchar, S.DateOfService, 101),
		L.LocationName,
		G.GroupName,
		S.Unit
FROM	Services S
JOIN	GroupServices GS
ON		S.GroupServiceId = GS.GroupServiceId
JOIN	Groups G
ON		GS.GroupId = G.GroupId
JOIN	Locations L
ON		S.LocationId = L.LocationId
WHERE	S.DateOfService between @start_date and dateadd(dd, 1, @end_date)
AND		S.Status in (''71'', ''75'')	-- Show, Complete
AND		L.LocationName like @location
AND		L.LocationName in (''Robinson'', ''Westfield'')
AND		ISNULL(S.RecordDeleted, ''N'') <> ''Y''
AND		ISNULL(GS.RecordDeleted, ''N'') <> ''Y''
AND		ISNULL(G.RecordDeleted, ''N'') <> ''Y''
AND		ISNULL(L.RecordDeleted, ''N'') <> ''Y''
ORDER BY
	CONVERT(varchar, S.DateOfService, 101),
	G.GroupName,
	S.ClientId

--SELECT	* FROM	@initial_results

INSERT	INTO	@final_results
SELECT	count(*),
		DateOfService,
		Location,
		Room,
		''90 or Less'',
		1
FROM	@initial_results
WHERE	Duration <= 90
GROUP	BY
		DateOfService,
		Location,
		Room

INSERT	INTO	@final_results
SELECT	count(*),
		DateOfService,
		Location,
		Room,
		''91 - 119'',
		2
FROM	@initial_results
WHERE	Duration between 91 and 119
GROUP	BY
		DateOfService,
		Location,
		Room

INSERT	INTO	@final_results
SELECT	count(*),
		DateOfService,
		Location,
		Room,
		''120 - 179'',
		3
FROM	@initial_results
WHERE	Duration between 120 and 179
GROUP	BY
		DateOfService,
		Location,
		Room

INSERT	INTO	@final_results
SELECT	count(*),
		DateOfService,
		Location,
		Room,
		''180 or More'',
		4
FROM	@initial_results
WHERE	Duration >= 180
GROUP	BY
		DateOfService,
		Location,
		Room

--select * from @final_results

INSERT	INTO @totals
SELECT	DISTINCT
		fr.DateOfService,
		(SELECT	SUM(count) FROM @final_results fr2 where fr.DateOfService = fr2.DateOfService and fr2.order_num = 1),
		(SELECT	SUM(count) FROM @final_results fr2 where fr.DateOfService = fr2.DateOfService and fr2.order_num = 2),
		(SELECT	SUM(count) FROM @final_results fr2 where fr.DateOfService = fr2.DateOfService and fr2.order_num = 3),
		(SELECT	SUM(count) FROM @final_results fr2 where fr.DateOfService = fr2.DateOfService and fr2.order_num = 4)
FROM	@final_results fr
GROUP	BY
		DateOfService,
		order_num

UPDATE	@totals
SET		range1 = 0
WHERE	range1 is null

UPDATE	@totals
SET		range2 = 0
WHERE	range2 is null

UPDATE	@totals
SET		range3 = 0
WHERE	range3 is null

UPDATE	@totals
SET		range4 = 0
WHERE	range4 is null

INSERT	INTO @grand_totals
SELECT	DISTINCT
		fr.DateOfService,
		SUM(fr.count)
FROM	@final_results fr
GROUP	BY
		DateOfService

/*
select ''@totals'', * from @totals
select ''@grand_totals'', * from @grand_totals
*/


INSERT	INTO @final_results
SELECT	t.range1,
		t.DateOfService,
		''zTotals'',
		'''',
		''90 or Less'',
		5
FROM	@totals t

INSERT	INTO @final_results
SELECT	t.range2,
		t.DateOfService,
		''zTotals'',
		'''',
		''91 - 119'',
		6
FROM	@totals t

INSERT	INTO @final_results
SELECT	t.range3,
		t.DateOfService,
		''zTotals'',
		'''',
		''120 - 179'',
		7
FROM	@totals t

INSERT	INTO @final_results
SELECT	t.range4,
		t.DateOfService,
		''zTotals'',
		'''',
		''180 or More'',
		8
FROM	@totals t

INSERT	INTO @final_results
SELECT	gt.count,
		gt.DateOfService,
		''zzGrandTotals'',
		'''',
		'''',
		9
FROM	@grand_totals gt

SELECT	fr.*,
		@location as ''LocationInput''
FROM	@final_results fr
ORDER	BY
		fr.DateOfService,
		fr.order_num,
		fr.Location,
		fr.Room
' 
END
GO
