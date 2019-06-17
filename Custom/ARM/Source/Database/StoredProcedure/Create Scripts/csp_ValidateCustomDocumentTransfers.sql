/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentTransfers]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentTransfers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentTransfers]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[csp_ValidateCustomDocumentTransfers]  
 @DocumentVersionId int  
/****************************************************************/  
-- PROCEDURE: [csp_ValidateCustomDocumentTransfers]  
-- PURPOSE: Handles the validation for custom transfer documents.  
-- CALLED BY: SmartCare on post-update (signature)  
-- REVISION HISTORY:  
--  2011.07.19 - T. Remisoski - Created.  
--Modified by Veena  added validation for LevelOfCare for ARM Customization  
-- 19-01-2018 Remove one validation Because customer do not need For Task #801 ARM-Support 
-- 10-31-2018 Hemant csp copied from ARM prod to commit the latest changes in SVN.A Renewed Mind - Support #972
-- 28-09-2018 Modified by Shivam added validation for Transfer Document,For A Renewed Mind - Support#971
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
 select 'CustomDocumentTransfers', 'TransferringStaff', 'Transferring staff selection required', '', ''  
 from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and TransferringStaff is null  
 union  
 select 'CustomDocumentTransfers', 'ReceivingStaff', 'Receiving staff selection required', '', ''  
 from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and ReceivingStaff is null  
 union  
 select 'CustomDocumentTransfers', 'AssessedNeedForTransfer', 'Assessed need for transfer required', '', ''  
 from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and LEN(ISNULL(LTRIM(RTRIM(AssessedNeedForTransfer)), '')) = 0  
 union  
 select 'CustomDocumentTransfers', 'ClientParticpatedWithTransfer', 'Client particpation required', '', ''  
 from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and ISNULL(ClientParticpatedWithTransfer, 'N') <> 'Y'  
 --union  
 --select 'CustomDocumentTransfers', 'DeletedBy', 'Receiving staff cannot be RN or LPN', '', ''  
 --from dbo.CustomDocumentTransfers as a  
 --join dbo.Staff as s on s.StaffId = a.ReceivingStaff  
 --where DocumentVersionId = @DocumentVersionId   
 --and s.Degree in (20940,20969)
 
 union  
 select 'CustomDocumentTransfers', 'LevelofCare', 'Current Level of Care is required', '', ''  
 from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and LevelofCare is null  
 
  if 0 = (select COUNT(*) from dbo.CustomDocumentTransferServices where DocumentVersionId = @DocumentVersionId and ISNULL(RecordDeleted, 'N') <> 'Y')  
  begin  
  Insert into #validationReturnTable (  
   TableName,    
   ColumnName,    
   ErrorMessage,    
   TabOrder,    
   ValidationOrder    
  )  
 select 'CustomDocumentTransfers', 'DeletedBy', 'At least one service must be selected for transfer.', '', '' 
 end  
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
 select 'CustomDocumentTransfers', 'TransferringStaff', 'Transferring staff selection required', '', ''  
 from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and TransferringStaff is null  
 union  
 select 'CustomDocumentTransfers', 'ReceivingStaff', 'Receiving staff selection required', '', ''  
 from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and ReceivingStaff is null  
 union  
 select 'CustomDocumentTransfers', 'AssessedNeedForTransfer', 'Assessed need for transfer required', '', ''  
 from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and LEN(ISNULL(LTRIM(RTRIM(AssessedNeedForTransfer)), '')) = 0  
 union  
 select 'CustomDocumentTransfers', 'ClientParticpatedWithTransfer', 'Client particpation required', '', ''  
 from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and ISNULL(ClientParticpatedWithTransfer, 'N') <> 'Y'  
 union  
 select 'CustomDocumentTransfers', 'ReceivingAction', 'Receiving action must be selected', '', ''  
 from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and ReceivingAction is null  
 union  
 select 'CustomDocumentTransfers', 'ReceivingComment', 'Comment required when rejecting a transfer', '', ''  
 from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and LEN(ISNULL(LTRIM(RTRIM(ReceivingComment)), '')) = 0  
 and ReceivingAction = @ActionReject  
 --union  
 --select 'CustomDocumentTransfers', 'DeletedBy', 'Receiving staff cannot be RN or LPN', '', ''  
 --from dbo.CustomDocumentTransfers as a  
 --join dbo.Staff as s on s.StaffId = a.ReceivingStaff  
 --where DocumentVersionId = @DocumentVersionId   
 --and s.Degree in (20940,20969)  
 --Added by Veena on 25/04/13 for ARM customization  
 union  
 select 'CustomDocumentTransfers', 'LevelofCare', 'Current Level of Care is required', '', ''  
 from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and LevelofCare is null  
   
  
end  