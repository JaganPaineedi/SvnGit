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
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentSUAdmissions')
BEGIN
/* 
 * TABLE: CustomDocumentSUAdmissions 
 */
 CREATE TABLE CustomDocumentSUAdmissions( 
		DocumentVersionId					int						NOT NULL,
		CreatedBy							type_CurrentUser		NOT NULL,
		CreatedDate							type_CurrentDatetime	NOT NULL,
		ModifiedBy							type_CurrentUser		NOT NULL,
		ModifiedDate						type_CurrentDatetime	NOT NULL,
		RecordDeleted						type_YOrN				NULL
											CHECK (RecordDeleted in ('Y','N')),
		DeletedBy							type_UserId				NULL,
		DeletedDate							datetime				NULL,
		ProgramId							int						NULL,
		AdmissionEntryDate					datetime				NULL,
		AssessmentDate						datetime				NULL,
		AdmissionType						type_GlobalCode			NULL,
		AdmissionProgramType				type_GlobalCode			NULL,
		ReferralSource						type_GlobalCode			NULL,
		SourceOfPayment						type_GlobalCode			NULL,
		PregnantAdmission					type_YOrNOrNA			NULL
											CHECK (PregnantAdmission in ('Y','N','A')),
		PriorEpisode						type_GlobalCode			NULL,
		SocialSupports						type_GlobalCode			NULL,
		VeteransStatus						type_GlobalCode			NULL,
		AdmittedPopulation					type_GlobalCode			NULL,
		AdmittedASAM						type_GlobalCode			NULL,
		ReferredASAM						type_GlobalCode			NULL,
		StateCode							type_GlobalCode			NULL,
		NumberOfArrests						int						NULL,
		NumberOfArrestsLast12Months			int						NULL,
		DrugCourtParticipation				type_GlobalCode			NULL,		
		CurrentlyOnProbation				type_YesNoUnknown		NULL
											CHECK (CurrentlyOnProbation in ('Y','N','U')),
		Jurisdiction						type_YesNoUnknown		NULL
											CHECK (Jurisdiction in ('Y','N','U')),
		CurrentlyOnParole					type_YesNoUnknown		NULL
											CHECK (CurrentlyOnParole in ('Y','N','U')),
		LivingArrangement					type_GlobalCode			NULL,
		Household							varchar(100)			NULL,
		Children							varchar(100)			NULL,
		HouseholdIncome						varchar(100)			NULL,
		MaritalStatus						type_GlobalCode			NULL,
		EmploymentStatus					type_GlobalCode			NULL,
		PrimarySourceOfIncome				type_GlobalCode			NULL,
		EnrolledEducation					type_GlobalCode			NULL,
		EducationCompleted					type_GlobalCode			NULL,
		Gender								type_GlobalCode			NULL,
		Race								type_GlobalCode			NULL,
		Ethnicity							type_GlobalCode			NULL,
		CoDependent							type_YOrN				NULL
											CHECK (CoDependent in ('Y','N')),
		CoOccurringMentalHealth				type_YOrN				NULL
											CHECK (CoOccurringMentalHealth in ('Y','N')),
		PharmocotherapyPlanned				type_YOrN				NULL
											CHECK (PharmocotherapyPlanned in ('Y','N')),		
		TobaccoUse							type_GlobalCode			NULL,
		AgeOfFirstTobaccoText				varchar(25)				NULL,
		AgeOfFirstTobacco					char(1)					NULL
											CHECK (AgeOfFirstTobacco in ('U','N')),
		PreferredUsage1						type_GlobalCode			NULL,
		DrugName1							type_GlobalCode			NULL,
		Severity1							type_GlobalCode			NULL,
		Frequency1							type_GlobalCode			NULL,
		Route1								type_GlobalCode			NULL,
		AgeOfFirstUseText1					varchar(25)				NULL,
		AgeOfFirstUse1						char(1)					NULL
											CHECK (AgeOfFirstUse1 in ('U','N')),
		PreferredUsage2						type_GlobalCode			NULL,
		DrugName2							type_GlobalCode			NULL,
		Severity2							type_GlobalCode			NULL,
		Frequency2							type_GlobalCode			NULL,
		Route2								type_GlobalCode			NULL,
		AgeOfFirstUseText2					varchar(25)				NULL,
		AgeOfFirstUse2						char(1)					NULL
											CHECK (AgeOfFirstUse2 in ('U','N')),
		PreferredUsage3						type_GlobalCode			NULL,
		DrugName3							type_GlobalCode			NULL,
		Severity3							type_GlobalCode			NULL,
		Frequency3							type_GlobalCode			NULL,		
		Route3								type_GlobalCode			NULL,
		AgeOfFirstUseText3					varchar(25)				NULL,
		AgeOfFirstUse3						char(1)					NULL
											CHECK (AgeOfFirstUse3 in ('U','N')),
		CONSTRAINT CustomDocumentSUAdmissions_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('CustomDocumentSUAdmissions') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentSUAdmissions >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentSUAdmissions >>>', 16, 1)
/* 
 * TABLE: CustomDocumentSUAdmissions 
 */   
  
ALTER TABLE CustomDocumentSUAdmissions ADD CONSTRAINT DocumentVersions_CustomDocumentSUAdmissions_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
ALTER TABLE CustomDocumentSUAdmissions ADD CONSTRAINT Programs_CustomDocumentSUAdmissions_FK
    FOREIGN KEY (ProgramId)
    REFERENCES Programs(ProgramId)
        
     PRINT 'STEP 4(A)COMPLETED'
 END
 
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentInfectiousDiseaseRiskAssessments')
BEGIN
/* 
 * TABLE: CustomDocumentInfectiousDiseaseRiskAssessments 
 */
 CREATE TABLE CustomDocumentInfectiousDiseaseRiskAssessments( 
		DocumentVersionId							int						NOT NULL,
		CreatedBy									type_CurrentUser		NOT NULL,
		CreatedDate									type_CurrentDatetime	NOT NULL,
		ModifiedBy									type_CurrentUser		NOT NULL,
		ModifiedDate								type_CurrentDatetime	NOT NULL,
		RecordDeleted								type_YOrN				NULL
													CHECK (RecordDeleted in ('Y','N')),
		DeletedBy									type_UserId				NULL,
		DeletedDate									datetime				NULL,
		AnyHealthCareProvider						type_YesNoUnknown		NULL
													CHECK (AnyHealthCareProvider in ('Y','N','U')),
		LivedStreetOrShelter						type_YesNoUnknown		NULL
													CHECK (LivedStreetOrShelter in ('Y','N','U')),
		EverBeenJailPrisonJuvenile					type_YesNoUnknown		NULL
													CHECK (EverBeenJailPrisonJuvenile in ('Y','N','U')),
		EverBeenCareFacility						type_YesNoUnknown		NULL
													CHECK (EverBeenCareFacility in ('Y','N','U')),
		WhereBorn									Varchar(50)				NULL,
		TraveledOrLivedOutsideUS					type_YesNoUnknown		NULL
													CHECK (TraveledOrLivedOutsideUS in ('Y','N','U')),
		HowLongBeenInUS								Varchar(50)				NULL,
		CombatVeteran								type_YesNoUnknown		NULL
													CHECK (CombatVeteran in ('Y','N','U')),
		HadTatooEarPiercingAcupunture				type_YesNoUnknown		NULL
													CHECK (HadTatooEarPiercingAcupunture in ('Y','N','U')),
		Nausea										type_YOrN				NULL
													CHECK (Nausea in ('Y','N')),
		Fever										type_YOrN				NULL
													CHECK (Fever in ('Y','N')),
		DrenchingNightSweats						type_YOrN				NULL
													CHECK (DrenchingNightSweats in ('Y','N')),
		ProductiveCough								type_YOrN				NULL
													CHECK (ProductiveCough in ('Y','N')),
		CoughingUpBlood								type_YOrN				NULL
													CHECK (CoughingUpBlood in ('Y','N')),
		ShortnessOfBreath							type_YOrN				NULL
													CHECK (ShortnessOfBreath in ('Y','N')),
		LumpsSwollenGlands							type_YOrN				NULL
													CHECK (LumpsSwollenGlands in ('Y','N')),
		DiarrheaLastingMoreThanWeek					type_YOrN				NULL
													CHECK (DiarrheaLastingMoreThanWeek in ('Y','N')),
		LosingWeightWithoutMeaning					type_YOrN				NULL
													CHECK (LosingWeightWithoutMeaning in ('Y','N')),
		BrownTingedUrine							type_YOrN				NULL
													CHECK (BrownTingedUrine in ('Y','N')),
		ExtremeFatigue								type_YOrN				NULL
													CHECK (ExtremeFatigue in ('Y','N')),
		Jaundice 									type_YOrN				NULL
													CHECK (Jaundice in ('Y','N')),
		NoSymptoms									type_YOrN				NULL
													CHECK (NoSymptoms in ('Y','N')),
		MissedLastTwoPeriods						type_YOrNOrNA			NULL
													CHECK (MissedLastTwoPeriods in ('Y','N','A')),
		WomanMissedLast2Periods						Varchar(100)			NULL,													
		EverBeenToldYouHaveTB						type_YesNoUnknown		NULL
													CHECK (EverBeenToldYouHaveTB in ('Y','N','U')),
		EverBeenHadPositiveSkinTestTB				type_YesNoUnknown		NULL
													CHECK (EverBeenHadPositiveSkinTestTB in ('Y','N','U')),
		EverBeenTreatedForTB						type_YesNoUnknown		NULL
													CHECK (EverBeenTreatedForTB in ('Y','N','U')),
		EverBeenToldYouHaveHepatitisA				type_YesNoUnknown		NULL
													CHECK (EverBeenToldYouHaveHepatitisA in ('Y','N','U')),
		EverBeenToldYouHaveHepatitisB				type_YesNoUnknown		NULL
													CHECK (EverBeenToldYouHaveHepatitisB in ('Y','N','U')),
		EverBeenToldYouHaveHepatitisC				type_YesNoUnknown		NULL
													CHECK (EverBeenToldYouHaveHepatitisC in ('Y','N','U')),
		EverUsedNeedlesToShootDrugs					type_YesNoUnknown		NULL
													CHECK (EverUsedNeedlesToShootDrugs in ('Y','N','U')),
		EverSharedNeedlesSyringesToInjectDrugs		type_YesNoUnknown		NULL
													CHECK (EverSharedNeedlesSyringesToInjectDrugs in ('Y','N','U')),
		EverHadNeedleStickInjuriesOrBloodContact	type_YesNoUnknown		NULL
													CHECK (EverHadNeedleStickInjuriesOrBloodContact in ('Y','N','U')),
		UseStimulants								type_YesNoUnknown		NULL
													CHECK (UseStimulants in ('Y','N','U')),
		PastTwelveMonthsHadSexWithAnyWithHepatitis	type_YesNoUnknown		NULL
													CHECK (PastTwelveMonthsHadSexWithAnyWithHepatitis in ('Y','N','U')),
		ReceiveBloodTransfusionBefore1992			type_YesNoUnknown		NULL
													CHECK (ReceiveBloodTransfusionBefore1992 in ('Y','N','U')),
		ReceivedBloodProductsBefore1987				type_YesNoUnknown		NULL
													CHECK (ReceivedBloodProductsBefore1987 in ('Y','N','U')),
		BirthMotherInfectedWithHepatitisC			type_YesNoUnknown		NULL
													CHECK (BirthMotherInfectedWithHepatitisC in ('Y','N','U')),
		EverBeenLongTermKidneyDialysis				type_YesNoUnknown		NULL
													CHECK (EverBeenLongTermKidneyDialysis in ('Y','N','U')),
		UnprotectedSexWithHemophiliaPatient			type_YesNoUnknown		NULL
													CHECK (UnprotectedSexWithHemophiliaPatient in ('Y','N','U')),
		UnprotectedSexWithManWithOtherMen			type_YesNoUnknown		NULL
													CHECK (UnprotectedSexWithManWithOtherMen in ('Y','N','U')),
		HadSexExchangeMoneyOrDrugs					type_YesNoUnknown		NULL
													CHECK (HadSexExchangeMoneyOrDrugs in ('Y','N','U')),
		HadSexMoreThanOnePersonPastSixMonths		type_YesNoUnknown		NULL
													CHECK (HadSexMoreThanOnePersonPastSixMonths in ('Y','N','U')),
		HadSexWithAIDSPersonOrHepatitisC			type_YesNoUnknown		NULL
													CHECK (HadSexWithAIDSPersonOrHepatitisC in ('Y','N','U')),
		EverInjectedDrugsEvenOnce					type_YesNoUnknown		NULL
													CHECK (EverInjectedDrugsEvenOnce in ('Y','N','U')),
		EvenBeenPrickedByNeedle						type_YesNoUnknown		NULL
													CHECK (EvenBeenPrickedByNeedle in ('Y','N','U')),
		EverHadDrinkingProblemCounselling			type_YesNoUnknown		NULL
													CHECK (EverHadDrinkingProblemCounselling in ('Y','N','U')),
		EverBeenToldDrinkingProblem					type_YesNoUnknown		NULL
													CHECK (EverBeenToldDrinkingProblem in ('Y','N','U')),
		EverHadBloodTestForHIVAntibody				type_YOrN				NULL
													CHECK (EverHadBloodTestForHIVAntibody in ('Y','N')),
		BeenTestedWithinLastSixMonthsHIV			type_YOrN				NULL
													CHECK (BeenTestedWithinLastSixMonthsHIV in ('Y','N')),
		WouldYouLikeBloodTestHIV					type_YOrN				NULL
													CHECK (WouldYouLikeBloodTestHIV in ('Y','N')),
		EverHadBloodTestForHepatitisC				type_YOrN				NULL
													CHECK (EverHadBloodTestForHepatitisC in ('Y','N')),
		BeenTestedWithinLastSixMonthsHepatitisC		type_YOrN				NULL
													CHECK (BeenTestedWithinLastSixMonthsHepatitisC in ('Y','N')),
		WouldYouLikeBloodTestHepatitisC				type_YOrN				NULL
													CHECK (WouldYouLikeBloodTestHepatitisC in ('Y','N')),
		JudgeOwnRiskInfectedWithHIV					char(1)					NULL
													CHECK (JudgeOwnRiskInfectedWithHIV in ('I','H','L','N','S')),
		JudgeOwnRiskInfectedWithHepatitisC			char(1)					NULL
													CHECK (JudgeOwnRiskInfectedWithHepatitisC in ('I','H','L','N','S')),
		ClientAssessed								type_YOrN				NULL
													CHECK (ClientAssessed in ('Y','N')),
		ClientReferredHealthOrAgency				type_YOrN				NULL
													CHECK (ClientReferredHealthOrAgency in ('Y','N')),
		ClientReferredWhere							Varchar(100)			NULL,
		CONSTRAINT CustomDocumentInfectiousDiseaseRiskAssessments_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('CustomDocumentInfectiousDiseaseRiskAssessments') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentInfectiousDiseaseRiskAssessments >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentInfectiousDiseaseRiskAssessments >>>', 16, 1)
/* 
 * TABLE: CustomDocumentInfectiousDiseaseRiskAssessments 
 */   
  
ALTER TABLE CustomDocumentInfectiousDiseaseRiskAssessments ADD CONSTRAINT DocumentVersions_CustomDocumentInfectiousDiseaseRiskAssessments_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
     PRINT 'STEP 4(B)COMPLETED'
 END
 
 
  ---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------


IF NOT EXISTS (SELECT [key] FROM SystemConfigurationKeys WHERE [key] = 'CDM_SUAdmission')
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
				   ,'CDM_SUAdmission'
				   ,'1.0'
				   )
		PRINT 'STEP 7 COMPLETED'
	END
 GO


		