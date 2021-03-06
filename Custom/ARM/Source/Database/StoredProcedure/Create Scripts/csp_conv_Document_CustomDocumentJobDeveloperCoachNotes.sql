/****** Object:  StoredProcedure [dbo].[csp_conv_Document_CustomDocumentJobDeveloperCoachNotes]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_CustomDocumentJobDeveloperCoachNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conv_Document_CustomDocumentJobDeveloperCoachNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_CustomDocumentJobDeveloperCoachNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_conv_Document_CustomDocumentJobDeveloperCoachNotes]
AS 
    INSERT  INTO dbo.CustomDocumentJobDeveloperCoachNotes
            ( DocumentVersionId ,
              CreatedBy ,
              CreatedDate ,
              ModifiedBy ,
              ModifiedDate ,
              PatientName ,
              StaffName ,
              NoteDate ,
              LocationID ,
              ProcedureDescription ,
              Timeliness ,
              AuthorizationNumber ,
              HoursAuthorized ,
              HoursBilled ,
              ReferralSource ,
              ActivityNote
            )
            SELECT  dvm.DocumentVersionId , -- DocumentVersionId - int
                    d.orig_user_id , -- CreatedBy - type_CurrentUser
                    orig_entry_chron , -- CreatedDate - type_CurrentDatetime
                    d.user_id , -- ModifiedBy - type_CurrentUser
                    d.entry_chron , -- ModifiedDate - type_CurrentDatetime
                    d.patient_name , -- PatientName - varchar(100)
                    d.staff_name , -- StaffName - varchar(100)
                    d.note_date , -- NoteDate - datetime
                    CCML.LocationId , -- LocationID - int
                    d.proc_desc , -- ProcedureDescription - varchar(250)
                    d.timeliness , -- Timeliness - type_YOrN
                    d.auth_no , -- AuthorizationNumber - varchar(10)
                    d.hrs_auth , -- HoursAuthorized - float
                    d.hrs_billed , -- HoursBilled - float
                    d.referral_source , -- ReferralSource - varchar(50)
                    d.activity_note  -- ActivityNote - type_Comment2
            FROM    Psych..cstm_cc_case_note d
                    JOIN Cstm_Conv_Map_DocumentVersions dvm ON dvm.doc_session_no = d.doc_session_no
                                                              AND dvm.version_no = d.version_no
                    LEFT JOIN dbo.Cstm_Conv_Map_Locations CCML ON d.location = CCML.location_code
            WHERE   NOT EXISTS ( SELECT *
                                 FROM   CustomDocumentJobDeveloperCoachNotes c
                                 WHERE  c.DocumentVersionId = dvm.DocumentVersionId )   

    IF @@error <> 0 
        GOTO error

    RETURN

    error:

    RAISERROR 5010 ''Failed to execute csp_conv_Document_CustomDocumentJobDeveloperCoachNotes''



' 
END
GO
