/****** Object:  StoredProcedure [dbo].[csp_AfterHoursCallNotification]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AfterHoursCallNotification]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_AfterHoursCallNotification]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AfterHoursCallNotification]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_AfterHoursCallNotification]
/********************************************************************************                                                                                                
-- Stored Procedure: dbo.csp_AfterHoursCallNotification                                                                                                  
--                                                                                                
-- Copyright: Streamline Healthcate Solutions                                                                                                
--                                                                                                
-- Purpose: Sends notification to staff the next morning when an after hours call occurs
--                                                                                                
-- Updates:                                                                                                                                                       
-- Date              Author      Purpose                     
-- 08.24.2001		jschultz	To send notification to staff
*********************************************************************************/                                                                     
as  

declare @ErrorNo int
declare @ErrorMessage varchar(100)
declare @DocCheck varchar(150)

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
   
   
set @DocCheck = (select documentname from #Staging)

if @DocCheck = 1491
begin

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
       ''After Hours Notification'',
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
       ''After Hours Notification'',
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
       ''After Hours Notification'',
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
       ''After Hours Notification'',
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

return  
  
error:  

raiserror @ErrorNo @ErrorMessage


end
' 
END
GO
