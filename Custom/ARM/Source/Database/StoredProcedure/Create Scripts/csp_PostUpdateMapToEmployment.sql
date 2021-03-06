/****** Object:  StoredProcedure [dbo].[csp_PostUpdateMapToEmployment]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostUpdateMapToEmployment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PostUpdateMapToEmployment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostUpdateMapToEmployment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
--select * from dbo.Messages
--exec sys.sp_help ''messages''

CREATE procedure [dbo].[csp_PostUpdateMapToEmployment]
/******************************************************************************                                      
**  File: csp_PostUpdateMapToEmployment                                  
**  Name: csp_PostUpdateMapToEmployment              
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
** 2012.06.19	TER				Revised based on Harbor''s rules
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
	tm.SupervisorId
from dbo.Documents as d
join dbo.StaffSupervisors as tm on tm.StaffId = d.AuthorId
where d.DocumentId = @ScreenKeyId
and tm.SupervisorId <> @AuthorId
and ISNULL(tm.RecordDeleted, ''N'') <> ''Y''

set @msgBody = ''A map to employment for client: '' + cast(@ClientId as varchar) + '' has been created or updated.  Please click the document reference link in this message to acknowledge and optionally comment on the new document.''


insert into dbo.Alerts
        (
         ToStaffId,
         ClientId,
         AlertType,
         Unread,
         DateReceived,
         Subject,
         Message,
         FollowUp,
         Reference,
         ReferenceLink,
         DocumentId,
         TabId
        )
select tm.SupervisorId,
d.ClientId,
81,
''Y'',
GETDATE(),
''Document Acknowledgement Required'',
''A map to employment for client: '' + cast(@ClientId as varchar) + '' has been created or updated.  Please click the document reference link in this message to acknowledge and optionally comment on the new document.'',
null,
@ScreenKeyId,
@ScreenKeyId,
@ScreenKeyId,
null
from dbo.Documents as d
join dbo.StaffSupervisors as tm on tm.StaffId = d.AuthorId
where d.DocumentId = @ScreenKeyId
and tm.SupervisorId <> @AuthorId
and ISNULL(tm.RecordDeleted, ''N'') <> ''Y''


' 
END
GO
