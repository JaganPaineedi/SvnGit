/****** Object:  StoredProcedure [dbo].[csp_GetCustomDocumentHealthHomeCarePlans]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomDocumentHealthHomeCarePlans]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetCustomDocumentHealthHomeCarePlans]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomDocumentHealthHomeCarePlans]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE procedure [dbo].[csp_GetCustomDocumentHealthHomeCarePlans]
    @DocumentVersionId int
as 
select   hhp.DocumentVersionId,
        hhp.CreatedBy,
        hhp.CreatedDate,
        hhp.ModifiedBy,
        hhp.ModifiedDate,
        hhp.RecordDeleted,
        hhp.DeletedBy,
        hhp.DeletedDate,
        hhp.PrimaryCareProviderFirstName,
        hhp.PrimaryCareProviderLastName,
        hhp.PrimaryCareProviderOrganization,
        hhp.ProblemList,
        hhp.ClientHasLivingWillOrDurablePOA,
        hhp.LongTermCareNotNeeded,
        hhp.LongTermCareNeeded,
        hhp.AdmitToFacilityType,
        hhp.AdmitToFacility,
        hhp.AdmitToFacilityNotApplicable,
        hhp.AdmissionComments,
        hhp.PrimaryTreatingProviderInCare,
        hhp.AchievingOutcomeAssistanceObtainingHealthcare,
        hhp.AchievingOutcomeMedicationManagement,
        hhp.AchievingOutcomeTrackTestsReferrals,
        hhp.AchievingOutcomeCoordinateCollaborate,
        hhp.AchievingOutcomeCoordinateReferrals,
        hhp.AchievingOutcomeProvideHealthEducation,
        hhp.AchievingOutcomeProvideReferralsToSelfHelpSupport,
        hhp.AchievingOutcomeAppointmentReminders,
        hhp.AchievingOutcomeFacilitateTransitionDischarge,
        hhp.AchievingOutcomeAdvocacyAnalysisApplications,
        hhp.AchievingOutcomeReviewRecords,
        hhp.AchievingOutcomeSupportRelationships,
        hhp.AchievingOutcomeOther,
        hhp.AchievingOutcomeOtherComment,
        hhp.ClientGuardianParticipatedInPlan,
        hhp.ClientCardianReasonForNonParticipation
from    dbo.CustomDocumentHealthHomeCarePlans as hhp
where   hhp.DocumentVersionId = @DocumentVersionId

select  hhpo.CustomDocumentHealthHomeCarePlanOutcomeId,
        hhpo.CreatedBy,
        hhpo.CreatedDate,
        hhpo.ModifiedBy,
        hhpo.ModifiedDate,
        hhpo.RecordDeleted,
        hhpo.DeletedBy,
        hhpo.DeletedDate,
        hhpo.DocumentVersionId,
        hhpo.OutcomeSequence,
        hhpo.OutcomeDescription,
        hhpo.OutcomeCriteria,
        hhpo.TargetDate
from    dbo.CustomDocumentHealthHomeCarePlanOutcomes as hhpo
where   hhpo.DocumentVersionId = @DocumentVersionId
        and ISNULL(hhpo.RecordDeleted, ''N'') <> ''Y''
order by hhpo.OutcomeSequence

select   hhpg.CustomDocumentHealthHomeCarePlanBHGoalId,
        hhpg.CreatedBy,
        hhpg.CreatedDate,
        hhpg.ModifiedBy,
        hhpg.ModifiedDate,
        hhpg.RecordDeleted,
        hhpg.DeletedBy,
        hhpg.DeletedDate,
        hhpg.DocumentVersionId,
        hhpg.GoalNumber,
        hhpg.GoalProvider,
        hhpg.NeedIdentifiedDate,
        hhpg.NeedDescription,
        hhpg.GoalDescription,
        hhpg.GoalTargetDate,
        hhpg.GoalObjectives,
        hhpg.GoalServices,
        hhpg.SourceDocumentVersionId
from    dbo.CustomDocumentHealthHomeCarePlanBHGoals as hhpg
where   hhpg.DocumentVersionId = @DocumentVersionId
        and ISNULL(hhpg.RecordDeleted, ''N'') <> ''Y''
order by hhpg.GoalNumber

select  hhpn.CustomDocumentHealthHomeCarePlanPESNeedId,
        hhpn.CreatedBy,
        hhpn.CreatedDate,
        hhpn.ModifiedBy,
        hhpn.ModifiedDate,
        hhpn.RecordDeleted,
        hhpn.DeletedBy,
        hhpn.DeletedDate,
        hhpn.DocumentVersionId,
        hhpn.PsychosocialSupportNeedSequence,
        hhpn.PsychosocialSupportNeedType,
        hhpn.PsychosocialSupportNeedPlan,
		CodeName AS PsychosocialSupportNeedTypeName
from    dbo.CustomDocumentHealthHomeCarePlanPESNeeds as hhpn
		LEFT JOIN dbo.GlobalCodes b ON (hhpn.PsychosocialSupportNeedType = b.GlobalCodeId AND ISNULL(b.RecordDeleted,''N'') = ''N'')
where   hhpn.DocumentVersionId = @DocumentVersionId
        and ISNULL(hhpn.RecordDeleted, ''N'') <> ''Y''
order by hhpn.PsychosocialSupportNeedSequence


select  hhd.CustomDocumentHealthHomeCarePlanDiagnosisId,
        hhd.CreatedBy,
        hhd.CreatedDate,
        hhd.ModifiedBy,
        hhd.ModifiedDate,
        hhd.RecordDeleted,
        hhd.DeletedBy,
        hhd.DeletedDate,
        hhd.DocumentVersionId,
        hhd.SequenceNumber,
        hhd.ReportedDiagnosis,
        hhd.DiagnosisSource,
        hhd.TreatmentProvider
from    dbo.CustomDocumentHealthHomeCarePlanDiagnoses as hhd
where   hhd.DocumentVersionId = @DocumentVersionId
        and ISNULL(hhd.RecordDeleted, ''N'') <> ''Y''
order by hhd.SequenceNumber




select  hhlto.CustomDocumentHealthHomeCarePlanLongTermCareOutcomeId,
        hhlto.CreatedBy,
        hhlto.CreatedDate,
        hhlto.ModifiedBy,
        hhlto.ModifiedDate,
        hhlto.RecordDeleted,
        hhlto.DeletedBy,
        hhlto.DeletedDate,
        hhlto.DocumentVersionId,
        hhlto.OutcomeSequence,
        hhlto.OutcomeDescription,
        hhlto.TargetDate
from    dbo.CustomDocumentHealthHomeCarePlanLongTermCareOutcomes as hhlto
where   hhlto.DocumentVersionId = @DocumentVersionId
        and ISNULL(hhlto.RecordDeleted, ''N'') <> ''Y''
order by hhlto.OutcomeSequence


' 
END
GO
