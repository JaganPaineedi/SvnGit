/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentMapToEmployments]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentMapToEmployments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentMapToEmployments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentMapToEmployments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[csp_ValidateCustomDocumentMapToEmployments]
@DocumentVersionId Int
As

BEGIN

BEGIN TRY
DECLARE @StoredProcedure varchar(300)

SET @StoredProcedure = object_name(@@procid)


CREATE TABLE [#CustomDocumentMapToEmployments] (
 DocumentVersionId int
,CreatedBy varchar(30)
,CreatedDate datetime
,ModifiedBy varchar(30)
,ModifiedDate datetime
,RecordDeleted char(1)
,DeletedBy varchar(30)
,DeletedDate datetime
,DevelopmentNotApplicable char(1)
,InitialOrReview char(1)
,JobPlacementIncluded char(1)
,JobDevelopmentIncluded char(1)
,GoalsVocationalAreas varchar(max)
,GoalsWage varchar(max)
,GoalsWorkHoursPerWeek varchar(max)
,GoalsShiftAvailability varchar(max)
,GoalsDistance varchar(max)
,GoalsBenefits varchar(max)
,GoalsAdditionalInfo varchar(max)
,AssistiveTechnologyNeeds varchar(max)
,HealthSafetyRisks varchar(max)
,FrequencyOfReview int
,NaturalSupports varchar(max)
,OtherProviderInvolvement varchar(max)
,ConsumerParticpatedDevelopmentPlan char(1)
,CoachingPosition varchar(max)
,CoachingEmploymentSite varchar(max)
,CoachingJobAccomodations varchar(max)
,CoachingNaturalSupports varchar(max)
,CoachingLearningStyle varchar(max)
,CoachingFadingPlan varchar(max)
,ConsumerParticipatedCoachingPlan char(1)
,ClientDidNotParticipate char(1)
,ClientDidNotParticpateComment varchar(max)
)

INSERT INTO [#CustomDocumentMapToEmployments](
DocumentVersionId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,DevelopmentNotApplicable
,InitialOrReview
,JobPlacementIncluded
,JobDevelopmentIncluded
,GoalsVocationalAreas
,GoalsWage
,GoalsWorkHoursPerWeek
,GoalsShiftAvailability
,GoalsDistance
,GoalsBenefits
,GoalsAdditionalInfo
,AssistiveTechnologyNeeds
,HealthSafetyRisks
,FrequencyOfReview
,NaturalSupports
,OtherProviderInvolvement
,ConsumerParticpatedDevelopmentPlan
,CoachingPosition
,CoachingEmploymentSite
,CoachingJobAccomodations
,CoachingNaturalSupports
,CoachingLearningStyle
,CoachingFadingPlan
,ConsumerParticipatedCoachingPlan
,ClientDidNotParticipate
,ClientDidNotParticpateComment		
)
select
DocumentVersionId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,DevelopmentNotApplicable
,InitialOrReview
,JobPlacementIncluded
,JobDevelopmentIncluded
,GoalsVocationalAreas
,GoalsWage
,GoalsWorkHoursPerWeek
,GoalsShiftAvailability
,GoalsDistance
,GoalsBenefits
,GoalsAdditionalInfo
,AssistiveTechnologyNeeds
,HealthSafetyRisks
,FrequencyOfReview
,NaturalSupports
,OtherProviderInvolvement
,ConsumerParticpatedDevelopmentPlan
,CoachingPosition
,CoachingEmploymentSite
,CoachingJobAccomodations
,CoachingNaturalSupports
,CoachingLearningStyle
,CoachingFadingPlan
,ConsumerParticipatedCoachingPlan
,ClientDidNotParticipate
,ClientDidNotParticpateComment
from CustomDocumentMapToEmployments a
where a.DocumentVersionId = @DocumentVersionId and isnull(a.RecordDeleted,''N'')<>''Y''


declare @Sex char(1), @Age int, @EffectiveDate datetime, @ClientId int, @DocumentCodeId int, @ServiceId int

declare @DevelopmentRequired char(1) = ''Y'', @CoachingRequired char(1) = ''Y''

if exists (select * from #CustomDocumentMapToEmployments where DevelopmentNotApplicable = ''Y'')	set @DevelopmentRequired = ''N''


if exists (select * from #CustomDocumentMapToEmployments where ((ISNULL(DevelopmentNotApplicable, ''N'') = ''N'') and (JobPlacementIncluded = ''Y'' or JobDevelopmentIncluded = ''Y''))) 
	set @CoachingRequired = ''N''


select @Sex = isnull(c.Sex,''U''), @Age = dbo.GetAge(c.DOB,d.EffectiveDate), @EffectiveDate = d.EffectiveDate, @ClientId = d.ClientId,
	@DocumentCodeId = d.DocumentCodeId, @ServiceId = d.ServiceId
from DocumentVersions dv
join Documents d on d.DocumentId = dv.DocumentId
join Clients c on c.ClientId = d.ClientId
where dv.DocumentVersionId = @DocumentVersionId

insert into #ValidationReturnTable (
	TableName,
	ColumnName,
	ErrorMessage,
	TabOrder,
	ValidationOrder
)

SELECT ''CustomDocumentMapToEmployments'', ''DeletedBy'', ''Development  - Initial or review selection is required'',1 ,2
FROM #CustomDocumentMapToEmployments
WHERE LEN(LTRIM(RTRIM(ISNULL(InitialOrReview, '''')))) = 0
and @DevelopmentRequired = ''Y''

--UNION
--SELECT ''CustomDocumentMapToEmployments'', ''DeletedBy'', ''General  - JobPlacementIncluded selection is required'',1 ,1
--FROM #CustomDocumentMapToEmployments
--WHERE LEN(LTRIM(RTRIM(ISNULL(JobPlacementIncluded, '''')))) = 0

--UNION
--SELECT ''CustomDocumentMapToEmployments'', ''DeletedBy'', ''General  - JobDevelopmentIncluded selection is required'',1 ,1
--FROM #CustomDocumentMapToEmployments
--WHERE LEN(LTRIM(RTRIM(ISNULL(JobDevelopmentIncluded, '''')))) = 0

UNION
SELECT ''CustomDocumentMapToEmployments'', ''DeletedBy'', ''Development  - Goal vocational area(s) section is required'',1 ,3
FROM #CustomDocumentMapToEmployments
WHERE LEN(LTRIM(RTRIM(ISNULL(GoalsVocationalAreas, '''')))) = 0
and @DevelopmentRequired = ''Y''


UNION
SELECT ''CustomDocumentMapToEmployments'', ''DeletedBy'', ''Development  - Wage section is required'',1 ,4
FROM #CustomDocumentMapToEmployments
WHERE LEN(LTRIM(RTRIM(ISNULL(GoalsWage, '''')))) = 0
and @DevelopmentRequired = ''Y''

UNION
SELECT ''CustomDocumentMapToEmployments'', ''DeletedBy'', ''Development  - Work hours per week section is required'',1 ,5
FROM #CustomDocumentMapToEmployments
WHERE LEN(LTRIM(RTRIM(ISNULL(GoalsWorkHoursPerWeek, '''')))) = 0
and @DevelopmentRequired = ''Y''

UNION
SELECT ''CustomDocumentMapToEmployments'', ''DeletedBy'', ''Development  - Shift availability section is required'',1 ,6
FROM #CustomDocumentMapToEmployments
WHERE LEN(LTRIM(RTRIM(ISNULL(GoalsShiftAvailability, '''')))) = 0
and @DevelopmentRequired = ''Y''

UNION
SELECT ''CustomDocumentMapToEmployments'', ''DeletedBy'', ''Development  - Distance section is required'',1 ,7
FROM #CustomDocumentMapToEmployments
WHERE LEN(LTRIM(RTRIM(ISNULL(GoalsDistance, '''')))) = 0
and @DevelopmentRequired = ''Y''

UNION
SELECT ''CustomDocumentMapToEmployments'', ''DeletedBy'', ''Development  - Benefits section is required'',1 ,8
FROM #CustomDocumentMapToEmployments
WHERE LEN(LTRIM(RTRIM(ISNULL(GoalsBenefits, '''')))) = 0
and @DevelopmentRequired = ''Y''

UNION
SELECT ''CustomDocumentMapToEmployments'', ''DeletedBy'', ''Development  - Additional info section is required'',1 ,9
FROM #CustomDocumentMapToEmployments
WHERE LEN(LTRIM(RTRIM(ISNULL(GoalsAdditionalInfo, '''')))) = 0
and @DevelopmentRequired = ''Y''

UNION
SELECT ''CustomDocumentMapToEmployments'', ''DeletedBy'', ''Development  - Assistive technology needs section is required'',1 ,10
FROM #CustomDocumentMapToEmployments
WHERE LEN(LTRIM(RTRIM(ISNULL(AssistiveTechnologyNeeds, '''')))) = 0
and @DevelopmentRequired = ''Y''

UNION
SELECT ''CustomDocumentMapToEmployments'', ''DeletedBy'', ''Development  - Health safety risks section is required'',1 ,11
FROM #CustomDocumentMapToEmployments
WHERE LEN(LTRIM(RTRIM(ISNULL(HealthSafetyRisks, '''')))) = 0
and @DevelopmentRequired = ''Y''


UNION
SELECT ''CustomDocumentMapToEmployments'', ''DeletedBy'', ''Development  - Frequency of review section is required'',1 ,12
FROM #CustomDocumentMapToEmployments
WHERE LEN(LTRIM(RTRIM(ISNULL(FrequencyOfReview, '''')))) = 0
and @DevelopmentRequired = ''Y''

UNION
SELECT ''CustomDocumentMapToEmployments'', ''DeletedBy'', ''Development  - Natural supports section is required'',1 ,13
FROM #CustomDocumentMapToEmployments
WHERE LEN(LTRIM(RTRIM(ISNULL(NaturalSupports, '''')))) = 0
and @DevelopmentRequired = ''Y''

UNION
SELECT ''CustomDocumentMapToEmployments'', ''DeletedBy'', ''Development  - Other provider involvement section is required'',1 ,14
FROM #CustomDocumentMapToEmployments
WHERE LEN(LTRIM(RTRIM(ISNULL(OtherProviderInvolvement, '''')))) = 0
and @DevelopmentRequired = ''Y''

UNION
SELECT ''CustomDocumentMapToEmployments'', ''DeletedBy'', ''Development  - client participation must be specified'',1 ,15
FROM #CustomDocumentMapToEmployments
WHERE ISNULL(ConsumerParticipatedCoachingPlan, ''N'')<>''Y''
and @DevelopmentRequired = ''Y''

UNION
SELECT ''CustomDocumentMapToEmployments'', ''DeletedBy'', ''Coaching  - Position section is required'',6 ,1
FROM #CustomDocumentMapToEmployments
WHERE LEN(LTRIM(RTRIM(ISNULL(CoachingPosition, '''')))) = 0
and @CoachingRequired = ''Y''

UNION
SELECT ''CustomDocumentMapToEmployments'', ''DeletedBy'', ''Coaching  - Employment site section is required'',6 ,2
FROM #CustomDocumentMapToEmployments
WHERE LEN(LTRIM(RTRIM(ISNULL(CoachingEmploymentSite, '''')))) = 0
and @CoachingRequired = ''Y''

UNION
SELECT ''CustomDocumentMapToEmployments'', ''DeletedBy'', ''Coaching  - Job accomodations section is required'',6 ,2
FROM #CustomDocumentMapToEmployments
WHERE LEN(LTRIM(RTRIM(ISNULL(CoachingJobAccomodations, '''')))) = 0
and @CoachingRequired = ''Y''

UNION
SELECT ''CustomDocumentMapToEmployments'', ''DeletedBy'', ''Coaching  - Natural supports section is required'',6 ,3
FROM #CustomDocumentMapToEmployments
WHERE LEN(LTRIM(RTRIM(ISNULL(CoachingNaturalSupports, '''')))) = 0
and @CoachingRequired = ''Y''

UNION
SELECT ''CustomDocumentMapToEmployments'', ''DeletedBy'', ''Coaching  - Learning style section is required'',6 ,4
FROM #CustomDocumentMapToEmployments
WHERE LEN(LTRIM(RTRIM(ISNULL(CoachingLearningStyle, '''')))) = 0
and @CoachingRequired = ''Y''

UNION
SELECT ''CustomDocumentMapToEmployments'', ''DeletedBy'', ''Coaching  - Fading plan section is required'',6 ,5
FROM #CustomDocumentMapToEmployments
WHERE LEN(LTRIM(RTRIM(ISNULL(CoachingFadingPlan, '''')))) = 0
and @CoachingRequired = ''Y''

UNION
SELECT ''CustomDocumentMapToEmployments'', ''DeletedBy'', ''Coaching  - Client participation must be specified'',6 ,7
FROM #CustomDocumentMapToEmployments
WHERE isnull(ClientDidNotParticipate, ''N'')<>''Y''
and isnull(ConsumerParticipatedCoachingPlan, ''N'')<>''Y''
and @CoachingRequired = ''Y''

if @DevelopmentRequired = ''Y''
begin
	exec dbo.csp_validateCustomDocumentMapToEmploymentObjectives @DocumentVersionId, 2, ''D''
	exec dbo.csp_validateCustomDocumentMapToEmploymentResponsibilities @DocumentVersionId, 3, ''D''
	exec dbo.csp_validateCustomDocumentMapToEmploymentMethods @DocumentVersionId, 4, ''D''
end

if @CoachingRequired = ''Y''
begin
	exec dbo.csp_validateCustomDocumentMapToEmploymentTrainingGoals @DocumentVersionId, 7
	exec dbo.csp_validateCustomDocumentMapToEmploymentObjectives @DocumentVersionId, 8, ''C''
	exec dbo.csp_validateCustomDocumentMapToEmploymentResponsibilities @DocumentVersionId, 9, ''C''
	--exec dbo.csp_validateCustomDocumentMapToEmploymentMethods @DocumentVersionId, 10, ''C''
end

END TRY

BEGIN CATCH
     DECLARE @Error varchar(8000)
     SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())
      + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),@StoredProcedure)
      + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())
      + ''*****'' + Convert(varchar,ERROR_STATE())
     RAISERROR
     (
      @Error, -- Message text.
      16, -- Severity.
      1 -- State.
     );
END CATCH

RETURN
END


' 
END
GO
