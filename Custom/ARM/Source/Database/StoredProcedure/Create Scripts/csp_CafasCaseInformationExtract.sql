/****** Object:  StoredProcedure [dbo].[csp_CafasCaseInformationExtract]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CafasCaseInformationExtract]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CafasCaseInformationExtract]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CafasCaseInformationExtract]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE    PROCEDURE [dbo].[csp_CafasCaseInformationExtract]
AS

DECLARE @eff_date DATETIME

set @eff_date = GETDATE()

--Get all of the new cases from the Cafas database

set Identity_Insert CustomCafasCaseInformation On

insert into CustomCafasCaseInformation
(CaseId,
StatusIsOpen,
Agency,
SiteName,
LastName,
FirstName,
MiddleName,
MRNorSSN,
BirthDate,
Sex,
AdmissionDate,
ClosedDate,
ClosedReason,
ClosedReasonNoTreatment,
ClosedReasonInterrupted,
ClosedWithOutcome,
ClosedAdditionalAction,
ClosedOutcomeofRecommendation,
DaysSinceAdmitted,
DaysSinceLastCafas,
MRNorSSN2)
select
CaseId,
StatusIsOpen,
Agency,
SiteName,
LastName,
FirstName,
MiddleName,
MRNorSSN,
BirthDate,
Sex,
AdmissionDate,
ClosedDate,
ClosedReason,
ClosedReasonNoTreatment,
ClosedReasonInterrupted,
ClosedWithOutcome,
ClosedAdditionalAction,
ClosedOutcomeofRecommendation,
DaysSinceAdmitted,
DaysSinceLastCafas,
MRNorSSN2
from customCafasCaseInformationStage a
where not exists
(select 1 from customCafasCaseInformation b
where a.CaseId = b.CaseId)

Update ci
Set
SiteName	 = cs.SiteName,
StatusIsOpen = cs.StatusIsOpen,
LastName	 = cs.LastName,
FirstName	 = cs.FirstName,
MiddleName	 = cs.MiddleName,
MRNorSSN	 = cs.MRNorSSN,
BirthDate	 = cs.BirthDate,
Sex			 = cs.Sex,
AdmissionDate= cs.AdmissionDate,
ClosedDate	 = cs.ClosedDate,
ClosedReason = cs.ClosedReason,
ClosedReasonNoTreatment = cs.ClosedReasonNoTreatment,
ClosedReasonInterrupted	= cs.ClosedReasonInterrupted,
ClosedWithOutcome		= cs.ClosedWithOutcome,
ClosedAdditionalAction	= cs.ClosedAdditionalAction,
ClosedOutcomeofRecommendation	= cs.ClosedOutcomeOfRecommendation,
DaysSinceAdmitted		= cs.DaysSinceAdmitted,
DaysSinceLastCafas		= cs.DaysSinceLastCafas,
MRNorSSN2				= cs.MRNorSSN2
from CustomCafasCaseInformation ci
join CustomCafasCaseInformationStage cs on ci.CaseId = cs.CaseId


set Identity_Insert CustomCafasCaseInformation Off

--Update Existing Cases

UPDATE ci SET
	[StatusIsOpen] = ci.[StatusIsOpen],
	[Agency] = ''Riverwood Center'',
	[SiteName] = ''Children'',
	[LastName] = c.LastName,
	[FirstName] = c.FirstName,
	[MiddleName] = c.MiddleName,
	[MRNorSSN] = c.ClientId,
	[Birthdate] = c.dob,
	[Sex] = case c.Sex when ''M'' then ''male'' when ''F'' then ''female'' end,
	[MRNorSSN2] = c.SSN,
	[AdmissionDate] = ce.RegistrationDate
FROM CustomCafasCaseInformation AS ci
join clients c on c.ClientId = ci.MRNorSSN
left join ClientEpisodes as ce on ce.ClientId = c.ClientId and isnull(ce.RecordDeleted, ''N'') <> ''Y''
	and not exists (select 1 from ClientEpisodes as ce2 where ce2.ClientId = ce.ClientId and isnull(ce2.RecordDeleted, ''N'') <> ''Y''
						and ce2.EpisodeNumber > ce.EpisodeNumber)
and ci.SiteName = ''Children''

--Get new cases that aren''t already in the Cafas Database
insert into CustomCafasCaseInformation
(StatusIsOpen,
Agency,
SiteName,
LastName,
FirstName,
MiddleName,
MRNorSSN,
Birthdate,
Sex,
MRNorSSN2,
AdmissionDate)
select
1,
''Riverwood Center'',
''Children'',
c.LastName,
c.FirstName,
c.MiddleName,
c.ClientId,
c.DOB,
case c.Sex when ''M'' then ''male'' when ''F'' then ''female'' end,
c.SSN,
ce.RegistrationDate
FROM Clients c
left join ClientEpisodes as ce on ce.ClientId = c.ClientId and isnull(ce.RecordDeleted, ''N'') <> ''Y''
	and not exists (select 1 from ClientEpisodes as ce2 where ce2.ClientId = ce.ClientId and isnull(ce2.RecordDeleted, ''N'') <> ''Y''
						and ce2.EpisodeNumber > ce.EpisodeNumber)
WHERE
c.Active = ''Y''
-- Client between 7 and 17
and dbo.GetAge(c.dob, @eff_date) >= 7
and dbo.GetAge(c.dob, @eff_date) <= 17	
and not exists
(select 1 from customCafasCaseInformation cci
where cci.MRNorSSN = c.clientId
and cci.SiteName = ''Children'')
/*and not exists
(select 1 from documents doc
join diagnosesIandII diag on diag.documentid = doc.documentId
where isnull(doc.RecordDeleted,''N'') <> ''Y''
and isnull(diag.RecordDeleted,''N'') <> ''Y''
and doc.clientId = c.clientId
and(
	 (diag.dsmCode Like ''317%'' and diag.Billable = ''Y'')
  or (diag.dsmCode like ''318%'' and diag.Billable = ''Y'')
  or (diag.dsmCode like ''319%'' and diag.Billable = ''Y'')
    )
)*/
and not exists
(
select 1 from clientPrograms cp
where cp.programId in
(4,-- DD
13, -- SMI Case Management
18 -- Child - DD
)
and 
(cp.dischargedDate is null or datediff(day,cp.dischargedDate, @eff_date) < 90)
and isnull(cp.RecordDeleted,''N'') <> ''Y''
and cp.PrimaryAssignment = ''Y''
and cp.clientId = c.clientId
)
and isnull(c.RecordDeleted,''N'') <> ''Y''


-- Set Cases Inactive or Active
update a
set StatusIsOpen = case when b.Active = ''Y'' then 1 else 0 end
from CustomCafasCaseInformation a
join Clients b on a.MRNorSSN = b.ClientId
where a.SiteName = ''Children''
and ((isnull(b.Active, ''N'') = ''Y'' and a.StatusIsOpen = 0) or (isnull(b.Active, ''N'') = ''N'' and a.StatusIsOpen = 1))
' 
END
GO
