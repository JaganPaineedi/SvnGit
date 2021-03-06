/****** Object:  StoredProcedure [dbo].[csp_validateDocumentCaseConferenceNotes]    Script Date: 06/19/2013 17:49:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateDocumentCaseConferenceNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateDocumentCaseConferenceNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateDocumentCaseConferenceNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [dbo].[csp_validateDocumentCaseConferenceNotes]      
@DocumentVersionId Int      
as      
BEGIN
BEGIN TRY     
      
CREATE TABLE [#CustomDocumentCaseConferenceNotes] (      
            DocumentVersionId int null,
            PurposeProblemSolving char(1) null,
            PurposeTransferCase char(1) null,
            PurposeAddtionalServicesNeeded char(1) null,
            PurposeOther char(1) null,
            PurposeOtherComment varchar(max) null,
            StaffedWithCSPCaseManager char(1) null,
            StaffedWithVocationalStaff char(1) null,
            StaffedWithPsychologyStaff char(1) null,
            StaffedWithEAPConsultant char(1) null,
            StaffedWithSupervisor char(1) null,
            StaffedWithMedicalStaff char(1) null,
            StaffedWithQI char(1) null,
            StaffedWithClinicalTeamMeeting char(1) null,
            StaffedWithTherapist char(1) null,
            StaffedWithOpportunityManagement char(1) null,
            StaffedWithOther char(1) null,
            StaffedWithOtherComment varchar(max) null,
            IssuesProblem varchar(max) null,
            InterventionsContracting char(1) null,
            InterventionsMeetingParentsFamilyOther char(1) null,
            InterventionsClassroomReorganization char(1) null,
            InterventionsIndividualCounseling char(1) null,
            InterventionsCommunitySupport char(1) null,
            InterventionsClassroomConsultation char(1) null,
            InterventionsMeetingInterventionTeam char(1) null,
            InterventionsStaffing char(1) null,
            Interventions1to1Intervention char(1) null,
            InterventionsGroupCounseling char(1) null,
            InterventionsVocationServices char(1) null,
            InterventionsOther char(1) null,
            InterventionsOtherComment varchar(max) null,	
            WorkedPastWithClient varchar(max) null,
            SpecificTimeDayWeek varchar(max) null,
            NaturalSupportsAvailable varchar(max) null,
            ClientStrengthsSupportProgress varchar(max) null,
            PlanOfAction varchar(max) null
)      
      
INSERT INTO [#CustomDocumentCaseConferenceNotes](      
            DocumentVersionId,
            PurposeProblemSolving,
            PurposeTransferCase,
            PurposeAddtionalServicesNeeded,
            PurposeOther,
            PurposeOtherComment,
            StaffedWithCSPCaseManager,
            StaffedWithVocationalStaff,
            StaffedWithPsychologyStaff,
            StaffedWithEAPConsultant,
            StaffedWithSupervisor,
            StaffedWithMedicalStaff,
            StaffedWithQI,
            StaffedWithClinicalTeamMeeting,
            StaffedWithTherapist,
            StaffedWithOpportunityManagement,
            StaffedWithOther,
            StaffedWithOtherComment,
            IssuesProblem,
            InterventionsContracting,
            InterventionsMeetingParentsFamilyOther,
            InterventionsClassroomReorganization,
            InterventionsIndividualCounseling,
            InterventionsCommunitySupport,
            InterventionsClassroomConsultation,
            InterventionsMeetingInterventionTeam,
            InterventionsStaffing,
            Interventions1to1Intervention,
            InterventionsGroupCounseling,
            InterventionsVocationServices,
            InterventionsOther,
            InterventionsOtherComment,
            WorkedPastWithClient,
            SpecificTimeDayWeek,
            NaturalSupportsAvailable,
            ClientStrengthsSupportProgress,
            PlanOfAction
)      
select      
            a.DocumentVersionId,
            a.PurposeProblemSolving,
            a.PurposeTransferCase,
            a.PurposeAddtionalServicesNeeded,
            a.PurposeOther,
            a.PurposeOtherComment,
            a.StaffedWithCSPCaseManager,
            a.StaffedWithVocationalStaff,
            a.StaffedWithPsychologyStaff,
            a.StaffedWithEAPConsultant,
            a.StaffedWithSupervisor,
            a.StaffedWithMedicalStaff,
            a.StaffedWithQI,
            a.StaffedWithClinicalTeamMeeting,
            a.StaffedWithTherapist,
            a.StaffedWithOpportunityManagement,
            a.StaffedWithOther,
            a.StaffedWithOtherComment,
            a.IssuesProblem,
            a.InterventionsContracting,
            a.InterventionsMeetingParentsFamilyOther,
            a.InterventionsClassroomReorganization,
            a.InterventionsIndividualCounseling,
            a.InterventionsCommunitySupport,
            a.InterventionsClassroomConsultation,
            a.InterventionsMeetingInterventionTeam,
            a.InterventionsStaffing,
            a.Interventions1to1Intervention,
            a.InterventionsGroupCounseling,
            a.InterventionsVocationServices,
            a.InterventionsOther,
            a.InterventionsOtherComment,
            a.WorkedPastWithClient,
            a.SpecificTimeDayWeek,
            a.NaturalSupportsAvailable,
            a.ClientStrengthsSupportProgress,
            a.PlanOfAction
from CustomDocumentCaseConferenceNotes a       
where a.DocumentVersionId = @DocumentVersionId and isnull(a.RecordDeleted,''N'')<>''Y''      
    
insert into #ValidationReturnTable (
	TableName,  
	ColumnName,  
	ErrorMessage,  
	TabOrder,  
	ValidationOrder  
)
select ''CustomDocumentCaseConferenceNotes'', ''PurposeProblemSolving'', ''Purpose must be specified.'', 1, 1
from #CustomDocumentCaseConferenceNotes
where (
	isnull(PurposeProblemSolving, ''N'') = ''N'' and
	isnull(PurposeTransferCase, ''N'') = ''N'' and
	isnull(PurposeAddtionalServicesNeeded, ''N'') = ''N'' and
	isnull(PurposeOther, ''N'') = ''N''
)
or (
	isnull(PurposeOther, ''N'') = ''Y''
	and LEN(ISNULL(PurposeOtherComment, '''')) = 0
)
union
select ''CustomDocumentCaseConferenceNotes'', ''StaffedWithCSPCaseManager'', ''Staffed with must be specified.'', 1, 2
from #CustomDocumentCaseConferenceNotes
where (
	isnull(StaffedWithCSPCaseManager, ''N'') = ''N'' and
	isnull(StaffedWithVocationalStaff, ''N'') = ''N'' and
	isnull(StaffedWithPsychologyStaff, ''N'') = ''N'' and
	isnull(StaffedWithEAPConsultant, ''N'') = ''N'' and
	isnull(StaffedWithSupervisor, ''N'') = ''N'' and
	isnull(StaffedWithMedicalStaff, ''N'') = ''N'' and
	isnull(StaffedWithQI, ''N'') = ''N'' and
	isnull(StaffedWithClinicalTeamMeeting, ''N'') = ''N'' and
	isnull(StaffedWithTherapist, ''N'') = ''N'' and
	isnull(StaffedWithOpportunityManagement, ''N'') = ''N'' and
	isnull(StaffedWithOther, ''N'') = ''N''
)
or (
	isnull(StaffedWithOther, ''N'') = ''Y''
	and LEN(ISNULL(StaffedWithOtherComment, '''')) = 0
)
union
select ''CustomDocumentCaseConferenceNotes'', ''IssuesProblem'', ''Issues/problem must be specified.'', 1, 3
from #CustomDocumentCaseConferenceNotes
where LEN(ISNULL(IssuesProblem, '''')) = 0
union
select ''CustomDocumentCaseConferenceNotes'', ''IssuesProblem'', ''Intervention must be specified.'', 1, 4
from #CustomDocumentCaseConferenceNotes
where (
	isnull(InterventionsContracting, ''N'') = ''N'' and
	isnull(InterventionsMeetingParentsFamilyOther, ''N'') = ''N'' and
	isnull(InterventionsClassroomReorganization, ''N'') = ''N'' and
	isnull(InterventionsIndividualCounseling, ''N'') = ''N'' and
	isnull(InterventionsCommunitySupport, ''N'') = ''N'' and
	isnull(InterventionsClassroomConsultation, ''N'') = ''N'' and
	isnull(InterventionsMeetingInterventionTeam, ''N'') = ''N'' and
	isnull(InterventionsStaffing, ''N'') = ''N'' and
	isnull(Interventions1to1Intervention, ''N'') = ''N'' and
	isnull(InterventionsGroupCounseling, ''N'') = ''N'' and
	isnull(InterventionsVocationServices, ''N'') = ''N'' and
	isnull(InterventionsOther, ''N'') = ''N''
) or (
		isnull(InterventionsOther, ''N'') = ''Y'' and
		LEN(isnull(InterventionsOtherComment, '''')) = 0
)
union
select ''CustomDocumentCaseConferenceNotes'', ''PlanOfAction'', ''Plan must be specified.'', 1, 5
from #CustomDocumentCaseConferenceNotes
where LEN(ISNULL(PlanOfAction, '''')) = 0

--    
-- DECLARE VARIABLES    
--    
declare @Variables varchar(max)    
declare @DocumentType varchar(20)    
Declare @DocumentCodeId int    

    
--    
-- DECLARE TABLE SELECT VARIABLES    
--    
set @Variables = ''Declare @DocumentVersionId int    
     Set @DocumentVersionId = '' + convert(varchar(20), @DocumentVersionId)        
    
    
Set @DocumentCodeId = (Select DocumentCodeId From Documents Where CurrentDocumentVersionId = @DocumentVersionId)    
set @DocumentType = NULL    
    
--    
-- Exec csp_validateDocumentsTableSelect to determine validation list    
--    
Exec csp_validateDocumentsTableSelect @DocumentVersionId, @DocumentCodeId, @DocumentType, @Variables  
          
END TRY

BEGIN CATCH     
   DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ ''*****'' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),''csp_validateDocumentCaseConferenceNotes'')                                                                                             
			+ ''*****'' + CONVERT(VARCHAR,ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ ''*****'' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
END CATCH

return  

END
' 
END
GO
