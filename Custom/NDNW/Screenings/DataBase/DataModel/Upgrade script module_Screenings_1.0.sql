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
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentSubstanceAbuseScreenings')
BEGIN
/*   
 * TABLE: CustomDocumentSubstanceAbuseScreenings 
 */
CREATE TABLE CustomDocumentSubstanceAbuseScreenings(
			DocumentVersionId							int						NOT NULL,
			CreatedBy									type_CurrentUser        NOT NULL,
			CreatedDate									type_CurrentDatetime    NOT NULL,
			ModifiedBy									type_CurrentUser        NOT NULL,
			ModifiedDate								type_CurrentDatetime    NOT NULL,
			RecordDeleted								type_YOrN               NULL
														CHECK (RecordDeleted in ('Y','N')),
			DeletedBy									type_UserId             NULL,
			DeletedDate									datetime				NULL,
			Inhalants									type_GlobalCode		    NULL,
			MissedSchool								type_GlobalCode		    NULL,
			PastYearDrunk								type_GlobalCode		    NULL,
			RiskyWhenHigh								type_GlobalCode		    NULL,
			ProblemWithDrinking							type_GlobalCode		    NULL,
			ThingsWithoutThinking						type_GlobalCode		    NULL,
			MissFamilyActivities						type_GlobalCode		    NULL,
			WorryAboutUsingAlcohol						type_GlobalCode		    NULL,
			HurtLovedOne								type_GlobalCode		    NULL,
			ToFeelNormal								type_GlobalCode		    NULL,
			MakeYouMad									type_GlobalCode		    NULL,
			GuiltyAboutAlcohol							type_GlobalCode		    NULL,
			WorryAboutGamblingActivities				type_GlobalCode		    NULL,
			HasMotherConsumedAlcohol					type_GlobalCode		    NULL,
			DidMotherDrinkInPregnancy					type_GlobalCode		    NULL,
			Comments									type_Comment2			NULL,
			CONSTRAINT CustomDocumentSubstanceAbuseScreenings_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('CustomDocumentSubstanceAbuseScreenings') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentSubstanceAbuseScreenings >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentSubstanceAbuseScreenings >>>', 16, 1)
/* 
 * TABLE: CustomDocumentSubstanceAbuseScreenings 
 */ 
   
ALTER TABLE CustomDocumentSubstanceAbuseScreenings ADD CONSTRAINT DocumentVersions_CustomDocumentSubstanceAbuseScreenings_FK 
	FOREIGN KEY (DocumentVersionId)
	REFERENCES DocumentVersions(DocumentVersionId)
	PRINT 'STEP 4(A) COMPLETED'
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentMentalHealthScreenings')
BEGIN
/*   
 * TABLE: CustomDocumentMentalHealthScreenings 
 */
CREATE TABLE CustomDocumentMentalHealthScreenings(
			DocumentVersionId							int						NOT NULL,
			CreatedBy									type_CurrentUser        NOT NULL,
			CreatedDate									type_CurrentDatetime    NOT NULL,
			ModifiedBy									type_CurrentUser        NOT NULL,
			ModifiedDate								type_CurrentDatetime    NOT NULL,
			RecordDeleted								type_YOrN               NULL
														CHECK (RecordDeleted in ('Y','N')),
			DeletedBy									type_UserId             NULL,
			DeletedDate									datetime				NULL,	
			PayingAttentionAtSchool						type_GlobalCode		    NULL,
			CanNotGetRidOfThought						type_GlobalCode		    NULL,
			HearVoices									type_GlobalCode		    NULL,
			SpendTimeKilling							type_GlobalCode		    NULL,
			TriedToCommitSuicide						type_GlobalCode		    NULL,
			WatchYourStep								type_GlobalCode		    NULL,
			FeelAnxious									type_GlobalCode		    NULL,
			ThoughtsComeQuickly							type_GlobalCode		    NULL,
			DestroyedProperty							type_GlobalCode		    NULL,
			FeelTrapped									type_GlobalCode		    NULL,
			DissatifiedWithLife							type_GlobalCode		    NULL,
			UnPleasantThoughts							type_GlobalCode		    NULL,
			DifficultyInSleeping						type_GlobalCode		    NULL,
			PhysicallyHarmed							type_GlobalCode		    NULL,
			LostInterest								type_GlobalCode		    NULL,
			FeelAngry									type_GlobalCode		    NULL,
			GetIntoTrouble								type_GlobalCode		    NULL,
			FeelAfraid									type_GlobalCode		    NULL,
			FeelDepressed								type_GlobalCode		    NULL,
			SpendTimeOnThinkingAboutWeight				type_GlobalCode		    NULL,
			Comments									type_Comment2			NULL,
			CONSTRAINT CustomDocumentMentalHealthScreenings_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('CustomDocumentMentalHealthScreenings') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentMentalHealthScreenings >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentMentalHealthScreenings >>>', 16, 1)
/* 
 * TABLE: CustomDocumentMentalHealthScreenings 
 */ 
   
ALTER TABLE CustomDocumentMentalHealthScreenings ADD CONSTRAINT DocumentVersions_CustomDocumentMentalHealthScreenings_FK 
	FOREIGN KEY (DocumentVersionId)
	REFERENCES DocumentVersions(DocumentVersionId)
	PRINT 'STEP 4(B) COMPLETED'
END
			
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentTraumaticBrainInjuryScreenings')
BEGIN
/*   
 * TABLE: CustomDocumentTraumaticBrainInjuryScreenings 
 */
CREATE TABLE CustomDocumentTraumaticBrainInjuryScreenings(
			DocumentVersionId							int						NOT NULL,
			CreatedBy									type_CurrentUser        NOT NULL,
			CreatedDate									type_CurrentDatetime    NOT NULL,
			ModifiedBy									type_CurrentUser        NOT NULL,
			ModifiedDate								type_CurrentDatetime    NOT NULL,
			RecordDeleted								type_YOrN               NULL
														CHECK (RecordDeleted in ('Y','N')),
			DeletedBy									type_UserId             NULL,
			DeletedDate									datetime				NULL,	
			BlowToTheHead								type_GlobalCode		    NULL,								
			HeadBlowWhenDidItOccur						varchar(500)			NULL,					
			HowLongUnconscious							varchar(500)			NULL,	
			CauseAConcussion							type_GlobalCode		    NULL,
			ConcussionWhenDidItOccur					varchar(500)			NULL,	
			HowLongConcussionLast						varchar(500)			NULL,	
			ReceiveTreatmentForHeadInjury				type_GlobalCode		    NULL,
			PhysicalAbilities							type_GlobalCode		    NULL,
			Mood										type_GlobalCode		    NULL,
			CareForYourSelf								type_GlobalCode		    NULL,
			Temper										type_GlobalCode		    NULL,
			Speech										type_GlobalCode		    NULL,
			RelationshipWithOthers						type_GlobalCode		    NULL,
			Hearing										type_GlobalCode		    NULL,
			Memory										type_GlobalCode		    NULL,
			AbilityToConcentrate						type_GlobalCode		    NULL,
			UseOfAlcohol								type_GlobalCode		    NULL,
			AbilityToWork								type_GlobalCode		    NULL,
			ChangedAfterInjury							type_GlobalCode		    NULL,
			Comments									type_Comment2			NULL,
			CONSTRAINT CustomDocumentTraumaticBrainInjuryScreenings_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('CustomDocumentTraumaticBrainInjuryScreenings') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentTraumaticBrainInjuryScreenings >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentTraumaticBrainInjuryScreenings >>>', 16, 1)
/* 
 * TABLE: CustomDocumentTraumaticBrainInjuryScreenings 
 */ 
   
ALTER TABLE CustomDocumentTraumaticBrainInjuryScreenings ADD CONSTRAINT DocumentVersions_CustomDocumentTraumaticBrainInjuryScreenings_FK 
	FOREIGN KEY (DocumentVersionId)
	REFERENCES DocumentVersions(DocumentVersionId)
	PRINT 'STEP 4(C) COMPLETED'
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentOutComesScreenings')
BEGIN
/*   
 * TABLE: CustomDocumentOutComesScreenings 
 */
CREATE TABLE CustomDocumentOutComesScreenings(
			DocumentVersionId							int						NOT NULL,
			CreatedBy									type_CurrentUser        NOT NULL,
			CreatedDate									type_CurrentDatetime    NOT NULL,
			ModifiedBy									type_CurrentUser        NOT NULL,
			ModifiedDate								type_CurrentDatetime    NOT NULL,
			RecordDeleted								type_YOrN               NULL
														CHECK (RecordDeleted in ('Y','N')),
			DeletedBy									type_UserId             NULL,
			DeletedDate									datetime				NULL,	
			SubstanceAbuseConsumer						type_GlobalCode		    NULL,
			SubstanceAbuseConsumerSteps					varchar(500)			NULL,	
			MentalHealthConsumer						type_GlobalCode		    NULL,
			MentalHealthConsumerSteps					varchar(500)			NULL,	
			FASDAssessment								type_GlobalCode		    NULL,
			FASDAssessmentSteps							varchar(500)			NULL,	
			MHAndSAConsumer								type_GlobalCode		    NULL,
			MHAndSAConsumerSteps						varchar(500)			NULL,	
			EvidenceOfInjury							type_GlobalCode		    NULL,
			EvidenceOfInjurySteps						varchar(500)			NULL,	
			Comments									type_Comment2			NULL,
			CONSTRAINT CustomDocumentOutComesScreenings_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('CustomDocumentOutComesScreenings') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentOutComesScreenings >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentOutComesScreenings >>>', 16, 1)
/* 
 * TABLE: CustomDocumentOutComesScreenings 
 */ 
   
ALTER TABLE CustomDocumentOutComesScreenings ADD CONSTRAINT DocumentVersions_CustomDocumentOutComesScreenings_FK 
	FOREIGN KEY (DocumentVersionId)
	REFERENCES DocumentVersions(DocumentVersionId)
	
	PRINT 'STEP 4(D) COMPLETED'
END

---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF NOT EXISTS (	SELECT [key] FROM SystemConfigurationKeys	WHERE [key] = 'CDM_Screenings')
BEGIN
	INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[key]
		,Value
		)
	VALUES (
		'SHSDBA'
		,GETDATE()
		,'SHSDBA'
		,GETDATE()
		,'CDM_Screenings'
		,'1.0'
		)

	PRINT 'STEP 7 COMPLETED'
END
GO
