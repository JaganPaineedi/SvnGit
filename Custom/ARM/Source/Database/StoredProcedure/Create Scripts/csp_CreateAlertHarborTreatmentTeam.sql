/****** Object:  StoredProcedure [dbo].[csp_CreateAlertHarborTreatmentTeam]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CreateAlertHarborTreatmentTeam]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CreateAlertHarborTreatmentTeam]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CreateAlertHarborTreatmentTeam]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
--select * from dbo.alerts
--exec sys.sp_help ''alerts''

create procedure [dbo].[csp_CreateAlertHarborTreatmentTeam]
	@TriggeringStaffId int,	-- don''t send a message to the person who triggered this alert event
	@ClientId int,
	@msgSubject varchar(700),
	@msgBody varchar(3000),
	@DocumentReference int,
	@alertType int = 81	-- Documents
/******************************************************************************
**  File: csp_CreateAlertHarborTreatmentTeam
**  Name: csp_CreateAlertHarborTreatmentTeam
**  Desc: Send notifications to treatment team after signature of document
**  Return values:
**  Called by: various places within the Harbor business rules
**  Parameters:
*******************************************************************************
**  Change History
*******************************************************************************
**  Date:       Author:       Description:
**  --------    --------        ----------------------------------------------------
** 2012.02.13	TER				Revised based on Harbor''s rules
*/
as

-- find all active treatment team members and create a notice message

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
select 
		tm.StaffId,
		@ClientId,
		@alertType,
		''Y'',
		GETDATE(),
		@msgSubject,
		@msgBody,
		null,
		@DocumentReference,
		@DocumentReference,
		@DocumentReference,
		null
from dbo.CustomTreatmentTeamMembers as tm
join dbo.Staff as s on s.StaffId = tm.StaffId
where tm.ClientId = @ClientId
and tm.StaffId <> @TriggeringStaffId
and s.Active = ''Y''
and ISNULL(s.RecordDeleted, ''N'') <> ''Y''
union
select 
		s.StaffId,
		@ClientId,
		@alertType,
		''Y'',
		GETDATE(),
		@msgSubject,
		@msgBody,
		null,
		@DocumentReference,
		@DocumentReference,
		@DocumentReference,
		null
from dbo.Clients as c
join dbo.Staff as s on s.StaffId = c.PrimaryClinicianId
where c.ClientId = @ClientId
and s.StaffId <> @TriggeringStaffId
and s.Active = ''Y''
and ISNULL(s.RecordDeleted, ''N'') <> ''Y''

' 
END
GO
