/****** Object:  StoredProcedure [dbo].[csp_validateCustomScreenForServices]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomScreenForServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomScreenForServices]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomScreenForServices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE         PROCEDURE [dbo].[csp_validateCustomScreenForServices]
@DocumentVersionId	Int
as

	

CREATE TABLE #CustomScreenForServices
(AccessToMeans char(3),
AccessToMeansDetail varchar(max),
ActiveSuicidal char(3),
Aggressive char(20),
Allergies varchar(300),
AWOLRisk char(3),
AWOLRiskDetail varchar(max),
ChargesPending char(3),
ChargesPendingDetail varchar(max),
ClientAddress varchar(300),
ClientCity varchar(300),
ClientCounty int,
ClientHomePhone varchar(300),
ClientName varchar(300),
ClientState char(20),
ClientSUHistory char(3),
ClientZip varchar(300),
CMHCaseNumber int,
ConstrictedThinking char(20),
ConsumerRequested int,
County int,
CreatedBy char(20),
CreatedDate datetime,
CurrentHealthConcerns varchar(max),
CurrentSubstanceUse char(3),
CurrentSubstanceUseSuspected char(3),
CurrentSuicidalIdeation char(3),
CurrentTherapist varchar(300),
DateOfBirth datetime,
DateOfRecentInpatient datetime,
DateOfScreen datetime,
DeletedBy char(20),
DeletedDate datetime,
Dependence char(20),
DestructionOfProperty char(3),
DestructionOfPropertyDetail varchar(max),
Diagnosis char(20),
DispositionTime datetime,
DocumentVersionId int,
EgoExplanation varchar(max),
EgosyntonicAttitude char(20),
ElapsedTimeOfScreen varchar(300),
EmergencyContact varchar(300),
EmergencyPhone varchar(300),
Ethnicity int,
EventStartTime datetime,
EventStopTime datetime,
Facility varchar(300),
FacilityName int,
FacilityProviderId int,
FacilitySiteId int,
FamilySUHistory char(3),
FamilySupport char(20),
FamilyUnwillingToHelp char(20),
GuardianName varchar(300),
GuardianPhone varchar(300),
HasPlan char(3),
HasPlanDetail varchar(max),
Helplessness char(20),
History varchar(max),
HistoryFamily char(20),
HistorySuicidalAttempts char(20),
Hopelessness char(20),
HospitalizationStatus int,
Ideation char(3),
IdeationDetail varchar(max),
JailHold char(3),
JustificationForReferral varchar(max),
LastSeen datetime,
Location varchar(300),
MakingPreparations char(20),
MaritalStatus int,
ModifiedBy char(20),
ModifiedDate datetime,
NameOfPrimaryCarePhysician varchar(300),
NoAmbivalence char(20),
NoSubstanceUseSuspected char(3),
NotificationMessage varchar(max),
NotificationSent datetime,
NotifyStaffId1 int,
NotifyStaffId2 int,
NotifyStaffId3 int,
NotifyStaffId4 int,
NumberOfInpatient int,
OtherCounty varchar(300),
OtherFacilityName varchar(300),
OtherRecommended int,
OtherReferral varchar(300),
OtherRequested int,
OutcomeDetail varchar(max),
PassiveSuicidal char(3),
Physical char(3),
PhysicalDetail varchar(max),
PreviosOutpatientTreatment char(3),
PreviousRescue char(20),
RecomendedSubstanceUse char(3),
Recommended int,
RecordDeleted char(3),
ReferralSouceName varchar(300),
ReferralSourceContacted char(3),
ReferralSourceContactedDetail varchar(300),
ReferralSourceType int,
RelationWithClient int,
RequestNotAuthorized int,
ScreeningCompletedBy int,
SelfHarmfulBehaviour char(3),
SelfHarmfulBehaviourDetail varchar(max),
Sex char(3),
SexualActingOut char(3),
SexualActingOutDetail varchar(max),
SSN char(20),
SubstanceUseDetails varchar(max),
SuicidalEgoDystonic char(3),
SuicidalEgoSyntonic char(3),
SuicidalIdeationWithin14Days char(3),
SuicidalIdeationWithin48Hours char(3),
Summary varchar(max),
UnableToObtain char(3),
Verbal char(3),
VerbalDetail varchar(max)
)

INSERT INTO #CustomScreenForServices
Select
a.AccessToMeans, 
a.AccessToMeansDetail, 
a.ActiveSuicidal, 
a.Aggressive, 
a.Allergies, 
a.AWOLRisk, 
a.AWOLRiskDetail, 
a.ChargesPending, 
a.ChargesPendingDetail, 
a.ClientAddress, 
a.ClientCity, 
a.ClientCounty, 
a.ClientHomePhone, 
a.ClientName, 
a.ClientState, 
a.ClientSUHistory, 
a.ClientZip, 
a.CMHCaseNumber, 
a.ConstrictedThinking, 
a.ConsumerRequested, 
a.County, 
a.CreatedBy, 
a.CreatedDate, 
a.CurrentHealthConcerns, 
a.CurrentSubstanceUse, 
a.CurrentSubstanceUseSuspected, 
a.CurrentSuicidalIdeation, 
a.CurrentTherapist, 
a.DateOfBirth, 
a.DateOfRecentInpatient, 
a.DateOfScreen, 
a.DeletedBy, 
a.DeletedDate, 
a.Dependence, 
a.DestructionOfProperty, 
a.DestructionOfPropertyDetail, 
a.Diagnosis, 
a.DispositionTime, 
a.DocumentVersionId, 
a.EgoExplanation, 
a.EgosyntonicAttitude, 
a.ElapsedTimeOfScreen, 
a.EmergencyContact, 
a.EmergencyPhone, 
a.Ethnicity, 
a.EventStartTime, 
a.EventStopTime, 
a.Facility, 
a.FacilityName, 
a.FacilityProviderId, 
a.FacilitySiteId, 
a.FamilySUHistory, 
a.FamilySupport, 
a.FamilyUnwillingToHelp, 
a.GuardianName,  
a.GuardianPhone,
a.HasPlan, 
a.HasPlanDetail, 
a.Helplessness, 
a.History, 
a.HistoryFamily, 
a.HistorySuicidalAttempts, 
a.Hopelessness, 
a.HospitalizationStatus, 
a.Ideation, 
a.IdeationDetail, 
a.JailHold, 
a.JustificationForReferral, 
a.LastSeen, 
a.Location, 
a.MakingPreparations, 
a.MaritalStatus, 
a.ModifiedBy, 
a.ModifiedDate, 
a.NameOfPrimaryCarePhysician, 
a.NoAmbivalence, 
a.NoSubstanceUseSuspected, 
a.NotificationMessage, 
a.NotificationSent, 
a.NotifyStaffId1, 
a.NotifyStaffId2, 
a.NotifyStaffId3, 
a.NotifyStaffId4, 
a.NumberOfInpatient, 
a.OtherCounty, 
a.OtherFacilityName, 
a.OtherRecommended, 
a.OtherReferral, 
a.OtherRequested, 
a.OutcomeDetail, 
a.PassiveSuicidal, 
a.Physical, 
a.PhysicalDetail, 
a.PreviosOutpatientTreatment, 
a.PreviousRescue, 
a.RecomendedSubstanceUse, 
a.Recommended, 
a.RecordDeleted, 
a.ReferralSouceName, 
a.ReferralSourceContacted, 
a.ReferralSourceContactedDetail, 
a.ReferralSourceType, 
a.RelationWithClient, 
a.RequestNotAuthorized, 
a.ScreeningCompletedBy, 
a.SelfHarmfulBehaviour, 
a.SelfHarmfulBehaviourDetail, 
a.Sex, 
a.SexualActingOut, 
a.SexualActingOutDetail, 
a.SSN, 
a.SubstanceUseDetails, 
a.SuicidalEgoDystonic, 
a.SuicidalEgoSyntonic, 
a.SuicidalIdeationWithin14Days, 
a.SuicidalIdeationWithin48Hours, 
a.Summary, 
a.UnableToObtain, 
a.Verbal, 
a.VerbalDetail
 FROM CustomScreenForServices a
where a.DocumentVersionId = @DocumentVersionId

Insert into #validationReturnTable
(TableName,
ColumnName,
ErrorMessage
)
--This validation returns three fields
--Field1 = TableName
--Field2 = ColumnName
--Field3 = ErrorMessage

SELECT ''CustomScreenForServices'' , ''DateOfScreen'', ''Date Of Screen must be specified.''
From #CustomScreenForServices
Where DateOfScreen is null
UNION
SELECT ''CustomScreenForServices'' , ''EventStartTime'', ''Event Start Time must be specified.''
From #CustomScreenForServices
Where EventStartTime is null
UNION
SELECT ''CustomScreenForServices'' , ''DispositionTime'', ''Disposition Time must be specified.''
From #CustomScreenForServices
Where DispositionTime is null
UNION
SELECT ''CustomScreenForServices'' , ''EventStopTime'', ''Event Stop Time must be specified.''
From #CustomScreenForServices
Where EventStopTime is null
UNION
SELECT ''CustomScreenForServices'' , ''ElapsedTimeOfScreen'', ''Elapsed Time Of Screen must be specified.''
From #CustomScreenForServices
Where ElapsedTimeOfScreen is null
UNION
SELECT ''CustomScreenForServices'' , ''ScreeningCompletedBy'', ''Screening Completed By must be specified.''
From #CustomScreenForServices
Where ScreeningCompletedBy is null
UNION
SELECT ''CustomScreenForServices'' , ''County'', ''County must be specified.''
From #CustomScreenForServices
Where County is null
UNION
SELECT ''CustomScreenForServices'' , ''Ethnicity'', ''Ethnicity must be specified.''
From #CustomScreenForServices
Where Ethnicity is null
UNION
SELECT ''CustomScreenForServices'' , ''MaritalStatus'', ''Marital Status must be specified.''
From #CustomScreenForServices
Where MaritalStatus is null
UNION
SELECT ''CustomScreenForServices'' , ''Sex'', ''Sex must be specified.''
From #CustomScreenForServices
Where Sex is null
UNION
SELECT ''CustomScreenForServices'' , ''ClientName'', ''Client Name must be specified.''
From #CustomScreenForServices
Where isnull(ClientName,'''')=''''
UNION
SELECT ''CustomScreenForServices'' , ''DateOfBirth'', ''Date Of Birth must be specified.''
From #CustomScreenForServices
Where DateOfBirth is null
UNION
SELECT ''CustomScreenForServices'' , ''ClientAddress'', ''Client Address must be specified.''
From #CustomScreenForServices
Where isnull(ClientAddress,'''')=''''
UNION
SELECT ''CustomScreenForServices'' , ''ClientCity'', ''Client City must be specified.''
From #CustomScreenForServices
Where isnull(ClientCity,'''')=''''
UNION
SELECT ''CustomScreenForServices'' , ''ClientState'', ''Client State must be specified.''
From #CustomScreenForServices
Where isnull(ClientState,'''')=''''
UNION
SELECT ''CustomScreenForServices'' , ''ClientZip'', ''Client Zip must be specified.''
From #CustomScreenForServices
Where isnull(ClientZip,'''')=''''
UNION
SELECT ''CustomScreenForServices'' , ''ClientCounty'', ''Client County must be specified.''
From #CustomScreenForServices
Where ClientCounty is null
UNION
SELECT ''CustomScreenForServices'' , ''ClientHomePhone'', ''Client Home Phone must be specified.''
From #CustomScreenForServices
Where isnull(ClientHomePhone,'''')=''''
UNION
SELECT ''CustomScreenForServices'' , ''EmergencyContact'', ''Emergency Contact must be specified.''
From #CustomScreenForServices
Where isnull(EmergencyContact,'''')=''''
UNION
SELECT ''CustomScreenForServices'' , ''RelationWithClient'', ''Relation With Client must be specified.''
From #CustomScreenForServices
Where isnull(RelationWithClient,'''')=''''
--UNION
--SELECT ''CustomScreenForServices'' , ''EmergencyPhone'', ''Emergency Phone must be specified.''
--UNION
--SELECT ''CustomScreenForServices'' , ''GuardianName'', ''GuardianName must be specified.''
--UNION
--SELECT ''CustomScreenForServices'' , ''GuardianPhone'', ''GuardianPhone must be specified.''
--UNION


-- REFERRAL SOURCE
UNION
SELECT ''CustomScreenForServices'', ''ReferralSourceType'', ''Referral Source Type must be specified.''
From #CustomScreenForServices
Where isnull(ReferralSourceType,'''')=''''
--UNION
--SELECT ''CustomScreenForServices'', ''OtherReferral'', ''OtherReferral must be specified.''
UNION
SELECT ''CustomScreenForServices'', ''ReferralSouceName'', ''Referral Source Name must be specified.''
From #CustomScreenForServices
Where isnull(ReferralSouceName,'''')=''''
UNION
SELECT ''CustomScreenForServices'', ''Location'', ''Referral Location must be specified.''
From #CustomScreenForServices
Where isnull(Location,'''')=''''
UNION
SELECT ''CustomScreenForServices'', ''ReferralSourceContacted'', ''Referral Source Contacted must be specified.''
From #CustomScreenForServices
Where isnull(ReferralSourceContacted,'''')=''''
UNION
SELECT ''CustomScreenForServices'', ''ReferralSourceContactedDetail'', ''Referral Source Contacted Detail must be specified.''
FROM #CustomScreenForServices cp
WHERE ReferralSourceContacted = ''N''
and isnull(ReferralSourceContactedDetail,'''')=''''


UNION
SELECT ''CustomScreenForServices'', ''JustificationForReferral'', ''Justification For Referral must be specified.''
From #CustomScreenForServices
Where isnull(JustificationForReferral,'''')=''''


UNION
SELECT ''CustomScreenForServices'', ''Aggressive'', ''Aggressive must be specified.''
From #CustomScreenForServices
Where isnull(Aggressive,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''AWOLRisk'', ''AWOLRisk must be specified.''
FROM #CustomScreenForServices cp
WHERE Aggressive <> ''NA'' AND Aggressive is not null
and isnull(AWOLRisk,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''AWOLRiskDetail'', ''AWOL Risk Detail must be specified.''
FROM #CustomScreenForServices cp
WHERE AWOLRisk = ''Y''
AND Aggressive <> ''NA'' AND Aggressive is not null
and isnull(AWOLRiskDetail,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''Physical'', ''Physical must be specified.''
FROM #CustomScreenForServices cp
WHERE Aggressive <> ''NA'' AND Aggressive is not null
and isnull(Physical,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''PhysicalDetail'', ''Physical Detail must be specified.''
FROM #CustomScreenForServices cp
WHERE Physical = ''Y''
AND Aggressive <> ''NA'' AND Aggressive is not null
and isnull(PhysicalDetail,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''Ideation'', ''Ideation must be specified.''
FROM #CustomScreenForServices cp
WHERE Aggressive <> ''NA'' AND Aggressive is not null
and isnull(Ideation,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''IdeationDetail'', ''Ideation Detail must be specified.''
FROM #CustomScreenForServices cp
WHERE Ideation = ''Y''
AND Aggressive <> ''NA'' AND Aggressive is not null
and isnull(IdeationDetail,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''SexualActingOut'', ''Sexual Acting Out must be specified.''
FROM #CustomScreenForServices cp
WHERE Aggressive <> ''NA'' AND Aggressive is not null
and isnull(SexualActingOut,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''SexualActingOutDetail'', ''Sexual Acting Out Detail must be specified.''
FROM #CustomScreenForServices cp
WHERE SexualActingOut = ''Y''
AND Aggressive <> ''NA'' AND Aggressive is not null
and isnull(SexualActingOutDetail,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''Verbal'', ''Verbal must be specified.''
FROM #CustomScreenForServices cp
WHERE Aggressive <> ''NA'' AND Aggressive is not null
and isnull(Verbal,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''VerbalDetail'', ''Verbal Detail must be specified.''
FROM #CustomScreenForServices cp
WHERE Verbal = ''Y''
AND Aggressive <> ''NA'' AND Aggressive is not null
and isnull(VerbalDetail,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''DestructionOfProperty'', ''Destruction Of Property must be specified.''
FROM #CustomScreenForServices cp
WHERE Aggressive <> ''NA'' AND Aggressive is not null
and isnull(DestructionOfProperty,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''DestructionOfPropertyDetail'', ''Destruction Of PropertyDetail must be specified.''
FROM #CustomScreenForServices cp
WHERE DestructionOfProperty = ''Y''
AND Aggressive <> ''NA'' AND Aggressive is not null
and isnull(DestructionOfPropertyDetail,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''History'', ''History must be specified.''
FROM #CustomScreenForServices cp
WHERE Aggressive <> ''NA'' AND Aggressive is not null
and isnull(History,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''ChargesPending'', ''Charges Pending must be specified.''
FROM #CustomScreenForServices cp
WHERE Aggressive <> ''NA'' AND Aggressive is not null
and isnull(ChargesPending,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''ChargesPendingDetail'', ''Charges Pending Detail must be specified.''
FROM #CustomScreenForServices cp
WHERE ChargesPending = ''Y''
AND Aggressive <> ''NA'' AND Aggressive is not null
and isnull(ChargesPendingDetail,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''JailHold'', ''Jail Hold must be specified.''
FROM #CustomScreenForServices cp
WHERE Aggressive <> ''NA'' AND Aggressive is not null
and isnull(JailHold,'''')=''''

UNION
SELECT ''CustomScreenForServices'' , ''CurrentSuicidalIdeation'', ''Current Suicidal Ideation must be specified.''
FROM #CustomScreenForServices cp
WHERE isnull(CurrentSuicidalIdeation,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''EgoExplanation'', ''Ego Syntonic/Ego Dystonic Explanation must be specified.''
FROM #CustomScreenForServices cp
WHERE (SuicidalEgoSyntonic = ''Y''
OR SuicidalEgoDystonic = ''Y'')
and isnull(EgoExplanation,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''HasPlanDetail'', ''Has Plan Detail must be specified.''
FROM #CustomScreenForServices cp
WHERE HasPlan = ''Y''
and isnull(HasPlanDetail,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''AccessToMeansDetail'', ''Access To Means Detail must be specified.''
FROM #CustomScreenForServices cp
WHERE AccessToMeans = ''Y''
and isnull(AccessToMeansDetail,'''')=''''




-- SLAP Questions
UNION
SELECT ''CustomScreenForServices'', ''HistorySuicidalAttempts'', ''SLAP - History of Suicidal Attempts must be specified.''
FROM #CustomScreenForServices cp
WHERE AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y''
and isnull(HistorySuicidalAttempts,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''HistoryFamily'', ''SLAP - Family History of Completions must be specified.''
FROM #CustomScreenForServices cp
WHERE AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y''
and isnull(HistoryFamily,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''Diagnosis'', ''SLAP - Diagnosis must be specified.''
FROM #CustomScreenForServices cp
WHERE AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y''
and isnull(Diagnosis,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''PreviousRescue'', ''SLAP - Previous Rescue must be specified.''
FROM #CustomScreenForServices cp
WHERE AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y''
and isnull(PreviousRescue,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''FamilySupport'', ''SLAP - Family Support must be specified.''
FROM #CustomScreenForServices cp
WHERE AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y''
and isnull(FamilySupport,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''FamilyUnwillingToHelp'', ''SLAP - Family Unwilling ToH elp must be specified.''
FROM #CustomScreenForServices cp
WHERE AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y''
and isnull(FamilyUnwillingToHelp,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''Dependence'', ''SLAP - Dependence must be specified.''
FROM #CustomScreenForServices cp
WHERE AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y''
and isnull(Dependence,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''ConstrictedThinking'', ''SLAP - Constricted Thinking must be specified.''
FROM #CustomScreenForServices cp
WHERE AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y''
and isnull(ConstrictedThinking,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''EgosyntonicAttitude'', ''SLAP - Ego Syntonic Attitude must be specified.''
FROM #CustomScreenForServices cp
WHERE AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y''
and isnull(EgosyntonicAttitude,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''Helplessness'', ''SLAP - Helplessness must be specified.''
FROM #CustomScreenForServices cp
WHERE AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y''
and isnull(Helplessness,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''Hopelessness'', ''SLAP - Hopelessness must be specified.''
FROM #CustomScreenForServices cp
WHERE AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y''
and isnull(Hopelessness,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''MakingPreparations'', ''SLAP - Making Preparations must be specified.''
FROM #CustomScreenForServices cp
WHERE AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y''
and isnull(MakingPreparations,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''NoAmbivalence'', ''SLAP - No Ambivalence must be specified.''
FROM #CustomScreenForServices cp
WHERE AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y''
and isnull(NoAmbivalence,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''SelfHarmfulBehaviour'', ''Current Self Harmful Behaviour must be specified.''
FROM #CustomScreenForServices cp
WHERE isnull(SelfHarmfulBehaviour,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''SelfHarmfulBehaviourDetail'', ''Current Self Harmful Behavior Detail must be specified.''
FROM #CustomScreenForServices cp
WHERE SelfHarmfulBehaviour = ''Y''
and isnull(SelfHarmfulBehaviourDetail,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''OutcomeDetail'', ''Current Self Harmful Behavior Outcome Detail must be specified.''
FROM #CustomScreenForServices cp
WHERE SelfHarmfulBehaviour = ''Y''
and isnull(OutcomeDetail,'''')=''''
	/*
	UNION
	SELECT ''CustomScreenForServices'', ''NumberOfInpatient'', ''Number Of IP Psychiactric Hospitalizatoins must be specified.''
	FROM #CustomScreenForServices cp
	WHERE UnableToObtain <> ''Y''

	UNION
	SELECT ''CustomScreenForServices'', ''DateOfRecentInpatient'', ''Date Of Most Recent IP Hospitalization must be specified.''
	FROM #CustomScreenForServices cp
	WHERE isnull(UnableToObtain, ''N'') <> ''Y''
	AND isnull(NumberOfInpatient, '''') <> '''' 

	UNION
	SELECT ''CustomScreenForServices'', ''Facility'', ''Facility must be specified.''
	FROM #CustomScreenForServices cp
	WHERE isnull(UnableToObtain, ''N'') <> ''Y''


	UNION
	SELECT ''CustomScreenForServices'', ''PreviosOutpatientTreatment'', ''Previous OP Treatment must be specified.''
	WHERE isnull(UnableToObtain, ''N'') <> ''Y''

	UNION
	SELECT ''CustomScreenForServices'', ''LastSeen'', ''Previous OP Treatment - Last Seen must be specified.''
	WHERE isnull(UnableToObtain, ''N'') <> ''Y''
	AND isnull(PreviousOutpatientTreatment, ''N'')= ''Y'' 
	*/

UNION
SELECT ''CustomScreenForServices'', ''NameOfPrimaryCarePhysician'', ''Name Of Primary Care Physician must be specified.''
FROM #CustomScreenForServices cp
WHERE isnull(NameOfPrimaryCarePhysician,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''Allergies'', ''Allergies must be specified.''
FROM #CustomScreenForServices cp
WHERE isnull(Allergies,'''')=''''
UNION
SELECT ''CustomScreenForServices'' , ''CurrentHealthConcerns'', ''CurrentHealthConcerns must be specified.''
FROM #CustomScreenForServices cp
WHERE isnull(CurrentHealthConcerns,'''')=''''
UNION
SELECT ''CustomScreenForServices'', ''ConsumerRequested'', ''Consumer Requested Service must be specified.''
FROM #CustomScreenForServices cp
WHERE NOT EXISTS (SELECT 1 FROM CustomRequestedServices r
		  WHERE r.DocumentVersionId = cp.DocumentVersionId
		  AND isnull(recorddeleted, ''N'') = ''N'')
and isnull(ConsumerRequested,'''')=''''

UNION
SELECT ''CustomScreenForServices'', ''Recommended'', ''Recommended/Authorized Service must be specified.''
FROM #CustomScreenForServices cp
WHERE NOT EXISTS (SELECT 1 FROM CustomRecommendedServices r
		  WHERE r.DocumentVersionId = cp.DocumentVersionId
		  AND isnull(recorddeleted, ''N'') = ''N'')
and isnull(Recommended,'''')=''''
UNION
SELECT ''CustomScreenForServices'' , ''OtherFacilityName'', ''OtherFacilityName must be specified.''
FROM #CustomScreenForServices cp
WHERE isnull(FacilityName, '''') = '''' AND isnull(OtherFacilityName, '''') = ''''
AND Isnull(FacilityProviderId, '''') = '''' AND isnull(FacilitySiteId, '''') = ''''
AND Recommended in (2341, 2342)

UNION
SELECT ''CustomScreenForServices'' , ''Summary'', ''Summary must be specified.''
FROM #CustomScreenForServices cp
WHERE isnull(Summary,'''')=''''



	--Full Mental Status
	exec csp_validateFullMentalStatus @DocumentVersionId
	if @@error <> 0 goto error
	
	--SU Assessment Validation
	exec csp_validateCustomSUAssessments @DocumentVersionId
	if @@error <> 0 goto error
	
	--Diagnosis Validation
	exec csp_validateDiagnosis @DocumentVersionId
	if @@error <> 0 goto error
	


--
--Check to make sure record exists in custom table for @DocumentCodeId
--
If not exists (Select 1 from #CustomScreenForServices)
begin 

Insert into CustomBugTracking
(DocumentVersionId, Description, CreatedDate)
Values
(@DocumentVersionId, ''No record exists in custom table.'', GETDATE())

Insert into #validationReturnTable
(TableName,
ColumnName,
ErrorMessage
)

Select ''CustomScreenForServices'', ''DeletedBy'', ''Error occurred. Please contact your system administrator. No record exists in custom table.''
Where not exists  (Select 1 from #CustomScreenForServices)
end


if @@error <> 0 goto error





return

error:
raiserror 50000 ''csp_validateCustomScreenForServices failed.  Contact your system administrator.''
' 
END
GO
