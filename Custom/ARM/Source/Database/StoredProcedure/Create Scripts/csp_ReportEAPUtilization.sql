/****** Object:  StoredProcedure [dbo].[csp_ReportEAPUtilization]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportEAPUtilization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportEAPUtilization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportEAPUtilization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



create procedure [dbo].[csp_ReportEAPUtilization]
--
-- EAP Utilization Report
-- History:
--	2012.07.22 - T. Remisoski - created/installed.
--  2013.03.07 - D. Veale - modified date range calculation for quarterly mode
	@StartDate datetime,
	@EndDate datetime,
	@IncludeInactiveCompanies char(1) = ''N'',
	@CompanyId int = null,
	@QuarterlyReport char(1) = ''N''
as
/*--set transaction isolation level read uncommitted
--select @StartDate = ''1/1/2011'', @EndDate = ''12/31/2011'', @CompanyId = 13
--declare 
--	@StartDate datetime, 
--	@EndDate datetime

exec csp_ReportEAPUtilization ''2/1/2013'', ''02/28/2013'', ''N'', 82, ''N''
*/

declare @ContractStartDate datetime
declare @statusTreatmentComplete int
select @statusTreatmentComplete = GlobalCodeId from GlobalCodes where Category = ''XEAPDISCHARGESTATUS'' and ExternalCode1 = ''AAR'' and ISNULL(RecordDeleted, ''N'') <> ''Y''

declare @tabEAPPrograms table (
	CompanyName varchar(100),
	NumberOfEmployees int,
	ProgramId int,
	ContractStartMonth int,
	ContractStartYear int,
	ContractStartDate datetime,
	ReportingStatus char(1),
	CloseDate datetime
)



--
--Establish list of included programs
insert into @tabEAPPrograms 
        (
		CompanyName,
		NumberOfEmployees,
         ProgramId,
         ContractStartMonth,
         ContractStartYear,
         ContractStartDate,
         --ReportingStatus,
         CloseDate
        )
select p.ProgramName, ISNULL(p.Capacity, 0), p.ProgramId, DATEPART(MONTH, pah.StartDate), DATEPART(YEAR, pah.StartDate), pah.StartDate, pah.EndDate
from dbo.Programs as p
join dbo.ProgramAvailabilityHistory as pah on pah.ProgramId = p.ProgramId
	and DATEDIFF(day, pah.StartDate, @EndDate) >= 0
	and (isnull(pah.RecordDeleted, ''N'') <> ''Y'')
where
	ServiceAreaId = 2	-- TER - 2013.02.27 - restrict to EAP Service area
	and	(@IncludeInactiveCompanies = ''Y'' or p.Active = ''Y'')
	and (@CompanyId is null or p.ProgramId = @CompanyId)

-- if it''s a quarterly report, just include companies having quarters that end in dates matching the end date
if @QuarterlyReport = ''Y''
begin
		delete from @tabEAPPrograms where ((DATEDIFF(MONTH, ContractStartDate, @EndDate) + 1) % 3) <> 0 
		
	--Set all contract start dates to current or previous year, whichever predates the @EndDate
		update @tabEAPPrograms 
		set ContractStartDate = CASE 
									When CAST(CAST(ContractStartMonth as varchar) + ''/1/'' + CAST(DATEPART(YEAR, @EndDate) as varchar) as datetime) >= @EndDate
										THEN CAST(CAST(ContractStartMonth as varchar) + ''/1/'' + CAST(DATEPART(YEAR, @EndDate)-1 as varchar) as datetime)
									When CAST(CAST(ContractStartMonth as varchar) + ''/1/'' + CAST(DATEPART(YEAR, @EndDate) as varchar) as datetime) < @EndDate
										THEN CAST(CAST(ContractStartMonth as varchar) + ''/1/'' + CAST(DATEPART(YEAR, @EndDate) as varchar) as datetime)
								END
	--Reset all contract start years to reflect adjusted ContractStartDate
		update @tabEAPPrograms 
		set ContractStartYear = DATEPART(YEAR, ContractStartDate)	
		
	--Delete any records with a closedate before the newly calculated ContractStartDate							
		Delete from @tabEAPPrograms
		Where 	(DATEDIFF(DAY, CloseDate, ContractStartDate) >= 0)					
END

--If not running in Quarterly mode, then delete any records where the closedate is before the @StartDate parameter value
	if @QuarterlyReport = ''N''
	begin
			Delete from @tabEAPPrograms
			Where 	(DATEDIFF(DAY, CloseDate, @StartDate) >= 0)	
	end


--return
declare @tabReportSections table (
	SectionName varchar(1000),
	HideIfNoData char(1),
	SortOrder int,
	HasSubSections char(1),
	DisplayType char(1) -- (H)ours/(V)isits,(P)ercent
)

insert into @tabReportSections
        (
         SectionName,
         HideIfNoData,
         SortOrder,
         HasSubSections,
         DisplayType	-- V = Visits, H = Hours, E = Employee Count, P = Percentage utilization
        )
values  
	(''New Visits'', ''N'', 1, ''Y'', ''V''),
	(''Subsequent Visits'', ''N'', 2, ''Y'', ''V''),
	(''Wellness Subsequent Visits'', ''Y'', 3, ''N'', ''V''),
	(''Total Visits'', ''N'', 4, ''Y'', ''V''),
	(''After Hours Response Time'', ''Y'', 5, ''N'', ''V''),
	(''Care Follow-Up'', ''Y'', 6, ''N'', ''V''),
	(''Complimentary Hours'', ''Y'', 7, ''N'', ''H''),
	(''Consulting Hours'', ''Y'', 8, ''N'', ''H''),
	(''Training'', ''Y'', 9, ''N'', ''V''),
	(''Disposition Cases'', ''Y'', 10, ''Y'', ''V''),
	(''Current Employee Count'', ''N'', 11, ''N'', ''E''),
	(''Utilization Rates'', ''N'', 12, ''Y'', ''P''),
	(''Case Management Hours'', ''Y'', 13, ''N'', ''H''),
	(''Critical Incident Reponses'', ''Y'', 14, ''N'', ''V'')


declare @tabReportProcedures table (
	ProcedureCodeId int not null,
	SectionName varchar(1000) not null,
	IsAllServiceCode char(1),
	CountNoShows char(1),
	isMandatoryReferralCode char(1),	-- y/n
	primary key (ProcedureCodeId, SectionName)
)

insert into @tabReportProcedures
        (
         ProcedureCodeId,
         SectionName,
         IsAllServiceCode,
         CountNoShows,
         isMandatoryReferralCode
        )
values  
		 (15,''After Hours Response Time'',''Y'',''N'',''N'')
		,(57,''Complimentary Hours'',''Y'',''N'',''N'')
		,(59,''Consulting Hours'',''Y'',''N'',''N'')
		,(65,''Subsequent Visits'',''Y'',''N'',''N'')
		,(65,''Total Visits'',''Y'',''N'',''N'')
		,(66,''New Visits'',''Y'',''N'',''N'')
		,(66,''Total Visits'',''Y'',''N'',''N'')
		,(68,''Training'',''Y'',''N'',''Y'')
		,(255,''Care Follow-Up'',''Y'',''N'',''N'')
		,(256,''New Visits'',''Y'',''N'',''N'')
		,(256,''Total Visits'',''Y'',''N'',''N'')
		,(258,''New Visits'',''Y'',''N'',''N'')
		,(258,''Total Visits'',''Y'',''N'',''N'')
		,(259,''Care Follow-Up'',''Y'',''N'',''N'')
		,(260,''Subsequent Visits'',''Y'',''Y'',''N'')
		,(260,''Total Visits'',''Y'',''Y'',''N'')
		,(261,''Critical Incident Reponses'',''N'',''N'',''N'')
		,(263,''Subsequent Visits'',''Y'',''N'',''N'')
		,(265,''Complimentary Hours'',''Y'',''N'',''N'')
		,(267,''Total Visits'',''Y'',''N'',''Y'')
		,(267,''New Visits'',''Y'',''N'',''Y'')
		,(268,''Subsequent Visits'',''Y'',''Y'',''N'')
		,(269,''New Visits'',''Y'',''N'',''N'')
		,(269,''Total Visits'',''Y'',''N'',''N'')
		,(270,''Subsequent Visits'',''Y'',''Y'',''N'')
		,(270,''Total Visits'',''Y'',''Y'',''N'')
		,(304,''Subsequent Visits'',''Y'',''N'',''Y'')
		,(328,''Consulting Hours'',''N'',''N'',''N'')
		,(393,''Subsequent Visits'',''Y'',''N'',''Y'')
		,(448,''Subsequent Visits'',''Y'',''N'',''N'')
		,(479,''Subsequent Visits'',''Y'',''N'',''Y'')
		,(490,''Wellness Subsequent Visits'',''Y'',''N'',''N'')
		,(537,''Subsequent Visits'',''Y'',''N'',''N'')
		,(616,''Subsequent Visits'',''Y'',''N'',''N'')
		,(617,''New Visits'',''Y'',''N'',''N'')
		,(617,''Total Visits'',''Y'',''N'',''N'')
		,(618,''Wellness Subsequent Visits'',''Y'',''N'',''N'')
		,(621,''New Visits'',''Y'',''N'',''N'')
		,(621,''Total Visits'',''Y'',''N'',''N'')
		,(622,''Subsequent Visits'',''Y'',''N'',''N'')
		,(622,''Total Visits'',''Y'',''N'',''N'')
		,(645,''Wellness Subsequent Visits'',''Y'',''N'',''N'')
		,(726,''Subsequent Visits'',''Y'',''N'',''N'')
		,(727,''Subsequent Visits'',''Y'',''N'',''N'')


	--select pg.Programid, pg.ProgramCode, COUNT(*)
	--from dbo.Services as s
	--join dbo.Programs as pg on pg.ProgramId = s.ProgramId
	--join dbo.ProcedureCodes as pc on pc.ProcedureCodeId = s.ProcedureCodeId
	--join (
	--	select distinct ProcedureCodeId, CountNoShows
	--	from @tabReportProcedures
	--) as rp on rp.ProcedureCodeId = s.ProcedureCodeId
	--where DATEDIFF(DAY, s.DateOfService, @StartDate) <= 0
	--and DATEDIFF(DAY, s.DateOfService, @EndDate) >= 0
	--and ((s.Status in (71, 75)) or (rp.CountNoShows = ''Y'' and s.Status = 72))
	--group by pg.programid, pg.ProgramCode
	--order by 3 desc

--OUTPUT QUERY, SECTION 1 OF 4 (runs all sections except disposition, utilization, employee count)
select  rs.SectionName,
        rs.HideIfNoData,
        rs.SortOrder,
        rs.DisplayType,
        rs.HasSubSections,
        trp.ProcedureCodeId,
        trp.IsAllServiceCode,
        trp.CountNoShows,
        trp.isMandatoryReferralCode,
        sv.ServiceId,
        sv.DateOfService,
        sv.ClientId,
        sv.Unit,
        sv.UnitType,
        sv.Status,
        sv.HoursProvided,
        tep.CompanyName,
        tep.ProgramId,
        tep.ContractStartMonth,
        tep.ContractStartYear,
        tep.ContractStartDate,
        tep.ReportingStatus,
        tep.CloseDate,
        tep.NumberOfEmployees,
        case 
			when trp.isMandatoryReferralCode = ''Y'' then ''Mandatory Referral'' 
			when exists (
				select *
				from dbo.ClientCoveragePlans as ccp
				join dbo.CoveragePlans as cp on cp.CoveragePlanId = ccp.CoveragePlanId
				where ccp.ClientId = sv.ClientId
				and ISNULL(ccp.ClientIsSubscriber, ''N'') <> ''Y''	-- if client is not the subscriber, then consider them a dependent.
				and ISNULL(ccp.RecordDeleted, ''N'') <> ''Y''
				and ISNULL(cp.RecordDeleted, ''N'') <> ''Y''
				) then ''Dependent'' 
			else ''Employee''
		end as SubSection,
        case 
			when trp.isMandatoryReferralCode = ''Y'' then 3
			when exists (
				select *
				from dbo.ClientCoveragePlans as ccp
				join dbo.CoveragePlans as cp on cp.CoveragePlanId = ccp.CoveragePlanId
				where ccp.ClientId = sv.ClientId
				and ISNULL(ccp.ClientIsSubscriber, ''N'') <> ''Y''	-- if client is not the subscriber, then consider them a dependent.
				and ISNULL(ccp.RecordDeleted, ''N'') <> ''Y''
				and ISNULL(cp.RecordDeleted, ''N'') <> ''Y''
				) then 2 
			else 1
		end as SubSectionOrder

from    @tabReportSections as rs
join    @tabReportProcedures as trp on trp.SectionName = rs.SectionName
cross join @tabEAPPrograms as tep
left join (
           select   s.ServiceId,
                    s.ProgramId,
                    s.ProcedureCodeId,
                    s.ClientId,
                    s.Unit,
                    s.UnitType,
                    s.Status,
                    s.DateOfService,
                    (s.Unit / CAST(CASE s.UnitType
                                     when 110 then 60.0
                                     when 111 then 1.0
                                     when 112 then 1.0 / 24.0
                                   end as decimal)) as HoursProvided
           from     dbo.Services as s
           join @tabEAPPrograms as tep2 on tep2.ProgramId = s.ProgramId
           join     dbo.ProcedureCodes as pc on pc.ProcedureCodeId = s.ProcedureCodeId
           join     (
                     select distinct
                            ProcedureCodeId,
                            CountNoShows
                     from   @tabReportProcedures
                    ) as rp on rp.ProcedureCodeId = s.ProcedureCodeId
           where    (
                     (s.Status in (71, 75))
                     or (
                         rp.CountNoShows = ''Y''
                         and s.Status = 72
                        )
                    )
                    and ISNULL(s.RecordDeleted, ''N'') <> ''Y''
          ) as sv on sv.ProcedureCodeId = trp.ProcedureCodeId
                     and sv.ProgramId = tep.ProgramId
                     and (@QuarterlyReport = ''Y'' OR DATEDIFF(DAY, sv.DateOfService, @StartDate) <= 0)
                     and DATEDIFF(DAY, sv.DateOfService, @EndDate) >= 0
                     and DATEDIFF(DAY, sv.DateOfService, tep.ContractStartDate) <= 0
                     and (
                          (tep.CloseDate is null)
                          or (DATEDIFF(DAY, sv.DateOfService, tep.CloseDate) >= 0)
                         )
union all
	--DISPOSITION CASES (2)
	select  rs.SectionName,
			rs.HideIfNoData,
			rs.SortOrder,
			rs.DisplayType,
			rs.HasSubSections,
			null as ProcedureCodeId,
			null as IsAllServiceCode,
			null as CountNoShows,
			null as isMandatoryReferralCode,
			sv.ClientId as ServiceId,
			null as DateOfService,
			sv.ClientId,
			null as Unit,
			null as UnitType,
			null as Status,
			null as HoursProvided,
			tep.CompanyName,
			tep.ProgramId,
			tep.ContractStartMonth,
			tep.ContractStartYear,
			tep.ContractStartDate,
			tep.ReportingStatus,
			tep.CloseDate,
			tep.NumberOfEmployees,
			sv.SubSection,
			case when sv.SubSection = ''Referred'' then 1 else 2 end as SubSectionOrder
	from    @tabReportSections as rs
	cross join @tabEAPPrograms as tep
	join (
		select cp.ProgramId, cp.ClientId, case when cc.EAPDischargeStatus <> @statusTreatmentComplete then ''Referred'' else ''Treatment Complete'' end as SubSection
		from ClientPrograms as cp
		join dbo.Programs as p on p.ProgramId = cp.ProgramId
		join CustomClients as cc on cc.ClientId = cp.ClientId
		join @tabEAPPrograms as INNRtep on INNRtep.ProgramId = p.ProgramId
		where 
		--p.ServiceAreaId = 2 -- EAP 
		--and 
		(@QuarterlyReport = ''Y'' OR (DATEDIFF(DAY, cc.EAPDischargeDate, @StartDate) <= 0))
		AND DATEDIFF(DAY, cc.EAPDischargeDate, INNRtep.ContractStartDate) <= 0
		and DATEDIFF(DAY, cc.EAPDischargeDate, @EndDate) >= 0
		and ISNULL(cc.RecordDeleted, ''N'') <> ''Y''
		and ISNULL(cp.RecordDeleted, ''N'') <> ''Y''
		and not exists (
			select *
			from ClientPrograms as cp2
			join dbo.Programs as p2 on p2.ProgramId = cp2.ProgramId
			where cp2.ClientId = cp.ClientId
			--and p2.ServiceAreaId = p.ServiceAreaId
			and ((cp2.EnrolledDate > cp.EnrolledDate)
				or ((cp2.EnrolledDate = cp.EnrolledDate and cp2.ClientProgramId > cp.ClientProgramId))
				or (cp2.EnrolledDate is not null and cp.EnrolledDate is null)
			)
		)
	) as sv on sv.ProgramId = tep.ProgramId
	where rs.SectionName = ''Disposition Cases''

union all
	--Utilization Rates (3)
	select  rs.SectionName,
			rs.HideIfNoData,
			rs.SortOrder,
			rs.DisplayType,
			rs.HasSubSections,
			null as ProcedureCodeId,
			null as IsAllServiceCode,
			null as CountNoShows,
			null as isMandatoryReferralCode,
			sv.ProgramId as ServiceId,
			null as DateOfService,
			null as ClientId,
			null as Unit,
			null as UnitType,
			null as Status,
			CAST(sv.ClientsServed as decimal(10,2)) as HoursProvided,
			tep.CompanyName,
			tep.ProgramId,
			tep.ContractStartMonth,
			tep.ContractStartYear,
			tep.ContractStartDate,
			tep.ReportingStatus,
			tep.CloseDate,
			tep.NumberOfEmployees,
			sv.SubSection as SubSection,
			case 
				when sv.SubSection = ''New Visits Only'' then 1
				when sv.SubSection = ''New and Subsequent Visits'' then 2
				when sv.SubSection = ''All Services'' then 3
			end as SubSectionOrder
	from    @tabReportSections as rs
	cross join @tabEAPPrograms as tep
	LEFT join (
	   select   s.ProgramId, tep2.ContractStartDate, COUNT(*) as ClientsServed, rpSection.SubSection
	   from     dbo.Services as s
	   join @tabEAPPrograms as tep2 on tep2.ProgramId = s.ProgramId
	   join     dbo.ProcedureCodes as pc on pc.ProcedureCodeId = s.ProcedureCodeId
	   join (
			select ''New Visits Only'' as SubSection, ProcedureCodeId
			from @tabReportProcedures
			where SectionName = ''New Visits''
			union
			select ''New and Subsequent Visits'' as SubSection, ProcedureCodeId
			from @tabReportProcedures
			where SectionName in (''New Visits'', ''Subsequent Visits'')
			union
			select distinct ''All Services'' as SubSection, ProcedureCodeId
			from @tabReportProcedures
			where IsAllServiceCode = ''Y''
		) as rpSection on rpSection.ProcedureCodeId = pc.ProcedureCodeId
	   join     (
				 select distinct
						ProcedureCodeId,
						CountNoShows
				 from   @tabReportProcedures
				) as rp on rp.ProcedureCodeId = s.ProcedureCodeId
	   where    (
				 (s.Status in (71, 75))
				 or (
					 rp.CountNoShows = ''Y''
					 and s.Status = 72
					)
				)
				and ISNULL(s.RecordDeleted, ''N'') <> ''Y''
				and (@QuarterlyReport = ''Y'' OR DATEDIFF(DAY, s.DateOfService, @StartDate) <= 0)
				and DATEDIFF(DAY, s.DateOfService, @EndDate) >= 0
				and DATEDIFF(DAY, s.DateOfService, tep2.ContractStartDate) <= 0  
				and (
					  (tep2.CloseDate is null)
					  or (DATEDIFF(DAY, s.DateOfService, tep2.CloseDate) >= 0)
				 )
		group by s.ProgramId, tep2.ContractStartDate, rpSection.SubSection
	) as sv on sv.ProgramId = tep.ProgramId and sv.ContractStartDate = tep.ContractStartDate
	where rs.SectionName = ''Utilization Rates''
	and ISNULL(tep.NumberOfEmployees, 0) > 0

union all
	--Current Employee Count (4)
	select  rs.SectionName,
			rs.HideIfNoData,
			rs.SortOrder,
			rs.DisplayType,
			rs.HasSubSections,
			null as ProcedureCodeId,
			null as IsAllServiceCode,
			null as CountNoShows,
			null as isMandatoryReferralCode,
			null as ServiceId,
			null as DateOfService,
			null as ClientId,
			null as Unit,
			null as UnitType,
			null as Status,
			null as HoursProvided,
			tep.CompanyName,
			tep.ProgramId,
			tep.ContractStartMonth,
			tep.ContractStartYear,
			tep.ContractStartDate,
			tep.ReportingStatus,
			tep.CloseDate,
			tep.NumberOfEmployees,
			null as SubSection,
			1 as SubSectionOrder
	from    @tabReportSections as rs
	cross join @tabEAPPrograms as tep
	where rs.SectionName = ''Current Employee Count''
	order by CompanyName,
			SortOrder,
			SubSectionOrder,
			DateOfService

' 
END
GO
