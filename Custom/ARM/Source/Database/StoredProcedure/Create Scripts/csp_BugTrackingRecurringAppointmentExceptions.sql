/****** Object:  StoredProcedure [dbo].[csp_BugTrackingRecurringAppointmentExceptions]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_BugTrackingRecurringAppointmentExceptions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_BugTrackingRecurringAppointmentExceptions]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_BugTrackingRecurringAppointmentExceptions]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_BugTrackingRecurringAppointmentExceptions]

as

insert into RecurringAppointmentExceptions
(RecurringAppointmentId, ExceptionDate, AppointmentDeleted, AppointmentId,
CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)

select ra.RecurringAppointmentId, a.StartTime, ''N'', a.AppointmentId,
''ExceptionFix'', GETDATE(), ''ExceptionFix'', GETDATE()
 from appointments a with (nolock)
join RecurringAppointments ra with(nolock) on ra.RecurringAppointmentId = a.RecurringAppointmentId
where 				(
					dbo.GetTimePart(a.starttime) <> dbo.GetTimePart(ra.starttime)
					or dbo.GetTimePart(a.endtime)<> dbo.GetTimePart(ra.endtime)
					)
and ISNULL(a.RecordDeleted, ''N'')= ''N''
and ISNULL(ra.RecordDeleted, ''N'') =''N''
and Not exists (select * from RecurringAppointmentExceptions e with(nolock)
				where e.AppointmentId = a.AppointmentId
				and ISNULL(e.AppointmentDeleted, ''N'')= ''N''
				and ISNULL(e.RecordDeleted, ''N'')= ''N''
				)

--
--Insert into bug tracking log
--
Insert into CustomBugTracking
(Description, CreatedDate)

Select distinct ''Appointment Exception Record Missing'' + '' - '' + ISNULL(convert(varchar(20), e.AppointmentId), ''''), e.CreatedDate
From RecurringAppointmentExceptions e with(nolock)
Where e.CreatedBy = ''ExceptionFix''
and not exists (select * from CustomBugTracking t with(nolock)
					where t.Description = ''Appointment Exception Record Missing'' + '' - '' + ISNULL(convert(varchar(20), e.AppointmentId), '''')
					and t.CreatedDate = e.CreatedDate
					)

and ISNULL(e.RecordDeleted, ''N'')= ''N''
' 
END
GO
