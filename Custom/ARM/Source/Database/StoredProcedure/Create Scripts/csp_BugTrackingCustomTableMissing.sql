/****** Object:  StoredProcedure [dbo].[csp_BugTrackingCustomTableMissing]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_BugTrackingCustomTableMissing]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_BugTrackingCustomTableMissing]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_BugTrackingCustomTableMissing]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_BugTrackingCustomTableMissing]

as


declare @StartDate datetime

set @StartDate = ''1/8/2010''


Insert into CustomBugTracking
(ClientId, DocumentId, Description, CreatedDate, DocumentVersionId)

select d.ClientId, d.DocumentId, ''Custom table record missing for version > 1'', GETDATE(), dv.DocumentVersionId
from Documents d with(nolock)
join DocumentVersions dv with(nolock) on d.DocumentId=dv.DocumentId and isnull(dv.RecordDeleted,''N'')<>''Y''
join Services s on s.ServiceId = d.ServiceId 
left join CustomHRMServiceNotes c with(nolock) on c.DocumentVersionId = dv.DocumentVersionId
where d.Status=22
and isnull(d.RecordDeleted,''N'')<>''Y''
and d.DocumentCodeId = 353
and d.ModifiedDate >= @StartDate
and c.DocumentVersionId is null
and Not exists (select * from CustomBugTracking t
				Where t.DocumentVersionId = dv.DocumentVersionId
				and t.Description like ''%missing for version > 1%''
				)
order by d.ModifiedDate


Insert into CustomBugTracking
(ClientId, DocumentId, Description, CreatedDate, DocumentVersionId)

select d.ClientId, d.DocumentId, ''Custom table record missing for version > 1'', GETDATE(), dv.DocumentVersionId
from Documents d with(nolock)
join DocumentVersions dv with(nolock) on d.DocumentId=dv.DocumentId and isnull(dv.RecordDeleted,''N'')<>''Y''
join Services s on s.ServiceId = d.ServiceId 
left join CustomDBTGroupNotes c with(nolock) on c.DocumentVersionId = dv.DocumentVersionId
where d.Status=22
and isnull(d.RecordDeleted,''N'')<>''Y''
and d.DocumentCodeId = 111
and d.ModifiedDate >= @StartDate
and c.DocumentVersionId is null
and Not exists (select * from CustomBugTracking t
				Where t.DocumentVersionId = dv.DocumentVersionId
				and t.Description like ''%missing for version > 1%''
				)
order by d.ModifiedDate



Insert into CustomBugTracking
(ClientId, DocumentId, Description, CreatedDate, DocumentVersionId)

select d.ClientId, d.DocumentId, ''Custom table record missing for version > 1'', GETDATE(), dv.DocumentVersionId
from Documents d with(nolock)
join DocumentVersions dv with(nolock) on d.DocumentId=dv.DocumentId and isnull(dv.RecordDeleted,''N'')<>''Y''
join Services s on s.ServiceId = d.ServiceId 
left join CustomMedicationAdministrations c with(nolock) on c.DocumentVersionId = dv.DocumentVersionId
where d.Status=22
and isnull(d.RecordDeleted,''N'')<>''Y''
and d.DocumentCodeId = 354
and d.ModifiedDate >= @StartDate
and c.DocumentVersionId is null
and Not exists (select * from CustomBugTracking t
				Where t.DocumentVersionId = dv.DocumentVersionId
				and t.Description like ''%missing for version > 1%''
				)
order by d.ModifiedDate



Insert into CustomBugTracking
(ClientId, DocumentId, Description, CreatedDate, DocumentVersionId)

select d.ClientId, d.DocumentId, ''Custom table record missing for version > 1'', GETDATE(), dv.DocumentVersionId
from Documents d with(nolock)
join DocumentVersions dv with(nolock) on d.DocumentId=dv.DocumentId and isnull(dv.RecordDeleted,''N'')<>''Y''
--join Services s on s.ServiceId = d.ServiceId 
left join TPGeneral c with(nolock) on c.DocumentVersionId = dv.DocumentVersionId and ISNULL(c.RecordDeleted, ''N'') = ''N''
where d.Status=22
and isnull(d.RecordDeleted,''N'')<>''Y''
and d.DocumentCodeId = 350
and d.ModifiedDate >= @StartDate
and c.DocumentVersionId is null
and Not exists (select * from CustomBugTracking t
				Where t.DocumentVersionId = dv.DocumentVersionId
				and t.Description like ''%missing for version > 1%''
				)
order by d.ModifiedDate


Insert into CustomBugTracking
(ClientId, DocumentId, Description, CreatedDate, DocumentVersionId)

select d.ClientId, d.DocumentId, ''Custom table record missing for version > 1'', GETDATE(), dv.DocumentVersionId
from Documents d with(nolock)
join DocumentVersions dv with(nolock) on d.DocumentId=dv.DocumentId and isnull(dv.RecordDeleted,''N'')<>''Y''
--join Services s on s.ServiceId = d.ServiceId 
left join CustomHRMAssessments c with(nolock) on c.DocumentVersionId = dv.DocumentVersionId and ISNULL(c.RecordDeleted, ''N'') = ''N''
where d.Status=22
and isnull(d.RecordDeleted,''N'')<>''Y''
and d.DocumentCodeId = 1469
and d.ModifiedDate >= @StartDate
and c.DocumentVersionId is null
and Not exists (select * from CustomBugTracking t
				Where t.DocumentVersionId = dv.DocumentVersionId
				and t.Description like ''%missing for version > 1%''
				)
order by d.ModifiedDate


Insert into CustomBugTracking
(ClientId, DocumentId, Description, CreatedDate, DocumentVersionId)

select d.ClientId, d.DocumentId, ''Custom table record missing for version > 1'', GETDATE(), dv.DocumentVersionId
from Documents d with(nolock)
join DocumentVersions dv with(nolock) on d.DocumentId=dv.DocumentId and isnull(dv.RecordDeleted,''N'')<>''Y''
--join Services s on s.ServiceId = d.ServiceId 
left join PeriodicReviews c with(nolock) on c.DocumentVersionId = dv.DocumentVersionId and ISNULL(c.RecordDeleted, ''N'') = ''N''
where d.Status=22
and isnull(d.RecordDeleted,''N'')<>''Y''
and d.DocumentCodeId = 352
and d.ModifiedDate >= @StartDate
and c.DocumentVersionId is null
and Not exists (select * from CustomBugTracking t
				Where t.DocumentVersionId = dv.DocumentVersionId
				and t.Description like ''%missing for version > 1%''
				)
order by d.ModifiedDate
' 
END
GO
