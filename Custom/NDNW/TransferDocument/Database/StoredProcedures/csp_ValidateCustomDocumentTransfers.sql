/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentTransfers]    Script Date: 01/11/2015 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentTransfers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentTransfers]
GO

/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentTransfers]    Script Date: 01/11/2015 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create procedure [dbo].[csp_ValidateCustomDocumentTransfers]
	@DocumentVersionId int
/****************************************************************/
-- PROCEDURE: [csp_ValidateCustomDocumentTransfers]
-- PURPOSE: Handles the validation for custom transfer documents.
-- CALLED BY: SmartCare on post-update (signature)
-- REVISION HISTORY:

/****************************************************************/

as

declare @StatusNotSent int, @StatusSent int, @StatusComplete int
declare @ActionAccept int, @ActionReject int, @ActionForward int

-- We keep getting burned by having different code-ids between systems so we will init these each time based on category/codename
select @StatusNotSent = GlobalCodeId from GlobalCodes where Category = 'REFERRALSTATUS' and CodeName = 'Not Sent'
select @StatusSent = GlobalCodeId from GlobalCodes where Category = 'REFERRALSTATUS' and CodeName = 'Sent'
select @StatusComplete = GlobalCodeId from GlobalCodes where Category = 'REFERRALSTATUS' and CodeName = 'Complete'

select @ActionAccept = GlobalCodeId from GlobalCodes where Category = 'RECEIVINGACTION' and CodeName = 'Accept'
select @ActionReject = GlobalCodeId from GlobalCodes where Category = 'RECEIVINGACTION' and CodeName = 'Reject'
select @ActionForward = GlobalCodeId from GlobalCodes where Category = 'RECEIVINGACTION' and CodeName = 'Forward'

declare @CurrentStatus int, @ReceivingStaffId int, @ReceivingAction int, @TransferringStaffId int

select
	@CurrentStatus = r.TransferStatus,
	@ReceivingStaffId = r.ReceivingStaff,
	@ReceivingAction = r.ReceivingAction,
	@TransferringStaffId = r.TransferringStaff
from CustomDocumentTransfers as r
where r.DocumentVersionId = @DocumentVersionId

-- Required when sending
if @CurrentStatus = @StatusNotSent
begin
	Insert into #validationReturnTable (
		TableName,  
		ColumnName,  
		ErrorMessage,  
		TabOrder,  
		ValidationOrder  
	)
	select 'CustomDocumentTransfers', 'ReceivingActionDate', 'Transfer Document-General- Request Date is required ', '', ''
	from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and ReceivingActionDate is null
	union 
	select 'CustomDocumentTransfers', 'TransferStatus', 'Transfer Document-General- Status is required', '', ''
	from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and TransferStatus is null
	union 
	select 'CustomDocumentTransfers', 'TransferringStaff', 'Transfer Document-General- From Staff is required ', '', ''
	from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and TransferringStaff is null
	union
	select 'CustomDocumentTransfers', 'ReceivingStaff', 'Transfer Document-General- Receiving Staff is required ', '', ''
	from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and ReceivingStaff is null
	union
	select 'CustomDocumentTransfers', 'ReceivingProgram', 'Transfer Document-General- Rec. Programing is required  ', '', ''
	from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and ReceivingProgram is null
	union
	select 'CustomDocumentTransfers', 'AssessedNeedForTransfer', 'Transfer Document-General- Reason/Assessed Need For Transfer is required ', '', ''
	from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and LEN(ISNULL(LTRIM(RTRIM(AssessedNeedForTransfer)), '')) = 0
	--union
	--select 'CustomDocumentTransfers', 'ClientParticpatedWithTransfer', 'Client particpation required', '', ''
	--from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and ISNULL(ClientParticpatedWithTransfer, 'N') <> 'Y'
	union
	select 'CustomDocumentTransfers', 'DeletedBy', 'Receiving staff cannot be RN or LPN', '', ''
	from dbo.CustomDocumentTransfers as a
	join dbo.Staff as s on s.StaffId = a.ReceivingStaff
	where DocumentVersionId = @DocumentVersionId 
	and s.Degree in (20940,20969)

	exec csp_ValidateCustomTransferServices @DocumentVersionId
end
else if @CurrentStatus = @StatusSent
begin
	Insert into #validationReturnTable (
		TableName,  
		ColumnName,  
		ErrorMessage,  
		TabOrder,  
		ValidationOrder  
	)
	select 'CustomDocumentTransfers', 'TransferringStaff', 'Transfer Document-General- From Staff is required ', '', ''
	from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and TransferringStaff is null
	union
	select 'CustomDocumentTransfers', 'ReceivingStaff', 'Transfer Document-General- Receiving Staff is required ', '', ''
	from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and ReceivingStaff is null
	union
	select 'CustomDocumentTransfers', 'AssessedNeedForTransfer', 'Transfer Document-General- Reason/Assessed Need For Transfer is required ', '', ''
	from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and LEN(ISNULL(LTRIM(RTRIM(AssessedNeedForTransfer)), '')) = 0
	--union
	--select 'CustomDocumentTransfers', 'ClientParticpatedWithTransfer', 'Client particpation required', '', ''
	--from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and ISNULL(ClientParticpatedWithTransfer, 'N') <> 'Y'
	union
	select 'CustomDocumentTransfers', 'ReceivingAction', 'Transfer Document-General- Receiving action is required', '', ''
	from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and ReceivingAction is null
	union
	select 'CustomDocumentTransfers', 'ReceivingComment', 'Comment required when rejecting a transfer', '', ''
	from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and LEN(ISNULL(LTRIM(RTRIM(ReceivingComment)), '')) = 0
	and ReceivingAction = @ActionReject
	union
	select 'CustomDocumentTransfers', 'DeletedBy', 'Receiving staff cannot be RN or LPN', '', ''
	from dbo.CustomDocumentTransfers as a
	join dbo.Staff as s on s.StaffId = a.ReceivingStaff
	where DocumentVersionId = @DocumentVersionId 
	and s.Degree in (20940,20969)

end



GO


