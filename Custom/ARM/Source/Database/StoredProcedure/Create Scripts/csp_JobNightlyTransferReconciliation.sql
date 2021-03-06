/****** Object:  StoredProcedure [dbo].[csp_JobNightlyTransferReconciliation]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobNightlyTransferReconciliation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_JobNightlyTransferReconciliation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobNightlyTransferReconciliation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_JobNightlyTransferReconciliation] as
-- Job to ensure primary clinician assignments and program assignments "take"
begin try
begin tran

declare @tAssignments table (
	ClientId int,
	ClinicianId int,
	ProgramId int,
	EffectiveDate datetime
)

insert into @tAssignments
        (ClientId, ClinicianId, ProgramId, EffectiveDate)

select d.ClientId, t.ReceivingStaff, t.ReceivingProgram, d.EffectiveDate
from dbo.Documents as d
join dbo.CustomDocumentTransfers as t on t.DocumentVersionId = d.CurrentDocumentVersionId
where d.DocumentCodeId = 15002
and d.Status = 22
and t.ReceivingAction = 20437
and not exists (
	select *
	from dbo.Documents as d2
	where d2.ClientId = d.ClientId
	and d2.DocumentCodeId = d.DocumentCodeId
	and ((d2.EffectiveDate > d.EffectiveDate) or (d2.EffectiveDate = d.EffectiveDate and d2.DocumentId > d.DocumentId))
	and ISNULL(d2.RecordDeleted, ''N'') <> ''Y''
)
and (
	not exists (
		select *
		from dbo.Clients as c
		where c.ClientId = d.ClientId
		and c.PrimaryClinicianId = t.ReceivingStaff
	)
	or not exists (
		select *
		from dbo.ClientPrograms as cp
		where cp.ClientId = d.ClientId
		and cp.ProgramId = t.ReceivingProgram
		--and cp.Status = 4
		and ISNULL(cp.RecordDeleted, ''N'') <> ''Y''
	)
)

update c set
	PrimaryClinicianId = t.ClinicianId
from dbo.Clients as c
join @tAssignments as t on t.ClientId = c.ClientId
where (c.PrimaryClinicianId is null) or (c.PrimaryClinicianId <> t.ClinicianId)

insert into dbo.ClientPrograms
        (
         ClientId,
         ProgramId,
         Status,
         EnrolledDate,
         PrimaryAssignment,
         Comment
        )
select t.ClientId, t.ProgramId, 4, t.EffectiveDate, ''Y'', ''Created by transfer document overnight reconciliation process.''
from @tAssignments as t
where not exists (
	select *
	from dbo.ClientPrograms as cp
	where cp.ClientId = t.ClientId
	and cp.ProgramId = t.ProgramId
	and ISNULL(cp.RecordDeleted, ''N'') <> ''Y''
)

update c set
	PrimaryProgramId = cp.ClientProgramId
from dbo.Clients as c
join dbo.ClientPrograms as cp on cp.ClientId = c.ClientId
join @tAssignments as t on t.ClientId = cp.ClientId and t.ProgramId = cp.ProgramId

update cp set
	PrimaryAssignment = ''N''
from dbo.ClientPrograms as cp
join @tAssignments as t on t.ClientId = cp.ClientId and t.ProgramId != cp.ProgramId
where cp.PrimaryAssignment = ''Y''

--select *
--from @tAssignments as t
--where not exists (
--	select *
--	from dbo.ClientPrograms as cp
--	where cp.ClientId = t.ClientId
--	and cp.ProgramId = t.ProgramId
--)

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
