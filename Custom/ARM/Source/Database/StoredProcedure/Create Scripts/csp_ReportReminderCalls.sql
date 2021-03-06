/****** Object:  StoredProcedure [dbo].[csp_ReportReminderCalls]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportReminderCalls]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportReminderCalls]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportReminderCalls]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE    PROCEDURE [dbo].[csp_ReportReminderCalls]

@ForDatesOfService		datetime,
@ReceptionViewId		int


AS


Select b.FirstName + '' '' +b.LastName as ClientName,
b.ClientId,
e.PhoneNumber,
c.DisplayAs,
convert(varchar,a.DateOfService,100) as DateOfService,
d.FirstName + '' ''+d.LastName as ScheduledStaff,
f.FirstName + '' ''+f.LastName as PrimaryStaff,
--Minor Check added 6/12/2007 avoss
case when isnull(b.DOB, ''1/1/1900'') = ''1/1/1900'' then ''No DOB''
when datediff(dd, b.DOB, getdate()) < 6570 and isnull(b.DOB, ''1/1/1900'') <> ''1/1/1900'' then ''Y''
else ''N''
end as Minor
--End Minor Check
from Services a
join Clients b on a.clientId = b.clientId
join ProcedureCodes c on c.ProcedureCodeId = a.ProcedureCodeId
join Staff d on d.StaffId = a.ClinicianId
left join ClientPhones e on e.clientId = a.clientId and e.PhoneType = 30
left join staff f on b.PrimaryClinicianId = f.staffId
where datediff(day,a.DateOfService,@ForDatesOfService) = 0
and a.Status = 70
and (e.PhoneType = 30 or e.PhoneType is null)
and isnull(a.RecordDeleted,''N'') = ''N''
and isnull(b.RecordDeleted,''N'') = ''N''
and isnull(c.RecordDeleted,''N'') = ''N''
and isnull(d.RecordDeleted,''N'') = ''N''
and isnull(e.RecordDeleted,''N'') = ''N''
and exists
(select * from
ReceptionViews g
join ReceptionViewPrograms h on h.ReceptionViewId = g.ReceptionViewId
where g.ReceptionViewId = @ReceptionViewId
and a.programId = h.programId
)
order by 
datepart(hour,a.DateOfService),datepart(minute,a.DateOfService), d.LastName
' 
END
GO
