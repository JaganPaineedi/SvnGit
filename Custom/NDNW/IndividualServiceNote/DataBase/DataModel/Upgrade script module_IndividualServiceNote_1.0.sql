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
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentIndividualServiceNoteGenerals')
BEGIN
/* 
 * TABLE: CustomDocumentIndividualServiceNoteGenerals 
 */
 CREATE TABLE CustomDocumentIndividualServiceNoteGenerals( 
		DocumentVersionId						int					 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		DBT										type_YOrN			 NULL
												CHECK (DBT in ('Y','N')),
		OQYOQ									type_YOrN			 NULL
												CHECK (OQYOQ in ('Y','N')),
		MotivationalInterviewing				type_YOrN			 NULL
												CHECK (MotivationalInterviewing in ('Y','N')),
		EMDR									type_YOrN			 NULL
												CHECK (EMDR in ('Y','N')),
		DV										type_YOrN			 NULL
												CHECK (DV in ('Y','N')),
		TFCBT									type_YOrN			 NULL
												CHECK (TFCBT in ('Y','N')),
		MoodAffect								type_YOrN			 NULL
												CHECK (MoodAffect in ('Y','N')),
		MoodAffectComments						type_Comment2		 NULL,
		ThoughtProcess							type_YOrN			 NULL
												CHECK (ThoughtProcess in ('Y','N')),
		ThoughtProcessComments					type_Comment2		 NULL,
		Behavior								type_YOrN			 NULL
												CHECK (Behavior in ('Y','N')),
		BehaviorComments						type_Comment2		 NULL,
		MedicalCondition						type_YOrN			 NULL
												CHECK (MedicalCondition in ('Y','N')),
		MedicalConditionComments				type_Comment2		 NULL,
		SubstanceAbuse							type_YOrN			 NULL
												CHECK (SubstanceAbuse in ('Y','N')),
		SubstanceAbuseComments					type_Comment2		 NULL,
		SelfHarm								type_YOrN			 NULL
												CHECK (SelfHarm in ('Y','N')),
		SelfHarmIdeation						type_YOrN			 NULL
												CHECK (SelfHarmIdeation in ('Y','N')),
		SelfHarmIntent							type_YOrN			 NULL
												CHECK (SelfHarmIntent in ('Y','N')),
		SelfHarmAttempt							type_YOrN			 NULL
												CHECK (SelfHarmAttempt in ('Y','N')),
		SelfHarmMeans							type_YOrN			 NULL
												CHECK (SelfHarmMeans in ('Y','N')),
		SelfHarmPlan							type_YOrN			 NULL
												CHECK (SelfHarmPlan in ('Y','N')),
		selfHarmOther							type_YOrN			 NULL
												CHECK (selfHarmOther in ('Y','N')),
		SelfHarmOtherComments					type_Comment2		 NULL,
		SelfHarmInformed						type_YOrN			 NULL
												CHECK (SelfHarmInformed in ('Y','N')),
		SelfHarmInformedComments				type_Comment2		 NULL,
		SelfHarmComments						type_Comment2		 NULL,
		HarmToOthers							type_YOrN			 NULL
												CHECK (HarmToOthers in ('Y','N')),
		HarmToOthersIdeation					type_YOrN			 NULL
												CHECK (HarmToOthersIdeation in ('Y','N')),
		HarmToOthersIntent						type_YOrN			 NULL
												CHECK (HarmToOthersIntent in ('Y','N')),
		HarmToOthersAttempt						type_YOrN			 NULL
												CHECK (HarmToOthersAttempt in ('Y','N')),
		HarmToOthersMeans						type_YOrN			 NULL
												CHECK (HarmToOthersMeans in ('Y','N')),
		HarmToOthersPlan						type_YOrN			 NULL
												CHECK (HarmToOthersPlan in ('Y','N')),
		HarmToOthersOther						type_YOrN			 NULL
												CHECK (HarmToOthersOther in ('Y','N')),
		HarmToOthersOtherComments				type_Comment2		 NULL,
		HarmToOthersInformed					type_YOrN			 NULL
												CHECK (HarmToOthersInformed in ('Y','N')),
		HarmToOthersInformedComments			type_Comment2		 NULL,
		HarmToOthersComments					type_Comment2		 NULL,
		HarmToProperty							type_YOrN			 NULL
												CHECK (HarmToProperty in ('Y','N')),
		HarmToPropertyIdeation					type_YOrN			 NULL
												CHECK (HarmToPropertyIdeation in ('Y','N')),
		HarmToPropertyIntent					type_YOrN			 NULL
												CHECK (HarmToPropertyIntent in ('Y','N')),
		HarmToPropertyAttempt					type_YOrN			 NULL
												CHECK (HarmToPropertyAttempt in ('Y','N')),
		HarmToPropertyMeans						type_YOrN			 NULL
												CHECK (HarmToPropertyMeans in ('Y','N')),
		HarmToPropertyPlan						type_YOrN			 NULL
												CHECK (HarmToPropertyPlan in ('Y','N')),
		HarmToPropertyOther						type_YOrN			 NULL
												CHECK (HarmToPropertyOther in ('Y','N')),
		HarmToPropertyOtherComments				type_Comment2		 NULL,
		HarmToPropertyInformed					type_YOrN			 NULL
												CHECK (HarmToPropertyInformed in ('Y','N')),
		HarmToPropertyInformedComments			type_Comment2		 NULL,
		HarmToPropertyComments					type_Comment2		 NULL,
		SafetyPlanWasReviewed					type_YOrN			 NULL
												CHECK (SafetyPlanWasReviewed in ('Y','N')),
		WithOrWithOutClient						type_YOrN			 NULL
												CHECK (WithOrWithOutClient in ('Y','N')),
		NextSteps								type_Comment2		NULL,
		FocusOfTheSession						type_Comment2		NULL,
		InterventionsProvided					type_Comment2		NULL,
		ProgressMade							type_Comment2		NULL,
		Overcome								type_Comment2		NULL,
		PlanLastService							type_Comment2		NULL,
		ShowSelectedItem						type_YOrN			 NULL
												CHECK (ShowSelectedItem in ('Y','N')),
		CONSTRAINT CustomDocumentIndividualServiceNoteGenerals_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('CustomDocumentIndividualServiceNoteGenerals') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentIndividualServiceNoteGenerals >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentIndividualServiceNoteGenerals >>>', 16, 1)
/* 
 * TABLE: CustomDocumentIndividualServiceNoteGenerals 
 */   

    
ALTER TABLE CustomDocumentIndividualServiceNoteGenerals ADD CONSTRAINT DocumentVersions_CustomDocumentIndividualServiceNoteGenerals_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
        
     PRINT 'STEP 4(A) COMPLETED'
END
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentDBTs')
BEGIN
/* 
 * TABLE: CustomDocumentDBTs 
 */
 CREATE TABLE CustomDocumentDBTs( 
		DocumentVersionId						int					 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,	
		SignificantInvolvement					varchar(max)		 NULL,
		OtherInvolvementDetail					varchar(max)		 NULL,
		WiseMind								type_YOrN			 NULL
												CHECK (WiseMind in ('Y','N')),
		NonJudgmentalStance						type_YOrN			 NULL
												CHECK (NonJudgmentalStance in ('Y','N')),
		ObserveNotice							type_YOrN			 NULL
												CHECK (ObserveNotice in ('Y','N')),
		MindfulSkill							type_YOrN			 NULL
												CHECK (MindfulSkill in ('Y','N')),
		DescribeWords							type_YOrN			 NULL
												CHECK (DescribeWords in ('Y','N')),
		Effectiveness							type_YOrN			 NULL
												CHECK (Effectiveness in ('Y','N')),
		Participate								type_YOrN			 NULL
												CHECK (Participate in ('Y','N')),
		DearMan									type_YOrN			 NULL
												CHECK (DearMan in ('Y','N')),
		FastInterpersonalSkill					type_YOrN			 NULL
												CHECK (FastInterpersonalSkill in ('Y','N')),
		GiveInterpersonalSkill					type_YOrN			 NULL
												CHECK (GiveInterpersonalSkill in ('Y','N')),
		PleaseEmotionalRegulationSkill			type_YOrN			 NULL
												CHECK (PleaseEmotionalRegulationSkill in ('Y','N')),
		PostiveExperience						type_YOrN			 NULL
												CHECK (PostiveExperience in ('Y','N')),
		Mastery									type_YOrN			 NULL
												CHECK (Mastery in ('Y','N')),
		ActOpposite								type_YOrN			 NULL
												CHECK (ActOpposite in ('Y','N')),
		DistractSkill							type_YOrN			 NULL
												CHECK (DistractSkill in ('Y','N')),
		ProsConsSkill							type_YOrN			 NULL
												CHECK (ProsConsSkill in ('Y','N')),
		SelfSootheSkill							type_YOrN			 NULL
												CHECK (SelfSootheSkill in ('Y','N')),
		RadicalAcceptance						type_YOrN			 NULL
												CHECK (RadicalAcceptance in ('Y','N')),
		Modeling								type_YOrN			 NULL
												CHECK (Modeling in ('Y','N')),
		ImproveMoment							type_YOrN			 NULL
												CHECK (ImproveMoment in ('Y','N')),
		AssessingAbilities						type_YOrN			 NULL
												CHECK (AssessingAbilities in ('Y','N')),
		Instructions							type_YOrN			 NULL
												CHECK (Instructions in ('Y','N')),
		BehavioralRehearsal						type_YOrN			 NULL
												CHECK (BehavioralRehearsal in ('Y','N')),
		FeedbackCoaching						type_YOrN			 NULL
												CHECK (FeedbackCoaching in ('Y','N')),
		ResponseReinforcement					type_YOrN			 NULL
												CHECK (ResponseReinforcement in ('Y','N')),
		HomeworkAssignment						type_YOrN			 NULL
												CHECK (HomeworkAssignment in ('Y','N')),
		DiscussionSimilarities					type_YOrN			 NULL
												CHECK (DiscussionSimilarities in ('Y','N')),
		ReviewDiaryCard							type_YOrN			 NULL
												CHECK (ReviewDiaryCard in ('Y','N')),
		BehavioralChainAnalysis					type_YOrN			 NULL
												CHECK (BehavioralChainAnalysis in ('Y','N')),
		CONSTRAINT CustomDocumentDBTs_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('CustomDocumentDBTs') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentDBTs >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentDBTs >>>', 16, 1)
/* 
 * TABLE: CustomDocumentDBTs 
 */   

    
ALTER TABLE CustomDocumentDBTs ADD CONSTRAINT DocumentVersions_CustomDocumentDBTs_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
        
     PRINT 'STEP 4(B) COMPLETED'
 END
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomIndividualServiceNoteGoals')
BEGIN
/* 
 * TABLE: CustomIndividualServiceNoteGoals 
 */
 CREATE TABLE CustomIndividualServiceNoteGoals( 
		IndividualServiceNoteGoalId				int	identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		DocumentVersionId						int					 NULL,
		GoalId									int					 NULL,
		GoalNumber								decimal(18, 2)		 NULL,
		GoalText								type_Comment2		 NULL,
		CustomGoalActive						type_YOrN			 NULL
												CHECK (CustomGoalActive in ('Y','N')),
		CONSTRAINT CustomIndividualServiceNoteGoals_PK PRIMARY KEY CLUSTERED (IndividualServiceNoteGoalId) 
 )
 
  IF OBJECT_ID('CustomIndividualServiceNoteGoals') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomIndividualServiceNoteGoals >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomIndividualServiceNoteGoals >>>', 16, 1)
/* 
 * TABLE: CustomIndividualServiceNoteGoals 
 */   

    
ALTER TABLE CustomIndividualServiceNoteGoals ADD CONSTRAINT DocumentVersions_CustomIndividualServiceNoteGoals_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)

ALTER TABLE CustomIndividualServiceNoteGoals ADD CONSTRAINT CarePlanGoals_CustomIndividualServiceNoteGoals_FK
    FOREIGN KEY (GoalId)
    REFERENCES CarePlanGoals(CarePlanGoalId)    
        
     PRINT 'STEP 4(C) COMPLETED'
 END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomIndividualServiceNoteObjectives')
BEGIN
/* 
 * TABLE: CustomIndividualServiceNoteObjectives 
 */
 CREATE TABLE CustomIndividualServiceNoteObjectives( 
		IndividualServiceNoteObjectiveId		int	identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		DocumentVersionId						int					 NULL,
		GoalId									int					 NULL,
		ObjectiveNumber 						decimal(18, 2)		 NULL,		
		CustomObjectiveActive 					type_YOrN			 NULL
												CHECK (CustomObjectiveActive in ('Y','N')),
		[Status]								type_GlobalCode		 NULL,
		ObjectiveText							type_Comment2		 NULL,										
		CONSTRAINT CustomIndividualServiceNoteObjectives_PK PRIMARY KEY CLUSTERED (IndividualServiceNoteObjectiveId) 
 )
 
  IF OBJECT_ID('CustomIndividualServiceNoteObjectives') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomIndividualServiceNoteObjectives >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomIndividualServiceNoteObjectives >>>', 16, 1)
/* 
 * TABLE: CustomIndividualServiceNoteObjectives 
 */
ALTER TABLE CustomIndividualServiceNoteObjectives ADD CONSTRAINT DocumentVersions_CustomIndividualServiceNoteObjectives_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
ALTER TABLE CustomIndividualServiceNoteObjectives ADD CONSTRAINT CarePlanGoals_CustomIndividualServiceNoteObjectives_FK
    FOREIGN KEY (GoalId)
    REFERENCES CarePlanGoals(CarePlanGoalId)   
            
     PRINT 'STEP 4(D) COMPLETED'
 END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomIndividualServiceNoteDiagnoses')
BEGIN
/* 
 * TABLE: CustomIndividualServiceNoteDiagnoses 
 */
 CREATE TABLE CustomIndividualServiceNoteDiagnoses( 
		IndividualServiceNoteDiagnosisId		int	identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		DocumentVersionId						int					 NULL,
		DSMCode									varchar(20)			 NULL,
		DSMNumber								int					 NULL,
		DSMVCodeId								varchar(20)			 NULL,
		ICD10Code								varchar(20)			 NULL,
		ICD9Code								varchar(20)			 NULL,
		[Order]									int					 NULL,
		CONSTRAINT CustomIndividualServiceNoteDiagnoses_PK PRIMARY KEY CLUSTERED (IndividualServiceNoteDiagnosisId) 
 )
 
  IF OBJECT_ID('CustomIndividualServiceNoteDiagnoses') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomIndividualServiceNoteDiagnoses >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomIndividualServiceNoteDiagnoses >>>', 16, 1)
/* 
 * TABLE: CustomIndividualServiceNoteDiagnoses 
 */   

    
ALTER TABLE CustomIndividualServiceNoteDiagnoses ADD CONSTRAINT DocumentVersions_CustomIndividualServiceNoteDiagnoses_FK
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


If not exists (select [key] from SystemConfigurationKeys where [key] = 'CDM_IndividualServiceNote')
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
				   ,'CDM_IndividualServiceNote'
				   ,'1.0'
				   )
		PRINT 'STEP 7 COMPLETED'
END
GO

 
