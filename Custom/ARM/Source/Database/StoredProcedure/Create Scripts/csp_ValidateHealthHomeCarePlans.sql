/****** Object:  StoredProcedure [dbo].[csp_ValidateHealthHomeCarePlans]    Script Date: 06/19/2013 17:49:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateHealthHomeCarePlans]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateHealthHomeCarePlans]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateHealthHomeCarePlans]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

create procedure [dbo].[csp_ValidateHealthHomeCarePlans]
	@DocumentVersionId int
-- 2013.03.15 - T. Remisoski - Added checking for Service on same day for same client
as

insert into #ValidationReturnTable (
	TableName,  
	ColumnName,  
	ErrorMessage,  
	TabOrder,  
	ValidationOrder  
)
select ''CustomDocumentHealthHomeCarePlans'', ''DeletedBy'', ''Primary Care Physician Last Name and First Name Required'', 1, 1
from dbo.CustomDocumentHealthHomeCarePlans as d
where d.DocumentVersionId = @DocumentVersionId
and (
	(LEN(ISNULL(LTRIM(RTRIM(d.PrimaryCareProviderFirstName)), '''')) = 0)
	or (LEN(ISNULL(LTRIM(RTRIM(d.PrimaryCareProviderLastName)), '''')) = 0)
)
union
select ''CustomDocumentHealthHomeCarePlans'', ''DeletedBy'', ''Problem List Required'', 1, 2
from dbo.CustomDocumentHealthHomeCarePlans as d
where d.DocumentVersionId = @DocumentVersionId
and LEN(ISNULL(LTRIM(RTRIM(d.ProblemList)), '''')) = 0
union
select ''CustomDocumentHealthHomeCarePlans'', ''DeletedBy'', ''At Least 1 Physical Health Outcome Required'', 1, 3
from dbo.CustomDocumentHealthHomeCarePlans as d
where d.DocumentVersionId = @DocumentVersionId
and 0 = (
	select COUNT(*)
	from dbo.CustomDocumentHealthHomeCarePlanOutcomes as oc
	where oc.DocumentVersionId = d.DocumentVersionId
	and ISNULL(oc.RecordDeleted, ''N'') <> ''Y''
)
union
select ''CustomDocumentHealthHomeCarePlans'', ''DeletedBy'', ''Living will/power of attorney entry required'', 1, 4
from dbo.CustomDocumentHealthHomeCarePlans as d
where d.DocumentVersionId = @DocumentVersionId
and LEN(ISNULL(LTRIM(RTRIM(d.ClientHasLivingWillOrDurablePOA)), '''')) = 0
--union
--select ''CustomDocumentHealthHomeCarePlans'', ''DeletedBy'', ''Living will/power of attorney entry required'', 1, 5
--from dbo.CustomDocumentHealthHomeCarePlans as d
--where d.DocumentVersionId = @DocumentVersionId
--and LEN(ISNULL(LTRIM(RTRIM(d.ClientHasLivingWillOrDurablePOA)), '''')) = 0
union
select ''CustomDocumentHealthHomeCarePlans'', ''DeletedBy'', ''At Least 1 Behavioral Need/Goal/Objective/Service Required'', 1, 6
from dbo.CustomDocumentHealthHomeCarePlans as d
where d.DocumentVersionId = @DocumentVersionId
and 0 = (
	select COUNT(*)
	from dbo.CustomDocumentHealthHomeCarePlanBHGoals as bhg
	where bhg.DocumentVersionId = d.DocumentVersionId
	and ISNULL(bhg.RecordDeleted, ''N'') <> ''Y''
)
union
select ''CustomDocumentHealthHomeCarePlans'', ''DeletedBy'', ''At least one Psychosocial/Environmental Support Required'', 1, 7
from dbo.CustomDocumentHealthHomeCarePlans as d
where d.DocumentVersionId = @DocumentVersionId
and 0 = (
	select COUNT(*)
	from dbo.CustomDocumentHealthHomeCarePlanPESNeeds as bhg
	where bhg.DocumentVersionId = d.DocumentVersionId
	and ISNULL(bhg.RecordDeleted, ''N'') <> ''Y''
)
union
select ''CustomDocumentHealthHomeCarePlans'', ''DeletedBy'', ''Long-term care selection required'', 1, 8
from dbo.CustomDocumentHealthHomeCarePlans as d
where d.DocumentVersionId = @DocumentVersionId
and ISNULL(LTRIM(RTRIM(d.LongTermCareNeeded)), ''N'') = ''N''
and ISNULL(LTRIM(RTRIM(d.LongTermCareNotNeeded)), ''N'') = ''N''
union
select ''CustomDocumentHealthHomeCarePlans'', ''DeletedBy'', ''Only 1 Long-term care selection allowed'', 1, 9
from dbo.CustomDocumentHealthHomeCarePlans as d
where d.DocumentVersionId = @DocumentVersionId
and ISNULL(LTRIM(RTRIM(d.LongTermCareNeeded)), ''N'') = ''Y''
and ISNULL(LTRIM(RTRIM(d.LongTermCareNotNeeded)), ''N'') = ''Y''
union
select ''CustomDocumentHealthHomeCarePlans'', ''DeletedBy'', ''Facility type required for long-term care'', 1, 10
from dbo.CustomDocumentHealthHomeCarePlans as d
where d.DocumentVersionId = @DocumentVersionId
and ISNULL(LTRIM(RTRIM(d.LongTermCareNeeded)), ''N'') = ''Y''
and d.AdmitToFacilityType is null
union
select ''CustomDocumentHealthHomeCarePlans'', ''DeletedBy'', ''Admit to Facility required for long-term care'', 1, 11
from dbo.CustomDocumentHealthHomeCarePlans as d
where d.DocumentVersionId = @DocumentVersionId
and ISNULL(LTRIM(RTRIM(d.LongTermCareNeeded)), ''N'') = ''Y''
and ISNULL(d.AdmitToFacilityNotApplicable, ''N'') <> ''Y''
and LEN(ISNULL(LTRIM(RTRIM(d.AdmitToFacility)), '''')) = 0
union
select ''CustomDocumentHealthHomeCarePlans'', ''DeletedBy'', ''Primary treating provider required for long-term care'', 1, 12
from dbo.CustomDocumentHealthHomeCarePlans as d
where d.DocumentVersionId = @DocumentVersionId
and ISNULL(LTRIM(RTRIM(d.LongTermCareNeeded)), ''N'') = ''Y''
and LEN(ISNULL(LTRIM(RTRIM(d.PrimaryTreatingProviderInCare)), '''')) = 0
union
select ''CustomDocumentHealthHomeCarePlans'', ''DeletedBy'', ''At least one Psychosocial/Environmental Support Required'', 1, 13
from dbo.CustomDocumentHealthHomeCarePlans as d
where d.DocumentVersionId = @DocumentVersionId
and ISNULL(LTRIM(RTRIM(d.LongTermCareNeeded)), ''N'') = ''Y''
and 0 = (
	select COUNT(*)
	from dbo.CustomDocumentHealthHomeCarePlanLongTermCareOutcomes as loc
	where loc.DocumentVersionId = d.DocumentVersionId
	and ISNULL(loc.RecordDeleted, ''N'') <> ''Y''
)
union
select ''CustomDocumentHealthHomeCarePlans'', ''DeletedBy'', ''At least one Health Home Team Activity Required'', 1, 14
from dbo.CustomDocumentHealthHomeCarePlans as d
where d.DocumentVersionId = @DocumentVersionId
and ISNULL(LTRIM(RTRIM(d.AchievingOutcomeAdvocacyAnalysisApplications)), ''N'') = ''N''
and ISNULL(LTRIM(RTRIM(d.AchievingOutcomeAppointmentReminders)), ''N'') = ''N''
and ISNULL(LTRIM(RTRIM(d.AchievingOutcomeAssistanceObtainingHealthcare)), ''N'') = ''N''
and ISNULL(LTRIM(RTRIM(d.AchievingOutcomeCoordinateCollaborate)), ''N'') = ''N''
and ISNULL(LTRIM(RTRIM(d.AchievingOutcomeCoordinateReferrals)), ''N'') = ''N''
and ISNULL(LTRIM(RTRIM(d.AchievingOutcomeFacilitateTransitionDischarge)), ''N'') = ''N''
and ISNULL(LTRIM(RTRIM(d.AchievingOutcomeMedicationManagement)), ''N'') = ''N''
and ISNULL(LTRIM(RTRIM(d.AchievingOutcomeOther)), ''N'') = ''N''
and ISNULL(LTRIM(RTRIM(d.AchievingOutcomeProvideHealthEducation)), ''N'') = ''N''
and ISNULL(LTRIM(RTRIM(d.AchievingOutcomeProvideReferralsToSelfHelpSupport)), ''N'') = ''N''
and ISNULL(LTRIM(RTRIM(d.AchievingOutcomeReviewRecords)), ''N'') = ''N''
and ISNULL(LTRIM(RTRIM(d.AchievingOutcomeSupportRelationships)), ''N'') = ''N''
and ISNULL(LTRIM(RTRIM(d.AchievingOutcomeTrackTestsReferrals)), ''N'') = ''N''
union
select ''CustomDocumentHealthHomeCarePlans'', ''DeletedBy'', ''Health Home Team Other Activity Description Required'', 1, 15
from dbo.CustomDocumentHealthHomeCarePlans as d
where d.DocumentVersionId = @DocumentVersionId
and ISNULL(LTRIM(RTRIM(d.AchievingOutcomeOther)), ''N'') = ''Y''
and LEN(ISNULL(LTRIM(RTRIM(d.AchievingOutcomeOtherComment)), '''')) = 0
union
select ''CustomDocumentHealthHomeCarePlans'', ''DeletedBy'', ''Client Participation Selection Required'', 1, 16
from dbo.CustomDocumentHealthHomeCarePlans as d
where d.DocumentVersionId = @DocumentVersionId
and d.ClientGuardianParticipatedInPlan is null
union
select ''CustomDocumentHealthHomeCarePlans'', ''DeletedBy'', ''Client Non-Participation Reason Required'', 1, 17
from dbo.CustomDocumentHealthHomeCarePlans as d
where d.DocumentVersionId = @DocumentVersionId
and d.ClientGuardianParticipatedInPlan = ''N''
and LEN(ISNULL(LTRIM(RTRIM(d.ClientCardianReasonForNonParticipation)), '''')) = 0
union
select ''CustomDocumentHealthHomeCarePlans'', ''DeletedBy'', ''Integrated Care Plan Service With Show/Complete Status Required'', 1, 18
from dbo.CustomDocumentHealthHomeCarePlans as hhcp
join dbo.DocumentVersions as dv on dv.DocumentVersionId = hhcp.DocumentVersionId
join dbo.Documents as d on d.DocumentId = dv.DocumentId
where hhcp.DocumentVersionId = @DocumentVersionId
and not exists (
	select *
	from Services as s
	where s.ClientId = d.ClientId
	and s.ProcedureCodeId = 725	-- integrated care plan
	and DATEDIFF(DAY, s.DateOfService, d.EffectiveDate) = 0
	and s.Status in (71,75)	-- show/complete
	and ISNULL(RecordDeleted, ''N'') <> ''Y''
)
	


' 
END
GO
