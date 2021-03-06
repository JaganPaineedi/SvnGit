/****** Object:  StoredProcedure [dbo].[csp_conv_Document_CustomDocumentActivityNotes]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_CustomDocumentActivityNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conv_Document_CustomDocumentActivityNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_CustomDocumentActivityNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
create procedure [dbo].[csp_conv_Document_CustomDocumentActivityNotes]
as

insert into CustomDocumentActivityNotes (
       DocumentVersionId
      ,CreatedBy
      ,CreatedDate
      ,ModifiedBy
      ,ModifiedDate
      ,Narrative)
select dvm.DocumentVersionId
      ,d.orig_user_id
      ,d.orig_entry_chron
      ,d.user_id
      ,d.entry_chron
      ,
      ''Narrative: '' + isnull(convert(varchar(max), d.activity_note), '''') + char(13) + char(10) + 
      ''Contact Type: '' + isnull(case when d.type_contact = ''OT'' then ''Other'' else gcct.name end, '''') + char(13) + char(10) +  
      ''Other Contact Description: '' + isnull(convert(varchar(max),d.other_contact_desc), '''') + char(13) + char(10) + 
      ''Contact Name: '' + isnull(convert(varchar(max), d.contact_name), '''') + char(13) + char(10) + 
      ''Contact Phone: '' + isnull(d.contact_phone, '''') + char(13) + char(10) + 
      ''Session Length: '' + isnull(convert(varchar, d.length_session), '''') + char(13) + char(10) + 
      ''Staff Name: '' + isnull(d.staff_name, '''') + char(13) + char(10) + 
      ''Next Appointment: '' + isnull(convert(varchar, d.next_appt), '''')  as Narrative
  from Psych..cstm_activity_note d
       join Cstm_Conv_Map_DocumentVersions dvm on dvm.doc_session_no = d.doc_session_no and dvm.version_no = d.version_no
       left join Psych..Global_Code gcct on gcct.category = ''CONTACTTYP'' and gcct.code = d.type_contact
 where not exists (select *
                     from CustomDocumentActivityNotes c
                    where c.DocumentVersionId = dvm.DocumentVersionId)      
      

if @@error <> 0 goto error

return

error:

raiserror 5010 ''Failed to execute csp_conv_Document_CustomDocumentActivityNotes''

' 
END
GO
