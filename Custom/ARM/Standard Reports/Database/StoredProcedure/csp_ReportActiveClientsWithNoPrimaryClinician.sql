/****** Object:  StoredProcedure [dbo].[csp_ReportActiveClientsWithNoPrimaryClinician]    Script Date: 04/18/2013 09:41:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportActiveClientsWithNoPrimaryClinician]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[csp_ReportActiveClientsWithNoPrimaryClinician]
GO

/****** Object:  StoredProcedure [dbo].[csp_ReportActiveClientsWithNoPrimaryClinician]    Script Date: 04/18/2013 09:41:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[csp_ReportActiveClientsWithNoPrimaryClinician] as
/********************************************************************
Barry Customization.											
Report called by Reporting Services.  Returns all active clients
with no primary clinician assignment.							

Modified by		Modified Date	Reason
avoss			05/06/2009		Modified to include only in treatment clients
avoss			05/29/2009		Modified to exclude only discharged clients
*******************************************************************/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

select c.LastName + ', ' + c.FirstName as ClientName, c.ClientId, ce.AssessmentDate, s.DateOfService as LastDayOfService, gc1.CodeName as Status
from Clients as c
left outer join ClientEpisodes as ce on ce.ClientId = c.ClientId and isnull(ce.RecordDeleted,'N')<>'Y'
left outer join Services as s on s.ClientId = c.ClientId and isnull(s.RecordDeleted,'N')<>'Y'
left outer join globalcodes as gc1 on gc1.globalCodeId = s.status
where isnull(c.RecordDeleted, 'N') <> 'Y'
and c.Active = 'Y'
and ce.Status not in (102)  --Modified to exclude discharged clients AV 5/29/2009
--and ce.Status in (101)  --Modified to include only in treatment clients 5/6/2009
and c.PrimaryClinicianId is null
and not exists (
	select *
	from ClientEpisodes as ce2
	where ce2.ClientId = c.ClientId
	and ce2.EpisodeNumber > ce.EpisodeNumber
	and isnull(ce2.RecordDeleted, 'N') <> 'Y'
	)
--added to include last date of service 8/6/07 av
and not exists (
	select *
	from services as s2
	where s2.ClientId = c.ClientId
	and s2.ServiceId > s.ServiceId
	and isnull(s2.RecordDeleted, 'N') <> 'Y')
-- and ((ce.AssessmentDate is null) or (datediff(day, ce.AssessmentDate, getdate()) > 0))
order by 1



SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO

