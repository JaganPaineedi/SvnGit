/****** Object:  StoredProcedure [dbo].[csp_Report_clients_turning_18]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_clients_turning_18]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_clients_turning_18]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_clients_turning_18]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE [dbo].[csp_Report_clients_turning_18]
		@StartDate	datetime,
		@EndDate	datetime,
		@LocationID	Int
AS	
--*/

/*
DECLARE	@StartDate	datetime,
		@EndDate	datetime,
		@LocationID	Int

SELECT	@StartDate	= ''3/1/13'',
		@EndDate	= ''3/31/13'',
		@LocationID	= 8 -- Central Ave.	-- 0=All Locations
--*/

SET NOCOUNT ON; -- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
/****************************************************************/
/* Stored Procedure:	csp_Report_clients_turning_18			*/
/*							(Formerly csp_youth_task_17)		*/
/* Creation Date:	05/30/2012									*/
/*																*/
/* Updates:														*/
/*  Date		Author	Purpose 								*/
/*  07/07/2012	Jess	Converted from Psych Consult			*/
/*	11/07/2012	MSR		Changed Loction to LocationID			*/
/****************************************************************/
DECLARE @Location TABLE
(
	LocationID		Int,
	LocationName	Varchar(25)
)

IF	@LocationID = 0 BEGIN
INSERT INTO @Location 
SELECT l.LocationId, l.LocationCode 
	FROM dbo.Locations l 
	WHERE l.Active = ''Y'' 
	AND (ISNULL(l.RecordDeleted,''N'')<>''Y'')
END
ELSE BEGIN
INSERT INTO @Location 
SELECT l.LocationId, l.LocationCode 
	FROM dbo.Locations l 
	WHERE l.Active = ''Y'' 
	AND l.LocationId = @LocationID 
	AND (ISNULL(l.RecordDeleted,''N'')<>''Y'')
END

SELECT	DISTINCT 		
		C.ClientId,
		C.DOB,
		DATEADD(YY, 18, C.DOB) AS ''DateTurning18'',
		C.LastName + '', '' + C.FirstName AS ''Client'',
		S.LastName + '', '' + S.FirstName AS ''Primary Staff'',
		L.LocationName AS ''Primary Location'',
		CC.MACUCI,
		P.ProgramName,
		COV.CoveragePlanName
FROM	Clients C
LEFT JOIN	ClientPrograms CP
	ON	C.ClientId = CP.ClientId
		AND	CP.Status <> 5 -- Discharged
		AND	CP.ProgramId IN	(	''18'',	-- Child Psychiatry
								''20'',	-- Developmental Behavioral Pediatrics
								''22'',	-- Early Childhood Intervention
								''25'',	-- MH CPST Youth Division
								''26'',	-- MH Day Treatment Youth Division
								''28'',	-- MH Psychological Testing & Evaluation Youth Division
								''30''	-- MH Therapy Youth Division
							)
	AND	ISNULL(CP.RecordDeleted, ''N'') <> ''Y''		
LEFT JOIN	Programs P
	ON	CP.ProgramId = P.ProgramId
	AND ISNULL(P.RecordDeleted, ''N'') <> ''Y''		
LEFT JOIN Staff S							-- Temp. used Left Join, needs to be JOIN when live.
	ON	S.StaffId = C.PrimaryClinicianID
	AND ISNULL(S.RecordDeleted, ''N'') <> ''Y''
JOIN CustomClients CC
	ON	CC.ClientId = C.ClientId
	AND ISNULL(CC.RecordDeleted, ''N'') <> ''Y''
LEFT JOIN @Location l	-- TEMPORARY LEFT join as clients aren''t assigned to locations
	ON	L.LocationId = CC.Location
	--AND	L.LocationName like @Location
	--AND ISNULL(L.RecordDeleted, ''N'') <> ''Y''	
LEFT JOIN ClientCoveragePlans CCP
	ON	C.ClientId = CCP.ClientId
	AND	CCP.CoveragePlanId IN	(	''559'',	-- DFMCD4801M - Mental Hlth Serv-LCMHB Dual Fund SED Medicaid	
									''566'',	-- DFMCD48OYM - Mental Hlth Serv-LCMHB Dual Fund Oth Yth Medicaid	
									''595'',	-- DFNON4801M - Mental Hlth Serv-LCMHB Dual Funded SED Non-MCD
									''600'',	-- DFNON48OYM - Mental Hlth Serv-LCMHB Dual Funded Oth Yth Non-MCD
									''1150'', -- MHMCD4801 - LCMHB SED MEDICAID	
									''1816'', -- DFMCD4801T - Mental Health Serv - "TJ" LCMHB Dual Fund SED MCD	
									''1819'' -- DFMCD48OYT - Mental Hlth Serv-"TJ" LCMHB Dual fund OthYth MCD
								)
	AND ISNULL(CCP.RecordDeleted, ''N'') <> ''Y''
LEFT JOIN ClientCoverageHistory CCH
	ON	CCP.ClientId = CCH.ClientCoveragePlanId
	AND	CCH.EndDate IS NULL
	AND ISNULL(CCH.RecordDeleted, ''N'') <> ''Y''
LEFT JOIN CoveragePlans COV
	ON	CCP.CoveragePlanId = COV.CoveragePlanId
WHERE	C.Active = ''Y''
AND		C.DOB >=DATEADD(yy ,-18, @StartDate) 
AND		C.DOB <= DATEADD(YY, -18, @EndDate)
--AND		CC.MACUCI is not null	-- JMB 1/7/13.  MACUCI no longer required since Medicaid moved from MACSIS to MITS
AND		(	CP.ProgramId IS NOT NULL 
		OR	CCP.CoveragePlanId IS NOT NULL
		)
ORDER BY DOB


' 
END
GO
