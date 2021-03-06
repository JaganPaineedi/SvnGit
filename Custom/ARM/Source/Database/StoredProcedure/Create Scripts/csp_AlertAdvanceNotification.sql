/****** Object:  StoredProcedure [dbo].[csp_AlertAdvanceNotification]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AlertAdvanceNotification]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_AlertAdvanceNotification]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AlertAdvanceNotification]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  Procedure [dbo].[csp_AlertAdvanceNotification]
AS


declare @staging	table
(
DocumentVersionId		int,
DocumentCodeId		int,
ToStaffId		int,
ClientId		int,
DateOfNotice		datetime
)

--Get Advance Notices that have been sent out 12 days ago
insert into @staging
select a.DocumentVersionId,b.DocumentCodeId,a.PrimaryStaffId, b.ClientId, a.dateofNotice
from customAdvanceNotice a
join documents b on a.DocumentVersionId = b.CurrentDocumentVersionId
where a.AlertSent is null
and a.CreatedDate >= ''01/01/2007''
and b.status = 22 --Signed
and isnull(a.RecordDeleted,''N'') = ''N''
and isnull(b.RecordDeleted,''N'') = ''N''

Declare
@DocumentVersionId		int,
@DocumentCodeId		int,
@ToStaffId		int,
@ClientId		int,
@DateOfNotice		datetime,
@ErrorMessage		Varchar(1000)


SET @ToStaffId = 64 --Nichole Boyd

--Send Alert Cursor
declare c1 cursor for
select a.DocumentVersionId, a.DocumentCodeId, a.ClientId, a.DateOfNotice
from @staging a

open c1
fetch c1 into
@DocumentVersionId, @DocumentCodeId, @ClientId, @DateOfNotice

While @@fetch_status = 0
Begin	
	insert into Alerts
	(ToStaffId, ClientId, AlertType, DateReceived, Unread, Subject,
	 Message, Reference, RecordDeleted)
	values(@ToStaffId, @ClientId, 10993, getdate(), ''Y'', 
		''Advance Notice Sent'',
	       	''An Advance Notice has been sent on '' + Convert(varchar(30), @DateOfNotice, 101) + '' for this client.'',
		@ClientId, ''N'')

	if @@error <> 0 
	Begin
		set @ErrorMessage = ''Error inserting into Alerts for Document Version ''+convert(varchar(12),@DocumentVersionId)
		goto error
	End


	UPDATE CustomAdvanceNotice
	SET AlertSent = getdate()
	FROM CustomAdvanceNotice Adv
	JOIN @staging s on s.DocumentVersionId = Adv.DocumentVersionId
	WHERE Adv.DocumentVersionId = @DocumentVersionId

	if @@error <> 0 
	Begin
		set @ErrorMessage = ''Error updating DischargeAlertSent field for Document Version ''+convert(varchar(12),@DocumentVersionId)
		goto error
	End



fetch c1 into
@DocumentVersionId, @DocumentCodeId, @ClientId, @DateOfNotice
End
close c1
deallocate c1

Return

Error:
Raiserror 50000 @ErrorMessage
' 
END
GO
