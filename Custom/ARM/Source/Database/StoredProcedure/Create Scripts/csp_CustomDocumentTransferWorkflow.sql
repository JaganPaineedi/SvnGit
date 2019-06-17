/****** Object:  StoredProcedure [dbo].[csp_CustomDocumentTransferWorkflow]    Script Date: 03/31/2014 21:04:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomDocumentTransferWorkflow]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomDocumentTransferWorkflow]
GO

/****** Object:  StoredProcedure [dbo].[csp_CustomDocumentTransferWorkflow]    Script Date: 03/31/2014 21:04:47 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO



CREATE procedure [dbo].[csp_CustomDocumentTransferWorkflow]
	@ScreenKeyId int,
	@StaffId int,
	@CurrentUser varchar(30),
	@CustomParameters xml
/****************************************************************/
-- PROCEDURE: csp_CustomDocumentTransferWorkflow
-- PURPOSE: Handles the workflow for custom transfer documents.
-- CALLED BY: SmartCare on post-update (signature)
-- REVISION HISTORY:
--		2011.07.19 - T. Remisoski - Created.
--		2012.02.01 - Updated logic for acceptance
--		2012.12.22 - T. Remisoski - added logic to create/update program enrollment
-- 		2014.03.31 - S Bhowmik - Added Enable/Disable Triggers before 'Update Documents'
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

-- ScreenKeyId is defined as the DocumentId
declare @DocumentVersionId int, @CurrentStatus int, @ReceivingStaffId int, @ReceivingAction int,
	@ReceivingProgram int,	@TransferringStaffId int, @MaxSignatureOrder int, @ClientId int, 
	@PreviousAuthorId int, @ProgramRequestedDate datetime, @ProgramEnrollmentDate datetime

declare @ReviewingStaffId int

select
	@DocumentVersionId = d.CurrentDocumentVersionId,
	@CurrentStatus = r.TransferStatus,
	@ReceivingStaffId = r.ReceivingStaff,
	@ReceivingAction = r.ReceivingAction,
	@ReceivingProgram = r.ReceivingProgram,
	@TransferringStaffId = r.TransferringStaff,
	@ClientId = d.ClientId,
	@PreviousAuthorId = d.AuthorId,
	@ProgramRequestedDate = d.CreatedDate,
	@ProgramEnrollmentDate = d.EffectiveDate
from Documents as d
join CustomDocumentTransfers as r on r.DocumentVersionId = d.CurrentDocumentVersionId
where d.DocumentId = @ScreenKeyId

if @DocumentVersionId is null raiserror('This procedure requires a current document version', 16, 1)
if @CurrentStatus is null raiserror('Transfer status cannot be empty for a signed transfer', 16, 1)
if @ReceivingStaffId is null raiserror('Receiving staff cannot be empty for a signed transfer', 16, 1)
if @ReceivingAction is null and  @CurrentStatus  <> @StatusNotSent  raiserror('Receiving action cannot be empty for a signed transfer', 16, 1)

if @CurrentStatus = @StatusNotSent
begin

	-- reset the signature, set the author to the receiving staff and set the document status back to in-progress, mark the transfer as "sent"
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
	and StaffId = @TransferringStaffId
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
	
	update CustomDocumentTransfers set
		TransferStatus = @StatusSent
	where DocumentVersionId = @DocumentVersionId
	
	exec dbo.csp_CustomDocumentReferralTransferAlert @DocumentId = @ScreenKeyId, -- int
	    @ClientId = @ClientId, -- int
	    @RecipientStaffId = @ReceivingStaffId, -- int
	    @Subject = 'New Transfer Document Sent', -- varchar(700)
	    @Message = 'A new transfer document has been sent and is awaiting your response.  Click the document reference link to edit to respond.' -- varchar(3000)
	
	commit tran

end
else if @CurrentStatus = @StatusSent
begin
	-- remove the extra signature from the Document
	if exists (select * from dbo.Documents as d where d.DocumentId = @ScreenKeyId and d.CurrentVersionStatus = 25)
	begin

		begin tran
		
		select @ReviewingStaffId = ReviewerId
		from dbo.Documents as d
		where d.DocumentId = @ScreenKeyId

		delete from ds
		from dbo.DocumentVersions as dv
		join dbo.Documents as d on d.DocumentId = dv.DocumentId
		join dbo.DocumentSignatures as ds on ds.DocumentId = d.DocumentId
		join dbo.CustomDocumentTransfers as t on t.DocumentVersionId = dv.DocumentVersionId
		where dv.DocumentVersionId = @DocumentVersionId
		and ds.StaffId = @ReviewingStaffId
		and ds.SignatureDate is null

		commit tran
	end

	if @ReceivingAction = @ActionForward
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
		and StaffId = @PreviousAuthorId
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
	
		update CustomDocumentTransfers set
			TransferStatus = @StatusSent
		where DocumentVersionId = @DocumentVersionId

		exec dbo.csp_CustomDocumentReferralTransferAlert @DocumentId = @ScreenKeyId, -- int
			@ClientId = @ClientId, -- int
			@RecipientStaffId = @ReceivingStaffId, -- int
			@Subject = 'Forwarded Transfer Document Sent', -- varchar(700)
			@Message = 'A transfer document has been forwarded and is awaiting your response.  Click the document reference link to edit to respond.' -- varchar(3000)
		
		commit tran
	end
	else if @ReceivingAction in (@ActionAccept, @ActionReject)
	begin
		-- in both cases, just need to notify the referring staff and add the referring staff as a co-signer
		begin tran

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
			Status = 22,
			CurrentVersionStatus = 22
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
	

		update CustomDocumentTransfers set
			TransferStatus = @StatusComplete
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
			-- set the client's primary clinician to the receiving staff
			update dbo.Clients set PrimaryClinicianId = @ReceivingStaffId where ClientId = @ClientId

			-- 2012.12.22 - TER - Create a new program enrollment if neccessary
			if @ReceivingProgram is not null
				exec csp_TransferReferralWorkFlowCreateProgramEnrollment
					@ClientId,
					@ReceivingProgram,				-- Program
					@ProgramRequestedDate,			-- date program requested
					@ProgramEnrollmentDate,			-- date program enrolled
					@ReceivingStaffId ,				-- Staff Id assigned to the program enrollment
					'Y'								-- indicates whether this assignment is to become primary

			exec dbo.csp_CustomDocumentReferralTransferAlert @DocumentId = @ScreenKeyId, -- int
				@ClientId = @ClientId, -- int
				@RecipientStaffId = @TransferringStaffId, -- int
				@Subject = 'Transfer Accepted',
				@Message = 'A transfer document has been accepted by the receiving staff member.  Click the link to open the document.'
		end
		else if @ReceivingAction = @ActionReject
		begin
			exec dbo.csp_CustomDocumentReferralTransferAlert @DocumentId = @ScreenKeyId, -- int
				@ClientId = @ClientId, -- int
				@RecipientStaffId = @TransferringStaffId, -- int
				@Subject = 'Transfer Rejected',
				@Message = 'A transfer document has been rejected by the receiving staff member.  Click the link to open the document.'
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


