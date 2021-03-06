/****** Object:  StoredProcedure [dbo].[csp_Report_school_seasonal_attendance]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_school_seasonal_attendance]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_school_seasonal_attendance]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_school_seasonal_attendance]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_school_seasonal_attendance]
	-- Add the parameters for the stored procedure here
	@start_date	datetime,
	@end_date	datetime,
	@summer_winter_or_spring	varchar(10)AS
--*/
-- ========================================================
-- Stored Procedure:  csp_Report_school_seasonal_attendance
-- Copyright:  Harbor Behavioral Healthcare	
--
-- Updates:                        
--	Date		Author	Purpose
--	04/27/2004  MSR     Created
-- ========================================================
/*
DECLARE	@start_date	datetime,
		@end_date	datetime,
		@summer_winter_or_spring	varchar(10)

SELECT	@start_date = 	''1/03/13'',
		@end_date = 	''1/3/13'',
		@summer_winter_or_spring = ''winter''
--*/
BEGIN

SELECT DISTINCT
	G.GroupName,
	CASE WHEN srv.Unit >= 120
		THEN 1
		ELSE 2
	END	AS ''Duration Order'',
	srv.DateofService,
	CASE	WHEN	@summer_winter_or_spring like ''su%''
		THEN	''Summer''
		WHEN	@summer_winter_or_spring like ''w%''
		THEN	''Winter''
		WHEN	@summer_winter_or_spring like ''sp%''
		THEN	''Spring''
	END	AS	''Season'',
	c.LastName + '', '' + c.FirstName AS ''Client'',
	srv.ClientId, 
	CASE srv.Status
	WHEN 75 THEN ''CO''
	WHEN 71 THEN ''SH''
	END AS ''Status'',
	CONVERT(varchar, srv.DateOfService, 101) AS ''Date'',
	s.LastName + '', '' + s.FirstName AS ''Staff'',
	srv.Unit AS ''Duration''
FROM dbo.Services srv
JOIN dbo.GroupServices GS
ON srv.GroupServiceId = GS.GroupServiceId
AND	ISNULL(GS.RecordDeleted, ''N'') <> ''Y''
JOIN dbo.Groups G 
ON GS.GroupId = G.GroupId
AND	ISNULL(G.RecordDeleted, ''N'') <> ''Y''
--AND g.Active = ''Y''
JOIN dbo.clients c 
ON srv.ClientId = c.ClientId 
AND	ISNULL(c.RecordDeleted, ''N'') <> ''Y''
JOIN dbo.Staff s
ON srv.ClinicianId = s.StaffId 
AND	ISNULL(s.RecordDeleted, ''N'') <> ''Y''
WHERE srv.DateOfService between @start_date and dateadd(dd, 1, @end_date)
AND	srv.Status in (''71'', ''75'')	-- Show, Complete
AND	(
	(@summer_winter_or_spring like ''w%''
		AND (g.GroupCode like ''%win%'')
	)
	OR	(@summer_winter_or_spring like ''su%''
		AND	(g.GroupCode like ''%sum%'')
	)
	OR	(@summer_winter_or_spring like ''sp%'' 
		AND (g.GroupCode like ''%spr%'')
	)
)
AND	srv.ProcedureCodeId NOT IN (460, 461, 481) -- NB_PHOSP+N, NB_PHOSPLS, PREV_EDUC 
AND	ISNULL(srv.RecordDeleted, ''N'') <> ''Y''
ORDER BY
	''Duration Order'',
	G.GroupName,
	''Client'',
	srv.DateOfService 
END
' 
END
GO
