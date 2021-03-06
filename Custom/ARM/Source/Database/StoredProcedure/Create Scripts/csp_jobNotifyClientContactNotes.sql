/****** Object:  StoredProcedure [dbo].[csp_jobNotifyClientContactNotes]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_jobNotifyClientContactNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_jobNotifyClientContactNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_jobNotifyClientContactNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_jobNotifyClientContactNotes] as

declare @tabAlerts table (
	ClientContactNoteId int,
	ClientId int,
	NotifyTeam char(1),
	Notifystaff int,
	Details varchar(2000)
)


begin try
begin tran

        
insert into @tabAlerts
        (
        ClientContactNoteId,
         ClientId,
         NotifyTeam,
         Notifystaff,
         Details
        )
select cn.ClientContactNoteId, cn.ClientId, case when (cn.NotifyTeam = ''Y'' and cn.NotifyTeamId is not null) then ''Y'' else ''N'' end,
case when (cn.NotifyStaff = ''Y'' and cn.NotifyStaffId is not null) then cn.NotifyStaffId else null end,
ISNULL(gcDetails.CodeName, '''') + '' - '' + ISNULL(cn.ContactDetails, '''')
from dbo.ClientContactNotes as cn
LEFT join dbo.GlobalCodes as gcDetails on gcDetails.GlobalCodeId = cn.ContactQuickDetails
join dbo.GlobalCodes as gcStatus on gcStatus.GlobalCodeId = cn.ContactStatus
where 
((cn.NotifyStaff = ''Y'' and cn.NotifyStaffId is not null)
or (cn.NotifyTeam = ''Y'' and cn.NotifyTeamId is not null))
and cn.NotificationSentDateTime is null
and gcstatus.ExternalCode1 = ''C''


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
select tt.StaffId, t.ClientId, 81, ''Y'', GETDATE(), ''Client Contact Notification'', t.Details, null, null, null, null, null
from @tabAlerts as t
join CustomTreatmentTeamMembers as tt on tt.ClientId = t.ClientId
where t.NotifyTeam = ''Y''

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
select t.Notifystaff, t.ClientId, 81, ''Y'', GETDATE(), ''Client Contact Notification'', t.Details, null, null, null, null, null
from @tabAlerts as t
where t.Notifystaff is not null


update cn set
	NotificationSentDateTime = GETDATE()
from dbo.ClientContactNotes as cn
join @tabAlerts as t on t.ClientContactNoteId = cn.ClientContactNoteId


commit tran

end try
begin catch
if @@TRANCOUNT > 0 rollback tran
declare @error_message nvarchar(4000)
set @error_message = ERROR_MESSAGE()
raiserror (@error_message, 16, 1)
end catch

' 
END
GO
