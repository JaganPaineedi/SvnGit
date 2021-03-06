/****** Object:  StoredProcedure [dbo].[csp_PostSignatureDischarge]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostSignatureDischarge]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PostSignatureDischarge]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostSignatureDischarge]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_PostSignatureDischarge]
	@ScreenKeyId int,
	@StaffId int,
	@CurrentUser varchar(30),
	@CustomParameters xml
/****************************************************************/
-- PROCEDURE: csp_PostSignatureDischarge
-- PURPOSE: Post Harbor discharge signature events.
-- CALLED BY: SmartCare on post-update (signature)
-- REVISION HISTORY:
--		2011.10.02 - T. Remisoski - Created.
/****************************************************************/

as

begin try
begin tran

declare @DocumentVersionId int, @EffectiveDate datetime, @ClientId int, @AuthorId int
declare @msgBody varchar(3000)

select @DocumentVersionId = CurrentDocumentVersionId, @EffectiveDate = EffectiveDate, @ClientId = ClientId, @AuthorId = AuthorId
from Documents
where DocumentId = @ScreenKeyId

-- CONSTANTS
declare @constEpisodeStatusDischarged int = 102

-- Mark the last open epiosde as discharged
update ce set
	Status = @constEpisodeStatusDischarged,
	DischargeDate = dis.DischargeDate
from ClientEpisodes as ce
cross join CustomDocumentDischarges as dis
where ce.ClientId = @ClientId
and ce.DischargeDate is null
and isnull(ce.RecordDeleted, ''N'') <> ''Y''
and dis.DocumentVersionId = @DocumentVersionId
and not exists (
	select *
	from ClientEpisodes as ce2
	where ce2.ClientId = ce.ClientId
	and ce2.DischargeDate is null
	and ce2.EpisodeNumber > ce.EpisodeNumber
	and isnull(ce2.RecordDeleted, ''N'') <> ''Y''
)

-- Mark the client as inactive
update Clients set
	Active = ''N''
where ClientId = @ClientId

select @msgBody = ''A discharge document has been completed for '' + isnull(c.LastName, '''') + '', '' + isnull(c.FirstName, '''') + '', Client Id: '' + cast(@ClientId as varchar) + ''.''
from Clients as c
where c.ClientId = @ClientId

exec [csp_CreateAlertHarborTreatmentTeam]
	@TriggeringStaffId = @AuthorId,
	@ClientId = @ClientId,
	@msgSubject = ''Client has been discharged.'',
	@msgBody = @msgBody,
	@DocumentReference = @ScreenKeyId,
	@alertType = 81	-- Documents
	
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
