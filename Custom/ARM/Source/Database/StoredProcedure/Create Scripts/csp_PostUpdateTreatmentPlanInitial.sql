/****** Object:  StoredProcedure [dbo].[csp_PostUpdateTreatmentPlanInitial]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostUpdateTreatmentPlanInitial]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PostUpdateTreatmentPlanInitial]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostUpdateTreatmentPlanInitial]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
--select * from dbo.Messages
--exec sys.sp_help ''messages''

create procedure [dbo].[csp_PostUpdateTreatmentPlanInitial]
/******************************************************************************                                      
**  File: csp_PostUpdateTreatmentPlanInitial                                  
**  Name: csp_PostUpdateTreatmentPlanInitial              
**  Desc: Send notifications to treatment team after signature of document
**  Return values:                                     
**  Called by:                                       
**  Parameters:                  
**  Auth:  Jagdeep Hundal                     
**  Date:  July 29 2011                                  
*******************************************************************************                                      
**  Change History                                      
*******************************************************************************                                      
**  Date:       Author:       Description:                                      
**  --------    --------        ----------------------------------------------------                                      
** 2012.02.10	TER				Revised based on Harbor''s rules
*/
	@ScreenKeyId int,
	@StaffId int,
	@CurrentUser varchar(30),
	@CustomParameters xml
as

declare @DocumentVersionId int, @AuthorId int, @ClientId int
select
	@DocumentVersionId = CurrentDocumentVersionId,
	@AuthorId = AuthorId,
	@ClientId = ClientId
from Documents
where DocumentId = @ScreenKeyId

declare @msgSubject varchar(700), @msgBody varchar(3000)

-- delete any unacknolwedged previous version records
delete from da
from dbo.DocumentsAcknowledgements as da
where da.DocumentId = @ScreenKeyId
and da.DateAcknowledged is null

delete from da
from dbo.DocumentsAcknowledgements as da
where da.DocumentId = @ScreenKeyId
and exists (
	select *
	from dbo.DocumentsAcknowledgements as da2
	where da2.DocumentId = da.DocumentId
	and da2.AcknowledgedDocumentVersionId = da.AcknowledgedDocumentVersionId
	and da2.AcknowledgedByStaffId = da.AcknowledgedByStaffId
	and da2.DocumentsAcknowledgementId < da.DocumentsAcknowledgementId
	and ISNULL(da2.RecordDeleted, ''N'') <> ''Y''
)

insert into dbo.DocumentsAcknowledgements
        (
         DocumentId,
         AcknowledgedDocumentVersionId,
         AcknowledgedByStaffId
        )
select
	@ScreenKeyId,
	@DocumentVersionId,
	tm.StaffId
from dbo.Documents as d
join dbo.CustomTreatmentTeamMembers as tm on tm.ClientId = d.ClientId
join dbo.Staff as s on s.StaffId = tm.StaffId
where d.DocumentId = @ScreenKeyId
and s.StaffId <> @AuthorId
and s.Active = ''Y''
and ISNULL(s.RecordDeleted, ''N'') <> ''Y''

set @msgBody = ''An initial treatment plan for client: '' + cast(@ClientId as varchar) + '' has been created or updated.  Please click the document reference link in this message to acknowledge and optionally comment on the new document.''

exec csp_CreateAlertHarborTreatmentTeam
	@TriggeringStaffId = @AuthorId,
	@ClientId = @ClientId,
	@msgSubject = ''Doc Acknowledgement Required'',
	@msgBody = @msgBody,
	@DocumentReference = @ScreenKeyId

' 
END
GO
