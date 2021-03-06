/****** Object:  StoredProcedure [dbo].[csp_conv_Document_CustomDocumentCaseConferenceNotes]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_CustomDocumentCaseConferenceNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conv_Document_CustomDocumentCaseConferenceNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_CustomDocumentCaseConferenceNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'    
create procedure [dbo].[csp_conv_Document_CustomDocumentCaseConferenceNotes]   
as  
  
insert into CustomDocumentCaseConferenceNotes (  
       DocumentVersionId  
      ,CreatedBy  
      ,CreatedDate  
      ,ModifiedBy  
      ,ModifiedDate  
      ,PurposeProblemSolving  
      ,PurposeTransferCase  
      ,PurposeAddtionalServicesNeeded  
      ,PurposeOther  
      ,PurposeOtherComment  
      ,StaffedWithCSPCaseManager  
      ,StaffedWithVocationalStaff  
      ,StaffedWithPsychologyStaff  
      ,StaffedWithEAPConsultant  
      ,StaffedWithSupervisor  
      ,StaffedWithMedicalStaff  
      ,StaffedWithQI  
      ,StaffedWithClinicalTeamMeeting  
      ,StaffedWithTherapist  
      ,StaffedWithOpportunityManagement  
      ,StaffedWithOther  
      ,StaffedWithOtherComment  
      ,IssuesProblem  
      ,InterventionsContracting  
      ,InterventionsMeetingParentsFamilyOther  
      ,InterventionsClassroomReorganization  
      ,InterventionsIndividualCounseling  
      ,InterventionsCommunitySupport  
      ,InterventionsClassroomConsultation  
      ,InterventionsMeetingInterventionTeam  
      ,InterventionsStaffing  
      ,Interventions1to1Intervention  
      ,InterventionsGroupCounseling  
      ,InterventionsVocationServices  
      ,InterventionsOther  
      ,InterventionsOtherComment  
      ,WorkedPastWithClient  
      ,SpecificTimeDayWeek  
      ,NaturalSupportsAvailable  
      ,ClientStrengthsSupportProgress  
      ,PlanOfAction)  
select dvm.DocumentVersionId  
      ,d.orig_user_id  
      ,d.orig_entry_chron  
      ,d.user_id  
      ,d.entry_chron  
      ,case when d.purpose_conference = ''PS'' then ''Y'' else null end  
      ,case when d.purpose_conference = ''TC'' then ''Y'' else null end  
      ,case when d.purpose_conference = ''AS'' then ''Y'' else null end  
      ,case when d.purpose_conference = ''OT'' then ''Y'' else null end  
      ,d.purpose_other  
      ,d.csp  
      ,d.voc_staff  
      ,d.psych_staff  
      ,d.eap  
      ,d.super  
      ,d.med_staff  
      ,d.qi_staff  
      ,d.clin_team  
      ,d.therapist  
      ,d.eqc  
      ,null -- StaffedWithOther  
      ,null -- StaffedWithOtherComment  
      ,d.issues  
      ,d.contracting  
      ,d.mtg_parents  
      ,d.class_reorg  
      ,case when d.indiv_cn = ''M'' then ''N'' else d.indiv_cn end  
      ,d.comm_support  
      ,d.class_consult  
      ,d.mtg_intervention  
      ,d.staffing  
      ,case when isnull(d.intervention, '''') = '''' then null else d.intervention end  
      ,d.group_couns  
      ,d.vocational  
      ,d.other_intervention  
      ,d.other_inter_desc  
      ,null --WorkedPastWithClient  
      ,null --SpecificTimeDayWeek  
      ,null --NaturalSupportsAvailable  
      ,null --ClientStrengthsSupportProgress  
      ,d.plan_of_action  
  from Psych..cstm_doc_case_conf d  
       join Cstm_Conv_Map_DocumentVersions dvm on dvm.doc_session_no = d.doc_session_no and dvm.version_no = d.version_no  
 where not exists(select *  
                    from CustomDocumentCaseConferenceNotes c  
                   where c.DocumentVersionId = isnull(dvm.DocumentVersionId, -1))          
         
if @@error <> 0 goto error  
  
return  
  
error:  
  
raiserror 50010 ''Failed to execute csp_conv_Document_CustomDocumentCaseConferenceNotes''  
  
' 
END
GO
