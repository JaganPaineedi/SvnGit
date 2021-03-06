/****** Object:  StoredProcedure [dbo].[csp_ReportActiveClientsWithNoPrimaryClinician]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportActiveClientsWithNoPrimaryClinician]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportActiveClientsWithNoPrimaryClinician]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportActiveClientsWithNoPrimaryClinician]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_ReportActiveClientsWithNoPrimaryClinician] as
/********************************************************************/
/* Riverwood Customization.											*/
/* Report called by Reporting Services.  Returns all active clients	*/
/* with no primary clinician assignment.							*/
/********************************************************************/


select c.LastName + '', '' + c.FirstName as ClientName, c.ClientId, ce.AssessmentDate, s.DateOfService as LastDayOfService, gc1.CodeName as Status
from Clients as c
left outer join ClientEpisodes as ce on ce.ClientId = c.ClientId and isnull(ce.RecordDeleted,''N'')<>''Y''
left outer join Services as s on s.ClientId = c.ClientId and isnull(s.RecordDeleted,''N'')<>''Y''
left outer join globalcodes as gc1 on gc1.globalCodeId = s.status
where isnull(c.RecordDeleted, ''N'') <> ''Y''
and c.Active = ''Y''
--and ce.Status not in (102)  --Modified to include discharged clients AV 8/3/2007
and c.PrimaryClinicianId is null
and not exists (
	select *
	from ClientEpisodes as ce2
	where ce2.ClientId = c.ClientId
	and ce2.EpisodeNumber > ce.EpisodeNumber
	and isnull(ce2.RecordDeleted, ''N'') <> ''Y''
	)
--added to include last date of service 8/6/07 av
and not exists (
	select *
	from services as s2
	where s2.ClientId = c.ClientId
	and s2.ServiceId > s.ServiceId
	and isnull(s2.RecordDeleted, ''N'') <> ''Y'')
-- and ((ce.AssessmentDate is null) or (datediff(day, ce.AssessmentDate, getdate()) > 0))
order by 1
' 
END
GO
