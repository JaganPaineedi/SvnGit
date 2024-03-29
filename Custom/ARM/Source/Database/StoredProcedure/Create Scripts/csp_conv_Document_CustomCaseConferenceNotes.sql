/****** Object:  StoredProcedure [dbo].[csp_conv_Document_CustomCaseConferenceNotes]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_CustomCaseConferenceNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conv_Document_CustomCaseConferenceNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_CustomCaseConferenceNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
  
CREATE PROCEDURE [dbo].[csp_conv_Document_CustomCaseConferenceNotes]
AS 
    INSERT  INTO dbo.CustomCaseConferenceNotes
            ( DocumentVersionId ,
              CreatedBy ,
              CreatedDate ,
              ModifiedBy ,
              ModifiedDate ,
              PatientName ,
              ConferenceDate ,
              StaffName ,
              ConferencePurpose ,
              PurposeOther ,
              CSP ,
              VocStaff ,
              PsychStaff ,
              EAP ,
              Super ,
              MedStaff ,
              QIStaff ,
              ClinicalTeam ,
              Therapist ,
              EQC ,
              Issues ,
              Contracting ,
              MeetingWithParents ,
              ClassroomReorganization ,
              IndivCN ,
              CommSupport ,
              ClassConsult ,
              MeetingWithInterventionTeam ,
              Staffing ,
              Intervention ,
              GroupCoinsult ,
              Vocational ,
              OtherIntervention ,
              OtherInterventionDescription ,
              PlanOfAction
            )
            SELECT  dvm.DocumentVersionId ,
                    d.orig_user_id ,
                    d.orig_entry_chron ,
                    d.user_id ,
                    d.entry_chron ,
                    patient_name ,
                    conf_date ,
                    staff_name ,
                    purpose_conference ,
                    purpose_other ,
                    csp ,
                    voc_staff ,
                    psych_staff ,
                    eap ,
                    super ,
                    med_staff ,
                    qi_staff ,
                    clin_team ,
                    therapist ,
                    eqc ,
                    issues ,
                    contracting ,
                    mtg_parents ,
                    class_reorg ,
                    indiv_cn ,
                    comm_support ,
                    class_consult ,
                    mtg_intervention ,
                    staffing ,
                    intervention ,
                    group_couns ,
                    vocational ,
                    other_intervention ,
                    other_inter_desc ,
                    plan_of_action
            FROM    Psych..cstm_doc_case_conf d
                    LEFT JOIN Cstm_Conv_Map_DocumentVersions dvm ON dvm.doc_session_no = d.doc_session_no
                                                              AND dvm.version_no = d.version_no
            WHERE   NOT EXISTS ( SELECT *
                                 FROM   CustomCaseConferenceNotes c
                                 WHERE  c.DocumentVersionId = ISNULL(dvm.DocumentVersionId,
                                                              -1) )      

       
    IF @@error <> 0 
        GOTO error

    RETURN

    error:

    RAISERROR 5010 ''Failed to execute csp_conv_Document_CustomCaseConferenceNotes''
' 
END
GO
