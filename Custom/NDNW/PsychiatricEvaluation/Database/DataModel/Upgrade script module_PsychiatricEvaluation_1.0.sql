----- STEP 1 ----------

----- End of STEP 1 ----------

------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------

------ END OF STEP 3 -----

------ STEP 4 ----------

IF Not EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentPsychiatricEvaluations')
 BEGIN
/* 
 * TABLE: CustomDocumentPsychiatricEvaluations 
 */
CREATE TABLE CustomDocumentPsychiatricEvaluations(
		DocumentVersionId 						   int						 NOT NULL,
		CreatedBy                                  type_CurrentUser          NOT NULL,
		CreatedDate                                type_CurrentDatetime      NOT NULL,
		ModifiedBy                                 type_CurrentUser          NOT NULL,
		ModifiedDate                               type_CurrentDatetime      NOT NULL,
		RecordDeleted                              type_YOrN                 NULL
												   CHECK (RecordDeleted in ('N','Y')),
		DeletedBy                                  type_UserId               NULL,
		DeletedDate                                datetime					  NULL,
		NotifyStaff1								int						  NULL,
		NotifyStaff2								int                       NULL,
		NotifyStaff3								int						  NULL,
		NextPsychiatricAppointment					type_Comment2			  NULL,
		SummaryAndRecommendations					type_Comment2			  NULL,
		MedicationListAtTheTimeOfTransition			type_Comment2			  NULL,
		IdentifyingInformation						type_Comment2			  NULL,
		FamilyHistory								type_Comment2			  NULL,
		PastPsychiatricHistory						type_Comment2			  NULL,
		DevelopmentalHistory						type_Comment2			  NULL,
		SubstanceAbuseHistory						type_Comment2			  NULL,
		MedicalHistory								type_Comment2			  NULL,
		HistoryofPresentIllness						type_Comment2			  NULL,
		SocialHistory								type_Comment2			  NULL,
		ReviewOfSystemPsych							type_YOrN                 NULL
													CHECK (ReviewOfSystemPsych in ('N','Y')),
		ReviewOfSystemSomaticConcerns				type_YOrN                 NULL
													CHECK (ReviewOfSystemSomaticConcerns in ('N','Y')),
		ReviewOfSystemConstitutional				type_YOrN                 NULL
													CHECK (ReviewOfSystemConstitutional in ('N','Y')),
		ReviewOfSystemEarNoseMouthThroat			type_YOrN                 NULL
													CHECK (ReviewOfSystemEarNoseMouthThroat in ('N','Y')),
		ReviewOfSystemGI							type_YOrN                 NULL
													CHECK (ReviewOfSystemGI in ('N','Y')),
		ReviewOfSystemGU							type_YOrN                 NULL
													CHECK (ReviewOfSystemGU in ('N','Y')),
		ReviewOfSystemIntegumentary					type_YOrN                 NULL
													CHECK (ReviewOfSystemIntegumentary in ('N','Y')),
		ReviewOfSystemEndo							type_YOrN                 NULL
													CHECK (ReviewOfSystemEndo in ('N','Y')),
		ReviewOfSystemNeuro							type_YOrN                 NULL
													CHECK (ReviewOfSystemNeuro in ('N','Y')),
		ReviewOfSystemImmune						type_YOrN                 NULL
													CHECK (ReviewOfSystemImmune in ('N','Y')),	
		ReviewOfSystemEyes							type_YOrN                 NULL
													CHECK (ReviewOfSystemEyes in ('N','Y')),
		ReviewOfSystemResp							type_YOrN                 NULL
													CHECK (ReviewOfSystemResp in ('N','Y')),
		ReviewOfSystemCardioVascular				type_YOrN                 NULL
													CHECK (ReviewOfSystemCardioVascular in ('N','Y')),
		ReviewOfSystemHemLymph						type_YOrN                 NULL
													CHECK (ReviewOfSystemHemLymph in ('N','Y')),
		ReviewOfSystemMusculo						type_YOrN                 NULL
													CHECK (ReviewOfSystemMusculo in ('N','Y')),
		ReviewOfSystemAllOthersNegative				type_YOrN                 NULL
													CHECK (ReviewOfSystemAllOthersNegative in ('N','Y')),
		ReviewOfSystemComments						type_Comment2			  NULL,
		AppropriatelyDressed						type_YOrN                 NULL
													CHECK (AppropriatelyDressed in ('N','Y')),
		GeneralAppearanceUnkept						type_YOrN                 NULL
													CHECK (GeneralAppearanceUnkept in ('N','Y')),
		GeneralAppearanceOther						type_YOrN                 NULL
													CHECK (GeneralAppearanceOther in ('N','Y')),
		GeneralAppearanceOtherText					type_Comment2			  NULL,
		MuscleStrengthNormal						type_YOrN                 NULL
													CHECK (MuscleStrengthNormal in ('N','Y')),
		MuscleStrengthAbnormal						type_YOrN                 NULL
													CHECK (MuscleStrengthAbnormal in ('N','Y')),
		MusculoskeletalTone							type_YOrN                 NULL
													CHECK (MusculoskeletalTone in ('N','Y')),
		GaitNormal									type_YOrN                 NULL
													CHECK (GaitNormal in ('N','Y')),
		GaitAbnormal								type_YOrN                 NULL
													CHECK (GaitAbnormal in ('N','Y')),
		TicsTremorsAbnormalMovements				type_YOrN                 NULL
													CHECK (TicsTremorsAbnormalMovements in ('N','Y')),
		EPS											type_YOrN                 NULL
													CHECK (EPS in ('N','Y')),
		Suicidal									type_YOrN                 NULL
													CHECK (Suicidal in ('N','Y')),
		Homicidal									type_YOrN                 NULL
													CHECK (Homicidal in ('N','Y')),
		IndicateIdeation							type_Comment2			  NULL,	
		AppearanceBehavior							type_YOrN                 NULL
													CHECK (AppearanceBehavior in ('N','Y')),
		AppearanceBehaviorComments					type_Comment2			  NULL,
		Speech										type_YOrN                 NULL
													CHECK (Speech in ('N','Y')),
		SpeechComments								type_Comment2			  NULL,
		ThoughtProcess								type_YOrN                 NULL
													CHECK (ThoughtProcess in ('N','Y')),
		ThoughtProcessComments						type_Comment2			  NULL,
		Associations								type_YOrN                 NULL
													CHECK (Associations in ('N','Y')),
		AssociationsComments						type_Comment2			  NULL,
		AbnormalPsychoticThoughts					type_YOrN                 NULL
													CHECK (AbnormalPsychoticThoughts in ('N','Y')),
		AbnormalPsychoticThoughtsComments			type_Comment2			  NULL,
		JudgmentAndInsight							type_YOrN                 NULL
													CHECK (JudgmentAndInsight in ('N','Y')),
		JudgmentAndInsightComments					type_Comment2			  NULL,
		Orientation									type_YOrN                 NULL
													CHECK (Orientation in ('N','Y')),
		OrientationComments							type_Comment2			  NULL,
		RecentRemoteMemory							type_YOrN                 NULL
													CHECK (RecentRemoteMemory in ('N','Y')),
		RecentRemoteMemoryComments					type_Comment2			  NULL,
		AttentionConcentration						type_YOrN                 NULL
													CHECK (AttentionConcentration in ('N','Y')),
		AttentionConcentrationComments				type_Comment2			  NULL,
		[Language]									type_YOrN                 NULL
													CHECK ([Language] in ('N','Y')),
		LanguageCommments							type_Comment2			  NULL,
		FundOfKnowledge								type_YOrN                 NULL
													CHECK (FundOfKnowledge in ('N','Y')),
		FundOfKnowledgeComments						type_Comment2			  NULL,
		MoodAndAffect								type_YOrN                 NULL
													CHECK (MoodAndAffect in ('N','Y')),
		MoodAndAffectComments						type_Comment2			  NULL,
		MedicalRecords								type_YOrN                 NULL
													CHECK (MedicalRecords in ('N','Y')),
		DiagnosticTest								type_YOrN                 NULL
													CHECK (DiagnosticTest in ('N','Y')),
		Labs										type_YOrN                 NULL
													CHECK (Labs in ('N','Y')),
		LabsSelected								int						  NULL,
		MedicalRecordsComments						type_Comment2			  NULL,
		OrderedMedications							type_YOrN                 NULL
													CHECK (OrderedMedications in ('N','Y')),
		RisksBenefits								type_YOrN                 NULL
													CHECK (RisksBenefits in ('N','Y')),
		NewlyEmergentSideEffects					type_YOrN                 NULL
													CHECK (NewlyEmergentSideEffects in ('N','Y')),
		LabOrder									type_YOrN                 NULL
													CHECK (LabOrder in ('N','Y')),
		RadiologyOrder								type_YOrN                 NULL
													CHECK (RadiologyOrder in ('N','Y')),
		Consultations								type_YOrN                 NULL
													CHECK (Consultations in ('N','Y')),
		OrdersComments								type_Comment2			  NULL,
	CONSTRAINT CustomDocumentPsychiatricEvaluations_PK PRIMARY KEY CLUSTERED (DocumentVersionId)
)

  IF OBJECT_ID('CustomDocumentPsychiatricEvaluations') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentPsychiatricEvaluations >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentPsychiatricEvaluations >>>', 16, 1)
/* 
 * TABLE: CustomDocumentPsychiatricEvaluations 
 */   
    
ALTER TABLE CustomDocumentPsychiatricEvaluations ADD CONSTRAINT DocumentVersions_CustomDocumentPsychiatricEvaluations_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
ALTER TABLE CustomDocumentPsychiatricEvaluations ADD CONSTRAINT Staff_CustomDocumentPsychiatricEvaluations_FK
    FOREIGN KEY (NotifyStaff1)
    REFERENCES Staff(StaffId)

ALTER TABLE CustomDocumentPsychiatricEvaluations ADD CONSTRAINT Staff_CustomDocumentPsychiatricEvaluations_FK1
    FOREIGN KEY (NotifyStaff2)
    REFERENCES Staff(StaffId)     

ALTER TABLE CustomDocumentPsychiatricEvaluations ADD CONSTRAINT Staff_CustomDocumentPsychiatricEvaluations_FK2
    FOREIGN KEY (NotifyStaff3)
    REFERENCES Staff(StaffId)              

     PRINT 'STEP 4(A) COMPLETED'
 END
 
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomPsychiatricEvaluationProblems')
BEGIN
/* 
 * TABLE: CustomPsychiatricEvaluationProblems 
 */
 CREATE TABLE CustomPsychiatricEvaluationProblems( 
		PsychiatricEvaluationProblemId			int	 identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		DocumentVersionId						int					 NULL,
		ProblemText								type_Comment2		 NULL,
		Severity								type_GlobalCode		 NULL,
		Duration								type_GlobalCode		 NULL,
		Intensity								type_GlobalCode		 NULL,
		TimeOfDayMorning						type_YOrN			 NULL
												CHECK (TimeOfDayMorning in ('Y','N')),
		TimeOfDayNoon							type_YOrN			 NULL
												CHECK (TimeOfDayNoon in ('Y','N')),
		TimeOfDayAfternoon						type_YOrN			 NULL
												CHECK (TimeOfDayAfternoon in ('Y','N')),
		TimeOfDayEvening						type_YOrN			 NULL
												CHECK (TimeOfDayEvening in ('Y','N')),
		TimeOfDayNight							type_YOrN			 NULL
												CHECK (TimeOfDayNight in ('Y','N')),
		ContextHome								type_YOrN			 NULL
												CHECK (ContextHome in ('Y','N')),
		ContextSchool							type_YOrN			 NULL
												CHECK (ContextSchool in ('Y','N')),
		ContextWork								type_YOrN			 NULL
												CHECK (ContextWork in ('Y','N')),
		ContextCommunity						type_YOrN			 NULL
												CHECK (ContextCommunity in ('Y','N')),
		ContextOther							type_YOrN			 NULL
												CHECK (ContextOther in ('Y','N')),
		ContextOtherText						type_Comment2		 NULL,
		AssociatedSignsSymptoms					type_GlobalCode		 NULL,
		AssociatedSignsSymptomsOtherText		type_Comment2		 NULL,
		ModifyingFactors						type_Comment2		 NULL,
		ReasonResolved							type_Comment2		 NULL,
		ProblemStatus							type_GlobalCode		 NULL,
		CONSTRAINT CustomPsychiatricEvaluationProblems_PK PRIMARY KEY CLUSTERED (PsychiatricEvaluationProblemId)
)


  IF OBJECT_ID('CustomPsychiatricEvaluationProblems') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomPsychiatricEvaluationProblems >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomPsychiatricEvaluationProblems >>>', 16, 1)
/* 
 * TABLE: CustomPsychiatricEvaluationProblems 
 */   
    
ALTER TABLE CustomPsychiatricEvaluationProblems ADD CONSTRAINT DocumentVersions_CustomPsychiatricEvaluationProblems_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)

     PRINT 'STEP 4(B) COMPLETED'
 END
 
  --END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------


------ STEP 7 -----------








IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomNoteInformations')
BEGIN
/* 
 * TABLE: CustomNoteInformations 
 */
CREATE TABLE CustomNoteInformations(
    CustomInformationId	                 int Identity(1,1)       NOT NULL,
    CreatedBy                            type_CurrentUser        NOT NULL,
    CreatedDate                          type_CurrentDatetime    NOT NULL,
    ModifiedBy                           type_CurrentUser        NOT NULL,
    ModifiedDate                         type_CurrentDatetime    NOT NULL,
    RecordDeleted                        type_YOrN               NULL
                                         CHECK (RecordDeleted in ('Y','N')),
    DeletedDate                          datetime                NULL,
    DeletedBy                            type_UserId             NULL,
    DocumentCodeId                       int                     NULL,
    InformationText                      varchar(50)             NULL,
    InformationToolTipStoredProcedure    varchar(100)            NULL,    
    CONSTRAINT CustomNoteInformations_PK PRIMARY KEY CLUSTERED (CustomInformationId)
)
IF OBJECT_ID('CustomNoteInformations') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomNoteInformations >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomNoteInformations >>>', 16, 1)
/* 
 * TABLE: CustomNoteInformations 
 */
   
   ALTER TABLE CustomNoteInformations ADD CONSTRAINT DocumentCodes_CustomNoteInformations_FK 
    FOREIGN KEY (DocumentCodeId)
    REFERENCES DocumentCodes(DocumentCodeId) 

END



If not exists (select [key] from SystemConfigurationKeys where [key] = 'CDM_PsychiatricEvaluation')
	begin
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
				   ,'CDM_PsychiatricEvaluation'
				   ,'1.0'
				   )
				   PRINT 'STEP 7 COMPLETED' 
	End


 GO
 
		


     