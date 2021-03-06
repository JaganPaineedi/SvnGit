/****** Object:  StoredProcedure [dbo].[csp_SendServiceNoteNotifications]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SendServiceNoteNotifications]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SendServiceNoteNotifications]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SendServiceNoteNotifications]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[csp_SendServiceNoteNotifications]
AS


declare @ErrorNo int
declare @ErrorMessage varchar(100)

create table #Staging (  
DocumentVersionId   int,  
DocumentId          int,  
DocumentCodeId      int,  
ClientId            int,  
AuthorId            int,  
NotifyStaff1        int,  
NotifyStaff2        int,  
NotifyStaff3        int,  
NotifyStaff4        int,  
NotificationMessage varchar(max),
DocumentName        varchar(100))  

--Get all Note notification
insert into #Staging (DocumentVersionId, DocumentId, DocumentCodeId, ClientId, AuthorId, NotifyStaff1, NotifyStaff2, NotifyStaff3, NotifyStaff4, NotificationMessage, DocumentName)
select a.DocumentVersionId,
       b.DocumentId,
       b.DocumentCodeId,
       b.ClientId,
       b.AuthorId,
       a.NotifyStaffId1,
       a.NotifyStaffId2,
       a.NotifyStaffId3,
       a.NotifyStaffId4,
       a.NotificationMessage,
       dc.DocumentName
  from Notes a
	join DocumentVersions dv on dv.DocumentVersionId = a.DocumentVersionId  
	join Documents b on b.CurrentDocumentVersionId = dv.DocumentVersionId  
	join DocumentCodes dc on dc.DocumentCodeId = b.DocumentCodeId
	join CustomNotificationsSent cns on cns.ServiceId = b.ServiceId
 where b.Status = 22  
   and (isnull(a.NotifyStaffId1, '''') <> '''' or isnull(a.NotifyStaffId2, '''') <> '''' or isnull(a.NotifyStaffId3, '''') <> '''' or isnull(a.NotifyStaffId4,'''') <> '''')
   --and a.NotificationSent is null  
   and isnull(a.RecordDeleted, ''N'') = ''N''  
   and isnull(b.RecordDeleted, ''N'') = ''N''

--Get all Note/Hosp Prescreen notification
insert into #Staging
select a.DocumentVersionId,
       b.DocumentId,
       b.DocumentCodeId,
       b.ClientId,
       b.AuthorId,
       a.NotifyStaffId1,
       a.NotifyStaffId2,
       a.NotifyStaffId3,
       a.NotifyStaffId4,
       a.NotificationMessage,
       dc.DocumentName
  from CustomHospitalizationPrescreens a
	join DocumentVersions dv on dv.DocumentVersionId = a.DocumentVersionId  
	join Documents b on b.CurrentDocumentVersionId = dv.DocumentVersionId  
	join DocumentCodes dc on dc.DocumentCodeId = b.DocumentCodeId
	join CustomNotificationsSent cns on cns.ServiceId = b.ServiceId
 where b.Status = 22  
   and (isnull(a.NotifyStaffId1, '''') <> '''' or isnull(a.NotifyStaffId2, '''') <> '''' or isnull(a.NotifyStaffId3, '''') <> '''' or isnull(a.NotifyStaffId4,'''') <> '''')
   --and a.NotificationSent is null  
   and isnull(a.RecordDeleted, ''N'') = ''N''  
   and isnull(b.RecordDeleted, ''N'') = ''N''



if @@error <> 0   
begin  
  select @ErrorNo = 50010, @ErrorMessage = ''Failed to insert into Messages''
  goto error  
end  

insert into Messages (
       FromStaffId, 
       ToStaffId,
       ClientId,
       Unread,
       DateReceived,
       Subject,  
       Message, 
       Priority, 
       OtherRecipients,
       ReferenceType,
       ReferenceId,
       Reference,
       ReferenceLink,
       RecordDeleted)  
select st.AuthorId,
       st.NotifyStaff2,
       st.ClientId,
       ''Y'',
       getdate(),
       ''Notification'',
       st.NotificationMessage,
       60,
       case when s1.StaffId is null then '''' else s1.FirstName + '' '' + s1.LastName end +   
       case when s3.StaffId is null then '''' else '';'' + s3.FirstName + '' '' + s3.LastName end +   
       case when s4.StaffId is null then '''' else '';'' + s4.FirstName + '' '' + s4.LastName end,
       5854,
       st.DocumentId,
       st.DocumentName,
       st.DocumentId,
       ''N''
  from #Staging st
       left join Staff s1 on s1.StaffId = st.NotifyStaff1
       left join Staff s3 on s3.StaffId = st.NotifyStaff3
       left join Staff s4 on s4.StaffId = st.NotifyStaff4
 where st.NotifyStaff2 is not null  

if @@error <> 0   
begin  
  select @ErrorNo = 50011, @ErrorMessage = ''Failed to insert into Messages''
  goto error  
end  

insert into Messages (
       FromStaffId, 
       ToStaffId,
       ClientId,
       Unread,
       DateReceived,
       Subject,  
       Message, 
       Priority, 
       OtherRecipients,
       ReferenceType,
       ReferenceId,
       Reference,
       ReferenceLink,
       RecordDeleted)  
select st.AuthorId,
       st.NotifyStaff3,
       st.ClientId,
       ''Y'',
       getdate(),
       ''Notification'',
       st.NotificationMessage,
       60,
       case when s1.StaffId is null then '''' else s1.FirstName + '' '' + s1.LastName end +   
       case when s2.StaffId is null then '''' else '';'' + s2.FirstName + '' '' + s2.LastName end +   
       case when s4.StaffId is null then '''' else '';'' + s4.FirstName + '' '' + s4.LastName end,
       5854,
       st.DocumentId,
       st.DocumentName,
       st.DocumentId,
       ''N''
  from #Staging st
       left join Staff s1 on s1.StaffId = st.NotifyStaff1
       left join Staff s2 on s2.StaffId = st.NotifyStaff2
       left join Staff s4 on s4.StaffId = st.NotifyStaff4
 where st.NotifyStaff3 is not null  

if @@error <> 0   
begin  
  select @ErrorNo = 50012, @ErrorMessage = ''Failed to insert into Messages''
  goto error  
end  

insert into Messages (
       FromStaffId, 
       ToStaffId,
       ClientId,
       Unread,
       DateReceived,
       Subject,  
       Message, 
       Priority, 
       OtherRecipients,
       ReferenceType,
       ReferenceId,
       Reference,
       ReferenceLink,
       RecordDeleted)  
select st.AuthorId,
       st.NotifyStaff4,
       st.ClientId,
       ''Y'',
       getdate(),
       ''Notification'',
       st.NotificationMessage,
       60,
       case when s1.StaffId is null then '''' else s1.FirstName + '' '' + s1.LastName end +   
       case when s2.StaffId is null then '''' else '';'' + s2.FirstName + '' '' + s2.LastName end +   
       case when s3.StaffId is null then '''' else '';'' + s3.FirstName + '' '' + s3.LastName end,
       5854,
       st.DocumentId,
       st.DocumentName,
       st.DocumentId,
       ''N''
  from #Staging st
       left join Staff s1 on s1.StaffId = st.NotifyStaff1
       left join Staff s2 on s2.StaffId = st.NotifyStaff2
       left join Staff s3 on s3.StaffId = st.NotifyStaff3
 where st.NotifyStaff4 is not null  

if @@error <> 0   
begin  
  select @ErrorNo = 50013, @ErrorMessage = ''Failed to insert into Messages''
  goto error  
end  

--/* SAMPLE IF NOTIFICATIONSENT COLUMN IS AVAILABLE */
---- Update NotificationSent date
--update a  
--   set NotificationSent = getdate()  
--  from CustomAssessments a
--       join #Staging st on st.DocumentVersionId = a.DocumentVersionId

--if @@error <> 0   
--begin  
--  select @ErrorNo = 50020, @ErrorMessage = ''Failed to update CustomAssessments''
--  goto error  
--end  

Return

Error:
Raiserror 50000 @ErrorMessage
' 
END
GO
