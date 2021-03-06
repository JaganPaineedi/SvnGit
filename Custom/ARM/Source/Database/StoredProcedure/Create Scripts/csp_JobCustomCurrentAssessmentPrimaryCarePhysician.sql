/****** Object:  StoredProcedure [dbo].[csp_JobCustomCurrentAssessmentPrimaryCarePhysician]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobCustomCurrentAssessmentPrimaryCarePhysician]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_JobCustomCurrentAssessmentPrimaryCarePhysician]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobCustomCurrentAssessmentPrimaryCarePhysician]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_JobCustomCurrentAssessmentPrimaryCarePhysician]

as
/*
Modified By		Modified Date	Reason
avoss			created			Used for Venture Report for all affiliates

exec dbo.csp_JobCustomCurrentAssessmentPrimaryCarePhysician
*/

delete from CustomCurrentAssessmentPrimaryCarePhysician

insert into CustomCurrentAssessmentPrimaryCarePhysician
(
 DocumentId 
,DocumentVersionId 
,Version 
,EffectiveDate
,ClientId 
,EpisodeNumber 
,RegistrationDate
,CurrentPrimaryCarePhysician 
)
select  
d.DocumentId, dv.DocumentVersionId, dv.Version, d.EffectiveDate, d.ClientId, 
ce.EpisodeNumber, ce.RegistrationDate, ltrim(rtrim(ca.CurrentPrimaryCarePhysician)) as CurrentPrimaryCarePhysician
from customHRMAssessments ca with (nolock) 
join DocumentVersions dv with (nolock) on dv.DocumentVersionId = ca.DocumentVersionId and isnull(dv.RecordDeleted,''N'') <> ''Y''
join Documents d with (nolock) on d.DocumentId = dv.DocumentId and isnull(d.RecordDeleted,''N'') <> ''Y'' 
join Clients c with (nolock) on c.ClientId = d.ClientId and isnull(c.RecordDeleted,''N'') <> ''Y''  
join ClientEpisodes ce on ce.ClientId = c.ClientId and isnull(ce.RecordDeleted,''N'') <> ''Y'' 
where isnull(ca.RecordDeleted,''N'') <> ''Y''
and c.Active = ''Y''
and d.Status = 22
--and d.EffectiveDate >= isnull(ce.RegistrationDate,''1/1/1900'')
and isnull(ca.CurrentPrimaryCarePhysician,'''') <> ''''
and not exists (
	select * 
	From clientepisodes ce2 with (nolock) where ce2.ClientId = c.CLientId and isnull(ce2.RecordDeleted,''N'') <> ''Y'' 
	and ce2.EpisodeNumber > ce.EpisodeNumber
)
and not exists ( 
	select *
	from customHRMAssessments ca2 with (nolock) 
	join DocumentVersions dv2 with (nolock) on dv2.DocumentVersionId = ca2.DocumentVersionId and isnull(dv2.RecordDeleted,''N'') <> ''Y''
	join Documents d2 with (nolock) on d2.DocumentId = dv2.DocumentId and isnull(d2.RecordDeleted,''N'') <> ''Y'' 
	where isnull(ca2.RecordDeleted,''N'') <> ''Y''
	and d2.ClientId = d.ClientId
	and d2.Status = 22
	and ( 
		(d2.EffectiveDate > d.EffectiveDate) 
		or ( d2.EffectiveDate = d.EffectiveDate and ( (d2.DocumentId<>d.DocumentId) or (d2.DocumentId = d.DocumentId and dv2.Version > dv.Version) )  ) 
	)
)
order by d.DocumentId, d.ClientId, dv.DocumentVersionId, dv.Version, d.EffectiveDate,
ce.EpisodeNumber, ltrim(rtrim(ca.CurrentPrimaryCarePhysician))
' 
END
GO
