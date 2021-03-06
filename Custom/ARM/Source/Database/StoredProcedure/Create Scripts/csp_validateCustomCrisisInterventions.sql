/****** Object:  StoredProcedure [dbo].[csp_validateCustomCrisisInterventions]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomCrisisInterventions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomCrisisInterventions]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomCrisisInterventions]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE          PROCEDURE [dbo].[csp_validateCustomCrisisInterventions]
@DocumentVersionId	Int--,@documentCodeId	Int
as

	

CREATE TABLE #CustomCrisisInterventions
(AccessToMeans char(3),
AccessToMeansDetail varchar(max),
ActiveSuicidal char(3),
Aggressive char(20),
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
ClientZip varchar(300),
CMHCaseNumber int,
ConstrictedThinking char(20),
ConsumerRequested int,
County int,
CreatedBy char(20),
CreatedDate datetime,
CurrentSuicidalIdeation char(3),
CurrentTherapist varchar(300),
DateOfBirth datetime,
DateOfCrisisIntervention datetime,
DeletedBy char(20),
DeletedDate datetime,
Dependence char(20),
DestructionOfProperty char(3),
DestructionOfPropertyDetail varchar(max),
Diagnosis char(20),
DocumentVersionId int,
EgoExplanation varchar(max),
EgosyntonicAttitude char(20),
EmergencyContact varchar(300),
EmergencyPhone varchar(300),
Ethnicity int,
FacilityName int,
FacilityProviderId int,
FacilitySiteId int,
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
MakingPreparations char(20),
MaritalStatus int,
ModifiedBy char(20),
ModifiedDate datetime,
NoAmbivalence char(20),
NotificationMessage varchar(max),
NotificationSent datetime,
NotifyStaffId1 int,
NotifyStaffId2 int,
NotifyStaffId3 int,
NotifyStaffId4 int,
NumberOfHospitalizations int,
OtherCounty varchar(300),
OtherFacilityName varchar(300),
OtherRecommended int,
OtherRequested int,
OutcomeDetail varchar(max),
PassiveSuicidal char(3),
Physical char(3),
PhysicalDetail varchar(max),
PreviousRescue char(20),
Recommended int,
RecordDeleted char(3),
RelationWithClient int,
RequestNotAuthorized int,
ScreeningCompletedBy int,
SelfHarmfulBehaviour char(3),
SelfHarmfulBehaviourDetail varchar(max),
Sex char(3),
SexualActingOut char(3),
SexualActingOutDetail varchar(max),
SSN char(20),
SuicidalEgoDystonic char(3),
SuicidalEgoSyntonic char(3),
SuicidalIdeationWithin14Days char(3),
SuicidalIdeationWithin48Hours char(3),
Summary varchar(max),
Verbal char(3),
VerbalDetail varchar(max)
)

INSERT INTO #CustomCrisisInterventions
Select
a.AccessToMeans, 
a.AccessToMeansDetail, 
a.ActiveSuicidal, 
a.Aggressive, 
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
a.ClientZip, 
a.CMHCaseNumber, 
a.ConstrictedThinking, 
a.ConsumerRequested, 
a.County, 
a.CreatedBy, 
a.CreatedDate, 
a.CurrentSuicidalIdeation, 
a.CurrentTherapist, 
a.DateOfBirth, 
a.DateOfCrisisIntervention, 
a.DeletedBy, 
a.DeletedDate, 
a.Dependence, 
a.DestructionOfProperty, 
a.DestructionOfPropertyDetail, 
a.Diagnosis, 
a.DocumentVersionId, 
a.EgoExplanation, 
a.EgosyntonicAttitude, 
a.EmergencyContact, 
a.EmergencyPhone, 
a.Ethnicity, 
a.FacilityName, 
a.FacilityProviderId, 
a.FacilitySiteId, 
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
a.MakingPreparations, 
a.MaritalStatus, 
a.ModifiedBy, 
a.ModifiedDate, 
a.NoAmbivalence, 
a.NotificationMessage, 
a.NotificationSent, 
a.NotifyStaffId1, 
a.NotifyStaffId2, 
a.NotifyStaffId3, 
a.NotifyStaffId4, 
a.NumberOfHospitalizations, 
a.OtherCounty, 
a.OtherFacilityName, 
a.OtherRecommended, 
a.OtherRequested, 
a.OutcomeDetail, 
a.PassiveSuicidal, 
a.Physical, 
a.PhysicalDetail, 
a.PreviousRescue, 
a.Recommended, 
a.RecordDeleted, 
a.RelationWithClient, 
a.RequestNotAuthorized, 
a.ScreeningComletedBy, 
a.SelfHarmfulBehaviour, 
a.SelfHarmfulBehaviourDetail, 
a.Sex, 
a.SexualActingOut, 
a.SexualActingOutDetail, 
a.SSN, 
a.SuicidalEgoDystonic, 
a.SuicidalEgoSyntonic, 
a.SuicidalIdeationWithin14, 
a.SuicidalIdeationWithin48, 
a.Summary, 
a.Verbal, 
a.VerbalDetail


 FROM CustomCrisisInterventions a
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

SELECT ''CustomCrisisInterventions'' , ''DateOfCrisisIntervention'', ''Date Of Crisis Intervention must be specified.''
	From #CustomCrisisInterventions
	Where DateOfCrisisIntervention is null
UNION
SELECT ''CustomCrisisInterventions'' , ''ScreeningCompletedBy'', ''Screening Completed By must be specified.''
	From #CustomCrisisInterventions
	Where ScreeningCompletedBy is null
UNION
SELECT ''CustomCrisisInterventions'' , ''County'', ''County must be specified.''
	From #CustomCrisisInterventions
	Where County is null
UNION
SELECT ''CustomCrisisInterventions'' , ''Ethnicity'', ''Ethnicity must be specified.''
	From #CustomCrisisInterventions
	Where Ethnicity is null
UNION
SELECT ''CustomCrisisInterventions'' , ''MaritalStatus'', ''Marital Status must be specified.''
	From #CustomCrisisInterventions
	Where MaritalStatus is null
UNION
SELECT ''CustomCrisisInterventions'' , ''Sex'', ''Sex must be specified.''
	From #CustomCrisisInterventions
	Where Sex is null
UNION
SELECT ''CustomCrisisInterventions'' , ''ClientName'', ''Client Name must be specified.''
	From #CustomCrisisInterventions
	Where isnull(ClientName,'''')=''''
UNION
SELECT ''CustomCrisisInterventions'' , ''DateOfBirth'', ''Date Of Birth must be specified.''
	From #CustomCrisisInterventions
	Where DateOfBirth is null
UNION
SELECT ''CustomCrisisInterventions'' , ''ClientAddress'', ''Client Address must be specified.''
	From #CustomCrisisInterventions
	Where isnull(ClientAddress,'''')=''''
UNION
SELECT ''CustomCrisisInterventions'' , ''ClientCity'', ''Client City must be specified.''
	From #CustomCrisisInterventions
	Where isnull(ClientCity,'''')=''''
UNION
SELECT ''CustomCrisisInterventions'' , ''ClientState'', ''Client State must be specified.''
	From #CustomCrisisInterventions
	Where isnull(ClientState,'''')=''''
UNION
SELECT ''CustomCrisisInterventions'' , ''ClientZip'', ''Client Zip must be specified.''
	From #CustomCrisisInterventions
	Where isnull(ClientZip,'''')=''''
UNION
SELECT ''CustomCrisisInterventions'' , ''ClientCounty'', ''Client County must be specified.''
	From #CustomCrisisInterventions
	Where ClientCounty is null
UNION
SELECT ''CustomCrisisInterventions'' , ''ClientHomePhone'', ''Client Home Phone must be specified.''
	From #CustomCrisisInterventions
	Where isnull(ClientHomePhone,'''')=''''
UNION
SELECT ''CustomCrisisInterventions'' , ''EmergencyContact'', ''Emergency Contact must be specified.''
	From #CustomCrisisInterventions
	Where isnull(EmergencyContact,'''')=''''
UNION
SELECT ''CustomCrisisInterventions'' , ''RelationWithClient'', ''Relation With Client must be specified.''
	From #CustomCrisisInterventions
	Where RelationWithClient is null
--UNION
--SELECT ''CustomCrisisInterventions'' , ''EmergencyPhone'', ''Emergency Phone must be specified.''
--UNION
--SELECT ''CustomCrisisInterventions'' , ''GuardianName'', ''GuardianName must be specified.''
--UNION
--SELECT ''CustomCrisisInterventions'' , ''GuardianPhone'', ''GuardianPhone must be specified.''
--UNION


UNION
SELECT ''CustomCrisisInterventions'', ''JustificationForReferral'', ''Justification For Referral must be specified.''
	From #CustomCrisisInterventions
	Where isnull(JustificationForReferral,'''')=''''


UNION
SELECT ''CustomCrisisInterventions'', ''Aggressive'', ''Aggressive must be specified.''
	From #CustomCrisisInterventions
	Where isnull(Aggressive,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''AWOLRisk'', ''AWOLRisk must be specified.''
FROM #CustomCrisisInterventions cp
WHERE Aggressive <> ''NA'' AND Aggressive is not null
and isnull(AWOLRisk,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''AWOLRiskDetail'', ''AWOL Risk Detail must be specified.''
FROM #CustomCrisisInterventions cp
WHERE AWOLRisk = ''Y''
and isnull(AWOLRiskDetail,'''')=''''
AND Aggressive <> ''NA'' AND Aggressive is not null

UNION
SELECT ''CustomCrisisInterventions'', ''Physical'', ''Physical must be specified.''
FROM #CustomCrisisInterventions cp
WHERE Aggressive <> ''NA'' AND Aggressive is not null
and isnull(Physical,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''PhysicalDetail'', ''Physical Detail must be specified.''
FROM #CustomCrisisInterventions cp
WHERE Physical = ''Y''
AND Aggressive <> ''NA'' AND Aggressive is not null
and isnull(PhysicalDetail,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''Ideation'', ''Ideation must be specified.''
FROM #CustomCrisisInterventions cp
WHERE Aggressive <> ''NA'' AND Aggressive is not null
and isnull(Ideation,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''IdeationDetail'', ''Ideation Detail must be specified.''
FROM #CustomCrisisInterventions cp
WHERE Ideation = ''Y''
AND Aggressive <> ''NA'' AND Aggressive is not null
and isnull(IdeationDetail,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''SexualActingOut'', ''Sexual Acting Out must be specified.''
FROM #CustomCrisisInterventions cp
WHERE Aggressive <> ''NA'' AND Aggressive is not null
and isnull(SexualActingOut,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''SexualActingOutDetail'', ''Sexual Acting Out Detail must be specified.''
FROM #CustomCrisisInterventions cp
WHERE SexualActingOut = ''Y''
AND Aggressive <> ''NA'' AND Aggressive is not null
and isnull(SexualActingOutDetail,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''Verbal'', ''Verbal must be specified.''
FROM #CustomCrisisInterventions cp
WHERE Aggressive <> ''NA'' AND Aggressive is not null
and isnull(Verbal,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''VerbalDetail'', ''Verbal Detail must be specified.''
FROM #CustomCrisisInterventions cp
WHERE Verbal = ''Y''
AND Aggressive <> ''NA'' AND Aggressive is not null
and isnull(VerbalDetail,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''DestructionOfProperty'', ''Destruction Of Property must be specified.''
FROM #CustomCrisisInterventions cp
WHERE Aggressive <> ''NA'' AND Aggressive is not null
and isnull(DestructionOfProperty,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''DestructionOfPropertyDetail'', ''Destruction Of PropertyDetail must be specified.''
FROM #CustomCrisisInterventions cp
WHERE DestructionOfProperty = ''Y''
AND Aggressive <> ''NA'' AND Aggressive is not null
and isnull(DestructionOfPropertyDetail,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''History'', ''History must be specified.''
FROM #CustomCrisisInterventions cp
WHERE Aggressive <> ''NA'' AND Aggressive is not null
and isnull(History,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''ChargesPending'', ''Charges Pending must be specified.''
FROM #CustomCrisisInterventions cp
WHERE Aggressive <> ''NA'' AND Aggressive is not null
and isnull(ChargesPending,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''ChargesPendingDetail'', ''Charges Pending Detail must be specified.''
FROM #CustomCrisisInterventions cp
WHERE ChargesPending = ''Y''
AND Aggressive <> ''NA'' AND Aggressive is not null
and isnull(ChargesPendingDetail,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''JailHold'', ''Jail Hold must be specified.''
FROM #CustomCrisisInterventions cp
WHERE Aggressive <> ''NA'' AND Aggressive is not null
and isnull(JailHold,'''')=''''
UNION
SELECT ''CustomCrisisInterventions'' , ''CurrentSuicidalIdeation'', ''Current Suicidal Ideation must be specified.''
FROM #CustomCrisisInterventions cp
WHERE isnull(CurrentSuicidalIdeation,'''')=''''
UNION
SELECT ''CustomCrisisInterventions'', ''EgoExplanation'', ''Ego Syntonic/Ego Dystonic Explanation must be specified.''
FROM #CustomCrisisInterventions cp
WHERE (SuicidalEgoSyntonic = ''Y''
OR SuicidalEgoDystonic = ''Y'')
and isnull(EgoExplanation,'''')=''''
-----------------------------------------------------------------------------------------------
-- temporary change made to let authors sign the note without specifying the explanation     --
-- 7/9/2007 By RPatil                                                                        --                                                         
AND CurrentSuicidalIdeation = ''Y''
-----------------------------------------------------------------------------------------------

UNION
SELECT ''CustomCrisisInterventions'', ''HasPlanDetail'', ''Has Plan Detail must be specified.''
FROM #CustomCrisisInterventions cp
WHERE HasPlan = ''Y''
and isnull(HasPlanDetail,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''AccessToMeansDetail'', ''Access To Means Detail must be specified.''
FROM #CustomCrisisInterventions cp
WHERE AccessToMeans = ''Y''
and isnull(AccessToMeansDetail,'''')=''''



-- SLAP Questions
UNION
SELECT ''CustomCrisisInterventions'', ''HistorySuicidalAttempts'', ''SLAP - History of Suicidal Attempts must be specified.''
FROM #CustomCrisisInterventions cp
WHERE ( AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y'' )
and isnull(HistorySuicidalAttempts,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''HistoryFamily'', ''SLAP - Family History of Completions must be specified.''
FROM #CustomCrisisInterventions cp
WHERE ( AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y'' )
and isnull(HistoryFamily,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''Diagnosis'', ''SLAP - Diagnosis must be specified.''
FROM #CustomCrisisInterventions cp
WHERE ( AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y'' )
and isnull(Diagnosis,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''PreviousRescue'', ''SLAP - Previous Rescue must be specified.''
FROM #CustomCrisisInterventions cp
WHERE ( AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y'' )
and isnull(PreviousRescue,'''')=''''

--UNION
--SELECT ''CustomCrisisInterventions'', ''FamilySupport'', ''SLAP - Family Support must be specified.''
--FROM #CustomCrisisInterventions cp
--WHERE ( AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y'' )
--and isnull(FamilySupport,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''FamilyUnwillingToHelp'', ''SLAP - Family Unwilling ToH elp must be specified.''
FROM #CustomCrisisInterventions cp
WHERE ( AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y'' )
and isnull(FamilyUnwillingToHelp,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''Dependence'', ''SLAP - Dependence must be specified.''
FROM #CustomCrisisInterventions cp
WHERE ( AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y'' )
and isnull(Dependence,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''ConstrictedThinking'', ''SLAP - Constricted Thinking must be specified.''
FROM #CustomCrisisInterventions cp
WHERE ( AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y'' )
and isnull(ConstrictedThinking,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''EgosyntonicAttitude'', ''SLAP - Ego Syntonic Attitude must be specified.''
FROM #CustomCrisisInterventions cp
WHERE ( AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y'' )
and isnull(EgosyntonicAttitude,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''Helplessness'', ''SLAP - Helplessness must be specified.''
FROM #CustomCrisisInterventions cp
WHERE ( AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y'' )
and isnull(Helplessness,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''Hopelessness'', ''SLAP - Hopelessness must be specified.''
FROM #CustomCrisisInterventions cp
WHERE ( AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y'' )
and isnull(Hopelessness,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''MakingPreparations'', ''SLAP - Making Preparations must be specified.''
FROM #CustomCrisisInterventions cp
WHERE ( AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y'' )
and isnull(MakingPreparations,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''NoAmbivalence'', ''SLAP - No Ambivalence must be specified.''
FROM #CustomCrisisInterventions cp
WHERE ( AccessToMeans = ''Y'' OR HasPlan = ''Y'' OR ActiveSuicidal = ''Y'' )
and isnull(NoAmbivalence,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''SelfHarmfulBehaviour'', ''Current Self Harmful Behaviour must be specified.''
FROM #CustomCrisisInterventions cp
WHERE isnull(SelfHarmfulBehaviour,'''')=''''
UNION
SELECT ''CustomCrisisInterventions'', ''SelfHarmfulBehaviourDetail'', ''Current Self Harmful Behavior Detail must be specified.''
FROM #CustomCrisisInterventions cp
WHERE SelfHarmfulBehaviour = ''Y''
and isnull(SelfHarmfulBehaviourDetail,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''OutcomeDetail'', ''Current Self Harmful Behavior Outcome Detail must be specified.''
FROM #CustomCrisisInterventions cp
WHERE SelfHarmfulBehaviour = ''Y''
and isnull(OutcomeDetail,'''')=''''
	/*
	UNION
	SELECT ''CustomCrisisInterventions'', ''NumberOfInpatient'', ''Number Of IP Psychiactric Hospitalizatoins must be specified.''
	FROM #CustomCrisisInterventions cp
	WHERE UnableToObtain <> ''Y''

	UNION
	SELECT ''CustomCrisisInterventions'', ''DateOfRecentInpatient'', ''Date Of Most Recent IP Hospitalization must be specified.''
	FROM #CustomCrisisInterventions cp
	WHERE isnull(UnableToObtain, ''N'') <> ''Y''
	AND isnull(NumberOfInpatient, '''') <> '''' 

	UNION
	SELECT ''CustomCrisisInterventions'', ''Facility'', ''Facility must be specified.''
	FROM #CustomCrisisInterventions cp
	WHERE isnull(UnableToObtain, ''N'') <> ''Y''


	UNION
	SELECT ''CustomCrisisInterventions'', ''PreviosOutpatientTreatment'', ''Previous OP Treatment must be specified.''
	WHERE isnull(UnableToObtain, ''N'') <> ''Y''

	UNION
	SELECT ''CustomCrisisInterventions'', ''LastSeen'', ''Previous OP Treatment - Last Seen must be specified.''
	WHERE isnull(UnableToObtain, ''N'') <> ''Y''
	AND isnull(PreviousOutpatientTreatment, ''N'')= ''Y'' 
	*/

UNION
SELECT ''CustomCrisisInterventions'', ''ConsumerRequested'', ''Consumer Requested Service must be specified.''
FROM #CustomCrisisInterventions cp
WHERE NOT EXISTS (SELECT 1 FROM CustomRequestedServices r
		  WHERE r.DocumentVersionId = cp.DocumentVersionId
		  AND isnull(recorddeleted, ''N'') = ''N'')
and isnull(ConsumerRequested,'''')=''''

UNION
SELECT ''CustomCrisisInterventions'', ''Recommended'', ''Recommended/Authorized Service must be specified.''
FROM #CustomCrisisInterventions cp
WHERE NOT EXISTS (SELECT 1 FROM CustomRecommendedServices r
		  WHERE r.DocumentVersionId = cp.DocumentVersionId
		  AND isnull(recorddeleted, ''N'') = ''N'')
and isnull(Recommended,'''')=''''
UNION
SELECT ''CustomCrisisInterventions'' , ''OtherFacilityName'', ''OtherFacilityName must be specified.''
FROM #CustomCrisisInterventions cp
WHERE isnull(FacilityName, '''') = '''' AND isnull(OtherFacilityName, '''') = ''''
AND Isnull(FacilityProviderId, '''') = '''' AND isnull(FacilitySiteId, '''') = ''''
AND Recommended in (2341, 2342)

UNION
SELECT ''CustomCrisisInterventions'' , ''Summary'', ''Summary must be specified.''
FROM #CustomCrisisInterventions cp
where isnull(cp.Summary, '''')=  '''' 


/*
	--Full Mental Status
	exec csp_validateFullMentalStatus @DocumentVersionId, @documentCodeId
	if @@error <> 0 goto error
*/	
	--SU Assessment Validation
--Will be replaced in DocumentValidations table without this call
	exec csp_validateCustomSUAssessments @DocumentVersionId--, @documentCodeId




	if @@error <> 0 goto error
	
--
--Check to make sure record exists in custom table for @DocumentCodeId
--
If not exists (Select 1 from #CustomCrisisInterventions)
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

Select ''CustomCrisisInterventions'', ''DeletedBy'', ''Error occurred. Please contact your system administrator. No record exists in custom table.''
Where not exists  (Select 1 from #CustomCrisisInterventions)
end


	



if @@error <> 0 goto error





return

error:
raiserror 50000 ''csp_validateCustomScreenForServices failed.  Contact your system administrator.''
' 
END
GO
