----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.58)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.58 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

------ STEP 3 ------------

-----END Of STEP 3--------------------

------ STEP 4 ------------
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='DocumentLOCUS')
BEGIN
/* 
 * TABLE: DocumentLOCUS 
 */
CREATE TABLE DocumentLOCUS(
			DocumentVersionId							int							NOT NULL,
			CreatedBy									type_CurrentUser			NOT NULL,
			CreatedDate									type_CurrentDatetime		NOT NULL,
			ModifiedBy									type_CurrentUser			NOT NULL,
			ModifiedDate								type_CurrentDatetime		NOT NULL,
			RecordDeleted								type_YOrN					NULL
														CHECK (RecordDeleted in ('Y','N')),
			DeletedBy									type_UserId					NULL,
			DeletedDate									datetime					NULL,
			MinimalRiskOfHarmNoIndication				type_YOrN					NULL
														CHECK (MinimalRiskOfHarmNoIndication in ('Y','N')),
			MinimalRiskOfHarmClearAbility				type_YOrN					NULL
														CHECK (MinimalRiskOfHarmClearAbility in ('Y','N')),	
			LowRiskOfHarmNoCurrentSuicidal				type_YOrN					NULL
														CHECK (LowRiskOfHarmNoCurrentSuicidal in ('Y','N')),
			LowRiskOfHarmOccasionalSubstance			type_YOrN					NULL
														CHECK (LowRiskOfHarmOccasionalSubstance in ('Y','N')),
			LowRiskOfHarmPeriodsInPast					type_YOrN					NULL
														CHECK (LowRiskOfHarmPeriodsInPast in ('Y','N')),
			ModerateRiskOfHarmSignificant				type_YOrN					NULL
														CHECK (ModerateRiskOfHarmSignificant in ('Y','N')),
			ModerateRiskOfHarmNoActiveSuicidal			type_YOrN					NULL
														CHECK (ModerateRiskOfHarmNoActiveSuicidal in ('Y','N')),
			ModerateRiskOfHarmHistoryOfChronic			type_YOrN					NULL
														CHECK (ModerateRiskOfHarmHistoryOfChronic in ('Y','N')),
			ModerateRiskOfHarmBinge						type_YOrN					NULL
														CHECK (ModerateRiskOfHarmBinge in ('Y','N')),
			ModerateRiskOfHarmSomeEvidence				type_YOrN					NULL
														CHECK (ModerateRiskOfHarmSomeEvidence in ('Y','N')),
			SeriousRiskOfHarmCurrentSuicidal			type_YOrN					NULL
														CHECK (SeriousRiskOfHarmCurrentSuicidal in ('Y','N')),
			SeriousRiskOfHarmHistoryOfChronic			type_YOrN					NULL
														CHECK (SeriousRiskOfHarmHistoryOfChronic in ('Y','N')),
			SeriousRiskOfHarmRecentPattern				type_YOrN					NULL
														CHECK (SeriousRiskOfHarmRecentPattern in ('Y','N')),
			SeriousRiskOfHarmClearCompromise			type_YOrN					NULL
														CHECK (SeriousRiskOfHarmClearCompromise in ('Y','N')),
			ExtremeRiskOfHarmCurrentSuicidal			type_YOrN					NULL
														CHECK (ExtremeRiskOfHarmCurrentSuicidal in ('Y','N')),
			ExtremeRiskOfHarmWithoutExpressed			type_YOrN					NULL
														CHECK (ExtremeRiskOfHarmWithoutExpressed in ('Y','N')),
			ExtremeRiskOfHarmWithHistory				type_YOrN					NULL
														CHECK (ExtremeRiskOfHarmWithHistory in ('Y','N')),
			ExtremeRiskOfHarmPresenceOfCommand			type_YOrN					NULL
														CHECK (ExtremeRiskOfHarmPresenceOfCommand in ('Y','N')),
			ExtremeRiskOfHarmRepeatedEpisodes			type_YOrN					NULL
														CHECK (ExtremeRiskOfHarmRepeatedEpisodes in ('Y','N')),
			ExtremeRiskOfHarmExtremeCompromise			type_YOrN					NULL
														CHECK (ExtremeRiskOfHarmExtremeCompromise in ('Y','N')),
			MinimalImpairmentNoMore						type_YOrN					NULL
														CHECK (MinimalImpairmentNoMore in ('Y','N')),
			MildImpairmentExperiencing					type_YOrN					NULL
														CHECK (MildImpairmentExperiencing in ('Y','N')),
			MildImpairmentRecentExperience				type_YOrN					NULL
														CHECK (MildImpairmentRecentExperience in ('Y','N')),
			MildImpairmentDevelopingMinor				type_YOrN					NULL
														CHECK (MildImpairmentDevelopingMinor in ('Y','N')),
			MildImpairmentDemonstrating					type_YOrN					NULL
														CHECK (MildImpairmentDemonstrating in ('Y','N')),
			ModerateImpairmentRecentConflict			type_YOrN					NULL
														CHECK (ModerateImpairmentRecentConflict in ('Y','N')),
			ModerateImpairmentAppearance				type_YOrN					NULL
														CHECK (ModerateImpairmentAppearance in ('Y','N')),
			ModerateImpairmentSignificantDisturbances	type_YOrN					NULL
														CHECK (ModerateImpairmentSignificantDisturbances in ('Y','N')),
			ModerateImpairmentSignificantDeterioration	type_YOrN					NULL
														CHECK (ModerateImpairmentSignificantDeterioration in ('Y','N')),
			ModerateImpairmentOngoing					type_YOrN					NULL
														CHECK (ModerateImpairmentOngoing in ('Y','N')),
			ModerateImpairmentRecentGains				type_YOrN					NULL
														CHECK (ModerateImpairmentRecentGains in ('Y','N')),
			SeriousImpairmentSeriousDecrease			type_YOrN					NULL
														CHECK (SeriousImpairmentSeriousDecrease in ('Y','N')),
			SeriousImpairmentSignificantWithdrawal		type_YOrN					NULL
														CHECK (SeriousImpairmentSignificantWithdrawal in ('Y','N')),
			SeriousImpairmentConsistentFailure			type_YOrN					NULL
														CHECK (SeriousImpairmentConsistentFailure in ('Y','N')),
			SeriousImpairmentSeriousDisturbances		type_YOrN					NULL
														CHECK (SeriousImpairmentSeriousDisturbances in ('Y','N')),
			SeriousImpairmentInability					type_YOrN					NULL
														CHECK (SeriousImpairmentInability in ('Y','N')),
			SevereImpairmentExtremeDeterioration		type_YOrN					NULL
														CHECK (SevereImpairmentExtremeDeterioration in ('Y','N')),
			SevereImpairmentDevelopmentComplete			type_YOrN					NULL
														CHECK (SevereImpairmentDevelopmentComplete in ('Y','N')),
			SevereImpairmentCompleteNeglect				type_YOrN					NULL
														CHECK (SevereImpairmentCompleteNeglect in ('Y','N')),
			SevereImpairmentExtremeDistruptions			type_YOrN					NULL
														CHECK (SevereImpairmentExtremeDistruptions in ('Y','N')),
			SevereImpairmentCompleteInability			type_YOrN					NULL
														CHECK (SevereImpairmentCompleteInability in ('Y','N')),										
			NoComorbidityNoEvidence						type_YOrN					NULL
														CHECK (NoComorbidityNoEvidence in ('Y','N')),
			NoComorbidityAnyIllnesses					type_YOrN					NULL
														CHECK (NoComorbidityAnyIllnesses in ('Y','N')),
			MinorComorbidityExistence					type_YOrN					NULL
														CHECK (MinorComorbidityExistence in ('Y','N')),
			MinorComorbidityOccasional					type_YOrN					NULL
														CHECK (MinorComorbidityOccasional in ('Y','N')),
			MinorComorbidityMayOccasionally				type_YOrN					NULL
														CHECK (MinorComorbidityMayOccasionally in ('Y','N')),
			SignificantComorbidityPotential				type_YOrN					NULL
														CHECK (SignificantComorbidityPotential in ('Y','N')),
			SignificantComorbidityCreated				type_YOrN					NULL
														CHECK (SignificantComorbidityCreated in ('Y','N')),
			SignificantComorbidityAdversely				type_YOrN					NULL
														CHECK (SignificantComorbidityAdversely in ('Y','N')),
			SignificantComorbidityOngoing				type_YOrN					NULL
														CHECK (SignificantComorbidityOngoing in ('Y','N')),
			SignificantComorbidityRecentSubstance		type_YOrN					NULL
														CHECK (SignificantComorbidityRecentSubstance in ('Y','N')),
			SignificantComorbiditySignificant			type_YOrN					NULL
														CHECK (SignificantComorbiditySignificant in ('Y','N')),
			MajorComorbidityHighLikelihood				type_YOrN					NULL
														CHECK (MajorComorbidityHighLikelihood in ('Y','N')),
			MajorComorbidityExistence					type_YOrN					NULL
														CHECK (MajorComorbidityExistence in ('Y','N')),
			MajorComorbidityOutcome						type_YOrN					NULL
														CHECK (MajorComorbidityOutcome in ('Y','N')),
			MajorComorbidityUncontrolled				type_YOrN					NULL
														CHECK (MajorComorbidityUncontrolled in ('Y','N')),
			MajorComorbidityPsychiatric					type_YOrN					NULL
														CHECK (MajorComorbidityPsychiatric in ('Y','N')),
			SevereComorbiditySignificant				type_YOrN					NULL
														CHECK (SevereComorbiditySignificant in ('Y','N')),
			SevereComorbidityPresence					type_YOrN					NULL
														CHECK (SevereComorbidityPresence in ('Y','N')),
			SevereComorbidityUncontrolled				type_YOrN					NULL
														CHECK (SevereComorbidityUncontrolled in ('Y','N')),
			SevereComorbiditySerereSubstance			type_YOrN					NULL
														CHECK (SevereComorbiditySerereSubstance in ('Y','N')),
			SevereComorbidityAcute						type_YOrN					NULL
														CHECK (SevereComorbidityAcute in ('Y','N')),							
			LowStressEssentially						type_YOrN					NULL
														CHECK (LowStressEssentially in ('Y','N')),
			LowStressNoRecent							type_YOrN					NULL
														CHECK (LowStressNoRecent in ('Y','N')),
			LowStressNoMajor							type_YOrN					NULL
														CHECK (LowStressNoMajor in ('Y','N')),
			LowStressMaterial							type_YOrN					NULL
														CHECK (LowStressMaterial in ('Y','N')),
			LowStressLiving								type_YOrN					NULL
														CHECK (LowStressLiving in ('Y','N')),
			LowStressNoPressure							type_YOrN					NULL
														CHECK (LowStressNoPressure in ('Y','N')),
			MildlyStressPresence						type_YOrN					NULL
														CHECK (MildlyStressPresence in ('Y','N')),
			MildlyStressTransition						type_YOrN					NULL
														CHECK (MildlyStressTransition in ('Y','N')),
			MildlyStressCircumstances					type_YOrN					NULL
														CHECK (MildlyStressCircumstances in ('Y','N')),
			MildlyStressRecentOnset						type_YOrN					NULL
														CHECK (MildlyStressRecentOnset in ('Y','N')),
			MildlyStressPotential						type_YOrN					NULL
														CHECK (MildlyStressPotential in ('Y','N')),
			MildlyStressPerformance						type_YOrN					NULL
														CHECK (MildlyStressPerformance in ('Y','N')),
			ModeratelyStressSignificantDiscord			type_YOrN					NULL
														CHECK (ModeratelyStressSignificantDiscord in ('Y','N')),
			ModeratelyStressSignificantTransition		type_YOrN					NULL
														CHECK (ModeratelyStressSignificantTransition in ('Y','N')),
			ModeratelyStressRecentImportant				type_YOrN					NULL
														CHECK (ModeratelyStressRecentImportant in ('Y','N')),
			ModeratelyStressConcern						type_YOrN					NULL
														CHECK (ModeratelyStressConcern in ('Y','N')),
			ModeratelyStressDanger						type_YOrN					NULL
														CHECK (ModeratelyStressDanger in ('Y','N')),
			ModeratelyStressEasyExposure				type_YOrN					NULL
														CHECK (ModeratelyStressEasyExposure in ('Y','N')),
			ModeratelyStressPerception					type_YOrN					NULL
														CHECK (ModeratelyStressPerception in ('Y','N')),
			HighlyStressSerious							type_YOrN					NULL
														CHECK (HighlyStressSerious in ('Y','N')),
			HighlyStressSevere							type_YOrN					NULL
														CHECK (HighlyStressSevere in ('Y','N')),
			HighlyStressInability						type_YOrN					NULL
														CHECK (HighlyStressInability in ('Y','N')),
			HighlyStressRecentOnset						type_YOrN					NULL
														CHECK (HighlyStressRecentOnset in ('Y','N')),
			HighlyStressDifficulty						type_YOrN					NULL
														CHECK (HighlyStressDifficulty in ('Y','N')),
			HighlyStressEpisodes						type_YOrN					NULL
														CHECK (HighlyStressEpisodes in ('Y','N')),
			HighlyStressOverwhelming					type_YOrN					NULL
														CHECK (HighlyStressOverwhelming in ('Y','N')),
			ExtremelyStressAcutely						type_YOrN					NULL
														CHECK (ExtremelyStressAcutely in ('Y','N')),
			ExtremelyStressOngoing						type_YOrN					NULL
														CHECK (ExtremelyStressOngoing in ('Y','N')),
			ExtremelyStressWitnessing					type_YOrN					NULL
														CHECK (ExtremelyStressWitnessing in ('Y','N')),
			ExtremelyStressPersecution					type_YOrN					NULL
														CHECK (ExtremelyStressPersecution in ('Y','N')),
			ExtremelyStressSudden						type_YOrN					NULL
														CHECK (ExtremelyStressSudden in ('Y','N')),	
			ExtremelyStressUnavoidable					type_YOrN					NULL
														CHECK (ExtremelyStressUnavoidable in ('Y','N')),
			ExtremelyStressIncarceration				type_YOrN					NULL
														CHECK (ExtremelyStressIncarceration in ('Y','N')),
			ExtremelyStressSevere						type_YOrN					NULL
														CHECK (ExtremelyStressSevere in ('Y','N')),
			ExtremelyStressSustained					type_YOrN					NULL
														CHECK (ExtremelyStressSustained in ('Y','N')),
			ExtremelyStressChaotic						type_YOrN					NULL
														CHECK (ExtremelyStressChaotic in ('Y','N')),
			HighlySupportivePlentiful					type_YOrN					NULL
														CHECK (HighlySupportivePlentiful in ('Y','N')),
			HighlySupportiveEffective					type_YOrN					NULL
														CHECK (HighlySupportiveEffective in ('Y','N')),
			SupportiveResources							type_YOrN					NULL
														CHECK (SupportiveResources in ('Y','N')),
			SupportiveSomeElements						type_YOrN					NULL
														CHECK (SupportiveSomeElements in ('Y','N')),
			SupportiveProfessional						type_YOrN					NULL
														CHECK (SupportiveProfessional in ('Y','N')),
			LimitedSupportFew							type_YOrN					NULL
														CHECK (LimitedSupportFew in ('Y','N')),
			LimitedSupportUsual							type_YOrN					NULL
														CHECK (LimitedSupportUsual in ('Y','N')),
			LimitedSupportPersons						type_YOrN					NULL
														CHECK (LimitedSupportPersons in ('Y','N')),
			LimitedSupportResources						type_YOrN					NULL
														CHECK (LimitedSupportResources in ('Y','N')),
			LimitedSupportLimited						type_YOrN					NULL
														CHECK (LimitedSupportLimited in ('Y','N')),
			MinimalSupportVeryFew						type_YOrN					NULL
														CHECK (MinimalSupportVeryFew in ('Y','N')),
			MinimalSupportUsual							type_YOrN					NULL
														CHECK (MinimalSupportUsual in ('Y','N')),
			MinimalSupportExisting						type_YOrN					NULL
														CHECK (MinimalSupportExisting in ('Y','N')),
			MinimalSupportClient						type_YOrN					NULL
														CHECK (MinimalSupportClient in ('Y','N')),
			NoSupportSources							type_YOrN					NULL
														CHECK (NoSupportSources in ('Y','N')),										
			FullyResponsiveNoPriorExperience			type_YOrN					NULL
														CHECK (FullyResponsiveNoPriorExperience in ('Y','N')),
			FullyResponsivePriorExperience				type_YOrN					NULL
														CHECK (FullyResponsivePriorExperience in ('Y','N')),
			FullyResponsiveSuccessful					type_YOrN					NULL
														CHECK (FullyResponsiveSuccessful in ('Y','N')),
			SignificantResponsePrevious					type_YOrN					NULL
														CHECK (SignificantResponsePrevious in ('Y','N')),
			SignificantResponseRecovery					type_YOrN					NULL
														CHECK (SignificantResponseRecovery in ('Y','N')),
			ModerateResponseCurrentTreatment			type_YOrN					NULL
														CHECK (ModerateResponseCurrentTreatment in ('Y','N')),
			ModerateResponsePreviousTreatment			type_YOrN					NULL
														CHECK (ModerateResponsePreviousTreatment in ('Y','N')),
			ModerateResponseUnclear						type_YOrN					NULL
														CHECK (ModerateResponseUnclear in ('Y','N')),
			ModerateResponseLeastPartial				type_YOrN					NULL
														CHECK (ModerateResponseLeastPartial in ('Y','N')),
			PoorResponsePrevious						type_YOrN					NULL
														CHECK (PoorResponsePrevious in ('Y','N')),
			PoorResponseAttempts						type_YOrN					NULL
														CHECK (PoorResponseAttempts in ('Y','N')),
			NegligibleResponsePast						type_YOrN					NULL
														CHECK (NegligibleResponsePast in ('Y','N')),
			NegligibleResponseSymptoms					type_YOrN					NULL
														CHECK (NegligibleResponseSymptoms in ('Y','N')),										
			OptimalEngagementComplete					type_YOrN					NULL
														CHECK (OptimalEngagementComplete in ('Y','N')),
			OptimalEngagementActively					type_YOrN					NULL
														CHECK (OptimalEngagementActively in ('Y','N')),
			OptimalEngagementEnthusiastic				type_YOrN					NULL
														CHECK (OptimalEngagementEnthusiastic in ('Y','N')),
			OptimalEngagementUnderstands				type_YOrN					NULL
														CHECK (OptimalEngagementUnderstands in ('Y','N')),
			PositiveEngagementSignificant				type_YOrN					NULL
														CHECK (PositiveEngagementSignificant in ('Y','N')),
			PositiveEngagementWilling					type_YOrN					NULL
														CHECK (PositiveEngagementWilling in ('Y','N')),
			PositiveEngagementPositive					type_YOrN					NULL
														CHECK (PositiveEngagementPositive in ('Y','N')),
			PositiveEngagementShows						type_YOrN					NULL
														CHECK (PositiveEngagementShows in ('Y','N')),
			LimitedEngagementSomeVariability			type_YOrN					NULL
														CHECK (LimitedEngagementSomeVariability in ('Y','N')),
			LimitedEngagementLimitedDesire				type_YOrN					NULL
														CHECK (LimitedEngagementLimitedDesire in ('Y','N')),
			LimitedEngagementRelatesToTreatment			type_YOrN					NULL
														CHECK (LimitedEngagementRelatesToTreatment in ('Y','N')),
			LimitedEngagementNotUseResources			type_YOrN					NULL
														CHECK (LimitedEngagementNotUseResources in ('Y','N')),
			LimitedEngagementLimitedAbility				type_YOrN					NULL
														CHECK (LimitedEngagementLimitedAbility in ('Y','N')),
			MinimalEngagementRarely						type_YOrN					NULL
														CHECK (MinimalEngagementRarely in ('Y','N')),
			MinimalEngagementNoDesire					type_YOrN					NULL
														CHECK (MinimalEngagementNoDesire in ('Y','N')),
			MinimalEngagementRelatesPoorly				type_YOrN					NULL
														CHECK (MinimalEngagementRelatesPoorly in ('Y','N')),
			MinimalEngagementAvoidsContact				type_YOrN					NULL
														CHECK (MinimalEngagementAvoidsContact in ('Y','N')),
			MinimalEngagementNotAccept					type_YOrN					NULL
														CHECK (MinimalEngagementNotAccept in ('Y','N')),
			UnengagedNoAwareness						type_YOrN					NULL
														CHECK (UnengagedNoAwareness in ('Y','N')),
			UnengagedInability							type_YOrN					NULL
														CHECK (UnengagedInability in ('Y','N')),
			UnengagedUnable								type_YOrN					NULL
														CHECK (UnengagedUnable in ('Y','N')),
			UnengagedExtremely							type_YOrN					NULL
														CHECK (UnengagedExtremely in ('Y','N')),										
			LocusScore									decimal(18,2)				NULL,
			RiskOfHarmScore								decimal(18,2)				NULL,
			FunctionalStatusScore						decimal(18,2)				NULL,
			MedicalAddictiveScore						decimal(18,2)				NULL,
			RecoveryEnvironmentStressScore				decimal(18,2)				NULL,
			RecoveryEnvironmentSupportScore				decimal(18,2)				NULL,
			TreatmentRecoveryScore						decimal(18,2)				NULL,
			EngagementScore								decimal(18,2)				NULL,
			EvaluationNotes								type_Comment2				NULL,
			CONSTRAINT DocumentLOCUS_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('DocumentLOCUS') IS NOT NULL
    PRINT '<<< CREATED TABLE DocumentLOCUS >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE DocumentLOCUS >>>', 16, 1)
   
/* 
 * TABLE: DocumentLOCUS 
 */ 
 
ALTER TABLE DocumentLOCUS ADD CONSTRAINT DocumentVersions_DocumentLOCUS_FK 
	FOREIGN KEY (DocumentVersionId)
	REFERENCES DocumentVersions(DocumentVersionId)	
		
	PRINT 'STEP 4(A) COMPLETED'
END


-- Script for key DefaultReleaseCheckToProvider  in System Configuration Keys table


IF NOT EXISTS (
  SELECT [key]
  FROM SystemConfigurationKeys
  WHERE [key] = 'EnableLOCUS'
  )
BEGIN
 INSERT INTO [dbo].[SystemConfigurationKeys] (
  CreatedBy
  ,CreateDate
  ,ModifiedBy
  ,ModifiedDate
  ,[Key]
  ,Value
  ,[Description]
  )
 VALUES (
  'SHSDBA'
  ,GETDATE()
  ,'SHSDBA'
  ,GETDATE()
  ,'EnableLOCUS'
  ,'N'  --Default this setting to ‘N’
  ,'Enable/ Disable LOCUS to use by customer'
  )
END


----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.58)
BEGIN
Update SystemConfigurations set DataModelVersion=15.59
PRINT 'STEP 7 COMPLETED'
END
Go