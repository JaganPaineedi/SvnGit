/****** Object:  StoredProcedure [dbo].[csp_AlertAdvanceAdequateNotification]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AlertAdvanceAdequateNotification]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_AlertAdvanceAdequateNotification]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AlertAdvanceAdequateNotification]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  Procedure [dbo].[csp_AlertAdvanceAdequateNotification]
 @CurrentUserId 	int,           
 @DocumentVersionId 		int,        
 @DocumentCodeId 	int

AS


declare @staging	table
(
DocumentVersionId		int,
DocumentCodeId		int,
ClientId		int,
DateOfNotice		DateTime
)

DECLARE @ErrorMessage 	varchar(1000)
DECLARE @ToStaffId	int

SET @ToStaffId = 64 --Nichole Boyd


IF @DocumentCodeId = 106
BEGIN
	--Get Advance Notice 
	insert into @staging
	select a.DocumentVersionId,b.DocumentCodeId,b.ClientId, a.DateOfNotice
	from customAdvanceNotice a
	join documents b on a.DocumentVersionId = b.CurrentDocumentVersionId
	where a.AlertSent is null
	and a.CreatedDate >= ''01/01/2007''
	and b.status = 22 --Signed
	and a.DocumentVersionId = @DocumentVersionId
	and isnull(a.RecordDeleted,''N'') = ''N''
	and isnull(b.RecordDeleted,''N'') = ''N''
END

IF @DocumentCodeId = 105
BEGIN
	--Get Adequate Notice
	insert into @staging
	select a.DocumentVersionId,b.DocumentCodeId,b.ClientId, a.DateOfNotice
	from customAdequateNotice a
	join documents b on a.DocumentVersionId = b.CurrentDocumentVersionId
	where a.AlertSent is null
	and a.CreatedDate >= ''01/01/2007''
	and b.status = 22 --Signed
	and a.DocumentVersionId = @DocumentVersionId
	and isnull(a.RecordDeleted,''N'') = ''N''
	and isnull(b.RecordDeleted,''N'') = ''N''
END



--Insert Into Alerts Table
	insert into Alerts
	(ToStaffId, ClientId, AlertType, DateReceived, Unread, Subject,
	 Message, Reference, RecordDeleted)
	SELECT @ToStaffId, ClientId, 10993, getdate(), ''Y'', 
		CASE WHEN DocumentCodeId = 106 then ''Advance Notice Sent''
		     WHEN DocumentCodeId = 105 then ''Adequate Notice Sent''
		     ELSE NULL END,
	       	CASE WHEN DocumentCodeId = 106 then ''An Advance Notice has been sent on '' + Convert(varchar(30), DateOfNotice, 101) + '' for this client.''
		     WHEN DocumentCodeId = 105 then ''An Adequate Notice has been sent on '' + Convert(varchar(30), DateOfNotice, 101) + '' for this client.''
		     ELSE NULL END,
		ClientId, ''N''
	FROM @Staging
	WHERE DocumentVersionId = @DocumentVersionId

	if @@error <> 0 
	Begin
		set @ErrorMessage = ''Error inserting into Alerts for Document Version ''+convert(varchar(12),@DocumentVersionId)
		goto error
	End

--Update Alert Sent for Advance Document
IF @DocumentCodeId = 106
BEGIN
	UPDATE CustomAdvanceNotice
	SET AlertSent = getdate()
	FROM CustomAdvanceNotice Adv
	JOIN @staging s on s.DocumentVersionId = Adv.DocumentVersionId
	WHERE Adv.DocumentVersionId = @DocumentVersionId
END

	if @@error <> 0 
	Begin
		set @ErrorMessage = ''Error updating AlertSent field for Document Version ''+convert(varchar(12),@DocumentVersionId)
		goto error
	End

--Update Alert Sent for Adequate Document
IF @DocumentCodeId = 105
BEGIN
	UPDATE CustomAdequateNotice
	SET AlertSent = getdate()
	FROM CustomAdequateNotice Adq
	JOIN @staging s on s.DocumentVersionId = Adq.DocumentVersionId
	WHERE Adq.DocumentVersionId = @DocumentVersionId
END

	if @@error <> 0 
	Begin
		set @ErrorMessage = ''Error updating AlertSent field for Document Version ''+convert(varchar(12),@DocumentVersionId)
		goto error
	End


Return

Error:
Raiserror 50000 @ErrorMessage
' 
END
GO
