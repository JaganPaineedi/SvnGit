----- STEP 1 ----------

------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------
IF OBJECT_ID('CustomAcuteServicesPrescreens') IS NOT NULL
BEGIN
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomicidePlanDetails') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomicidePlanDetails  type_GlobalCode  NULL           
	END	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomicidePlanAvailability') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomicidePlanAvailability  type_GlobalCode  NULL           
	END	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomicidePlanTime') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomicidePlanTime  type_GlobalCode  NULL           
	END
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomicidePlanLethalityMethod') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomicidePlanLethalityMethod  type_GlobalCode  NULL           
	END
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomisideAttempts') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomisideAttempts  type_GlobalCode  NULL           
	END
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomisideIsolation') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomisideIsolation  type_GlobalCode  NULL           
	END	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomisideProbabilityTiming') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomisideProbabilityTiming  type_GlobalCode  NULL           
	END	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomisidePrecaution') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomisidePrecaution  type_GlobalCode  NULL           
	END	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomisideActingToGetHelp') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomisideActingToGetHelp  type_GlobalCode  NULL           
	END	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomisideFinalAct') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomisideFinalAct  type_GlobalCode  NULL           
	END	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomisideActiveForAttempt') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomisideActiveForAttempt  type_GlobalCode  NULL           
	END
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomisideSucideNote') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomisideSucideNote  type_GlobalCode  NULL           
	END	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomisideOvertCommunication') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomisideOvertCommunication  type_GlobalCode  NULL           
	END	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomisideAllegedPurposed') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomisideAllegedPurposed  type_GlobalCode  NULL           
	END
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomisideExpectationFatality') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomisideExpectationFatality  type_GlobalCode  NULL           
	END
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomisideConceptionOfMethod') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomisideConceptionOfMethod  type_GlobalCode  NULL           
	END
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomisideSeriousnessOfAttempt') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomisideSeriousnessOfAttempt  type_GlobalCode  NULL           
	END
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomisideAttitudeLivingDying') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomisideAttitudeLivingDying  type_GlobalCode  NULL           
	END
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomisideMedicalStatus') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomisideMedicalStatus  type_GlobalCode  NULL           
	END
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomisideConceptMedicalRescue') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomisideConceptMedicalRescue  type_GlobalCode  NULL           
	END	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomisideDegreePremeditation') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomisideDegreePremeditation  type_GlobalCode  NULL           
	END	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomisideStress') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomisideStress  type_GlobalCode  NULL           
	END	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomisideCopingBehavior') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomisideCopingBehavior  type_GlobalCode  NULL           
	END	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomisideDepression') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomisideDepression  type_GlobalCode  NULL           
	END	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomisideResource') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomisideResource  type_GlobalCode  NULL           
	END	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomisideLifeStyle') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomisideLifeStyle  type_GlobalCode  NULL           
	END
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomisideTotalScore') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomisideTotalScore  decimal(18,2)  NULL           
	END
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicideHomisideComments') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicideHomisideComments  type_Comment2  NULL           
	END
IF COL_LENGTH('CustomAcuteServicesPrescreens','Recommendations') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD Recommendations  type_Comment2  NULL           
	END
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskActionTakenMedicalER') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskActionTakenMedicalER  type_YOrN  NULL
													  CHECK (RiskActionTakenMedicalER in ('Y','N'))        
	END		
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskActionTakenPsychiatricPlacement') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskActionTakenPsychiatricPlacement  type_YOrN  NULL
													  CHECK (RiskActionTakenPsychiatricPlacement in ('Y','N'))        
	END
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskActionTakenPsychiatricPlacementVoluntary') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskActionTakenPsychiatricPlacementVoluntary  type_YOrN  NULL
													  CHECK (RiskActionTakenPsychiatricPlacementVoluntary in ('Y','N'))        
	END		
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskActionTakenPsychiatricPlacementInVoluntary') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskActionTakenPsychiatricPlacementInVoluntary  type_YOrN  NULL
													  CHECK (RiskActionTakenPsychiatricPlacementInVoluntary in ('Y','N'))        
	END		
IF COL_LENGTH('CustomAcuteServicesPrescreens','ActionTakenPsychiatricPlacementHospital') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD ActionTakenPsychiatricPlacementHospital  type_GlobalCode  NULL           
	END		
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskActionDirectorsHoldPlaced') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskActionDirectorsHoldPlaced  type_YOrN  NULL
													  CHECK (RiskActionDirectorsHoldPlaced in ('Y','N'))        
	END	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskActionSecureTransport') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskActionSecureTransport  type_YOrN  NULL
													  CHECK (RiskActionSecureTransport in ('Y','N'))        
	END	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskActionSecureTransportCompanyName') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskActionSecureTransportCompanyName  varchar(max)  NULL									       
	END		
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskActionTakenCrisisRespiteBed') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskActionTakenCrisisRespiteBed  type_YOrN  NULL
													  CHECK (RiskActionTakenCrisisRespiteBed in ('Y','N'))        
	END		
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskActionTakenCrisisRespiteBedWithPsych') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskActionTakenCrisisRespiteBedWithPsych  type_YOrN  NULL
													  CHECK (RiskActionTakenCrisisRespiteBedWithPsych in ('Y','N'))        
	END			
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskActionTakenCrisisRespiteBedWithoutPsych') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskActionTakenCrisisRespiteBedWithoutPsych  type_YOrN  NULL
													  CHECK (RiskActionTakenCrisisRespiteBedWithoutPsych in ('Y','N'))        
	END		
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskActionTakenJail') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskActionTakenJail  type_YOrN  NULL
													  CHECK (RiskActionTakenJail in ('Y','N'))        
	END	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskActionSocialDextorBed') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskActionSocialDextorBed  type_YOrN  NULL
													  CHECK (RiskActionSocialDextorBed in ('Y','N'))        
	END
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSentHomeAlone') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSentHomeAlone  type_YOrN  NULL
													  CHECK (RiskSentHomeAlone in ('Y','N'))        
	END	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSentHomeWithRelative') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSentHomeWithRelative  type_YOrN  NULL
													  CHECK (RiskSentHomeWithRelative in ('Y','N'))        
	END		
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskRefferedToFollowNextDay') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskRefferedToFollowNextDay  type_YOrN  NULL
													  CHECK (RiskRefferedToFollowNextDay in ('Y','N'))        
	END		
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskReferedToPrivateProvider') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskReferedToPrivateProvider  type_YOrN  NULL
													  CHECK (RiskReferedToPrivateProvider in ('Y','N'))        
	END	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskReferedToPrivateProviderName') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskReferedToPrivateProviderName  varchar(MAX)  NULL
	END
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskRefferedPyschiatristPMNHP') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskRefferedPyschiatristPMNHP  type_YOrN  NULL
													  CHECK (RiskRefferedPyschiatristPMNHP in ('Y','N'))        
	END	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskReferedToOther') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskReferedToOther  type_YOrN  NULL
													  CHECK (RiskReferedToOther in ('Y','N'))        
	END	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskReferedToOtherSpecify') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskReferedToOtherSpecify  varchar(MAX)  NULL
	END
	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicidePresentingDangersSuicide') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicidePresentingDangersSuicide  type_GlobalCode  NULL           
	END		
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicidePresentingDangersOtherHarmToSelf') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicidePresentingDangersOtherHarmToSelf  type_GlobalCode  NULL           
	END			
	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicidePresentingDangersHarmToOthers') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicidePresentingDangersHarmToOthers  type_GlobalCode  NULL           
	END	
IF COL_LENGTH('CustomAcuteServicesPrescreens','RiskSuicidePresentingDangersHarmToProperty') IS NULL
	BEGIN
		ALTER TABLE CustomAcuteServicesPrescreens ADD RiskSuicidePresentingDangersHarmToProperty  type_GlobalCode  NULL           
	END
END
------ END OF STEP 3 -----

------ STEP 4 ----------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomAcuteServicesPrescreens')
BEGIN  
/* 
 * TABLE: CustomAcuteServicesPrescreens 
 */
 CREATE TABLE CustomAcuteServicesPrescreens(
    DocumentVersionId							int 						NOT NULL,
    CreatedBy									type_CurrentUser			NOT NULL,
    CreatedDate									type_CurrentDatetime		NOT NULL,
    ModifiedBy									type_CurrentUser			NOT NULL,
    ModifiedDate								type_CurrentDatetime		NOT NULL,
    RecordDeleted								type_YOrN					NULL
												CHECK (RecordDeleted in ('Y','N')),
    DeletedDate									datetime					NULL,
    DeletedBy									type_UserId					NULL,
    DateOfPrescreen								datetime					NULL,
	InitialCallTime								datetime					NULL,
	ClientAvailableTimeForScreen				datetime					NULL,
	DispositionTime								datetime					NULL,
	ElapsedHours								int							NULL,
	ElapsedMinutes								int							NULL,
	CMHStatus									char(1)						NULL,
	CMHStatusPrimaryClinician					int							NULL,
	CMHCaseNumber								varchar(20)					NULL,
	ClientName									varchar(100)				NULL,
	ClientEthnicity								char(2)						NULL,
	ClientSex									type_Sex					NULL,
												CHECK (ClientSex in ('U','F','M')),
	ClientMaritalStatus							char(2)						NULL,
	ClientSSN									type_SSN					NULL,
	ClientDateOfBirth							datetime					NULL,
	ClientAddress								varchar(max)				NULL,
	ClientCity									type_City					NULL,
	ClientState									type_State					NULL,
	ClientZip									type_ZipCode				NULL,
	ClientCounty								type_County					NULL,
	ClientHomePhone								type_PhoneNumber			NULL,
	ClientEmergencyContact						varchar(100)				NULL,
	ClientRelationship							type_GlobalCode				NULL,
	ClientEmergencyPhone						type_PhoneNumber			NULL,
	ClientGuardianName							varchar(100)				NULL,
	ClientGuardianPhone							type_PhoneNumber			NULL,
	PaymentSourceIndigent						type_YOrN					NULL
												CHECK (PaymentSourceIndigent in ('Y','N')),
	PaymentSourcePrivate						type_YOrN					NULL
												CHECK (PaymentSourcePrivate in ('Y','N')),
	PaymentSourcePrivateEmployer				varchar(100)				NULL,
	PaymentSourcePrivateNumber					varchar(25)					NULL,
	PaymentSourceMedicare						type_YOrN					NULL
												CHECK (PaymentSourceMedicare in ('Y','N')),
	PaymentSourceMedicareNumber					varchar(25)					NULL,
	PaymentSourceMedicaid						type_YOrN					NULL
												CHECK (PaymentSourceMedicaid in ('Y','N')),
	PaymentSourceMedicaidNumber					varchar(25)					NULL,
	PaymentSourceMedicaidType					varchar(25)					NULL,
	PaymentMedicaidOtherCounty					type_Comment2				NULL,
	PaymentSourceVA								type_YOrN					NULL
												CHECK (PaymentSourceVA in ('Y','N')),
	PaymentSourceOther							type_YOrN					NULL
												CHECK (PaymentSourceOther in ('Y','N')),
	PaymentSourceOtherDescribe					varchar(100)				NULL,
	PaymentMedicaidVerified						type_YOrN					NULL
												CHECK (PaymentMedicaidVerified in ('Y','N')),
	ServiceRequested							type_Comment2				NULL,
	ClientRecentLocation						type_Comment2				NULL,
	ClientBelongingsLocation					type_Comment2				NULL,
	ClientMailLocation							type_Comment2				NULL,
	ClientReturnLocation						type_Comment2				NULL,
	ClientFromDifferentCounty					type_Comment2				NULL,
	ClientPriorLivingArrangement				type_Comment2				NULL,
	ClientIsWardofState							type_Comment2				NULL,
	ClientIsWardofStateCountyDetail				type_Comment2				NULL,
	COFRAdditionalInformation					type_Comment2				NULL,
	COFROtherCountyDetail						type_Comment2				NULL,
	ReferralSourceName							varchar(100)				NULL,
	ReferralSourcePhoneLocation					varchar(100)				NULL,
	ReferralSourceContacted						type_YOrN					NULL
												CHECK (ReferralSourceContacted in ('Y','N')),
	ReferralSourceContactedExplain				type_Comment2				NULL,
	ReferralSourceJailLiason					type_YOrN					NULL
												CHECK (ReferralSourceJailLiason in ('Y','N')),
	ReferralSourceFamilyMember					type_YOrN					NULL
												CHECK (ReferralSourceFamilyMember in ('Y','N')),
	ReferralSourcePhysician						type_YOrN					NULL
												CHECK (ReferralSourcePhysician in ('Y','N')),
	ReferralSourceMHProvider					type_YOrN					NULL
												CHECK (ReferralSourceMHProvider in ('Y','N')),
	ReferralSourcePetitioned					type_YOrN					NULL
												CHECK (ReferralSourcePetitioned in ('Y','N')),
	ReferralSourceOther							type_YOrN					NULL
												CHECK (ReferralSourceOther in ('Y','N')),
	ReferralSourceOtherSpecify					varchar(100)				NULL,
	ReferralContactTypeFaceToFace				type_YOrN					NULL
												CHECK (ReferralContactTypeFaceToFace in ('Y','N')),
	ReferralContactTypePhone					type_YOrN					NULL
												CHECK (ReferralContactTypePhone in ('Y','N')),
	ReferralContactTypePreBooking				type_YOrN					NULL
												CHECK (ReferralContactTypePreBooking in ('Y','N')),
	ReferralContactTypePostBooking				type_YOrN					NULL
												CHECK (ReferralContactTypePostBooking in ('Y','N')),
	ReferralPrecipitatingEvents					type_Comment2				NULL,
	RiskOthersAAgressiveWithin24Hours			type_YOrN					NULL
												CHECK (RiskOthersAAgressiveWithin24Hours in ('Y','N')),
	RiskOthersAgressivePast48Hours				type_YOrN					NULL
												CHECK (RiskOthersAgressivePast48Hours in ('Y','N')),
	RiskOthersAgressiveWithinPast4Weeks			type_YOrN					NULL
												CHECK (RiskOthersAgressiveWithinPast4Weeks in ('Y','N')),
	RiskOthersCurrentHomicidalIdeation			type_YOrN					NULL
												CHECK (RiskOthersCurrentHomicidalIdeation in ('Y','N')),
	RiskOthersCurrentHomicidalActive			type_YOrN					NULL
												CHECK (RiskOthersCurrentHomicidalActive in ('Y','N')),
	RiskOthersCurrentHomicidalWithin48Hours		type_YOrN					NULL
												CHECK (RiskOthersCurrentHomicidalWithin48Hours in ('Y','N')),
	RiskOthersCurrentHomicidalWithin14Days		type_YOrN					NULL
												CHECK (RiskOthersCurrentHomicidalWithin14Days in ('Y','N')),
	RiskOthersAWOL								type_YOrN					NULL
												CHECK (RiskOthersAWOL in ('Y','N')),
	RiskOthersVerbal							type_YOrN					NULL
												CHECK (RiskOthersVerbal in ('Y','N')),
	RiskOthersPhysical							type_YOrN					NULL
												CHECK (RiskOthersPhysical in ('Y','N')),
	RiskOthersSexualActingOut					type_YOrN					NULL
												CHECK (RiskOthersSexualActingOut in ('Y','N')),
	RiskOthersDestructionOfProperty				type_YOrN					NULL
												CHECK (RiskOthersDestructionOfProperty in ('Y','N')),
	RiskOthersDestructionOfPropertyDescribe		type_Comment2				NULL,
	RiskOthersHasPlan							type_YOrN					NULL
												CHECK (RiskOthersHasPlan in ('Y','N')),
	RiskOthersHasPlanDescribe					type_Comment2				NULL,
	RiskOthersAccessToMeans						type_YOrN					NULL
												CHECK (RiskOthersAccessToMeans in ('Y','N')),
	RiskOthersAccessToMeansDescribe				type_Comment2				NULL,
	RiskOthersVerbalDescribe					type_Comment2				NULL,
	RiskOthersPhysicalDescribe					type_Comment2				NULL,
	RiskOthersSexualActingOutDescribe			type_Comment2				NULL,
	RiskOthersHistory							type_Comment2				NULL,
	RiskOthersChargesPending					type_YOrN					NULL
												CHECK (RiskOthersChargesPending in ('Y','N')),
	RiskOthersChargesPendingDescribe			type_Comment2				NULL,
	RiskOthersJailHold							type_YOrN					NULL
												CHECK (RiskOthersJailHold in ('Y','N')),
	RiskSelfCurrentSuicidalIdeation				type_YOrN					NULL
												CHECK (RiskSelfCurrentSuicidalIdeation in ('Y','N')),
	RiskSelfCurrentSuicidalActive				type_YOrN					NULL
												CHECK (RiskSelfCurrentSuicidalActive in ('Y','N')),
	RiskSelfCurrentSuicidalWithin48Hours		type_YOrN					NULL
												CHECK (RiskSelfCurrentSuicidalWithin48Hours in ('Y','N')),
	RiskSelfCurrentSuicidalWithin14Days			type_YOrN					NULL
												CHECK (RiskSelfCurrentSuicidalWithin14Days in ('Y','N')),
	RiskSelfHasPlan								type_YOrN					NULL
												CHECK (RiskSelfHasPlan in ('Y','N')),
	RiskSelfHasPlanDescribe						type_Comment2				NULL,
	RiskSelfEgoSyntonic							type_YOrN					NULL
												CHECK (RiskSelfEgoSyntonic in ('Y','N')),
	RiskSelfEgoDystonic							type_YOrN					NULL
												CHECK (RiskSelfEgoDystonic in ('Y','N')),
	RiskSelfEgoDescribe							type_Comment2				NULL,
	RiskSelfAccessToMeans						type_YOrN					NULL
												CHECK (RiskSelfAccessToMeans in ('Y','N')),
	RiskSelfAccessToMeansDescribe				type_Comment2				NULL,
	RiskSelfCurrentSelfHarm						type_YOrN					NULL
												CHECK (RiskSelfCurrentSelfHarm in ('Y','N')),
	RiskSelfCurrentSelfHarmDescribe				type_Comment2				NULL,
	RiskSelfCurrentSelfHarmOutcome				type_Comment2				NULL,
	RiskSelfPreviousSelfHarm					type_YOrN					NULL
												CHECK (RiskSelfPreviousSelfHarm in ('Y','N')),
	RiskSelfPreviousSelfHarmDescribe			type_Comment2				NULL,
	RiskSelfPreviousSelfHarmOutcomes			type_Comment2				NULL,
	RiskSelfFamilySuicideHistory				type_Comment2				NULL,
	MentalStatusOrientaionPerson				type_YOrN					NULL
												CHECK (MentalStatusOrientaionPerson in ('Y','N')),
	MentalStatusOrientaionPlace					type_YOrN					NULL
												CHECK (MentalStatusOrientaionPlace in ('Y','N')),
	MentalStatusOrientaionTime					type_YOrN					NULL
												CHECK (MentalStatusOrientaionTime in ('Y','N')),
	MentalStatusOrientaionCircumstance			type_YOrN					NULL
												CHECK (MentalStatusOrientaionCircumstance in ('Y','N')),
	MentalStatusLOCAlert						type_YOrN					NULL
												CHECK (MentalStatusLOCAlert in ('Y','N')),
	MentalStatusLOCSedate						type_YOrN					NULL
												CHECK (MentalStatusLOCSedate in ('Y','N')),
	MentalStatusLOCLethargic					type_YOrN					NULL
												CHECK (MentalStatusLOCLethargic in ('Y','N')),
	MentalStatusLOCObtunded						type_YOrN					NULL
												CHECK (MentalStatusLOCObtunded in ('Y','N')),
	MentalStatusLOCOther						type_YOrN					NULL
												CHECK (MentalStatusLOCOther in ('Y','N')),
	MentalStatusLOCOtherDescribe				type_Comment2				NULL,
	MentaStatusMoodAppropriate					type_YOrN					NULL
												CHECK (MentaStatusMoodAppropriate in ('Y','N')),
	MentaStatusMoodIncongruent					type_YOrN					NULL
												CHECK (MentaStatusMoodIncongruent in ('Y','N')),
	MentaStatusMoodHostile						type_YOrN					NULL
												CHECK (MentaStatusMoodHostile in ('Y','N')),
	MentaStatusMoodTearful						type_YOrN					NULL
												CHECK (MentaStatusMoodTearful in ('Y','N')),
	MentaStatusMoodOther						type_YOrN					NULL
												CHECK (MentaStatusMoodOther in ('Y','N')),
	MentaStatusMoodOtherDescribe				type_Comment2				NULL,
	MentaStatusAffectRestricted					type_YOrN					NULL
												CHECK (MentaStatusAffectRestricted in ('Y','N')),
	MentaStatusAffectUnremarkable				type_YOrN					NULL
												CHECK (MentaStatusAffectUnremarkable in ('Y','N')),
	MentaStatusAffectExpansive					type_YOrN					NULL
												CHECK (MentaStatusAffectExpansive in ('Y','N')),
	MentaStatusAffectOther						type_YOrN					NULL
												CHECK (MentaStatusAffectOther in ('Y','N')),
	MentaStatusAffectOtherDescribe				type_Comment2				NULL,
	MentaStatusThoughtLucid						type_YOrN					NULL
												CHECK (MentaStatusThoughtLucid in ('Y','N')),
	MentaStatusThoughtSuspicious				type_YOrN					NULL
												CHECK (MentaStatusThoughtSuspicious in ('Y','N')),
	MentaStatusThoughtObsessive					type_YOrN					NULL
												CHECK (MentaStatusThoughtObsessive in ('Y','N')),
	MentaStatusThoughtObsessiveAbout			type_Comment2				NULL,
	MentaStatusThoughtTangential				type_YOrN					NULL
												CHECK (MentaStatusThoughtTangential in ('Y','N')),
	MentaStatusThoughtLoose						type_YOrN					NULL
												CHECK (MentaStatusThoughtLoose in ('Y','N')),
	MentaStatusThoughtDelusional				type_YOrN					NULL
												CHECK (MentaStatusThoughtDelusional in ('Y','N')),
	MentaStatusThoughtPsychosis					type_YOrN					NULL
												CHECK (MentaStatusThoughtPsychosis in ('Y','N')),
	MentaStatusThoughtImpoverished				type_YOrN					NULL
												CHECK (MentaStatusThoughtImpoverished in ('Y','N')),
	MentaStatusThoughtConfused					type_YOrN					NULL
												CHECK (MentaStatusThoughtConfused in ('Y','N')),
	MentaStatusSpeechClear						type_YOrN					NULL
												CHECK (MentaStatusSpeechClear in ('Y','N')),
	MentaStatusSpeechRapid						type_YOrN					NULL
												CHECK (MentaStatusSpeechRapid in ('Y','N')),
	MentaStatusSpeechSlurred					type_YOrN					NULL
												CHECK (MentaStatusSpeechSlurred in ('Y','N')),
	MentaStatusJudgementImpaired				type_YOrN					NULL
												CHECK (MentaStatusJudgementImpaired in ('Y','N')),
	MentaStatusJudgementImpairedDescribe		type_Comment2				NULL,
	MentalStatusImpulsivityApparent				type_YOrN					NULL
												CHECK (MentalStatusImpulsivityApparent in ('Y','N')),
	MentalStatusImpulsivityApparentDescribe		type_Comment2				NULL,
	MentalStatusInsightLimited					type_YOrN					NULL
												CHECK (MentalStatusInsightLimited in ('Y','N')),
	MentalStatusInsightLimitedDescribe			type_Comment2				NULL,
	MentalStatusPxWithGrooming					type_YOrN					NULL
												CHECK (MentalStatusPxWithGrooming in ('Y','N')),
	MentalStatusSleepDisturbance				type_YOrN					NULL
												CHECK (MentalStatusSleepDisturbance in ('Y','N')),
	MentalStatusSleepDisturbanceDescribe		type_Comment2				NULL,
	MentalStatusEatingDisturbance				type_YOrN					NULL
												CHECK (MentalStatusEatingDisturbance in ('Y','N')),
	MentalStatusEatingDisturbanceLbs			int							NULL,
	MentalStatusNotMedicationComplaint			type_YOrN					NULL
												CHECK (MentalStatusNotMedicationComplaint in ('Y','N')),
	SUCurrentUse								char(1)						NULL
												CHECK (SUCurrentUse in ('R','Y','N')),
	SUOdorOfSubstance							type_YOrN					NULL
												CHECK (SUOdorOfSubstance in ('Y','N')),
	SUSlurredSpeech								type_YOrN					NULL
												CHECK (SUSlurredSpeech in ('Y','N')),
	SUWithdrawalSymptoms						type_YOrN					NULL
												CHECK (SUWithdrawalSymptoms in ('Y','N')),
	SUDTOther									type_YOrN					NULL
												CHECK (SUDTOther in ('Y','N')),
	SUOtherDescribe								varchar(100)				NULL,
	SUBlackOuts									type_YOrN					NULL
												CHECK (SUBlackOuts in ('Y','N')),
	SURelatedArrests							type_YOrN					NULL
												CHECK (SURelatedArrests in ('Y','N')),
	SURelatedSocialProblems						type_YOrN					NULL
												CHECK (SURelatedSocialProblems in ('Y','N')),
	SUFrequentAbsences							type_YOrN					NULL
												CHECK (SUFrequentAbsences in ('Y','N')),
	SUCurrentTreatment							type_YOrN					NULL
												CHECK (SUCurrentTreatment in ('Y','N')),
	SUCurrentTreatmentProvider					varchar(100)				NULL,
	SUProviderContactNumber						varchar(250)				NULL,
	SUHistory									type_YOrN					NULL
												CHECK (SUHistory in ('Y','N')),
	SUHistorySpecify							type_Comment2				NULL,
	SUPreviousTreatment							type_YOrN					NULL
												CHECK (SUPreviousTreatment in ('Y','N')),
	SUReferralToSA								type_YOrN					NULL
												CHECK (SUReferralToSA in ('Y','N')),
	SUWhereReferred								varchar(100)				NULL,
	SUNotReferredBecause						type_Comment2				NULL,
	SUToxicologyResults							type_Comment2				NULL,
	HHMentalHealthUnableToObtain				type_YOrN					NULL
												CHECK (HHMentalHealthUnableToObtain in ('Y','N')),
	HHNumberOfIPPsychHospitalizations			int							NULL,
	HHMostRecentIPHospitalizationDate			datetime					NULL,
	HHMostRecentIPHospitalizationFacility		varchar(max)				NULL,
	HHPreviousOPPsychTreatment					type_YOrN					NULL
												CHECK (HHPreviousOPPsychTreatment in ('Y','N')),
	HHOPPsychUnableToObtain						type_YOrN					NULL
												CHECK (HHOPPsychUnableToObtain in ('Y','N')),
	HHTypeOfService								varchar(100)				NULL,
	HHCurrentProviderAndCredentials				varchar(100)				NULL,
	HHProviderCredentialsUnableToObtain			type_YOrN					NULL
												CHECK (HHProviderCredentialsUnableToObtain in ('Y','N')),
	HHDateLastSeenByCurrentProvider				datetime					NULL,
	HHPrimaryCareProvider						varchar(100)				NULL,
	HHPrimaryCareProviderPhone					varchar(250)				NULL,
	HHNoPrimaryCarePhysician					type_YOrN					NULL
												CHECK (HHNoPrimaryCarePhysician in ('Y','N')),
	HHAllergies									type_Comment2				NULL,
	HHCurrentHealthConcerns						type_Comment2				NULL,
	HHPreviousHealthConcerns					type_Comment2				NULL,
	SIPsychiatricSymptoms						char(2)						NULL
												CHECK (SIPsychiatricSymptoms in ('NA','MI','MO','SE')),
	SIPossibleHarmToSelf						char(2)						NULL
												CHECK (SIPossibleHarmToSelf in ('NA','MI','MO','SE')),
	SIPossibleHarmToOthers						char(2)						NULL
												CHECK (SIPossibleHarmToOthers in ('NA','MI','MO','SE')),
	SIMedicationDrugComplications				char(2)						NULL
												CHECK (SIMedicationDrugComplications in ('NA','MI','MO','SE')),
	SIDisruptionOfSelfCareAbilities				char(2)						NULL
												CHECK (SIDisruptionOfSelfCareAbilities in ('NA','MI','MO','SE')),
	SIImpairedPersonalAdjustment				char(2)						NULL
												CHECK (SIImpairedPersonalAdjustment in ('NA','MI','MO','SE')),
	SIIntensityOfService						char(1)						NULL
												CHECK (SIIntensityOfService in ('Q','P','O','N','M','L','K','J','I','H','G','F','E','D','C','B','A')),
	SummaryVoluntary							type_YOrN					NULL
												CHECK (SummaryVoluntary in ('Y','N')),
	SummaryInvoluntary							type_YOrN					NULL
												CHECK (SummaryInvoluntary in ('Y','N')),
	SummaryInpatientFacilityName				type_Comment2				NULL,
	AuthorizedDays								int							NULL,
	SummaryCrisisResidential					type_YOrN					NULL
												CHECK (SummaryCrisisResidential in ('Y','N')),
	SummaryCrisisFacilityName					type_Comment2			    NULL,
	SummaryPartialHospitalization				type_YOrN					NULL
												CHECK (SummaryPartialHospitalization in ('Y','N')),
	SummaryPartialFacilityName					type_Comment2				NULL,
	SummaryACT									type_YOrN					NULL
												CHECK (SummaryACT in ('Y','N')),
	SummaryCaseManagement						type_YOrN					NULL
												CHECK (SummaryCaseManagement in ('Y','N')),
	SummaryIOP									type_YOrN					NULL
												CHECK (SummaryIOP in ('Y','N')),
	SummaryOutpatient							type_YOrN					NULL
												CHECK (SummaryOutpatient in ('Y','N')),
	SummarySubstanceAbuse						type_YOrN					NULL
												CHECK (SummarySubstanceAbuse in ('Y','N')),
	SummaryOther								type_YOrN					NULL
												CHECK (SummaryOther in ('Y','N')),
	SummaryOtherSpecify							type_Comment2				NULL,
	SummaryProviderRecommended					varchar(max)				NULL,
	SummaryFamilyNotificationOffered			type_YOrN					NULL
												CHECK (SummaryFamilyNotificationOffered in ('Y','N')),
	SummaryFamilyMemberName						varchar(100)				NULL,
	SummaryInpatientRequestedAndDenied			type_YOrN					NULL
												CHECK (SummaryInpatientRequestedAndDenied in ('Y','N')),
	SummarySecondOpinionRights					type_YOrN					NULL
												CHECK (SummarySecondOpinionRights in ('Y','N')),
	SummaryOfferedAlternativeServices			type_YOrN					NULL
												CHECK (SummaryOfferedAlternativeServices in ('Y','N')),
	SummaryAlternativeServicesSpecify			varchar(max)				NULL,
	SummaryAgreedToAlternativeServices			type_YOrN					NULL
												CHECK (SummaryAgreedToAlternativeServices in ('Y','N')),
	SummaryAlternativeAppointmentTime			datetime					NULL,
	SummaryAlternativeAgencyName				type_Comment2				NULL,
	SummaryAlternativeAgencyContactNumber		varchar(250)				NULL,
	SummaryChooseOtherPlan						type_YOrN					NULL
												CHECK (SummaryChooseOtherPlan in ('Y','N')),
	SummaryChooseOtherPlanSpecify				type_Comment2				NULL,
	SummaryMedicaidRights						type_YOrN					NULL
												CHECK (SummaryMedicaidRights in ('Y','N')),
	SummaryMedicaidRightsWhyNot					type_Comment2				NULL,
	SummaryRefusedTreatment						type_YOrN					NULL
												CHECK (SummaryRefusedTreatment in ('Y','N')),
	SummaryNoServicesNeeded						type_YOrN					NULL
												CHECK (SummaryNoServicesNeeded in ('Y','N')),
	SummaryUnableToObtainSignature				type_YOrN					NULL
												CHECK (SummaryUnableToObtainSignature in ('Y','N')),
	SummaryUnableToObtainSignatureReason		type_Comment2				NULL,
	ClientSignedPaperCopy						type_YOrN					NULL
												CHECK (ClientSignedPaperCopy in ('Y','N')),
	SummarySummary								type_Comment2				NULL,
	RiskSuicideHomicidePlanDetails				type_GlobalCode				NULL,
	RiskSuicideHomicidePlanAvailability			type_GlobalCode				NULL,
	RiskSuicideHomicidePlanTime					type_GlobalCode				NULL,
	RiskSuicideHomicidePlanLethalityMethod		type_GlobalCode				NULL,
	RiskSuicideHomisideAttempts					type_GlobalCode				NULL,
	RiskSuicideHomisideIsolation				type_GlobalCode				NULL,
	RiskSuicideHomisideProbabilityTiming		type_GlobalCode				NULL,
	RiskSuicideHomisidePrecaution				type_GlobalCode				NULL,
	RiskSuicideHomisideActingToGetHelp			type_GlobalCode				NULL,
	RiskSuicideHomisideFinalAct					type_GlobalCode				NULL,
	RiskSuicideHomisideActiveForAttempt			type_GlobalCode				NULL,
	RiskSuicideHomisideSucideNote				type_GlobalCode				NULL,
	RiskSuicideHomisideOvertCommunication		type_GlobalCode				NULL,
	RiskSuicideHomisideAllegedPurposed			type_GlobalCode				NULL,
	RiskSuicideHomisideExpectationFatality		type_GlobalCode				NULL,
	RiskSuicideHomisideConceptionOfMethod		type_GlobalCode				NULL,
	RiskSuicideHomisideSeriousnessOfAttempt		type_GlobalCode				NULL,
	RiskSuicideHomisideAttitudeLivingDying		type_GlobalCode				NULL,
	RiskSuicideHomisideMedicalStatus			type_GlobalCode				NULL,
	RiskSuicideHomisideConceptMedicalRescue		type_GlobalCode				NULL,
	RiskSuicideHomisideDegreePremeditation		type_GlobalCode				NULL,
	RiskSuicideHomisideStress					type_GlobalCode				NULL,
	RiskSuicideHomisideCopingBehavior			type_GlobalCode				NULL,
	RiskSuicideHomisideDepression				type_GlobalCode				NULL,
	RiskSuicideHomisideResource					type_GlobalCode				NULL,
	RiskSuicideHomisideLifeStyle				type_GlobalCode				NULL,
	RiskSuicideHomisideTotalScore				decimal(18,2)				NULL,
	RiskSuicideHomisideComments					type_Comment2				NULL,
	Recommendations								type_Comment2				NULL,
	RiskActionTakenMedicalER					type_YOrN					NULL
												CHECK (RiskActionTakenMedicalER in ('Y','N')),
	RiskActionTakenPsychiatricPlacement			type_YOrN					NULL
												CHECK (RiskActionTakenPsychiatricPlacement in ('Y','N')),
	RiskActionTakenPsychiatricPlacementVoluntary		type_YOrN					NULL
												CHECK (RiskActionTakenPsychiatricPlacementVoluntary in ('Y','N')),
	RiskActionTakenPsychiatricPlacementInVoluntary		type_YOrN					NULL
												CHECK (RiskActionTakenPsychiatricPlacementInVoluntary in ('Y','N')),
	ActionTakenPsychiatricPlacementHospital		type_GlobalCode				NULL,
	RiskActionDirectorsHoldPlaced				type_YOrN					NULL
												CHECK (RiskActionDirectorsHoldPlaced in ('Y','N')),
	RiskActionSecureTransport					type_YOrN					NULL
												CHECK (RiskActionSecureTransport in ('Y','N')),
	RiskActionSecureTransportCompanyName		varchar(max)				NULL,
	RiskActionTakenCrisisRespiteBed				type_YOrN					NULL
												CHECK (RiskActionTakenCrisisRespiteBed in ('Y','N')),
	RiskActionTakenCrisisRespiteBedWithPsych	type_YOrN					NULL
												CHECK (RiskActionTakenCrisisRespiteBedWithPsych in ('Y','N')),
	RiskActionTakenCrisisRespiteBedWithoutPsych	type_YOrN					NULL
												CHECK (RiskActionTakenCrisisRespiteBedWithoutPsych in ('Y','N')),
	RiskActionTakenJail							type_YOrN					NULL
												CHECK (RiskActionTakenJail in ('Y','N')),
	RiskActionSocialDextorBed					type_YOrN					NULL
												CHECK (RiskActionSocialDextorBed in ('Y','N')),
	RiskSentHomeAlone							type_YOrN					NULL
												CHECK (RiskSentHomeAlone in ('Y','N')),
	RiskSentHomeWithRelative					type_YOrN					NULL
												CHECK (RiskSentHomeWithRelative in ('Y','N')),
	RiskRefferedToFollowNextDay					type_YOrN					NULL
												CHECK (RiskRefferedToFollowNextDay in ('Y','N')),
	RiskReferedToPrivateProvider				type_YOrN					NULL
												CHECK (RiskReferedToPrivateProvider in ('Y','N')),
	RiskReferedToPrivateProviderName			varchar(max)				NULL,
	RiskRefferedPyschiatristPMNHP				type_YOrN					NULL
												CHECK (RiskRefferedPyschiatristPMNHP in ('Y','N')),
	RiskReferedToOther							type_YOrN					NULL
												CHECK (RiskReferedToOther in ('Y','N')),
	RiskReferedToOtherSpecify					varchar(max)				NULL,
	RiskSuicidePresentingDangersSuicide			type_GlobalCode				NULL,
	RiskSuicidePresentingDangersOtherHarmToSelf	type_GlobalCode				NULL,
	RiskSuicidePresentingDangersHarmToOthers	type_GlobalCode				NULL,
	RiskSuicidePresentingDangersHarmToProperty	type_GlobalCode				NULL,
	RowIdentifier								type_GUID					NOT	NULL, 
    CONSTRAINT CustomAcuteServicesPrescreens_PK PRIMARY KEY CLUSTERED (DocumentVersionId)
    )  
IF OBJECT_ID('CustomAcuteServicesPrescreens') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomAcuteServicesPrescreens >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomAcuteServicesPrescreens >>>', 16, 1)
/* 
 * TABLE: CustomAcuteServicesPrescreens 
 */    
 ALTER TABLE CustomAcuteServicesPrescreens ADD CONSTRAINT DocumentVersions_CustomAcuteServicesPrescreens_FK 
	FOREIGN KEY (DocumentVersionId)
	REFERENCES DocumentVersions(DocumentVersionId)
	
 
 PRINT 'STEP 4(A) COMPLETED'	
END
    
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomSUSubstances')
BEGIN  
/* 
 * TABLE: CustomSUSubstances 
 */
 CREATE TABLE CustomSUSubstances(
	SUSubstanceId						int identity(1,1)			NOT NULL,
    CreatedBy							type_CurrentUser			NOT NULL,
    CreatedDate							type_CurrentDatetime		NOT NULL,
    ModifiedBy							type_CurrentUser			NOT NULL,
    ModifiedDate						type_CurrentDatetime		NOT NULL,
    RecordDeleted						type_YOrN					NULL
										CHECK (RecordDeleted in ('Y','N')),
    DeletedDate							datetime					NULL,
    DeletedBy							type_UserId					NULL,
   	DocumentVersionId					int 						NOT NULL,
   	SubstanceName						varchar(100)				NULL,
   	Amount								varchar(100)				NULL,
   	Frequency							varchar(100)				NULL,
   	RowIdentifier						type_GUID					NOT	NULL, 
	CONSTRAINT CustomSUSubstances_PK PRIMARY KEY CLUSTERED (SUSubstanceId)
    )  
IF OBJECT_ID('CustomSUSubstances') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomSUSubstances >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomSUSubstances >>>', 16, 1)
/* 
 * TABLE: CustomSUSubstances 
 */  

CREATE NONCLUSTERED INDEX [XIE1_CustomSUSubstances] ON [dbo].[CustomSUSubstances] 
	(  
	  [DocumentVersionId] ASC
	  )
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomSUSubstances') AND name='XIE1_CustomSUSubstances')
	PRINT '<<< CREATED INDEX CustomSUSubstances.XIE1_CustomSUSubstances >>>'
	ELSE
	RAISERROR('<<< FAILED CREATING INDEX CustomSUSubstances.XIE1_CustomSUSubstances >>>', 16, 1)
	   
 ALTER TABLE CustomSUSubstances ADD CONSTRAINT DocumentVersions_CustomSUSubstances_FK 
	FOREIGN KEY (DocumentVersionId)
	REFERENCES DocumentVersions(DocumentVersionId)
	 
 PRINT 'STEP 4(B) COMPLETED'	
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomMedicationHistory')
BEGIN  
/* 
 * TABLE: CustomMedicationHistory 
 */
 CREATE TABLE CustomMedicationHistory(
	MedicationHistoryId					int identity(1,1)			NOT NULL,
    CreatedBy							type_CurrentUser			NOT NULL,
    CreatedDate							type_CurrentDatetime		NOT NULL,
    ModifiedBy							type_CurrentUser			NOT NULL,
    ModifiedDate						type_CurrentDatetime		NOT NULL,
    RecordDeleted						type_YOrN					NULL
										CHECK (RecordDeleted in ('Y','N')),
    DeletedDate							datetime					NULL,
    DeletedBy							type_UserId					NULL, 
    DocumentVersionId					int 						NOT NULL,
    MedicationName						varchar(50)					NULL,
	DosageFrequency						varchar(50)					NULL,
	Purpose								varchar(50)					NULL,
	PrescribingPhysician				varchar(50)					NULL,
	RowIdentifier						type_GUID					NOT	NULL, 
	CONSTRAINT CustomMedicationHistory_PK PRIMARY KEY CLUSTERED (MedicationHistoryId)
    )  
IF OBJECT_ID('CustomMedicationHistory') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomMedicationHistory >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomMedicationHistory >>>', 16, 1)
/* 
 * TABLE: CustomMedicationHistory 
 */    
 ALTER TABLE CustomMedicationHistory ADD CONSTRAINT DocumentVersions_CustomMedicationHistory_FK 
	FOREIGN KEY (DocumentVersionId)
	REFERENCES DocumentVersions(DocumentVersionId)
	 
 PRINT 'STEP 4(C) COMPLETED'	
END

  ---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

If NOT EXISTS (SELECT [key] FROM SystemConfigurationKeys WHERE [key] = 'CDM_CrisisServiceNote')
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
				   ,'CDM_CrisisServiceNote'
				   ,'1.0'
				   )

		PRINT 'STEP 7 COMPLETED'     
	END
GO