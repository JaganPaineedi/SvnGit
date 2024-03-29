/****** Object:  StoredProcedure [dbo].[csp_ReportClinicianSchedule]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClinicianSchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportClinicianSchedule]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClinicianSchedule]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--select * from globalcodes where globalcodeid = 10471
--select * from globalcodes where category = ''receptionstatus''
--Scheduled
--Scheduled and Show
--Canceled and No Show

CREATE                PROCEDURE [dbo].[csp_ReportClinicianSchedule]

@SelectedDate			smalldatetime,
@ReceptionViewId		int,
@Status				varchar(100)
AS
--RJN 09/21/2006 This procedure gets the ''busy'' appointments for each clinician
--for the date specified by the calling process.
Declare @sql	varchar(2000)

CREATE  Table #ServiceStatuses
(
ServiceStatus	int
)

/* RJN 10/02/2006 The reason for using the codeName rather than the code is that no-show and cancel appear to be flipped in the system.)*/
-- TER 04/03/2007 - SmartData is passing the GlobalCodeId now.  Nice of them to tell us (they didn''t).
select @sql = 
''insert into #ServiceStatuses
select GlobalCodeId from GlobalCodes where category = ''+''''''''+''ServiceStatus''+''''''''+
'' and CodeName in (''+CASE WHEN @Status = ''10068'' THEN ''''''''+''Scheduled''+''''''''+'',''+ ''''''''+''Show''+'''''''' 
	WHEN @Status = ''10069'' THEN ''''''''+''Cancel''+''''''''+'','' +''''''''+''No Show''+'''''''' 
	WHEN @Status = ''10067'' THEN ''''''''+''Scheduled''+'''''''' 
	WHEN @Status = ''0'' THEN ''''''''+''Scheduled''+''''''''+'',''+ ''''''''+''Show''+''''''''+'',''+''''''''+''No Show''+''''''''+'','' +''''''''+''Cancel''+''''''''+'','' +''''''''+''Complete''+'''''''' 
	-- default to scheduled and show, just in case this parameter is bad
	ELSE ''''''''+''Scheduled''+''''''''+'',''+ ''''''''+''Show''+'''''''' END +'')''

exec (@sql)

CREATE TABLE #Results
(
StaffId			int,
Staff			varchar(300),
StaffLastName		varchar(300),
[Date]			smalldatetime,
ClientId		int,
ClientOrAssignment	varchar(300),
[Procedure]		varchar(300),
Duration		varchar(300),
LocationName		varchar(300),
ProgramName		varchar(300),
[Time]			smalldatetime
)


Insert into #Results

SELECT
c.staffId AS ''StaffId'',
c.firstName + '' '' + c.lastName as ''Staff'',
c.LastName as ''StaffLastName'',
@SelectedDate AS ''Date'',
d.clientId as ''ClientId'',
case when d.serviceId is null then isnull(a.subject,'''')
else f.lastName +'', ''+f.firstName end as ''ClientOrAssignment'',
e.displayAs as ''Procedure'',
convert(varchar(4),convert(int,d.unit))+'' ''+g.codeName as ''Duration'',
h.locationName as ''LocationName'',
i.programName as ''ProgramName'',
isnull(a.startTime,'''') as ''Time''
from
(
	select ap.ServiceId, ap.subject, ap.startTime, ap.AppointmentType, ap.StaffId, ap.ShowTimeAs, ap.RecordDeleted
	from appointments as ap
	where datediff(day,isnull(ap.startTime,getdate()),@SelectedDate)=0 and ap.ServiceId is null
	union
	select sv.ServiceId, null, sv.DateOfService, 4761, sv.ClinicianId, 4342, sv.RecordDeleted
	from Services as sv
	where datediff(day, sv.DateOfService, @SelectedDate) = 0
) as a
left join globalCodes b on a.appointmentType = b.globalcodeId
left join staff c on a.staffId = c.staffId
left join services d on a.serviceId = d.serviceId and isnull(d.RecordDeleted,''N'') <> ''Y''
left join procedureCodes e on d.procedureCodeId = e.procedureCodeId
left join clients f on d.clientId = f.clientId
left join globalCodes g on d.unitType = g.globalCodeId and g.category = ''unitType''
left join locations h on d.locationId = h.locationId
left join programs i on d.programId = i.programId
where
--For now use showTimeAs 4342 until the application sends the status parameter
isnull(a.showTimeAs,4342) = 4342
and datediff(day,isnull(a.startTime,getdate()),@SelectedDate)=0
and isnull(c.active,''N'') = ''Y''
and isnull(c.clinician,''N'') = ''Y''
and isnull(a.RecordDeleted,''N'') <> ''Y''
AND
(
	-- Limit to services/appts for staff belonging to the reception view
	exists (
		select * from ReceptionViews as rv
		where rv.ReceptionViewId = @ReceptionViewId
		and isnull(rv.AllStaff, ''N'') = ''Y''
	)
	or
	exists(
		select * from ReceptionViewStaff a2 where
		a2.ReceptionViewId = @ReceptionViewId
		and isnull(c.StaffId,'''') = CASE WHEN @ReceptionViewId = 1 THEN c.StaffId ELSE a2.staffId END
		and isnull(a2.recorddeleted, ''N'') = ''N''
	)
)
and
(
	-- Limit to services/appts for locations belonging to the reception view
	exists (
		select * from ReceptionViews as rv
		where rv.ReceptionViewId = @ReceptionViewId
		and isnull(rv.AllLocations, ''N'') = ''Y''
	)
	or
	exists(
		select * from ReceptionViewLocations a2 where
		a2.ReceptionViewId = @ReceptionViewId
		and (
			(h.LocationId is null)
			or (a2.LocationId = h.LocationId)
		)
		and isnull(a2.recorddeleted, ''N'') = ''N''
	)
)
and
(
	-- Limit to services/appts for programs belonging to the reception view
	exists (
		select * from ReceptionViews as rv
		where rv.ReceptionViewId = @ReceptionViewId
		and isnull(rv.AllPrograms, ''N'') = ''Y''
	)
	or
	exists(
		select * from ReceptionViewPrograms a2 where
		a2.ReceptionViewId = @ReceptionViewId
		and (
			(i.ProgramId is null)
			or (a2.ProgramId = i.ProgramId)
		)
		and isnull(a2.recorddeleted, ''N'') = ''N''
	)
)
and
(	 exists
	(
	select * from #ServiceStatuses a3
	where isnull(d.status,'''') = CASE WHEN @Status = ''0'' THEN isnull(d.status,'''') else a3.ServiceStatus end
	)
	OR
	d.serviceId is null
)

if @receptionViewId <> 1
Begin
insert into #results
(staffId,
Staff,
StaffLastName
)
select a.staffId,a.firstName +'' ''+a.LastName,a.LastName from staff a
where not exists
(
	select * from #Results b where a.StaffId = b.StaffId
)
and exists
(
	select * from receptionViewStaff c where c.receptionViewId = @receptionViewId
	and c.staffId = a.staffId
	and isnull(c.recorddeleted, ''N'') = ''N''
)
and a.clinician = ''Y'' and a.active = ''Y'' and isnull(a.RecordDeleted,''N'') <> ''Y''
End
else
begin	
insert into #results
(staffId,
Staff,
StaffLastName
)
select a.staffId,a.firstName +'' ''+a.LastName,a.LastName from staff a
where not exists
(
	select * from #Results b where a.StaffId = b.StaffId
)
and a.clinician = ''Y'' and a.active = ''Y'' and isnull(a.RecordDeleted,''N'') <> ''Y''
END

--Remove non-clinician clinicians
/*Delete from #results where staffId in (92)*/

select *From #results
order by StaffLastName
' 
END
GO
