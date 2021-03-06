/****** Object:  StoredProcedure [dbo].[csp_AlertAdvanceNoticeReminder]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AlertAdvanceNoticeReminder]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_AlertAdvanceNoticeReminder]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AlertAdvanceNoticeReminder]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  Procedure [dbo].[csp_AlertAdvanceNoticeReminder]
AS

declare @staging	table
(
DocumentVersionId		int,
DocumentCodeId		int,
ToStaffId		int,
ClientId		int
--AlertType		int,
--Subject			varchar(100),
--Message			varchar(8000)
)

--Get Advance Notices that have been sent out 12 days ago
insert into @staging
select a.DocumentVersionId,b.DocumentCodeId,a.PrimaryStaffId, b.ClientId
from customAdvanceNotice a
join documents b on a.DocumentVersionId = b.CurrentDocumentVersionId
where a.DischargeAlertSent is null
and a.CreatedDate >= ''01/01/2007''
and a.DischargeFromAgency = ''Y''
and b.status = 22 --Signed
and DATEDIFF(dd, a.DateOfNotice, getdate()) >= 13
and isnull(a.RecordDeleted,''N'') = ''N''
and isnull(b.RecordDeleted,''N'') = ''N''

Declare
@DocumentVersionId		int,
@DocumentCodeId		int,
@ToStaffId		int,
@ClientId		int,
@ErrorMessage		Varchar(1000)

--Send Alert Cursor
declare c1 cursor for
select a.DocumentVersionId, a.DocumentCodeId, a.ToStaffId, a.ClientId
from @staging a

open c1
fetch c1 into
@DocumentVersionId,@DocumentCodeId, @ToStaffId, @ClientId

While @@fetch_status = 0
Begin	
	insert into Alerts
	(ToStaffId, ClientId, AlertType, DateReceived, Unread, Subject,
	 Message, Reference, RecordDeleted)
	values(@ToStaffId, @ClientId, 10992, getdate(), ''Y'', ''Advance Notice: Discharge Reminder'',
	       ''It has been more than 12 days since an Advance Notice has been mailed for this client.  This client may now be discharged if there has been no activity since the Advance Notice was sent.'',
	       @ClientId, ''N'')

	if @@error <> 0 
	Begin
		set @ErrorMessage = ''Error inserting into Alerts for Document Version ''+convert(varchar(12),@DocumentVersionId)
		goto error
	End


	UPDATE CustomAdvanceNotice
	SET DischargeAlertSent = getdate()
	WHERE DocumentVersionId = @DocumentVersionId

	if @@error <> 0 
	Begin
		set @ErrorMessage = ''Error updating DischargeAlertSent field for Document Version ''+convert(varchar(12),@DocumentVersionId)
		goto error
	End



fetch c1 into
@DocumentVersionId, @DocumentCodeId, @ToStaffId, @ClientId
End
close c1
deallocate c1

Return

Error:
Raiserror 50000 @ErrorMessage
' 
END
GO
