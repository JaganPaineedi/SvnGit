/****** Object:  StoredProcedure [dbo].[csp_TransferReferralWorkFlowCreateProgramEnrollment]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_TransferReferralWorkFlowCreateProgramEnrollment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_TransferReferralWorkFlowCreateProgramEnrollment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_TransferReferralWorkFlowCreateProgramEnrollment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

create procedure [dbo].[csp_TransferReferralWorkFlowCreateProgramEnrollment]
	@ClientId int,				-- client for whom the enrolment occurs
	@ProgramId int,				-- Program
	@RequestedDate datetime,	-- date program requested
	@EnrollmentDate datetime,	-- date program enrolled
	@AssignedStaff int,			-- Staff Id assigned to the program enrollment
	@PrimaryAssignment char(1)	-- indicates whether this assignment is to become primary
as
/****************************************************************/
-- PROCEDURE: csp_TransferReferralWorkFlowCreateProgramEnrollment
-- PURPOSE: Handles the creation of new program enrollments.
-- CALLED BY: csp_CustomDocumentReferralWorkflow and csp_CustomDocumentTransferWorkflow.
-- REVISION HISTORY:
--		2011.07.19 - T. Remisoski - Created.
--		2012.02.01 - Updated logic for acceptance
--		2012.12.22 - T. Remisoski - added logic to create/update program enrollment
/****************************************************************/


begin try
begin tran

declare @tabAssignments table (
	ClientId int,
	ClientProgramId int,
	AssignedStaffId int,
	EnrolledDate datetime
)

declare @tabProgramHistory table 
(
	ClientProgramId int ,
	Status int,
	RequestedDate datetime,
	EnrolledDate datetime,
	DischargedDate datetime,
	PrimaryAssignment char(1) ,
	CreatedBy varchar(30) ,
	CreatedDate datetime ,
	ModifiedBy varchar(30) ,
	ModifiedDate datetime ,
	RecordDeleted char(1),
	DeletedDate datetime,
	DeletedBy varchar(30),
	AssignedStaffId int
)

if not exists (
	select *
	from dbo.ClientPrograms as cp
	where cp.ClientId = @ClientId
	and cp.ProgramId = @ProgramId
	and cp.Status in (1,3,4)
	and ISNULL(cp.RecordDeleted, ''N'') <> ''Y''
)
begin
	insert into dbo.ClientPrograms 
			(
			 ClientId,
			 ProgramId,
			 Status,
			 RequestedDate,
			 EnrolledDate,
			 DischargedDate,
			 PrimaryAssignment,
			 Comment,
			 AssignedStaffId
			)
	output inserted.ClientId, inserted.ClientProgramId, inserted.AssignedStaffId, inserted.EnrolledDate
	into @tabAssignments(ClientId, ClientProgramId, AssignedStaffId, EnrolledDate)
	values (
		@ClientId,
		@ProgramId, 
		4,	-- enrolled
		@RequestedDate,
		@EnrollmentDate,
		null,
		@PrimaryAssignment,	-- Primary Assignment
		''Created as result of referral or transfer to program.'',
		@AssignedStaff
	)
end
else
begin
	-- if not already enrolled, update the status of the current program assignement to enroled
	update dbo.ClientPrograms set
		EnrolledDate = @EnrollmentDate,
		Status = 4,
		PrimaryAssignment = @PrimaryAssignment,
		AssignedStaffId = @AssignedStaff
	output inserted.ClientId, inserted.ClientProgramId, inserted.AssignedStaffId, inserted.EnrolledDate
	into @tabAssignments(ClientId, ClientProgramId, AssignedStaffId, EnrolledDate)
	where ClientId = @ClientId
	and ProgramId = @ProgramId
	and Status in (1,3)
	and ISNULL(RecordDeleted, ''N'') <> ''Y''
	
end

-- write a history record for the new/updated assignment
insert into dbo.ClientProgramHistory
		(
		 ClientProgramId,
		 Status,
		 RequestedDate,
		 EnrolledDate,
		 DischargedDate,
		 PrimaryAssignment,
		 CreatedBy,
		 CreatedDate,
		 ModifiedBy,
		 ModifiedDate,
		 RecordDeleted,
		 DeletedDate,
		 DeletedBy,
		 AssignedStaffId
		)
select
	cp.ClientProgramId,
	cp.Status,
	cp.RequestedDate,
	cp.EnrolledDate,
	cp.DischargedDate,
	cp.PrimaryAssignment,
	cp.CreatedBy,
	cp.CreatedDate,
	cp.ModifiedBy,
	cp.ModifiedDate,
	cp.RecordDeleted,
	cp.DeletedDate,
	cp.DeletedBy,
	cp.AssignedStaffId
from dbo.ClientPrograms as cp
join @tabAssignments as t on t.ClientProgramId = cp.ClientProgramId


-- only one primary assignment allowed
if @PrimaryAssignment = ''Y''
begin
	update cp set
		PrimaryAssignment = ''N''
	output 
		 inserted.ClientProgramId,
		 inserted.Status,
		 inserted.RequestedDate,
		 inserted.EnrolledDate,
		 inserted.DischargedDate,
		 inserted.PrimaryAssignment,
		 inserted.CreatedBy,
		 inserted.CreatedDate,
		 inserted.ModifiedBy,
		 inserted.ModifiedDate,
		 inserted.RecordDeleted,
		 inserted.DeletedDate,
		 inserted.DeletedBy,
		 inserted.AssignedStaffId
	into @tabProgramHistory
		(
		 ClientProgramId,
		 Status,
		 RequestedDate,
		 EnrolledDate,
		 DischargedDate,
		 PrimaryAssignment,
		 CreatedBy,
		 CreatedDate,
		 ModifiedBy,
		 ModifiedDate,
		 RecordDeleted,
		 DeletedDate,
		 DeletedBy,
		 AssignedStaffId
		)
	from dbo.ClientPrograms as cp
	join @tabAssignments as t on t.ClientId = cp.ClientId
	where cp.ClientProgramId <> t.ClientProgramId
	--and cp.EnrolledDate <= t.EnrolledDate
	and cp.PrimaryAssignment = ''Y''
	
	-- write a history record for the udated program assignments
	insert into dbo.ClientProgramHistory
	        (
	         ClientProgramId,
	         Status,
	         RequestedDate,
	         EnrolledDate,
	         DischargedDate,
	         PrimaryAssignment,
	         CreatedBy,
	         CreatedDate,
	         ModifiedBy,
	         ModifiedDate,
	         RecordDeleted,
	         DeletedDate,
	         DeletedBy,
	         AssignedStaffId
	        )
	select
		 ClientProgramId,
		 Status,
		 RequestedDate,
		 EnrolledDate,
		 DischargedDate,
		 PrimaryAssignment,
		 CreatedBy,
		 CreatedDate,
		 ModifiedBy,
		 ModifiedDate,
		 RecordDeleted,
		 DeletedDate,
		 DeletedBy,
		 AssignedStaffId
	from @tabProgramHistory
end



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
