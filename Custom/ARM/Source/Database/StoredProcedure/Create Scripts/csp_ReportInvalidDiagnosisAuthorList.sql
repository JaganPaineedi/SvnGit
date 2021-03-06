/****** Object:  StoredProcedure [dbo].[csp_ReportInvalidDiagnosisAuthorList]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportInvalidDiagnosisAuthorList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportInvalidDiagnosisAuthorList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportInvalidDiagnosisAuthorList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/**/
CREATE      procedure [dbo].[csp_ReportInvalidDiagnosisAuthorList]

/* 
Report to Identify Current Diagnosis for clients that will become invalid
with implementation of DSMIV-TR codes
declare 	@PrimaryClinicianId	int, @AuthorId   int
select @PrimaryClinicianId = null, @authorId = 872
*/

AS




select distinct
	st2.staffid, 
	st2.lastname + '', '' + st2.firstname as Author
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


Union 

select NULL, ''< All Staff >'' 

Order By st2.lastname + '', '' + st2.firstname
' 
END
GO
