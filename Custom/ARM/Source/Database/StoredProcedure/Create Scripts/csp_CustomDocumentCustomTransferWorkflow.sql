/****** Object:  StoredProcedure [dbo].[csp_CustomDocumentCustomTransferWorkflow]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomDocumentCustomTransferWorkflow]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomDocumentCustomTransferWorkflow]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomDocumentCustomTransferWorkflow]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_CustomDocumentCustomTransferWorkflow]
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
/****************************************************************/

as
-- This procedure fires when the author signs the document

begin try
-- NOTE TO DEVELOPER:
-- replace these with the actual global codes values
declare @StatusNotSent int = 20527, @StatusSent int = 20526, @StatusComplete int = 20538
declare @ActionAccept int = 20536, @ActionReject int = 20537, @ActionForward int = 20539

-- ScreenKeyId is defined as the DocumentId
declare @DocumentVersionId int, @CurrentStatus int, @ReceivingStaffId int, @ReceivingAction int, @TransferringStaffId int, @MaxSignatureOrder int

select
	@DocumentVersionId = d.CurrentDocumentVersionId,
	@CurrentStatus = r.TransferStatus,
	@ReceivingStaffId = r.ReceivingStaff,
	@ReceivingAction = r.ReceivingAction,
	@TransferringStaffId = r.TransferringStaff
from Documents as d
join CustomDocumentTransfers as r on r.DocumentVersionId = d.CurrentDocumentVersionId
where d.DocumentId = @ScreenKeyId

if @DocumentVersionId is null raiserror(''This procedure requires a current document version'', 16, 1)
if @CurrentStatus is null raiserror(''Referral status cannot be empty for a signed referral'', 16, 1)
if @ReceivingStaffId is null raiserror(''Receiving staff cannot be empty for a signed referral'', 16, 1)
if @ReceivingAction is null and  @CurrentStatus  <> @StatusNotSent  raiserror(''Receiving action cannot be empty for a signed referral'', 16, 1)

if @CurrentStatus = @StatusNotSent
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
	and StaffId = @TransferringStaffId
	and ISNULL(RecordDeleted, ''N'') <> ''Y''
	
	update Documents set
		AuthorId = @ReceivingStaffId,
		Status = 21
	where DocumentId = @ScreenKeyId
	and ISNULL(RecordDeleted, ''N'') <> ''Y''
	
	update CustomDocumentTransfers set
		TransferStatus = @StatusSent
	where DocumentVersionId = @DocumentVersionId
	
	commit tran

end
else if @CurrentStatus = @StatusSent
begin

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
		and StaffId = @TransferringStaffId
		and ISNULL(RecordDeleted, ''N'') <> ''Y''
		
		update Documents set
			AuthorId = @ReceivingStaffId,
			Status = 21
		where DocumentId = @ScreenKeyId
		and ISNULL(RecordDeleted, ''N'') <> ''Y''
		
		update CustomDocumentTransfers set
			TransferStatus  = @StatusSent
		where DocumentVersionId = @DocumentVersionId
		
		commit tran
	end
	else if @ReceivingAction in (@ActionAccept, @ActionReject)
	begin
		-- in both cases, just need to notify the referring staff and add the referring staff as a co-signer
		begin tran
		
		update CustomDocumentTransfers set
			TransferStatus = @StatusComplete
		where DocumentVersionId = @DocumentVersionId

		select @MaxSignatureOrder = MAX(SignatureOrder)
		from DocumentSignatures
		where DocumentId = @ScreenKeyId
		and ISNULL(RecordDeleted, ''N'') <> ''Y''

		set @MaxSignatureOrder = isnull(@MaxSignatureOrder, 0) + 1
		
		insert into DocumentSignatures (
			DocumentId,
			SignedDocumentVersionId,
			StaffId,
			ClientId,
			IsClient,
			RelationToClient,
			RelationToAuthor,
			SignerName,
			SignatureOrder,
			SignatureDate,
			VerificationMode,
			PhysicalSignature,
			DeclinedSignature,
			ClientSignedPaper,
			RevisionNumber
		) values (
			@ScreenKeyId,
			@DocumentVersionId,
			@TransferringStaffId,
			null,
			''N'',
			null,
			null,
			null,
			@MaxSignatureOrder,
			null,
			null,
			null,
			null,
			null,
			null
		)
		
		commit tran
	end
end


end try
begin catch

declare @errorMessage nvarchar(4000)
set @errorMessage = ERROR_MESSAGE()

raiserror(@errorMessage, 16, 1)

end catch

' 
END
GO
