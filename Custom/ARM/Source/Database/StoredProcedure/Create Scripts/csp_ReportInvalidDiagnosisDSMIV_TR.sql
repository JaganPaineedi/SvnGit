/****** Object:  StoredProcedure [dbo].[csp_ReportInvalidDiagnosisDSMIV_TR]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportInvalidDiagnosisDSMIV_TR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportInvalidDiagnosisDSMIV_TR]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportInvalidDiagnosisDSMIV_TR]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/**/
Create      procedure [dbo].[csp_ReportInvalidDiagnosisDSMIV_TR]
	@PrimaryClinicianId	int,
	@AuthorId   int
/* 
Report to Identify Current Diagnosis for clients that will become invalid
with implementation of DSMIV-TR codes
declare 	@PrimaryClinicianId	int, @AuthorId   int
select @PrimaryClinicianId = null, @authorId = 872
*/

AS




select 
	s.staffid, 
	isnull(s.lastname + '', '' + s.firstname,''* None Assigned'') as PrimaryClinicianName, 
	c.clientid, 
	c.lastname +'', ''+ c.firstname as ClientName,
	d.authorid, 
	st2.lastname + '', '' + st2.firstname as AuthorName,
	d.effectivedate, 
	dv.version, 
	dc.documentname,
	di.dsmcode, 
	gc.codename, 
	diagnosisorder, 
	case when isnull(ruleout, ''N'') = ''N'' then null
		when isnull(ruleout, ''N'') = ''Y'' then ''R/O'' 
		else null end as ruleout, dsmdescription,
	convert(varchar(20), d.createddate, 101) as createddate, 
	di.createdby,
	convert(varchar(20), d.modifieddate, 101) as modifieddate, 
	di.modifiedby
--convert(varchar(20), ds.signaturedate, 101) as SignatureDate
from Clients as c
left join staff as s on s.staffid = c.primaryclinicianid 
	--and isnull(s.active, ''N'') = ''Y'' 
	and isnull(s.recorddeleted, ''N'') <> ''Y''
left join programs as p on p.programid = s.PrimaryProgramId 
	and isnull(p.recorddeleted, ''N'') <> ''Y''
left join GlobalCodes as gc2 on gc2.GlobalCodeId = p.ProgramType
left join Documents as d on d.clientid = c.clientid
	and d.Status = 22 and d.DocumentCodeId = 5
	and not exists ( 
		select * from documents as d2 where d2.clientid = d.clientid
		and d2.DocumentCodeId = d.DocumentCodeId
		and d2.DocumentCodeId = 5 and d2.Status = 22
		and d2.EffectiveDate > d.EffectiveDate
		and isnull(d2.RecordDeleted, ''N'') <> ''Y''
)
	and isnull(d.RecordDeleted, ''N'') <> ''Y''
left join DocumentVersions dv on dv.DocumentVersionId=d.CurrentDocumentVersionId
left join staff as st2 on st2.staffid = d.authorid 
	and isnull(st2.recorddeleted, ''N'') <> ''Y''
left join DiagnosesIandII as di on di.DocumentVersionId = d.CurrentDocumentVersionId 
	and isnull(di.RecordDeleted, ''N'') <> ''Y''
left join GlobalCodes as gc on gc.GlobalCodeId = di.DiagnosisType 
	and isnull(gc.RecordDeleted, ''N'') <> ''Y''
left join DocumentCodes as dc on dc.DocumentCodeId = d.DocumentCodeId 
	and isnull(dc.RecordDeleted, ''N'') <> ''Y''
left join DiagnosisDsmDescriptions as dd on dd.DsmCode = di.DsmCode 
	and dd.DsmNumber = di.DsmNumber
where c.Active = ''Y''
and exists ( select * from DiagnosisDsmDescriptions_Old as ddo
	where ddo.DsmCode = di.DsmCode and ddo.InvalidInDSMIV = ''Y'' 
)
and isnull(dc.RecordDeleted, ''N'') <> ''Y''
and isnull(c.RecordDeleted, ''N'') <> ''Y''
and (s.StaffId = @PrimaryClinicianId or @PrimaryClinicianId is null )
and (st2.StaffId = @AuthorId or @AuthorId is null )
order by 
	gc2.codename, 
	s.lastname + '', '' + s.firstname, 
	c.lastname + '', ''+ c.firstname, 
	d.effectivedate, 
	di.diagnosisorder
' 
END
GO
