/****** Object:  StoredProcedure [dbo].[csp_conv_Document_CustomActivityNotes]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_CustomActivityNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conv_Document_CustomActivityNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_CustomActivityNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
  
CREATE PROCEDURE [dbo].[csp_conv_Document_CustomActivityNotes]
AS 
    INSERT  INTO CustomActivityNotes
            ( DocumentVersionId ,
              CreatedBy ,
              CreatedDate ,
              ModifiedBy ,
              ModifiedDate ,
              PatientName ,
              ContactType ,
              OtherContactDescription ,
              ContactName ,
              ContactPhone ,
              AcitvityNote ,
              SessionLenght ,
              NextAppointment ,
              StaffName
      
            )
            SELECT  dvm.DocumentVersionId ,
                    d.orig_user_id ,
                    d.orig_entry_chron ,
                    d.user_id ,
                    d.entry_chron ,
                    d.patient_name ,
                    d.type_contact ,
                    d.other_contact_desc ,
                    d.contact_name ,
                    d.contact_phone ,
                    d.activity_note ,
                    d.length_session ,
                    d.next_appt ,
                    d.staff_name
            FROM    Psych..cstm_activity_note d
                    LEFT JOIN Cstm_Conv_Map_DocumentVersions dvm ON dvm.doc_session_no = d.doc_session_no
                                                              AND dvm.version_no = d.version_no
            WHERE   NOT EXISTS ( SELECT *
                                 FROM   CustomActivityNotes c
                                 WHERE  c.DocumentVersionId = ISNULL(dvm.DocumentVersionId,
                                                              -1) )      

       
    IF @@error <> 0 
        GOTO error

    RETURN

    error:

    RAISERROR 5010 ''Failed to execute csp_conv_Document_CustomActivityNotes''



' 
END
GO
