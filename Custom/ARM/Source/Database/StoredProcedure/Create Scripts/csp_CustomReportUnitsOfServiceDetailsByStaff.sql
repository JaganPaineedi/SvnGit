/****** Object:  StoredProcedure [dbo].[csp_CustomReportUnitsOfServiceDetailsByStaff]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomReportUnitsOfServiceDetailsByStaff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomReportUnitsOfServiceDetailsByStaff]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomReportUnitsOfServiceDetailsByStaff]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
--[csp_CustomReportUnitsOfServiceDetailsByStaff] ''2/1/2013'', ''2/28/2013'', 2, 1109, 1, 0, 0, 0


CREATE  proc [dbo].[csp_CustomReportUnitsOfServiceDetailsByStaff]                                                 
@StartDate        AS DateTime 
,@EndDate         AS DateTime 
,@ReportType      AS INT  --Supervior or staff report      
,@ReportValue     AS INT
,@Billable        AS INT  -- 0 Mean All, 1 Billable, 2 Not Billable
,@ServiceAreaID   AS INT  -- 0 Means don''t group by, 1 means group by 
,@ProgramID       AS INT  -- 0 Means don''t group by, 1 means group by 
,@locationID      AS INT  -- 0 Means don''t group by, 1 means group by 
                  
  AS
BEGIN

IF OBJECT_ID(''tempdb..#DetailedServiceUnitStaff'') is not null
	DROP TABLE #DetailedServiceUnitStaff 

CREATE TABLE #DetailedServiceUnitStaff (
	StaffID INT NOT NULL,
	StaffName VARCHAR(50) NOT NULL,
	SupervisorID INT NULL,
	SupervisorName VARCHAR(50) NULL
	)

IF @ReportType=1  -- Select the Supervisor and His staffs for the selected Supervisor
BEGIN 
	INSERT      #DetailedServiceUnitStaff
	SELECT Distinct
		S.StaffID AS StaffID,
		S.LastName  + '', ''+S.FirstName  AS StaffName,
		SS.SupervisorID AS SupervisorID,
		S2.LastName + '', ''+S2.FirstName AS SupervisorName                    
	FROM Staff S
	JOIN StaffSupervisors AS SS ON SS.StaffID =S.StaffID
		AND ISNULL(SS.RecordDeleted,''N'')<>''Y''
	JOIN Staff            AS S2 ON SS.SuperVisorID=S2.StaffID
		AND ISNULL(S2.RecordDeleted,''N'')<>''Y''
	WHERE SS.SuperVisorID=@ReportValue
		AND ISNULL(S.RecordDeleted,''N'')<>''Y''
END
ELSE IF @ReportType=2 -- Select the Staff and His Superviors for the selected staff
BEGIN  
	INSERT INTO #DetailedServiceUnitStaff
	SELECT Distinct
		S.StaffID AS StaffID,
		S.LastName  + '', ''+S.FirstName  AS StaffName,
		SS.SupervisorID AS SupervisorID,
		S2.LastName + '', ''+S2.FirstName   AS SupervisorName
	FROM Staff AS S
	LEFT JOIN (
		select ss1.StaffId, min(ss1.SupervisorId) as SupervisorId
		from dbo.StaffSupervisors as ss1
		where ISNULL(ss1.RecordDeleted, ''N'') <> ''Y''
		group by ss1.StaffId
	) as ss on ss.StaffId = S.StaffId
	LEFT JOIN Staff AS S2 ON SS.SuperVisorID=S2.StaffID
		AND ISNULL(S2.RecordDeleted,''N'')<>''Y''
	WHERE S.StaffID=@ReportValue
		AND ISNULL(S.RecordDeleted,''N'')<>''Y''
END 

IF OBJECT_ID(''tempdb..#DetailedServiceUnitList'') IS NOT NULL
	DROP TABLE #DetailedServiceUnitList

SELECT
	S.ServiceID,
	S.ProcedureCodeID,
	ClinicianID,
	Billable = ISNULL(C.IsBonus,''N''),
	ClientID,
	PR.ProgramId,
	PR.ProgramName,
	SR.ServiceAreaId,
	SR.ServiceAreaName,
	LO.LocationCode,
	LO.LocationId,
	S.DateOfService,
	PC.DisplayAs,
	Stf.*,
	CASE WHEN S.UnitType=110 AND (
			PC.DisplayAs <> ''GROUP_CN'' and PC.DisplayAs <> ''CSP_GROUP''
			and PC.DisplayAs <> ''SA_IOP'' and PC.DisplayAs <> ''SA_GROUPCN'' 
			and PC.DisplayAs <> ''PART_HOSP'' and PC.DisplayAs <> ''EDUC_CLASS''
			and pc.DisplayAs <> ''CBA_GROUP'') THEN CONVERT(FLOAT,Unit/60)
        WHEN PC.DisplayAs =''PART_HOSP'' and S.Unit <>1  THEN CONVERT(FLOAT,(Unit))/180 
		WHEN PC.DisplayAs =''PART_HOSP'' and (S.Unit =1 or S.Unit=10) THEN 1
		WHEN S.UnitType=110 and (PC.DisplayAs  = ''GROUP_CN''  or PC.DisplayAs =''CSP_GROUP''
			OR PC.DisplayAs  = ''SA_IOP''    or PC.DisplayAs  = ''SA_GROUPCN''
			or pc.DisplayAs = ''CBA_GROUP'') THEN CONVERT(FLOAT,(unit/60))/3 
		WHEN S.UnitType =110 and PC.DisplayAs = ''EDUC_CLASS''        THEN CONVERT(FLOAT,Unit)/60/6   
		WHEN S.UnitType =111 or S.UnitType=112 or S.UnitType=113     THEN CONVERT(FLOAT,Unit) /60 
	END AS Duration_units,
	S.GroupServiceID AS GroupServiceID,
	CAST(null as int) AS num_co_therapists,
	Cast(Null As Decimal)  AS Units,
	case
		WHEN S.UnitType=110
			and (
				PC.DisplayAs  = ''GROUP_CN''
				or PC.DisplayAs =''CSP_GROUP''
				OR PC.DisplayAs  = ''SA_IOP''
				or PC.DisplayAs  = ''SA_GROUPCN''
				or PC.DisplayAs = ''EDUC_CLASS''
				or PC.DisplayAs = ''CBA_GROUP''
			) then ''Y''
		else ''N'' 
	end as isGroupService
INTO #DetailedServiceUnitList 
	FROM Services AS S
		JOIN ProcedureCodes AS PC ON S.ProcedureCodeID=PC.ProcedureCodeID
			AND ISNULL(PC.RecordDeleted,''N'')<>''Y''
		JOIN Programs AS PR ON PR.ProgramId=S.ProgramId
			AND ISNULL(PR.RecordDeleted,''N'')<>''Y''
		JOIN ServiceAreas AS SR ON SR.ServiceAreaId=PR.ServiceAreaId
			AND ISNULL(SR.RecordDeleted,''N'')<>''Y''
		JOIN Locations AS LO ON LO.LocationId=S.LocationId
			AND ISNULL(LO.RecordDeleted,''N'')<>''Y''
		JOIN #DetailedServiceUnitStaff AS Stf ON stf.StaffID =ClinicianID
		LEFT JOIN CustomUnitsOfServiceProcedureCategories C ON c.ProcedureCodeId = PC.ProcedureCodeId
			AND ISNULL(C.RecordDeleted,''N'')<>''Y''
	WHERE ISNULL(S.RecordDeleted,''N'')<>''Y''
	AND S.[Status]in (75) -- Completed
  and DATEDIFF(DAY,DateOfService, @EndDate) >= 0
  and DATEDIFF(DAY,DateofService, @StartDate) <= 0

-- SmartCare Group Services
UPDATE S SET 
	S.num_co_therapists = GrpService.num_co_therapists
FROM #DetailedServiceUnitList AS S
JOIN (  
	SELECT GroupServiceID,count(distinct StaffId)AS num_co_therapists 
	FROM GroupServiceStaff cts   with (nolock)
	WHERE GroupServiceID in (
		SELECT GroupServiceID FROM #DetailedServiceUnitList
		WHERE GroupServiceID IS Not Null
		)
		AND ISNULL(cts.RecordDeleted,''N'')<>''Y''
	GROUP BY GroupServiceID 
	) AS GrpService ON GrpService.GroupServiceID=s.GroupServiceID
WHERE S.isGroupService = ''Y''
	
-- PsychConsult groups
update s set
	num_co_therapists = grp.numClinicians
from #DetailedServiceUnitList as s
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

update #DetailedServiceUnitList set num_co_therapists = 1 where ((num_co_therapists is null) or (num_co_therapists = 0))

update #DetailedServiceUnitList set Duration_units = Duration_units / CAST(num_co_therapists as float)



IF OBJECT_ID(''tempdb..#DetailedServiceUnitsResult'') is not null
	DROP TABLE #DetailedServiceUnitsResult

SELECT
	S.SupervisorName,
	ServiceAreaName,
	ProgramName,
	LocationCode,
	Billable,
	s.staffID,
	S.StaffName,
	ProcedureCodeCatgory,
	ProcedureSubcategory = ProcedureSubcategory,	-- + CASE WHEN ISNULL(Billable,''N'') = ''N'' THEN ''*'' ELSE '''' END,
	Case when s.MM=7  then Sum(UnitsCompleted)  Else 0 End as Jul,
	Case when s.MM=8  then Sum(UnitsCompleted)  Else 0 End as Aug,
	Case when s.MM=9  then Sum(UnitsCompleted)  Else 0 End as Sep,
	Case when s.MM=10 then Sum(UnitsCompleted)  Else 0 End as Oct,
	Case when s.MM=11 then Sum(UnitsCompleted)  Else 0 End as Nov,
	Case when s.MM=12 then Sum(UnitsCompleted)  Else 0 End as [Dec],
	Case when s.MM=1  then Sum(UnitsCompleted)  Else 0 End as Jan,
	Case when s.MM=2  then Sum(UnitsCompleted)  Else 0 End as Feb,
	Case when s.MM=3  then Sum(UnitsCompleted)  Else 0 End as Mar,
	Case when s.MM=4  then Sum(UnitsCompleted)  Else 0 End as Apr,
	Case when s.MM=5  then Sum(UnitsCompleted)  Else 0 End as MAy,
	Case when s.MM=6  then Sum(UnitsCompleted)  Else 0 End as Jun
INTO #DetailedServiceUnitsResult
FROM (
	SELECT 
		S.SupervisorName,
		CASE WHEN @ServiceAreaID=0 THEN NULL ELSE ServiceAreaName END ServiceAreaName,
		CASE WHEN @ProgramID=0 THEN NULL ELSE ProgramName END AS ProgramName,
		CASE WHEN @locationID=0 THEN NULL ELSE LocationCode END AS LocationCode,
		DatePart(MM,S.DateOfService) AS MM,
		DatePart(YY,S.DateOfService) AS YY,
		s.staffID,
		S.StaffName,
		CodeName AS ProcedureCodeCatgory,
		ProcedureSubcategory AS ProcedureSubcategory,
		Sum(s.Duration_units) AS UnitsCompleted,
		Billable
	FROM #DetailedServiceUnitList S
	JOIN (
		SELECT CodeName,ProcedureSubcategory,ProcedureCodeID
		FROM CustomUnitsOfServiceProcedureCategories  AS P 
		JOIN GlobalCodes G on P.ProcedureCategory = G.GlobalCodeID
			AND ISNULL(G.RecordDeleted,''N'')<>''Y''
		WHERE ISNULL(P.RecordDeleted,''N'')<>''Y''
		)AS Cat On S.ProcedureCodeId=Cat.ProcedureCodeID
	GROUP BY
		--GROUPING SETS ((
		S.SupervisorID,
			S.SupervisorName,
			CASE WHEN @ServiceAreaID=0 THEN NULL ELSE ServiceAreaName END,
			CASE WHEN @ProgramID=0      THEN NULL ELSE ProgramName     END, 
			CASE WHEN @locationID=0      THEN NULL ELSE LocationCode    END, 
			s.staffID,
			S.StaffName,
			CodeName,
			Billable,
			ProcedureSubcategory,
			datepart (MM,S.DateOfService),
			datepart (YY,S.DateOfService)
			--))
	) AS S
GROUP BY S.SupervisorName,
	ServiceAreaName,
	ProgramName,
	LocationCode,
	Billable,
	s.staffID,
	S.StaffName,
	ProcedureCodeCatgory,
	ProcedureSubcategory,
	S.MM

--select * from #DetailedServiceUnitsResult

IF OBJECT_ID(''tempdb..#DetailedServiceUnitList'') IS NOT NULL
	DROP TABLE #DetailedServiceUnitList

print ''Here''
SELECT
	S.SupervisorName,
	ServiceAreaName,
	ProgramName,
	LocationCode,
	Billable,
	s.staffID,
	S.StaffName,
	ProcedureCodeCatgory,
	ProcedureSubcategory = ProcedureSubcategory + CASE WHEN ISNULL(Billable,''N'') = ''N'' THEN ''*'' ELSE '''' END,
	CASE WHEN Sum(Jul) = 0 THEN NULL ELSE Sum(Jul) END AS Jul,
	CASE WHEN Sum(Aug) = 0 THEN NULL ELSE Sum(Aug) END AS Aug,
	CASE WHEN Sum(Sep) = 0 THEN NULL ELSE Sum(Sep) END AS Sep,
	CASE WHEN Sum(Oct) = 0 THEN NULL ELSE Sum(Oct) END AS Oct,
	CASE WHEN Sum(Nov) = 0 THEN NULL ELSE Sum(Nov) END AS Nov,
	CASE WHEN Sum([Dec]) = 0 THEN NULL ELSE Sum([Dec]) END AS [Dec],
	CASE WHEN Sum(Jan) = 0 THEN NULL ELSE Sum(Jan) END AS Jan,
	CASE WHEN Sum(Feb) = 0 THEN NULL ELSE Sum(Feb) END AS Feb,
	CASE WHEN Sum(Mar) = 0 THEN NULL ELSE Sum(Mar) END AS Mar,
	CASE WHEN Sum(Apr) = 0 THEN NULL ELSE Sum(Apr) END AS Apr,
	CASE WHEN Sum(MAy) = 0 THEN NULL ELSE Sum(MAy) END AS MAy,
	CASE WHEN Sum(Jun) = 0 THEN NULL ELSE Sum(Jun) END AS Jun,
	(Sum(Jul)+Sum(Aug)+Sum(Sep)+Sum(Oct)+Sum(Nov)+Sum(Dec)+Sum(Jan)+Sum(Feb)+Sum(Mar) +Sum(Apr) +Sum(May)+Sum(Jun))/ (ISNULL(DATEDIFF(MONTH, @StartDate, @EndDate), 0) + 1) AS Average,
	(Sum(Jul)+Sum(Aug)+Sum(Sep)+Sum(Oct)+Sum(Nov)+Sum(Dec)+Sum(Jan)+Sum(Feb)+Sum(Mar) +Sum(Apr) +Sum(May)+Sum(Jun)) AS Total,
	f.OrganizationName
FROM #DetailedServiceUnitsResult AS S
CROSS JOIN SystemConfigurations f
WHERE Billable = CASE @Billable
	WHEN 0 THEN Billable
	WHEN 1 THEN ''Y''
	WHEN 2 THEN ''N'' END
GROUP BY S.SupervisorName,
	ServiceAreaName,
	ProgramName,
	LocationCode,
	Billable,
	s.staffID,
	S.StaffName,
	ProcedureCodeCatgory,
	ProcedureSubcategory,
	f.OrganizationName
ORDER BY 
	S.SupervisorName,
	ServiceAreaName,
	ProgramName, 
	LocationCode,   
	Billable,
	s.staffID,
	S.StaffName,
	ProcedureCodeCatgory,
	ProcedureSubcategory,
	f.OrganizationName

IF OBJECT_ID(''tempdb..#DetailedServiceUnitStaff'') IS NOT NULL
	DROP TABLE #DetailedServiceUnitStaff 


END

' 
END
GO
