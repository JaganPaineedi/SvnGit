/****** Object:  StoredProcedure [dbo].[csp_ReportHealthHomeCarePlan]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportHealthHomeCarePlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportHealthHomeCarePlan]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportHealthHomeCarePlan]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

create procedure [dbo].[csp_ReportHealthHomeCarePlan]
	@DocumentVersionId int
as

select  hcp.DocumentVersionId,
        hcp.CreatedBy,
        hcp.CreatedDate,
        hcp.ModifiedBy,
        hcp.ModifiedDate,
        hcp.RecordDeleted,
        hcp.DeletedBy,
        hcp.DeletedDate,
        hcp.PrimaryCareProviderFirstName,
        hcp.PrimaryCareProviderLastName,
        hcp.PrimaryCareProviderOrganization,
        hcp.ProblemList,
        hcp.ClientHasLivingWillOrDurablePOA,
        hcp.LongTermCareNotNeeded,
        hcp.LongTermCareNeeded,
        gcFacility.CodeName as AdmitToFacilityType,
        case when hcp.AdmitToFacilityNotApplicable = ''Y'' then ''N/A'' else hcp.AdmitToFacility end as AdmitToFacility,
        --hcp.AdmitToFacilityNotApplicable,
        hcp.AdmissionComments,
        hcp.PrimaryTreatingProviderInCare,
        hcp.AchievingOutcomeAssistanceObtainingHealthcare,
        hcp.AchievingOutcomeMedicationManagement,
        hcp.AchievingOutcomeTrackTestsReferrals,
        hcp.AchievingOutcomeCoordinateCollaborate,
        hcp.AchievingOutcomeCoordinateReferrals,
        hcp.AchievingOutcomeProvideHealthEducation,
        hcp.AchievingOutcomeProvideReferralsToSelfHelpSupport,
        hcp.AchievingOutcomeAppointmentReminders,
        hcp.AchievingOutcomeFacilitateTransitionDischarge,
        hcp.AchievingOutcomeAdvocacyAnalysisApplications,
        hcp.AchievingOutcomeReviewRecords,
        hcp.AchievingOutcomeSupportRelationships,
        hcp.AchievingOutcomeOther,
        hcp.AchievingOutcomeOtherComment,
        hcp.ClientGuardianParticipatedInPlan,
        hcp.ClientCardianReasonForNonParticipation,
        c.LastName + '', '' + c.FirstName as ClientName,
        c.ClientId
from dbo.CustomDocumentHealthHomeCarePlans as hcp
join dbo.DocumentVersions as dv on dv.DocumentVersionId = hcp.DocumentVersionId
join dbo.Documents as d on d.DocumentId = dv.DocumentId
join dbo.Clients as c on c.ClientId = d.ClientId
LEFT join dbo.GlobalCodes as gcFacility on gcFacility.GlobalCodeId = hcp.AdmitToFacilityType
where hcp.DocumentVersionId = @DocumentVersionId


' 
END
GO
