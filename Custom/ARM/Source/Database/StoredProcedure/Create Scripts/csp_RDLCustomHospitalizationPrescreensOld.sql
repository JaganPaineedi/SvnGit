/****** Object:  StoredProcedure [dbo].[csp_RDLCustomHospitalizationPrescreensOld]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomHospitalizationPrescreensOld]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomHospitalizationPrescreensOld]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomHospitalizationPrescreensOld]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_RDLCustomHospitalizationPrescreensOld]             
(                                  
@DocumentId int,             
@Version int            
)                                  
      
As                                  
                                          
Begin                                          
/*********************************************************************/                                            
/* Stored Procedure:csp_RDLCustomHospitalizationPrescreensOld   */                                   
                                  
/* Copyright: 2006 Streamline SmartCare*/                                            
                                  
/* Creation Date:  Dec 19 ,2007                                  */                                            
/*                                                                   */                                            
/* Purpose: Gets Data from CustomHospitalizationPrescreensOld */                                           
/*                                                                   */                                          
/* Input Parameters: DocumentID,Version */                                          
/*                                                                   */                                             
/* Output Parameters:                                */                                            
/*                                                                   */                                            
/*    */                                            
/*                                                                   */                                            
/* Purpose Use For Rdl Report  */                                  
/*      */                                  
                                  
/*                                                                   */                                            
/* Calls:                                                            */                                            
/*                                                                   */                                            
/* Author Vikas Vyas                                     */                                            
/*                                                                   */                                            
/*                                                             */                                            
                                  
/*                                        */                                            
/*           */                                            
/*********************************************************************/                                             
        
SELECT d.[DocumentId]        
      ,CHPOld.[Version] 
	  ,d.[ClientID]       
      ,CHPOld.[DocumentCodeId]        
      ,[DocumentCodeVersion]        
      ,[event_date]         
       ,LTRIM(RIGHT(CONVERT(VARCHAR(20),initial_call_time, 22), 11)) as [initial_call_time]  
       ,LTRIM(RIGHT(CONVERT(VARCHAR(20),event_start_time, 22), 11)) as [event_start_time]  
       ,LTRIM(RIGHT(CONVERT(VARCHAR(20),disposition_time, 22), 11)) as [disposition_time]  
         ,LTRIM(RIGHT(CONVERT(VARCHAR(20),event_stop_time, 22), 11)) as   [event_stop_time]  
         ,[elapsed_screen_time]        
         ,[travel_time]        
        ,LTRIM(RIGHT(CONVERT(VARCHAR(20),provider_response_time, 22), 11)) as [provider_response_time]   
        ,LTRIM(RIGHT(CONVERT(VARCHAR(20),referral_to_provider_time, 22), 11)) as [referral_to_provider_time] 
    ,Case cmh_status             
        When ''O'' then  ''Open''      
     When ''C'' then ''Closed''      
     When ''N'' then ''New''      
  When ''P'' then ''Pending''      
        Else ''''      
        End       
        As      
        cmh_status             
            
     ,[patient_id]        
      
,Case sex      
 When ''F'' then ''Female''      
 When ''M'' then ''Male''      
 Else ''''      
 End      
 As       
 sex      
      
, Case marital_status          
  When ''D'' then ''Divorced''      
  When ''M'' then  ''Married''      
  When ''P'' then ''Separated''       
  When ''S'' then ''Single''      
  When ''U'' then ''Unreported''       
  When ''W'' then  ''Widowed''      
  Else ''''      
  End      
  As        
marital_status          
      
      
      
,Case ethnicity      
 WHEN ''ARAB'' then ''Arab American''      
 WHEN ''ASIAN'' then ''Asian / Pacific Islander''      
 WHEN ''BLACK'' then  ''Black / African American''      
 WHEN ''HISPANIC'' then ''Hispanic''      
 WHEN ''MULTIRACIA'' then ''Multi Racial''      
 WHEN ''NATIVE'' then ''Native American / Indian''      
 WHEN ''REFUSED'' then ''Consumer refused to provide information''      
 WHEN ''UNREP'' then ''Unreported''      
 WHEN ''WHITE'' then ''White / Caucasian''      
 Else ''''      
 End      
 As      
 ethnicity      
      
 ,[customer_name]        
      ,[ssn]        
      ,[dob]        
      ,[addr_1]        
      ,[addr_2]        
      ,[city]        
      ,[state]        
      ,[zip]        
      ,[county]        
      ,[home_phone]        
      ,[emergency_contact]        
            
      
,Case emergency_contact_relationship      
When ''AU'' then  ''Aunt''                                                    
When ''BIL'' then  ''Brother In Law''                                                
When ''BR'' then ''Brother''      
When ''CLIN'' then ''Mental Health Clinician''      
When ''COU'' then  ''Cousin''      
When ''DA'' then ''Daughter''      
When ''DIL'' then ''Daughter In Law''      
When ''DPOA'' then ''Durable Power of Attorney''      
When ''FA'' then ''Father''      
When ''FOSTER'' then ''Foster Parent''      
When  ''FRIEND'' then ''Friend''      
When  ''G'' then  ''Guardian''       
When ''HU'' then ''Husband''      
When ''MC'' then ''Managed Care Contact''      
When ''MF'' then ''Maternal Grandfather''      
When  ''MI'' then ''Mother In Law''      
When ''MM'' then ''Maternal Grandmother''      
When ''MO'' then ''Mother''      
When ''NE'' then ''Nephew''                                   
When ''NEIGHBOR'' then ''Neighbor''       
When ''NI'' then ''Niece''      
When ''OT'' then  ''Other (Special Status)''                                  
When ''PCP'' then ''Primary Care Physician''       
When ''PF'' then  ''Paternal Grandfather''      
When ''PM'' then ''Paternal Grandmother''      
When ''PROB'' then ''Probation Officer''      
When ''PROF'' then ''Professional''      
When ''SELF'' then ''Self''      
When ''SF'' then ''Step Father''      
When ''SI'' then ''Sister''      
When ''SIL'' then ''Sister In Law''      
When ''SM'' then ''Step Mother''      
When ''SO'' then ''Son''      
When ''TE'' then ''Teacher''      
When ''UN'' then ''Uncle''      
When ''WI'' then ''Wife''      
Else ''''      
End      
As      
emergency_contact_relationship        
         
      
,[emergency_contact_phone]        
      ,[responsible_person]        
      ,[responsible_phone]        
      ,[pay_source_indigent]      
      ,[pay_source_priv]        
      ,[pay_source_priv_cov_name]        
      ,[pay_source_priv_emp]        
      ,[pay_source_priv_ins_id]        
      ,[pay_source_medicare]       
      ,[pay_source_medicare_id]      
      ,case pay_source_medcicare_type
       When ''A'' then ''Part A''
	   When ''B'' then ''Part B''
	   Else ''''
       End
       As
	   pay_source_medcicare_type   
      ,[pay_source_medicaid]        
      ,[pay_source_medicaid_id]        
      ,[pay_source_medicaid_type]        
      ,[pay_source_medicaid_verified]        
      ,[pay_source_va]        
      ,[pay_source_other]        
      ,[pay_source_other_note]        
      ,[service_requested]        
      ,[service_requested_other]        
      ,[referral_source]        
      ,[referal_source_contacted]        
      ,[referral_source_explain]        
      ,[referral_source_org]        
      ,[referral_source_other]        
 ,Case screen_contact_type      
 When ''PHONE'' then ''Phone''      
 When ''F2F'' then ''Face to Face''  
 Else ''''     
 End      
 As       
 screen_contact_type           

      ,[precipitating_events]        
      ,[risk_others_agress_within_24_hours]        
      ,[risk_others_agress_within_48_hours]        
      ,[risk_others_agress_within_4_weeks]        
      ,[risk_others_none]        
      ,[risk_others_ideation]        
      ,[risk_others_ideation_desc]        
      ,[risk_others_awol]        
      ,[risk_others_verbal]        
      ,[risk_others_verbal_desc]        
      ,[risk_others_physical]        
      ,[risk_others_physical_desc]        
      ,[risk_others_sexual]        
      ,[risk_others_sexual_desc]        
      ,[risk_others_property]        
      ,[risk_others_property_desc]        
      ,[risk_others_history]        
      ,[risk_others_charges_pending]        
      ,[risk_others_charges_desc]        
      ,[risk_others_jail_hold]        
      ,[risk_self_ideation]        
      ,[risk_self_active]        
      ,[risk_self_passive]        
      ,[risk_self_within_48_hours]        
      ,[risk_self_within_14_days]        
      ,[risk_self_has_plan]        
      ,[risk_self_plan_describe]        
      ,[risk_self_ego_syntonic]        
      ,[risk_self_ego_dystonic]        
      ,[risk_self_ego_describe]        
      ,[risk_self_access_means]        
      ,[risk_self_access_describe]        
      ,[risk_self_hist_suicide_24_months]        
      ,[risk_self_family_completions]        
      ,[risk_self_diag_depression]        
      ,[risk_self_previous_rescue]        
      ,[risk_self_family_no_support]        
      ,[risk_self_family_unwilling]        
      ,[risk_self_alchol_drug_depend]        
      ,[risk_self_constricted_thinking]        
      ,[risk_self_egosyntoic_attitude]        
      ,[risk_self_helplessness]        
      ,[risk_self_hopelessness]        
      ,[risk_self_making_preparations]        
      ,[risk_self_no_ambivalence]        
      ,[risk_self_harmful_behavior]        
      ,[risk_self_harmful_describe]        
      ,[risk_self_previous_behavior]        
      ,[risk_self_previous_describe]        
      ,[risk_self_outcome_rescue]        
      ,[risk_self_previous_outcome_rescue]        
      ,[risk_self_family_hx_suicide]        
      ,[ms_appear_neat_clean]        
      ,[ms_appear_appropriate]        
      ,[ms_appear_unkempt]        
      ,[ms_activity_lethargic]        
      ,[ms_activity_unremarkable]        
      ,[ms_activity_restless]        
      ,[ms_eye_contact_intense]        
      ,[ms_eye_contact_appropiate]        
      ,[ms_eye_contact_avoided]        
      ,[ms_gait_unremarkable]        
      ,[ms_gait_unable_assess]        
      ,[ms_gait_unsteady]        
      ,[ms_mood_pleasant]        
      ,[ms_mood_friendly]        
      ,[ms_mood_appropiate]        
      ,[ms_mood_incongruent]        
      ,[ms_mood_inappropiate]        
      ,[ms_mood_hostile]        
      ,[ms_mood_angry]        
      ,[ms_mood_tearful]        
      ,[ms_affect_restricted]        
      ,[ms_affect_unremarkable]        
      ,[ms_affect_expansive]        
      ,[ms_thought_lucid]        
      ,[ms_thought_paranoid]        
      ,[ms_thought_obsessive]        
      ,[ms_thought_obsessive_about]        
      ,[ms_thought_compulsive]        
      ,[ms_thought_tangential]        
      ,[ms_thought_loose_association]        
      ,[ms_thought_psychosis]        
      ,[ms_thought_preoccupied]        
      ,[ms_thought_confused]        
      ,[ms_thought_preoccupied_with]        
      ,[ms_thought_impoverished]        
      ,[ms_thought_delusional]        
      ,[ms_thought_hallicinatory]        
      ,[ms_orient_person]        
      ,[ms_orient_place]        
      ,[ms_orient_time]        
      ,[ms_orient_situation]        
      ,[ms_speech_articulate]        
      ,[ms_speech_clear]        
      ,[ms_speech_soft]        
      ,[ms_speech_loud]        
      ,[ms_speech_lethargic]        
      ,[ms_speech_rapid]        
      ,[ms_speech_pressured]        
      ,[ms_speech_slurred]        
      ,[ms_speech_neologistic]        
      ,[ms_insight_good]        
      ,[ms_insight_impaired]        
      ,[ms_insight_age_appropriate]        
      ,[ms_insight_impaired_describe]        
      ,[ms_remote_memory_good]        
     ,[ms_remote_memory_impaired]        
      ,[ms_remote_memory_age_appropriate]        
      ,[ms_recent_memory_good]        
      ,[ms_recent_memory_impaired]        
      ,[ms_recent_memory_age_appropriate]        
      ,[ms_loc_alert]        
      ,[ms_loc_sedate]        
      ,[ms_loc_obtunded]        
      ,[ms_loc_lethargic]        
      ,[ms_loc_other]        
      ,[ms_loc_other_describe]        
      ,[ms_attn_intact]        
      ,[ms_px_grooming]        
      ,[ms_sleep_disturbance]        
      ,[ms_sleep_disturbance_describe]        
      ,[ms_eating_disturbance]        
      ,[ms_eating_disturbance_describe]        
      ,[ms_not_medication_compliant]        
      ,[ms_attn_impaired]        
      ,[ms_attn_age_appropriate]        
      ,[ms_judgement_intact]        
      ,[ms_judgement_impaired]        
      ,[ms_judgement_age_appropriate]        
      ,[ms_judgement_impaired_desribe]        
      ,[sa_current_use]        
      ,[sa_name_1]        
      ,[sa_amount_1]        
      ,[sa_frequency_1]        
      ,[sa_name_2]        
      ,[sa_amount_2]        
      ,[sa_frequency_2]        
      ,[sa_name_3]        
      ,[sa_amount_3]        
      ,[sa_frequency_3]        
      ,[sa_symptom_odor]        
      ,[sa_symptom_slurred]        
      ,[sa_symptom_withdrawal]        
      ,[sa_symptom_dts_other]        
      ,[sa_symptom_dts_describe]        
      ,[sa_symptom_blackouts]        
      ,[sa_symptom_arrests]        
      ,[sa_symptom_social_problems]        
      ,[sa_symptom_job_school_absence]        
      ,[sa_previous_treatment]        
      ,[toxicology_results]        
      ,[sa_current_treatment]        
      ,[sa_current_provider]        
      ,[sa_history_abuse]        
      ,[sa_history_describe]        
      ,[sa_referral_completed]        
      ,[sa_referral_describe]        
      ,[sa_bal_at_screen]        
      ,[sa_bal_at_admit]        
      ,[mh_hx_unable_obtain]        
      ,[mh_hx_num_inpatient]        
      ,[mh_hx_most_recent_ip]        
      ,[mh_hx_most_recent_facility]        
      ,[mh_hx_previous_op]        
      ,[mh_hx_previous_op_date]        
      ,[mh_hx_current_case_mgr]        
      ,[health_pcp_name]        
      ,[health_pcp_phone]        
      ,[health_allergies]        
      ,[health_current_concerns]        
      ,[health_previous_concerns]        
      ,[med_name_1]        
      ,[med_dosage_1]        
      ,[med_frequency_1]        
      ,[med_prescriber_1]        
      ,[med_name_2]        
      ,[med_dosage_2]        
      ,[med_frequency_2]        
      ,[med_prescriber_2]        
      ,[med_name_3]        
      ,[med_dosage_3]        
      ,[med_frequency_3]        
      ,[med_prescriber_3]        
      ,[med_name_4]        
      ,[med_dosage_4]        
      ,[med_frequency_4]        
      ,[med_prescriber_4]        
      ,[med_name_5]        
      ,[med_dosage_5]        
      ,[med_frequency_5]        
      ,[med_prescriber_5]        
      ,[med_name_6]        
      ,[med_dosage_6]        
      ,[med_frequency_6]        
      ,[med_prescriber_6]        
      ,[med_listed_elswhere]        
      ,[sev_psych_symptoms]        
      ,[sev_harm_self]        
      ,[sev_harm_others]        
      ,[sev_drug_complications]        
      ,[sev_disruption_self_care]        
      ,[sev_personal_adjust_child]        
      ,[intensity_op_a]        
      ,[intensity_op_b]        
      ,[intensity_op_c]        
      ,[intensity_op_d]        
      ,[intensity_cr_e]        
      ,[intensity_cr_f]        
      ,[intensity_cr_g]        
      ,[intensity_cr_h]        
      ,[intensity_cr_i]        
      ,[intensity_cr_j]        
      ,[intensity_ph_k]        
      ,[intensity_ph_l]        
      ,[intensity_ph_m]        
      ,[intensity_ph_n]        
      ,[intensity_co_o]        
      ,[intensity_co_p]        
      ,[intensity_ops_q]        
      ,[axis_1_1]        
        
        ,Case axis_1_1_type    
        When ''P'' then  ''Primary''      
        When ''S'' then ''Secondary''    
     Else ''''    
        End      
        As    
        axis_1_1_type    
     
      ,[axis_1_1_ro]        
      , axis_1_2    
           
      ,Case axis_1_2_type     
       When ''P'' then ''Primary''    
       When ''S'' then ''Secondary''    
       Else ''''    
       End    
       as     
      axis_1_2_type     
      ,[axis_1_2_ro]        
      ,[axis_2_1]        
      ,Case axis_2_1_type    
       When ''P'' then ''Primary''    
       When ''S'' then ''Secondary''    
       Else ''''    
       End    
       As    
       axis_2_1_type    
              
      ,[axis_2_1_ro]        
      ,[axis_2_2]        
      ,Case axis_2_2_type    
       When ''P'' then ''Primary''    
       When ''S'' then ''Secondary''    
       Else ''''    
       End    
       As    
      axis_2_2_type    
     
      ,[axis_2_2_ro]        
      ,[axis_3_desc]        
   ,[axis_4_desc]        
      ,[current_gaf]        
      ,[screening_completed_by]        
      ,[screening_completed_co]        
      ,[screening_completed_credentials]        
      ,[disp_ip_voluntary]        
      ,[disp_ip_involuntary]        
      ,[disp_ip_facility]        
      ,[disp_disp_crisis_residential]        
      ,[disp_crisis_residential_program]        
      ,[disp_partial_hosp]        
      ,[disp_partial_hosp_facility]        
      ,[disp_act]        
      ,[disp_csm]        
      ,[disp_iop]        
      ,[disp_outpatient]        
      ,[disp_sa]        
      ,[disp_other]        
      ,[disp_other_specified]        
      ,[disp_provider_recommend]        
      ,[disp_family_notify_offered]        
      ,[disp_family_member_name]        
      ,[disp_ip_treatement_denied]        
      ,[disp_customer_second_opinion]        
      ,[disp_alternate_services]        
      ,[disp_alternate_services_desc]        
      ,[disp_alternate_services_agreed]        
      ,[disp_customer_refused_treatment]        
      ,[disp_crisis_resolved]        
      ,[signed_by_customer]        
      ,[witness_name]        
      ,[unable_to_obtain_signature]        
      ,[unable_to_obtain_rationale]        
      ,[summary]        
      ,[ms2_unable_assess]        
      ,[ms2_appear_age]        
      ,[ms2_appear_weight]        
      ,[ms2_appear_height]        
      ,[ms2_appear_grooming]        
      ,[ms2_appear_dreesed]        
      ,[ms2_appear_hygiene]        
      ,[ms2_appear_other]        
      ,[ms2_appear_comment]        
      ,[ms2_behav_gait]        
      ,[ms2_behav_tics]        
      ,[ms2_behav_tremors]        
      ,[ms2_behav_twitches]        
      ,[ms2_behav_lethargic]        
      ,[ms2_behav_aggressive]        
      ,[ms2_behav_agitated]        
      ,[ms2_behav_activity]        
      ,[ms2_behav_eye_contact]        
      ,[ms2_behav_other]        
      ,[ms2_behav_comment]        
      ,[ms2_attitude_cooperative]        
      ,[ms2_attitude_defensive]        
      ,[ms2_attitude_reserved]        
      ,[ms2_attitude_mistrustful]        
      ,[ms2_attitude_other]        
      ,[ms2_attitude_comment]        
      ,[ms2_speech_spontaneous]        
      ,[ms2_speech_coherent]        
      ,[ms2_speech_talkative]        
      ,[ms2_speech_verbal]        
      ,[ms2_speech_speed]        
      ,[ms2_speech_pressured]        
      ,[ms2_speech_monotonous]        
      ,[ms2_speech_volume]        
      ,[ms2_speech_slurred]        
      ,[ms2_speech_echolalia]        
      ,[ms2_speech_repetitive]        
      ,[ms2_speech_other]        
      ,[ms2_speech_comment]        
      ,[ms2_affect_blunted]        
      ,[ms2_affect_flat]        
      ,[ms2_affect_restricted]        
      ,[ms2_affect_expansive]        
      ,[ms2_affect_unremarkable]        
      ,[ms2_affect_congruent]        
      ,[ms2_affect_unable_assess]        
      ,[ms2_affect_other]        
      ,[ms2_affect_comment]        
      ,[ms2_mood_cheerful]        
      ,[ms2_mood_labile]        
      ,[ms2_mood_hostile]        
      ,[ms2_mood_anxious]        
      ,[ms2_mood_guilty]        
      ,[ms2_mood_angry]        
      ,[ms2_mood_irritable]        
      ,[ms2_mood_fearful]        
      ,[ms2_mood_sad]        
      ,[ms2_mood_other]        
      ,[ms2_mood_comment]        
      ,[ms2_cognition_obsessions]        
      ,[ms2_cognition_limited]        
      ,[ms2_cognition_phobias]        
      ,[ms2_cognition_normal]        
      ,[ms2_cognition_other]        
      ,[ms2_cognition_comment]        
      ,[ms2_attention_good]        
      ,[ms2_attention_impaired]        
      ,[ms2_attention_appropriate]        
      ,[ms2_attention_comment]        
      ,[ms2_orient_person]        
      ,[ms2_orient_place]        
      ,[ms2_orient_time]        
      ,[ms2_orient_circumstance]        
      ,[ms2_orient_explain]        
      ,[ms2_memory_intact]        
      ,[ms2_memory_short_tem]        
      ,[ms2_memory_long_term]        
      ,[ms2_memory_other]        
      ,[ms2_memory_comment]        
      ,[ms2_perceptual_none]        
      ,[ms2_perceptual_delusions]        
      ,[ms2_perceptual_auditory]        
      ,[ms2_perceptual_visual]        
      ,[ms2_perceptual_tactile]       
      ,[ms2_perceptual_olfactory]        
      ,[ms2_perceptual_depersonalization]        
      ,[ms2_perceptual_paranoia]        
      ,[ms2_perceptual_ideas_reference]        
      ,[ms2_perceptual_other]        
      ,[ms2_perceptual_comment]        
      ,[ms2_judgment_aware_symptoms]        
      ,[ms2_judgment_need_tx]        
      ,[ms2_judgment_outcome_behavior]        
      ,[ms2_judgment_risky_behavior]        
      ,[ms2_judgment_other]        
      ,[ms2_judgment_comment]        
      ,[residence_county_other_specify]        
      ,[screening_completed_other_co]        
      ,[notify_1]        
      ,[notify_2]        
      ,[notify_3]        
      ,[notify_4]        
      ,[notify_comment]        
      ,[notify_clinician_comment]        
      ,[notify_sent]        
      ,[forward_to_required]        
      ,[forward_to_staff_id]        
      ,[hosp_tab_id]        
      ,[screen_doc_service_type]        
            
 FROM Documents d
left join CustomHospitalizationPrescreensOld  CHPOld on CHPOld.DocumentId = d.DocumentId      
where   Isnull(CHPOld.RecordDeleted,''N'')<>''Y''  and  CHPOld.DocumentId=@DocumentId and CHPOld.Version=@Version              
        
  --Checking For Errors                                  
  If (@@error!=0)                                  
  Begin                                  
   RAISERROR  20006   ''[csp_RDLCustomHospitalizationPrescreensOld] : An Error Occured''                                   
   Return                                  
   End                                           
                                  
End
' 
END
GO
