/****** Object:  StoredProcedure [dbo].[csp_UpdateAppointmentClientName]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_UpdateAppointmentClientName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_UpdateAppointmentClientName]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_UpdateAppointmentClientName]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_UpdateAppointmentClientName]   

AS
/*******************************************************
 Find all Appointments where the client name does not match
  the client id on the service

10.2.2010 - DJH
*******************************************************/

Create Table #AppointmentBug (
	AppointmentId int, ServiceId int, ClientId int, ClientName varchar(200)
	, ApptClientId int, ApptClientName varchar(200), Subject varchar(max), ProcedureCodeName varchar(200)
	)

Insert into #AppointmentBug
Select 
	a.AppointmentId, s.ServiceId, s.ClientId as ClientId, c.LastName+'', ''+c.FirstName as ClientName
	, SUBSTRING(Subject
		,CHARINDEX(''(#'',a.Subject)+Case When CHARINDEX(''(#'',a.Subject)=0 Then 0 Else 2 End 							--Client Id First Char
		,CHARINDEX('')'',RIGHT(a.Subject, LEN(a.Subject)-CHARINDEX(''(#'',a.Subject)))
			-Case When CHARINDEX('')'',RIGHT(a.Subject, LEN(a.Subject)-CHARINDEX(''(#'',a.Subject)))=0 Then 0 Else 2 End	--Client Id Last Char
		) as ApptClientId
	, SUBSTRING(Subject
		,CHARINDEX('':'',a.Subject)+Case When CHARINDEX(''(#'',a.Subject)=0 Then 0 Else 2 End 							--Client Name First Char
		,CHARINDEX(''(#'',a.Subject)-CHARINDEX('':'',a.Subject)-Case When CHARINDEX(''(#'',a.Subject)=0 Then 0 Else 3 End	--Client Name Last Char
		) as ApptClientName
	, a.Subject
	, pc.DisplayAs

	From Appointments a with(nolock)
	Join Services s with(nolock) on s.ServiceId=a.ServiceId and ISNULL(s.RecordDeleted,''N'')=''N''
	Join Clients c with(nolock) on c.ClientId=s.ClientId and ISNULL(c.RecordDeleted,''N'')=''N''
	Join ProcedureCodes pc with(nolock) on pc.ProcedureCodeId=s.ProcedureCodeId and ISNULL(pc.RecordDeleted,''N'')=''N''
	Where a.Subject like ''%(#%''
	and LEFT(c.LastName+'', ''+c.FirstName,12) <> LEFT(SUBSTRING(Subject
		,CHARINDEX('':'',a.Subject)+Case When CHARINDEX(''(#'',a.Subject)=0 Then 0 Else 2 End 							--Client Name First Char
		,CHARINDEX(''(#'',a.Subject)-CHARINDEX('':'',a.Subject)-Case When CHARINDEX(''(#'',a.Subject)=0 Then 0 Else 3 End	--Client Name Last Char
		),12)
	and a.AppointmentType = 4761 --Service
	and a.ServiceId is not null
	and s.DateOfService >= GETDATE()--''9/27/2010''
	and ISNULL(a.RecordDeleted,''N'')=''N''

--Bug Tracking
INSERT into CustomBugTracking (ClientId, ServiceId, Description, CreatedDate)
Select 	b.ClientId, b.ServiceId
	, ''AppointmentId: ''+convert(varchar(20),b.AppointmentId)
	+'' - Corrected ClientName on Appt from ''+b.ApptClientName+'' to ''+b.ClientName
	, GETDATE()
	from #AppointmentBug b
	Where b.ClientId = b.ApptClientId
	and LEFT(b.ClientName,12) <> LEFT(b.ApptClientName,12)
	Order by b.ServiceId


--Correct Appointment Subject line
	UPDATE a
	SET a.Subject = ''Client: ''
		+Case When LEN(b.ClientName) > 15 Then LEFT(b.ClientName,15)+''..'' Else b.ClientName End
		+'' (#''+CONVERT(varchar(20),b.ClientId)
		+'') ''+CHAR(151)+'' ''+b.ProcedureCodeName
	from Appointments a 
	Join #AppointmentBug b with(nolock) on a.AppointmentId=b.AppointmentId
	Where b.ClientId = b.ApptClientId
	and LEFT(b.ClientName,12) <> LEFT(b.ApptClientName,12)
	
	

drop table #AppointmentBug
' 
END
GO
