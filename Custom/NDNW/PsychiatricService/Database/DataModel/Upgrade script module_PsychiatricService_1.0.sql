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
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentPsychiatricServiceNoteGenerals')
BEGIN
/* 
 * TABLE: CustomDocumentPsychiatricServiceNoteGenerals 
 */
  CREATE TABLE CustomDocumentPsychiatricServiceNoteGenerals( 
		DocumentVersionId					int					 NOT NULL,
		CreatedBy							type_CurrentUser     NOT NULL,
		CreatedDate							type_CurrentDatetime NOT NULL,
		ModifiedBy							type_CurrentUser     NOT NULL,
		ModifiedDate						type_CurrentDatetime NOT NULL,
		RecordDeleted						type_YOrN			 NULL
											CHECK (RecordDeleted in ('Y','N')),
		DeletedBy							type_UserId          NULL,
		DeletedDate							datetime             NULL,
		NextPsychiatricAppointment  		type_Comment2		 NULL,
		SummaryAndRecommendations  			type_Comment2		 NULL,
		MedicationListAtTheTimeOfTransition type_Comment2		 NULL,
CONSTRAINT CustomDocumentPsychiatricServiceNoteGenerals_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('CustomDocumentPsychiatricServiceNoteGenerals') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentPsychiatricServiceNoteGenerals >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentPsychiatricServiceNoteGenerals >>>', 16, 1)
/* 
 * TABLE: CustomDocumentPsychiatricServiceNoteGenerals 
 */   
    
ALTER TABLE CustomDocumentPsychiatricServiceNoteGenerals ADD CONSTRAINT DocumentVersions_CustomDocumentPsychiatricServiceNoteGenerals_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
    PRINT 'STEP 4(A) COMPLETED'

END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentPsychiatricServiceNoteHistory')
BEGIN
/* 
 * TABLE: CustomDocumentPsychiatricServiceNoteHistory 
 */
  CREATE TABLE CustomDocumentPsychiatricServiceNoteHistory( 
		DocumentVersionId					int					 NOT NULL,
		CreatedBy							type_CurrentUser     NOT NULL,
		CreatedDate							type_CurrentDatetime NOT NULL,
		ModifiedBy							type_CurrentUser     NOT NULL,
		ModifiedDate						type_CurrentDatetime NOT NULL,
		RecordDeleted						type_YOrN			 NULL
											CHECK (RecordDeleted in ('Y','N')),
		DeletedBy							type_UserId          NULL,
		DeletedDate							datetime             NULL,
		NextPsychiatricAppointment  		type_Comment2		 NULL,
		SummaryAndRecommendations  			type_Comment2		 NULL,
		MedicationListAtTheTimeOfTransition type_Comment2		 NULL,
		ChiefComplaint 						type_Comment2		 NULL,
		SubjectiveAndObjective				type_Comment2		 NULL,
		AssessmentAndPlan					type_Comment2		 NULL,
		MedicalHistoryReviewedNoChanges 	type_YOrN			 NULL
											CHECK (MedicalHistoryReviewedNoChanges in ('Y','N')),
		MedicalHistoryReviewedWithChanges 	type_YOrN			 NULL
											CHECK (MedicalHistoryReviewedWithChanges in ('Y','N')),
		MedicalHistoryComments 				type_Comment2		 NULL,
		FamilyHistoryReviewedNoChanges 		type_YOrN			 NULL
											CHECK (FamilyHistoryReviewedNoChanges in ('Y','N')),
		FamilyHistoryReviewedWithChanges 	type_YOrN			 NULL
											CHECK (FamilyHistoryReviewedWithChanges in ('Y','N')),
		FamilyHistoryComments 				type_Comment2		 NULL,
		SocialHistoryReviewedNoChanges 		type_YOrN			 NULL
											CHECK (SocialHistoryReviewedNoChanges in ('Y','N')),
		SocialHistoryReviewedWithChanges	type_YOrN			 NULL
											CHECK (SocialHistoryReviewedWithChanges in ('Y','N')),
		SocialHistoryComments 				type_Comment2		 NULL,
		ReviewOfSystemPsych 				type_YOrN			 NULL
											CHECK (ReviewOfSystemPsych in ('Y','N')),
		ReviewOfSystemSomaticConcerns 		type_YOrN			 NULL
											CHECK (ReviewOfSystemSomaticConcerns in ('Y','N')),
		ReviewOfSystemConstitutional		type_YOrN			 NULL
											CHECK (ReviewOfSystemConstitutional in ('Y','N')),
		ReviewOfSystemEarNoseMouthThroat	type_YOrN			 NULL
											CHECK (ReviewOfSystemEarNoseMouthThroat in ('Y','N')),
		ReviewOfSystemGI					type_YOrN			 NULL
											CHECK (ReviewOfSystemGI in ('Y','N')),
		ReviewOfSystemGU					type_YOrN			 NULL
											CHECK (ReviewOfSystemGU in ('Y','N')),
		ReviewOfSystemIntegumentary			type_YOrN			 NULL 
											CHECK (ReviewOfSystemIntegumentary in ('Y','N')),
		ReviewOfSystemEndo					type_YOrN			 NULL
											CHECK (ReviewOfSystemEndo in ('Y','N')),
		ReviewOfSystemNeuro					type_YOrN			 NULL
											CHECK (ReviewOfSystemNeuro in ('Y','N')),
		ReviewOfSystemImmune				type_YOrN			 NULL
											CHECK (ReviewOfSystemImmune in ('Y','N')),
		ReviewOfSystemEyes					type_YOrN			 NULL
											CHECK (ReviewOfSystemEyes in ('Y','N')),
		ReviewOfSystemResp 					type_YOrN			 NULL
											CHECK (ReviewOfSystemResp in ('Y','N')),
		ReviewOfSystemCardioVascular		type_YOrN			 NULL
											CHECK (ReviewOfSystemCardioVascular in ('Y','N')),
		ReviewOfSystemHemLymph				type_YOrN			 NULL
											CHECK (ReviewOfSystemHemLymph in ('Y','N')),
		ReviewOfSystemMusculo				type_YOrN			 NULL
											CHECK (ReviewOfSystemMusculo in ('Y','N')),
		ReviewOfSystemAllOthersNegative		type_YOrN			 NULL
											CHECK (ReviewOfSystemAllOthersNegative in ('Y','N')),
		ReviewOfSystemComments				type_Comment2		 NULL,
		CONSTRAINT CustomDocumentPsychiatricServiceNoteHistory_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('CustomDocumentPsychiatricServiceNoteHistory') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentPsychiatricServiceNoteHistory >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentPsychiatricServiceNoteHistory >>>', 16, 1)
/* 
 * TABLE: CustomDocumentPsychiatricServiceNoteHistory 
 */   
    
ALTER TABLE CustomDocumentPsychiatricServiceNoteHistory ADD CONSTRAINT DocumentVersions_CustomDocumentPsychiatricServiceNoteHistory_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
    PRINT 'STEP 4(B) COMPLETED'

END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomPsychiatricServiceNoteProblems')
BEGIN
/* 
 * TABLE: CustomPsychiatricServiceNoteProblems 
 */
  CREATE TABLE CustomPsychiatricServiceNoteProblems( 
		PsychiatricServiceNoteProblemId		int	identity(1,1)	 NOT NULL,
		CreatedBy							type_CurrentUser     NOT NULL,
		CreatedDate							type_CurrentDatetime NOT NULL,
		ModifiedBy							type_CurrentUser     NOT NULL,
		ModifiedDate						type_CurrentDatetime NOT NULL,
		RecordDeleted						type_YOrN			 NULL
											CHECK (RecordDeleted in ('Y','N')),
		DeletedBy							type_UserId          NULL,
		DeletedDate							datetime             NULL,
		DocumentVersionId			  		int					 NULL,
		ProblemText 						type_Comment2		 NULL,
		Severity 							type_GlobalCode		 NULL,
		Duration							varchar(150)		 NULL,
		Intensity 							type_GlobalCode		 NULL,
		IntensityText 						type_Comment2		 NULL,
		TimeOfDayMorning  					type_YOrN			 NULL
											CHECK (TimeOfDayMorning in ('Y','N')),				
		TimeOfDayNoon  						type_YOrN			 NULL
											CHECK (TimeOfDayNoon in ('Y','N')), 	
		TimeOfDayAfternoon 					type_YOrN			 NULL
											CHECK (TimeOfDayAfternoon in ('Y','N')), 	
		TimeOfDayEvening 					type_YOrN			 NULL
											CHECK (TimeOfDayEvening in ('Y','N')), 	
		TimeOfDayNight 						type_YOrN			 NULL
											CHECK (TimeOfDayNight in ('Y','N')), 	 
		ContextHome 						type_YOrN			 NULL
											CHECK (ContextHome in ('Y','N')), 	
		ContextSchool 						type_YOrN			 NULL
											CHECK (ContextSchool in ('Y','N')), 		
		ContextWork 						type_YOrN			 NULL
											CHECK (ContextWork in ('Y','N')), 	
		ContextCommunity 					type_YOrN			 NULL
											CHECK (ContextCommunity in ('Y','N')), 	
		ContextOther 						type_YOrN			 NULL
											CHECK (ContextOther in ('Y','N')), 	
		ContextOtherText 					type_Comment2		 NULL,
		AssociatedSignsSymptoms				type_GlobalCode		 NULL,
		AssociatedSignsSymptomsOtherText 	type_Comment2		 NULL,
		ModifyingFactors 					type_Comment2		 NULL,
		ProblemStatus						type_GlobalCode		 NULL,
		CONSTRAINT CustomPsychiatricServiceNoteProblems_PK PRIMARY KEY CLUSTERED (PsychiatricServiceNoteProblemId) 
 )
 
  IF OBJECT_ID('CustomPsychiatricServiceNoteProblems') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomPsychiatricServiceNoteProblems >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomPsychiatricServiceNoteProblems >>>', 16, 1)
/* 
 * TABLE: CustomPsychiatricServiceNoteProblems 
 */   
    
ALTER TABLE CustomPsychiatricServiceNoteProblems ADD CONSTRAINT DocumentVersions_CustomPsychiatricServiceNoteProblems_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
    PRINT 'STEP 4(C) COMPLETED'

END
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentPsychiatricServiceNoteExams')
BEGIN
/* 
 * TABLE: CustomDocumentPsychiatricServiceNoteExams 
 */
  CREATE TABLE CustomDocumentPsychiatricServiceNoteExams( 
		DocumentVersionId					int					 NOT NULL,
		CreatedBy							type_CurrentUser     NOT NULL,
		CreatedDate							type_CurrentDatetime NOT NULL,
		ModifiedBy							type_CurrentUser     NOT NULL,
		ModifiedDate						type_CurrentDatetime NOT NULL,
		RecordDeleted						type_YOrN			 NULL
											CHECK (RecordDeleted in ('Y','N')),
		DeletedBy							type_UserId          NULL,
		DeletedDate							datetime             NULL,
		AppropriatelyDressed 				type_YOrN			 NULL
											CHECK (AppropriatelyDressed in ('Y','N')),
		GeneralAppearanceUnkept  			type_YOrN			 NULL
											CHECK (GeneralAppearanceUnkept in ('Y','N')),
		GeneralAppearanceOther 				type_YOrN			 NULL
											CHECK (GeneralAppearanceOther in ('Y','N')),
		GeneralAppearanceOtherText 			type_Comment2		 NULL,
		MuscleStrengthNormal 				type_YOrN			 NULL
											CHECK (MuscleStrengthNormal in ('Y','N')),
		MuscleStrengthAbnormal 				type_YOrN			 NULL
											CHECK (MuscleStrengthAbnormal in ('Y','N')),
		MusculoskeletalTone					type_YOrN			 NULL
											CHECK (MusculoskeletalTone in ('Y','N')),
		GaitNormal 							type_YOrN			 NULL
											CHECK (GaitNormal in ('Y','N')),
		GaitAbnormal 						type_YOrN			 NULL
											CHECK (GaitAbnormal in ('Y','N')),
		TicsTremorsAbnormalMovements 		type_YOrN			 NULL
											CHECK (TicsTremorsAbnormalMovements in ('Y','N')),
		EPS 								type_YOrN			 NULL
											CHECK (EPS in ('Y','N')),
		AppearanceBehavior 					type_YOrN			 NULL
											CHECK (AppearanceBehavior in ('Y','N')),
		AppearanceBehaviorComments 			type_Comment2		 NULL,
		Speech								type_YOrN			 NULL
											CHECK (Speech in ('Y','N')),
		SpeechComments 						type_Comment2		 NULL,
		ThoughtProcess 						type_YOrN			 NULL
											CHECK (ThoughtProcess in ('Y','N')),
		ThoughtProcessComments				type_Comment2		 NULL,
		Associations						type_YOrN			 NULL
											CHECK (Associations in ('Y','N')),
		AssociationsComments 				type_Comment2		 NULL,
		AbnormalPsychoticThoughts 			type_YOrN			 NULL
											CHECK (AbnormalPsychoticThoughts in ('Y','N')),
		AbnormalPsychoticThoughtsComments	type_Comment2		 NULL,
		JudgmentAndInsight					type_YOrN			 NULL
											CHECK (JudgmentAndInsight in ('Y','N')),	
		JudgmentAndInsightComments			type_Comment2		 NULL,
		Orientation							type_YOrN			 NULL
											CHECK (Orientation in ('Y','N')),
		OrientationComments 				type_Comment2		 NULL,
		RecentRemoteMemory 					type_YOrN			 NULL
											CHECK (RecentRemoteMemory in ('Y','N')),
		RecentRemoteMemoryComments 			type_Comment2		 NULL,
		AttentionConcentration				type_YOrN			 NULL
											CHECK (AttentionConcentration in ('Y','N')),
		AttentionConcentrationComments		type_Comment2		 NULL,
		[Language]							type_YOrN			 NULL
											CHECK ([Language] in ('Y','N')),
		LanguageCommments					type_Comment2		 NULL,
		FundOfKnowledge 					type_YOrN			 NULL
											CHECK (FundOfKnowledge in ('Y','N')),
		FundOfKnowledgeComments 			type_Comment2		 NULL,
		MoodAndAffect 						type_YOrN			 NULL
											CHECK (MoodAndAffect in ('Y','N')),
		MoodAndAffectComments				type_Comment2		 NULL,
CONSTRAINT CustomDocumentPsychiatricServiceNoteExams_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('CustomDocumentPsychiatricServiceNoteExams') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentPsychiatricServiceNoteExams >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentPsychiatricServiceNoteExams >>>', 16, 1)
/* 
 * TABLE: CustomDocumentPsychiatricServiceNoteExams 
 */   
    
ALTER TABLE CustomDocumentPsychiatricServiceNoteExams ADD CONSTRAINT DocumentVersions_CustomDocumentPsychiatricServiceNoteExams_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
    PRINT 'STEP 4(D) COMPLETED'

END
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentPsychiatricServiceNoteMDMs')
BEGIN
/* 
 * TABLE: CustomDocumentPsychiatricServiceNoteMDMs 
 */
  CREATE TABLE CustomDocumentPsychiatricServiceNoteMDMs( 
		DocumentVersionId					int					 NOT NULL,
		CreatedBy							type_CurrentUser     NOT NULL,
		CreatedDate							type_CurrentDatetime NOT NULL,
		ModifiedBy							type_CurrentUser     NOT NULL,
		ModifiedDate						type_CurrentDatetime NOT NULL,
		RecordDeleted						type_YOrN			 NULL
											CHECK (RecordDeleted in ('Y','N')),
		DeletedBy							type_UserId          NULL,
		DeletedDate							datetime             NULL,
		MedicalRecords 						type_YOrN			 NULL
											CHECK (MedicalRecords in ('Y','N')),
		DiagnosticTest  					type_YOrN			 NULL
											CHECK (DiagnosticTest in ('Y','N')),
		Labs 								type_YOrN			 NULL
											CHECK (Labs in ('Y','N')),
		LabsSelected						int					 NULL,
		MedicalRecordsComments  			type_Comment2		 NULL,
		OrderedMedications 					type_YOrN			 NULL
											CHECK (OrderedMedications in ('Y','N')),
		RisksBenefits 						type_YOrN			 NULL
											CHECK (RisksBenefits in ('Y','N')),
		NewlyEmergentSideEffects 			type_YOrN			 NULL
											CHECK (NewlyEmergentSideEffects in ('Y','N')),
		LabOrder 							type_YOrN			 NULL
											CHECK (LabOrder in ('Y','N')),
		RadiologyOrder						type_YOrN			 NULL
											CHECK (RadiologyOrder in ('Y','N')),
		Consultations 						type_YOrN			 NULL
											CHECK (Consultations in ('Y','N')),
		OrdersComments 						type_Comment2		 NULL,
CONSTRAINT CustomDocumentPsychiatricServiceNoteMDMs_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('CustomDocumentPsychiatricServiceNoteMDMs') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentPsychiatricServiceNoteMDMs >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentPsychiatricServiceNoteMDMs >>>', 16, 1)
/* 
 * TABLE: CustomDocumentPsychiatricServiceNoteMDMs 
 */   
    
ALTER TABLE CustomDocumentPsychiatricServiceNoteMDMs ADD CONSTRAINT DocumentVersions_CustomDocumentPsychiatricServiceNoteMDMs_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
    PRINT 'STEP 4(E) COMPLETED'

END
  ---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------


IF NOT EXISTS (SELECT  [key] FROM SystemConfigurationKeys WHERE  [key] = 'CDM_PsychiatricService')
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
				   ,'CDM_PsychiatricService'
				   ,'1.0'
				   )
		PRINT 'STEP 7 COMPLETED'
	END



 GO