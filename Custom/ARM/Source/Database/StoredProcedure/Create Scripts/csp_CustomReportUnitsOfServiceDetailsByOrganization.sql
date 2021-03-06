/****** Object:  StoredProcedure [dbo].[csp_CustomReportUnitsOfServiceDetailsByOrganization]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomReportUnitsOfServiceDetailsByOrganization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomReportUnitsOfServiceDetailsByOrganization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomReportUnitsOfServiceDetailsByOrganization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[csp_CustomReportUnitsOfServiceDetailsByOrganization]
@StartDate        AS DateTime
,@ENDDate         AS DateTime
,@Billable        AS INT  -- 0 Mean All, 1 Billable, 2 Not Billable
,@GroupServiceArea   AS INT  -- 0 Means don''t group by, 1 means group by
,@GroupProgram       AS INT  -- 0 Means don''t group by, 1 means group by
,@GroupLocation      AS INT  -- 0 Means don''t group by, 1 means group by

AS
BEGIN

IF OBJECT_ID(''tempdb..#OrgDetailedServiceUnitList'') is not null
	DROP TABLE #OrgDetailedServiceUnitList

SELECT
	S.ServiceID,
	S.ProcedureCodeID,
	ClinicianID,
	Billable = ISNULL(C.IsBonus,''N''),
	ClientID,
	S.DateOfService,
	PC.DisplayAs AS ProcedureCode,
	CASE WHEN S.UnitType=110 AND (
			PC.DisplayAs <> ''GROUP_CN'' and PC.DisplayAs <> ''CSP_GROUP''
			and PC.DisplayAs <> ''SA_IOP'' and PC.DisplayAs <> ''SA_GROUPCN''
			and PC.DisplayAs <> ''PART_HOSP'' and PC.DisplayAs <> ''EDUC_CLASS''
			and pc.DisplayAs <> ''CBA_GROUP'') THEN CONVERT(FLOAT,Unit/60)
        WHEN PC.DisplayAs =''PART_HOSP'' and S.Unit <>1  THEN CONVERT(FLOAT,(Unit))/180
		WHEN PC.DisplayAs =''PART_HOSP'' and (S.Unit =1 or S.Unit=10) THEN 1
		WHEN S.UnitType=110 and (PC.DisplayAs  = ''GROUP_CN''  or PC.DisplayAs =''CSP_GROUP''
			OR PC.DisplayAs  = ''SA_IOP''    
			or PC.DisplayAs  = ''SA_GROUPCN'' or PC.DisplayAs = ''CBA_GROUP'') THEN CONVERT(FLOAT,(unit/60))/3
		WHEN S.UnitType =110 and PC.DisplayAs = ''EDUC_CLASS''        THEN CONVERT(FLOAT,Unit)/60/6
		WHEN S.UnitType =111 or S.UnitType=112 or S.UnitType=113     THEN CONVERT(FLOAT,Unit) /60
	END AS Duration_units,
	S.GroupServiceID AS GroupServiceID,
	Cast(Null As Decimal) AS Units,
	ServiceAreaName = CASE WHEN @GroupServiceArea = 0 THEN ''ALL'' ELSE SR.ServiceAreaName END,
	ProgramName = CASE WHEN @GroupProgram = 0 THEN ''ALL'' ELSE PR.ProgramName END,
	LocationName = CASE WHEN @GroupLocation = 0 THEN ''ALL'' ELSE LO.LocationCode end,
	CAST(null as int) AS num_co_therapists,
	case
		WHEN S.UnitType=110
			and (
				PC.DisplayAs  = ''GROUP_CN''
				or PC.DisplayAs =''CSP_GROUP''
				OR PC.DisplayAs  = ''SA_IOP''
				or PC.DisplayAs  = ''SA_GROUPCN''
				or PC.DisplayAs = ''EDUC_CLASS''
				or pc.DisplayAs = ''CBA_GROUP''
			) then ''Y''
		else ''N'' 
	end as isGroupService
INTO #OrgDetailedServiceUnitList
FROM Services AS S
JOIN ProcedureCodes AS PC ON S.ProcedureCodeID=PC.ProcedureCodeID
	AND ISNULL(PC.RecordDeleted,''N'')<>''Y''
JOIN Programs            AS PR   ON PR.ProgramId=S.ProgramId
	AND ISNULL(PR.RecordDeleted,''N'')<>''Y''
JOIN ServiceAreas        AS SR   ON SR.ServiceAreaId=PR.ServiceAreaId
	AND ISNULL(SR.RecordDeleted,''N'')<>''Y''
JOIN Locations           AS LO   ON LO.LocationId=S.LocationId
	AND ISNULL(LO.RecordDeleted,''N'')<>''Y''
LEFT JOIN CustomUnitsOfServiceProcedureCategories C ON c.ProcedureCodeId = PC.ProcedureCodeId
	AND ISNULL(C.RecordDeleted,''N'')<>''Y''
WHERE ISNULL(S.RecordDeleted,''N'')<>''Y''
AND S.[Status]in (75) --Completed
and DATEDIFF(DAY,DateOfService, @EndDate) >= 0
and DATEDIFF(DAY,DateofService, @StartDate) <= 0

-- SmartCare Group Services
UPDATE S SET 
	S.num_co_therapists = GrpService.num_co_therapists
FROM #OrgDetailedServiceUnitList AS S
JOIN (  
	SELECT GroupServiceID,count(distinct StaffId)AS num_co_therapists 
	FROM GroupServiceStaff cts   with (nolock)
	WHERE GroupServiceID in (
		SELECT GroupServiceID FROM #OrgDetailedServiceUnitList
		WHERE GroupServiceID IS Not Null
		)
		AND ISNULL(cts.RecordDeleted,''N'')<>''Y''
	GROUP BY GroupServiceID 
	) AS GrpService ON GrpService.GroupServiceID=s.GroupServiceID
	where S.isGroupService = ''Y''

-- PsychConsult groups
update s set
	num_co_therapists = grp.numClinicians
from #OrgDetailedServiceUnitList as s
join (
	select s.ServiceId, COUNT(distinct ss.StaffId) as numClinicians
	from dbo.Services as S
	join dbo.ProcedureCodes as PC on PC.ProcedureCodeId = S.ProcedureCodeId
		AND ISNULL(PC.RecordDeleted,''N'')<>''Y''
	join dbo.CustomLegacyServiceStaff as ss on ss.ServiceId = s.ServiceId
		AND ISNULL(ss.RecordDeleted,''N'')<>''Y''
	where S.UnitType=110 
	and (
		PC.DisplayAs = ''GROUP_CN''
		or PC.DisplayAs =''CSP_GROUP''
		or PC.DisplayAs  = ''SA_IOP''
		or PC.DisplayAs  = ''SA_GROUPCN''
		or PC.DisplayAs = ''CBA_GROUP''
		)
	AND ISNULL(S.RecordDeleted,''N'')<>''Y''
	group by s.ServiceId
) as grp on grp.ServiceId = s.ServiceId
where s.isGroupService = ''Y''
and s.num_co_therapists is null

update #OrgDetailedServiceUnitList set num_co_therapists = 1 where ((num_co_therapists is null) or (num_co_therapists = 0))

update #OrgDetailedServiceUnitList set Duration_units = Duration_units / CAST(num_co_therapists as float)


IF OBJECT_ID(''tempdb..#OrgDetailedServiceUnitsResult'') IS NOT NULL
	DROP TABLE #OrgDetailedServiceUnitsResult

SELECT
	ProcedureCodeCatgory,
	ProcedureSubcategory,
	ServiceAreaName,
	ProgramName,
	LocationName,
	CASE WHEN s.MM=7  THEN Sum(UnitsCompleted)  ELSE 0 END AS Jul,
	CASE WHEN s.MM=8  THEN Sum(UnitsCompleted)  ELSE 0 END AS Aug,
	CASE WHEN s.MM=9  THEN Sum(UnitsCompleted)  ELSE 0 END AS Sep,
	CASE WHEN s.MM=10 THEN Sum(UnitsCompleted)  ELSE 0 END AS Oct,
	CASE WHEN s.MM=11 THEN Sum(UnitsCompleted)  ELSE 0 END AS Nov,
	CASE WHEN s.MM=12 THEN Sum(UnitsCompleted)  ELSE 0 END AS Dec,
	CASE WHEN s.MM=1  THEN Sum(UnitsCompleted)  ELSE 0 END AS Jan,
	CASE WHEN s.MM=2  THEN Sum(UnitsCompleted)  ELSE 0 END AS Feb,
	CASE WHEN s.MM=3  THEN Sum(UnitsCompleted)  ELSE 0 END AS Mar,
	CASE WHEN s.MM=4  THEN Sum(UnitsCompleted)  ELSE 0 END AS Apr,
	CASE WHEN s.MM=5  THEN Sum(UnitsCompleted)  ELSE 0 END AS MAy,
	CASE WHEN s.MM=6  THEN Sum(UnitsCompleted)  ELSE 0 END AS Jun,
	Billable
INTO #OrgDetailedServiceUnitsResult
FROM (
	SELECT
		DatePart(MM,S.DateOfService) AS MM,
		DatePart(YY,S.DateOfService) AS YY,
		CodeName AS ProcedureCodeCatgory,
		ProcedureSubcategory AS ProcedureSubcategory,
		Sum(s.Duration_units) AS UnitsCompleted,
		ServiceAreaName,
		ProgramName,
		LocationName,
		Billable
	FROM  #OrgDetailedServiceUnitList S
	JOIN (
		SELECT CodeName,ProcedureSubcategory,ProcedureCodeID
		FROM CustomUnitsOfServiceProcedureCategories AS P
		JOIN GlobalCodes G ON P.ProcedureCategory = G.GlobalCodeID
			AND ISNULL(G.RecordDeleted,''N'')<>''Y''
		WHERE ISNULL(P.RecordDeleted,''N'')<>''Y''
		) AS Cat ON S.ProcedureCodeId=Cat.ProcedureCodeID
	GROUP BY
		--GROUPING SETS((
			CodeName,
			ProcedureSubcategory,
			ServiceAreaName,
			ProgramName,
			LocationName,
			Billable,
			datepart (MM,S.DateOfService),
			datepart (YY,S.DateOfService)
		--	))
	) AS S
GROUP BY
	ProcedureCodeCatgory,
	ProcedureSubcategory,
	ServiceAreaName,
	ProgramName,
	LocationName,
	Billable,
	S.MM

IF OBJECT_ID(''tempdb..#OrgDetailedServiceUnitList'') IS NOT NULL
DROP TABLE #OrgDetailedServiceUnitList

PRINT ''Here''
SELECT
	ProcedureCodeCatgory,
	ProcedureSubcategory = ProcedureSubcategory + CASE WHEN ISNULL(Billable,''N'') = ''N'' THEN ''*'' ELSE '''' END,
	ServiceAreaName,
	ProgramName,
	LocationName,
	Billable,
	CASE WHEN Sum(Jul) = 0 THEN NULL ELSE Sum(Jul) END  As Jul,
	CASE WHEN Sum(Aug) = 0 THEN NULL ELSE Sum(Aug) END  AS Aug,
	CASE WHEN Sum(Sep) = 0 THEN NULL ELSE Sum(Sep) END  AS Sep,
	CASE WHEN Sum(Oct) = 0 THEN NULL ELSE Sum(Oct) END  AS Oct,
	CASE WHEN Sum(Nov) = 0 THEN NULL ELSE Sum(Nov) END  AS Nov,
	CASE WHEN Sum(Dec) = 0 THEN NULL ELSE Sum(Dec) END  AS [Dec],
	CASE WHEN Sum(Jan) = 0 THEN NULL ELSE Sum(Jan) END  AS Jan,
	CASE WHEN Sum(Feb) = 0 THEN NULL ELSE Sum(Feb) END  AS Feb,
	CASE WHEN Sum(Mar) = 0 THEN NULL ELSE Sum(Mar) END  AS Mar,
	CASE WHEN Sum(Apr) = 0 THEN NULL ELSE Sum(Apr) END  AS Apr,
	CASE WHEN Sum(May) = 0 THEN NULL ELSE Sum(May) END  AS May,
	CASE WHEN Sum(Jun) = 0 THEN NULL ELSE Sum(Jun) END  AS Jun,
	(Sum(Jul)+Sum(Aug)+Sum(Sep)+Sum(Oct)+Sum(Nov)+Sum(Dec)+Sum(Jan)+Sum(Feb)+Sum(Mar) +Sum(Apr) +Sum(May)+Sum(Jun))/  CASE WHEN DATEDIFF(MONTH, @StartDate, @ENDDate) = 0 THEN 1 ELSE DATEDIFF(MONTH, @StartDate, @ENDDate) END AS Average,
	(Sum(Jul)+Sum(Aug)+Sum(Sep)+Sum(Oct)+Sum(Nov)+Sum(Dec)+Sum(Jan)+Sum(Feb)+Sum(Mar) +Sum(Apr) +Sum(May)+Sum(Jun)) AS Total,
	f.OrganizationName
FROM #OrgDetailedServiceUnitsResult AS S
CROSS JOIN SystemConfigurations f
WHERE Billable = CASE @Billable
	WHEN 0 THEN Billable
	WHEN 1 THEN ''Y''
	WHEN 2 THEN ''N'' END
GROUP BY
	ProcedureCodeCatgory,
	ProcedureSubcategory,
	ServiceAreaName,
	ProgramName,
	LocationName,
	Billable,
	f.OrganizationName
ORDER BY
	ProcedureCodeCatgory,
	ProcedureSubcategory,
	ServiceAreaName,
	ProgramName,
	LocationName,
	Billable,
	f.OrganizationName

IF OBJECT_ID(''tempdb..#OrgDetailedServiceUnitStaff'') is not null
	DROP TABLE #OrgDetailedServiceUnitStaff

END

' 
END
GO
