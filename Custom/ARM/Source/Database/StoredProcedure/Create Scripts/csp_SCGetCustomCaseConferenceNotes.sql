/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomCaseConferenceNotes]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomCaseConferenceNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomCaseConferenceNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomCaseConferenceNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'    
create PROCEDURE  [dbo].[csp_SCGetCustomCaseConferenceNotes] 
@DocumentVersionId INT      
AS        
BEGIN  
 BEGIN TRY              
  SELECT    [DocumentVersionId],
            [CreatedBy],
            [CreatedDate],
            [ModifiedBy],
            [ModifiedDate],
            [RecordDeleted],
            [DeletedBy],
            [DeletedDate],
            [PurposeProblemSolving],
            [PurposeTransferCase],
            [PurposeAddtionalServicesNeeded],
            [PurposeOther],
            [PurposeOtherComment],
            [StaffedWithCSPCaseManager],
            [StaffedWithVocationalStaff],
            [StaffedWithPsychologyStaff],
            [StaffedWithEAPConsultant],
            [StaffedWithSupervisor],
            [StaffedWithMedicalStaff],
            [StaffedWithQI],
            [StaffedWithClinicalTeamMeeting],
            [StaffedWithTherapist],
            [StaffedWithOpportunityManagement],
            [StaffedWithOther],
            [StaffedWithOtherComment],
            [IssuesProblem],
            [InterventionsContracting],
            [InterventionsMeetingParentsFamilyOther],
            [InterventionsClassroomReorganization],
            [InterventionsIndividualCounseling],
            [InterventionsCommunitySupport],
            [InterventionsClassroomConsultation],
            [InterventionsMeetingInterventionTeam],
            [InterventionsStaffing],
            [Interventions1to1Intervention],
            [InterventionsGroupCounseling],
            [InterventionsVocationServices],
            [InterventionsOther],
            [InterventionsOtherComment],
            [WorkedPastWithClient],
            [SpecificTimeDayWeek],
            [NaturalSupportsAvailable],
            [ClientStrengthsSupportProgress],
            [PlanOfAction]
 FROM       [dbo].[CustomDocumentCaseConferenceNotes]
 WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @DocumentVersionId)        
      
END TRY

BEGIN CATCH      
 DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ ''*****'' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),''csp_SCGetCustomCaseConferenceNotes'')                                                                                             
			+ ''*****'' + CONVERT(VARCHAR,ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ ''*****'' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
END CATCH            
END 
' 
END
GO
