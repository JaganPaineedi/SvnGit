/****** Object:  StoredProcedure [dbo].[csp_CustomDocumentReferralWorkflow]    Script Date: 03/31/2014 21:14:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomDocumentReferralWorkflow]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomDocumentReferralWorkflow]
GO

/****** Object:  StoredProcedure [dbo].[csp_CustomDocumentReferralWorkflow]    Script Date: 03/31/2014 21:14:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[csp_CustomDocumentReferralWorkflow]
	@ScreenKeyId int,
	@StaffId int,
	@CurrentUser varchar(30),
	@CustomParameters xml
/****************************************************************/
-- PROCEDURE: csp_CustomDocumentReferralWorkflow
-- PURPOSE: Handles the workflow for custom referral documents.
-- CALLED BY: SmartCare on post-update (signature)
-- REVISION HISTORY:
--		2011.07.19 - T. Remisoski - Created.
--		2012.07.27 - T. Remisoski - Removed psychological testing from list of auto-accept codes
--		2012.11.10 - T. Remisoski - Added psych testing back to the list of auto-accept codes (removed from assessment)
--		2012.11.29 - T. Remisoski - Removed psych testing COMPLETELY from the list of auto-accept codes (sigh).
--		2012.12.22 - T. Remisoski - Added program enrollment, if selected by the author
/****************************************************************/

as
-- This procedure fires when the author signs the document

begin try

declare @StatusNotSent int, @StatusSent int, @StatusComplete int
declare @ActionAccept int, @ActionReject int, @ActionForward int

-- We keep getting burned by having different code-ids between systems so we will init these each time based on category/codename
select @StatusNotSent = GlobalCodeId from GlobalCodes where Category = 'REFERRALSTATUS' and CodeName = 'Not Sent'
select @StatusSent = GlobalCodeId from GlobalCodes where Category = 'REFERRALSTATUS' and CodeName = 'Sent'
select @StatusComplete = GlobalCodeId from GlobalCodes where Category = 'REFERRALSTATUS' and CodeName = 'Complete'

select @ActionAccept = GlobalCodeId from GlobalCodes where Category = 'RECEIVINGACTION' and CodeName = 'Accept'
select @ActionReject = GlobalCodeId from GlobalCodes where Category = 'RECEIVINGACTION' and CodeName = 'Reject'
select @ActionForward = GlobalCodeId from GlobalCodes where Category = 'RECEIVINGACTION' and CodeName = 'Forward'

declare @AutoApproveReferralAuthorizationCodes table (
	AuthorizationCodeId int
)
insert into @AutoApproveReferralAuthorizationCodes
        (AuthorizationCodeId)	-- from AuthorizationCodes table
values 
	(10),	--	Developmental Pediatric Consultation
	(11),	--	Integrated Primary Care
	(13),	--	Pharmacologic Management
	(14)	--	Psychiatric Evaluation
	-- 2012.11.29 - ter - removed psych testing
	-- (15)	--	Psychological Testing


declare @RemoveClientFromCaseLoad char(1)

-- ScreenKeyId is defined as the DocumentId
declare
	@DocumentVersionId int, @CurrentStatus int, @ReceivingStaffId int, @ReceivingAction int,
	@ReceivingProgram int,	@ReferringStaffId int, @MaxSignatureOrder int, @ClientId int, 
	@PreviousAuthorId int, @ProgramRequestedDate datetime, @ProgramEnrollmentDate datetime
select
	@DocumentVersionId = d.CurrentDocumentVersionId,
	@CurrentStatus = r.ReferralStatus,
	@ReceivingStaffId = r.ReceivingStaff,
	@ReceivingAction = r.ReceivingAction,
	@ReceivingProgram = r.ReceivingProgram,
	@ReferringStaffId = r.ReferringStaff,
	@ClientId = d.ClientId,
	@PreviousAuthorId = d.AuthorId,
	@ProgramRequestedDate = d.CreatedDate,
	@ProgramEnrollmentDate = d.EffectiveDate,
	@RemoveClientFromCaseLoad = r.RemoveClientFromCaseLoad
from Documents as d
join CustomDocumentReferrals as r on r.DocumentVersionId = d.CurrentDocumentVersionId
where d.DocumentId = @ScreenKeyId

if @DocumentVersionId is null raiserror('This procedure requires a current document version', 16, 1)
if @CurrentStatus is null raiserror('Referral status cannot be empty for a signed referral', 16, 1)
if @ReceivingStaffId is null raiserror('Receiving staff cannot be empty for a signed referral', 16, 1)
if @ReceivingAction is null and  @CurrentStatus  <> @StatusNotSent raiserror('Receiving action cannot be empty for a signed referral', 16, 1)

if @CurrentStatus = @StatusNotSent
begin


	begin tran

	begin
		-- reset the signature, set the author to the receiving staff and set the document status back to in-progress, mark the referral as "sent"
		
		update DocumentSignatures set 
			StaffId = @ReceivingStaffId,
			SignerName = null,
			SignatureDate = null,
			VerificationMode = null,
			PhysicalSignature = null,
			DeclinedSignature = null,
			ClientSignedPaper = null
		where DocumentId = @ScreenKeyId
		and StaffId = @ReferringStaffId
		and ISNULL(RecordDeleted, 'N') <> 'Y'
		
		-- Check whether TRIGGER enabled on Documents Table, then disable the TRIGGER
		IF EXISTS(SELECT * 
          FROM   [sys].[triggers] AS TRIG 
                 INNER JOIN sys.tables AS TAB 
                         ON TRIG.parent_id = TAB.object_id 
                            AND TAB.name = 'Documents' 
                            AND TRIG.is_disabled = 0) 
		BEGIN 
		  DISABLE TRIGGER ALL ON documents 
		END	
	
		update Documents set
			AuthorId = @ReceivingStaffId,
			Status = 21,
			CurrentVersionStatus = 21
		where DocumentId = @ScreenKeyId
		and ISNULL(RecordDeleted, 'N') <> 'Y'
		
		-- ENABLE the TRIGGERS BACK
		IF EXISTS(SELECT * 
          FROM   [sys].[triggers] AS TRIG 
                 INNER JOIN sys.tables AS TAB 
                         ON TRIG.parent_id = TAB.object_id 
                            AND TAB.name = 'Documents' 
                            AND TRIG.is_disabled = 1) 
		BEGIN 
		  ENABLE TRIGGER ALL ON documents 
		END	
	
		update CustomDocumentReferrals set
			ReferralStatus = @StatusSent
		where DocumentVersionId = @DocumentVersionId
		
		exec dbo.csp_CustomDocumentReferralTransferAlert @DocumentId = @ScreenKeyId, -- int
			@ClientId = @ClientId, -- int
			@RecipientStaffId = @ReceivingStaffId, -- int
			@Subject = 'New Referral Document Sent', -- varchar(700)
			@Message = 'A new referral document has been sent and is awaiting your response.  Click the document reference link to edit to respond.' -- varchar(3000)
	end
	commit tran

end
else if @CurrentStatus = @StatusSent
begin

	if @ReceivingAction = @ActionForward
	begin
		-- if all services on the referral are "auto-approved" services, just mark the document as compeleted
		if (0 < (select COUNT(*) from dbo.CustomDocumentReferralServices as rs join @AutoApproveReferralAuthorizationCodes as a on a.AuthorizationCodeId = rs.AuthorizationCodeId where rs.DocumentVersionId = @DocumentVersionId and ISNULL(rs.RecordDeleted, 'N') <> 'Y'))
		and (0 = (select COUNT(*) from dbo.CustomDocumentReferralServices as rs where rs.DocumentVersionId = @DocumentVersionId and ISNULL(rs.RecordDeleted, 'N') <> 'Y' and not exists (select * from @AutoApproveReferralAuthorizationCodes as a where a.AuthorizationCodeId = rs.AuthorizationCodeId)))
		begin

			update CustomDocumentReferrals set
				ReferralStatus = @StatusComplete,
				ReceivingComment = 'Services on the referral are configured for "auto-acceptance".',
				ReceivingAction = @ActionAccept,
				ReceivingActionDate = GETDATE()			
			where DocumentVersionId = @DocumentVersionId
		end
		else
		begin
			-- reset the signature, set the author to the receiving staff and set the document status back to in-progress, mark the referral as "sent"
			begin tran
			
			update DocumentSignatures set 
				StaffId = @ReceivingStaffId,
				SignerName = null,
				SignatureDate = null,
				VerificationMode = null,
				PhysicalSignature = null,
				DeclinedSignature = null,
				ClientSignedPaper = null
			where DocumentId = @ScreenKeyId
			and StaffId = @ReferringStaffId
			and ISNULL(RecordDeleted, 'N') <> 'Y'
		
			-- Check whether TRIGGER enabled on Documents Table, then disable the TRIGGER
			IF EXISTS(SELECT * 
			  FROM   [sys].[triggers] AS TRIG 
					 INNER JOIN sys.tables AS TAB 
							 ON TRIG.parent_id = TAB.object_id 
								AND TAB.name = 'Documents' 
								AND TRIG.is_disabled = 0) 
			BEGIN 
			  DISABLE TRIGGER ALL ON documents 
			END	
	
	
			update Documents set
				AuthorId = @ReceivingStaffId,
				Status = 21,
				CurrentVersionStatus = 21
			where DocumentId = @ScreenKeyId
			and ISNULL(RecordDeleted, 'N') <> 'Y'
			
			-- ENABLE the TRIGGERS BACK
			IF EXISTS(SELECT * 
			  FROM   [sys].[triggers] AS TRIG 
					 INNER JOIN sys.tables AS TAB 
							 ON TRIG.parent_id = TAB.object_id 
								AND TAB.name = 'Documents' 
								AND TRIG.is_disabled = 1) 
			BEGIN 
			  ENABLE TRIGGER ALL ON documents 
			END	
	
	
			update CustomDocumentReferrals set
				ReferralStatus = @StatusSent
			where DocumentVersionId = @DocumentVersionId
			
			exec dbo.csp_CustomDocumentReferralTransferAlert @DocumentId = @ScreenKeyId, -- int
				@ClientId = @ClientId, -- int
				@RecipientStaffId = @ReceivingStaffId, -- int
				@Subject = 'Forwarded Referral Document Sent', -- varchar(700)
				@Message = 'A referral document has been forwarded and is awaiting your response.  Click the document reference link to edit to respond.' -- varchar(3000)

			commit tran
		end
	end
	else if @ReceivingAction in (@ActionAccept, @ActionReject)
	begin
		-- in both cases, just need to notify the referring staff and add the referring staff as a co-signer
		begin tran
		
		update CustomDocumentReferrals set
			ReferralStatus = @StatusComplete
		where DocumentVersionId = @DocumentVersionId

		update ds set
			SignatureDate = ISNULL(ds.SignatureDate, GETDATE()),
			SignerName = ISNULL(ds.SignerName, ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '') + case when s.SigningSuffix is not null then ', ' + s.SigningSuffix else '' end),
			VerificationMode = ISNULL(ds.VerificationMode, 'P'),
			RevisionNumber = ISNULL(ds.RevisionNumber, 1)
		from dbo.DocumentSignatures as ds
		join dbo.Staff as s on s.StaffId = ds.StaffId
		where ds.DocumentId = @ScreenKeyId
		and ds.SignedDocumentVersionId = @DocumentVersionId
		and ds.SignatureOrder = 1
		and ISNULL(ds.RecordDeleted, 'N') <> 'Y'

		if @ReceivingAction = @ActionAccept
		begin
			-- create program assignment, if applicable
			-- 2012.12.22 - TER - Create a new program enrollment if neccessary
			if @ReceivingProgram is not null
				exec csp_TransferReferralWorkFlowCreateProgramEnrollment
					@ClientId,
					@ReceivingProgram,				-- Program
					@ProgramRequestedDate,			-- date program requested
					@ProgramEnrollmentDate,			-- date program enrolled
					@ReceivingStaffId ,				-- Staff Id assigned to the program enrollment
					'N'								-- indicates whether this assignment is to become primary
					
								
			-- add the client to the receiving clinican's caseload
			insert into dbo.CustomTreatmentTeamMembers
			        (
			         ClientId,
			         StaffId
			        )
			 select @ClientId, @ReceivingStaffId
			 where not exists (
				select *
				from dbo.CustomTreatmentTeamMembers as a
				where a.ClientId = @ClientId
				and a.StaffId = @ReceivingStaffId
				and ISNULL(a.RecordDeleted, 'N') <> 'Y'
			)
		
			-- remove client from sending clinician's caseload if specified
			if @RemoveClientFromCaseLoad = 'Y'
			begin
				update dbo.CustomTreatmentTeamMembers set
					RecordDeleted = 'Y',
					DeletedBy = 'REFERRAL',
					DeletedDate = GETDATE()
				where ClientId = @ClientId
				and StaffId = @ReferringStaffId
				and ISNULL(RecordDeleted, 'N') <> 'Y'
				
			end
			exec dbo.csp_CustomDocumentReferralTransferAlert @DocumentId = @ScreenKeyId, -- int
				@ClientId = @ClientId, -- int
				@RecipientStaffId = @ReferringStaffId, -- int
				@Subject = 'Referral Accepted',
				@Message = 'A referral document has been accepted by the receiving staff member.  Click the link to open the document.'
			
		end
		else if @ReceivingAction = @ActionReject
		begin
			exec dbo.csp_CustomDocumentReferralTransferAlert @DocumentId = @ScreenKeyId, -- int
				@ClientId = @ClientId, -- int
				@RecipientStaffId = @ReferringStaffId, -- int
				@Subject = 'Referral Rejected',
				@Message = 'A Referral document has been rejected by the receiving staff member.  Click the link to open the document.'
		end
		
		
		commit tran
	end
end


end try
begin catch

declare @errorMessage nvarchar(4000)
set @errorMessage = ERROR_MESSAGE()

raiserror(@errorMessage, 16, 1)

end catch


GO


