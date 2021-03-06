/****** Object:  StoredProcedure [dbo].[csp_ReportClinicianCaseloadVerbose]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClinicianCaseloadVerbose]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportClinicianCaseloadVerbose]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClinicianCaseloadVerbose]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/****** Object:  Stored Procedure dbo.csp_ReportClinicianCaseloadVerbose    Script Date: 12/19/2006 8:54:26 AM ******/


CREATE  PROCEDURE [dbo].[csp_ReportClinicianCaseloadVerbose]
@StaffId int = null
AS
/*
TER 12/97/2006 Created
This stored procedure is a report which lists the current caseload by staff.
This is the same logic as csp_ReportClinicianCaseload except the layout shows one row per Client.
*/


create table #StaffCaseload (
RecordId        int  identity not null,
StaffId		int  null,
StaffFirstName	varchar(300) null,
StaffLastName	varchar(300) null,
ClientId	int  null,
EpisodeNumber	int  null,
ClientLastName	varchar(300) null,
ClientFirstName	varchar(300) null,
ClientDateOfBirth datetime null,
ClientSSN varchar(11) null,
ClientAddress varchar(128) null,
AssessmentDate	datetime null,
LastDateofService	datetime null,
ClientPhone varchar(128) null
)


insert into #StaffCaseload
(StaffId,StaffFirstName,StaffLastName,ClientLastName,ClientFirstName, ClientId, EpisodeNumber, ClientDateOfBirth, ClientSSN, ClientAddress, ClientPhone)
select distinct a.PrimaryClinicianId,b.FirstName,b.LastName,a.LastName,a.FirstName, a.ClientId, c.EpisodeNumber, a.DOB, 
substring(a.SSN, 1, 3) + ''-'' + substring(a.SSN, 4, 2) + ''-'' + substring(a.SSN, 6, 4), ca.Display, cp.PhoneNumber
from Clients a
Join Staff b on a.PrimaryClinicianId = b.StaffId
JOIN ClientEpisodes c ON (a.ClientId = c.ClientId
and 
(
	a.CurrentEpisodeNumber = c.EpisodeNumber
	OR
	a.CurrentEpisodeNumber is NULL
)
)
left outer join ClientAddresses as ca on (ca.ClientId = a.ClientId and ca.AddressType = 90 /* home */ and (isnull(ca.recorddeleted, ''N'') <> ''Y''))
left outer join ClientPhones as cp on (cp.ClientId = a.ClientId and cp.PhoneType = 30 /* home */ and (isnull(cp.recorddeleted, ''N'') <> ''Y''))
where
a.active = ''Y''
and Isnull(a.RecordDeleted,'''') <> ''Y''
and isnull(b.RecordDeleted,'''') <> ''Y''
and Isnull(c.RecordDeleted,'''') <> ''Y''
and a.PrimaryClinicianId = isnull(@StaffId,a.PrimaryClinicianId) 
--Remove Non-Clinician Clinicians
and a.PrimaryClinicianId not in(92,93,94,131,135)

update a set
	AssessmentDate = ce.AssessmentDate
from #StaffCaseload as a
join ClientEpisodes as ce on (ce.ClientId = a.ClientId and ce.EpisodeNumber = a.EpisodeNumber)
where
	ISNULL(ce.recorddeleted, ''N'') <> ''Y''


update a set
	LastDateOfService = summ.MaxDateOfService
from #StaffCaseload as a
join
(
	select s.ClientId, max(s.DateOfService) as MaxDateOfService
	from Services as s
	where isnull(s.recorddeleted, ''N'') <> ''Y''
	and s.Status in (71,75)
	group by s.ClientId
) as summ on (summ.ClientId = a.ClientId)
		

select 
	StaffId,
	StaffFirstName,
	StaffLastName,
	ClientLastName + '','' + ClientFirstName as ClientName, 
	ClientId, 
	EpisodeNumber, 
	ClientDateOfBirth, 
	ClientSSN, 
	ClientAddress,
	AssessmentDate,
	LastDateOfService,
	ClientPhone
from #StaffCaseload a
order by StaffLastName,StaffFirstName,a.StaffId, ClientLastName + '','' + ClientFirstName, ClientId
' 
END
GO
