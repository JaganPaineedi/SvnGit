/****** Object:  StoredProcedure [dbo].[csp_conv_Document_MedicationManagementList]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_MedicationManagementList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conv_Document_MedicationManagementList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_MedicationManagementList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
  
CREATE PROCEDURE [dbo].[csp_conv_Document_MedicationManagementList]
AS 
    INSERT  INTO dbo.MedicationManagementList
            ( DocumentVersionId ,
              CreatedBy ,
              CreatedDate ,
              ModifiedBy ,
              ModifiedDate ,
              ClinicalTransactionNumber ,
              ClinicalStatus ,
              MentalStatusExam ,
              ThoughContentDeniesEndorsesSuicidal , --tcde_suicidal ,
              ThoughContentDeniesEndorsesSuicidalComment ,--  tce_suicidal_comment ,
              ThoughContentDeniesEndorsesHomicidal , --  tcde_homicidal ,
              ThoughContentDeniesEndorsesHomicidalComment , --  tce_homicidal_comment ,
              ThoughContentDeniesEndorsesSelfInjuriousThoughts , --  tcde_self_injury_thots ,
              ThoughContentDeniesEndorsesSelfInjuriousThoughtsComment , --  tce_self_injury_thots_comment ,
              ThoughContentDeniesEndorsesSelfInjuriousBehavior ,--  tcde_self_injury_behavior ,
              ThoughContentDeniesEndorsesSelfInjuriousBehaviorComment , --  tce_self_injury_behavior_comt ,
              ThoughContentDeniesEndorsesDelusions ,--  tcde_delusions ,
              ThoughContentDeniesEndorsesDelusionsComment ,--  tce_delusions_comment ,
              ThoughContentDeniesEndorsesImpulsivity ,   --  tcde_impulse_control ,
              ThoughContentDeniesEndorsesImpulsivityComment , --  tce_impulse_control_comment ,
              ThoughContentDeniesEndorsesObsessionCompulsions , --  tcde_obsession_compulsion ,
              ThoughContentObsessionComment , --  tce_obsession_comment ,
              ThoughContentDeniesEndorsesOther , --  tce_other ,
              ThoughContentDeniesEndorsesOtherComment , --  tce_other_comment ,
              ThoughContentAtBaseline , --  tc_at_baseline ,
              ThoughContentAtBaselineComment , --  tc_at_baseline_comment ,
              ThoughContentComment , --  tc_comment ,              
              DelusionalContetParanoid ,
              DelusionalContetReligious ,
              DelusionalContetSomatic ,
              DelusionalContetJealous ,
              DelusionalContetErotomanic ,
              DelusionalContetOther ,
              DelusionalContet ,
              CognitionMemoryComment ,
              CognitionAttnComment ,
              ChangesResponse ,
              TreatmentRecommendation ,
              Comments ,
              LastSeenByOther ,
              LastSeenByAuthorID ,
              Allergies ,
              GAFScore ,
              PatientIdent ,
              MedicationEducation 
            )
            SELECT  dvm.DocumentVersionId ,
                    d.orig_user_id ,
                    d.orig_entry_chron ,
                    d.user_id ,
                    d.entry_chron ,
                    clinical_transaction_no ,
                    clinical_status ,
                    mental_status_exam ,
                    tcde_suicidal ,
                    tce_suicidal_comment ,
                    tcde_homicidal ,
                    tce_homicidal_comment ,
                    tcde_self_injury_thots ,
                    tce_self_injury_thots_comment ,
                    tcde_self_injury_behavior ,
                    tce_self_injury_behavior_comt ,
                    tcde_delusions ,
                    tce_delusions_comment ,
                    tcde_impulse_control ,
                    tce_impulse_control_comment ,
                    tcde_obsession_compulsion ,
                    tce_obsession_comment ,
                    tce_other ,
                    tce_other_comment ,
                    tc_at_baseline ,
                    tc_at_baseline_comment ,
                    tc_comment ,
                    dc_paranoid ,
                    dc_religious ,
                    dc_somatic ,
                    dc_jealous ,
                    dc_erotomanic ,
                    dc_other ,
                    dc_other_val ,
                    cognition_memory_comment ,
                    cognition_attn_comment ,
                    changes_response ,
                    treatment_recommendation ,
                    comments ,                 
                    last_seen_by_other ,
                    last_seen_by_author_id ,
                    allergies ,
                    gaf_score ,
                    patient_iden ,
                    medication_education
            FROM    Psych..Doc_Rx_Mgt d
                    LEFT JOIN Cstm_Conv_Map_DocumentVersions dvm ON dvm.doc_session_no = d.doc_session_no
                                                              AND dvm.version_no = d.doc_version_no
            WHERE   NOT EXISTS ( SELECT *
                                 FROM   MedicationManagementList c
                                 WHERE  c.DocumentVersionId = ISNULL(dvm.DocumentVersionId,
                                                              -1) )    
    IF @@error <> 0 
        GOTO error

    RETURN

    error:

    RAISERROR 5010 ''Failed to execute csp_conv_Document_MedicationManagementList''
' 
END
GO
