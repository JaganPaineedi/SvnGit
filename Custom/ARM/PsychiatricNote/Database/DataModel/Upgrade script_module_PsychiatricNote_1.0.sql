----- STEP 1 ----------

------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins


--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------

------ END OF STEP 3 -----

------ STEP 4 ----------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentPsychiatricNoteGenerals')
 BEGIN
/* 
 * TABLE: CustomDocumentPsychiatricNoteGenerals 
 */

CREATE TABLE CustomDocumentPsychiatricNoteGenerals(
    DocumentVersionId					int							NOT NULL,
    CreatedBy							type_CurrentUser			NOT NULL,
    CreatedDate							type_CurrentDatetime		NOT NULL,
    ModifiedBy							type_CurrentUser			NOT NULL,
    ModifiedDate						type_CurrentDatetime		NOT NULL,
    RecordDeleted						type_YOrN					NULL
										CHECK (RecordDeleted in('Y','N')),
    DeletedBy							type_UserId					NULL,
    DeletedDate							datetime					NULL,
    AdultChildAdolescent				char(1)						NULL
										CHECK (AdultChildAdolescent in('C','A')),
	PersonPresent						type_Comment2				NULL,
	ChiefComplaint						type_Comment2				NULL,
	PresentingProblem					type_Comment2				NULL,
	SideEffects							char(1)						NULL
										CHECK (SideEffects in('S','N')),
	SideEffectsComments					type_Comment2				NULL,
	PlanLastVisit						type_Comment2				NULL,
	PsychiatricHistory					char(1)						NULL
										CHECK (PsychiatricHistory in('C','N')),
	PsychiatricHistoryComments			type_Comment2				NULL,
	FamilyHistory						char(1)						NULL
										CHECK (FamilyHistory in('C','N')),
	FamilyHistoryComments				type_Comment2				NULL,
	SocialHistory						char(1)						NULL
										CHECK (SocialHistory in('C','N')),
	SocialHistoryComments				type_Comment2				NULL,
	ReviewPsychiatric					type_YOrN					NULL
										CHECK (ReviewPsychiatric in('Y','N')),
	ReviewMusculoskeletal				type_YOrN					NULL
										CHECK (ReviewMusculoskeletal in('Y','N')),
	ReviewConstitutional				type_YOrN					NULL
										CHECK (ReviewConstitutional in('Y','N')),
	ReviewEarNoseMouthThroat			type_YOrN					NULL
										CHECK (ReviewEarNoseMouthThroat in('Y','N')),
	ReviewGenitourinary					type_YOrN					NULL
										CHECK (ReviewGenitourinary in('Y','N')),
	ReviewGastrointestinal				type_YOrN					NULL
										CHECK (ReviewGastrointestinal in('Y','N')),
	ReviewIntegumentary					type_YOrN					NULL
										CHECK (ReviewIntegumentary in('Y','N')),
	ReviewEndocrine						type_YOrN					NULL
										CHECK (ReviewEndocrine in('Y','N')),
	ReviewNeurological					type_YOrN					NULL
										CHECK (ReviewNeurological in('Y','N')),
	ReviewImmune						type_YOrN					NULL
										CHECK (ReviewImmune in('Y','N')),
	ReviewEyes							type_YOrN					NULL
										CHECK (ReviewEyes in('Y','N')),
	ReviewRespiratory					type_YOrN					NULL
										CHECK (ReviewRespiratory in('Y','N')),
	ReviewCardio						type_YOrN					NULL
										CHECK (ReviewCardio in('Y','N')),
	ReviewHemLymph						type_YOrN					NULL
										CHECK (ReviewHemLymph in('Y','N')),
	ReviewOthersNegative				type_YOrN					NULL
										CHECK (ReviewOthersNegative in('Y','N')),
	ReviewComments						type_Comment2				NULL,	
	AllergiesText						type_Comment2				NULL,	
	SubstanceUse						type_Comment2				NULL,
	AllergiesSmoke						char(1)						NULL
										CHECK (AllergiesSmoke in('N','S')),
	AllergiesSmokePerday				varchar(10)					NULL,
	AllergiesTobacouse					type_Comment2				NULL,
	AllergiesCaffeineConsumption		type_Comment2				NULL,			
	Pregnant							type_YOrNOrNA				NULL
										CHECK (Pregnant in('Y','N','A')),	
	LastMenstrualPeriod					type_Comment2				NULL,
	MedicalHistory						CHAR(1)						NULL
										CHECK (MedicalHistory in ('N','C')),
	MedicalHistoryComments				type_Comment2				NULL,
	SUAlcohol							type_YOrN					NULL
										CHECK (SUAlcohol in ('Y','N')) ,
	SUAmphetamines						type_YOrN					NULL
										CHECK (SUAmphetamines in ('Y','N')),
	SUBenzos							type_YOrN					NULL
										CHECK (SUBenzos in ('Y','N')) ,
	SUCocaine							type_YOrN					NULL
										CHECK (SUCocaine in ('Y','N')) ,
	SUMarijuana							type_YOrN					NULL
										CHECK (SUMarijuana in ('Y','N')) ,
	SUOpiates							type_YOrN					NULL
										CHECK (SUOpiates in ('Y','N')) ,
	SUHallucinogen						type_YOrN NULL
										CHECK (SUHallucinogen in ('Y','N')) ,
	SUInhalant							type_YOrN NULL
										CHECK (SUInhalant in ('Y','N')) ,
	SUOthers							type_YOrN NULL
										CHECK (SUOthers in ('Y','N')) ,
	SUAlcoholDiagnosis					type_Comment2				NULL,
	SUAmphetaminesDiagnosis				type_Comment2				NULL,
	SUBenzosDiagnosis					type_Comment2				NULL,
	SUCocaineDiagnosis					type_Comment2				 NULL,
	SUMarijuanaDiagnosis				type_Comment2				NULL,
	SUOpiatesDiagnosis					type_Comment2				NULL,
	SUOthersDiagnosis					type_Comment2				NULL,
	SUHallucinogenDiagnosis				type_Comment2				NULL,
	SUInhalantDiagnosis					type_Comment2				NULL,									
    CONSTRAINT CustomDocumentPsychiatricNoteGenerals_PK PRIMARY KEY CLUSTERED (DocumentVersionId)		 	
)
 IF OBJECT_ID('CustomDocumentPsychiatricNoteGenerals') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentPsychiatricNoteGenerals >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentPsychiatricNoteGenerals >>>', 16, 1)
/*  
 * TABLE: CustomDocumentPsychiatricNoteGenerals 
 */ 

 ALTER TABLE CustomDocumentPsychiatricNoteGenerals ADD CONSTRAINT DocumentVersions_CustomDocumentPsychiatricNoteGenerals_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
  	EXEC sys.sp_addextendedproperty 'CustomDocumentPsychiatricNoteGenerals_Description'
	,'MedicalHistory field stores N, C.N- Reviewed No Changes, C- Reviewed With Changes'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentPsychiatricNoteGenerals'
	,'column'
	,'MedicalHistory'  
    
PRINT 'STEP 4(A) COMPLETED'
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomPsychiatricNoteProblems')
 BEGIN
/* 
 * TABLE: CustomPsychiatricNoteProblems 
 */

CREATE TABLE CustomPsychiatricNoteProblems(
    PsychiatricNoteProblemId			int identity(1,1)			NOT NULL,
    CreatedBy							type_CurrentUser			NOT NULL,
    CreatedDate							type_CurrentDatetime		NOT NULL,
    ModifiedBy							type_CurrentUser			NOT NULL,
    ModifiedDate						type_CurrentDatetime		NOT NULL,
    RecordDeleted						type_YOrN					NULL
										CHECK (RecordDeleted in	('Y','N')),
    DeletedBy							type_UserId					NULL,
    DeletedDate							datetime					NULL,
    DocumentVersionId					int							NULL,
    SubjectiveText						type_Comment2				NULL,
	TypeOfProblem						type_GlobalCode				NULL,
	Severity							type_GlobalCode				NULL,
	ModifyingFactors					type_Comment2				NULL,					
	Duration							type_GlobalCode				NULL,
	TimeOfDayAllday						type_YOrN					NULL
										CHECK (TimeOfDayAllday in	('Y','N')),
	TimeOfDayMorning					type_YOrN					NULL
										CHECK (TimeOfDayMorning in('Y','N')),
	TimeOfDayAfternoon					type_YOrN					NULL
										CHECK (TimeOfDayAfternoon in('Y','N')),
	TimeOfDayNight						type_YOrN					NULL
										CHECK (TimeOfDayNight in('Y','N')),
	ContextText							type_Comment2				NULL,
	LocationHome						type_YOrN					NULL
										CHECK (LocationHome in('Y','N')),
	LocationWork						type_YOrN					NULL
										CHECK (LocationWork in('Y','N')),
	LocationSchool						type_YOrN					NULL
										CHECK (LocationSchool in('Y','N')),
	LocationEveryWhere					type_YOrN					NULL
										CHECK (LocationEveryWhere in	('Y','N')),
	LocationOther						type_YOrN					NULL
										CHECK (LocationOther in	('Y','N')),
	LocationOtherText					type_Comment2				NULL,
	AssociatedSignsSymptoms				type_GlobalCode				NULL,
	AssociatedSignsSymptomsOtherText	type_Comment2				NULL,
	ProblemStatus						type_GlobalCode				NULL,
	DiscussLongActingInjectable			type_YOrN					NULL
										CHECK (DiscussLongActingInjectable in	('Y','N')),
	ProblemMDMComments					type_Comment2				NULL,
	ICD10Code							type_Comment2				NULL,
    CONSTRAINT CustomPsychiatricNoteProblems_PK PRIMARY KEY CLUSTERED (PsychiatricNoteProblemId)		 	
)
 IF OBJECT_ID('CustomPsychiatricNoteProblems') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomPsychiatricNoteProblems >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomPsychiatricNoteProblems >>>', 16, 1)
    
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('CustomPsychiatricNoteProblems') AND name='XIE1_CustomPsychiatricNoteProblems')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_CustomPsychiatricNoteProblems] ON [dbo].[CustomPsychiatricNoteProblems] 
		(
		DocumentVersionId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomPsychiatricNoteProblems') AND name='XIE1_CustomPsychiatricNoteProblems')
		PRINT '<<< CREATED INDEX CustomPsychiatricNoteProblems.XIE1_CustomPsychiatricNoteProblems >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CustomPsychiatricNoteProblems.XIE1_CustomPsychiatricNoteProblems >>>', 16, 1)		
	END		
/*  
 * TABLE: CustomPsychiatricNoteProblems 
 */ 

 ALTER TABLE CustomPsychiatricNoteProblems ADD CONSTRAINT DocumentVersions_CustomPsychiatricNoteProblems_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
PRINT 'STEP 4(B) COMPLETED'
END	

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomPsychiatricPCPProviders')
 BEGIN
/* 
 * TABLE: CustomPsychiatricPCPProviders 
 */

CREATE TABLE CustomPsychiatricPCPProviders(
    PsychiatricPCPProviderId			int identity(1,1)			NOT NULL,
    CreatedBy							type_CurrentUser			NOT NULL,
    CreatedDate							type_CurrentDatetime		NOT NULL,
    ModifiedBy							type_CurrentUser			NOT NULL,
    ModifiedDate						type_CurrentDatetime		NOT NULL,
    RecordDeleted						type_YOrN					NULL
										CHECK (RecordDeleted in	('Y','N')),
    DeletedBy							type_UserId					NULL,
    DeletedDate							datetime					NULL,
    DocumentVersionId					int							NULL,
    ExternalReferralProviderId			int							NULL,
    CONSTRAINT CustomPsychiatricPCPProviders_PK PRIMARY KEY CLUSTERED (PsychiatricPCPProviderId)		 	
)
 IF OBJECT_ID('CustomPsychiatricPCPProviders') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomPsychiatricPCPProviders >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomPsychiatricPCPProviders >>>', 16, 1)
/*  
 * TABLE: CustomPsychiatricPCPProviders 
 */ 

 ALTER TABLE CustomPsychiatricPCPProviders ADD CONSTRAINT DocumentVersions_CustomPsychiatricPCPProviders_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
 ALTER TABLE CustomPsychiatricPCPProviders ADD CONSTRAINT ExternalReferralProviders_CustomPsychiatricPCPProviders_FK 
    FOREIGN KEY (ExternalReferralProviderId)
    REFERENCES ExternalReferralProviders(ExternalReferralProviderId)
    
PRINT 'STEP 4(C) COMPLETED'
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentPsychiatricNoteExams')
 BEGIN
/* 
 * TABLE: CustomDocumentPsychiatricNoteExams 
 */

CREATE TABLE CustomDocumentPsychiatricNoteExams(
    DocumentVersionId					int							NOT NULL,
    CreatedBy							type_CurrentUser			NOT NULL,
    CreatedDate							type_CurrentDatetime		NOT NULL,
    ModifiedBy							type_CurrentUser			NOT NULL,
    ModifiedDate						type_CurrentDatetime		NOT NULL,
    RecordDeleted						type_YOrN					NULL
										CHECK (RecordDeleted in	('Y','N')),
    DeletedBy							type_UserId					NULL,
    DeletedDate							datetime					NULL,
    ReviewWithChanges					char(1)						NULL
										CHECK (ReviewWithChanges in('C','N','A')),
    MusculoskeletalMuscleNormal			type_YOrN					NULL
										CHECK (MusculoskeletalMuscleNormal in('Y','N')),
	MusculoskeletalMuscleAbnormal		type_YOrN					NULL
										CHECK (MusculoskeletalMuscleAbnormal in	('Y','N')),
	MusculoskeletalMuscleTone			type_YOrN					NULL
										CHECK (MusculoskeletalMuscleTone in('Y','N')),
	MusculoskeletalMuscleComment		type_Comment2				NULL,
	MusculoskeletalMuscleTicsTremors	type_YOrN					NULL
										CHECK (MusculoskeletalMuscleTicsTremors in('Y','N')),
	MusculoskeletalMuscleEPS			type_YOrN					NULL
										CHECK (MusculoskeletalMuscleEPS in('Y','N')),
	GaitStationNormal					type_YOrN					NULL
										CHECK (GaitStationNormal in('Y','N')),
	GaitStationAbnormal					type_YOrN					NULL
										CHECK (GaitStationAbnormal in('Y','N')),
	AlertOriented						type_YOrN					NULL
										CHECK (AlertOriented in	('Y','N')),
	AlertOrientedComment				type_Comment2				NULL,
	Grooming							char(1)						NULL
										CHECK (Grooming in('G','F','D','P')),
	GroomingComment						type_Comment2				NULL,
	EyeContact							char(1)						NULL
										CHECK (EyeContact in('G','A','N')),
	EyeContactComment					type_Comment2				NULL,
	Cooperative							type_YOrN					NULL
										CHECK (Cooperative in('Y','N')),
	CooperativeComment					type_Comment2				NULL,
	MentalStatusGeneral					type_Comment2				NULL,			
	Speech								char(1)						NULL
										CHECK (Speech in('R','S')),
	SpeechComment						type_Comment2				NULL,
	Psychomotor							char(1)						NULL
										CHECK (Psychomotor in('N','I','D','O')),
	PsychomotorComment					type_Comment2				NULL,
	MoodEuthymic						type_YOrN					NULL
										CHECK (MoodEuthymic in('Y','N')),
	MoodLabile							type_YOrN					NULL
										CHECK (MoodLabile in('Y','N')),		
	MoodDysphoric						type_YOrN					NULL
										CHECK (MoodDysphoric in('Y','N')),	
	MoodElevated						type_YOrN					NULL
										CHECK (MoodElevated in('Y','N')),	
	MoodAnxious							type_YOrN					NULL
										CHECK (MoodAnxious in('Y','N')),
	MoodIrritable						type_YOrN					NULL
										CHECK (MoodIrritable in('Y','N')),	
	MoodExpansive						type_YOrN					NULL
										CHECK (MoodExpansive in('Y','N')),			
	MoodComment							type_Comment2				NULL,
	AffectBroad							type_YOrN					NULL
										CHECK (AffectBroad in('Y','N')),
	AffectFlat							type_YOrN					NULL
										CHECK (AffectFlat in('Y','N')),
	AffectBlunted						type_YOrN					NULL
										CHECK (AffectBlunted in	('Y','N')),	
	AffectConstricted					type_YOrN					NULL
										CHECK (AffectConstricted in	('Y','N')),
	AffectGuarded						type_YOrN					NULL
										CHECK (AffectGuarded in	('Y','N')),
	AffectComment						type_Comment2				NULL,
	ThoughtProcessLogical				type_YOrN					NULL
										CHECK (ThoughtProcessLogical in('Y','N')),
	ThoughtProcessIllogical				type_YOrN					NULL
										CHECK (ThoughtProcessIllogical in('Y','N')),
	ThoughtProcessCircumstantial		type_YOrN					NULL
										CHECK (ThoughtProcessCircumstantial in('Y','N')),	
	ThoughtProcessTangential			type_YOrN					NULL
										CHECK (ThoughtProcessTangential in('Y','N')),	
	ThoughtProcessFlightOfIdeas			type_YOrN					NULL
										CHECK (ThoughtProcessFlightOfIdeas in('Y','N')),	
	ThoughtProcessPreoccupied			type_YOrN					NULL
										CHECK (ThoughtProcessPreoccupied in('Y','N')),		
	ThoughtProcessAuditoryHallucinations type_YOrN					NULL
										CHECK (ThoughtProcessAuditoryHallucinations in('Y','N')),
	ThoughtProcessDelusions				type_YOrN					NULL
										CHECK (ThoughtProcessDelusions in('Y','N')),	
	ThoughtProcessVisualHallucinations	type_YOrN					NULL
										CHECK (ThoughtProcessVisualHallucinations in('Y','N')),	
	ThoughtProcessParanoia				type_YOrN					NULL
										CHECK (ThoughtProcessParanoia in('Y','N')),	
	ThoughtProcessGrandiose				type_YOrN					NULL
										CHECK (ThoughtProcessGrandiose in('Y','N')),
	ThoughtProcessReferential			type_YOrN					NULL
										CHECK (ThoughtProcessReferential in('Y','N')),	
	ThoughtProcessPovertyOfThought		type_YOrN					NULL
										CHECK (ThoughtProcessPovertyOfThought in('Y','N')),		
	ThoughtProcessLooseAssociations		type_YOrN					NULL
										CHECK (ThoughtProcessLooseAssociations in('Y','N')),					
	ThoughtProcessComment				type_Comment2				NULL,
	Suicidal							char(1)						NULL
										CHECK (Suicidal in('N','S')),
	SuicidalIdeation					type_YOrN					NULL
										CHECK (SuicidalIdeation in('Y','N')),	
	SuicidalIntent						type_YOrN					NULL
										CHECK (SuicidalIntent in('Y','N')),	
	SuicidalPlan						type_YOrN					NULL
										CHECK (SuicidalPlan in('Y','N')),	
	SuicidalComment						type_Comment2				NULL,	
	Homicidal							char(1)						NULL
										CHECK (Homicidal in('N','S')),
	HomicidalIdeation					type_YOrN					NULL
										CHECK (HomicidalIdeation in('Y','N')),	
	HomicidalIntent						type_YOrN					NULL
										CHECK (HomicidalIntent in('Y','N')),	
	HomicidalPlan						type_YOrN					NULL
										CHECK (HomicidalPlan in('Y','N')),	
	HomicidalCommnet					type_Comment2				NULL,															
	MemoryRecall						char(1)						NULL
										CHECK (MemoryRecall in('I','S')),
	MemoryRecallComment					type_Comment2				NULL,
	Intelligence						char(1)						NULL
										CHECK (Intelligence in('A','B','L','W')),					
	InsightJudgment						char(1)						NULL
										CHECK (InsightJudgment in('G','F','P')),
	InsightJudgmentComment				type_Comment2				NULL,
	MentalStatusAdditionalComment	    type_Comment2				NULL,
	GeneralAppearance					CHAR(1)						NULL
										CHECK (GeneralAppearance in ('A','N','G')),
	GeneralPoorlyAddresses				type_YOrN	NULL
										CHECK (GeneralPoorlyAddresses in ('Y','N')),
	GeneralPoorlyGroomed				type_YOrN	NULL
										CHECK (GeneralPoorlyGroomed in ('Y','N')),
	GeneralDisheveled					type_YOrN	NULL
										CHECK (GeneralDisheveled in ('Y','N')),
	GeneralOdferous						type_YOrN	NULL
										CHECK (GeneralOdferous in ('Y','N')),
	GeneralDeformities					type_YOrN	NULL
										CHECK (GeneralDeformities in ('Y','N')),
	GeneralPoorNutrion					type_YOrN	NULL
										CHECK (GeneralPoorNutrion in ('Y','N')),
	GeneralRestless						type_YOrN	NULL
										CHECK (GeneralRestless in ('Y','N')),
	GeneralPsychometer					type_YOrN	NULL
										CHECK (GeneralPsychometer in ('Y','N')),
	GeneralHyperActive					type_YOrN	NULL
										CHECK (GeneralHyperActive in ('Y','N')),
	GeneralEvasive						type_YOrN	NULL
										CHECK (GeneralEvasive in ('Y','N')),
	GeneralInAttentive					type_YOrN	NULL
										CHECK (GeneralInAttentive in ('Y','N')),
	GeneralPoorEyeContact				type_YOrN	NULL
										CHECK (GeneralPoorEyeContact in ('Y','N')),
	GeneralHostile						type_YOrN	NULL
										CHECK (GeneralHostile in ('Y','N')),
	SpeechIncreased						type_YOrN	NULL
										CHECK (SpeechIncreased in ('Y','N')),
	SpeechDecreased						type_YOrN	NULL
										CHECK (SpeechDecreased in ('Y','N')),
	SpeechPaucity						type_YOrN	NULL
										CHECK (SpeechPaucity in ('Y','N')),
	SpeechHyperverbal					type_YOrN	NULL
										CHECK (SpeechHyperverbal in ('Y','N')),
	SpeechPoorArticulations				type_YOrN	NULL
										CHECK (SpeechPoorArticulations in ('Y','N')),
	SpeechLoud							type_YOrN	NULL
										CHECK (SpeechLoud in ('Y','N')),
	SpeechSoft							type_YOrN	NULL
										CHECK (SpeechSoft in ('Y','N')),
	SpeechMute							type_YOrN	NULL
										CHECK (SpeechMute in ('Y','N')),
	SpeechStuttering					type_YOrN	NULL
										CHECK (SpeechStuttering in ('Y','N')),
	SpeechImpaired						type_YOrN	NULL
										CHECK (SpeechImpaired in ('Y','N')),
	SpeechPressured						type_YOrN	NULL
										CHECK (SpeechPressured in ('Y','N')),
	SpeechFlight						type_YOrN	NULL
										CHECK (SpeechFlight in ('Y','N')),
	PsychiatricNoteExamLanguage			char(1)		NULL
										CHECK (PsychiatricNoteExamLanguage in ('A','N','W')),
										CHECK (PsychiatricNoteExamLanguage in ('A','N','W')),
	LanguageDifficultyNaming			type_YOrN	NULL
										CHECK (LanguageDifficultyNaming in ('Y','N')),
	LanguageDifficultyRepeating			type_YOrN	NULL
										CHECK (LanguageDifficultyRepeating in ('Y','N')),
	MoodAndAffect						char(1)	NULL
										CHECK (MoodAndAffect in ('A','N','W')),
	MoodHappy							type_YOrN	NULL
										CHECK (MoodHappy in ('Y','N')),
	MoodSad								type_YOrN	NULL
										CHECK (MoodSad in ('Y','N')),
	MoodAngry							type_YOrN	NULL
										CHECK (MoodAngry in ('Y','N')),
	MoodElation							type_YOrN	NULL
										CHECK (MoodElation in ('Y','N')),
	MoodNormal							type_YOrN	NULL
										CHECK (MoodNormal in ('Y','N')),
	AffectEuthymic						type_YOrN	NULL
										CHECK (AffectEuthymic in ('Y','N')),
	AffectDysphoric						type_YOrN	NULL
										CHECK (AffectDysphoric in ('Y','N')),
	AffectAnxious						type_YOrN	NULL
										CHECK (AffectAnxious in ('Y','N')),
	AffectIrritable						type_YOrN	NULL
										CHECK (AffectIrritable in ('Y','N')),
	AffectLabile						type_YOrN	NULL
										CHECK (AffectLabile in ('Y','N')),
	AffectEuphoric						type_YOrN	NULL
										CHECK (AffectEuphoric in ('Y','N')),
	 AffectCongruent					type_YOrN	NULL
										CHECK (AffectCongruent in ('Y','N')),
	AttensionSpanAndConcentration		char(1)		NULL
										CHECK (AttensionSpanAndConcentration in ('A','N','W')),
	AttensionPoorConcentration			type_YOrN					NULL
										CHECK (AttensionPoorConcentration in('Y','N')),	
	AttensionPoorAttension				type_YOrN					NULL
										CHECK (AttensionPoorAttension in('Y','N')),	
	AttensionDistractible				type_YOrN					NULL
										CHECK (AttensionDistractible in('Y','N')),	
	ThoughtContentCognision				char(1)	NULL
										CHECK (ThoughtContentCognision in ('A','N','W')),
	TPDisOrganised						type_YOrN					NULL
										CHECK (TPDisOrganised in('Y','N')),	
	TPBlocking							type_YOrN					NULL
										CHECK (TPBlocking in('Y','N')),	
	TPPersecution						type_YOrN					NULL
										CHECK (TPPersecution in('Y','N')),	
	TPBroadCasting						type_YOrN					NULL
										CHECK (TPBroadCasting in('Y','N')),	
	TPDetrailed							type_YOrN					NULL
										CHECK (TPDetrailed in('Y','N')),	
	TPThoughtinsertion					type_YOrN					NULL
										CHECK (TPThoughtinsertion in('Y','N')),	
	TPIncoherent						type_YOrN					NULL
										CHECK (TPIncoherent in('Y','N')),	
	TPRacing							type_YOrN					NULL
										CHECK (TPRacing in('Y','N')),	
	TPIllogical							type_YOrN					NULL
										CHECK (TPIllogical in('Y','N')),	
	TCDelusional						type_YOrN					NULL
										CHECK (TCDelusional in('Y','N')),	
	TCParanoid							type_YOrN					NULL
										CHECK (TCParanoid in('Y','N')),	
	TCIdeas								type_YOrN					NULL
										CHECK (TCIdeas in('Y','N')),	
	TCThoughtInsertion					type_YOrN					NULL
										CHECK (TCThoughtInsertion in('Y','N')),	
	TCThoughtWithdrawal					type_YOrN					NULL
										CHECK (TCThoughtWithdrawal in('Y','N')),	
	TCThoughtBroadcasting				type_YOrN					NULL
										CHECK (TCThoughtBroadcasting in('Y','N')),	
	TCReligiosity						type_YOrN					NULL
										CHECK (TCReligiosity in('Y','N')),	
	TCGrandiosity						type_YOrN					NULL
										CHECK (TCGrandiosity in('Y','N')),	
	TCPerserveration					type_YOrN					NULL
										CHECK (TCPerserveration in('Y','N')),	
	TCObsessions						type_YOrN					NULL
										CHECK (TCObsessions in('Y','N')),	
	TCWorthlessness						type_YOrN					NULL
										CHECK (TCWorthlessness in('Y','N')),	
	TCLoneliness						type_YOrN					NULL
										CHECK (TCLoneliness in('Y','N')),	
	TCGuilt								type_YOrN					NULL
										CHECK (TCGuilt in('Y','N')),	
	TCHopelessness						type_YOrN					NULL
										CHECK (TCHopelessness in('Y','N')),	
	TCHelplessness						type_YOrN					NULL
										CHECK (TCHelplessness in('Y','N')),	
	CAPoorKnowledget					type_YOrN					NULL
										CHECK (CAPoorKnowledget in('Y','N')),	
	CAConcrete							type_YOrN					NULL
										CHECK (CAConcrete in('Y','N')),	
	CAUnable							type_YOrN					NULL
										CHECK (CAUnable in('Y','N')),	
	CAPoorComputation					type_YOrN					NULL
										CHECK (CAPoorComputation in('Y','N')),	
	Associations						char(1)	NULL
										CHECK (Associations in ('A','N','W')),
	AssociationsLoose					type_YOrN					NULL
										CHECK (AssociationsLoose in('Y','N')),	
	AssociationsClanging				type_YOrN					NULL
										CHECK (AssociationsClanging in('Y','N')),	
	AssociationsWordsalad				type_YOrN					NULL
										CHECK (AssociationsWordsalad in('Y','N')),	
	AssociationsCircumstantial			type_YOrN					NULL
										CHECK (AssociationsCircumstantial in('Y','N')),	
	AssociationsTangential				type_YOrN					NULL
										CHECK (AssociationsTangential in('Y','N')),	
	AbnormalorPsychoticThoughts			char(1)	NULL
										CHECK (AbnormalorPsychoticThoughts in ('A','N')),
	PsychosisOrDisturbanceOfPerception	char(1)	NULL
										CHECK (PsychosisOrDisturbanceOfPerception in ('N','P')),
	PDAuditoryHallucinations			type_YOrN					NULL
										CHECK (PDAuditoryHallucinations in('Y','N')),	
	PDVisualHallucinations				type_YOrN					NULL
										CHECK (PDVisualHallucinations in('Y','N')),	
	PDCommandHallucinations				type_YOrN					NULL
										CHECK (PDCommandHallucinations in('Y','N')),	
	PDDelusions							type_YOrN					NULL
										CHECK (PDDelusions in('Y','N')),	
	PDPreoccupation						type_YOrN					NULL
										CHECK (PDPreoccupation in('Y','N')),	
	PDOlfactoryHallucinations			type_YOrN					NULL
										CHECK (PDOlfactoryHallucinations in('Y','N')),	
	PDGustatoryHallucinations			type_YOrN					NULL
										CHECK (PDGustatoryHallucinations in('Y','N')),	
	PDTactileHallucinations				type_YOrN					NULL
										CHECK (PDTactileHallucinations in('Y','N')),	
	PDSomaticHallucinations				type_YOrN					NULL
										CHECK (PDSomaticHallucinations in('Y','N')),	
	PDIllusions							type_YOrN					NULL
										CHECK (PDIllusions in('Y','N')),	
	PDCurrentSuicideIdeation			type_YOrN					NULL
										CHECK (PDCurrentSuicideIdeation in('Y','N')),	
	PDCurrentSuicidalPlan				type_YOrN					NULL
										CHECK (PDCurrentSuicidalPlan in('Y','N')),	
	PDCurrentSuicidalIntent				type_YOrN					NULL
										CHECK (PDCurrentSuicidalIntent in('Y','N')),	
	PDCurrentHomicidalIdeation			type_YOrN					NULL
										CHECK (PDCurrentHomicidalIdeation in('Y','N')),	
	PDMeanstocarry						type_YOrN					NULL
										CHECK (PDMeanstocarry in('Y','N')),	
	PDCurrentHomicidalPlans				type_YOrN					NULL
										CHECK (PDCurrentHomicidalPlans in('Y','N')),	
	PDCurrentHomicidalIntent			type_YOrN					NULL
										CHECK (PDCurrentHomicidalIntent in('Y','N')),	
	PDMeansToCarryNew					type_YOrN					NULL
										CHECK (PDMeansToCarryNew in('Y','N')),	
	Orientation							char(1)	NULL
										CHECK (Orientation in ('A','N','W')),
	OrientationPerson					type_YOrN					NULL
										CHECK (OrientationPerson in('Y','N')),	
	OrientationPlace					type_YOrN					NULL
										CHECK (OrientationPlace in('Y','N')),	
	OrientationTime						type_YOrN					NULL
										CHECK (OrientationTime in('Y','N')),	
	OrientationSituation				type_YOrN					NULL
										CHECK (OrientationSituation in('Y','N')),	
	FundOfKnowledge						char(1)	NULL
										CHECK (FundOfKnowledge in ('A','N','W')),
	FundOfKnowledgeCurrentEvents		type_YOrN					NULL
										CHECK (FundOfKnowledgeCurrentEvents in('Y','N')),	
	FundOfKnowledgePastHistory			type_YOrN					NULL
										CHECK (FundOfKnowledgePastHistory in('Y','N')),	
	FundOfKnowledgeVocabulary			type_YOrN					NULL
										CHECK (FundOfKnowledgeVocabulary in('Y','N')),	
	InsightAndJudgement					char(1)						NULL
										CHECK (InsightAndJudgement in ('A','N')),
	InsightAndJudgementStatus			char(1)						NULL
										CHECK (InsightAndJudgementStatus in ('E','G','F','P','R')),
	InsightAndJudgementSubstance		type_YOrN					NULL
										CHECK (InsightAndJudgementSubstance in('Y','N')),	
	Memory								char(1)						NULL
										CHECK (Memory in ('A','N','W')),
	MemoryImmediate						char(1)						NULL
										CHECK (MemoryImmediate in ('F','I')),
	MemoryRecent						char(1)						NULL
										CHECK (MemoryRecent in ('F','I')),
	MemoryRemote						char(1)						NULL
										CHECK (MemoryRemote in ('F','I')),
	MuscleStrengthorTone				char(1)						NULL
										CHECK (MuscleStrengthorTone in ('A','N','W')),
	MuscleStrengthorToneAtrophy			type_YOrN					NULL
										CHECK (MuscleStrengthorToneAtrophy in('Y','N')),	
	MuscleStrengthorToneAbnormal		type_YOrN					NULL
										CHECK (MuscleStrengthorToneAbnormal in('Y','N')),	
	GaitandStation						char(1)						NULL
										CHECK (GaitandStation in ('A','N','W')),
	GaitandStationRestlessness			type_YOrN					NULL
										CHECK (GaitandStationRestlessness in('Y','N')),	
	GaitandStationStaggered				type_YOrN					NULL
										CHECK (GaitandStationStaggered in('Y','N')),	
	GaitandStationShuffling				type_YOrN					NULL
										CHECK (GaitandStationShuffling in('Y','N')),	
	GaitandStationUnstable				type_YOrN					NULL
										CHECK (GaitandStationUnstable in('Y','N')),	
	MentalStatusComments				type_Comment2 NULL,
	GeneralAppearanceOthers				type_YOrN					NULL
										CHECK (GeneralAppearanceOthers in('Y','N')),	
	GeneralAppearanceOtherComments		type_Comment2 NULL,
	SpeechOthers						type_YOrN					NULL
										CHECK (SpeechOthers in('Y','N')),	
	SpeechOtherComments					type_Comment2 NULL,
	LanguageOthers						type_YOrN					NULL
										CHECK (LanguageOthers in('Y','N')),	
	LanguageOtherComments				type_Comment2 NULL,
	MoodOthers							type_YOrN					NULL
										CHECK (MoodOthers in('Y','N')),	
	MoodOtherComments					type_Comment2 NULL,
	AffectOthers						type_YOrN					NULL
										CHECK (AffectOthers in('Y','N')),	
	AffectOtherComments					type_Comment2 NULL,
	AttentionSpanOthers					type_YOrN					NULL
										CHECK (AttentionSpanOthers in('Y','N')),	
	AttentionSpanOtherComments			type_Comment2 NULL,
	ThoughtProcessOthers				type_YOrN					NULL
										CHECK (ThoughtProcessOthers in('Y','N')),	
	ThoughtProcessOtherComments			type_Comment2 NULL,
	ThoughtContentOthers				type_YOrN					NULL
										CHECK (ThoughtContentOthers in('Y','N')),	
	ThoughtContentOtherComments			type_Comment2 NULL,
	CognitiveAbnormalitiesOthers		type_YOrN					NULL
										CHECK (CognitiveAbnormalitiesOthers in('Y','N')),	
	CognitiveAbnormalitiesOtherComments	type_Comment2 NULL,
	AssociationsOthers					type_YOrN					NULL
										CHECK (AssociationsOthers in('Y','N')),	
	AssociationsOtherComments			type_Comment2 NULL,
	AbnormalPsychoticOthers				type_YOrN					NULL
										CHECK (AbnormalPsychoticOthers in('Y','N')),	
	AbnormalPsychoticOthersComments		type_Comment2 NULL,
	OrientationOthers					type_YOrN					NULL
										CHECK (OrientationOthers in('Y','N')),	
	OrientationOtherComments			type_Comment2 NULL,
	FundOfKnowledgeOthers				type_YOrN					NULL
										CHECK (FundOfKnowledgeOthers in('Y','N')),	
	FundOfKnowledgeOtherComments		type_Comment2 NULL,
	InsightAndJudgementOthers			type_YOrN					NULL
										CHECK (InsightAndJudgementOthers in('Y','N')),	
	InsightAndJudgementOtherComments	type_Comment2 NULL,
	MemoryOthers						type_YOrN					NULL
										CHECK (MemoryOthers in('Y','N')),	
	MemoryOtherComments					type_Comment2 NULL,
	MuscleStrengthOthers				type_YOrN					NULL
										CHECK (MuscleStrengthOthers in('Y','N')),	
	MuscleStrengthOtherComments			type_Comment2 NULL,
	GaitAndStationOthers				type_YOrN					NULL
										CHECK (GaitAndStationOthers in('Y','N')),	
	GaitAndStationOtherComments			type_Comment2 NULL,
    CONSTRAINT CustomDocumentPsychiatricNoteExams_PK PRIMARY KEY CLUSTERED (DocumentVersionId)		 	
)
 IF OBJECT_ID('CustomDocumentPsychiatricNoteExams') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentPsychiatricNoteExams >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentPsychiatricNoteExams >>>', 16, 1)
/*  
 * TABLE: CustomDocumentPsychiatricNoteExams 
 */ 

 ALTER TABLE CustomDocumentPsychiatricNoteExams ADD CONSTRAINT DocumentVersions_CustomDocumentPsychiatricNoteExams_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
   EXEC sys.sp_addextendedproperty 'CustomDocumentPsychiatricNoteExams_Description'
	,'GeneralAppearance column stores A,N,G. A- Assessed , N- Not Assessed, G-Appropriately dressed and groomed for the occasion'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentPsychiatricNoteExams'
	,'column'
	,'GeneralAppearance'
    
PRINT 'STEP 4(D) COMPLETED'
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentPsychiatricNoteMDMs')
 BEGIN
/* 
 * TABLE: CustomDocumentPsychiatricNoteMDMs 
 */

CREATE TABLE CustomDocumentPsychiatricNoteMDMs(
    DocumentVersionId					int							NOT NULL,
    CreatedBy							type_CurrentUser			NOT NULL,
    CreatedDate							type_CurrentDatetime		NOT NULL,
    ModifiedBy							type_CurrentUser			NOT NULL,
    ModifiedDate						type_CurrentDatetime		NOT NULL,
    RecordDeleted						type_YOrN					NULL
										CHECK (RecordDeleted in('Y','N')),
    DeletedBy							type_UserId					NULL,
    DeletedDate							datetime					NULL,				
    MedicalRecords 						type_YOrN					NULL
										CHECK (MedicalRecords in('Y','N')),
	CollaborationOfCare					type_YOrN					NULL
										CHECK (CollaborationOfCare in('Y','N')),
	DiagnosticTest  					type_YOrN					NULL
										CHECK (DiagnosticTest in('Y','N')),
	Labs 								type_YOrN					NULL
										CHECK (Labs in('Y','N')),
	Other								type_YOrN					NULL
										CHECK (Other in	('Y','N')),
	LabsSelected						int							NULL,
	MedicalRecordsComments  			type_Comment2				NULL,
	OrderedMedications 					type_YOrN					NULL
										CHECK (OrderedMedications in('Y','N')),
	MedicationsReviewed					type_YOrN					NULL
										CHECK (MedicationsReviewed in('Y','N')),
	RisksBenefits 						type_YOrNOrNA				NULL
										CHECK (RisksBenefits in('Y','N','A')),
	NewlyEmergentSideEffects 			type_YOrN					NULL
										CHECK (NewlyEmergentSideEffects in('Y','N')),
	LabOrder 							type_YOrN					NULL
										CHECK (LabOrder in	('Y','N')),
	EKG									type_YOrN					NULL
										CHECK (EKG in	('Y','N')),
	RadiologyOrder						type_YOrN					NULL
										CHECK (RadiologyOrder in('Y','N')),
	Consultations 						type_YOrN					NULL
										CHECK (Consultations in	('Y','N')),
	OrdersComments 						type_Comment2				NULL,
	LabsLastOrder						type_Comment2				NULL,
	PlanLastVisitMDM					type_Comment2				NULL,
	PlanComment							type_Comment2				NULL,
	NextPhysicianVisit					type_Comment2				NULL,
	PatientConsent						type_YOrN					NULL
										CHECK (PatientConsent in('Y','N')),
	MoreThanFifty						type_YOrN					NULL
										CHECK (MoreThanFifty in	('Y','N')),
	InformationAndEducation				type_Comment2				NULL,
	NurseMonitorPillBox					type_YOrN					NULL
										CHECK (NurseMonitorPillBox in('Y','N')),	
	NurseMonitorFrequency				type_GlobalCode				NULL,
	NurseMonitorComment					type_Comment2				NULL,	
	DecisionMakingSchizophrenia			type_Comment2				NULL,
	DecisionMakingSchizophreniaStatus	type_GlobalCode				NULL,	
	DecisionMakingAnxiety				type_Comment2				NULL,
	DecisionMakingAnxietyStatus			type_GlobalCode				NULL,	
	DecisionMakingWeightLoss			type_Comment2				NULL,
	DecisionMakingWeightLossStatus		type_GlobalCode				NULL,
	DecisionMakingInsomnia				type_Comment2				NULL,
	DecisionMakingInsomniaStatus		type_GlobalCode				NULL,
	MedicationsDiscontinued 			type_Comment2				NULL,
	NurseMonitorFrequencyOther			type_Comment2				NULL,
	RisksBenefitscomment				type_Comment2				NULL,
	MedicalRecordsRelevantResults		type_Comment2				NULL,
	MedicalRecordsLabsOrderedLastvisit	type_Comment2				NULL,
	MedicalRecordsPreviousResults		type_Comment2				NULL,
	ReviewClinicalLabs					type_YOrN					NULL
										CHECK (ReviewClinicalLabs in ('Y','N')),
	ReviewRadiologyTest					type_YOrN					NULL
										CHECK (ReviewRadiologyTest in ('Y','N')),
	ReviewOtherTest						type_YOrN					NULL
										CHECK (ReviewOtherTest in ('Y','N')),
	DiscussionOfTestResults				type_YOrN					NULL
										CHECK (DiscussionOfTestResults in ('Y','N')),
	DecisionToObtainByOthers			type_YOrN					NULL
										CHECK (DecisionToObtainByOthers in ('Y','N')),
	ReviewSummarizedOldRecords			type_YOrN					NULL
										CHECK (ReviewSummarizedOldRecords in ('Y','N')),
	IndependentVisualization			type_YOrN					NULL
										CHECK (IndependentVisualization in ('Y','N')),
	LevelOfRisk							char(1)						NULL
										CHECK (LevelOfRisk in ('M','L','O','H')),
	MedicationReconciliation			type_YOrN					NULL
										CHECK (MedicationReconciliation in ('Y','N')) ,
    CONSTRAINT CustomDocumentPsychiatricNoteMDMs_PK PRIMARY KEY CLUSTERED (DocumentVersionId)		 	
)
 IF OBJECT_ID('CustomDocumentPsychiatricNoteMDMs') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentPsychiatricNoteMDMs >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentPsychiatricNoteMDMs >>>', 16, 1)
/*  
 * TABLE: CustomDocumentPsychiatricNoteMDMs 
 */ 

 ALTER TABLE CustomDocumentPsychiatricNoteMDMs ADD CONSTRAINT DocumentVersions_CustomDocumentPsychiatricNoteMDMs_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
    EXEC sys.sp_addextendedproperty 'CustomDocumentPsychiatricNoteMDMs_Description'
	,'LevelOfRisk column stores M,L,O,H.  M- Minimal, L-Low, O– Moderate,H-High'
	,'schema'
	,'dbo'
	,'table'
	,'CustomDocumentPsychiatricNoteMDMs'
	,'column'
	,'LevelOfRisk' 
    
PRINT 'STEP 4(E) COMPLETED'
END


IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentPsychiatricAIMSs')
 BEGIN
/* 
 * TABLE: CustomDocumentPsychiatricAIMSs 
 */

CREATE TABLE CustomDocumentPsychiatricAIMSs(
    DocumentVersionId					int							NOT NULL,
    CreatedBy							type_CurrentUser			NOT NULL,
    CreatedDate							type_CurrentDatetime		NOT NULL,
    ModifiedBy							type_CurrentUser			NOT NULL,
    ModifiedDate						type_CurrentDatetime		NOT NULL,
    RecordDeleted						type_YOrN					NULL
										CHECK (RecordDeleted in('Y','N')),
    DeletedBy							type_UserId					NULL,
    DeletedDate							datetime					NULL,
    MuscleFacialExpression				type_GlobalCode				NULL,
	LipsPerioralArea					type_GlobalCode				NULL,
	Jaw									type_GlobalCode				NULL,
	Tongue								type_GlobalCode				NULL,
	ExtremityMovementsUpper				type_GlobalCode				NULL,
	ExtremityMovementsLower				type_GlobalCode				NULL,
	NeckShouldersHips					type_GlobalCode				NULL,
	SeverityAbnormalMovements			type_GlobalCode				NULL,
	IncapacitationAbnormalMovements		type_GlobalCode				NULL,
	PatientAwarenessAbnormalMovements	type_GlobalCode				NULL,
	CurrentProblemsTeeth				type_YOrN					NULL
										CHECK (CurrentProblemsTeeth in	('Y','N')),			
	DoesPatientWearDentures				type_YOrN					NULL
										CHECK (DoesPatientWearDentures in	('Y','N')),
	AIMSTotalScore						int							NULL,
	AIMSPositveNegative					char(1)						NULL
										CHECK (AIMSPositveNegative in ('P','N')) ,
	SetDeafultForMovements				type_YOrN					NULL
										CHECK (SetDeafultForMovements in ('Y','N')) ,
    AIMSComments						type_Comment2				NULL,									
	CONSTRAINT CustomDocumentPsychiatricAIMSs_PK PRIMARY KEY CLUSTERED (DocumentVersionId)		 	
)
 IF OBJECT_ID('CustomDocumentPsychiatricAIMSs') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentPsychiatricAIMSs >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentPsychiatricAIMSs >>>', 16, 1)
/*  
 * TABLE: CustomDocumentPsychiatricAIMSs 
 */ 

 ALTER TABLE CustomDocumentPsychiatricAIMSs ADD CONSTRAINT DocumentVersions_CustomDocumentPsychiatricAIMSs_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
PRINT 'STEP 4(F) COMPLETED'
END


IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentPsychiatricNoteChildAdolescents')
 BEGIN
/*  
 * TABLE: CustomDocumentPsychiatricNoteChildAdolescents 
 */

CREATE TABLE CustomDocumentPsychiatricNoteChildAdolescents(
    DocumentVersionId					int							NOT NULL,
    CreatedBy							type_CurrentUser			NOT NULL,
    CreatedDate							type_CurrentDatetime		NOT NULL,
    ModifiedBy							type_CurrentUser			NOT NULL,
    ModifiedDate						type_CurrentDatetime		NOT NULL,
    RecordDeleted						type_YOrN					NULL
										CHECK (RecordDeleted in('Y','N')),
    DeletedBy							type_UserId					NULL,
    DeletedDate							datetime					NULL,
    ProblemsLabors						type_YesNoUnknown			NULL
										CHECK (ProblemsLabors in('N','Y','U')),								
	ProblemsPregnancy					type_YesNoUnknown			NULL
										CHECK (ProblemsPregnancy in('N','Y','U')),
	PrenatalExposure					type_YesNoUnknown			NULL
										CHECK (PrenatalExposure in('N','Y','U')),
	CurrentHealthIssues					type_YesNoUnknown			NULL
										CHECK (CurrentHealthIssues in('N','Y','U')),
	ChildDevlopmental					type_YesNoUnknown			NULL
										CHECK (ChildDevlopmental in('N','Y','U')),
	SexualityIssues						type_YesNoUnknown			NULL
										CHECK (SexualityIssues in('N','Y','U')),
	CurrentImmunizations				type_YesNoUnknown			NULL
										CHECK (CurrentImmunizations in('N','Y','U')),
	HealthFunctioningComment			type_Comment2				NULL,
	FunctioningLanguage					type_YesNoUnknown			NULL
										CHECK (FunctioningLanguage in('N','Y','U')),
	FunctioningVisual					type_YesNoUnknown			NULL
										CHECK (FunctioningVisual in('N','Y','U')),
	FunctioningIntellectual				type_YesNoUnknown			NULL
										CHECK (FunctioningIntellectual in('N','Y','U')),
	FunctioningLearning					type_YesNoUnknown			NULL
										CHECK (FunctioningLearning in('N','Y','U')),
	AreasOfConcernComment				type_Comment2				NULL,
	FamilyMentalHealth					type_YesNoUnknown			NULL
										CHECK (FamilyMentalHealth in ('N','Y','U')),
	FamilyCurrentHousingIssues			type_YesNoUnknown			NULL
										CHECK (FamilyCurrentHousingIssues in ('N','Y','U')),
	FamilyParticipate					type_YesNoUnknown			NULL
										CHECK (FamilyParticipate in('N','Y','U')),
	ChildAbuse							type_YesNoUnknown			NULL
										CHECK (ChildAbuse in('N','Y','U')),
	FamilyDynamicsComment				type_Comment2				NULL,
    CONSTRAINT CustomDocumentPsychiatricNoteChildAdolescents_PK PRIMARY KEY CLUSTERED (DocumentVersionId)		 	
)
 IF OBJECT_ID('CustomDocumentPsychiatricNoteChildAdolescents') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentPsychiatricNoteChildAdolescents >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentPsychiatricNoteChildAdolescents >>>', 16, 1)
/*  
 * TABLE: CustomDocumentPsychiatricNoteChildAdolescents 
 */ 

 ALTER TABLE CustomDocumentPsychiatricNoteChildAdolescents ADD CONSTRAINT DocumentVersions_CustomDocumentPsychiatricNoteChildAdolescents_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
PRINT 'STEP 4(G) COMPLETED'
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomPsychiatricNoteMedications')
BEGIN
/*  
 * TABLE: CustomPsychiatricNoteMedications 
 */ 
CREATE TABLE CustomPsychiatricNoteMedications(
		PsychiatricNoteMedicationId						int identity(1,1)			NOT NULL,
		CreatedBy										type_CurrentUser			NOT NULL,
		CreatedDate										type_CurrentDatetime		NOT NULL,
		ModifiedBy										type_CurrentUser			NOT NULL,
		ModifiedDate									type_CurrentDatetime		NOT NULL,
		RecordDeleted									type_YOrN					NULL
														CHECK (RecordDeleted in ('Y','N')),
		DeletedBy										type_UserId					NULL,
		DeletedDate										datetime					NULL,
		DocumentVersionId								int							NULL,
		MedicationName									varchar(100)				NULL,
		PrescriberName									varchar(100)				NULL,
		MedicationSource								varchar(250)				NULL,
		MedicationStartDate								datetime					NULL,
		MedicationEndDate								datetime					NULL,
		Script											varchar(100)				NULL,
		Instructions									varchar(max)				NULL,
		Direction										varchar(100)				NULL,
		Quantity										varchar(100)				NULL,
		Refills											varchar(100)				NULL,
		Flag											char(1)						NULL
														CHECK (Flag in ('C','N','D')),
		CONSTRAINT CustomPsychiatricNoteMedications_PK PRIMARY KEY CLUSTERED (PsychiatricNoteMedicationId)		 	
)
 IF OBJECT_ID('CustomPsychiatricNoteMedications') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomPsychiatricNoteMedications >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomPsychiatricNoteMedications >>>', 16, 1)
    
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('CustomPsychiatricNoteMedications') AND name='XIE1_CustomPsychiatricNoteMedications')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_CustomPsychiatricNoteMedications] ON [dbo].[CustomPsychiatricNoteMedications] 
		(DocumentVersionId ASC)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomPsychiatricNoteMedications') AND name='XIE1_CustomPsychiatricNoteMedications')
		PRINT '<<< CREATED INDEX CustomPsychiatricNoteMedications.XIE1_CustomPsychiatricNoteMedications >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CustomPsychiatricNoteMedications.XIE1_CustomPsychiatricNoteMedications >>>', 16, 1)		
	END		
	
/* 
 * TABLE: CustomPsychiatricNoteMedications 
 */ 

ALTER TABLE CustomPsychiatricNoteMedications ADD CONSTRAINT DocumentVersions_CustomPsychiatricNoteMedications_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)           
    
PRINT 'STEP 4(H) COMPLETED'
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomPsychiatricNoteSubstanceUses')
 BEGIN
/* 
 * TABLE: CustomPsychiatricNoteSubstanceUses 
 */

CREATE TABLE CustomPsychiatricNoteSubstanceUses(
    PsychiatricNoteSubstanceUseId		int identity(1,1)			NOT NULL,
    CreatedBy							type_CurrentUser			NOT NULL,
    CreatedDate							type_CurrentDatetime		NOT NULL,
    ModifiedBy							type_CurrentUser			NOT NULL,
    ModifiedDate						type_CurrentDatetime		NOT NULL,
    RecordDeleted						type_YOrN					NULL
										CHECK (RecordDeleted in	('Y','N')),
    DeletedBy							type_UserId					NULL,
    DeletedDate							datetime					NULL,
    DocumentVersionId					int							NULL,
    DocumentDiagnosisCodeId				int							NULL,
    SubstanceUseName					varchar(250)				NULL,
    CONSTRAINT CustomPsychiatricNoteSubstanceUses_PK PRIMARY KEY CLUSTERED (PsychiatricNoteSubstanceUseId)		 	
)
 IF OBJECT_ID('CustomPsychiatricNoteSubstanceUses') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomPsychiatricNoteSubstanceUses >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomPsychiatricNoteSubstanceUses >>>', 16, 1)
    
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('CustomPsychiatricNoteSubstanceUses') AND name='XIE1_CustomPsychiatricNoteSubstanceUses')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_CustomPsychiatricNoteSubstanceUses] ON [dbo].[CustomPsychiatricNoteSubstanceUses] 
		(
		DocumentVersionId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomPsychiatricNoteSubstanceUses') AND name='XIE1_CustomPsychiatricNoteSubstanceUses')
		PRINT '<<< CREATED INDEX CustomPsychiatricNoteSubstanceUses.XIE1_CustomPsychiatricNoteSubstanceUses >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CustomPsychiatricNoteSubstanceUses.XIE1_CustomPsychiatricNoteSubstanceUses >>>', 16, 1)		
	END		
	
	
	
/*  
 * TABLE: CustomPsychiatricNoteSubstanceUses 
 */ 

 ALTER TABLE CustomPsychiatricNoteSubstanceUses ADD CONSTRAINT DocumentVersions_CustomPsychiatricNoteSubstanceUses_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
 
PRINT 'STEP 4(I) COMPLETED'
END	

	
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomPsychiatricNoteMedicationHistory')
BEGIN
/*  
 * TABLE: CustomPsychiatricNoteMedicationHistory 
 */ 
CREATE TABLE CustomPsychiatricNoteMedicationHistory(
		PsychiatricNoteMedicationHistoryId				int identity(1,1)			NOT NULL,
		CreatedBy										type_CurrentUser			NOT NULL,
		CreatedDate										type_CurrentDatetime		NOT NULL,
		ModifiedBy										type_CurrentUser			NOT NULL,
		ModifiedDate									type_CurrentDatetime		NOT NULL,
		RecordDeleted									type_YOrN					NULL
														CHECK (RecordDeleted in ('Y','N')),
		DeletedBy										type_UserId					NULL,
		DeletedDate										datetime					NULL,
		DocumentVersionId								int							NULL,
		ClientMedicationId								int							NULL,
		MedicalStatus									char(1)						NULL
														CHECK (MedicalStatus in ('C','N','D','S')),
		CONSTRAINT CustomPsychiatricNoteMedicationHistory_PK PRIMARY KEY CLUSTERED (PsychiatricNoteMedicationHistoryId)		 	
)
 IF OBJECT_ID('CustomPsychiatricNoteMedicationHistory') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomPsychiatricNoteMedicationHistory >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomPsychiatricNoteMedicationHistory >>>', 16, 1)
    
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('CustomPsychiatricNoteMedicationHistory') AND name='XIE1_CustomPsychiatricNoteMedicationHistory')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_CustomPsychiatricNoteMedicationHistory] ON [dbo].[CustomPsychiatricNoteMedicationHistory] 
		(DocumentVersionId ASC)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomPsychiatricNoteMedicationHistory') AND name='XIE1_CustomPsychiatricNoteMedicationHistory')
		PRINT '<<< CREATED INDEX CustomPsychiatricNoteMedicationHistory.XIE1_CustomPsychiatricNoteMedicationHistory >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CustomPsychiatricNoteMedicationHistory.XIE1_CustomPsychiatricNoteMedicationHistory >>>', 16, 1)		
	END	
	
    
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('CustomPsychiatricNoteMedicationHistory') AND name='XIE2_CustomPsychiatricNoteMedicationHistory')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_CustomPsychiatricNoteMedicationHistory] ON [dbo].[CustomPsychiatricNoteMedicationHistory] 
		(ClientMedicationId ASC)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomPsychiatricNoteMedicationHistory') AND name='XIE2_CustomPsychiatricNoteMedicationHistory')
		PRINT '<<< CREATED INDEX CustomPsychiatricNoteMedicationHistory.XIE2_CustomPsychiatricNoteMedicationHistory >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CustomPsychiatricNoteMedicationHistory.XIE2_CustomPsychiatricNoteMedicationHistory >>>', 16, 1)		
	END		
		
	
/* 
 * TABLE: CustomPsychiatricNoteMedicationHistory 
 */ 

ALTER TABLE CustomPsychiatricNoteMedicationHistory ADD CONSTRAINT DocumentVersions_CustomPsychiatricNoteMedicationHistory_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)   
    
ALTER TABLE CustomPsychiatricNoteMedicationHistory ADD CONSTRAINT ClientMedications_CustomPsychiatricNoteMedicationHistory_FK 
    FOREIGN KEY (ClientMedicationId)
    REFERENCES ClientMedications(ClientMedicationId)    
    
    
 EXEC sys.sp_addextendedproperty 'CustomPsychiatricNoteMedicationHistory_Description'
	,'MedicalStatus field stores C,N,M,S .C-Current Medications, N-Not Ordered by,M-Medications Discontinued ,S-Self Reported '
	,'schema'
	,'dbo'
	,'table'
	,'CustomPsychiatricNoteMedicationHistory'
	,'column'
	,'MedicalStatus'        
    
PRINT 'STEP 4(J) COMPLETED'
END
---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
IF NOT EXISTS (SELECT [key] FROM SystemConfigurationKeys WHERE [key] = 'CDM_PsychiatricNote')
	BEGIN
		INSERT INTO [dbo].[SystemConfigurationKeys]
				   (CreatedBy
				   ,CreateDate 
				   ,ModifiedBy
				   ,ModifiedDate
				   ,[Key]
				   ,Value
				   )
			 VALUES    
				   ('SHSDBA'
				   ,GETDATE()
				   ,'SHSDBA'
				   ,GETDATE()
				   ,'CDM_PsychiatricNote'
				   ,'1.0'
				   )         
			PRINT 'STEP 7 COMPLETED'
	END
Go