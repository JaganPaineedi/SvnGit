/****** Object:  StoredProcedure [dbo].[csp_job_DeleteInvalidTreatmentPlanReviews]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_job_DeleteInvalidTreatmentPlanReviews]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_job_DeleteInvalidTreatmentPlanReviews]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_job_DeleteInvalidTreatmentPlanReviews]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_job_DeleteInvalidTreatmentPlanReviews] as
-- Job to delete in-progress treatment plan reviews where the author is not currently the primary clinician
-- or the client is no longer active
begin try
begin tran

declare @tabDocuments table (
	DocumentId int
)

insert @tabDocuments
        (DocumentId)
select d.DocumentId
from dbo.Documents as d
join dbo.Clients as c on c.ClientId = d.ClientId
join dbo.Staff as s on s.StaffId = d.AuthorId
LEFT join dbo.Staff as s2 on s2.StaffId = c.PrimaryClinicianId
where d.DocumentCodeId = 1485
and d.Status = 21
and ((c.PrimaryClinicianId is null) or (c.Active = ''N'') or (d.AuthorId <> c.PrimaryClinicianId))
and ISNULL(d.RecordDeleted, ''N'') <> ''Y''

update d set
	RecordDeleted = ''Y'',
	DeletedDate = GETDATE(),
	DeletedBy = ''DELREVIEWS''
from dbo.Documents as d
join @tabDocuments as t on t.DocumentId = d.DocumentId

update d set
	RecordDeleted = ''Y'',
	DeletedDate = GETDATE(),
	DeletedBy = ''DELREVIEWS''
from dbo.DocumentVersions as d
join @tabDocuments as t on t.DocumentId = d.DocumentId

update d set
	RecordDeleted = ''Y'',
	DeletedDate = GETDATE(),
	DeletedBy = ''DELREVIEWS''
from dbo.DocumentSignatures as d
join @tabDocuments as t on t.DocumentId = d.DocumentId

commit tran

end try
begin catch
if @@TRANCOUNT > 0 rollback tran
declare @error_message nvarchar(4000)
set @error_message = ERROR_MESSAGE()
raiserror (@error_message, 16, 1)
end catch
' 
END
GO
