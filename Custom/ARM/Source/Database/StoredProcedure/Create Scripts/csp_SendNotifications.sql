/****** Object:  StoredProcedure [dbo].[csp_SendNotifications]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SendNotifications]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SendNotifications]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SendNotifications]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_SendNotifications]
/********************************************************************************                                                                                                
-- Stored Procedure: dbo.csp_SendNotifications                                                                                                  
--                                                                                                
-- Copyright: Streamline Healthcate Solutions                                                                                                
--                                                                                                
-- Purpose: sends staff notification messages
--                                                                                                
-- Updates:                                                                                                                                                       
-- Date            Author    Purpose                     
-- 05.25.2007      RJN       Modified to only send notice for signed documents                                                                         
-- 10.20.2010      SFarber   Replaced CustomDischargesOld with CustomDischarges; Removed cursors
-- 11.24.2010	   dharvey	 Replaced NotifyStaff1 with correct NotifyStaff[#]
								for Inserts on NotifyStaff2,NotifyStaff3, & NotifyStaff4
								(this was sending multiple messages to the same staffid
								 as NotifyStaff1)
*********************************************************************************/                                                                     
as  

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
  
--Get all Transfer/Broker notification  
insert into #Staging (DocumentVersionId, DocumentId, DocumentCodeId, ClientId, AuthorId, NotifyStaff1, NotifyStaff2, NotifyStaff3, NotifyStaff4, NotificationMessage, DocumentName)
select a.DocumentVersionId,
       b.DocumentId,
       b.DocumentCodeId,
       b.ClientId,
       b.AuthorId,
       a.NotifyStaff1,
       a.NotifyStaff2,
       a.NotifyStaff3,
       a.NotifyStaff4,
       a.NotificationMessage,
       dc.DocumentName
  from CustomTransferBroker a  
       join DocumentVersions dv on dv.DocumentVersionId = a.DocumentVersionId  
       join Documents b on b.CurrentDocumentVersionId = dv.DocumentVersionId  
       join DocumentCodes dc on dc.DocumentCodeId = b.DocumentCodeId
 where b.Status = 22  
   and (isnull(a.NotifyStaff1, '''') <> '''' or isnull(a.NotifyStaff2, '''') <> '''' or isnull(a.NotifyStaff3, '''') <> '''' or isnull(a.NotifyStaff4,'''') <> '''')
   and a.NotificationSent is null  
   and isnull(a.RecordDeleted, ''N'') = ''N''  
   and isnull(b.RecordDeleted, ''N'') = ''N''  
  
--Get all Assessment notifications  
insert into #Staging (DocumentVersionId, DocumentId, DocumentCodeId, ClientId, AuthorId, NotifyStaff1, NotifyStaff2, NotifyStaff3, NotifyStaff4, NotificationMessage, DocumentName)
select a.DocumentVersionId,
       b.DocumentId,
       b.DocumentCodeId,
       b.ClientId,
       b.AuthorId,
       a.NotifyStaff1,
       a.NotifyStaff2,
       a.NotifyStaff3,
       a.NotifyStaff4,
       a.NotificationMessage,
       dc.DocumentName
  from CustomAssessments a  
       join DocumentVersions dv on dv.DocumentVersionId = a.DocumentVersionId  
       join Documents b on b.CurrentDocumentVersionId = dv.DocumentVersionId  
       join DocumentCodes dc on dc.DocumentCodeId = b.DocumentCodeId
 where b.Status = 22  
   and (isnull(a.NotifyStaff1, '''') <> '''' or isnull(a.NotifyStaff2, '''') <> '''' or isnull(a.NotifyStaff3, '''') <> '''' or isnull(a.NotifyStaff4,'''') <> '''')
   and a.NotificationSent is null  
   and isnull(a.RecordDeleted, ''N'') = ''N''  
   and isnull(b.RecordDeleted, ''N'') = ''N''  
  
--Get all Discharge notifications  
insert into #Staging (DocumentVersionId, DocumentId, DocumentCodeId, ClientId, AuthorId, NotifyStaff1, NotifyStaff2, NotifyStaff3, NotifyStaff4, NotificationMessage, DocumentName)
select a.DocumentVersionId,
       b.DocumentId,
       b.DocumentCodeId,
       b.ClientId,
       b.AuthorId,
       a.NotifyStaff1,
       a.NotifyStaff2,
       a.NotifyStaff3,
       a.NotifyStaff4,
       a.NotificationMessage,
       dc.DocumentName  
  from CustomDischarges a  
       join DocumentVersions dv on dv.DocumentVersionId = a.DocumentVersionId  
       join Documents b on b.CurrentDocumentVersionId = dv.DocumentVersionId  
       join DocumentCodes dc on dc.DocumentCodeId = b.DocumentCodeId
 where b.Status = 22  
   and (isnull(a.NotifyStaff1, '''') <> '''' or isnull(a.NotifyStaff2, '''') <> '''' or isnull(a.NotifyStaff3, '''') <> '''' or isnull(a.NotifyStaff4,'''') <> '''')
--   and a.NotificationSent is null  
   and isnull(a.RecordDeleted, ''N'') = ''N''  
   and isnull(b.RecordDeleted, ''N'') = ''N''  
   and not exists(select * from CustomDischargesNotificationSent s where s.DocumentId = b.DocumentId)
  
  
--Get all TreatmentPlan notifications  
insert into #Staging (DocumentVersionId, DocumentId, DocumentCodeId, ClientId, AuthorId, NotifyStaff1, NotifyStaff2, NotifyStaff3, NotifyStaff4, NotificationMessage, DocumentName)
select a.DocumentVersionId,
       b.DocumentId,
       b.DocumentCodeId,
       b.ClientId,
       b.AuthorId,
       a.StaffId1,
       a.StaffId2,
       a.StaffId3,
       a.StaffId4,
       a.NotificationMessage,
       dc.DocumentName    
  from TPGeneral a  
       join DocumentVersions dv on dv.DocumentVersionId = a.DocumentVersionId  
       join Documents b on b.CurrentDocumentVersionId = dv.DocumentVersionId  
       join DocumentCodes dc on dc.DocumentCodeId = b.DocumentCodeId
 where b.Status = 22  
   and (isnull(a.StaffId1, '''') <> '''' or isnull(a.StaffId2, '''') <> '''' or isnull(a.StaffId3, '''') <> '''' or isnull(a.StaffId4,'''') <> '''')
   and a.NotificationSent is null  
   and isnull(a.RecordDeleted, ''N'') = ''N''  
   and isnull(b.RecordDeleted, ''N'') = ''N''  
  
  
--Get all Periodic Reveiw notifications  
insert into #Staging (DocumentVersionId, DocumentId, DocumentCodeId, ClientId, AuthorId, NotifyStaff1, NotifyStaff2, NotifyStaff3, NotifyStaff4, NotificationMessage, DocumentName)
select a.DocumentVersionId,
       b.DocumentId,
       b.DocumentCodeId,
       b.ClientId,
       b.AuthorId,
       a.NotifyClinician1,
       a.NotifyClinician2,
       a.NotifyClinician3,
       a.NotifyClinician4,
       a.NotifyComment,
       dc.DocumentName      
  from PeriodicReviews a  
       join DocumentVersions dv on dv.DocumentVersionId = a.DocumentVersionId  
       join Documents b on b.CurrentDocumentVersionId = dv.DocumentVersionId  
       join DocumentCodes dc on dc.DocumentCodeId = b.DocumentCodeId
 where b.Status = 22  
   and (isnull(a.NotifyClinician1, '''') <> '''' or isnull(a.NotifyClinician2, '''') <> '''' or isnull(a.NotifyClinician3, '''') <> '''' or isnull(a.NotifyClinician4,'''') <> '''')
   and a.NotificationSent is null  
   and isnull(a.RecordDeleted, ''N'') = ''N''  
   and isnull(b.RecordDeleted, ''N'') = ''N''  

-- Create notification messages
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
       st.NotifyStaff1,
       st.ClientId,
       ''Y'',
       getdate(),
       ''Notification'',
       st.NotificationMessage,
       60,
       case when s2.StaffId is null then '''' else s2.FirstName + '' '' + s2.LastName end +
       case when s3.StaffId is null then '''' else '';'' + s3.FirstName + '' '' + s3.LastName end +   
       case when s4.StaffId is null then '''' else '';'' + s4.FirstName + '' '' + s4.LastName end,
       5854,
       st.DocumentId,
       st.DocumentName,
       st.DocumentId,
       ''N''
  from #Staging st
       left join Staff s2 on s2.StaffId = st.NotifyStaff2
       left join Staff s3 on s3.StaffId = st.NotifyStaff3
       left join Staff s4 on s4.StaffId = st.NotifyStaff4
 where st.NotifyStaff1 is not null  

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

-- Update NotificationSent date
update a  
   set NotificationSent = getdate()  
  from CustomAssessments a
       join #Staging st on st.DocumentVersionId = a.DocumentVersionId

if @@error <> 0   
begin  
  select @ErrorNo = 50020, @ErrorMessage = ''Failed to update CustomAssessments''
  goto error  
end  

update a  
   set NotificationSent = getdate()  
  from CustomTransferBroker a
       join #Staging st on st.DocumentVersionId = a.DocumentVersionId

if @@error <> 0   
begin  
  select @ErrorNo = 50030, @ErrorMessage = ''Failed to update CustomTransferBroker''
  goto error  
end  

/*
update a  
   set NotificationSent = getdate()  
  from CustomDischarges a
       join #Staging st on st.DocumentVersionId = a.DocumentVersionId
*/
insert into CustomDischargesNotificationSent (DocumentId, NotificationSent)
select st.DocumentId, getdate()
  from #Staging st
 where st.DocumentCodeId = 1468
   and not exists(select * 
                    from CustomDischargesNotificationSent s 
                   where s.DocumentId = st.DocumentId)

if @@error <> 0   
begin  
  select @ErrorNo = 50040, @ErrorMessage = ''Failed to update CustomDischarges''
  goto error  
end  

update a  
   set NotificationSent = getdate()  
  from TPGeneral a
       join #Staging st on st.DocumentVersionId = a.DocumentVersionId

if @@error <> 0   
begin  
  select @ErrorNo = 50050, @ErrorMessage = ''Failed to update TPGeneral''
  goto error  
end  

update a  
   set NotificationSent = getdate()  
  from PeriodicReviews a
       join #Staging st on st.DocumentVersionId = a.DocumentVersionId

if @@error <> 0   
begin  
  select @ErrorNo = 50060, @ErrorMessage = ''Failed to update PeriodicReviews''
  goto error  
end  

return  
  
error:  

raiserror @ErrorNo @ErrorMessage
' 
END
GO
