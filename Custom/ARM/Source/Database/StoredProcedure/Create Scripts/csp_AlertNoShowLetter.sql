/****** Object:  StoredProcedure [dbo].[csp_AlertNoShowLetter]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AlertNoShowLetter]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_AlertNoShowLetter]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AlertNoShowLetter]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE   Procedure [dbo].[csp_AlertNoShowLetter]
AS


declare @staging	table
(
ServiceId		int,
ProcedureCode		varchar(30),
DocumentVersionId		int,
DocumentCodeId		int,
ToStaffId		int,
ClientId		int,
DateOfService		datetime
)

--Get Advance Notices that have been sent out 12 days ago
insert into @staging
select cns.ServiceId, pc.DisplayAs, d.CurrentDocumentVersionId, d.DocumentCodeId,
 s.ClinicianId, s.ClientId, s.DateOfService
From CustomCancelNoShows cns
Join Services s on s.ServiceId = cns.ServiceId
Join Clients c on c.ClientId = s.ClientId
Join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId
Left Join Documents d on d.ServiceId = s.ServiceId and isnull(d.RecordDeleted, ''N'') = ''N''
Where cns.NoShowNoticeSent is null
and (isnull(pc.Category1, 0) = 10943 OR isnull(pc.Category2, 0) = 10943 OR isnull(pc.Category3, 0) = 10943) 
and s.ProgramId in (12, 13, 14) -- OP Programs
and s.Status = 72 -- No Show
and isnull(s.RecordDeleted, ''N'') = ''N''
and isnull(c.RecordDeleted, ''N'') = ''N''
and isnull(cns.RecordDeleted, ''N'') = ''N''


Declare
@ServiceId		int,
@ProcedureCode		varchar(30),
@DocumentVersionId		int,
@DocumentCodeId		int,
@ToStaffId		int,
@ClientId		int,
@DateOfService		datetime,
@ErrorMessage		Varchar(1000)



--Send Alert Cursor
declare c1 cursor for
select a.ServiceId, a.ProcedureCode, a.DocumentVersionId, a.DocumentCodeId, a.ClientId, a.DateOfService, a.ToStaffId
from @staging a

open c1
fetch c1 into
@ServiceId, @ProcedureCode, @DocumentVersionId, @DocumentCodeId, @ClientId, @DateOfService, @ToStaffId

While @@fetch_status = 0
Begin	
	insert into Alerts
	(ToStaffId, ClientId, AlertType, DateReceived, Unread, Subject,
	 Message, Reference, RecordDeleted)
	values(@ToStaffId, @ClientId, 11021, getdate(), ''Y'', 
		''Client No Show'',
	       	''This client has not shown up for the '' + @ProcedureCode + '' service, scheduled for: '' +Convert(varchar(30), @DateOfService, 0) + ''.  A No Show Letter will be sent to this client.  Please contact Support Staff if you would not like this letter to be sent.'',
		@ClientId, ''N'')

	if @@error <> 0 
	Begin
		set @ErrorMessage = ''Error inserting into Alerts for ServiceId ''+convert(varchar(12),@ServiceId)
		goto error
	End


	UPDATE cns
	SET NoShowNoticeSent = getdate()
	FROM CustomCancelNoShows cns
	JOIN @staging s on s.ServiceId = cns.ServiceId
	WHERE cns.ServiceId = @ServiceId

	if @@error <> 0 
	Begin
		set @ErrorMessage = ''Error updating NoShowNoticeSent field for serviceid ''+convert(varchar(12),@ServiceId)
		goto error
	End



fetch c1 into
@ServiceId, @ProcedureCode, @DocumentVersionId, @DocumentCodeId, @ClientId, @DateOfService, @ToStaffId
End
close c1
deallocate c1

Return

Error:
Raiserror 50000 @ErrorMessage
' 
END
GO
