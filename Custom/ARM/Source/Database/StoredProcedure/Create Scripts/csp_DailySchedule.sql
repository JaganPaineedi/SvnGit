/****** Object:  StoredProcedure [dbo].[csp_DailySchedule]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DailySchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_DailySchedule]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DailySchedule]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE                PROCEDURE [dbo].[csp_DailySchedule]
@SelectedDate			smalldatetime,
@ReceptionViewId		int,
@Status				varchar(100)
AS

Declare @ServiceStatuses table
(
Status	int
)

insert into @ServiceStatuses
(Status)
select globalCodeId from GlobalCodes where
(@status = ''ScheduledAndShow'' and globalCodeId in(70,71) )
OR
(@status = ''CanceledAndNoShow'' and globalCodeId in (72,73) )
OR
(@status = ''Scheduled'' and globalCodeId in (70) )
OR
(@status = ''All'' and globalCodeId in (70,71,72,73,76,75) )


CREATE TABLE #Results
(
ClientId		int,
ClientName		varchar(100),
[Procedure]		varchar(300),
[DateTime]		smalldatetime,
Status			varchar(20),
Staff			varchar(300),
MedicaidId		varchar(20),
PrimaryCoverage		varchar(50),
SecondaryCoverage	varchar(50)
)
Insert into #Results
(
ClientId,
ClientName,
[Procedure],
[DateTime],
Status,
Staff
)

SELECT
a.clientId as ''ClientId'',
b.LastName +'', ''+b.FirstName as ''ClientName'',
d.displayAs as ''Procedure'',
a.DateOfService AS ''DateTime'',
e.CodeName,
c.firstName + '' '' + c.lastName as ''Staff''
from
services a
join clients b on b.clientId = a.clientId
join staff c on a.clinicianId = c.staffId
join procedureCodes d on a.procedureCodeId = d.procedureCodeId
join globalCodes e on e.globalCodeId = a.status
join @serviceStatuses h on a.status = h.status
where
datediff(day,a.DateOfService,@SelectedDate)=0
AND exists
--Work through the receptionViews
	(select * from ReceptionViews rv
		left Join ReceptionViewLocations rvl on rv.ReceptionViewId = rvl.ReceptionViewId
		left Join ReceptionViewPrograms rvp on rv.ReceptionViewId = rvp.ReceptionViewId
		left Join ReceptionViewStaff rvs on rv.ReceptionViewId = rvs.ReceptionViewId
		where
		rv.ReceptionViewId = @ReceptionViewId
		and 	(rv.AllLocations = ''Y'' Or a.LocationId = rvl.LocationId )
		and	(rv.AllPrograms = ''Y'' Or a.ProgramId = rvp.ProgramId )
		and	(rv.AllStaff = ''Y'' Or a.clinicianId = rvs.StaffId )
	)
and isnull(a.RecordDeleted,''N'') = ''N''
and isnull(b.RecordDeleted,''N'') = ''N''
and isnull(c.RecordDeleted,''N'') = ''N''
and isnull(d.RecordDeleted,''N'') = ''N''
and isnull(e.RecordDeleted,''N'') = ''N''

update a
set PrimaryCoverage = cp1.CoveragePlanName
from #Results a
join ClientCoveragePlans ccp1 on a.clientId = ccp1.clientId
join ClientCoverageHistory ch1 on ccp1.clientCoveragePlanId = ch1.ClientCoveragePlanId
join CoveragePlans cp1 on cp1.coveragePlanId = ccp1.CoveragePlanId
where ch1.COBOrder = 1
and ch1.StartDate <= a.[DateTime] and (ch1.EndDate >= a.[DateTime] or ch1.EndDate is null)

update a
set SecondaryCoverage = cp1.CoveragePlanName
from #Results a
join ClientCoveragePlans ccp1 on a.clientId = ccp1.clientId
join ClientCoverageHistory ch1 on ccp1.clientCoveragePlanId = ch1.ClientCoveragePlanId
join CoveragePlans cp1 on cp1.coveragePlanId = ccp1.CoveragePlanId
where ch1.COBOrder = 2
and ch1.StartDate <= a.[DateTime] and (ch1.EndDate >= a.[DateTime] or ch1.EndDate is null)

--Check for MedVenture coverage IP or OP.  If both exist, get the ID from the OP coverage
update a
set MedicaidId = ccp1.InsuredId
from #Results a
join ClientCoveragePlans ccp1 on a.clientId = ccp1.clientId
join ClientCoverageHistory ch1 on ccp1.clientCoveragePlanId = ch1.ClientCoveragePlanId
join CoveragePlans cp1 on cp1.coveragePlanId = ccp1.CoveragePlanId
where
ch1.StartDate <= a.[DateTime] and (ch1.EndDate >= a.[DateTime] or ch1.EndDate is null)
and cp1.CoveragePlanId in (764,1040)
and not exists
	(select * from clientCoveragePlans ccp2
	join coveragePlans cp2 on ccp2.coveragePlanId = cp2.CoveragePlanId
	where ccp2.ClientCoveragePlanId = ccp1.ClientCoveragePlanId
	and cp2.CoveragePlanId > cp1.CoveragePlanId)

select * From #results
order by [DateTime],Staff
' 
END
GO
