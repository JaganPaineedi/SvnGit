/****** Object:  StoredProcedure [dbo].[csp_CustomDocumentReferralTransferAlert]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomDocumentReferralTransferAlert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomDocumentReferralTransferAlert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomDocumentReferralTransferAlert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

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
--		2011.10.02 - T. Remisoski - Created.
/****************************************************************/
as
begin try
begin tran

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
         ''Y'', -- Unread - type_YOrN
         GETDATE(), -- DateReceived - datetime
         @Subject, -- Subject - varchar(700)
         @Message, -- Message - varchar(3000)
         CAST(@DocumentId as varchar), -- Reference - varchar(150)
         CAST(@DocumentId as varchar), -- ReferenceLink - varchar(150)
         @DocumentId
        )
        
commit tran
end try
begin catch
if @@TRANCOUNT > 0 rollback tran

declare @errorMessage nvarchar(4000)
set @errorMessage = ERROR_MESSAGE()

raiserror(@errorMessage, 16, 1)

end catch

' 
END
GO
