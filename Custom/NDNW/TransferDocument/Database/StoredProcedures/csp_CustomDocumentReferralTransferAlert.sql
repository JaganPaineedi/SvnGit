

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomDocumentReferralTransferAlert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomDocumentReferralTransferAlert]
GO

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE procedure [dbo].[csp_CustomDocumentReferralTransferAlert]
	@DocumentId int,
	@ClientId int,
	@RecipientStaffId int,
	@Subject varchar(700),
	@Message varchar(3000)
/****************************************************************/
-- PROCEDURE: csp_CustomDocumentReferralTransferAlert
-- PURPOSE: Creates an alert to a staff with the specified subject and message.
-- CALLED BY: csp_CustomDocumentReferralWorkflow and csp_CustomDocumentTransferWorkflow
-- REVISION HISTORY:
--		
/****************************************************************/
as
begin try
begin tran

 declare @documentcodeid int;
   select @documentcodeid = DocumentCodeId  from Documents where DocumentId = @DocumentId
if(@documentcodeid <> 100)
begin
insert into dbo.Alerts
        (
         ToStaffId,
         ClientId,
         AlertType,
         Unread,
         DateReceived,
         Subject,
         Message,
         Reference,
         ReferenceLink,
         DocumentId
        )
values  (
         @RecipientStaffId, -- ToStaffId - int
         @ClientId, -- ClientId - int
         81, -- AlertType - type_GlobalCode
         'Y', -- Unread - type_YOrN
         GETDATE(), -- DateReceived - datetime
         @Subject, -- Subject - varchar(700)
         @Message, -- Message - varchar(3000)
         CAST(@DocumentId as varchar), -- Reference - varchar(150)
         CAST(@DocumentId as varchar), -- ReferenceLink - varchar(150)
         @DocumentId
        )
   end   
  
   if(@documentcodeid = 16106 and @Subject = 'Transfer Accepted')
   begin
   declare @staffs as table
   (
   staffid int
   );
      insert into @staffs   SELECT    dbo.Staff.StaffId    
  FROM         dbo.Staff  
               INNER JOIN      
               dbo.StaffRoles ON dbo.Staff.StaffId = dbo.StaffRoles.StaffId  
               INNER JOIN GlobalCodes gc on gc.GlobalCodeId = dbo.StaffRoles.RoleId  
               where gc.Category = 'STAFFROLE' and  gc.CodeName  =  'Medical Records' and isnull(gc.RecordDeleted,'N')<>'Y' and isnull(gc.Active,'Y') = 'Y' and isnull(dbo.StaffRoles.RecordDeleted,'N')<>'Y' and isnull(dbo.Staff.Active,'Y')='Y' and isnull(dbo.Staff.RecordDeleted,'N')<>'Y'  and Staff.StaffId <>@RecipientStaffId
         
         insert into dbo.Alerts
        (
         ToStaffId,
         ClientId,
         AlertType,
         Unread,
         DateReceived,
         Subject,
         Message,
         Reference,
         ReferenceLink,
         DocumentId
        )
select 
         staffid, -- ToStaffId - int
         @ClientId, -- ClientId - int
         81, -- AlertType - type_GlobalCode
         'Y', -- Unread - type_YOrN
         GETDATE(), -- DateReceived - datetime
         @Subject, -- Subject - varchar(700)
         @Message, -- Message - varchar(3000)
         CAST(@DocumentId as varchar), -- Reference - varchar(150)
         CAST(@DocumentId as varchar), -- ReferenceLink - varchar(150)
         @DocumentId
        from @staffs
               
     end
  if(@documentcodeid = 100)
     begin
     declare @staffstemp as table
   (
   staffid int
   );
      insert into @staffstemp   SELECT    dbo.Staff.StaffId    
  FROM         dbo.Staff  
               INNER JOIN      
               dbo.StaffRoles ON dbo.Staff.StaffId = dbo.StaffRoles.StaffId  
               INNER JOIN GlobalCodes gc on gc.GlobalCodeId = dbo.StaffRoles.RoleId  
               where gc.Category = 'STAFFROLE' and  gc.CodeName  =  'Medical Records' and isnull(gc.RecordDeleted,'N')<>'Y' and isnull(gc.Active,'Y') = 'Y' and isnull(dbo.StaffRoles.RecordDeleted,'N')<>'Y' and isnull(dbo.Staff.Active,'Y')='Y' and isnull(dbo.Staff.RecordDeleted,'N')<>'Y' 
         
         insert into dbo.Alerts
        (
         ToStaffId,
         ClientId,
         AlertType,
         Unread,
         DateReceived,
         Subject,
         Message,
         Reference,
         ReferenceLink,
         DocumentId
        )
select 
         staffid, -- ToStaffId - int
         @ClientId, -- ClientId - int
         81, -- AlertType - type_GlobalCode
         'Y', -- Unread - type_YOrN
         GETDATE(), -- DateReceived - datetime
         @Subject, -- Subject - varchar(700)
         @Message, -- Message - varchar(3000)
         CAST(@DocumentId as varchar), -- Reference - varchar(150)
         CAST(@DocumentId as varchar), -- ReferenceLink - varchar(150)
         @DocumentId
        from @staffstemp
     end
commit tran
end try
begin catch
if @@TRANCOUNT > 0 rollback tran

declare @errorMessage nvarchar(4000)
set @errorMessage = ERROR_MESSAGE()

raiserror(@errorMessage, 16, 1)

end catch
GO