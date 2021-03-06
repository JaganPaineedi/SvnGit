/****** Object:  StoredProcedure [dbo].[csp_Report_unitOfServiceSummaryByOrganization]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_unitOfServiceSummaryByOrganization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_unitOfServiceSummaryByOrganization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_unitOfServiceSummaryByOrganization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*********************************************************************/
/* Stored Procedure: csp_Summary_unit_of_Service                            */
/* Creation Date:    6/12/2012                                      */
/* Copyright:                                                         */
/*                                                                   */
/* Purpose: Units of Service Report                                  */
/*                                                                   */
/* Input Parameters: @StartDate @EndDate,@Repotvalue,@ReportType	
/* @Billable    A													 */
/*	               													 */
/*																	 */
/* Output Parameters:                                                */
/*                                                                   */
/* Return Status:  0=success                                         */
/*                                                                   */
/* Called By:  Crystal units of service Summary						 */
/*                                                                   */
/* Calls: 															 */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*Code for Value UnitType :											 */
			--110 Minute --113 Items  --111 Hours                    */
			--110 Minutes --112 Days								 */
/*																	 */
/*********************************************************************/


CREATE proc [dbo].[csp_Report_unitOfServiceSummaryByOrganization]
	@StartDate	AS datetime,
	@EndDate	AS datetime,
	@Billable	AS int,  -- 0 Means All, 1 Billable, 2 Not Billable
	@ServiceArea	AS int = 0, -- 0 Means don''t group by, 1 means group by
	@Program		AS int = 0, -- 0 Means don''t group by, 1 means group by 
	@Location		AS int = 0  -- 0 Means don''t group by, 1 means group by
AS
BEGIN

SET @ServiceArea = COALESCE(@ServiceArea,0)
SET @Program = COALESCE(@Program,0)
SET @Location = COALESCE(@Location,0)

IF OBJECT_ID(''tempdb..#SummaryServiceUnitList'') is not null
drop table #SummaryServiceUnitList

SELECT 
	S.ServiceID,
	s.DateOfService,
	S.ProcedureCodeID,
	ClinicianID,
	Billable = case when C.ProcedureCategory is not null then ''Y'' else ''N'' end,
	ClientID,
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
			or PC.DisplayAs  = ''SA_GROUPCN'' or pc.DisplayAs = ''CBA_GROUP'') THEN CONVERT(FLOAT,(unit/60))/3 
		WHEN S.UnitType =110 and PC.DisplayAs = ''EDUC_CLASS''        THEN CONVERT(FLOAT,Unit)/60/6   
		WHEN S.UnitType =111 or S.UnitType=112 or S.UnitType=113     THEN CONVERT(FLOAT,Unit) /60 
	END AS Duration_units,
	S.GroupServiceID AS GroupServiceID,
	CASE WHEN s.Status in (75) then ''Completed'' when s.status in (71) then ''Pending'' Else ''Not Completed'' end As ServiceStatus,
	CASE WHEN s.Status in (75) then  1 when s.Status in (71) then 2 Else 0 End As  ServiceStatusID,
	CASE WHEN @ServiceArea = 0	THEN ''ALL'' ELSE ServiceAreaName END AS ServiceAreaName,
	CASE WHEN @Program = 0		THEN ''ALL'' ELSE ProgramName     END AS ProgramName,
	CASE WHEN @Location = 0		THEN ''ALL'' ELSE LocationCode    END AS LocationName,
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
INTO #SummaryServiceUnitList
FROM Services S
JOIN Programs P ON P.ProgramId = S.ProgramId
JOIN ServiceAreas SA ON SA.ServiceAreaId = P.ServiceAreaId
JOIN Locations L ON L.LocationId = S.LocationId
JOIN ProcedureCodes PC ON S.ProcedureCodeID = PC.ProcedureCodeID
LEFT JOIN CustomUnitsOfServiceProcedureCategories C ON c.ProcedureCodeId = PC.ProcedureCodeId and ISNULL(c.RecordDeleted, ''N'') <> ''Y''
WHERE ISNULL(S.RecordDeleted,''N'')<>''Y''
	AND S.[Status] IN (71, -- Show
		75, --Completed
		72, -- No show
		73 -- cancel
		)-- Completed Status
	and DATEDIFF(DAY,DateOfService, @EndDate) >= 0
	And DATEDIFF(DAY,DateofService, @StartDate) <= 0
	--AND ISNULL(P.RecordDeleted,''N'')<>''Y''
	--AND ISNULL(PC.RecordDeleted,''N'')<>''Y''
                          
-- SmartCare Group Services
UPDATE S SET 
	S.num_co_therapists = GrpService.num_co_therapists
FROM #SummaryServiceUnitList AS S
JOIN (  
	SELECT GroupServiceID,count(distinct StaffId)AS num_co_therapists 
	FROM GroupServiceStaff cts   with (nolock)
	WHERE GroupServiceID in (
		SELECT GroupServiceID FROM #SummaryServiceUnitList
		WHERE GroupServiceID IS Not Null
		)
	GROUP BY GroupServiceID 
	) AS GrpService ON GrpService.GroupServiceID=s.GroupServiceID
	where S.isGroupService = ''Y''

-- PsychConsult groups
update s set
	num_co_therapists = grp.numClinicians
from #SummaryServiceUnitList as s
join (
	select s.ServiceId, COUNT(distinct ss.StaffId) as numClinicians
	from dbo.Services as S
	join dbo.ProcedureCodes as PC on PC.ProcedureCodeId = S.ProcedureCodeId
	join dbo.CustomLegacyServiceStaff as ss on ss.ServiceId = s.ServiceId
	where S.UnitType=110 
	and (
		PC.DisplayAs = ''GROUP_CN''
		or PC.DisplayAs =''CSP_GROUP''
		or PC.DisplayAs  = ''SA_IOP''
		or PC.DisplayAs  = ''SA_GROUPCN''
		or PC.DisplayAs = ''CBA_GROUP''
	)
	group by s.ServiceId
) as grp on grp.ServiceId = s.ServiceId
where s.isGroupService = ''Y''
and s.num_co_therapists is null

update #SummaryServiceUnitList set num_co_therapists = 1 where ((num_co_therapists is null) or (num_co_therapists = 0))

update #SummaryServiceUnitList set Duration_units = Duration_units / CAST(num_co_therapists as float)



IF OBJECT_ID(''tempdb..#SummaryServiceUnitsResult'') is not null
	drop table #SummaryServiceUnitsResult 

select
	SUM(Case when ServiceStatusID=2 then s.Duration_units Else 0 end)			AS UnitsPending,
	SUM(Case when ServiceStatusID=1 then s.Duration_units Else 0 end) AS UnitsCompleted,
	sum(Case when ServiceStatusID=0 then s.Duration_units Else 0 end)  AS UnitsNotCompleted,
	SUM(Case when ServiceStatusID=2 then  1  Else 0 end) 	AS VisitsPending,
	sum(Case when ServiceStatusID=1 then  1  Else 0 end) AS VisitsCompleted,
	sum(Case when ServiceStatusID=0 then  1  Else 0 end) AS VisitsNotCompleted,
	ISNULL(CodeName, ''Other'')  AS ProcedureCodeCatgory,	COUNT(distinct s.ClientId) as DistinctClients,	S.ServiceAreaName,	S.ProgramName,	S.LocationName,	Billable,	MAX(sac.Clients) as ServiceAreaClients,	MAX(pgc.Clients) as ProgramClients,	MAX(lc.Clients) as LocationClients,	MAX(dc.Clients) as ClientsINTO  #SummaryServiceUnitsResultFROM  #SummaryServiceUnitList Sleft Join ( 	Select CodeName,ProcedureCodeID	from CustomUnitsOfServiceProcedureCategories  AS P 	inner join GlobalCodes on ProcedureCategory = GlobalCodeID) AS Cat On S.ProcedureCodeId=Cat.ProcedureCodeID	LEFT join (		select ServiceAreaName, COUNT(distinct ClientId) as Clients		from #SummaryServiceUnitList		group by ServiceAreaName	) as sac on sac.ServiceAreaName = S.ServiceAreaName	LEFT join (		select ProgramName, COUNT(distinct ClientId) as Clients		from #SummaryServiceUnitList		group by ProgramName	) as pgc on pgc.ProgramName = S.ProgramName	LEFT join (		select LocationName, COUNT(distinct ClientId) as Clients		from #SummaryServiceUnitList		group by LocationName	) as lc on lc.LocationName = S.LocationName	cross join (		select COUNT(distinct ClientId) as Clients		from #SummaryServiceUnitList	) as dcGroup by 	S.ServiceAreaName,	S.ProgramName,	S.LocationName,	S.Billable,	Cat.CodeName
SELECT 
	SUM(s.UnitsPending) as UnitsPending,
	Sum(S.UnitsCompleted) AS UnitsCompleted,
	Sum(S.UnitsNotCompleted) AS UnitsNotCompleted,
	SUM(s.VisitsPending) as VisitsPending,
	Sum(S.VisitsCompleted) AS VisitsCompleted,
	Sum(S.VisitsNotCompleted) AS VisitsNotCompleted,
	ServiceAreaName,
	ProgramName,
	LocationName,
	Billable,
	F.OrganizationName,
	S.ProcedureCodeCatgory,
	S.DistinctClients,
	S.ServiceAreaClients,
	S.ProgramClients,
	S.LocationClients,
	S.Clients
FROM  #SummaryServiceUnitsResult SCROSS JOIN SystemConfigurations fWHERE Billable = CASE @Billable
	WHEN 0 THEN Billable
	WHEN 1 THEN ''Y''
	WHEN 2 THEN ''N'' END
GROUP BY
	f.OrganizationName,
	ServiceAreaName,
	ProgramName,
	LocationName,
	Billable,
	s.ProcedureCodeCatgory,
	S.DistinctClients,
	S.ServiceAreaClients,
	S.ProgramClients,
	S.LocationClients,
	S.Clients
ORDER BY ServiceAreaName, ProgramName, LocationName, S.ProcedureCodeCatgory
IF OBJECT_ID(''tempdb..#SummaryServiceUnitList'') is not null
	drop table #SummaryServiceUnitList			

IF OBJECT_ID(''tempdb..#SummaryServiceUnitstResult'') is not null
	drop table #SummaryServiceUnitstResult 

END
' 
END
GO
