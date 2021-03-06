/****** Object:  StoredProcedure [dbo].[csp_UpdateAppointmentEndTime]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_UpdateAppointmentEndTime]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_UpdateAppointmentEndTime]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_UpdateAppointmentEndTime]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_UpdateAppointmentEndTime]   

AS
/*******************************************************
 Find all Appointments where the end date is the same as
  the start date, and does not match the service end date

9.30.2010 - DJH
*******************************************************/

 
BEGIN TRAN

--Bug Tracking
INSERT into CustomBugTracking (ClientId, ServiceId, Description, CreatedDate)
Select 	s.ClientId, s.ServiceId
	, ''AppointmentId: ''+convert(varchar(20),a.AppointmentId)
	+'' - Corrected Appointment EndTime from ''+CONVERT(varchar(100),a.EndTime)+'' to ''+CONVERT(varchar(100),s.EndDateOfService)
	, GETDATE()
	from Services s with(nolock)
	Join Appointments a with(nolock) on s.ServiceId=a.ServiceId
	Where s.EndDateOfService <> a.EndTime
	and a.StartTime=a.EndTime
	and s.Status = 70
	and ISNULL(s.RecordDeleted,''N'')=''N''
	and ISNULL(a.RecordDeleted,''N'')=''N''

--Correct End Time
	UPDATE a
	SET a.EndTime = s.EndDateOfService
	from Services s with(nolock)
	Join Appointments a with(nolock) on s.ServiceId=a.ServiceId
	Where s.EndDateOfService <> a.EndTime
	and a.StartTime=a.EndTime
	and s.Status = 70
	and ISNULL(s.RecordDeleted,''N'')=''N''
	and ISNULL(a.RecordDeleted,''N'')=''N''

--rollback

COMMIT
' 
END
GO
