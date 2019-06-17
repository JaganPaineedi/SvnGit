----- STEP 1 ----------
IF OBJECT_ID('tempdb..#ColumnExists') IS NOT NULL
 DROP TABLE #ColumnExists
 
 CREATE TABLE #ColumnExists (value INT)


 IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
BEGIN
	IF COL_LENGTH('CustomHRMAssessments','PsMedicationsSideEffects') IS NOT NULL AND COL_LENGTH('CustomHRMAssessments','RowIdentifier') IS NULL
	BEGIN
		INSERT INTO #ColumnExists
				(value)
			VALUES (1)
		PRINT 'PsMedicationsSideEffects Column already  exists in dbo.CustomHRMAssessments  - Skipping operation'
	END	
	
END

IF COL_LENGTH('CustomHRMAssessments','PsMedicationsComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsMedicationsComment	type_Comment2	NULL
END
IF COL_LENGTH('CustomHRMAssessments','PsEducationComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsEducationComment type_Comment2	NULL
END
IF COL_LENGTH('CustomHRMAssessments','IncludeFunctionalAssessment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD IncludeFunctionalAssessment	type_YOrN	NULL
										CHECK (IncludeFunctionalAssessment in ('Y','N'))
END
IF COL_LENGTH('CustomHRMAssessments','IncludeSymptomChecklist') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD IncludeSymptomChecklist	type_YOrN	NULL
										CHECK (IncludeSymptomChecklist in	('Y','N'))
END
IF COL_LENGTH('CustomHRMAssessments','IncludeUNCOPE') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD 	IncludeUNCOPE	type_YOrN	NULL
										CHECK (IncludeUNCOPE in	('Y','N'))
END
IF COL_LENGTH('CustomHRMAssessments','IncludeUNCOPE') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD 	IncludeUNCOPE type_YOrN		NULL
										CHECK (IncludeUNCOPE in	('Y','N'))
END	
IF COL_LENGTH('CustomHRMAssessments','ClientIsAppropriateForTreatment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD 	ClientIsAppropriateForTreatment	type_YOrN	NULL
										CHECK (ClientIsAppropriateForTreatment in('Y','N'))
END	

IF COL_LENGTH('CustomHRMAssessments','SecondOpinionNoticeProvided') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD 	SecondOpinionNoticeProvided	type_YOrN	NULL
										CHECK (SecondOpinionNoticeProvided in('Y','N'))	
END

IF COL_LENGTH('CustomHRMAssessments','TreatmentNarrative') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD 	TreatmentNarrative	type_Comment2 NULL										
END
IF COL_LENGTH('CustomHRMAssessments','RapCiDomainIntensity') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD 	RapCiDomainIntensity varchar(50) NULL										
END			
IF COL_LENGTH('CustomHRMAssessments','RapCiDomainComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD 	RapCiDomainComment type_Comment2 NULL								
END	
IF COL_LENGTH('CustomHRMAssessments','RapCiDomainNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD 	RapCiDomainNeedsList type_YOrN	NULL
										CHECK (RapCiDomainNeedsList in	('Y','N'))								
END		
IF COL_LENGTH('CustomHRMAssessments','RapCbDomainIntensity') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD 	RapCbDomainIntensity varchar(50) NULL														
END		
IF COL_LENGTH('CustomHRMAssessments','RapCbDomainComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD RapCbDomainComment	type_Comment2 NULL													
END	
IF COL_LENGTH('CustomHRMAssessments','RapCbDomainNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD RapCbDomainNeedsList		type_YOrN	NULL
										CHECK (RapCbDomainNeedsList in	('Y','N'))													
END		
IF COL_LENGTH('CustomHRMAssessments','RapCaDomainIntensity') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD RapCaDomainIntensity	varchar(50)	NULL																				
END		
IF COL_LENGTH('CustomHRMAssessments','RapCaDomainComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD RapCaDomainComment type_Comment2	NULL																				
END

IF COL_LENGTH('CustomHRMAssessments','RapCaDomainNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD RapCaDomainNeedsList	type_YOrN	NULL
									  CHECK (RapCaDomainNeedsList in ('Y','N'))																				
END		
IF COL_LENGTH('CustomHRMAssessments','RapHhcDomainIntensity') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD RapHhcDomainIntensity	 varchar(50) NULL									 																
END			
IF COL_LENGTH('CustomHRMAssessments','OutsideReferralsGiven') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD OutsideReferralsGiven	type_YOrN	NULL
											CHECK (OutsideReferralsGiven in	('Y','N'))									 																
END	
IF COL_LENGTH('CustomHRMAssessments','ReferralsNarrative') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD ReferralsNarrative type_Comment2	NULL														 																
END		
IF COL_LENGTH('CustomHRMAssessments','ServiceOther') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD ServiceOther	type_YOrN	NULL
										CHECK (ServiceOther in	('Y','N'))														 																
END		
IF COL_LENGTH('CustomHRMAssessments','ServiceOtherDescription') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD ServiceOtherDescription varchar(100) NULL																			 																
END	
IF COL_LENGTH('CustomHRMAssessments','AssessmentAddtionalInformation') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD AssessmentAddtionalInformation type_Comment2	NULL																		 																
END	
IF COL_LENGTH('CustomHRMAssessments','TreatmentAccomodation') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD TreatmentAccomodation	type_Comment2	NULL																		 																
END
IF COL_LENGTH('CustomHRMAssessments','Participants') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD Participants  type_Comment2	NULL																		 																
END
IF COL_LENGTH('CustomHRMAssessments','TimeLocation') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD TimeLocation  type_Comment2	NULL																		 																
END
IF COL_LENGTH('CustomHRMAssessments','AssessmentsNeeded') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD AssessmentsNeeded	type_Comment2 NULL																		 																
END	
IF COL_LENGTH('CustomHRMAssessments','CommunicationAccomodations') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD CommunicationAccomodations type_Comment2	NULL																		 																
END
IF COL_LENGTH('CustomHRMAssessments','IssuesToAvoid') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD IssuesToAvoid type_Comment2	NULL																		 																
END			
IF COL_LENGTH('CustomHRMAssessments','IssuesToDiscuss') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD IssuesToDiscuss type_Comment2	NULL																		 																
END	
IF COL_LENGTH('CustomHRMAssessments','SourceOfPrePlanningInfo') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SourceOfPrePlanningInfo type_Comment2	NULL																		 																
END	
IF COL_LENGTH('CustomHRMAssessments','SelfDeterminationDesired') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SelfDeterminationDesired	type_YOrNOrNA	NULL
										CHECK (SelfDeterminationDesired in('Y','N','A'))																		 																
END	
IF COL_LENGTH('CustomHRMAssessments','FiscalIntermediaryDesired') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD FiscalIntermediaryDesired	type_YOrNOrNA	NULL
										CHECK (FiscalIntermediaryDesired in('Y','N','A'))																		 																
END	
IF COL_LENGTH('CustomHRMAssessments','PamphletGiven') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PamphletGiven	type_YOrN	NULL
										CHECK (PamphletGiven in	('Y','N'))														 																
END		
IF COL_LENGTH('CustomHRMAssessments','PamphletDiscussed') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PamphletDiscussed	type_YOrN	NULL
										CHECK (PamphletGiven in	('Y','N'))														 																
END	
IF COL_LENGTH('CustomHRMAssessments','PrePlanIndependentFacilitatorDiscussed') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PrePlanIndependentFacilitatorDiscussed	type_YOrN	NULL
										CHECK (PrePlanIndependentFacilitatorDiscussed in	('Y','N'))														 																
END	
IF COL_LENGTH('CustomHRMAssessments','PrePlanIndependentFacilitatorDesired') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PrePlanIndependentFacilitatorDesired	type_YOrN	NULL
										CHECK (PrePlanIndependentFacilitatorDesired in	('Y','N'))														 																
END	
IF COL_LENGTH('CustomHRMAssessments','PrePlanGuardianContacted') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PrePlanGuardianContacted	type_YOrN	NULL
 										CHECK (PrePlanGuardianContacted in	('Y','N'))														 																
END
	
IF COL_LENGTH('CustomHRMAssessments','PrePlanSeparateDocument') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PrePlanSeparateDocument	type_YOrN	NULL
										CHECK (PrePlanSeparateDocument in	('Y','N'))														 																
END
IF COL_LENGTH('CustomHRMAssessments','CommunityActivitiesCurrentDesired') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD CommunityActivitiesCurrentDesired	type_Comment2	NULL																						 																
END
IF COL_LENGTH('CustomHRMAssessments','CommunityActivitiesIncreaseDesired') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD CommunityActivitiesIncreaseDesired	type_YOrN	NULL
											CHECK (CommunityActivitiesIncreaseDesired in('Y','N'))																						 																
END		
IF COL_LENGTH('CustomHRMAssessments','CommunityActivitiesNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD CommunityActivitiesNeedsList	type_YOrN	NULL
											CHECK (CommunityActivitiesNeedsList in('Y','N'))																						 																
END		
IF COL_LENGTH('CustomHRMAssessments','PsCurrentHealthIssues') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsCurrentHealthIssues	type_YesNoUnknown	NULL
											CHECK (PsCurrentHealthIssues in ('Y','N','U'))																						 																
END
IF COL_LENGTH('CustomHRMAssessments','PsCurrentHealthIssuesComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsCurrentHealthIssuesComment	type_Comment2	NULL																						 																
END	
IF COL_LENGTH('CustomHRMAssessments','PsCurrentHealthIssuesNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsCurrentHealthIssuesNeedsList	type_YOrN	NULL
											CHECK (PsCurrentHealthIssuesNeedsList in('Y','N'))																						 																
END	
IF COL_LENGTH('CustomHRMAssessments','HistMentalHealthTx') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HistMentalHealthTx	type_YesNoUnknown	NULL
											CHECK (HistMentalHealthTx in ('Y','N','U'))																						 																
END
IF COL_LENGTH('CustomHRMAssessments','HistMentalHealthTxNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HistMentalHealthTxNeedsList	type_YOrN	NULL
											CHECK (HistMentalHealthTxNeedsList in('Y','N'))																						 																
END		
IF COL_LENGTH('CustomHRMAssessments','HistMentalHealthTxComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HistMentalHealthTxComment	type_Comment2	NULL																						 																
END		
IF COL_LENGTH('CustomHRMAssessments','HistMentalHealthTx') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HistFamilyMentalHealthTx	type_YesNoUnknown	NULL
											CHECK (HistFamilyMentalHealthTx in ('Y','N','U'))																						 																
END	

IF COL_LENGTH('CustomHRMAssessments','HistFamilyMentalHealthTxNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HistFamilyMentalHealthTxNeedsList	type_YOrN	NULL
											CHECK (HistFamilyMentalHealthTxNeedsList in('Y','N'))																						 																
END	
	
IF COL_LENGTH('CustomHRMAssessments','HistMentalHealthTxComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HistFamilyMentalHealthTxComment type_Comment2	NULL																						 																
END	
	
IF COL_LENGTH('CustomHRMAssessments','PsClientAbuseIssues') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsClientAbuseIssues	type_YesNoUnknown	NULL
											CHECK (PsClientAbuseIssues in ('Y','N','U'))																						 																
END	
IF COL_LENGTH('CustomHRMAssessments','PsClientAbuesIssuesComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsClientAbuesIssuesComment type_Comment2	NULL																						 																
END	
IF COL_LENGTH('CustomHRMAssessments','PsClientAbuseIssuesNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsClientAbuseIssuesNeedsList	type_YOrN	NULL
											CHECK (PsClientAbuseIssuesNeedsList in('Y','N'))																						 																
END	
IF COL_LENGTH('CustomHRMAssessments','PsFamilyConcernsComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsFamilyConcernsComment type_Comment2	NULL																						 																
END		
IF COL_LENGTH('CustomHRMAssessments','PsRiskLossOfPlacement') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsRiskLossOfPlacement	type_YOrN	NULL
											CHECK (PsRiskLossOfPlacement in('Y','N'))																						 																
END	
IF COL_LENGTH('CustomHRMAssessments','PsRiskLossOfPlacementDueTo') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsRiskLossOfPlacementDueTo	type_GlobalCode	 NULL															 																
END	

IF COL_LENGTH('CustomHRMAssessments','PsRiskSensoryMotorFunction') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsRiskSensoryMotorFunction	type_YOrN	NULL
											CHECK (PsRiskSensoryMotorFunction in('Y','N'))																						 																
END	
IF COL_LENGTH('CustomHRMAssessments','PsRiskSensoryMotorFunctionDueTo') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsRiskSensoryMotorFunctionDueTo	type_GlobalCode	 NULL															 																
END	

IF COL_LENGTH('CustomHRMAssessments','PsRiskSafety') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsRiskSafety	type_YOrN	NULL
											CHECK (PsRiskSafety in('Y','N'))																						 																
END	

IF COL_LENGTH('CustomHRMAssessments','PsRiskSafetyDueTo') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsRiskSafetyDueTo	type_GlobalCode	 NULL															 																
END	

IF COL_LENGTH('CustomHRMAssessments','PsRiskLossOfSupport') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsRiskLossOfSupport	type_YOrN	NULL
											CHECK (PsRiskLossOfSupport in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsRiskLossOfSupportDueTo') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsRiskLossOfSupportDueTo	type_GlobalCode	NULL	
END

IF COL_LENGTH('CustomHRMAssessments','PsRiskLossOfSupport') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsRiskExpulsionFromSchool	type_YOrN	NULL
											CHECK (PsRiskExpulsionFromSchool in('Y','N'))
END	

IF COL_LENGTH('CustomHRMAssessments','PsRiskExpulsionFromSchoolDueTo') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsRiskExpulsionFromSchoolDueTo	type_GlobalCode	NULL	
END

IF COL_LENGTH('CustomHRMAssessments','PsRiskHospitalization') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsRiskHospitalization	type_YOrN	NULL
											CHECK (PsRiskHospitalization in('Y','N'))
END	

IF COL_LENGTH('CustomHRMAssessments','PsRiskHospitalizationDueTo') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsRiskHospitalizationDueTo	type_GlobalCode	NULL	
END

IF COL_LENGTH('CustomHRMAssessments','PsRiskCriminalJusticeSystem') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsRiskCriminalJusticeSystem	type_YOrN	NULL
											CHECK (PsRiskCriminalJusticeSystem in('Y','N'))
END	

IF COL_LENGTH('CustomHRMAssessments','PsRiskCriminalJusticeSystemDueTo') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsRiskCriminalJusticeSystemDueTo	type_GlobalCode	NULL	
END

IF COL_LENGTH('CustomHRMAssessments','PsRiskElopementFromHome') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsRiskElopementFromHome	type_YOrN	NULL
											CHECK (PsRiskElopementFromHome in('Y','N'))
END	

IF COL_LENGTH('CustomHRMAssessments','PsRiskElopementFromHomeDueTo') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsRiskElopementFromHomeDueTo	type_GlobalCode	NULL	
END	


IF COL_LENGTH('CustomHRMAssessments','PsRiskLossOfFinancialStatus') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsRiskLossOfFinancialStatus	type_YOrN	NULL
											CHECK (PsRiskLossOfFinancialStatus in('Y','N'))
END	

IF COL_LENGTH('CustomHRMAssessments','PsRiskLossOfFinancialStatusDueTo') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsRiskLossOfFinancialStatusDueTo	type_GlobalCode	NULL	
END	


IF COL_LENGTH('CustomHRMAssessments','PsDevelopmentalMilestones') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsDevelopmentalMilestones	type_YesNoUnknown	NULL
											CHECK (PsDevelopmentalMilestones in('Y','N','U'))
END	

IF COL_LENGTH('CustomHRMAssessments','PsDevelopmentalMilestonesComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsDevelopmentalMilestonesComment	type_Comment2	NULL	
END	

IF COL_LENGTH('CustomHRMAssessments','PsDevelopmentalMilestonesNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsDevelopmentalMilestonesNeedsList	type_YOrN	NULL
											CHECK (PsDevelopmentalMilestonesNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsChildEnvironmentalFactors') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsChildEnvironmentalFactors	type_YesNoUnknown	NULL
											CHECK (PsChildEnvironmentalFactors in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsChildEnvironmentalFactorsComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsChildEnvironmentalFactorsComment	type_Comment2	NULL
END


IF COL_LENGTH('CustomHRMAssessments','PsChildEnvironmentalFactorsNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsChildEnvironmentalFactorsNeedsList	type_YOrN	NULL
											CHECK (PsChildEnvironmentalFactorsNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsLanguageFunctioning') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsLanguageFunctioning	type_YesNoUnknown	NULL
											CHECK (PsLanguageFunctioning in('Y','N','U'))
END
	

IF COL_LENGTH('CustomHRMAssessments','PsLanguageFunctioningComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsLanguageFunctioningComment	type_Comment2	NULL
END
	
IF COL_LENGTH('CustomHRMAssessments','PsLanguageFunctioningNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsLanguageFunctioningNeedsList	type_YOrN	NULL
											CHECK (PsLanguageFunctioningNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsVisualFunctioning') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsVisualFunctioning	type_YesNoUnknown	NULL
											CHECK (PsVisualFunctioning in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsVisualFunctioningComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsVisualFunctioningComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','PsVisualFunctioningNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsVisualFunctioningNeedsList	type_YOrN	NULL
											CHECK (PsVisualFunctioningNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsPrenatalExposure') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsPrenatalExposure	type_YesNoUnknown	NULL
											CHECK (PsPrenatalExposure in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsPrenatalExposureComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsPrenatalExposureComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','PsPrenatalExposureNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsPrenatalExposureNeedsList	type_YOrN	NULL
											CHECK (PsPrenatalExposureNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsChildMentalHealthHistory') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsChildMentalHealthHistory	type_YesNoUnknown	NULL
											CHECK (PsChildMentalHealthHistory in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsChildMentalHealthHistoryComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsChildMentalHealthHistoryComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','PsChildMentalHealthHistoryNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsChildMentalHealthHistoryNeedsList	type_YOrN	NULL
											CHECK (PsPrenatalExposureNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsIntellectualFunctioning') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsIntellectualFunctioning	type_YesNoUnknown	NULL
											CHECK (PsIntellectualFunctioning in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsIntellectualFunctioningComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsIntellectualFunctioningComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','PsIntellectualFunctioningNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsIntellectualFunctioningNeedsList	type_YOrN	NULL
											CHECK (PsIntellectualFunctioningNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsLearningAbility') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsLearningAbility		type_YesNoUnknown	NULL
											CHECK (PsLearningAbility in('Y','N','U'))
END	

IF COL_LENGTH('CustomHRMAssessments','PsLearningAbilityComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsLearningAbilityComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','PsLearningAbilityNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsLearningAbilityNeedsList	type_YOrN	NULL
											CHECK (PsLearningAbilityNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsFunctioningConcernComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsFunctioningConcernComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','PsPeerInteraction') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsPeerInteraction		type_YesNoUnknown	NULL
											CHECK (PsPeerInteraction in('Y','N','U'))
END	

IF COL_LENGTH('CustomHRMAssessments','PsPeerInteractionComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsPeerInteractionComment	type_Comment2	NULL
END										

IF COL_LENGTH('CustomHRMAssessments','PsPeerInteractionNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsPeerInteractionNeedsList	type_YOrN	NULL
											CHECK (PsPeerInteractionNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsParentalParticipation') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsParentalParticipation		type_YesNoUnknown	NULL
											CHECK (PsParentalParticipation in('Y','N','U'))
END	

IF COL_LENGTH('CustomHRMAssessments','PsParentalParticipationComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsParentalParticipationComment	type_Comment2	NULL
END	

IF COL_LENGTH('CustomHRMAssessments','PsParentalParticipationNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsParentalParticipationNeedsList	type_YOrN	NULL
											CHECK (PsParentalParticipationNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsSchoolHistory') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsSchoolHistory	type_YesNoUnknown	NULL
											CHECK (PsSchoolHistory in('Y','N','U'))
END


IF COL_LENGTH('CustomHRMAssessments','PsSchoolHistoryComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsSchoolHistoryComment	type_Comment2	NULL
END
	
IF COL_LENGTH('CustomHRMAssessments','PsSchoolHistoryNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsSchoolHistoryNeedsList	type_YOrN	NULL
											CHECK (PsSchoolHistoryNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsImmunizations') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsImmunizations	type_YesNoUnknown	NULL
											CHECK (PsImmunizations in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsImmunizationsComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsImmunizationsComment	type_Comment2	NULL
END

	
IF COL_LENGTH('CustomHRMAssessments','PsImmunizationsNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsImmunizationsNeedsList	type_YOrN	NULL
											CHECK (PsImmunizationsNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsChildHousingIssues') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsChildHousingIssues	type_YesNoUnknown	NULL
											CHECK (PsChildHousingIssues in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsChildHousingIssuesComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsChildHousingIssuesComment	type_Comment2	NULL
END

	
IF COL_LENGTH('CustomHRMAssessments','PsChildHousingIssuesNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsChildHousingIssuesNeedsList	type_YOrN	NULL
											CHECK (PsChildHousingIssuesNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsSexuality') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsSexuality	type_YesNoUnknown	NULL
											CHECK (PsSexuality in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsSexualityComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsSexualityComment	type_Comment2	NULL
END

	
IF COL_LENGTH('CustomHRMAssessments','PsSexualityNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsSexualityNeedsList	type_YOrN	NULL
											CHECK (PsSexualityNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsFamilyFunctioning') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsFamilyFunctioning	type_YesNoUnknown	NULL
											CHECK (PsFamilyFunctioning in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsFamilyFunctioningComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsFamilyFunctioningComment	type_Comment2	NULL
END

	
IF COL_LENGTH('CustomHRMAssessments','PsFamilyFunctioningNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsFamilyFunctioningNeedsList	type_YOrN	NULL
											CHECK (PsFamilyFunctioningNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsTraumaticIncident') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsTraumaticIncident	type_YesNoUnknown	NULL
											CHECK (PsTraumaticIncident in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsTraumaticIncidentComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsTraumaticIncidentComment	type_Comment2	NULL
END

	
IF COL_LENGTH('CustomHRMAssessments','PsTraumaticIncidentNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsTraumaticIncidentNeedsList	type_YOrN	NULL
											CHECK (PsTraumaticIncidentNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','HistDevelopmental') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HistDevelopmental	type_YesNoUnknown	NULL
											CHECK (HistDevelopmental in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','HistDevelopmentalComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HistDevelopmentalComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','HistResidential') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HistResidential	type_YesNoUnknown	NULL
											CHECK (HistResidential in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','HistResidentialComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HistResidentialComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','HistOccupational') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HistOccupational	type_YesNoUnknown	NULL
											CHECK (HistOccupational in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','HistOccupationalComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HistOccupationalComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','HistLegalFinancial') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HistLegalFinancial	type_YesNoUnknown	NULL
											CHECK (HistLegalFinancial in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','HistLegalFinancialComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HistLegalFinancialComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','SignificantEventsPastYear') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SignificantEventsPastYear	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','PsGrossFineMotor') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsGrossFineMotor	type_YesNoUnknown	NULL
											CHECK (PsGrossFineMotor in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsGrossFineMotorComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsGrossFineMotorComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','PsGrossFineMotorNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsGrossFineMotorNeedsList	type_YOrN	NULL
											CHECK (PsGrossFineMotorNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsSensoryPerceptual') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsSensoryPerceptual	type_YesNoUnknown	NULL
											CHECK (PsSensoryPerceptual in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsSensoryPerceptualComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsSensoryPerceptualComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','PsSensoryPerceptualNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsSensoryPerceptualNeedsList	type_YOrN	NULL
											CHECK (PsSensoryPerceptualNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsCognitiveFunction') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsCognitiveFunction	type_YesNoUnknown	NULL
											CHECK (PsCognitiveFunction in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsCognitiveFunctionComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsCognitiveFunctionComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','PsCognitiveFunctionNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsCognitiveFunctionNeedsList	type_YOrN	NULL
											CHECK (PsCognitiveFunctionNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsCommunicativeFunction') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsCommunicativeFunction	type_YesNoUnknown	NULL
											CHECK (PsCommunicativeFunction in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsCommunicativeFunctionComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsCommunicativeFunctionComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','PsCommunicativeFunctionNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsCommunicativeFunctionNeedsList	type_YOrN	NULL
											CHECK (PsCommunicativeFunctionNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsCurrentPsychoSocialFunctiion') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsCurrentPsychoSocialFunctiion	type_YesNoUnknown	NULL
											CHECK (PsCurrentPsychoSocialFunctiion in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsCurrentPsychoSocialFunctiionComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsCurrentPsychoSocialFunctiionComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','PsCurrentPsychoSocialFunctiionNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsCurrentPsychoSocialFunctiionNeedsList	type_YOrN	NULL
											CHECK (PsCurrentPsychoSocialFunctiionNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsAdaptiveEquipment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsAdaptiveEquipment	type_YesNoUnknown	NULL
											CHECK (PsAdaptiveEquipment in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsAdaptiveEquipmentComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsAdaptiveEquipmentComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','PsAdaptiveEquipmentNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsAdaptiveEquipmentNeedsList	type_YOrN	NULL
											CHECK (PsAdaptiveEquipmentNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsSafetyMobilityHome') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsSafetyMobilityHome	type_YesNoUnknown	NULL
											CHECK (PsSafetyMobilityHome in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsSafetyMobilityHomeComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsSafetyMobilityHomeComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','PsSafetyMobilityHomeNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsSafetyMobilityHomeNeedsList	type_YOrN	NULL
											CHECK (PsSafetyMobilityHomeNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsHealthSafetyChecklistComplete') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsHealthSafetyChecklistComplete	type_YesNoNoanswerNotasked	NULL
											CHECK (PsHealthSafetyChecklistComplete in('NAS','NAN','Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsAccessibilityIssues') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsAccessibilityIssues	type_YesNoUnknown	NULL
											CHECK (PsAccessibilityIssues in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsAccessibilityIssuesComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsAccessibilityIssuesComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','PsAccessibilityIssuesNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsAccessibilityIssuesNeedsList	type_YOrN	NULL
											CHECK (PsAccessibilityIssuesNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsEvacuationTraining') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsEvacuationTraining	type_YesNoUnknown	NULL
											CHECK (PsEvacuationTraining in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsEvacuationTrainingComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsEvacuationTrainingComment	type_Comment2	NULL
END


IF COL_LENGTH('CustomHRMAssessments','PsEvacuationTrainingNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsEvacuationTrainingNeedsList	type_YOrN	NULL
											CHECK (PsEvacuationTrainingNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','Ps24HourSetting') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD Ps24HourSetting	type_YesNoUnknown	NULL
											CHECK (Ps24HourSetting in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','Ps24HourSettingComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD Ps24HourSettingComment	type_Comment2	NULL
END


IF COL_LENGTH('CustomHRMAssessments','Ps24HourSettingNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD Ps24HourSettingNeedsList	type_YOrN	NULL
											CHECK (Ps24HourSettingNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','Ps24HourNeedsAwakeSupervision') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD Ps24HourNeedsAwakeSupervision	type_YesNoUnknown	NULL
											CHECK (Ps24HourNeedsAwakeSupervision in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsSpecialEdEligibility') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsSpecialEdEligibility	type_YesNoUnknown	NULL
											CHECK (PsSpecialEdEligibility in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsSpecialEdEligibilityComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsSpecialEdEligibilityComment	type_Comment2	NULL
END


IF COL_LENGTH('CustomHRMAssessments','PsSpecialEdEligibilityNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsSpecialEdEligibilityNeedsList	type_YOrN	NULL
											CHECK (PsSpecialEdEligibilityNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsSpecialEdEnrolled') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsSpecialEdEnrolled	type_YesNoUnknown	NULL
											CHECK (PsSpecialEdEnrolled in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsSpecialEdEnrolledComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsSpecialEdEnrolledComment	type_Comment2	NULL
END


IF COL_LENGTH('CustomHRMAssessments','PsSpecialEdEnrolledNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsSpecialEdEnrolledNeedsList	type_YOrN	NULL
											CHECK (PsSpecialEdEnrolledNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsEmployer') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsEmployer	type_YesNoUnknown	NULL
											CHECK (PsEmployer in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsEmployerComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsEmployerComment	type_Comment2	NULL
END


IF COL_LENGTH('CustomHRMAssessments','PsEmployerNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsEmployerNeedsList	type_YOrN	NULL
											CHECK (PsEmployerNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsEmploymentIssues') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsEmploymentIssues	type_YesNoUnknown	NULL
											CHECK (PsEmploymentIssues in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsEmploymentIssuesComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsEmploymentIssuesComment	type_Comment2	NULL
END


IF COL_LENGTH('CustomHRMAssessments','PsEmploymentIssuesNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsEmploymentIssuesNeedsList	type_YOrN	NULL
											CHECK (PsEmploymentIssuesNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsRestrictionsOccupational') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsRestrictionsOccupational	type_YesNoUnknown	NULL
											CHECK (PsRestrictionsOccupational in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsRestrictionsOccupationalComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsRestrictionsOccupationalComment	type_Comment2	NULL
END


IF COL_LENGTH('CustomHRMAssessments','PsRestrictionsOccupationalNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsRestrictionsOccupationalNeedsList	type_YOrN	NULL
											CHECK (PsRestrictionsOccupationalNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsFunctionalAssessmentNeeded') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsFunctionalAssessmentNeeded	type_YOrN	NULL
											CHECK (PsFunctionalAssessmentNeeded in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsAdvocacyNeeded') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsAdvocacyNeeded	type_YOrN	NULL
											CHECK (PsAdvocacyNeeded in('Y','N'))
END
	
IF COL_LENGTH('CustomHRMAssessments','PsPlanDevelopmentNeeded') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsPlanDevelopmentNeeded	type_YOrN	NULL
											CHECK (PsPlanDevelopmentNeeded in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsLinkingNeeded') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsLinkingNeeded	type_YOrN	NULL
											CHECK (PsLinkingNeeded in('Y','N'))
END	

IF COL_LENGTH('CustomHRMAssessments','PsDDInformationProvidedBy') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsDDInformationProvidedBy	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','HistPreviousDx') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HistPreviousDx	type_YesNoUnknown	NULL
											CHECK (HistPreviousDx in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','HistPreviousDxComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HistPreviousDxComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','PsLegalIssues') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsLegalIssues	type_YesNoUnknown	NULL
											CHECK (PsLegalIssues in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsLegalIssuesComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsLegalIssuesComment	type_Comment2	NULL
END


IF COL_LENGTH('CustomHRMAssessments','PsLegalIssuesNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsLegalIssuesNeedsList	type_YOrN	NULL
											CHECK (PsLegalIssuesNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsCulturalEthnicIssues') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsCulturalEthnicIssues	type_YesNoUnknown	NULL
											CHECK (PsCulturalEthnicIssues in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsCulturalEthnicIssuesComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsCulturalEthnicIssuesComment	type_Comment2	NULL
END


IF COL_LENGTH('CustomHRMAssessments','PsCulturalEthnicIssuesNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsCulturalEthnicIssuesNeedsList	type_YOrN	NULL
											CHECK (PsCulturalEthnicIssuesNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsSpiritualityIssues') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsSpiritualityIssues	type_YesNoUnknown	NULL
											CHECK (PsSpiritualityIssues in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsSpiritualityIssuesComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsSpiritualityIssuesComment	type_Comment2	NULL
END


IF COL_LENGTH('CustomHRMAssessments','PsSpiritualityIssuesNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsSpiritualityIssuesNeedsList	type_YOrN	NULL
											CHECK (PsSpiritualityIssuesNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','SuicideNotPresent') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SuicideNotPresent	type_YOrN	NULL
											CHECK (SuicideNotPresent in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','SuicideIdeation') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SuicideIdeation	type_YOrN	NULL
											CHECK (SuicideIdeation in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','SuicideActive') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SuicideActive	type_YOrN	NULL
											CHECK (SuicideActive in('Y','N'))
END


IF COL_LENGTH('CustomHRMAssessments','SuicidePassive') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SuicidePassive	type_YOrN	NULL
											CHECK (SuicidePassive in('Y','N'))
END


IF COL_LENGTH('CustomHRMAssessments','SuicideMeans') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SuicideMeans	type_YOrN	NULL
											CHECK (SuicideMeans in('Y','N'))
END


IF COL_LENGTH('CustomHRMAssessments','SuicidePlan') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SuicidePlan	type_YOrN	NULL
											CHECK (SuicidePlan in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','SuicideCurrent') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SuicideCurrent	type_YOrN	NULL
											CHECK (SuicideCurrent in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','SuicidePriorAttempt') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SuicidePriorAttempt	type_YOrN	NULL
											CHECK (SuicidePriorAttempt in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','SuicideNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SuicideNeedsList	type_YOrN	NULL
											CHECK (SuicideNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','SuicideBehaviorsPastHistory') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SuicideBehaviorsPastHistory	type_Comment2	NULL
END	

IF COL_LENGTH('CustomHRMAssessments','SuicideOtherRiskSelf') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SuicideOtherRiskSelf	type_YOrN	NULL
											CHECK (SuicideOtherRiskSelf in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','SuicideBehaviorsPastHistory') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SuicideBehaviorsPastHistory	type_Comment2	NULL
END	

IF COL_LENGTH('CustomHRMAssessments','SuicideOtherRiskSelf') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SuicideOtherRiskSelf	type_YOrN	NULL
											CHECK (SuicideOtherRiskSelf in('Y','N'))
END


IF COL_LENGTH('CustomHRMAssessments','SuicideOtherRiskSelfComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SuicideOtherRiskSelfComment	type_Comment2	NULL
END	

IF COL_LENGTH('CustomHRMAssessments','HomicideNotPresent') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HomicideNotPresent	type_YOrN	NULL
											CHECK (HomicideNotPresent in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','HomicideIdeation') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HomicideIdeation	type_YOrN	NULL
											CHECK (HomicideIdeation in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','HomicideActive') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HomicideActive	type_YOrN	NULL
											CHECK (HomicideActive in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','HomicidePassive') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HomicidePassive	type_YOrN	NULL
											CHECK (HomicidePassive in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','HomicideMeans') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HomicideMeans	type_YOrN	NULL
											CHECK (HomicideMeans in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','HomicidePlan') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HomicidePlan	type_YOrN	NULL
											CHECK (HomicidePlan in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','HomicideCurrent') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HomicideCurrent	type_YOrN	NULL
											CHECK (HomicideCurrent in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','HomicidePriorAttempt') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HomicidePriorAttempt	type_YOrN	NULL
											CHECK (HomicidePriorAttempt in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','HomicideNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HomicideNeedsList	type_YOrN	NULL
											CHECK (HomicideNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','HomicideBehaviorsPastHistory') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HomicideBehaviorsPastHistory	type_Comment2	NULL
END	

IF COL_LENGTH('CustomHRMAssessments','HomicdeOtherRiskOthers') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HomicdeOtherRiskOthers	type_YOrN	NULL
											CHECK (HomicdeOtherRiskOthers in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','HomicideOtherRiskOthersComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HomicideOtherRiskOthersComment	type_Comment2	NULL
END	

IF COL_LENGTH('CustomHRMAssessments','PhysicalAgressionNotPresent') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PhysicalAgressionNotPresent	type_YOrN  NULL
											CHECK (PhysicalAgressionNotPresent in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PhysicalAgressionSelf') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PhysicalAgressionSelf	type_YOrN  NULL
											CHECK (PhysicalAgressionSelf in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PhysicalAgressionOthers') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PhysicalAgressionOthers	type_YOrN  NULL
											CHECK (PhysicalAgressionOthers in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PhysicalAgressionCurrentIssue') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PhysicalAgressionCurrentIssue	type_YOrN  NULL
											CHECK (PhysicalAgressionCurrentIssue in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PhysicalAgressionNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PhysicalAgressionNeedsList	type_YOrN  NULL
											CHECK (PhysicalAgressionNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PhysicalAgressionBehaviorsPastHistory') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PhysicalAgressionBehaviorsPastHistory	type_Comment2	NULL
END	

IF COL_LENGTH('CustomHRMAssessments','RiskAccessToWeapons') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD RiskAccessToWeapons	type_YOrN  NULL
											CHECK (RiskAccessToWeapons in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','RiskAppropriateForAdditionalScreening') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD RiskAppropriateForAdditionalScreening	type_YOrN  NULL
											CHECK (RiskAppropriateForAdditionalScreening in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','RiskClinicalIntervention') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD RiskClinicalIntervention	type_Comment2	NULL
END	

IF COL_LENGTH('CustomHRMAssessments','RiskOtherFactorsNone') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD RiskOtherFactorsNone	type_YOrN  NULL
											CHECK (RiskOtherFactorsNone in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','RiskOtherFactors') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD RiskOtherFactors	type_Comment2	NULL
END	

IF COL_LENGTH('CustomHRMAssessments','RiskOtherFactorsNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD RiskOtherFactorsNeedsList	type_YOrN  NULL
											CHECK (RiskOtherFactorsNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','StaffAxisV') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD StaffAxisV	int		NULL
END	

IF COL_LENGTH('CustomHRMAssessments','StaffAxisVReason') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD StaffAxisVReason	type_Comment2	NULL
END	

IF COL_LENGTH('CustomHRMAssessments','ClientStrengthsNarrative') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD ClientStrengthsNarrative	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','CrisisPlanningClientHasPlan') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD CrisisPlanningClientHasPlan	type_YOrN  NULL
											CHECK (CrisisPlanningClientHasPlan in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','CrisisPlanningNarrative') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD CrisisPlanningNarrative	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','CrisisPlanningDesired') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD CrisisPlanningDesired	 type_YOrN  NULL
											CHECK (CrisisPlanningDesired in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','CrisisPlanningNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD CrisisPlanningNeedsList	 type_YOrN  NULL
											CHECK (CrisisPlanningNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','CrisisPlanningMoreInfo') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD CrisisPlanningMoreInfo	 type_YOrN  NULL
											CHECK (CrisisPlanningMoreInfo in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','AdvanceDirectiveClientHasDirective') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD AdvanceDirectiveClientHasDirective	 type_YOrN  NULL
											CHECK (AdvanceDirectiveClientHasDirective in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','AdvanceDirectiveDesired') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD AdvanceDirectiveDesired	 type_YOrN  NULL
											CHECK (AdvanceDirectiveDesired in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','AdvanceDirectiveNarrative') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD AdvanceDirectiveNarrative	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','AdvanceDirectiveNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD AdvanceDirectiveNeedsList	type_YOrN  NULL
											CHECK (AdvanceDirectiveNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','AdvanceDirectiveMoreInfo') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD AdvanceDirectiveMoreInfo	type_YOrN  NULL
											CHECK (AdvanceDirectiveMoreInfo in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','NaturalSupportSufficiency') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD NaturalSupportSufficiency	char(2)	NULL
END

IF COL_LENGTH('CustomHRMAssessments','NaturalSupportNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD NaturalSupportNeedsList	type_YOrN  NULL
											CHECK (NaturalSupportNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','NaturalSupportIncreaseDesired') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD NaturalSupportIncreaseDesired	type_YOrN  NULL
											CHECK (NaturalSupportIncreaseDesired in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','ClinicalSummary') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD ClinicalSummary	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','UncopeQuestionU') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD UncopeQuestionU	type_YOrN  NULL
											CHECK (UncopeQuestionU in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','UncopeApplicable') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD UncopeApplicable	type_YOrN  NULL
											CHECK (UncopeApplicable in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','UncopeApplicableReason') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD UncopeApplicableReason	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','UncopeQuestionN') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD UncopeQuestionN	type_YOrN  NULL
											CHECK (UncopeQuestionN in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','UncopeQuestionC') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD UncopeQuestionC	type_YOrN  NULL
											CHECK (UncopeQuestionC in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','UncopeQuestionO') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD UncopeQuestionO	type_YOrN  NULL
											CHECK (UncopeQuestionO in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','UncopeQuestionP') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD UncopeQuestionP	type_YOrN  NULL
											CHECK (UncopeQuestionP in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','UncopeQuestionE') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD UncopeQuestionE	type_YOrN  NULL
											CHECK (UncopeQuestionE in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','UncopeCompleteFullSUAssessment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD UncopeCompleteFullSUAssessment	type_YOrN  NULL
											CHECK (UncopeCompleteFullSUAssessment in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','SubstanceUseNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SubstanceUseNeedsList	type_YOrN  NULL
											CHECK (SubstanceUseNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','DecreaseSymptomsNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DecreaseSymptomsNeedsList	type_YOrN  NULL
											CHECK (DecreaseSymptomsNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','DDEPreviouslyMet') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DDEPreviouslyMet	type_YOrN  NULL
											CHECK (DDEPreviouslyMet in('Y','N'))
END
IF COL_LENGTH('CustomHRMAssessments','DDAttributableMentalPhysicalLimitation') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DDAttributableMentalPhysicalLimitation	type_YOrN  NULL
											CHECK (DDAttributableMentalPhysicalLimitation in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','DDDxAxisI') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DDDxAxisI	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','DDDxAxisII') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DDDxAxisII	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','DDDxAxisIII') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DDDxAxisIII	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','DDDxAxisIV') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DDDxAxisIV	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','DDDxAxisV') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DDDxAxisV	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','DDDxSource') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DDDxSource	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','DDManifestBeforeAge22') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DDManifestBeforeAge22	type_YOrN  NULL
											CHECK (DDManifestBeforeAge22 in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','DDContinueIndefinitely') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DDContinueIndefinitely	type_YOrN  NULL
											CHECK (DDContinueIndefinitely in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','DDLimitSelfCare') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DDLimitSelfCare	type_YOrN  NULL
											CHECK (DDLimitSelfCare in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','DDLimitLanguage') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DDLimitLanguage	type_YOrN  NULL
											CHECK (DDLimitLanguage in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','DDLimitMobility') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DDLimitMobility	type_YOrN  NULL
											CHECK (DDLimitMobility in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','DDLimitSelfDirection') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DDLimitSelfDirection	type_YOrN  NULL
											CHECK (DDLimitSelfDirection in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','DDLimitEconomic') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DDLimitEconomic	type_YOrN  NULL
											CHECK (DDLimitEconomic in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','DDLimitIndependentLiving') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DDLimitIndependentLiving	type_YOrN  NULL
											CHECK (DDLimitIndependentLiving in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','DDNeedMulitpleSupports') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DDNeedMulitpleSupports	type_YOrN  NULL
											CHECK (DDNeedMulitpleSupports in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','CAFASDate') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD CAFASDate	datetime	NULL
END

IF COL_LENGTH('CustomHRMAssessments','RaterClinician') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD RaterClinician	int	NULL
END

IF COL_LENGTH('CustomHRMAssessments','CAFASInterval') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD CAFASInterval	type_GlobalCode	NULL
END
IF COL_LENGTH('CustomHRMAssessments','SchoolPerformance') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SchoolPerformance	int	NULL
END

IF COL_LENGTH('CustomHRMAssessments','SchoolPerformanceComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SchoolPerformanceComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','HomePerformance') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HomePerformance	int	NULL
END

IF COL_LENGTH('CustomHRMAssessments','HomePerfomanceComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD HomePerfomanceComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','CommunityPerformance') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD CommunityPerformance	int	NULL
END

IF COL_LENGTH('CustomHRMAssessments','CommunityPerformanceComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD CommunityPerformanceComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','BehaviorTowardsOther') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD BehaviorTowardsOther	int	NULL
END

IF COL_LENGTH('CustomHRMAssessments','BehaviorTowardsOtherComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD BehaviorTowardsOtherComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','MoodsEmotion') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD MoodsEmotion	int	NULL
END

IF COL_LENGTH('CustomHRMAssessments','MoodsEmotionComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD MoodsEmotionComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','SelfHarmfulBehavior') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SelfHarmfulBehavior	int	NULL
END

IF COL_LENGTH('CustomHRMAssessments','SelfHarmfulBehaviorComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SelfHarmfulBehaviorComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','SubstanceUse') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SubstanceUse	int	NULL
END

IF COL_LENGTH('CustomHRMAssessments','SubstanceUseComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SubstanceUseComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','Thinkng') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD Thinkng	int	NULL
END

IF COL_LENGTH('CustomHRMAssessments','ThinkngComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD ThinkngComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','YouthTotalScore') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD YouthTotalScore	int	NULL
END

IF COL_LENGTH('CustomHRMAssessments','PrimaryFamilyMaterialNeeds') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PrimaryFamilyMaterialNeeds	int	NULL
END

IF COL_LENGTH('CustomHRMAssessments','PrimaryFamilyMaterialNeedsComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PrimaryFamilyMaterialNeedsComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','PrimaryFamilySocialSupport') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PrimaryFamilySocialSupport	int	NULL
END

IF COL_LENGTH('CustomHRMAssessments','PrimaryFamilySocialSupportComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PrimaryFamilySocialSupportComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','NonCustodialMaterialNeeds') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD NonCustodialMaterialNeeds	int	NULL
END

IF COL_LENGTH('CustomHRMAssessments','NonCustodialMaterialNeedsComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD NonCustodialMaterialNeedsComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','NonCustodialSocialSupport') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD NonCustodialSocialSupport	int	NULL
END

IF COL_LENGTH('CustomHRMAssessments','NonCustodialSocialSupportComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD NonCustodialSocialSupportComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','SurrogateMaterialNeeds') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SurrogateMaterialNeeds	int	NULL
END

IF COL_LENGTH('CustomHRMAssessments','SurrogateMaterialNeedsComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SurrogateMaterialNeedsComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','SurrogateSocialSupport') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SurrogateSocialSupport	int	NULL
END

IF COL_LENGTH('CustomHRMAssessments','SurrogateSocialSupportComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SurrogateSocialSupportComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','DischargeCriteria') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DischargeCriteria	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','PrePlanFiscalIntermediaryComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PrePlanFiscalIntermediaryComment	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','StageOfChange') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD StageOfChange	type_GlobalCode	NULL
END


IF COL_LENGTH('CustomHRMAssessments','PsEducation') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsEducation	type_YesNoUnknown  NULL
											CHECK (PsEducation in('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PsEducationNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsEducationNeedsList	type_YOrN  NULL
											CHECK (PsEducationNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsMedications') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsMedications	char(1)  NULL
											CHECK (PsMedications in('Y','U','N','I','L'))
END

IF COL_LENGTH('CustomHRMAssessments','PsMedicationsNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsMedicationsNeedsList	type_YOrN  NULL
											CHECK (PsMedicationsNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsMedicationsListToBeModified') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsMedicationsListToBeModified	type_YOrN  NULL
											CHECK (PsMedicationsListToBeModified in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PhysicalConditionQuadriplegic') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PhysicalConditionQuadriplegic	type_YOrN  NULL
											CHECK (PhysicalConditionQuadriplegic in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PhysicalConditionMultipleSclerosis') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PhysicalConditionMultipleSclerosis	type_YOrN  NULL
											CHECK (PhysicalConditionMultipleSclerosis in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PhysicalConditionBlindness') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PhysicalConditionBlindness	type_YOrN  NULL
											CHECK (PhysicalConditionBlindness in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PhysicalConditionDeafness') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PhysicalConditionDeafness	type_YOrN  NULL
											CHECK (PhysicalConditionDeafness in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PhysicalConditionParaplegic') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PhysicalConditionParaplegic	type_YOrN  NULL
											CHECK (PhysicalConditionParaplegic in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PhysicalConditionCerebral') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PhysicalConditionCerebral	type_YOrN  NULL
											CHECK (PhysicalConditionCerebral in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PhysicalConditionMuteness') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PhysicalConditionMuteness	type_YOrN  NULL
											CHECK (PhysicalConditionMuteness in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PhysicalConditionOtherHearingImpairment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PhysicalConditionOtherHearingImpairment	type_YOrN  NULL
											CHECK (PhysicalConditionOtherHearingImpairment in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','TestingReportsReviewed') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD TestingReportsReviewed	varchar(2)  NULL
END

IF COL_LENGTH('CustomHRMAssessments','SevereProfoundDisability') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SevereProfoundDisability	type_YOrN  NULL
											CHECK (SevereProfoundDisability in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','SevereProfoundDisabilityComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SevereProfoundDisabilityComment	type_Comment2  NULL
END

IF COL_LENGTH('CustomHRMAssessments','EmploymentStatus') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD EmploymentStatus	type_GlobalCode  NULL
END

IF COL_LENGTH('CustomHRMAssessments','DxTabDisabled') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DxTabDisabled	type_YOrN  NULL
											CHECK (DxTabDisabled in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsMedicationsSideEffects') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PsMedicationsSideEffects	type_Comment2  NULL
END

IF COL_LENGTH('CustomHRMAssessments','AutisticallyImpaired') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD AutisticallyImpaired	type_YOrN  NULL
											CHECK (AutisticallyImpaired in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','CognitivelyImpaired') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD CognitivelyImpaired	type_YOrN  NULL
											CHECK (CognitivelyImpaired in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','EmotionallyImpaired') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD EmotionallyImpaired	type_YOrN  NULL
											CHECK (EmotionallyImpaired in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','BehavioralConcern') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD BehavioralConcern	type_YOrN  NULL
											CHECK (BehavioralConcern in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','LearningDisabilities') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD LearningDisabilities	type_YOrN  NULL
											CHECK (LearningDisabilities in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PhysicalImpaired') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PhysicalImpaired	type_YOrN  NULL
											CHECK (PhysicalImpaired in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','IEP') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD IEP	type_YOrN  NULL
											CHECK (IEP in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','ChallengesBarrier') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD ChallengesBarrier	type_YOrN  NULL
											CHECK (ChallengesBarrier in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','UnProtectedSexualRelationMoreThenOnePartner') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD UnProtectedSexualRelationMoreThenOnePartner	type_YOrN  NULL
											CHECK (UnProtectedSexualRelationMoreThenOnePartner in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','SexualRelationWithHIVInfected') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SexualRelationWithHIVInfected	type_YOrN  NULL
											CHECK (SexualRelationWithHIVInfected in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','SexualRelationWithDrugInject') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SexualRelationWithDrugInject	type_YOrN  NULL
											CHECK (SexualRelationWithDrugInject in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','InjectsDrugsSharedNeedle') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD InjectsDrugsSharedNeedle	type_YOrN  NULL
											CHECK (InjectsDrugsSharedNeedle in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','ReceivedAnyFavorsForSexualRelation') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD ReceivedAnyFavorsForSexualRelation	type_YOrN  NULL
											CHECK (ReceivedAnyFavorsForSexualRelation in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','FamilyFriendFeelingsCausedDistress') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD FamilyFriendFeelingsCausedDistress	type_YOrN  NULL
											CHECK (FamilyFriendFeelingsCausedDistress in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','FeltNervousAnxious') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD FeltNervousAnxious	type_GlobalCode  NULL
END

IF COL_LENGTH('CustomHRMAssessments','NotAbleToStopWorrying') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD NotAbleToStopWorrying	type_GlobalCode  NULL
END

IF COL_LENGTH('CustomHRMAssessments','StressPeoblemForHandlingThing') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD StressPeoblemForHandlingThing	type_GlobalCode  NULL
END
IF COL_LENGTH('CustomHRMAssessments','SocialAndEmotionalNeed') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SocialAndEmotionalNeed	type_GlobalCode  NULL
END

IF COL_LENGTH('CustomHRMAssessments','DepressionAnxietyRecommendation') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DepressionAnxietyRecommendation	type_YOrN	NULL
									CHECK(DepressionAnxietyRecommendation in ('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','CommunicableDiseaseRecommendation') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD CommunicableDiseaseRecommendation	type_YOrN	NULL
									CHECK(CommunicableDiseaseRecommendation in ('Y','N'))
END
IF COL_LENGTH('CustomHRMAssessments','PleasureInDoingThings') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PleasureInDoingThings	type_GlobalCode  NULL
END

IF COL_LENGTH('CustomHRMAssessments','DepressedHopelessFeeling') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DepressedHopelessFeeling	type_GlobalCode  NULL
END

IF COL_LENGTH('CustomHRMAssessments','AsleepSleepingFalling') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD AsleepSleepingFalling	type_GlobalCode  NULL
END
IF COL_LENGTH('CustomHRMAssessments','TiredFeeling') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD TiredFeeling	type_GlobalCode  NULL
END

IF COL_LENGTH('CustomHRMAssessments','OverEating') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD OverEating	type_GlobalCode  NULL
END

IF COL_LENGTH('CustomHRMAssessments','BadAboutYourselfFeeling') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD BadAboutYourselfFeeling	type_GlobalCode  NULL
END
IF COL_LENGTH('CustomHRMAssessments','TroubleConcentratingOnThings') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD TroubleConcentratingOnThings	type_GlobalCode  NULL
END

IF COL_LENGTH('CustomHRMAssessments','SpeakingSlowlyOrOpposite') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SpeakingSlowlyOrOpposite	type_GlobalCode  NULL
END

IF COL_LENGTH('CustomHRMAssessments','BetterOffDeadThought') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD BetterOffDeadThought	type_GlobalCode  NULL
END
IF COL_LENGTH('CustomHRMAssessments','DifficultProblem') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DifficultProblem	type_GlobalCode  NULL
END

IF COL_LENGTH('CustomHRMAssessments','SexualityComment') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD SexualityComment	type_Comment2  NULL
END

IF COL_LENGTH('CustomHRMAssessments','ReceivePrenatalCare') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD ReceivePrenatalCare	type_YesNoUnknown	NULL
											CHECK(ReceivePrenatalCare in ('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','ReceivePrenatalCareNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD ReceivePrenatalCareNeedsList	type_YOrN	NULL
											CHECK (ReceivePrenatalCareNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','ProblemInPregnancy') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD ProblemInPregnancy	type_YesNoUnknown	NULL
											CHECK(ProblemInPregnancy in ('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','ProblemInPregnancyNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD ProblemInPregnancyNeedsList	type_YOrN	NULL
											CHECK (ProblemInPregnancyNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','WhenTheyTalk') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD WhenTheyTalk	type_Comment2  NULL
END

IF COL_LENGTH('CustomHRMAssessments','DevelopmentalAttachmentComments') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DevelopmentalAttachmentComments	type_Comment2  NULL
END

IF COL_LENGTH('CustomHRMAssessments','PrenatalExposer') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PrenatalExposer	type_YesNoUnknown	NULL
											CHECK(PrenatalExposer in ('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','PrenatalExposerNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD PrenatalExposerNeedsList	type_YOrN	NULL
											CHECK (PrenatalExposerNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','WhereMedicationUsed') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD WhereMedicationUsed	type_YesNoUnknown	NULL
											CHECK(WhereMedicationUsed in ('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','WhereMedicationUsedNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD WhereMedicationUsedNeedsList	type_YOrN	NULL
											CHECK (WhereMedicationUsedNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','IssueWithDelivery') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD IssueWithDelivery	type_YesNoUnknown	NULL
											CHECK(IssueWithDelivery in ('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','IssueWithDeliveryNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD IssueWithDeliveryNeedsList	type_YOrN	NULL
											CHECK (IssueWithDeliveryNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','ChildDevelopmentalMilestones') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD ChildDevelopmentalMilestones	type_YesNoUnknown	NULL
											CHECK(ChildDevelopmentalMilestones in ('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','ChildDevelopmentalMilestonesNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD ChildDevelopmentalMilestonesNeedsList	type_YOrN	NULL
											CHECK (ChildDevelopmentalMilestonesNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','TalkBefore') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD TalkBefore	type_YesNoUnknown	NULL
											CHECK(TalkBefore in ('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','TalkBeforeNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD TalkBeforeNeedsList	type_YOrN	NULL
											CHECK (TalkBeforeNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','ParentChildRelationshipIssue') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD ParentChildRelationshipIssue	type_YesNoUnknown	NULL
											CHECK(ParentChildRelationshipIssue in ('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','ParentChildRelationshipNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD ParentChildRelationshipNeedsList	type_YOrN	NULL
											CHECK (ParentChildRelationshipNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','FamilyRelationshipIssues') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD FamilyRelationshipIssues	type_YesNoUnknown	NULL
											CHECK(FamilyRelationshipIssues in ('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','FamilyRelationshipNeedsList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD FamilyRelationshipNeedsList	type_YOrN	NULL
											CHECK (FamilyRelationshipNeedsList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','WhenTheyTalkSentences') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD WhenTheyTalkSentences	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','WhenTheyWalk') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD WhenTheyWalk	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','AddSexualitytoNeedList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD AddSexualitytoNeedList	type_YesNoUnknown	NULL
											CHECK(AddSexualitytoNeedList in ('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','WhenTheyWalkUnknown') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD WhenTheyWalkUnknown	type_YesNoUnknown	NULL
											CHECK(WhenTheyWalkUnknown in ('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','WhenTheyTalkUnknown') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD WhenTheyTalkUnknown	type_YesNoUnknown	NULL
											CHECK(WhenTheyTalkUnknown in ('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','WhenTheyTalkSentenceUnknown') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD WhenTheyTalkSentenceUnknown	type_YesNoUnknown	NULL
											CHECK(WhenTheyTalkSentenceUnknown in ('Y','N','U'))
END

IF COL_LENGTH('CustomHRMAssessments','ClientInAutsimPopulation') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD ClientInAutsimPopulation	type_YOrN	NULL
											CHECK (ClientInAutsimPopulation  in ('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','LegalIssues') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD LegalIssues	type_Comment2 NULL
END

IF COL_LENGTH('CustomHRMAssessments','CSSRSAdultOrChild') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD CSSRSAdultOrChild	Char(1)	NULL	
											CHECK (CSSRSAdultOrChild  in ('A','C'))
END

IF COL_LENGTH('CustomHRMAssessments','Strengths') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD Strengths	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','TransitionLevelOfCare') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD TransitionLevelOfCare	type_Comment2	NULL
END


IF COL_LENGTH('CustomHRMAssessments','ReductionInSymptoms') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD ReductionInSymptoms	type_YOrN	NULL
											CHECK (ReductionInSymptoms in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','AttainmentOfHigherFunctioning') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD AttainmentOfHigherFunctioning	type_YOrN	NULL
											CHECK (AttainmentOfHigherFunctioning in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','TreatmentNotNecessary') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD TreatmentNotNecessary	type_YOrN	NULL
											CHECK (TreatmentNotNecessary in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','OtherTransitionCriteria') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD OtherTransitionCriteria	type_YOrN	NULL
											CHECK (OtherTransitionCriteria in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','EstimatedDischargeDate') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD EstimatedDischargeDate	datetime	NULL
END

IF COL_LENGTH('CustomHRMAssessments','ReductionInSymptomsDescription') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD ReductionInSymptomsDescription	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','AttainmentOfHigherFunctioningDescription') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD AttainmentOfHigherFunctioningDescription	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','TreatmentNotNecessaryDescription') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD TreatmentNotNecessaryDescription	type_Comment2	NULL
END

IF COL_LENGTH('CustomHRMAssessments','OtherTransitionCriteriaDescription') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD OtherTransitionCriteriaDescription	type_Comment2	NULL
END
	

IF COL_LENGTH('CustomHRMAssessments','DepressionPHQToNeedList') IS NULL 
BEGIN
 ALTER TABLE CustomHRMAssessments ADD DepressionPHQToNeedList	type_YOrN	NULL
											CHECK (DepressionPHQToNeedList in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','InitialRequestDate')IS NULL
BEGIN
	ALTER TABLE CustomHRMAssessments ADD InitialRequestDate datetime NULL	
END

IF COL_LENGTH('CustomHRMAssessments','PsRiskHigherLevelOfCare')IS NULL
BEGIN
	ALTER TABLE CustomHRMAssessments ADD PsRiskHigherLevelOfCare type_YOrN	NULL
									 CHECK (PsRiskHigherLevelOfCare in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsRiskHigherLevelOfCareDueTo')IS NULL
BEGIN
	ALTER TABLE CustomHRMAssessments ADD PsRiskHigherLevelOfCareDueTo type_GlobalCode  NULL	
END

IF COL_LENGTH('CustomHRMAssessments','PsRiskOutOfCountryPlacement')IS NULL
BEGIN
	ALTER TABLE CustomHRMAssessments ADD PsRiskOutOfCountryPlacement type_YOrN	NULL
									 CHECK (PsRiskOutOfCountryPlacement in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsRiskOutOfCountryPlacementDueTo')IS NULL
BEGIN
	ALTER TABLE CustomHRMAssessments ADD PsRiskOutOfCountryPlacementDueTo type_GlobalCode  NULL	
END

IF COL_LENGTH('CustomHRMAssessments','PsRiskOutOfHomePlacement')IS NULL
BEGIN
	ALTER TABLE CustomHRMAssessments ADD PsRiskOutOfHomePlacement type_YOrN	NULL
									 CHECK (PsRiskOutOfHomePlacement in('Y','N'))
END

IF COL_LENGTH('CustomHRMAssessments','PsRiskOutOfHomePlacementDueTo')IS NULL
BEGIN
	ALTER TABLE CustomHRMAssessments ADD PsRiskOutOfHomePlacementDueTo type_GlobalCode  NULL	
END

IF COL_LENGTH('CustomHRMAssessments','CommunicableDiseaseAssessed')IS NULL
BEGIN
	ALTER TABLE CustomHRMAssessments ADD CommunicableDiseaseAssessed type_GlobalCode  NULL	
END

IF COL_LENGTH('CustomHRMAssessments','CommunicableDiseaseFurtherInfo')IS NULL
BEGIN
	ALTER TABLE CustomHRMAssessments ADD CommunicableDiseaseFurtherInfo type_Comment2	NULL
END

----------------------------------------------------------------------------------------------------

IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	BEGIN					
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CustomHRMAssessments') AND type in (N'U'))     Exec sp_rename  CustomHRMAssessments,CustomHRMAssessments_Temp111
		PRINT 'STEP 1 COMPLETED'
	END
	
	IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	BEGIN
		IF EXISTS (SELECT * FROM sys.objects WHERE object_id=OBJECT_ID(N'ssp_DeleteTableChecks') AND type IN (N'P',N'PC')) 	DROP PROCEDURE ssp_DeleteTableChecks
	END
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	BEGIN
		exec ('create PROCEDURE ssp_DeleteTableChecks
		@TableName varchar(128)   
		as  
		  
		create table #temp1  
		(ConstraintName varchar(128) null,  
		ConstraintDefinition varchar(1000) null,  
		Col1 int null,  
		Col2 int null)  
		  
		declare @ConstraintName varchar(128)  
		declare @DropSQLString varchar(1000)  
  
		insert into #temp1  
		exec sp_MStablechecks @TableName  
		  
		if @@error <> 0 return  
		  
		declare cur_DropCheck cursor for  
		select ConstraintName  
		from #temp1  
		  
		if @@error <> 0 return  
		  
		open cur_DropCheck  
		  
		if @@error <> 0 return  
		  
		fetch cur_DropCheck into @ConstraintName  
		  
		while @@Fetch_Status = 0  
		begin  
		  
		set @DropSQLString = ''ALTER TABLE '' + @TableName + '' DROP CONSTRAINT '' + @ConstraintName  
		  
		if @@error <> 0 return  
		  
		print @DropSQLString  
		execute(@DropSQLString)  
		  
		if @@error <> 0 return  
		  
		fetch cur_DropCheck into @ConstraintName  
		  
		if @@error <> 0 return  
		  
		end  
		  
		close cur_DropCheck  
		  
		if @@error <> 0 return  
		  
		deallocate cur_DropCheck  
		  
		if @@error <> 0 return ') 
		
	END
		
--End of Step 1	
------ STEP 2 ----------
--Part1 Begin
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	exec ssp_DeleteTableChecks 'CustomHRMAssessments_Temp111'
--Part2 Begins
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	BEGIN
	declare @PKName nvarchar(max)
	declare @tempPK  nvarchar(max)

	IF EXISTS(SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'CustomHRMAssessments_Temp111') AND is_primary_key=1)
	BEGIN
		SET @PKName=(SELECT name FROM sys.indexes WHERE object_id = OBJECT_ID(N'CustomHRMAssessments_Temp111') AND is_primary_key=1)
		SET @tempPK=@PKName +'_Temp111'
		Exec sp_rename  @PKName,@tempPK
	END			
	END
-----End of Step 2 -------
------ STEP 3 ------------
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce )
BEGIN 
	IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[CustomLOCs_CustomHRMAssessments_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomHRMAssessments_Temp111]'))
	ALTER TABLE [dbo].[CustomHRMAssessments_Temp111] DROP CONSTRAINT [CustomLOCs_CustomHRMAssessments_FK]	
END
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce )
BEGIN 
	IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[DocumentVersions_CustomHRMAssessments_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomHRMAssessments_Temp111]'))
	ALTER TABLE [dbo].[CustomHRMAssessments_Temp111] DROP CONSTRAINT [DocumentVersions_CustomHRMAssessments_FK]	
END
------ STEP 4 ----------

/* 
 * TABLE: CustomHRMAssessments 
 */
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
BEGIN
 CREATE TABLE CustomHRMAssessments(
	DocumentVersionId						int						NOT NULL,
	CreatedBy								type_CurrentUser		NOT NULL,
	CreatedDate								type_CurrentDatetime	NOT NULL,
	ModifiedBy								type_CurrentUser		NOT NULL,
	ModifiedDate							type_CurrentDatetime	NOT NULL,
	RecordDeleted							type_YOrN				NULL
											CHECK (RecordDeleted in	('Y','N')),	
	DeletedBy								type_UserId				NULL,
	DeletedDate								datetime				NULL,
	LOCId									int						NULL,
	ClientName								varchar(150)			NULL,
	AssessmentType							char(1)					NULL
											CHECK (AssessmentType in('S','A','U','I')),	
	CurrentAssessmentDate					datetime				NULL,
	PreviousAssessmentDate					datetime				NULL,
	ClientDOB								datetime				NULL,
	AdultOrChild							char(1)					NULL,
	ChildHasNoParentalConsent				type_YOrN				NULL
											CHECK (ChildHasNoParentalConsent in	('Y','N')),	
	ClientHasGuardian						type_YOrN				NULL
											CHECK (ClientHasGuardian in	('Y','N')),	
	GuardianName							varchar(150)			NULL,
	GuardianAddress							type_Address			NULL,
	GuardianPhone							type_PhoneNumber		NULL,
	GuardianType							type_GlobalCode			NULL,
	ClientInDDPopulation					type_YOrN				NULL
											CHECK (ClientInDDPopulation in	('Y','N')),	
	ClientInSAPopulation					type_YOrN				NULL
											CHECK (ClientInSAPopulation in	('Y','N')),	
	ClientInMHPopulation					type_YOrN				NULL
											CHECK (ClientInMHPopulation in	('Y','N')),	
	PreviousDiagnosisText					type_Comment2			NULL,
	ReferralType							type_GlobalCode			NULL,
	PresentingProblem						type_Comment2			NULL,
	CurrentLivingArrangement				type_GlobalCode			NULL,
	CurrentPrimaryCarePhysician				varchar(50)				NULL,
	ReasonForUpdate							type_Comment2			NULL,
	DesiredOutcomes							type_Comment2			NULL,
	PsMedicationsComment					type_Comment2			NULL,
	PsEducationComment						type_Comment2			NULL,
	IncludeFunctionalAssessment				type_YOrN				NULL
											CHECK (IncludeFunctionalAssessment in ('Y','N')),	
	IncludeSymptomChecklist					type_YOrN				NULL
											CHECK (IncludeSymptomChecklist in	('Y','N')),	
	IncludeUNCOPE							type_YOrN				NULL
											CHECK (IncludeUNCOPE in	('Y','N')),	
	ClientIsAppropriateForTreatment			type_YOrN				NULL
											CHECK (ClientIsAppropriateForTreatment in('Y','N')),	
	SecondOpinionNoticeProvided				type_YOrN				NULL
											CHECK (SecondOpinionNoticeProvided in('Y','N')),	
	TreatmentNarrative						type_Comment2			NULL,
	RapCiDomainIntensity					varchar(50)				NULL,
	RapCiDomainComment						type_Comment2			NULL,
	RapCiDomainNeedsList					type_YOrN				NULL
											CHECK (RapCiDomainNeedsList in	('Y','N')),	
	RapCbDomainIntensity					varchar(50)				NULL,
	RapCbDomainComment						type_Comment2			NULL,
	RapCbDomainNeedsList					type_YOrN				NULL
											CHECK (RapCbDomainNeedsList in	('Y','N')),	
	RapCaDomainIntensity					varchar(50)				NULL,
	RapCaDomainComment						type_Comment2			NULL,
	RapCaDomainNeedsList					type_YOrN				NULL
											CHECK (RapCaDomainNeedsList in	('Y','N')),	
	RapHhcDomainIntensity					varchar(50)				NULL,
	OutsideReferralsGiven					type_YOrN				NULL
											CHECK (OutsideReferralsGiven in	('Y','N')),	
	ReferralsNarrative						type_Comment2			NULL,
	ServiceOther							type_YOrN				NULL
											CHECK (ServiceOther in	('Y','N')),	
	ServiceOtherDescription					varchar(100)			NULL,
	AssessmentAddtionalInformation			type_Comment2			NULL,
	TreatmentAccomodation					type_Comment2			NULL,
	Participants							type_Comment2			NULL,
	Facilitator								type_Comment2			NULL,
	TimeLocation							type_Comment2			NULL,
	AssessmentsNeeded						type_Comment2			NULL,
	CommunicationAccomodations				type_Comment2			NULL,
	IssuesToAvoid							type_Comment2			NULL,
	IssuesToDiscuss							type_Comment2			NULL,
	SourceOfPrePlanningInfo					type_Comment2			NULL,
	SelfDeterminationDesired				type_YOrNOrNA			NULL
											CHECK (SelfDeterminationDesired in('Y','N','A')),	
	FiscalIntermediaryDesired				type_YOrNOrNA			NULL
											CHECK (FiscalIntermediaryDesired in	('Y','N','A')),	
	PamphletGiven							type_YOrN				NULL
											CHECK (PamphletGiven in	('Y','N')),	
	PamphletDiscussed						type_YOrN				NULL
											CHECK (PamphletDiscussed in	('Y','N')),	
	PrePlanIndependentFacilitatorDiscussed	type_YOrN				NULL
											CHECK (PrePlanIndependentFacilitatorDiscussed in('Y','N')),	
	PrePlanIndependentFacilitatorDesired	type_YOrN				NULL
											CHECK (PrePlanIndependentFacilitatorDesired in('Y','N')),	
	PrePlanGuardianContacted				type_YOrN				NULL
											CHECK (PrePlanGuardianContacted in	('Y','N')),	
	PrePlanSeparateDocument					type_YOrN				NULL
											CHECK (PrePlanSeparateDocument in	('Y','N')),	
	CommunityActivitiesCurrentDesired		type_Comment2			NULL,
	CommunityActivitiesIncreaseDesired		type_YOrN				NULL
											CHECK (CommunityActivitiesIncreaseDesired in('Y','N')),	
	CommunityActivitiesNeedsList			type_YOrN				NULL
											CHECK (CommunityActivitiesNeedsList in	('Y','N')),	
	PsCurrentHealthIssues					type_YesNoUnknown		NULL
											CHECK (PsCurrentHealthIssues in ('Y','N','U')),
	PsCurrentHealthIssuesComment			type_Comment2			NULL,
	PsCurrentHealthIssuesNeedsList			type_YOrN				NULL
											CHECK (PsCurrentHealthIssuesNeedsList in('Y','N')),	
	HistMentalHealthTx						type_YesNoUnknown		NULL
											CHECK (HistMentalHealthTx in ('Y','N','U')),
	HistMentalHealthTxNeedsList				type_YOrN				NULL
											CHECK (HistMentalHealthTxNeedsList in('Y','N')),	
	HistMentalHealthTxComment				type_Comment2			NULL,
	HistFamilyMentalHealthTx				type_YesNoUnknown		NULL
											CHECK (HistFamilyMentalHealthTx in ('Y','N','U')),
	HistFamilyMentalHealthTxNeedsList		type_YOrN				NULL
											CHECK (HistFamilyMentalHealthTxNeedsList in	('Y','N')),	
	HistFamilyMentalHealthTxComment			type_Comment2			NULL,
	PsClientAbuseIssues						type_YesNoUnknown		NULL
											CHECK (PsClientAbuseIssues in ('Y','N','U')),
	PsClientAbuesIssuesComment				type_Comment2			NULL,
	PsClientAbuseIssuesNeedsList			type_YOrN				NULL
											CHECK (PsClientAbuseIssuesNeedsList in('Y','N')),	
	PsFamilyConcernsComment					type_Comment2			NULL,
	PsRiskLossOfPlacement					type_YOrN				NULL
											CHECK (PsRiskLossOfPlacement in	('Y','N')),	
	PsRiskLossOfPlacementDueTo				type_GlobalCode			NULL,
	PsRiskSensoryMotorFunction				type_YOrN				NULL
											CHECK (PsRiskSensoryMotorFunction in	('Y','N')),	
	PsRiskSensoryMotorFunctionDueTo			type_GlobalCode			NULL,
	PsRiskSafety							type_YOrN				NULL
											CHECK (PsRiskSafety in	('Y','N')),	
	PsRiskSafetyDueTo						type_GlobalCode			NULL,
	PsRiskLossOfSupport						type_YOrN				NULL
											CHECK (PsRiskLossOfSupport in	('Y','N')),	
	PsRiskLossOfSupportDueTo				type_GlobalCode			NULL,
	PsRiskExpulsionFromSchool				type_YOrN				NULL
											CHECK (PsRiskExpulsionFromSchool in	('Y','N')),	
	PsRiskExpulsionFromSchoolDueTo			type_GlobalCode			NULL,
	PsRiskHospitalization					type_YOrN				NULL
											CHECK (PsRiskHospitalization in	('Y','N')),	
	PsRiskHospitalizationDueTo				type_GlobalCode			NULL,
	PsRiskCriminalJusticeSystem				type_YOrN				NULL
											CHECK (PsRiskCriminalJusticeSystem in	('Y','N')),	
	PsRiskCriminalJusticeSystemDueTo		type_GlobalCode			NULL,
	PsRiskElopementFromHome					type_YOrN				NULL
											CHECK (PsRiskElopementFromHome in	('Y','N')),	
	PsRiskElopementFromHomeDueTo			type_GlobalCode			NULL,
	PsRiskLossOfFinancialStatus				type_YOrN				NULL
											CHECK (PsRiskLossOfFinancialStatus in	('Y','N')),	
	PsRiskLossOfFinancialStatusDueTo		type_GlobalCode			NULL,
	PsDevelopmentalMilestones				type_YesNoUnknown		NULL
											CHECK (PsDevelopmentalMilestones in ('Y','N','U')),
	PsDevelopmentalMilestonesComment		type_Comment2			NULL,
	PsDevelopmentalMilestonesNeedsList		type_YOrN				NULL
											CHECK (PsDevelopmentalMilestonesNeedsList in	('Y','N')),	
	PsChildEnvironmentalFactors				type_YesNoUnknown		NULL
											CHECK (PsChildEnvironmentalFactors in ('Y','N','U')),
	PsChildEnvironmentalFactorsComment		type_Comment2			NULL,
	PsChildEnvironmentalFactorsNeedsList	type_YOrN				NULL
											CHECK (PsChildEnvironmentalFactorsNeedsList in	('Y','N')),	
	PsLanguageFunctioning					type_YesNoUnknown		NULL
											CHECK (PsLanguageFunctioning in ('Y','N','U')),
	PsLanguageFunctioningComment			type_Comment2			NULL,
	PsLanguageFunctioningNeedsList			type_YOrN				NULL
											CHECK (PsLanguageFunctioningNeedsList in('Y','N')),	
	PsVisualFunctioning						type_YesNoUnknown		NULL
											CHECK (PsVisualFunctioning in ('Y','N','U')),
	PsVisualFunctioningComment				type_Comment2			NULL,
	PsVisualFunctioningNeedsList			type_YOrN				NULL
											CHECK (PsVisualFunctioningNeedsList in('Y','N')),	
	PsPrenatalExposure						type_YesNoUnknown		NULL
											CHECK (PsPrenatalExposure in ('Y','N','U')),
	PsPrenatalExposureComment				type_Comment2			NULL,
	PsPrenatalExposureNeedsList				type_YOrN				NULL
											CHECK (PsPrenatalExposureNeedsList in	('Y','N')),	
	PsChildMentalHealthHistory				type_YesNoUnknown		NULL
											CHECK (PsChildMentalHealthHistory in ('Y','N','U')),
	PsChildMentalHealthHistoryComment		type_Comment2			NULL,
	PsChildMentalHealthHistoryNeedsList		type_YOrN				NULL
											CHECK (PsChildMentalHealthHistoryNeedsList in	('Y','N')),	
	PsIntellectualFunctioning				type_YesNoUnknown		NULL,
	PsIntellectualFunctioningComment		type_Comment2			NULL,
	PsIntellectualFunctioningNeedsList		type_YOrN				NULL
											CHECK (PsIntellectualFunctioningNeedsList in	('Y','N')),	
	PsLearningAbility						type_YesNoUnknown		NULL
											CHECK (PsLearningAbility in ('Y','N','U')),
	PsLearningAbilityComment				type_Comment2			NULL,
	PsLearningAbilityNeedsList				type_YOrN				NULL
											CHECK (PsLearningAbilityNeedsList in ('Y','N')),	
	PsFunctioningConcernComment				type_Comment2			NULL,
	PsPeerInteraction						type_YesNoUnknown		NULL
											CHECK (PsPeerInteraction in ('Y','N','U')),
	PsPeerInteractionComment				type_Comment2			NULL,
	PsPeerInteractionNeedsList				type_YOrN				NULL
											CHECK (PsPeerInteractionNeedsList in('Y','N')),	
	PsParentalParticipation					type_YesNoUnknown		NULL
											CHECK (PsParentalParticipation in ('Y','N','U')),
	PsParentalParticipationComment			type_Comment2			NULL,
	PsParentalParticipationNeedsList		type_YOrN				NULL
											CHECK (PsParentalParticipationNeedsList in('Y','N')),	
	PsSchoolHistory							type_YesNoUnknown		NULL
											CHECK (PsSchoolHistory in ('Y','N','U')),
	PsSchoolHistoryComment					type_Comment2			NULL,
	PsSchoolHistoryNeedsList				type_YOrN				NULL
											CHECK (PsSchoolHistoryNeedsList in	('Y','N')),	
	PsImmunizations							type_YesNoUnknown		NULL
											CHECK (PsImmunizations in ('Y','N','U')),
	PsImmunizationsComment					type_Comment2			NULL,
	PsImmunizationsNeedsList				type_YOrN				NULL
											CHECK (PsImmunizationsNeedsList in('Y','N')),	
	PsChildHousingIssues					type_YesNoUnknown		NULL
											CHECK (PsChildHousingIssues in ('Y','N','U')),
	PsChildHousingIssuesComment				type_Comment2			NULL,
	PsChildHousingIssuesNeedsList			type_YOrN				NULL
											CHECK (PsChildHousingIssuesNeedsList in	('Y','N')),	
	PsSexuality								type_YesNoUnknown		NULL
											CHECK (PsSexuality in ('Y','N','U')),
	PsSexualityComment						type_Comment2			NULL,
	PsSexualityNeedsList					type_YOrN				NULL
											CHECK (PsSexualityNeedsList in	('Y','N')),	
	PsFamilyFunctioning						type_YesNoUnknown		NULL
											CHECK (PsFamilyFunctioning in ('Y','N','U')),
	PsFamilyFunctioningComment				type_Comment2			NULL,
	PsFamilyFunctioningNeedsList			type_YOrN				NULL
											CHECK (PsFamilyFunctioningNeedsList in	('Y','N')),	
	PsTraumaticIncident						type_YesNoUnknown		NULL
											CHECK (PsTraumaticIncident in ('Y','N','U')),
	PsTraumaticIncidentComment				type_Comment2			NULL,
	PsTraumaticIncidentNeedsList			type_YOrN				NULL
											CHECK (PsTraumaticIncidentNeedsList in	('Y','N')),	
	HistDevelopmental						type_YesNoUnknown		NULL
											CHECK (HistDevelopmental in ('Y','N','U')),
	HistDevelopmentalComment				type_Comment2			NULL,
	HistResidential							type_YesNoUnknown		NULL
											CHECK (HistResidential in ('Y','N','U')),
	HistResidentialComment					type_Comment2			NULL,
	HistOccupational						type_YesNoUnknown		NULL
											CHECK (HistOccupational in ('Y','N','U')),
	HistOccupationalComment					type_Comment2			NULL,
	HistLegalFinancial						type_YesNoUnknown		NULL
											CHECK (HistLegalFinancial in ('Y','N','U')),
	HistLegalFinancialComment				type_Comment2			NULL,
	SignificantEventsPastYear				type_Comment2			NULL,
	PsGrossFineMotor						type_YesNoUnknown		NULL
											CHECK (PsGrossFineMotor in ('Y','N','U')),
	PsGrossFineMotorComment					type_Comment2			NULL,
	PsGrossFineMotorNeedsList				type_YOrN				NULL
											CHECK (PsGrossFineMotorNeedsList in	('Y','N')),	
	PsSensoryPerceptual						type_YesNoUnknown		NULL
											CHECK (PsSensoryPerceptual in ('Y','N','U')),
	PsSensoryPerceptualComment				type_Comment2			NULL,
	PsSensoryPerceptualNeedsList			type_YOrN				NULL
											CHECK (PsSensoryPerceptualNeedsList in	('Y','N')),	
	PsCognitiveFunction						type_YesNoUnknown		NULL
											CHECK (PsCognitiveFunction in ('Y','N','U')),
	PsCognitiveFunctionComment				type_Comment2			NULL,
	PsCognitiveFunctionNeedsList			type_YOrN				NULL
											CHECK (PsCognitiveFunctionNeedsList in	('Y','N')),	
	PsCommunicativeFunction					type_YesNoUnknown		NULL,
	PsCommunicativeFunctionComment			type_Comment2			NULL,
	PsCommunicativeFunctionNeedsList		type_YOrN				NULL
											CHECK (PsCommunicativeFunctionNeedsList in	('Y','N')),	
	PsCurrentPsychoSocialFunctiion			type_YesNoUnknown		NULL
											CHECK (PsCurrentPsychoSocialFunctiion in ('Y','N','U')),
	PsCurrentPsychoSocialFunctiionComment	type_Comment2			NULL,
	PsCurrentPsychoSocialFunctiionNeedsList type_YOrN				NULL
											CHECK (PsCurrentPsychoSocialFunctiionNeedsList in('Y','N')),	
	PsAdaptiveEquipment						type_YesNoUnknown		NULL
											CHECK (PsAdaptiveEquipment in ('Y','N','U')),
	PsAdaptiveEquipmentComment				type_Comment2			NULL,
	PsAdaptiveEquipmentNeedsList			type_YOrN				NULL
											CHECK (PsAdaptiveEquipmentNeedsList in	('Y','N')),	
	PsSafetyMobilityHome					type_YesNoUnknown		NULL
											CHECK (PsSafetyMobilityHome in ('Y','N','U')),
	PsSafetyMobilityHomeComment				type_Comment2			NULL,
	PsSafetyMobilityHomeNeedsList			type_YOrN				NULL
											CHECK (PsSafetyMobilityHomeNeedsList in	('Y','N')),	
	PsHealthSafetyChecklistComplete			type_YesNoNoanswerNotasked NULL
											CHECK (PsHealthSafetyChecklistComplete in('NAS','NAN','Y','N')),	
	PsAccessibilityIssues					type_YesNoUnknown		NULL
											CHECK (PsAccessibilityIssues in ('Y','N','U')),
	PsAccessibilityIssuesComment			type_Comment2			NULL,
	PsAccessibilityIssuesNeedsList			type_YOrN				NULL
											CHECK (PsAccessibilityIssuesNeedsList in	('Y','N')),	
	PsEvacuationTraining					type_YesNoUnknown		NULL
											CHECK (PsEvacuationTraining in ('Y','N','U')),
	PsEvacuationTrainingComment				type_Comment2			NULL,
	PsEvacuationTrainingNeedsList			type_YOrN				NULL
											CHECK (PsEvacuationTrainingNeedsList in	('Y','N')),	
	Ps24HourSetting							type_YesNoUnknown		NULL
											CHECK (Ps24HourSetting in ('Y','N','U')),
	Ps24HourSettingComment					type_Comment2			NULL,
	Ps24HourSettingNeedsList				type_YOrN				NULL
											CHECK (Ps24HourSettingNeedsList in	('Y','N')),	
	Ps24HourNeedsAwakeSupervision			type_YesNoUnknown		NULL
											CHECK (Ps24HourNeedsAwakeSupervision in ('Y','N','U')),
	PsSpecialEdEligibility					type_YesNoUnknown		NULL
											CHECK (PsSpecialEdEligibility in ('Y','N','U')),
	PsSpecialEdEligibilityComment			type_Comment2			NULL,
	PsSpecialEdEligibilityNeedsList			type_YOrN				NULL
											CHECK (PsSpecialEdEligibilityNeedsList in	('Y','N')),	
	PsSpecialEdEnrolled						type_YesNoUnknown		NULL
											CHECK (PsSpecialEdEnrolled in ('Y','N','U')),
	PsSpecialEdEnrolledComment				type_Comment2			NULL,
	PsSpecialEdEnrolledNeedsList			type_YOrN				NULL
											CHECK (PsSpecialEdEnrolledNeedsList in	('Y','N')),	
	PsEmployer								type_YesNoUnknown		NULL
											CHECK (PsEmployer in('Y','N','U')),		
	PsEmployerComment						type_Comment2			NULL,
	PsEmployerNeedsList						type_YOrN				NULL
											CHECK (PsEmployerNeedsList in	('Y','N')),	
	PsEmploymentIssues						type_YesNoUnknown		NULL
											CHECK (PsEmploymentIssues in('Y','N')),	
	PsEmploymentIssuesComment				type_Comment2			NULL,
	PsEmploymentIssuesNeedsList				type_YOrN				NULL
											CHECK (PsEmploymentIssuesNeedsList in('Y','N')),	
	PsRestrictionsOccupational				type_YesNoUnknown		NULL
											CHECK (PsRestrictionsOccupational in ('Y','N','U')),
	PsRestrictionsOccupationalComment		type_Comment2			NULL,
	PsRestrictionsOccupationalNeedsList		type_YOrN				NULL
											CHECK (PsRestrictionsOccupationalNeedsList in('Y','N')),	
	PsFunctionalAssessmentNeeded			type_YOrN				NULL
											CHECK (PsFunctionalAssessmentNeeded in	('Y','N')),	
	PsAdvocacyNeeded						type_YOrN				NULL
											CHECK (PsAdvocacyNeeded in	('Y','N')),	
	PsPlanDevelopmentNeeded					type_YOrN				NULL
											CHECK (PsPlanDevelopmentNeeded in ('Y','N')),	
	PsLinkingNeeded							type_YOrN				NULL
											CHECK (PsLinkingNeeded in('Y','N')),	
	PsDDInformationProvidedBy				type_Comment2			NULL,
	HistPreviousDx							type_YesNoUnknown		NULL
											CHECK (HistPreviousDx in ('Y','N','U')),
	HistPreviousDxComment					type_Comment2			NULL,
	PsLegalIssues							type_YesNoUnknown		NULL
											CHECK (PsLegalIssues in ('Y','N','U')),
	PsLegalIssuesComment					type_Comment2			NULL,
	PsLegalIssuesNeedsList					type_YOrN				NULL
											CHECK (PsLegalIssuesNeedsList in	('Y','N')),	
	PsCulturalEthnicIssues					type_YesNoUnknown		NULL
											CHECK (PsCulturalEthnicIssues in ('Y','N','U')),
	PsCulturalEthnicIssuesComment			type_Comment2			NULL,
	PsCulturalEthnicIssuesNeedsList			type_YOrN				NULL
											CHECK (PsCulturalEthnicIssuesNeedsList in('Y','N')),	
	PsSpiritualityIssues					type_YesNoUnknown		NULL
											CHECK (PsSpiritualityIssues in	('Y','N','U')),	
	PsSpiritualityIssuesComment				type_Comment2			NULL,
	PsSpiritualityIssuesNeedsList			type_YOrN				NULL
											CHECK (PsSpiritualityIssuesNeedsList in	('Y','N')),	
	SuicideNotPresent						type_YOrN				NULL
											CHECK (SuicideNotPresent in	('Y','N')),	
	SuicideIdeation							type_YOrN				NULL
											CHECK (SuicideIdeation in	('Y','N')),	
	SuicideActive							type_YOrN				NULL
											CHECK (SuicideActive in	('Y','N')),	
	SuicidePassive							type_YOrN				NULL
											CHECK (SuicidePassive in	('Y','N')),	
	SuicideMeans							type_YOrN				NULL
											CHECK (SuicideMeans in	('Y','N')),	
	SuicidePlan								type_YOrN				NULL
											CHECK (SuicidePlan in	('Y','N')),	
	SuicideCurrent							type_YOrN				NULL
											CHECK (SuicideCurrent in	('Y','N')),	
	SuicidePriorAttempt						type_YOrN				NULL
											CHECK (SuicidePriorAttempt in	('Y','N')),	
	SuicideNeedsList						type_YOrN				NULL
											CHECK (SuicideNeedsList in	('Y','N')),	
	SuicideBehaviorsPastHistory				type_Comment2			NULL,
	SuicideOtherRiskSelf					type_YOrN				NULL
											CHECK (SuicideOtherRiskSelf in	('Y','N')),	
	SuicideOtherRiskSelfComment				type_Comment2			NULL,
	HomicideNotPresent						type_YOrN				NULL
											CHECK (HomicideNotPresent in	('Y','N')),	
	HomicideIdeation						type_YOrN				NULL
											CHECK (HomicideIdeation in	('Y','N')),	
	HomicideActive							type_YOrN				NULL
											CHECK (HomicideActive in	('Y','N')),	
	HomicidePassive							type_YOrN				NULL
											CHECK (HomicidePassive in	('Y','N')),	
	HomicideMeans							type_YOrN				NULL
											CHECK (HomicideMeans in	('Y','N')),	
	HomicidePlan							type_YOrN				NULL
											CHECK (HomicidePlan in	('Y','N')),	
	HomicideCurrent							type_YOrN				NULL
											CHECK (HomicideCurrent in	('Y','N')),	
	HomicidePriorAttempt					type_YOrN				NULL
											CHECK (HomicidePriorAttempt in	('Y','N')),	
	HomicideNeedsList						type_YOrN				NULL
											CHECK (HomicideNeedsList in	('Y','N')),	
	HomicideBehaviorsPastHistory			type_Comment2			NULL,
	HomicdeOtherRiskOthers					type_YOrN				NULL
											CHECK (HomicdeOtherRiskOthers in	('Y','N')),	
	HomicideOtherRiskOthersComment			type_Comment2			NULL,
	PhysicalAgressionNotPresent				type_YOrN				NULL
											CHECK (PhysicalAgressionNotPresent in	('Y','N')),	
	PhysicalAgressionSelf					type_YOrN				NULL
											CHECK (PhysicalAgressionSelf in	('Y','N')),	
	PhysicalAgressionOthers					type_YOrN				NULL
											CHECK (PhysicalAgressionOthers in	('Y','N')),	
	PhysicalAgressionCurrentIssue			type_YOrN				NULL
											CHECK (PhysicalAgressionCurrentIssue in	('Y','N')),	
	PhysicalAgressionNeedsList				type_YOrN				NULL
											CHECK (PhysicalAgressionNeedsList in	('Y','N')),	
	PhysicalAgressionBehaviorsPastHistory	type_Comment2			NULL,
	RiskAccessToWeapons						type_YOrN				NULL
											CHECK (RiskAccessToWeapons in	('Y','N')),	
	RiskAppropriateForAdditionalScreening	type_YOrN				NULL
											CHECK (RiskAppropriateForAdditionalScreening in	('Y','N')),	
	RiskClinicalIntervention				type_Comment2			NULL,
	RiskOtherFactorsNone					type_YOrN				NULL
											CHECK (RiskOtherFactorsNone in	('Y','N')),	
	RiskOtherFactors						type_Comment2			NULL,
	RiskOtherFactorsNeedsList				type_YOrN				NULL
											CHECK (RiskOtherFactorsNeedsList in	('Y','N')),	
	StaffAxisV								int						NULL,
	StaffAxisVReason						type_Comment2			NULL,
	ClientStrengthsNarrative				type_Comment2			NULL,
	CrisisPlanningClientHasPlan				type_YOrN				NULL
											CHECK (CrisisPlanningClientHasPlan in	('Y','N')),	
	CrisisPlanningNarrative					type_Comment2			NULL,
	CrisisPlanningDesired					type_YOrN				NULL
											CHECK (CrisisPlanningDesired in	('Y','N')),	
	CrisisPlanningNeedsList					type_YOrN				NULL
											CHECK (CrisisPlanningNeedsList in	('Y','N')),	
	CrisisPlanningMoreInfo					type_YOrN				NULL
											CHECK (CrisisPlanningMoreInfo in	('Y','N')),	
	AdvanceDirectiveClientHasDirective		type_YOrN				NULL
											CHECK (AdvanceDirectiveClientHasDirective in	('Y','N')),	
	AdvanceDirectiveDesired					type_YOrN				NULL
											CHECK (AdvanceDirectiveDesired in	('Y','N')),	
	AdvanceDirectiveNarrative				type_Comment2			NULL,
	AdvanceDirectiveNeedsList				type_YOrN				NULL
											CHECK (AdvanceDirectiveNeedsList in	('Y','N')),	
	AdvanceDirectiveMoreInfo				type_YOrN				NULL
											CHECK (AdvanceDirectiveMoreInfo in	('Y','N')),	
	NaturalSupportSufficiency				char(2)					NULL,
	NaturalSupportNeedsList					type_YOrN				NULL
											CHECK (NaturalSupportNeedsList in	('Y','N')),	
	NaturalSupportIncreaseDesired			type_YOrN				NULL
											CHECK (NaturalSupportIncreaseDesired in	('Y','N')),	
	ClinicalSummary							type_Comment2			NULL,
	UncopeQuestionU							type_YOrN				NULL
											CHECK (UncopeQuestionU in('Y','N')),	
	UncopeApplicable						type_YOrN				NULL
											CHECK (UncopeApplicable in	('Y','N')),	
	UncopeApplicableReason					type_Comment2			NULL,
	UncopeQuestionN							type_YOrN				NULL
											CHECK (UncopeQuestionN in	('Y','N')),	
	UncopeQuestionC							type_YOrN				NULL
											CHECK (UncopeQuestionC in	('Y','N')),	
	UncopeQuestionO							type_YOrN				NULL
											CHECK (UncopeQuestionO in	('Y','N')),	
	UncopeQuestionP							type_YOrN				NULL
											CHECK (UncopeQuestionP in	('Y','N')),	
	UncopeQuestionE							type_YOrN				NULL
											CHECK (UncopeQuestionE in	('Y','N')),	
	UncopeCompleteFullSUAssessment			type_YOrN				NULL
											CHECK (UncopeCompleteFullSUAssessment in('Y','N')),	
	SubstanceUseNeedsList					type_YOrN				NULL
											CHECK (SubstanceUseNeedsList in	('Y','N')),	
	DecreaseSymptomsNeedsList				type_YOrN				NULL
											CHECK (DecreaseSymptomsNeedsList in	('Y','N')),	
	DDEPreviouslyMet						type_YOrN				NULL
											CHECK (DDEPreviouslyMet in	('Y','N')),	
	DDAttributableMentalPhysicalLimitation	type_YOrN				NULL
											CHECK (DDAttributableMentalPhysicalLimitation in('Y','N')),	
	DDDxAxisI								type_Comment2			NULL,
	DDDxAxisII								type_Comment2			NULL,
	DDDxAxisIII								type_Comment2			NULL,
	DDDxAxisIV								type_Comment2			NULL,
	DDDxAxisV								type_Comment2			NULL,
	DDDxSource								type_Comment2			NULL,
	DDManifestBeforeAge22					type_YOrN				NULL
											CHECK (DDManifestBeforeAge22 in	('Y','N')),	
	DDContinueIndefinitely					type_YOrN				NULL
											CHECK (DDContinueIndefinitely in	('Y','N')),	
	DDLimitSelfCare							type_YOrN				NULL
											CHECK (DDLimitSelfCare in	('Y','N')),	
	DDLimitLanguage							type_YOrN				NULL
											CHECK (DDLimitLanguage in	('Y','N')),	
	DDLimitLearning							type_YOrN				NULL
											CHECK (DDLimitLearning in	('Y','N')),	
	DDLimitMobility							type_YOrN				NULL
											CHECK (DDLimitMobility in	('Y','N')),	
	DDLimitSelfDirection					type_YOrN				NULL
											CHECK (DDLimitSelfDirection in	('Y','N')),	
	DDLimitEconomic							type_YOrN				NULL
											CHECK (DDLimitEconomic in	('Y','N')),	
	DDLimitIndependentLiving				type_YOrN				NULL
											CHECK (DDLimitIndependentLiving in('Y','N')),	
	DDNeedMulitpleSupports					type_YOrN				NULL
											CHECK (DDNeedMulitpleSupports in('Y','N')),	
	CAFASDate								datetime				NULL,
	RaterClinician							int						NULL,
	CAFASInterval							type_GlobalCode			NULL,
	SchoolPerformance						int						NULL,
	SchoolPerformanceComment				type_Comment2			NULL,
	HomePerformance							int						NULL,
	HomePerfomanceComment					type_Comment2			NULL,
	CommunityPerformance					int						NULL,
	CommunityPerformanceComment				type_Comment2			NULL,
	BehaviorTowardsOther					int						NULL,
	BehaviorTowardsOtherComment				type_Comment2			NULL,
	MoodsEmotion							int						NULL,
	MoodsEmotionComment						type_Comment2			NULL,
	SelfHarmfulBehavior						int						NULL,
	SelfHarmfulBehaviorComment				type_Comment2			NULL,
	SubstanceUse							int						NULL,
	SubstanceUseComment						type_Comment2			NULL,
	Thinkng									int						NULL,
	ThinkngComment							type_Comment2			NULL,
	YouthTotalScore							int						NULL,
	PrimaryFamilyMaterialNeeds				int						NULL,
	PrimaryFamilyMaterialNeedsComment		type_Comment2			NULL,
	PrimaryFamilySocialSupport				int						NULL,
	PrimaryFamilySocialSupportComment		type_Comment2			NULL,
	NonCustodialMaterialNeeds				int						NULL,
	NonCustodialMaterialNeedsComment		type_Comment2			NULL,
	NonCustodialSocialSupport				int						NULL,
	NonCustodialSocialSupportComment		type_Comment2			NULL,
	SurrogateMaterialNeeds					int						NULL,
	SurrogateMaterialNeedsComment			type_Comment2			NULL,
	SurrogateSocialSupport					int						NULL,
	SurrogateSocialSupportComment			type_Comment2			NULL,
	DischargeCriteria						type_Comment2			NULL,
	PrePlanFiscalIntermediaryComment		type_Comment2			NULL,
	StageOfChange							type_GlobalCode			NULL,
	PsEducation								type_YesNoUnknown		NULL
											CHECK (PsEducation in('Y','N','U')),
	PsEducationNeedsList					type_YOrN				NULL
											CHECK (PsEducationNeedsList in('Y','N')),
	PsMedications							char(1)					NULL
											CHECK (PsMedications in	('Y','U','N','I','L')),	
	PsMedicationsNeedsList					type_YOrN				NULL
											CHECK (PsMedicationsNeedsList in	('Y','N')),	
	PsMedicationsListToBeModified			type_YOrN				NULL
											CHECK (PsMedicationsListToBeModified in	('Y','N')),	
	PhysicalConditionQuadriplegic			type_YOrN				NULL
											CHECK (PhysicalConditionQuadriplegic in	('Y','N')),	
	PhysicalConditionMultipleSclerosis		type_YOrN				NULL
											CHECK (PhysicalConditionMultipleSclerosis in ('Y','N')),	
	PhysicalConditionBlindness				type_YOrN				NULL
											CHECK (PhysicalConditionBlindness in('Y','N')),	
	PhysicalConditionDeafness				type_YOrN				NULL
											CHECK (PhysicalConditionDeafness in	('Y','N')),	
	PhysicalConditionParaplegic				type_YOrN				NULL
											CHECK (PhysicalConditionParaplegic in	('Y','N')),	
	PhysicalConditionCerebral				type_YOrN				NULL
											CHECK (PhysicalConditionCerebral in	('Y','N')),	
	PhysicalConditionMuteness				type_YOrN				NULL
											CHECK (PhysicalConditionMuteness in	('Y','N')),	
	PhysicalConditionOtherHearingImpairment type_YOrN				NULL
											CHECK (PhysicalConditionOtherHearingImpairment in	('Y','N')),	
	TestingReportsReviewed					varchar(2)				NULL,	
	SevereProfoundDisability				type_YOrN				NULL
											CHECK (SevereProfoundDisability in	('Y','N')),	
	SevereProfoundDisabilityComment			type_Comment2			NULL,
	EmploymentStatus						type_GlobalCode			NULL,
	DxTabDisabled							type_YOrN				NULL
											CHECK (DxTabDisabled in	('Y','N')),
	PsMedicationsSideEffects				type_Comment2			NULL,	
	AutisticallyImpaired					type_YOrN				NULL
											CHECK (AutisticallyImpaired in	('Y','N')),
	CognitivelyImpaired						type_YOrN				NULL
											CHECK (CognitivelyImpaired in	('Y','N')),
	EmotionallyImpaired						type_YOrN				NULL
											CHECK (EmotionallyImpaired in	('Y','N')),
	BehavioralConcern						type_YOrN				NULL
											CHECK (BehavioralConcern in	('Y','N')),
	LearningDisabilities					type_YOrN				NULL
											CHECK (LearningDisabilities in	('Y','N')),
	PhysicalImpaired						type_YOrN				NULL
											CHECK (PhysicalImpaired in	('Y','N')),
	IEP										type_YOrN				NULL
											CHECK (IEP in	('Y','N')),
	ChallengesBarrier						type_YOrN				NULL
											CHECK (ChallengesBarrier in	('Y','N')),
	UnProtectedSexualRelationMoreThenOnePartner	type_YOrN				NULL
											CHECK (UnProtectedSexualRelationMoreThenOnePartner in	('Y','N')),
	SexualRelationWithHIVInfected			type_YOrN				NULL
											CHECK (SexualRelationWithHIVInfected in	('Y','N')),
	SexualRelationWithDrugInject			type_YOrN				NULL
											CHECK (SexualRelationWithDrugInject in	('Y','N')),
	InjectsDrugsSharedNeedle				type_YOrN				NULL
											CHECK (InjectsDrugsSharedNeedle in	('Y','N')),
	ReceivedAnyFavorsForSexualRelation		type_YOrN				NULL
											CHECK (ReceivedAnyFavorsForSexualRelation in('Y','N')),
	FamilyFriendFeelingsCausedDistress		type_YOrN				NULL
											CHECK (FamilyFriendFeelingsCausedDistress in('Y','N')),
	FeltNervousAnxious						type_GlobalCode			NULL,
	NotAbleToStopWorrying					type_GlobalCode			NULL,	
	StressPeoblemForHandlingThing			type_GlobalCode			NULL,
	SocialAndEmotionalNeed					type_GlobalCode			NULL,
	DepressionAnxietyRecommendation			type_YOrN				NULL
											CHECK (DepressionAnxietyRecommendation in('Y','N')),
	CommunicableDiseaseRecommendation		type_YOrN				NULL
											CHECK (CommunicableDiseaseRecommendation in('Y','N')),
	PleasureInDoingThings					type_GlobalCode			NULL,
	DepressedHopelessFeeling				type_GlobalCode			NULL,
	AsleepSleepingFalling					type_GlobalCode			NULL,
	TiredFeeling							type_GlobalCode			NULL,
	OverEating								type_GlobalCode			NULL,
	BadAboutYourselfFeeling					type_GlobalCode			NULL,
	TroubleConcentratingOnThings			type_GlobalCode			NULL,
	SpeakingSlowlyOrOpposite				type_GlobalCode			NULL,
	BetterOffDeadThought					type_GlobalCode			NULL,
	DifficultProblem						type_GlobalCode			NULL,
	SexualityComment						type_Comment2			NULL,
	ReceivePrenatalCare						type_YesNoUnknown		NULL
											CHECK(ReceivePrenatalCare in ('Y','N','U')),
	ReceivePrenatalCareNeedsList			type_YOrN				NULL
											CHECK (ReceivePrenatalCareNeedsList in('Y','N')),
	ProblemInPregnancy						type_YesNoUnknown		NULL
											CHECK(ProblemInPregnancy  in ('Y','N','U')),
	ProblemInPregnancyNeedsList				type_YOrN				NULL
											CHECK (ProblemInPregnancyNeedsList in('Y','N')),
	WhenTheyTalk							type_Comment2			NULL,
	DevelopmentalAttachmentComments			type_Comment2			NULL,
	PrenatalExposer							type_YesNoUnknown		NULL
											CHECK(PrenatalExposer  in ('Y','N','U')),
	PrenatalExposerNeedsList				type_YOrN				NULL
											CHECK (PrenatalExposerNeedsList in('Y','N')),
	WhereMedicationUsed						type_YesNoUnknown		NULL
											CHECK(WhereMedicationUsed  in ('Y','N','U')),
	WhereMedicationUsedNeedsList			type_YOrN				NULL
											CHECK (WhereMedicationUsedNeedsList in('Y','N')),
	IssueWithDelivery						type_YesNoUnknown		NULL
											CHECK(IssueWithDelivery  in ('Y','N','U')),
	IssueWithDeliveryNeedsList				type_YOrN				NULL
											CHECK (IssueWithDeliveryNeedsList in('Y','N')),
	ChildDevelopmentalMilestones			type_YesNoUnknown		NULL
											CHECK(ChildDevelopmentalMilestones  in ('Y','N','U')),
	ChildDevelopmentalMilestonesNeedsList	type_YOrN				NULL
											CHECK (ChildDevelopmentalMilestonesNeedsList in('Y','N')),
	TalkBefore								type_YesNoUnknown		NULL
											CHECK(TalkBefore in ('Y','N','U')),
	TalkBeforeNeedsList						type_YOrN				NULL
											CHECK(TalkBeforeNeedsList in ('Y','N')),
	ParentChildRelationshipIssue			type_YesNoUnknown		NULL
											CHECK(ParentChildRelationshipIssue in ('Y','N','U')),
	ParentChildRelationshipNeedsList		type_YOrN				NULL
											CHECK(ParentChildRelationshipNeedsList in ('Y','N')),
	FamilyRelationshipIssues				type_YesNoUnknown		NULL
											CHECK(FamilyRelationshipIssues in ('Y','N','U')),
	FamilyRelationshipNeedsList				type_YOrN				NULL
											CHECK(FamilyRelationshipNeedsList in ('Y','N')),
	WhenTheyTalkSentences					type_Comment2			NULL,	
	WhenTheyWalk							type_Comment2			NULL,
	AddSexualitytoNeedList					type_YesNoUnknown       NULL
											CHECK (AddSexualitytoNeedList in ('Y','N','U')),
	WhenTheyWalkUnknown						type_YesNoUnknown		NULL
											CHECK (WhenTheyWalkUnknown in ('Y','N','U')),
	WhenTheyTalkUnknown						type_YesNoUnknown		NULL
											CHECK (WhenTheyTalkUnknown in ('Y','N','U')),
	WhenTheyTalkSentenceUnknown				type_YesNoUnknown		NULL
											CHECK (WhenTheyTalkSentenceUnknown  in ('Y','N','U')),	
	ClientInAutsimPopulation				type_YOrN				NULL
											CHECK (ClientInAutsimPopulation  in ('Y','N')),	
	LegalIssues								type_Comment2			NULL,	
	CSSRSAdultOrChild						Char(1)					NULL	
											CHECK (CSSRSAdultOrChild  in ('A','C')),
	Strengths								type_Comment2			NULL,
	TransitionLevelOfCare					type_Comment2			NULL,
	ReductionInSymptoms						type_YOrN				NULL
											CHECK (ReductionInSymptoms in('Y','N')),
	AttainmentOfHigherFunctioning			type_YOrN				NULL
											CHECK (AttainmentOfHigherFunctioning in('Y','N')),
	TreatmentNotNecessary					type_YOrN				NULL
											CHECK (TreatmentNotNecessary in('Y','N')),
    OtherTransitionCriteria					type_YOrN				NULL
											CHECK (OtherTransitionCriteria in('Y','N'))	,
	EstimatedDischargeDate					datetime				NULL,	
	ReductionInSymptomsDescription			type_Comment2			NULL,
	AttainmentOfHigherFunctioningDescription type_Comment2			NULL,
	TreatmentNotNecessaryDescription		type_Comment2			NULL,
	OtherTransitionCriteriaDescription		type_Comment2			NULL,
	DepressionPHQToNeedList					type_YOrN				NULL
											CHECK (DepressionPHQToNeedList in('Y','N'))	,	
	InitialRequestDate						datetime				NULL,
	PsRiskHigherLevelOfCare					type_YOrN				NULL
											CHECK (PsRiskHigherLevelOfCare in('Y','N')),
	PsRiskHigherLevelOfCareDueTo			type_GlobalCode			NULL,
	PsRiskOutOfCountryPlacement				type_YOrN				NULL
											CHECK (PsRiskOutOfCountryPlacement in('Y','N')),
	PsRiskOutOfCountryPlacementDueTo		type_GlobalCode			NULL,
	PsRiskOutOfHomePlacement				type_YOrN				NULL
											CHECK (PsRiskOutOfHomePlacement in('Y','N')),	
	PsRiskOutOfHomePlacementDueTo			type_GlobalCode			NULL,
	CommunicableDiseaseAssessed				type_GlobalCode			NULL,
	CommunicableDiseaseFurtherInfo			type_Comment2			NULL,																																																																																																																																																																																																																																										
	CONSTRAINT CustomHRMAssessments_PK PRIMARY KEY CLUSTERED (DocumentVersionId)
 ) 
 IF OBJECT_ID('CustomHRMAssessments') IS NOT NULL
	PRINT '<<< CREATED TABLE CustomHRMAssessments >>>'
ELSE
	RAISERROR('<<< FAILED CREATING TABLE CustomHRMAssessments >>>', 16, 1)	
/* 
 * TABLE: CustomHRMAssessments 
 */
 ALTER TABLE CustomHRMAssessments ADD CONSTRAINT DocumentVersions_CustomHRMAssessments_FK 
		FOREIGN KEY (DocumentVersionId)
		REFERENCES DocumentVersions(DocumentVersionId)
		
 ALTER TABLE CustomHRMAssessments ADD CONSTRAINT CustomLOCs_CustomHRMAssessments_FK 
		FOREIGN KEY (LOCId)
		REFERENCES CustomLOCs(LOCId)
		
END

--END Of STEP 4

------ STEP 5 ----------------

IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
BEGIN
 INSERT INTO [CustomHRMAssessments]
	 ([DocumentVersionId]
      ,[ClientName]
      ,[AssessmentType]
      ,[CurrentAssessmentDate]
      ,[PreviousAssessmentDate]
      ,[ClientDOB]
      ,[AdultOrChild]
      ,[ChildHasNoParentalConsent]
      ,[ClientHasGuardian]
      ,[GuardianName]
      ,[GuardianAddress]
      ,[GuardianPhone]
      ,[GuardianType]
      ,[ClientInDDPopulation]
      ,[ClientInSAPopulation]
      ,[ClientInMHPopulation]
      ,[PreviousDiagnosisText]
      ,[ReferralType]
      ,[PresentingProblem]
      ,[CurrentLivingArrangement]
      ,[CurrentPrimaryCarePhysician]
      ,[ReasonForUpdate]
      ,[DesiredOutcomes]
      ,[PsMedicationsComment]
      ,[PsEducationComment]
      ,[IncludeFunctionalAssessment]
      ,[IncludeSymptomChecklist]
      ,[IncludeUNCOPE]
      ,[ClientIsAppropriateForTreatment]
      ,[SecondOpinionNoticeProvided]
      ,[TreatmentNarrative]
      ,[RapCiDomainIntensity]
      ,[RapCiDomainComment]
      ,[RapCiDomainNeedsList]
      ,[RapCbDomainIntensity]
      ,[RapCbDomainComment]
      ,[RapCbDomainNeedsList]
      ,[RapCaDomainIntensity]
      ,[RapCaDomainComment]
      ,[RapCaDomainNeedsList]
      ,[RapHhcDomainIntensity]
      ,[OutsideReferralsGiven]
      ,[ReferralsNarrative]
      ,[ServiceOther]
      ,[ServiceOtherDescription]
      ,[AssessmentAddtionalInformation]
      ,[TreatmentAccomodation]
      ,[Participants]
      ,[Facilitator]
      ,[TimeLocation]
      ,[AssessmentsNeeded]
      ,[CommunicationAccomodations]
      ,[IssuesToAvoid]
      ,[IssuesToDiscuss]
      ,[SourceOfPrePlanningInfo]
      ,[SelfDeterminationDesired]
      ,[FiscalIntermediaryDesired]
      ,[PamphletGiven]
      ,[PamphletDiscussed]
      ,[PrePlanIndependentFacilitatorDiscussed]
      ,[PrePlanIndependentFacilitatorDesired]
      ,[PrePlanGuardianContacted]
      ,[PrePlanSeparateDocument]
      ,[CommunityActivitiesCurrentDesired]
      ,[CommunityActivitiesIncreaseDesired]
      ,[CommunityActivitiesNeedsList]
      ,[PsCurrentHealthIssues]
      ,[PsCurrentHealthIssuesComment]
      ,[PsCurrentHealthIssuesNeedsList]
      ,[HistMentalHealthTx]
      ,[HistMentalHealthTxNeedsList]
      ,[HistMentalHealthTxComment]
      ,[HistFamilyMentalHealthTx]
      ,[HistFamilyMentalHealthTxNeedsList]
      ,[HistFamilyMentalHealthTxComment]
      ,[PsClientAbuseIssues]
      ,[PsClientAbuesIssuesComment]
      ,[PsClientAbuseIssuesNeedsList]
      ,[PsFamilyConcernsComment]
      ,[PsRiskLossOfPlacement]
      ,[PsRiskLossOfPlacementDueTo]
      ,[PsRiskSensoryMotorFunction]
      ,[PsRiskSensoryMotorFunctionDueTo]
      ,[PsRiskSafety]
      ,[PsRiskSafetyDueTo]
      ,[PsRiskLossOfSupport]
      ,[PsRiskLossOfSupportDueTo]
      ,[PsRiskExpulsionFromSchool]
      ,[PsRiskExpulsionFromSchoolDueTo]
      ,[PsRiskHospitalization]
      ,[PsRiskHospitalizationDueTo]
      ,[PsRiskCriminalJusticeSystem]
      ,[PsRiskCriminalJusticeSystemDueTo]
      ,[PsRiskElopementFromHome]
      ,[PsRiskElopementFromHomeDueTo]
      ,[PsRiskLossOfFinancialStatus]
      ,[PsRiskLossOfFinancialStatusDueTo]
      ,[PsDevelopmentalMilestones]
      ,[PsDevelopmentalMilestonesComment]
      ,[PsDevelopmentalMilestonesNeedsList]
      ,[PsChildEnvironmentalFactors]
      ,[PsChildEnvironmentalFactorsComment]
      ,[PsChildEnvironmentalFactorsNeedsList]
      ,[PsLanguageFunctioning]
      ,[PsLanguageFunctioningComment]
      ,[PsLanguageFunctioningNeedsList]
      ,[PsVisualFunctioning]
      ,[PsVisualFunctioningComment]
      ,[PsVisualFunctioningNeedsList]
      ,[PsPrenatalExposure]
      ,[PsPrenatalExposureComment]
      ,[PsPrenatalExposureNeedsList]
      ,[PsChildMentalHealthHistory]
      ,[PsChildMentalHealthHistoryComment]
      ,[PsChildMentalHealthHistoryNeedsList]
      ,[PsIntellectualFunctioning]
      ,[PsIntellectualFunctioningComment]
      ,[PsIntellectualFunctioningNeedsList]
      ,[PsLearningAbility]
      ,[PsLearningAbilityComment]
      ,[PsLearningAbilityNeedsList]
      ,[PsFunctioningConcernComment]
      ,[PsPeerInteraction]
      ,[PsPeerInteractionComment]
      ,[PsPeerInteractionNeedsList]
      ,[PsParentalParticipation]
      ,[PsParentalParticipationComment]
      ,[PsParentalParticipationNeedsList]
      ,[PsSchoolHistory]
      ,[PsSchoolHistoryComment]
      ,[PsSchoolHistoryNeedsList]
      ,[PsImmunizations]
      ,[PsImmunizationsComment]
      ,[PsImmunizationsNeedsList]
      ,[PsChildHousingIssues]
      ,[PsChildHousingIssuesComment]
      ,[PsChildHousingIssuesNeedsList]
      ,[PsSexuality]
      ,[PsSexualityComment]
      ,[PsSexualityNeedsList]
      ,[PsFamilyFunctioning]
      ,[PsFamilyFunctioningComment]
      ,[PsFamilyFunctioningNeedsList]
      ,[PsTraumaticIncident]
      ,[PsTraumaticIncidentComment]
      ,[PsTraumaticIncidentNeedsList]
      ,[HistDevelopmental]
      ,[HistDevelopmentalComment]
      ,[HistResidential]
      ,[HistResidentialComment]
      ,[HistOccupational]
      ,[HistOccupationalComment]
      ,[HistLegalFinancial]
      ,[HistLegalFinancialComment]
      ,[SignificantEventsPastYear]
      ,[PsGrossFineMotor]
      ,[PsGrossFineMotorComment]
      ,[PsGrossFineMotorNeedsList]
      ,[PsSensoryPerceptual]
      ,[PsSensoryPerceptualComment]
      ,[PsSensoryPerceptualNeedsList]
      ,[PsCognitiveFunction]
      ,[PsCognitiveFunctionComment]
      ,[PsCognitiveFunctionNeedsList]
      ,[PsCommunicativeFunction]
      ,[PsCommunicativeFunctionComment]
      ,[PsCommunicativeFunctionNeedsList]
      ,[PsCurrentPsychoSocialFunctiion]
      ,[PsCurrentPsychoSocialFunctiionComment]
      ,[PsCurrentPsychoSocialFunctiionNeedsList]
      ,[PsAdaptiveEquipment]
      ,[PsAdaptiveEquipmentComment]
      ,[PsAdaptiveEquipmentNeedsList]
      ,[PsSafetyMobilityHome]
      ,[PsSafetyMobilityHomeComment]
      ,[PsSafetyMobilityHomeNeedsList]
      ,[PsHealthSafetyChecklistComplete]
      ,[PsAccessibilityIssues]
      ,[PsAccessibilityIssuesComment]
      ,[PsAccessibilityIssuesNeedsList]
      ,[PsEvacuationTraining]
      ,[PsEvacuationTrainingComment]
      ,[PsEvacuationTrainingNeedsList]
      ,[Ps24HourSetting]
      ,[Ps24HourSettingComment]
      ,[Ps24HourSettingNeedsList]
      ,[Ps24HourNeedsAwakeSupervision]
      ,[PsSpecialEdEligibility]
      ,[PsSpecialEdEligibilityComment]
      ,[PsSpecialEdEligibilityNeedsList]
      ,[PsSpecialEdEnrolled]
      ,[PsSpecialEdEnrolledComment]
      ,[PsSpecialEdEnrolledNeedsList]
      ,[PsEmployer]
      ,[PsEmployerComment]
      ,[PsEmployerNeedsList]
      ,[PsEmploymentIssues]
      ,[PsEmploymentIssuesComment]
      ,[PsEmploymentIssuesNeedsList]
      ,[PsRestrictionsOccupational]
      ,[PsRestrictionsOccupationalComment]
      ,[PsRestrictionsOccupationalNeedsList]
      ,[PsFunctionalAssessmentNeeded]
      ,[PsAdvocacyNeeded]
      ,[PsPlanDevelopmentNeeded]
      ,[PsLinkingNeeded]
      ,[PsDDInformationProvidedBy]
      ,[HistPreviousDx]
      ,[HistPreviousDxComment]
      ,[PsLegalIssues]
      ,[PsLegalIssuesComment]
      ,[PsLegalIssuesNeedsList]
      ,[PsCulturalEthnicIssues]
      ,[PsCulturalEthnicIssuesComment]
      ,[PsCulturalEthnicIssuesNeedsList]
      ,[PsSpiritualityIssues]
      ,[PsSpiritualityIssuesComment]
      ,[PsSpiritualityIssuesNeedsList]
      ,[SuicideNotPresent]
      ,[SuicideIdeation]
      ,[SuicideActive]
      ,[SuicidePassive]
      ,[SuicideMeans]
      ,[SuicidePlan]
      ,[SuicideCurrent]
      ,[SuicidePriorAttempt]
      ,[SuicideNeedsList]
      ,[SuicideBehaviorsPastHistory]
      ,[SuicideOtherRiskSelf]
      ,[SuicideOtherRiskSelfComment]
      ,[HomicideNotPresent]
      ,[HomicideIdeation]
      ,[HomicideActive]
      ,[HomicidePassive]
      ,[HomicideMeans]
      ,[HomicidePlan]
      ,[HomicideCurrent]
      ,[HomicidePriorAttempt]
      ,[HomicideNeedsList]
      ,[HomicideBehaviorsPastHistory]
      ,[HomicdeOtherRiskOthers]
      ,[HomicideOtherRiskOthersComment]
      ,[PhysicalAgressionNotPresent]
      ,[PhysicalAgressionSelf]
      ,[PhysicalAgressionOthers]
      ,[PhysicalAgressionCurrentIssue]
      ,[PhysicalAgressionNeedsList]
      ,[PhysicalAgressionBehaviorsPastHistory]
      ,[RiskAccessToWeapons]
      ,[RiskAppropriateForAdditionalScreening]
      ,[RiskClinicalIntervention]
      ,[RiskOtherFactorsNone]
      ,[RiskOtherFactors]
      ,[RiskOtherFactorsNeedsList]
      ,[StaffAxisV]
      ,[StaffAxisVReason]
      ,[ClientStrengthsNarrative]
      ,[CrisisPlanningClientHasPlan]
      ,[CrisisPlanningNarrative]
      ,[CrisisPlanningDesired]
      ,[CrisisPlanningNeedsList]
      ,[CrisisPlanningMoreInfo]
      ,[AdvanceDirectiveClientHasDirective]
      ,[AdvanceDirectiveDesired]
      ,[AdvanceDirectiveNarrative]
      ,[AdvanceDirectiveNeedsList]
      ,[AdvanceDirectiveMoreInfo]
      ,[NaturalSupportSufficiency]
      ,[NaturalSupportNeedsList]
      ,[NaturalSupportIncreaseDesired]
      ,[ClinicalSummary]
      ,[UncopeQuestionU]
      ,[UncopeApplicable]
      ,[UncopeApplicableReason]
      ,[UncopeQuestionN]
      ,[UncopeQuestionC]
      ,[UncopeQuestionO]
      ,[UncopeQuestionP]
      ,[UncopeQuestionE]
      ,[UncopeCompleteFullSUAssessment]
      ,[SubstanceUseNeedsList]
      ,[DecreaseSymptomsNeedsList]
      ,[DDEPreviouslyMet]
      ,[DDAttributableMentalPhysicalLimitation]
      ,[DDDxAxisI]
      ,[DDDxAxisII]
      ,[DDDxAxisIII]
      ,[DDDxAxisIV]
      ,[DDDxAxisV]
      ,[DDDxSource]
      ,[DDManifestBeforeAge22]
      ,[DDContinueIndefinitely]
      ,[DDLimitSelfCare]
      ,[DDLimitLanguage]
      ,[DDLimitLearning]
      ,[DDLimitMobility]
      ,[DDLimitSelfDirection]
      ,[DDLimitEconomic]
      ,[DDLimitIndependentLiving]
      ,[DDNeedMulitpleSupports]
      ,[CAFASDate]
      ,[RaterClinician]
      ,[CAFASInterval]
      ,[SchoolPerformance]
      ,[SchoolPerformanceComment]
      ,[HomePerformance]
      ,[HomePerfomanceComment]
      ,[CommunityPerformance]
      ,[CommunityPerformanceComment]
      ,[BehaviorTowardsOther]
      ,[BehaviorTowardsOtherComment]
      ,[MoodsEmotion]
      ,[MoodsEmotionComment]
      ,[SelfHarmfulBehavior]
      ,[SelfHarmfulBehaviorComment]
      ,[SubstanceUse]
      ,[SubstanceUseComment]
      ,[Thinkng]
      ,[ThinkngComment]
      ,[YouthTotalScore]
      ,[PrimaryFamilyMaterialNeeds]
      ,[PrimaryFamilyMaterialNeedsComment]
      ,[PrimaryFamilySocialSupport]
      ,[PrimaryFamilySocialSupportComment]
      ,[NonCustodialMaterialNeeds]
      ,[NonCustodialMaterialNeedsComment]
      ,[NonCustodialSocialSupport]
      ,[NonCustodialSocialSupportComment]
      ,[SurrogateMaterialNeeds]
      ,[SurrogateMaterialNeedsComment]
      ,[SurrogateSocialSupport]
      ,[SurrogateSocialSupportComment]
      ,[DischargeCriteria]
      ,[PrePlanFiscalIntermediaryComment]
      ,[StageOfChange]
      ,[PsEducation]
      ,[PsEducationNeedsList]
      ,[PsMedications]
      ,[PsMedicationsNeedsList]
      ,[PsMedicationsListToBeModified]
      ,[PhysicalConditionQuadriplegic]
      ,[PhysicalConditionMultipleSclerosis]
      ,[PhysicalConditionBlindness]
      ,[PhysicalConditionDeafness]
      ,[PhysicalConditionParaplegic]
      ,[PhysicalConditionCerebral]
      ,[PhysicalConditionMuteness]
      ,[PhysicalConditionOtherHearingImpairment]
      ,[TestingReportsReviewed]
      ,[LOCId]
      ,[SevereProfoundDisability]
      ,[SevereProfoundDisabilityComment]
      ,[EmploymentStatus]
      ,[DxTabDisabled]     
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy])
	 SELECT
	  [DocumentVersionId]
      ,[ClientName]
      ,[AssessmentType]
      ,[CurrentAssessmentDate]
      ,[PreviousAssessmentDate]
      ,[ClientDOB]
      ,[AdultOrChild]
      ,[ChildHasNoParentalConsent]
      ,[ClientHasGuardian]
      ,[GuardianName]
      ,[GuardianAddress]
      ,[GuardianPhone]
      ,[GuardianType]
      ,[ClientInDDPopulation]
      ,[ClientInSAPopulation]
      ,[ClientInMHPopulation]
      ,[PreviousDiagnosisText]
      ,[ReferralType]
      ,[PresentingProblem]
      ,[CurrentLivingArrangement]
      ,[CurrentPrimaryCarePhysician]
      ,[ReasonForUpdate]
      ,[DesiredOutcomes]
      ,[PsMedicationsComment]
      ,[PsEducationComment]
      ,[IncludeFunctionalAssessment]
      ,[IncludeSymptomChecklist]
      ,[IncludeUNCOPE]
      ,[ClientIsAppropriateForTreatment]
      ,[SecondOpinionNoticeProvided]
      ,[TreatmentNarrative]
      ,[RapCiDomainIntensity]
      ,[RapCiDomainComment]
      ,[RapCiDomainNeedsList]
      ,[RapCbDomainIntensity]
      ,[RapCbDomainComment]
      ,[RapCbDomainNeedsList]
      ,[RapCaDomainIntensity]
      ,[RapCaDomainComment]
      ,[RapCaDomainNeedsList]
      ,[RapHhcDomainIntensity]
      ,[OutsideReferralsGiven]
      ,[ReferralsNarrative]
      ,[ServiceOther]
      ,[ServiceOtherDescription]
      ,[AssessmentAddtionalInformation]
      ,[TreatmentAccomodation]
      ,[Participants]
      ,[Facilitator]
      ,[TimeLocation]
      ,[AssessmentsNeeded]
      ,[CommunicationAccomodations]
      ,[IssuesToAvoid]
      ,[IssuesToDiscuss]
      ,[SourceOfPrePlanningInfo]
      ,[SelfDeterminationDesired]
      ,[FiscalIntermediaryDesired]
      ,[PamphletGiven]
      ,[PamphletDiscussed]
      ,[PrePlanIndependentFacilitatorDiscussed]
      ,[PrePlanIndependentFacilitatorDesired]
      ,[PrePlanGuardianContacted]
      ,[PrePlanSeparateDocument]
      ,[CommunityActivitiesCurrentDesired]
      ,[CommunityActivitiesIncreaseDesired]
      ,[CommunityActivitiesNeedsList]
      ,[PsCurrentHealthIssues]
      ,[PsCurrentHealthIssuesComment]
      ,[PsCurrentHealthIssuesNeedsList]
      ,[HistMentalHealthTx]
      ,[HistMentalHealthTxNeedsList]
      ,[HistMentalHealthTxComment]
      ,[HistFamilyMentalHealthTx]
      ,[HistFamilyMentalHealthTxNeedsList]
      ,[HistFamilyMentalHealthTxComment]
      ,[PsClientAbuseIssues]
      ,[PsClientAbuesIssuesComment]
      ,[PsClientAbuseIssuesNeedsList]
      ,[PsFamilyConcernsComment]
      ,[PsRiskLossOfPlacement]
      ,[PsRiskLossOfPlacementDueTo]
      ,[PsRiskSensoryMotorFunction]
      ,[PsRiskSensoryMotorFunctionDueTo]
      ,[PsRiskSafety]
      ,[PsRiskSafetyDueTo]
      ,[PsRiskLossOfSupport]
      ,[PsRiskLossOfSupportDueTo]
      ,[PsRiskExpulsionFromSchool]
      ,[PsRiskExpulsionFromSchoolDueTo]
      ,[PsRiskHospitalization]
      ,[PsRiskHospitalizationDueTo]
      ,[PsRiskCriminalJusticeSystem]
      ,[PsRiskCriminalJusticeSystemDueTo]
      ,[PsRiskElopementFromHome]
      ,[PsRiskElopementFromHomeDueTo]
      ,[PsRiskLossOfFinancialStatus]
      ,[PsRiskLossOfFinancialStatusDueTo]
      ,[PsDevelopmentalMilestones]
      ,[PsDevelopmentalMilestonesComment]
      ,[PsDevelopmentalMilestonesNeedsList]
      ,[PsChildEnvironmentalFactors]
      ,[PsChildEnvironmentalFactorsComment]
      ,[PsChildEnvironmentalFactorsNeedsList]
      ,[PsLanguageFunctioning]
      ,[PsLanguageFunctioningComment]
      ,[PsLanguageFunctioningNeedsList]
      ,[PsVisualFunctioning]
      ,[PsVisualFunctioningComment]
      ,[PsVisualFunctioningNeedsList]
      ,[PsPrenatalExposure]
      ,[PsPrenatalExposureComment]
      ,[PsPrenatalExposureNeedsList]
      ,[PsChildMentalHealthHistory]
      ,[PsChildMentalHealthHistoryComment]
      ,[PsChildMentalHealthHistoryNeedsList]
      ,[PsIntellectualFunctioning]
      ,[PsIntellectualFunctioningComment]
      ,[PsIntellectualFunctioningNeedsList]
      ,[PsLearningAbility]
      ,[PsLearningAbilityComment]
      ,[PsLearningAbilityNeedsList]
      ,[PsFunctioningConcernComment]
      ,[PsPeerInteraction]
      ,[PsPeerInteractionComment]
      ,[PsPeerInteractionNeedsList]
      ,[PsParentalParticipation]
      ,[PsParentalParticipationComment]
      ,[PsParentalParticipationNeedsList]
      ,[PsSchoolHistory]
      ,[PsSchoolHistoryComment]
      ,[PsSchoolHistoryNeedsList]
      ,[PsImmunizations]
      ,[PsImmunizationsComment]
      ,[PsImmunizationsNeedsList]
      ,[PsChildHousingIssues]
      ,[PsChildHousingIssuesComment]
      ,[PsChildHousingIssuesNeedsList]
      ,[PsSexuality]
      ,[PsSexualityComment]
      ,[PsSexualityNeedsList]
      ,[PsFamilyFunctioning]
      ,[PsFamilyFunctioningComment]
      ,[PsFamilyFunctioningNeedsList]
      ,[PsTraumaticIncident]
      ,[PsTraumaticIncidentComment]
      ,[PsTraumaticIncidentNeedsList]
      ,[HistDevelopmental]
      ,[HistDevelopmentalComment]
      ,[HistResidential]
      ,[HistResidentialComment]
      ,[HistOccupational]
      ,[HistOccupationalComment]
      ,[HistLegalFinancial]
      ,[HistLegalFinancialComment]
      ,[SignificantEventsPastYear]
      ,[PsGrossFineMotor]
      ,[PsGrossFineMotorComment]
      ,[PsGrossFineMotorNeedsList]
      ,[PsSensoryPerceptual]
      ,[PsSensoryPerceptualComment]
      ,[PsSensoryPerceptualNeedsList]
      ,[PsCognitiveFunction]
      ,[PsCognitiveFunctionComment]
      ,[PsCognitiveFunctionNeedsList]
      ,[PsCommunicativeFunction]
      ,[PsCommunicativeFunctionComment]
      ,[PsCommunicativeFunctionNeedsList]
      ,[PsCurrentPsychoSocialFunctiion]
      ,[PsCurrentPsychoSocialFunctiionComment]
      ,[PsCurrentPsychoSocialFunctiionNeedsList]
      ,[PsAdaptiveEquipment]
      ,[PsAdaptiveEquipmentComment]
      ,[PsAdaptiveEquipmentNeedsList]
      ,[PsSafetyMobilityHome]
      ,[PsSafetyMobilityHomeComment]
      ,[PsSafetyMobilityHomeNeedsList]
      ,[PsHealthSafetyChecklistComplete]
      ,[PsAccessibilityIssues]
      ,[PsAccessibilityIssuesComment]
      ,[PsAccessibilityIssuesNeedsList]
      ,[PsEvacuationTraining]
      ,[PsEvacuationTrainingComment]
      ,[PsEvacuationTrainingNeedsList]
      ,[Ps24HourSetting]
      ,[Ps24HourSettingComment]
      ,[Ps24HourSettingNeedsList]
      ,[Ps24HourNeedsAwakeSupervision]
      ,[PsSpecialEdEligibility]
      ,[PsSpecialEdEligibilityComment]
      ,[PsSpecialEdEligibilityNeedsList]
      ,[PsSpecialEdEnrolled]
      ,[PsSpecialEdEnrolledComment]
      ,[PsSpecialEdEnrolledNeedsList]
      ,[PsEmployer]
      ,[PsEmployerComment]
      ,[PsEmployerNeedsList]
      ,[PsEmploymentIssues]
      ,[PsEmploymentIssuesComment]
      ,[PsEmploymentIssuesNeedsList]
      ,[PsRestrictionsOccupational]
      ,[PsRestrictionsOccupationalComment]
      ,[PsRestrictionsOccupationalNeedsList]
      ,[PsFunctionalAssessmentNeeded]
      ,[PsAdvocacyNeeded]
      ,[PsPlanDevelopmentNeeded]
      ,[PsLinkingNeeded]
      ,[PsDDInformationProvidedBy]
      ,[HistPreviousDx]
      ,[HistPreviousDxComment]
      ,[PsLegalIssues]
      ,[PsLegalIssuesComment]
      ,[PsLegalIssuesNeedsList]
      ,[PsCulturalEthnicIssues]
      ,[PsCulturalEthnicIssuesComment]
      ,[PsCulturalEthnicIssuesNeedsList]
      ,[PsSpiritualityIssues]
      ,[PsSpiritualityIssuesComment]
      ,[PsSpiritualityIssuesNeedsList]
      ,[SuicideNotPresent]
      ,[SuicideIdeation]
      ,[SuicideActive]
      ,[SuicidePassive]
      ,[SuicideMeans]
      ,[SuicidePlan]
      ,[SuicideCurrent]
      ,[SuicidePriorAttempt]
      ,[SuicideNeedsList]
      ,[SuicideBehaviorsPastHistory]
      ,[SuicideOtherRiskSelf]
      ,[SuicideOtherRiskSelfComment]
      ,[HomicideNotPresent]
      ,[HomicideIdeation]
      ,[HomicideActive]
      ,[HomicidePassive]
      ,[HomicideMeans]
      ,[HomicidePlan]
      ,[HomicideCurrent]
      ,[HomicidePriorAttempt]
      ,[HomicideNeedsList]
      ,[HomicideBehaviorsPastHistory]
      ,[HomicdeOtherRiskOthers]
      ,[HomicideOtherRiskOthersComment]
      ,[PhysicalAgressionNotPresent]
      ,[PhysicalAgressionSelf]
      ,[PhysicalAgressionOthers]
      ,[PhysicalAgressionCurrentIssue]
      ,[PhysicalAgressionNeedsList]
      ,[PhysicalAgressionBehaviorsPastHistory]
      ,[RiskAccessToWeapons]
      ,[RiskAppropriateForAdditionalScreening]
      ,[RiskClinicalIntervention]
      ,[RiskOtherFactorsNone]
      ,[RiskOtherFactors]
      ,[RiskOtherFactorsNeedsList]
      ,[StaffAxisV]
      ,[StaffAxisVReason]
      ,[ClientStrengthsNarrative]
      ,[CrisisPlanningClientHasPlan]
      ,[CrisisPlanningNarrative]
      ,[CrisisPlanningDesired]
      ,[CrisisPlanningNeedsList]
      ,[CrisisPlanningMoreInfo]
      ,[AdvanceDirectiveClientHasDirective]
      ,[AdvanceDirectiveDesired]
      ,[AdvanceDirectiveNarrative]
      ,[AdvanceDirectiveNeedsList]
      ,[AdvanceDirectiveMoreInfo]
      ,[NaturalSupportSufficiency]
      ,[NaturalSupportNeedsList]
      ,[NaturalSupportIncreaseDesired]
      ,[ClinicalSummary]
      ,[UncopeQuestionU]
      ,[UncopeApplicable]
      ,[UncopeApplicableReason]
      ,[UncopeQuestionN]
      ,[UncopeQuestionC]
      ,[UncopeQuestionO]
      ,[UncopeQuestionP]
      ,[UncopeQuestionE]
      ,[UncopeCompleteFullSUAssessment]
      ,[SubstanceUseNeedsList]
      ,[DecreaseSymptomsNeedsList]
      ,[DDEPreviouslyMet]
      ,[DDAttributableMentalPhysicalLimitation]
      ,[DDDxAxisI]
      ,[DDDxAxisII]
      ,[DDDxAxisIII]
      ,[DDDxAxisIV]
      ,[DDDxAxisV]
      ,[DDDxSource]
      ,[DDManifestBeforeAge22]
      ,[DDContinueIndefinitely]
      ,[DDLimitSelfCare]
      ,[DDLimitLanguage]
      ,[DDLimitLearning]
      ,[DDLimitMobility]
      ,[DDLimitSelfDirection]
      ,[DDLimitEconomic]
      ,[DDLimitIndependentLiving]
      ,[DDNeedMulitpleSupports]
      ,[CAFASDate]
      ,[RaterClinician]
      ,[CAFASInterval]
      ,[SchoolPerformance]
      ,[SchoolPerformanceComment]
      ,[HomePerformance]
      ,[HomePerfomanceComment]
      ,[CommunityPerformance]
      ,[CommunityPerformanceComment]
      ,[BehaviorTowardsOther]
      ,[BehaviorTowardsOtherComment]
      ,[MoodsEmotion]
      ,[MoodsEmotionComment]
      ,[SelfHarmfulBehavior]
      ,[SelfHarmfulBehaviorComment]
      ,[SubstanceUse]
      ,[SubstanceUseComment]
      ,[Thinkng]
      ,[ThinkngComment]
      ,[YouthTotalScore]
      ,[PrimaryFamilyMaterialNeeds]
      ,[PrimaryFamilyMaterialNeedsComment]
      ,[PrimaryFamilySocialSupport]
      ,[PrimaryFamilySocialSupportComment]
      ,[NonCustodialMaterialNeeds]
      ,[NonCustodialMaterialNeedsComment]
      ,[NonCustodialSocialSupport]
      ,[NonCustodialSocialSupportComment]
      ,[SurrogateMaterialNeeds]
      ,[SurrogateMaterialNeedsComment]
      ,[SurrogateSocialSupport]
      ,[SurrogateSocialSupportComment]
      ,[DischargeCriteria]
      ,[PrePlanFiscalIntermediaryComment]
      ,[StageOfChange]
      ,[PsEducation]
      ,[PsEducationNeedsList]
      ,[PsMedications]
      ,[PsMedicationsNeedsList]
      ,[PsMedicationsListToBeModified]
      ,[PhysicalConditionQuadriplegic]
      ,[PhysicalConditionMultipleSclerosis]
      ,[PhysicalConditionBlindness]
      ,[PhysicalConditionDeafness]
      ,[PhysicalConditionParaplegic]
      ,[PhysicalConditionCerebral]
      ,[PhysicalConditionMuteness]
      ,[PhysicalConditionOtherHearingImpairment]
      ,[TestingReportsReviewed]
      ,[LOCId]
      ,[SevereProfoundDisability]
      ,[SevereProfoundDisabilityComment]
      ,[EmploymentStatus]
      ,[DxTabDisabled]    
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
      FROM [CustomHRMAssessments_Temp111]
END
-------END STEP 5-------------

IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	Begin
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_MoveForeignKeyConstraints]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [dbo].[ssp_MoveForeignKeyConstraints]
	End

IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	Begin
	Exec('create proc [dbo].[ssp_MoveForeignKeyConstraints]  
		@FromTable varchar(128), @ToTable varchar(128)  
		as  
  
		create table #temp1  
		(PKTable varchar(128) null,  
		FKTable varchar(128) null,  
		ConstraintName varchar(128) null,  
		Status int null,  
		cKeyCol1 varchar(128) null,  
		cKeyCol2 varchar(128) null,  
		cKeyCol3 varchar(128) null,  
		cKeyCol4 varchar(128) null,  
		cKeyCol5 varchar(128) null,  
		cKeyCol6 varchar(128) null,  
		cKeyCol7 varchar(128) null,  
		cKeyCol8 varchar(128) null,  
		cKeyCol9 varchar(128) null,  
		cKeyCol10 varchar(128) null,  
		cKeyCol11 varchar(128) null,  
		cKeyCol12 varchar(128) null,  
		cKeyCol13 varchar(128) null,  
		cKeyCol14 varchar(128) null,  
		cKeyCol15 varchar(128) null,  
		cKeyCol16 varchar(128) null,  
		cRefCol1 varchar(128) null,  
		cRefCol2 varchar(128) null,  
		cRefCol3 varchar(128) null,  
		cRefCol4 varchar(128) null,  
		cRefCol5 varchar(128) null,  
		cRefCol6 varchar(128) null,  
		cRefCol7 varchar(128) null,  
		cRefCol8 varchar(128) null,  
		cRefCol9 varchar(128) null,  
		cRefCol10 varchar(128) null,  
		cRefCol11 varchar(128) null,  
		cRefCol12 varchar(128) null,  
		cRefCol13 varchar(128) null,  
		cRefCol14 varchar(128) null,  
		cRefCol15 varchar(128) null,  
		cRefCol16 varchar(128) null,  
		PKTableOwner varchar(50) null,  
		FKTableOwner varchar(50) null,  
		DeleteCascade int null,  
		UpdateCascade int null,  
		)  
  
		declare @CreateSQLString varchar(8000)  
		declare @DropSQLString varchar(8000)  
  
		declare @PKTable varchar(128),  
		@FKTable varchar(128),  
		@ConstraintName varchar(128),  
		@Status int,  
		@cKeyCol1 varchar(128),  
		@cKeyCol2 varchar(128),  
		@cKeyCol3 varchar(128),  
		@cKeyCol4 varchar(128),  
		@cKeyCol5 varchar(128),  
		@cKeyCol6 varchar(128),  
		@cKeyCol7 varchar(128),  
		@cKeyCol8 varchar(128),  
		@cKeyCol9 varchar(128),  
		@cKeyCol10 varchar(128),  
		@cKeyCol11 varchar(128),  
		@cKeyCol12 varchar(128),  
		@cKeyCol13 varchar(128),  
		@cKeyCol14 varchar(128),  
		@cKeyCol15 varchar(128),  
		@cKeyCol16 varchar(128),  
		@cRefCol1 varchar(128),  
		@cRefCol2 varchar(128),  
		@cRefCol3 varchar(128),  
		@cRefCol4 varchar(128),  
		@cRefCol5 varchar(128),  
		@cRefCol6 varchar(128),  
		@cRefCol7 varchar(128),  
		@cRefCol8 varchar(128),  
		@cRefCol9 varchar(128),  
		@cRefCol10 varchar(128),  
		@cRefCol11 varchar(128),  
		@cRefCol12 varchar(128),  
		@cRefCol13 varchar(128),  
		@cRefCol14 varchar(128),  
		@cRefCol15 varchar(128),  
		@cRefCol16 varchar(128),  
		@PKTableOwner varchar(50),  
		@FKTableOwner varchar(50),  
		@DeleteCascade int,  
		@UpdateCascade int  
  
		insert into #temp1  
		exec sp_MStablerefs @FromTable, N''actualtables'', N''both'', null   
  
		declare cur_ForeignKeys cursor for  
		select PKTable,  
		FKTable,  
		ConstraintName,  
		Status,  
		cKeyCol1,  
		cKeyCol2,  
		cKeyCol3,  
		cKeyCol4,  
		cKeyCol5,  
		cKeyCol6,  
		cKeyCol7,  
		cKeyCol8,  
		cKeyCol9,  
		cKeyCol10,  
		cKeyCol11,  
		cKeyCol12,  
		cKeyCol13,  
		cKeyCol14,  
		cKeyCol15,  
		cKeyCol16,  
		cRefCol1,  
		cRefCol2,  
		cRefCol3,  
		cRefCol4,  
		cRefCol5,  
		cRefCol6,  
		cRefCol7,  
		cRefCol8,  
		cRefCol9,  
		cRefCol10,  
		cRefCol11,  
		cRefCol12,  
		cRefCol13,  
		cRefCol14,  
		cRefCol15,  
		cRefCol16,  
		PKTableOwner,  
		FKTableOwner,  
		DeleteCascade,  
		UpdateCascade  
		from #temp1  
		  
		if @@error <> 0 return  
		  
		open cur_ForeignKeys  
		  
		if @@error <> 0 return  
		  
		fetch cur_ForeignKeys into  
		@PKTable,  
		@FKTable,  
		@ConstraintName,  
		@Status,  
		@cKeyCol1,  
		@cKeyCol2,  
		@cKeyCol3,  
		@cKeyCol4,  
		@cKeyCol5,  
		@cKeyCol6,  
		@cKeyCol7,  
		@cKeyCol8,  
		@cKeyCol9,  
		@cKeyCol10,  
		@cKeyCol11,  
		@cKeyCol12,  
		@cKeyCol13,  
		@cKeyCol14,  
		@cKeyCol15,  
		@cKeyCol16,  
		@cRefCol1,  
		@cRefCol2,  
		@cRefCol3,  
		@cRefCol4,  
		@cRefCol5,  
		@cRefCol6,  
		@cRefCol7,  
		@cRefCol8,  
		@cRefCol9,  
		@cRefCol10,  
		@cRefCol11,  
		@cRefCol12,  
		@cRefCol13,  
		@cRefCol14,  
		@cRefCol15,  
		@cRefCol16,  
		@PKTableOwner,  
		@FKTableOwner,  
		@DeleteCascade,  
		@UpdateCascade  
		  
		if @@error <> 0 return  
		  
		while @@Fetch_Status = 0  
		begin  
		  
		set @DropSQLString = ''ALTER Table '' + @FKTable + '' DROP CONSTRAINT '' + @ConstraintName  
		  
		if @FKTable = @FromTable set @FKTable = @ToTable  
		else set @PKTable = @ToTable  
		  
		if @@error <> 0 return  
		  
		set @CreateSQLString = ''ALTER Table '' + @FKTable + '' ADD CONSTRAINT '' + @ConstraintName +  
		'' FOREIGN KEY ('' + @cKeyCol1 +   
		case when @cKeyCol2 is null then rtrim('''') else '', '' + @cKeyCol2 end +   
		case when @cKeyCol3 is null then rtrim('''') else '', '' + @cKeyCol3 end +   
		case when @cKeyCol4 is null then rtrim('''') else '', '' + @cKeyCol4 end +   
		case when @cKeyCol5 is null then rtrim('''') else '', '' + @cKeyCol5 end +  
		case when @cKeyCol6 is null then rtrim('''') else '', '' + @cKeyCol6 end +  
		case when @cKeyCol7 is null then rtrim('''') else '', '' + @cKeyCol7 end +  
		case when @cKeyCol8 is null then rtrim('''') else '', '' + @cKeyCol8 end +  
		case when @cKeyCol9 is null then rtrim('''') else '', '' + @cKeyCol9 end +  
		case when @cKeyCol10 is null then rtrim('''') else '', '' + @cKeyCol10 end +  
		'') REFERENCES '' + replace(@PKTable, ''_temp111'', '''') + ''('' + @cRefCol1 +  
		case when @cRefCol2 is null then rtrim('''') else '', '' + @cRefCol2 end +   
		case when @cRefCol3 is null then rtrim('''') else '', '' + @cRefCol3 end +   
		case when @cRefCol4 is null then rtrim('''') else '', '' + @cRefCol4 end +   
		case when @cRefCol5 is null then rtrim('''') else '', '' + @cRefCol5 end +   
		case when @cRefCol6 is null then rtrim('''') else '', '' + @cRefCol6 end +   
		case when @cRefCol7 is null then rtrim('''') else '', '' + @cRefCol7 end +   
		case when @cRefCol8 is null then rtrim('''') else '', '' + @cRefCol8 end +   
		case when @cRefCol9 is null then rtrim('''') else '', '' + @cRefCol9 end +   
		case when @cRefCol10 is null then rtrim('''') else '', '' + @cRefCol10 end +   
		'')'' + case  when @DeleteCascade = 1 then '' ON DELETE CASCADE'' else rtrim('''') end  
		+ case  when @UpdateCascade = 1 then '' ON UPDATE CASCADE'' else rtrim('''') end  
		  
		   
		if @@error <> 0 return  
		  
		print @DropSQLString  
		execute(@DropSQLString)  
		  
		if @@error <> 0 return  
		  
		print @CreateSQLString  
		execute(@CreateSQLString)  
		  
		  
		if @@error <> 0 return  
		  
		fetch cur_ForeignKeys into  
		@PKTable,  
		@FKTable,  
		@ConstraintName,  
		@Status,  
		@cKeyCol1,  
		@cKeyCol2,  
		@cKeyCol3,  
		@cKeyCol4,  
		@cKeyCol5,  
		@cKeyCol6,  
		@cKeyCol7,  
		@cKeyCol8,  
		@cKeyCol9,  
		@cKeyCol10,  
		@cKeyCol11,  
		@cKeyCol12,  
		@cKeyCol13,  
		@cKeyCol14,  
		@cKeyCol15,  
		@cKeyCol16,  
		@cRefCol1,  
		@cRefCol2,  
		@cRefCol3,  
		@cRefCol4,  
		@cRefCol5,  
		@cRefCol6,  
		@cRefCol7,  
		@cRefCol8,  
		@cRefCol9,  
		@cRefCol10,  
		@cRefCol11,  
		@cRefCol12,  
		@cRefCol13,  
		@cRefCol14,  
		@cRefCol15,  
		@cRefCol16,  
		@PKTableOwner,  
		@FKTableOwner,  
		@DeleteCascade,  
		@UpdateCascade  
		  
		if @@error <> 0 return  
		  
		end  
		  
		close cur_ForeignKeys  
		  
		if @@error <> 0 return  
		  
		deallocate cur_ForeignKeys  
		  
		if @@error <> 0 return ') 
	End


------ STEP 6  ----------

IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	Begin
		exec ssp_MoveForeignKeyConstraints  'CustomHRMAssessments_Temp111','CustomHRMAssessments'
		PRINT 'STEP 6 COMPLETED'
	end
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	BEGIN
		DROP TABLE CustomHRMAssessments_Temp111
	END
				

IF OBJECT_ID('tempdb..#ColumnExists') IS NOT NULL
 DROP TABLE #ColumnExists
------ END OF STEP 3 -----

------ STEP 4 ----------

 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentAssessmentSubstanceUses')
BEGIN
/* 
 * TABLE: CustomDocumentAssessmentSubstanceUses 
 */
 CREATE TABLE CustomDocumentAssessmentSubstanceUses( 
		DocumentVersionId						int					 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,		
		UseOfAlcohol							Char(1)				 NULL
												CHECK (UseOfAlcohol in ('N','R','M','D')),	
		AlcoholAddToNeedsList					type_YOrN			 NULL
												CHECK (AlcoholAddToNeedsList in ('Y','N')),
		UseOfTobaccoNicotine					Char(1)				 NULL
												CHECK (UseOfTobaccoNicotine in ('N','P','T')),		  
		UseOfTobaccoNicotineQuit				Datetime			 NULL,
		UseOfTobaccoNicotineTypeOfFrequency		Varchar(100)		 NULL,
		UseOfTobaccoNicotineAddToNeedsList		type_YOrN			 NULL
												CHECK (UseOfTobaccoNicotineAddToNeedsList in ('Y','N')),
		UseOfIllicitDrugs						type_YOrN			 NULL
												CHECK (UseOfIllicitDrugs in ('Y','N')),
		UseOfIllicitDrugsTypeFrequency			Varchar(100)		 NULL,
		UseOfIllicitDrugsAddToNeedsList			type_YOrN			 NULL
												CHECK (UseOfIllicitDrugsAddToNeedsList in ('Y','N')),
		PrescriptionOTCDrugs					type_YOrN			 NULL
												CHECK (PrescriptionOTCDrugs in ('Y','N')),
		PrescriptionOTCDrugsTypeFrequency		Varchar(100)		 NULL,
		PrescriptionOTCDrugsAddtoNeedsList		type_YOrN			 NULL
												CHECK (PrescriptionOTCDrugsAddtoNeedsList in ('Y','N')),
	CONSTRAINT CustomDocumentAssessmentSubstanceUses_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('CustomDocumentAssessmentSubstanceUses') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentAssessmentSubstanceUses >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentAssessmentSubstanceUses >>>', 16, 1)
/* 
 * TABLE: CustomDocumentAssessmentSubstanceUses 
 */   
 
ALTER TABLE CustomDocumentAssessmentSubstanceUses ADD CONSTRAINT DocumentVersions_CustomDocumentAssessmentSubstanceUses_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
        
     PRINT 'STEP 4(A) COMPLETED'
 END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomHRMAssessmentMedications')
BEGIN
/* 
 * TABLE: CustomHRMAssessmentMedications
 
 */
CREATE TABLE CustomHRMAssessmentMedications(
	HRMAssessmentMedicationId				int identity(1,1)		NOT NULL,
	CreatedBy								type_CurrentUser		NOT NULL,
	CreatedDate								type_CurrentDatetime	NOT NULL,
	ModifiedBy								type_CurrentUser		NOT NULL,
	ModifiedDate							type_CurrentDatetime	NOT NULL,
	RecordDeleted							type_YOrN				NULL
											CHECK (RecordDeleted in ('Y','N')),
	DeletedBy								type_UserId				NULL,
	DeletedDate								datetime				NULL,
	DocumentVersionId						int						NULL,
	Name									Varchar(250)			NULL,
	Dosage									Varchar(250)			NULL,
	Purpose									Varchar(max)			NULL,
	PrescribingPhysician					Varchar(250)			NULL,
	CONSTRAINT CustomHRMAssessmentMedications_PK PRIMARY KEY CLUSTERED (HRMAssessmentMedicationId)
)

IF OBJECT_ID('CustomHRMAssessmentMedications') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomHRMAssessmentMedications >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomHRMAssessmentMedications >>>', 16, 1)

/* 
 * TABLE: CustomHRMAssessmentMedications 
 */
		
ALTER TABLE CustomHRMAssessmentMedications ADD CONSTRAINT DocumentVersions_CustomHRMAssessmentMedications_FK 
		FOREIGN KEY (DocumentVersionId)
		REFERENCES DocumentVersions(DocumentVersionId)	
					
PRINT 'STEP 4(B) COMPLETED'
END

IF Not EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentSafetyCrisisPlans')
 BEGIN
/* 
 * TABLE: CustomDocumentSafetyCrisisPlans 
 */
CREATE TABLE CustomDocumentSafetyCrisisPlans(
	 DocumentVersionId 							int						  NOT NULL,
	 CreatedBy                                  type_CurrentUser          NOT NULL,
     CreatedDate                                type_CurrentDatetime      NOT NULL,
     ModifiedBy                                 type_CurrentUser          NOT NULL,
     ModifiedDate                               type_CurrentDatetime      NOT NULL,
     RecordDeleted                              type_YOrN                 NULL
												CHECK (RecordDeleted in ('N','Y')),
     DeletedBy                                  type_UserId               NULL,
     DeletedDate                                datetime                  NULL,
     ClientHasCurrentCrisis						type_YOrN				  NULL
												CHECK (ClientHasCurrentCrisis in ('N','Y')),
     WarningSignsCrisis							type_Comment2			  NULL,
     CopingStrategies							type_Comment2			  NULL,
     ThreeMonths								type_YOrN				  NULL
												CHECK (ThreeMonths in ('N','Y')),
	 TwelveMonths								type_YOrN				  NULL
												CHECK (TwelveMonths in ('N','Y')),
	 DateOfCrisis								datetime				  NULL,
	 DOB										datetime				  NULL,
	 ProgramId									int						  NULL,
	 StaffId									int						  NULL,
	 SignificantOther							varchar(100)			  NULL,
	 CurrentCrisisDescription					type_Comment2			  NULL,
	 CurrentCrisisSpecificactions				type_Comment2			  NULL,
	 InitialSafetyPlan							type_YOrN				  NULL
												CHECK (InitialSafetyPlan in ('N','Y')),
	 InitialCrisisPlan							type_YOrN				  NULL
												CHECK (InitialCrisisPlan in ('N','Y')),
	 SafetyPlanNotReviewed						type_YOrN				  NULL
												CHECK (SafetyPlanNotReviewed in ('N','Y')),
	 ReviewCrisisPlanXDays						int						  NULL,
	 NextCrisisPlanReviewDate					datetime				  NULL,
	 CONSTRAINT CustomDocumentSafetyCrisisPlans_PK PRIMARY KEY CLUSTERED (DocumentVersionId)
)

  IF OBJECT_ID('CustomDocumentSafetyCrisisPlans') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentSafetyCrisisPlans >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentSafetyCrisisPlans >>>', 16, 1)
/* 
 * TABLE: CustomDocumentSafetyCrisisPlans 
 */   
    
ALTER TABLE CustomDocumentSafetyCrisisPlans ADD CONSTRAINT DocumentVersions_CustomDocumentSafetyCrisisPlans_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)

ALTER TABLE CustomDocumentSafetyCrisisPlans ADD CONSTRAINT Programs_CustomDocumentSafetyCrisisPlans_FK
    FOREIGN KEY (ProgramId)
    REFERENCES Programs(ProgramId)

ALTER TABLE CustomDocumentSafetyCrisisPlans ADD CONSTRAINT Staff_CustomDocumentSafetyCrisisPlans_FK
    FOREIGN KEY (StaffId)
    REFERENCES Staff(StaffId)
    
     PRINT 'STEP 4(C) COMPLETED'
 END


 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomSupportContacts')
BEGIN
/* 
 * TABLE: CustomSupportContacts 
 */
 CREATE TABLE CustomSupportContacts( 
		SupportContactId						int	 identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		DocumentVersionId						int					 NULL,
		ClientContactId							int					 NULL,
		Name									varchar(200)		 NULL,
		Relationship							varchar(200)		 NULL,
		[Address]								type_Comment2		 NULL,
		Phone									type_PhoneNumber	 NULL,
		CONSTRAINT CustomSupportContacts_PK PRIMARY KEY CLUSTERED (SupportContactId)
)

  IF OBJECT_ID('CustomSupportContacts') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomSupportContacts >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomSupportContacts >>>', 16, 1)
/* 
 * TABLE: CustomSupportContacts 
 */   

ALTER TABLE CustomSupportContacts ADD CONSTRAINT DocumentVersions_CustomSupportContacts_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)  
     
ALTER TABLE CustomSupportContacts ADD CONSTRAINT ClientContacts_CustomSupportContacts_FK
    FOREIGN KEY (ClientContactId)
    REFERENCES ClientContacts(ClientContactId)
    
     PRINT 'STEP 4(D) COMPLETED'
 END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomSafetyCrisisPlanReviews')
BEGIN
/* 
 * TABLE: CustomSafetyCrisisPlanReviews 
 */
 CREATE TABLE CustomSafetyCrisisPlanReviews( 
		SafetyCrisisPlanReviewId				int	identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		DocumentVersionId						int					 NULL,
		SafetyCrisisPlanReviewed				type_YOrN			 NULL
												CHECK (SafetyCrisisPlanReviewed in ('Y','N')),
		DateReviewed							datetime			 NULL,
		ReviewEveryXDays						int					 NULL,
		DescribePlanReview						type_Comment2		 NULL,
		CrisisDisposition						type_Comment2		 NULL,
		CONSTRAINT CustomSafetyCrisisPlanReviews_PK PRIMARY KEY CLUSTERED (SafetyCrisisPlanReviewId)
)

 IF OBJECT_ID('CustomSafetyCrisisPlanReviews') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomSafetyCrisisPlanReviews >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomSafetyCrisisPlanReviews >>>', 16, 1)
/* 
 * TABLE: CustomSafetyCrisisPlanReviews 
 */   

ALTER TABLE CustomSafetyCrisisPlanReviews ADD CONSTRAINT DocumentVersions_CustomSafetyCrisisPlanReviews_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)   
  PRINT 'STEP 4(E) COMPLETED'
 END


IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomCrisisPlanMedicalProviders')
BEGIN
/* 
 * TABLE: CustomCrisisPlanMedicalProviders 
 */
 CREATE TABLE CustomCrisisPlanMedicalProviders( 
		CrisisPlanMedicalProviderId				int	identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		DocumentVersionId                       int					 NULL,
		Name									varchar(50)			 NULL,
		AddressType								type_GlobalCode		 NULL,
		[Address]								varchar(150)		 NULL,
		Phone									type_PhoneNumber	 NULL,
		CONSTRAINT CustomCrisisPlanMedicalProviders_PK PRIMARY KEY CLUSTERED (CrisisPlanMedicalProviderId)
)

IF OBJECT_ID('CustomCrisisPlanMedicalProviders') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomCrisisPlanMedicalProviders >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomCrisisPlanMedicalProviders >>>', 16, 1)
/* 
 * TABLE: CustomCrisisPlanMedicalProviders 
 */   

ALTER TABLE CustomCrisisPlanMedicalProviders ADD CONSTRAINT DocumentVersions_CustomCrisisPlanMedicalProviders_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)   
  PRINT 'STEP 4(F) COMPLETED'
 END


IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomCrisisPlanNetworkProviders')
BEGIN
/* 
 * TABLE: CustomCrisisPlanNetworkProviders 
 */
 CREATE TABLE CustomCrisisPlanNetworkProviders( 
		CrisisPlanNetworkProviderId				int	identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		DocumentVersionId                       int					 NULL,
		Name									varchar(50)			 NULL,
		AddressType								type_GlobalCode		 NULL,
		Address									varchar(150)		 NULL,
		Phone									type_PhoneNumber	 NULL,
		CONSTRAINT CustomCrisisPlanNetworkProviders_PK PRIMARY KEY CLUSTERED (CrisisPlanNetworkProviderId)
)

IF OBJECT_ID('CustomCrisisPlanNetworkProviders') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomCrisisPlanNetworkProviders >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomCrisisPlanNetworkProviders >>>', 16, 1)
/* 
 * TABLE: CustomCrisisPlanNetworkProviders 
 */   

ALTER TABLE CustomCrisisPlanNetworkProviders ADD CONSTRAINT DocumentVersions_CustomCrisisPlanNetworkProviders_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)  
     
  PRINT 'STEP 4(G) COMPLETED'
 END
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomSubstanceUseAssessments')
BEGIN
/* 
 * TABLE: CustomSubstanceUseAssessments 
 */
 CREATE TABLE CustomSubstanceUseAssessments( 
		DocumentVersionId						int						NOT NULL,
		CreatedBy								type_CurrentUser		NOT NULL,
		CreatedDate								type_CurrentDatetime	NOT NULL,
		ModifiedBy								type_CurrentUser		NOT NULL,
		ModifiedDate							type_CurrentDatetime	NOT NULL,
		RecordDeleted							type_YOrN				NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedDate								datetime				NULL,
		DeletedBy								type_UserId				NULL,
		VoluntaryAbstinenceTrial				type_Comment2			NULL,
		Comment									type_Comment2			NULL,
		HistoryOrCurrentDUI						type_YOrN				NULL
												CHECK (HistoryOrCurrentDUI in ('Y','N')),
		NumberOfTimesDUI						int						NULL,
		HistoryOrCurrentDWI						type_YOrN				NULL
												CHECK (HistoryOrCurrentDWI in ('Y','N')),
		NumberOfTimesDWI						int						NULL,
		HistoryOrCurrentMIP						type_YOrN				NULL
												CHECK (HistoryOrCurrentMIP in ('Y','N')),
		NumberOfTimeMIP							int						NULL,
		HistoryOrCurrentBlackOuts				type_YOrN				NULL
												CHECK (HistoryOrCurrentBlackOuts in ('Y','N')),
		NumberOfTimesBlackOut					int						NULL,
		HistoryOrCurrentDomesticAbuse			type_YOrN				NULL
												CHECK (HistoryOrCurrentDomesticAbuse in ('Y','N')),
		NumberOfTimesDomesticAbuse				int						NULL,
		LossOfControl							type_YOrN				NULL
												CHECK (LossOfControl in ('Y','N')),
		IncreasedTolerance						type_YOrN				NULL
												CHECK (IncreasedTolerance in ('Y','N')),
		OtherConsequence						type_YOrN				NULL
												CHECK (OtherConsequence in ('Y','N')),
		OtherConsequenceDescription				varchar(1000)			NULL,
		RiskOfRelapse							type_Comment2			NULL,
		PreviousTreatment						type_YOrN				NULL
												CHECK (PreviousTreatment in ('Y','N')),
		CurrentSubstanceAbuseTreatment			type_YOrN				NULL
												CHECK (CurrentSubstanceAbuseTreatment in ('Y','N')),
		CurrentTreatmentProvider				varchar(max)			NULL,
		CurrentSubstanceAbuseReferralToSAorTx	type_YOrN				NULL
												CHECK (CurrentSubstanceAbuseReferralToSAorTx in ('Y','N')),
		CurrentSubstanceAbuseRefferedReason		type_Comment2			NULL,
		ToxicologyResults						type_Comment2			NULL,
		SubstanceAbuseAdmittedOrSuspected		type_YOrN				NULL
												CHECK (SubstanceAbuseAdmittedOrSuspected in ('Y','N')),
		ClientSAHistory							type_YOrN				NULL
												CHECK (ClientSAHistory in ('Y','N')),
		FamilySAHistory							type_YOrN				NULL
												CHECK (FamilySAHistory in ('Y','N')),
		NoSubstanceAbuseSuspected				type_YOrN				NULL
												CHECK (NoSubstanceAbuseSuspected in ('Y','N')),
		DUI30Days								int						NULL,
		DUI5Years								int						NULL,
		DWI30Days								int						NULL,
		DWI5Years								int						NULL,
		Possession30Days						int						NULL,
		Possession5Years						int						NULL,
		CurrentSubstanceAbuse					type_YOrN				NULL
												CHECK (CurrentSubstanceAbuse in ('Y','N')),
		SuspectedSubstanceAbuse					type_YOrN				NULL
												CHECK (SuspectedSubstanceAbuse in ('Y','N')),
		SubstanceAbuseDetail					type_Comment			NULL,
		SubstanceAbuseTxPlan					type_YOrN				NULL
												CHECK (SubstanceAbuseTxPlan in ('Y','N')),
		OdorOfSubstance							type_YOrN				NULL
												CHECK (OdorOfSubstance in ('Y','N')),
		SlurredSpeech							type_YOrN				NULL
												CHECK (SlurredSpeech in ('Y','N')),
		WithdrawalSymptoms						type_YOrN				NULL
												CHECK (WithdrawalSymptoms in ('Y','N')),
		DTOther									type_YOrN				NULL
												CHECK (DTOther in ('Y','N')),
		DTOtherText								type_Comment			NULL,
		Blackouts								type_YOrN				NULL
												CHECK (Blackouts in ('Y','N')),
		RelatedArrests							type_YOrN				NULL
												CHECK (RelatedArrests in ('Y','N')),
		RelatedSocialProblems					type_YOrN				NULL
												CHECK (RelatedSocialProblems in ('Y','N')),
		FrequentJobSchoolAbsence				type_YOrN				NULL
												CHECK (FrequentJobSchoolAbsence in ('Y','N')),
		NoneSynptomsReportedOrObserved			type_YOrN				NULL
												CHECK (NoneSynptomsReportedOrObserved in ('Y','N')),
		PreviousMedication						type_YOrN				NULL
												CHECK (PreviousMedication in ('Y','N')),
		CurrentSubstanceAbuseMedication			type_YOrN				NULL
												CHECK (CurrentSubstanceAbuseMedication in ('Y','N')),
		MedicationAssistedTreatmentRefferedReason type_Comment2			NULL,
		MedicationAssistedTreatment				Char(1)				    NULL
												CHECK (MedicationAssistedTreatment in ('Y','N','A')),
		CONSTRAINT CustomSubstanceUseAssessments_PK PRIMARY KEY CLUSTERED (DocumentVersionId)
)


IF OBJECT_ID('CustomSubstanceUseAssessments') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomSubstanceUseAssessments >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomSubstanceUseAssessments >>>', 16, 1)
/* 
 * TABLE: CustomSubstanceUseAssessments 
 */   

ALTER TABLE CustomSubstanceUseAssessments ADD CONSTRAINT DocumentVersions_CustomSubstanceUseAssessments_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)  
     
  PRINT 'STEP 4(H) COMPLETED'
 END
 
 
 IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomHRMActivities')
BEGIN
/* 
 * TABLE: CustomHRMActivities 
 */
CREATE TABLE CustomHRMActivities(
    HRMActivityId			 int IDENTITY(1,1)       NOT NULL,    
    CreatedBy                type_CurrentUser        NOT NULL,
    CreatedDate              type_CurrentDatetime    NOT NULL,
    ModifiedBy               type_CurrentUser        NOT NULL,
    ModifiedDate             type_CurrentDatetime    NOT NULL,
    RecordDeleted            type_YOrN               NULL
                             CHECK (RecordDeleted in ('Y','N')),
    DeletedDate              datetime                NULL,
    DeletedBy                type_UserId             NULL,
    AssociatedHRMNeedId		 int					 NULL,
    HRMActivityDescription   varchar(2000)           NOT NULL,
    SortOrder				 int					 NOT NULL,
	Active					 type_Active             NOT NULL,
	Example					 type_Comment2           NULL,
    CONSTRAINT CustomHRMActivities_PK PRIMARY KEY CLUSTERED (HRMActivityId)
)
IF OBJECT_ID('CustomHRMActivities') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomHRMActivities >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomHRMActivities >>>', 16, 1)
/* 
 * TABLE: CustomHRMActivities 
 */

ALTER TABLE CustomHRMActivities ADD CONSTRAINT CustomHRMNeeds_CustomHRMActivities_FK 
FOREIGN KEY (AssociatedHRMNeedId)
REFERENCES CustomHRMNeeds(HRMNeedId) 

PRINT 'STEP 4(I) COMPLETED'  

END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomSubstanceUseHistory2')
 BEGIN
/* 
 * TABLE: CustomSubstanceUseHistory2 
 */
CREATE TABLE CustomSubstanceUseHistory2(
	SubstanceUseHistoryId						int IDENTITY(1,1)			NOT NULL,
	CreatedBy								    type_CurrentUser			NOT NULL,
    CreatedDate                                 type_CurrentDatetime		NOT NULL,
    ModifiedBy                                  type_CurrentUser			NOT NULL,
    ModifiedDate                                type_CurrentDatetime		NOT NULL,
    RecordDeleted                               type_YOrN					NULL
												CHECK (RecordDeleted in ('N','Y')),
    DeletedBy                                   type_UserId					NULL,
    DeletedDate                                 datetime					NULL,
    DocumentVersionId							int							NOT NULL,
	SUDrugId									int							NOT NULL,
	AgeOfFirstUse								int							NULL,
	Frequency									type_GlobalCode				NULL,
	[Route]										type_GlobalCode				NULL,
	LastUsed									varchar(50)					NULL,					
	InitiallyPrescribed							type_YOrN					NULL
												CHECK (InitiallyPrescribed in ('N','Y')),
	Preference									int							NULL,
	FamilyHistory								type_Comment2				NULL,
	CONSTRAINT CustomSubstanceUseHistory2_PK PRIMARY KEY CLUSTERED (SubstanceUseHistoryId)
)

  IF OBJECT_ID('CustomSubstanceUseHistory2') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomSubstanceUseHistory2 >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomSubstanceUseHistory2 >>>', 16, 1)
/* 
 * TABLE: CustomSubstanceUseHistory2 
 */   
 
CREATE NONCLUSTERED INDEX [XIE1_CustomSubstanceUseHistory2] ON [dbo].[CustomSubstanceUseHistory2] 
(	
[DocumentVersionId] ASC	
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomSubstanceUseHistory2') AND name='XIE1_CustomSubstanceUseHistory2')
PRINT '<<< CREATED INDEX CustomSubstanceUseHistory2.XIE1_CustomSubstanceUseHistory2 >>>'
ELSE
RAISERROR('<<< FAILED CREATING INDEX CustomSubstanceUseHistory2.XIE1_CustomSubstanceUseHistory2 >>>', 16, 1) 
    
    
ALTER TABLE CustomSubstanceUseHistory2 ADD CONSTRAINT DocumentVersions_CustomSubstanceUseHistory2_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
ALTER TABLE CustomSubstanceUseHistory2 ADD CONSTRAINT CustomSUDrugs_CustomSubstanceUseHistory2_FK
    FOREIGN KEY (SUDrugId)
    REFERENCES CustomSUDrugs(SUDrugId)

    
PRINT 'STEP 4(J) COMPLETED'
 END
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomHRMAssessmentLevelOfCareOptions')
 BEGIN
/* 
 * TABLE: CustomHRMAssessmentLevelOfCareOptions 
 */
CREATE TABLE CustomHRMAssessmentLevelOfCareOptions(
	HRMAssessmentLevelOfCareOptionId			int IDENTITY(1,1)			NOT NULL,
	CreatedBy								    type_CurrentUser			NOT NULL,
    CreatedDate                                 type_CurrentDatetime		NOT NULL,
    ModifiedBy                                  type_CurrentUser			NOT NULL,
    ModifiedDate                                type_CurrentDatetime		NOT NULL,
    RecordDeleted                               type_YOrN					NULL
												CHECK (RecordDeleted in ('N','Y')),
    DeletedBy                                   type_UserId					NULL,
    DeletedDate                                 datetime					NULL,
    DocumentVersionId							int							NOT NULL,
    HRMLevelOfCareOptionId						int							NOT NULL,
	OptionSelected								type_YOrN					NULL,
												CHECK (OptionSelected in ('N','Y')),
	CONSTRAINT CustomHRMAssessmentLevelOfCareOptions_PK PRIMARY KEY CLUSTERED (HRMAssessmentLevelOfCareOptionId)
)

  IF OBJECT_ID('CustomHRMAssessmentLevelOfCareOptions') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomHRMAssessmentLevelOfCareOptions >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomHRMAssessmentLevelOfCareOptions >>>', 16, 1)
/* 
 * TABLE: CustomHRMAssessmentLevelOfCareOptions 
 */   

CREATE NONCLUSTERED INDEX [XIE1_CustomHRMAssessmentLevelOfCareOptions] ON [dbo].[CustomHRMAssessmentLevelOfCareOptions] 
(	
[DocumentVersionId] ASC	
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomHRMAssessmentLevelOfCareOptions') AND name='XIE1_CustomHRMAssessmentLevelOfCareOptions')
PRINT '<<< CREATED INDEX CustomHRMAssessmentLevelOfCareOptions.XIE1_CustomHRMAssessmentLevelOfCareOptions >>>'
ELSE
RAISERROR('<<< FAILED CREATING INDEX CustomHRMAssessmentLevelOfCareOptions.XIE1_CustomHRMAssessmentLevelOfCareOptions >>>', 16, 1) 
    
ALTER TABLE CustomHRMAssessmentLevelOfCareOptions ADD CONSTRAINT DocumentVersions_CustomHRMAssessmentLevelOfCareOptions_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
ALTER TABLE CustomHRMAssessmentLevelOfCareOptions ADD CONSTRAINT CustomHRMLevelOfCareOptions_CustomHRMAssessmentLevelOfCareOptions_FK
    FOREIGN KEY (HRMLevelOfCareOptionId)
    REFERENCES CustomHRMLevelOfCareOptions(HRMLevelOfCareOptionId)

    
PRINT 'STEP 4(K) COMPLETED'
 END
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomOtherRiskFactors')
 BEGIN
/* 
 * TABLE: CustomOtherRiskFactors 
 */
CREATE TABLE CustomOtherRiskFactors(
	OtherRiskFactorId							int IDENTITY(1,1)			NOT NULL,
	CreatedBy								    type_CurrentUser			NOT NULL,
    CreatedDate                                 type_CurrentDatetime		NOT NULL,
    ModifiedBy                                  type_CurrentUser			NOT NULL,
    ModifiedDate                                type_CurrentDatetime		NOT NULL,
    RecordDeleted                               type_YOrN					NULL
												CHECK (RecordDeleted in ('N','Y')),
    DeletedBy                                   type_UserId					NULL,
    DeletedDate                                 datetime					NULL,
    DocumentVersionId							int							NOT NULL,
    OtherRiskFactor								type_GlobalCode				NULL,
	CONSTRAINT CustomOtherRiskFactors_PK PRIMARY KEY CLUSTERED (OtherRiskFactorId)
)

IF OBJECT_ID('CustomOtherRiskFactors') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomOtherRiskFactors >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomOtherRiskFactors >>>', 16, 1)
/* 
 * TABLE: CustomOtherRiskFactors 
 */   
 
CREATE NONCLUSTERED INDEX [XIE1_CustomOtherRiskFactors] ON [dbo].[CustomOtherRiskFactors] 
(	
[DocumentVersionId] ASC	
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomOtherRiskFactors') AND name='XIE1_CustomOtherRiskFactors')
PRINT '<<< CREATED INDEX CustomOtherRiskFactors.XIE1_CustomOtherRiskFactors >>>'
ELSE
RAISERROR('<<< FAILED CREATING INDEX CustomOtherRiskFactors.XIE1_CustomOtherRiskFactors >>>', 16, 1) 
   
ALTER TABLE CustomOtherRiskFactors ADD CONSTRAINT DocumentVersions_CustomOtherRiskFactors_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
     
PRINT 'STEP 4(L) COMPLETED'
 END
IF Not EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomHRMAssessmentSupports2')
 BEGIN
/* 
 * TABLE: CustomHRMAssessmentSupports2 
 */
CREATE TABLE CustomHRMAssessmentSupports2(
	HRMAssessmentSupportId						int IDENTITY(1,1)			NOT NULL,
	CreatedBy								    type_CurrentUser			NOT NULL,
    CreatedDate                                 type_CurrentDatetime		NOT NULL,
    ModifiedBy                                  type_CurrentUser			NOT NULL,
    ModifiedDate                                type_CurrentDatetime		NOT NULL,
    RecordDeleted                               type_YOrN					NULL
												CHECK (RecordDeleted in ('N','Y')),
    DeletedBy                                   type_UserId					NULL,
    DeletedDate                                 datetime					NULL,
    DocumentVersionId							int							NOT NULL,
    SupportDescription							type_Comment2				NULL,
	[Current]									type_YOrN					NULL
												CHECK ([Current] in ('N','Y')),
	PaidSupport									type_YOrN					NULL
												CHECK (PaidSupport in ('N','Y')),
	UnpaidSupport								type_YOrN					NULL
												CHECK (UnpaidSupport in ('N','Y')),
	ClinicallyRecommended						type_YOrN					NULL
												CHECK (ClinicallyRecommended in ('N','Y')),
	CustomerDesired								type_YOrN					NULL
												CHECK (CustomerDesired in ('N','Y')),
	CONSTRAINT CustomHRMAssessmentSupports2_PK PRIMARY KEY CLUSTERED (HRMAssessmentSupportId)
)

IF OBJECT_ID('CustomHRMAssessmentSupports2') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomHRMAssessmentSupports2 >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomHRMAssessmentSupports2 >>>', 16, 1)
/* 
 * TABLE: CustomHRMAssessmentSupports2 
 */   

CREATE NONCLUSTERED INDEX [XIE1_CustomHRMAssessmentSupports2] ON [dbo].[CustomHRMAssessmentSupports2] 
(	
[DocumentVersionId] ASC	
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomHRMAssessmentSupports2') AND name='XIE1_CustomHRMAssessmentSupports2')
PRINT '<<< CREATED INDEX CustomHRMAssessmentSupports2.XIE1_CustomHRMAssessmentSupports2 >>>'
ELSE
RAISERROR('<<< FAILED CREATING INDEX CustomHRMAssessmentSupports2.XIE1_CustomHRMAssessmentSupports2 >>>', 16, 1) 
   
    
ALTER TABLE CustomHRMAssessmentSupports2 ADD CONSTRAINT DocumentVersions_CustomHRMAssessmentSupports2_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
     
PRINT 'STEP 4(M) COMPLETED'
 END
 
IF Not EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomMentalStatuses2')
 BEGIN
/* 
 * TABLE: CustomMentalStatuses2 
 */
CREATE TABLE CustomMentalStatuses2(
	DocumentVersionId							int							NOT NULL,
	CreatedBy								    type_CurrentUser			NOT NULL,
    CreatedDate                                 type_CurrentDatetime		NOT NULL,
    ModifiedBy                                  type_CurrentUser			NOT NULL,
    ModifiedDate                                type_CurrentDatetime		NOT NULL,
    RecordDeleted                               type_YOrN					NULL
												CHECK (RecordDeleted in ('N','Y')),
    DeletedBy                                   type_UserId					NULL,
    DeletedDate                                 datetime					NULL,
    AppearanceAddToNeedsList					type_YOrN					NULL
												CHECK (AppearanceAddToNeedsList in ('N','Y')),
	AppearanceNeatClean							type_YOrN					NULL
												CHECK (AppearanceNeatClean in ('N','Y')),
	AppearancePoorHygiene						type_YOrN					NULL
												CHECK (AppearancePoorHygiene in ('N','Y')),
	AppearanceWellGroomed						type_YOrN					NULL
												CHECK (AppearanceWellGroomed in ('N','Y')),
	AppearanceAppropriatelyDressed				type_YOrN					NULL
												CHECK (AppearanceAppropriatelyDressed in ('N','Y')),
	AppearanceYoungerThanStatedAge				type_YOrN					NULL
												CHECK (AppearanceYoungerThanStatedAge in ('N','Y')),
	AppearanceOlderThanStatedAge				type_YOrN					NULL
												CHECK (AppearanceOlderThanStatedAge in ('N','Y')),
	AppearanceOverweight						type_YOrN					NULL
												CHECK (AppearanceOverweight in ('N','Y')),
	AppearanceUnderweight						type_YOrN					NULL
												CHECK (AppearanceUnderweight in ('N','Y')),
	AppearanceEccentric							type_YOrN					NULL
												CHECK (AppearanceEccentric in ('N','Y')),
	AppearanceSeductive							type_YOrN					NULL
												CHECK (AppearanceSeductive in ('N','Y')),
	AppearanceUnkemptDisheveled					type_YOrN					NULL
												CHECK (AppearanceUnkemptDisheveled in ('N','Y')),
	AppearanceOther								type_YOrN					NULL
												CHECK (AppearanceOther in ('N','Y')),
	AppearanceComment							type_Comment2				NULL,
	IntellectualAddToNeedsList					type_YOrN					NULL
												CHECK (IntellectualAddToNeedsList in ('N','Y')),
	IntellectualAboveAverage					type_YOrN					NULL
												CHECK (IntellectualAboveAverage in ('N','Y')),
	IntellectualAverage							type_YOrN					NULL
												CHECK (IntellectualAverage in ('N','Y')),
	IntellectualBelowAverage					type_YOrN					NULL
												CHECK (IntellectualBelowAverage in ('N','Y')),
	IntellectualPossibleMR						type_YOrN					NULL
												CHECK (IntellectualPossibleMR in ('N','Y')),
	IntellectualDocumentedMR					type_YOrN					NULL
												CHECK (IntellectualDocumentedMR in ('N','Y')),
	IntellectualOther							type_YOrN					NULL
												CHECK (IntellectualOther in ('N','Y')),
	IntellectualComment							type_Comment2				NULL,
	CommunicationAddToNeedsList					type_YOrN					NULL
												CHECK (CommunicationAddToNeedsList in ('N','Y')),
	CommunicationNormal							type_YOrN					NULL
												CHECK (CommunicationNormal in ('N','Y')),
	CommunicationUsesSignLanguage				type_YOrN					NULL
												CHECK (CommunicationUsesSignLanguage in ('N','Y')),
	CommunicationUnableToRead					type_YOrN					NULL
												CHECK (CommunicationUnableToRead in ('N','Y')),
	CommunicationNeedForBraille					type_YOrN					NULL
												CHECK (CommunicationNeedForBraille in ('N','Y')),
	CommunicationHearingImpaired				type_YOrN					NULL
												CHECK (CommunicationHearingImpaired in ('N','Y')),
	CommunicationDoesLipReading					type_YOrN					NULL
												CHECK (CommunicationDoesLipReading in ('N','Y')),
	CommunicationEnglishIsSecondLanguage		type_YOrN					NULL
												CHECK (CommunicationEnglishIsSecondLanguage in ('N','Y')),
	CommunicationTranslatorNeeded				type_YOrN					NULL
												CHECK (CommunicationTranslatorNeeded in ('N','Y')),
	CommunicationOther							type_YOrN					NULL
												CHECK (CommunicationOther in ('N','Y')),
	CommunicationComment						type_Comment2				NULL,
	MoodAddToNeedsList							type_YOrN					NULL
												CHECK (MoodAddToNeedsList in ('N','Y')),
	MoodUnremarkable							type_YOrN					NULL
												CHECK (MoodUnremarkable in ('N','Y')),
	MoodCooperative								type_YOrN					NULL
												CHECK (MoodCooperative in ('N','Y')),
	MoodAnxious									type_YOrN					NULL
												CHECK (MoodAnxious in ('N','Y')),
	MoodTearful									type_YOrN					NULL
												CHECK (MoodTearful in ('N','Y')),
	MoodCalm									type_YOrN					NULL
												CHECK (MoodCalm in ('N','Y')),
	MoodLabile									type_YOrN					NULL
												CHECK (MoodLabile in ('N','Y')),
	MoodPessimistic								type_YOrN					NULL
												CHECK (MoodPessimistic in ('N','Y')),
	MoodCheerful								type_YOrN					NULL
												CHECK (MoodCheerful in ('N','Y')),
	MoodGuilty									type_YOrN					NULL
												CHECK (MoodGuilty in ('N','Y')),
	MoodEuphoric								type_YOrN					NULL
												CHECK (MoodEuphoric in ('N','Y')),
	MoodDepressed								type_YOrN					NULL
												CHECK (MoodDepressed in ('N','Y')),
	MoodHostile									type_YOrN					NULL
												CHECK (MoodHostile in ('N','Y')),
	MoodIrritable								type_YOrN					NULL
												CHECK (MoodIrritable in ('N','Y')),
	MoodDramatized								type_YOrN					NULL
												CHECK (MoodDramatized in ('N','Y')),
	MoodFearful									type_YOrN					NULL
												CHECK (MoodFearful in ('N','Y')),
	MoodSupicious								type_YOrN					NULL
												CHECK (MoodSupicious in ('N','Y')),
	MoodOther									type_YOrN					NULL
												CHECK (MoodOther in ('N','Y')),
	MoodComment									type_Comment2				NULL,
	AffectAddToNeedsList						type_YOrN					NULL
												CHECK (AffectAddToNeedsList in ('N','Y')),
	AffectPrimarilyAppropriate					type_YOrN					NULL
												CHECK (AffectPrimarilyAppropriate in ('N','Y')),
	AffectRestricted							type_YOrN					NULL
												CHECK (AffectRestricted in ('N','Y')),
	AffectBlunted								type_YOrN					NULL
												CHECK (AffectBlunted in ('N','Y')),
	AffectFlattened								type_YOrN					NULL
												CHECK (AffectFlattened in ('N','Y')),
	AffectDetached								type_YOrN					NULL
												CHECK (AffectDetached in ('N','Y')),
	AffectPrimarilyInappropriate				type_YOrN					NULL
												CHECK (AffectPrimarilyInappropriate in ('N','Y')),
	AffectOther									type_YOrN					NULL
												CHECK (AffectOther in ('N','Y')),
	AffectComment								type_Comment2				NULL,
	SpeechAddToNeedsList						type_YOrN					NULL
												CHECK (SpeechAddToNeedsList in ('N','Y')),
	SpeechNormal								type_YOrN					NULL
												CHECK (SpeechNormal in ('N','Y')),
	SpeechLogicalCoherent						type_YOrN					NULL
												CHECK (SpeechLogicalCoherent in ('N','Y')),
	SpeechTangential							type_YOrN					NULL
												CHECK (SpeechTangential in ('N','Y')),
	SpeechSparseSlow							type_YOrN					NULL
												CHECK (SpeechSparseSlow in ('N','Y')),
	SpeechRapidPressured						type_YOrN					NULL
												CHECK (SpeechRapidPressured in ('N','Y')),
	SpeechSoft									type_YOrN					NULL
												CHECK (SpeechSoft in ('N','Y')),
	SpeechCircumstantial						type_YOrN					NULL
												CHECK (SpeechCircumstantial in ('N','Y')),
	SpeechLoud									type_YOrN					NULL
												CHECK (SpeechLoud in ('N','Y')),
	SpeechRambling								type_YOrN					NULL
												CHECK (SpeechRambling in ('N','Y')),
	SpeechOther									type_YOrN					NULL
												CHECK (SpeechOther in ('N','Y')),
	SpeechComment								type_Comment2				NULL,
	ThoughtAddToNeedsList						type_YOrN					NULL
												CHECK (ThoughtAddToNeedsList in ('N','Y')),
	ThoughtUnremarkable							type_YOrN					NULL
												CHECK (ThoughtUnremarkable in ('N','Y')),
	ThoughtParanoid								type_YOrN					NULL
												CHECK (ThoughtParanoid in ('N','Y')),
	ThoughtGrandiose							type_YOrN					NULL
												CHECK (ThoughtGrandiose in ('N','Y')),
	ThoughtObsessive							type_YOrN					NULL
												CHECK (ThoughtObsessive in ('N','Y')),
	ThoughtBizarre								type_YOrN					NULL
												CHECK (ThoughtBizarre in ('N','Y')),
	ThoughtFlightOfIdeas						type_YOrN					NULL
												CHECK (ThoughtFlightOfIdeas in ('N','Y')),
	ThoughtDisorganized							type_YOrN					NULL
												CHECK (ThoughtDisorganized in ('N','Y')),
	ThoughtAuditoryHallucinations				type_YOrN					NULL
												CHECK (ThoughtAuditoryHallucinations in ('N','Y')),
	ThoughtVisualHallucinations					type_YOrN					NULL
												CHECK (ThoughtVisualHallucinations in ('N','Y')),
	ThoughtTactileHallucinations				type_YOrN					NULL
												CHECK (ThoughtTactileHallucinations in ('N','Y')),
	ThoughtOther								type_YOrN					NULL
												CHECK (ThoughtOther in ('N','Y')),
	ThoughtComment								type_Comment2				NULL,
	BehaviorAddToNeedsList						type_YOrN					NULL
												CHECK (BehaviorAddToNeedsList in ('N','Y')),
	BehaviorNormal								type_YOrN					NULL
												CHECK (BehaviorNormal in ('N','Y')),
	BehaviorRestless							type_YOrN					NULL
												CHECK (BehaviorRestless in ('N','Y')),
	BehaviorTremors								type_YOrN					NULL
												CHECK (BehaviorTremors in ('N','Y')),
	BehaviorPoorEyeContact						type_YOrN					NULL
												CHECK (BehaviorPoorEyeContact in ('N','Y')),
	BehaviorAgitated							type_YOrN					NULL
												CHECK (BehaviorAgitated in ('N','Y')),
	BehaviorPeculiar							type_YOrN					NULL
												CHECK (BehaviorPeculiar in ('N','Y')),
	BehaviorSelfDestructive						type_YOrN					NULL
												CHECK (BehaviorSelfDestructive in ('N','Y')),
	BehaviorSlowed								type_YOrN					NULL
												CHECK (BehaviorSlowed in ('N','Y')),
	BehaviorDestructiveToOthers					type_YOrN					NULL
												CHECK (BehaviorDestructiveToOthers in ('N','Y')),
	BehaviorCompulsive							type_YOrN					NULL
												CHECK (BehaviorCompulsive in ('N','Y')),
	BehaviorOther								type_YOrN					NULL
												CHECK (BehaviorOther in ('N','Y')),
	BehaviorComment								type_Comment2				NULL,
	OrientationAddToNeedsList					type_YOrN					NULL
												CHECK (OrientationAddToNeedsList in ('N','Y')),
	OrientationToPersonPlaceTime				type_YOrN					NULL
												CHECK (OrientationToPersonPlaceTime in ('N','Y')),
	OrientationNotToPerson						type_YOrN					NULL
												CHECK (OrientationNotToPerson in ('N','Y')),
	OrientationNotToPlace						type_YOrN					NULL
												CHECK (OrientationNotToPlace in ('N','Y')),
	OrientationNotToTime						type_YOrN					NULL
												CHECK (OrientationNotToTime in ('N','Y')),
	OrientationOther							type_YOrN					NULL
												CHECK (OrientationOther in ('N','Y')),
	OrientationComment							type_Comment2				NULL,
	InsightAddToNeedsList						type_YOrN					NULL
												CHECK (InsightAddToNeedsList in ('N','Y')),
	InsightGood									type_YOrN					NULL
												CHECK (InsightGood in ('N','Y')),
	InsightFair									type_YOrN					NULL
												CHECK (InsightFair in ('N','Y')),
	InsightPoor									type_YOrN					NULL
												CHECK (InsightPoor in ('N','Y')),
	InsightLacking								type_YOrN					NULL
												CHECK (InsightLacking in ('N','Y')),
	InsightOther								type_YOrN					NULL
												CHECK (InsightOther in ('N','Y')),
	InsightComment								type_Comment2				NULL,
	MemoryAddToNeedsList						type_YOrN					NULL
												CHECK (MemoryAddToNeedsList in ('N','Y')),
	MemoryGoodNormal							type_YOrN					NULL
												CHECK (MemoryGoodNormal in ('N','Y')),
	MemoryImpairedShortTerm						type_YOrN					NULL
												CHECK (MemoryImpairedShortTerm in ('N','Y')),
	MemoryImpairedLongTerm						type_YOrN					NULL
												CHECK (MemoryImpairedLongTerm in ('N','Y')),
	MemoryOther									type_YOrN					NULL
												CHECK (MemoryOther in ('N','Y')),
	MemoryComment								type_Comment2				NULL,
	RealityOrientationAddToNeedsList			type_YOrN					NULL
												CHECK (RealityOrientationAddToNeedsList in ('N','Y')),
	RealityOrientationIntact					type_YOrN					NULL
												CHECK (RealityOrientationIntact in ('N','Y')),
	RealityOrientationTenuous					type_YOrN					NULL
												CHECK (RealityOrientationTenuous in ('N','Y')),
	RealityOrientationPoor						type_YOrN					NULL
												CHECK (RealityOrientationPoor in ('N','Y')),
	RealityOrientationOther						type_YOrN					NULL
												CHECK (RealityOrientationOther in ('N','Y')),
	RealityOrientationComment					type_Comment2				NULL,
	ThoughtDissociativeSymptom					type_YOrN					NULL
												CHECK (ThoughtDissociativeSymptom in ('N','Y')),
	ThoughtNightmare							type_YOrN					NULL
												CHECK (ThoughtNightmare in ('N','Y')),
	CONSTRAINT CustomMentalStatuses2_PK PRIMARY KEY CLUSTERED (DocumentVersionId)
)

IF OBJECT_ID('CustomMentalStatuses2') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomMentalStatuses2 >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomMentalStatuses2 >>>', 16, 1)
/* 
 * TABLE: CustomMentalStatuses2 
 */   
    
ALTER TABLE CustomMentalStatuses2 ADD CONSTRAINT DocumentVersions_CustomMentalStatuses2_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
     
PRINT 'STEP 4(N) COMPLETED'
 END

 IF Not EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentCRAFFTs')
 BEGIN
/* 
 * TABLE: CustomDocumentCRAFFTs 
 */
CREATE TABLE CustomDocumentCRAFFTs(
	DocumentVersionId							int							NOT NULL,
	CreatedBy								    type_CurrentUser			NOT NULL,
    CreatedDate                                 type_CurrentDatetime		NOT NULL,
    ModifiedBy                                  type_CurrentUser			NOT NULL,
    ModifiedDate                                type_CurrentDatetime		NOT NULL,
    RecordDeleted                               type_YOrN					NULL
												CHECK (RecordDeleted in ('N','Y')),
    DeletedBy                                   type_UserId					NULL,
    DeletedDate                                 datetime					NULL,
    CrafftApplicable							type_YOrN					NULL
												CHECK (CrafftApplicable in ('N','Y')),
	CrafftApplicableReason						type_Comment2				NULL,
	CrafftQuestionC								type_YOrN					NULL
												CHECK (CrafftQuestionC in ('N','Y')),
	CrafftQuestionR								type_YOrN					NULL
												CHECK (CrafftQuestionR in ('N','Y')),
	CrafftQuestionA								type_YOrN					NULL
												CHECK (CrafftQuestionA in ('N','Y')),
	CrafftQuestionF								type_YOrN					NULL
												CHECK (CrafftQuestionF in ('N','Y')),
	CrafftQuestionFR							type_YOrN					NULL
												CHECK (CrafftQuestionFR in ('N','Y')),
	CrafftQuestionT								type_YOrN					NULL
												CHECK (CrafftQuestionT in ('N','Y')),
	CrafftCompleteFullSUAssessment				type_YOrN					NULL
												CHECK (CrafftCompleteFullSUAssessment in ('N','Y')),
	CrafftStageOfChange							type_GlobalCode				NULL,
	CONSTRAINT CustomDocumentCRAFFTs_PK PRIMARY KEY CLUSTERED (DocumentVersionId)
)

IF OBJECT_ID('CustomDocumentCRAFFTs') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentCRAFFTs >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentCRAFFTs >>>', 16, 1)
/* 
 * TABLE: CustomDocumentCRAFFTs 
 */   
    
ALTER TABLE CustomDocumentCRAFFTs ADD CONSTRAINT DocumentVersions_CustomDocumentCRAFFTs_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
     
PRINT 'STEP 4(O) COMPLETED'
 END

 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomASAMPlacements')
 BEGIN
/* 
 * TABLE: CustomASAMPlacements 
 */
CREATE TABLE CustomASAMPlacements(
	DocumentVersionId							int							NOT NULL,
	CreatedBy								    type_CurrentUser			NOT NULL,
    CreatedDate                                 type_CurrentDatetime		NOT NULL,
    ModifiedBy                                  type_CurrentUser			NOT NULL,
    ModifiedDate                                type_CurrentDatetime		NOT NULL,
    RecordDeleted                               type_YOrN					NULL
												CHECK (RecordDeleted in ('N','Y')),
    DeletedBy                                   type_UserId					NULL,
    DeletedDate                                 datetime					NULL,
	Dimension1LevelOfCare						int							NULL,
	Dimension1Need								type_Comment2				NULL,
	Dimension2LevelOfCare						int							NULL,
	Dimension2Need								type_Comment2				NULL,
	Dimension3LevelOfCare						int							NULL,
	Dimension3Need								type_Comment2				NULL,
	Dimension4LevelOfCare						int							NULL,
	Dimension4Need								type_Comment2				NULL,
	Dimension5LevelOfCare						int							NULL,
	Dimension5Need								type_Comment2				NULL,
	Dimension6LevelOfCare						int							NULL,
	Dimension6Need								type_Comment2				NULL,
	SuggestedPlacement							int							NULL,
	FinalPlacement								int							NULL,
	FinalPlacementComment						type_Comment2				NULL,
	CONSTRAINT CustomASAMPlacements_PK PRIMARY KEY CLUSTERED (DocumentVersionId)
)

IF OBJECT_ID('CustomASAMPlacements') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomASAMPlacements >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomASAMPlacements >>>', 16, 1)
/* 
 * TABLE: CustomDocumentCRAFFTs 
 */   
    
ALTER TABLE CustomASAMPlacements ADD CONSTRAINT DocumentVersions_CustomASAMPlacements_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)


ALTER TABLE CustomASAMPlacements ADD CONSTRAINT CustomASAMLevelOfCares_CustomASAMPlacements_FK
    FOREIGN KEY (Dimension1LevelOfCare)
    REFERENCES CustomASAMLevelOfCares(ASAMLevelOfCareId)
 
ALTER TABLE CustomASAMPlacements ADD CONSTRAINT CustomASAMLevelOfCares_CustomASAMPlacements_FK2
    FOREIGN KEY (Dimension2LevelOfCare)
    REFERENCES CustomASAMLevelOfCares(ASAMLevelOfCareId)

ALTER TABLE CustomASAMPlacements ADD CONSTRAINT CustomASAMLevelOfCares_CustomASAMPlacements_FK3
    FOREIGN KEY (Dimension3LevelOfCare)
    REFERENCES CustomASAMLevelOfCares(ASAMLevelOfCareId)


ALTER TABLE CustomASAMPlacements ADD CONSTRAINT CustomASAMLevelOfCares_CustomASAMPlacements_FK4
    FOREIGN KEY (Dimension4LevelOfCare)
    REFERENCES CustomASAMLevelOfCares(ASAMLevelOfCareId)


ALTER TABLE CustomASAMPlacements ADD CONSTRAINT CustomASAMLevelOfCares_CustomASAMPlacements_FK5
    FOREIGN KEY (Dimension5LevelOfCare)
    REFERENCES CustomASAMLevelOfCares(ASAMLevelOfCareId)


ALTER TABLE CustomASAMPlacements ADD CONSTRAINT CustomASAMLevelOfCares_CustomASAMPlacements_FK6
    FOREIGN KEY (Dimension6LevelOfCare)
    REFERENCES CustomASAMLevelOfCares(ASAMLevelOfCareId)
 
 
ALTER TABLE CustomASAMPlacements ADD CONSTRAINT CustomASAMLevelOfCares_CustomASAMPlacements_FK7
    FOREIGN KEY (SuggestedPlacement)
    REFERENCES CustomASAMLevelOfCares(ASAMLevelOfCareId)

ALTER TABLE CustomASAMPlacements ADD CONSTRAINT CustomASAMLevelOfCares_CustomASAMPlacements_FK8
    FOREIGN KEY (FinalPlacement)
    REFERENCES CustomASAMLevelOfCares(ASAMLevelOfCareId)
     
PRINT 'STEP 4(P) COMPLETED'
 END
 IF Not EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomFASRequestLog')
 BEGIN
/* 
 * TABLE: CustomFASRequestLog 
 */
CREATE TABLE CustomFASRequestLog(
	FASRequestId								int IDENTITY(1,1)			NOT NULL,
	RequestType									varchar(50)					NOT NULL,
	RequestXML									varchar(max)				NULL,
	ResponseXML									varchar(max)				NULL,
	ResponseProcessed							type_YOrN					NULL
												CHECK (ResponseProcessed in ('N','Y')),
	ResponseError								type_YOrN					NULL
												CHECK (ResponseError in ('N','Y')),
	CreatedDate                                 type_CurrentDatetime		NOT NULL,
	ModifiedDate                                type_CurrentDatetime		NOT NULL,
	CONSTRAINT CustomFASRequestLog_PK PRIMARY KEY CLUSTERED (FASRequestId)
)

IF OBJECT_ID('CustomFASRequestLog') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomFASRequestLog >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomFASRequestLog >>>', 16, 1)
    
PRINT 'STEP 4(Q) COMPLETED'
 END

IF Not EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomFASCAFASAssessments')
 BEGIN
/* 
 * TABLE: CustomFASCAFASAssessments 
 */
CREATE TABLE CustomFASCAFASAssessments(
	CAFASAssessmentId							int IDENTITY(1,1)			NOT NULL,
	FASRequestId								int							NOT NULL,
	ResponseRecordId							int							NOT NULL,
	DocumentVersionId							int							NULL,
	AssessmentId								uniqueidentifier			NOT NULL,
	AssessmentDate								datetime					NULL,
	IsDeleted									varchar(3)					NULL,
	ClientId									varchar(20)					NULL,
	ClientName									varchar(100)				NULL,
	ClientAge									int							NULL,
	AdministrationDescription					varchar(100)				NULL,
	IsLocked									varchar(5)					NULL,
	AssessmentStatus							varchar(20)					NULL,
	EmployeeId									varchar(20)					NULL,
	ServiceAreaCode								varchar(20)					NULL,
	ServiceAreaName								varchar(50)					NULL,
	ProgramCode									varchar(20)					NULL,
	ProgramName									varchar(50)					NULL,
	Rater										varchar(100)				NULL,
	EpisodeNumber								int							NULL,
	TotalScore									int							NULL,
	CAFASTier									varchar(50)					NULL,
	RiskBehaviors								varchar(max)				NULL,
	ChildMgmtConsider							varchar(20)					NULL,
	SevereImpairmentsTotal						int							NULL,
	PervasiveBehImpResult						varchar(20)					NULL,
	ChangeTotalScore							int							NULL,
	ChangeSevereImpairments						varchar(20)					NULL,
	ChangePervasiveBehImp						varchar(20)					NULL,
	ChangeMeaningfulReliableDiff				varchar(20)					NULL,
	ChangeImprovement1orMore					varchar(20)					NULL,
	YouthSchoolScore							int							NULL,
	YouthSchoolCouldNotScore					varchar(5)					NULL,
	YouthSchoolExplanation						varchar(max)				NULL,
	YouthSchoolPlanText							varchar(max)				NULL,
	YouthHomeScore								int							NULL,
	YouthHomeCouldNotScore						varchar(5)					NULL,
	YouthHomeExplanation						varchar(max)				NULL,
	YouthHomePlanText							varchar(max)				NULL,
	YouthCommunityScore							int							NULL,
	YouthCommunityCouldNotScore					varchar(5)					NULL,
	YouthCommunityExplanation					varchar(max)				NULL,
	YouthCommunityPlanText						varchar(max)				NULL,
	YouthBehaviorScore							int							NULL,
	YouthBehaviorCouldNotScore					varchar(5)					NULL,
	YouthBehaviorExplanation					varchar(max)				NULL,
	YouthBehaviorPlanText						varchar(max)				NULL,
	YouthMoodsScore								int							NULL,
	YouthMoodsCouldNotScore						varchar(5)					NULL,
	YouthMoodsExplanation						varchar(max)				NULL,
	YouthMoodsPlanText							varchar(max)				NULL,
	YouthSelfHarmScore							int							NULL,
	YouthSelfHarmCouldNotScore					varchar(5)					NULL,
	YouthSelfHarmExplanation					varchar(max)				NULL,
	YouthSelfHarmPlanText						varchar(max)				NULL,
	YouthSubUseScore							int							NULL,
	YouthSubUseCouldNotScore					varchar(5)					NULL,
	YouthSubUseExplanation						varchar(max)				NULL,
	YouthSubUsePlanText							varchar(max)				NULL,
	YouthThinkingScore							int							NULL,
	YouthThinkingCouldNotScore					varchar(5)					NULL,
	YouthThinkingExplanation					varchar(max)				NULL,
	YouthThinkingPlanText						varchar(max)				NULL,
	CaregiverPrimaryMaterialScore				int							NULL,
	CaregiverPrimarySocialScore					int							NULL,
	CaregiverPrimaryCouldNotScore				varchar(5)					NULL,
	CaregiverPrimaryCaregiverName				varchar(100)				NULL,
	CaregiverPrimaryCaregiverRelation			varchar(50)					NULL,
	CaregiverPrimaryMaterialExplanation			varchar(max)				NULL,
	CaregiverPrimarySocialExplanation			varchar(max)				NULL,
	CaregiverPrimaryPlanText					varchar(max)				NULL,
	CaregiverNonCustodialMaterialScore			int							NULL,
	CaregiverNonCustodialSocialScore			int							NULL,
	CaregiverNonCustodialCouldNotScore			varchar(5)					NULL,
	CaregiverNonCustodialCaregiverName			varchar(100)				NULL,
	CaregiverNonCustodialCaregiverRelation		varchar(50)					NULL,
	CaregiverNonCustodialMaterialExplanation	varchar(max)				NULL,
	CaregiverNonCustodialSocialExplanation		varchar(max)				NULL,
	CaregiverNonCustodialPlanText				varchar(max)				NULL,
	CaregiverSurrogateMaterialScore				int							NULL,
	CaregiverSurrogateSocialScore				int							NULL,
	CaregiverSurrogateCouldNotScore				varchar(5)					NULL,
	CaregiverSurrogateCaregiverName				varchar(100)				NULL,
	CaregiverSurrogateCaregiverRelation			varchar(50)					NULL,
	CaregiverSurrogateMaterialExplanation		varchar(max)				NULL,
	CaregiverSurrogateSocialExplanation			varchar(max)				NULL,
	CaregiverSurrogatePlanText					varchar(max)				NULL,
	CreatedDate                                 type_CurrentDatetime		NOT NULL,
	CONSTRAINT CustomFASCAFASAssessments_PK PRIMARY KEY CLUSTERED (CAFASAssessmentId)
)

IF OBJECT_ID('CustomFASCAFASAssessments') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomFASCAFASAssessments >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomFASCAFASAssessments >>>', 16, 1)
     
PRINT 'STEP 4(R) COMPLETED'
 END
IF Not EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomCafasRaters')
 BEGIN
/* 
 * TABLE: CustomCafasRaters 
 */
CREATE TABLE CustomCafasRaters(
	StaffId			int							NOT NULL,	
    Active		    char(1)						NULL,
    CONSTRAINT CustomCafasRaters_PK PRIMARY KEY CLUSTERED (StaffId)
)

IF OBJECT_ID('CustomCafasRaters') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomCafasRaters >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomCafasRaters >>>', 16, 1)
 
 /* 
 * TABLE: CustomCafasRaters 
 */   
PRINT 'STEP 4(S) COMPLETED'
 END
 
 IF Not EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomFamilyHistory')
 BEGIN
/* 
 * TABLE: CustomFamilyHistory 
 */
CREATE TABLE CustomFamilyHistory(
	FamilyHistoryId 						int	identity(1,1)			NOT NULL,
	CreatedBy								type_CurrentUser			NOT NULL,
    CreatedDate                             type_CurrentDatetime		NOT NULL,
    ModifiedBy                              type_CurrentUser			NOT NULL,
    ModifiedDate                            type_CurrentDatetime		NOT NULL,
    RecordDeleted                           type_YOrN					NULL
											CHECK (RecordDeleted in ('Y','N')),
    DeletedBy                               type_UserId					NULL,
    DeletedDate                             datetime					NULL,
	DocumentVersionId						int							NULL,
	FamilyMemberType						type_GlobalCode				NULL,
	IsLiving								char						NULL,
	CurrentAge								int							NULL,
	CauseOfDeath							varchar(1000)				NULL,
	Hypertension							type_YOrN					NULL
											CHECK (Hypertension in ('Y','N')),					
	Hyperlipidemia							type_YOrN					NULL
											CHECK (Hyperlipidemia in ('Y','N')),
	Diabetes								type_YOrN					NULL
											CHECK (Diabetes in ('Y','N')),
	DiabetesType1							type_YOrN					NULL
											CHECK (DiabetesType1 in ('Y','N')),
	DiabetesType2							type_YOrN					NULL
											CHECK (DiabetesType2 in ('Y','N')),
	Alcoholism								type_YOrN					NULL
											CHECK (Alcoholism in ('Y','N')),
	COPD									type_YOrN					NULL
											CHECK (COPD in ('Y','N')),
	Depression								type_YOrN					NULL
											CHECK (Depression in ('Y','N')),
	ThyroidDisease							type_YOrN					NULL
											CHECK (ThyroidDisease in ('Y','N')),
	CoronaryArteryDisease					type_YOrN					NULL
											CHECK (CoronaryArteryDisease in ('Y','N')),
	Cancer									type_YOrN					NULL
											CHECK (Cancer in ('Y','N')),
	CancerType								type_GlobalCode				NULL,
	Other									type_YOrN					NULL
											CHECK (Other in ('Y','N')),
	OtherComment							type_Comment2				NULL,
	DiseaseConditionDXCode					varchar(10)					NULL,
	DiseaseConditionDXCodeDescription		varchar(1000)				NULL,
	CONSTRAINT CustomFamilyHistory_PK PRIMARY KEY CLUSTERED (FamilyHistoryId)
)

IF OBJECT_ID('CustomFamilyHistory') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomFamilyHistory >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomFamilyHistory >>>', 16, 1)
/* 
 * TABLE: CustomFamilyHistory 
 */   
    
ALTER TABLE CustomFamilyHistory ADD CONSTRAINT DocumentVersions_CustomFamilyHistory_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)

PRINT 'STEP 4(T) COMPLETED'
END

IF Not EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentGambling')
 BEGIN
/* 
 * TABLE: CustomDocumentGambling 
 */
CREATE TABLE CustomDocumentGambling(
	DocumentVersionId 						int						NOT NULL,
	CreatedBy								type_CurrentUser		NOT NULL,
    CreatedDate                             type_CurrentDatetime	NOT NULL,
    ModifiedBy                              type_CurrentUser		NOT NULL,
    ModifiedDate                            type_CurrentDatetime	NOT NULL,
    RecordDeleted                           type_YOrN				NULL
											CHECK (RecordDeleted in ('Y','N')),
    DeletedBy                               type_UserId				NULL,
    DeletedDate                             datetime				NULL,
    GamblingDate							datetime				NULL,
	TotalMonthlyHousehold					money					NULL,
	HealthInsurance							type_GlobalCode			NULL,
	PrimarySourceOfIncome					type_GlobalCode			NULL,
	TotalNumberOfDependents					int						NULL,
	LastGradeCompleted						varchar(500)			NULL,
	TotalEstimatedGamblingDebt				money					NULL,
	LifeInGeneral							type_GlobalCode			NULL,
	OverallPhysicalHealth					type_GlobalCode			NULL,
	OverallEmotionalWellbeing				type_GlobalCode			NULL,
	RelationshipWithSpouse					type_GlobalCode			NULL,
	RelationshipWithFriends					type_GlobalCode			NULL,
	RelationshipWithOtherFamilyMembers		type_GlobalCode			NULL,
	RelationshipWithChildren				type_GlobalCode			NULL,
	Job										type_GlobalCode			NULL,
	School									type_GlobalCode			NULL,
	SpiritualWellbeing						type_GlobalCode			NULL,
	AccomplishedResponsibilitiesAtWork		type_GlobalCode			NULL,
	PaidBillsOnTime							type_GlobalCode			NULL,
	AccomplishedResponsibilitiesAtHome		type_GlobalCode			NULL,
	HaveThoughtsOfSuicide					type_GlobalCode			NULL,
	AttemptToCommitSuicide					type_GlobalCode			NULL,
	DrinkAlcohol							type_GlobalCode			NULL,
	ProblemsAssociatedWithAlcohol			type_GlobalCode			NULL,
	UseOfIllegalDrugs						type_GlobalCode			NULL,
	ProblemsAssociatedWithIllegalDrugs		type_GlobalCode			NULL,
	UseOfTobacco							type_GlobalCode			NULL,
	CommitIllegalActs						type_GlobalCode			NULL,
	MaintainSupportiveNetworkOfFamily		type_GlobalCode			NULL,
	TakeTimeToRelax							type_GlobalCode			NULL,
	EatHealthyFood							type_GlobalCode			NULL,
	Exercise								type_GlobalCode			NULL,
	AttendCommunitySupport					type_GlobalCode			NULL,
	ThinkingAboutGambling					type_GlobalCode			NULL,
	GamblingWithMoreMoney					type_GlobalCode			NULL,
	UnsuccessfulAttemptsToControlGambling	type_GlobalCode			NULL,
	RestlessOrIrritable						type_GlobalCode			NULL,
	GambleToEscapeFromProblems				type_GlobalCode			NULL,
	ReturningAfterLosingGamblingMoney		type_GlobalCode			NULL,
	LieToFamily								type_GlobalCode			NULL,
	GoBeyondLegalGambling					type_GlobalCode			NULL,
	LoseSignificantRelationship				type_GlobalCode			NULL,
	SeekHelpFromOthers						type_GlobalCode			NULL,
	NumberOfDaysGambled						int						NULL,
	AverageAmountGambled					money					NULL,
	PrimaryGamblingActivity					varchar(200)			NULL,
	PrimarilyGamblingPlace					varchar(200)			NULL,
	NumberOfTimesEnteredEmergencyRoom		int						NULL,
	EnrolledInTreatmentProgramForAlcohol	type_GlobalCode			NULL,
	AlcoholInpatientAAndD					type_YOrN				NULL
											CHECK (AlcoholInpatientAAndD in('Y','N')),
	AlcoholOutpatientAAndD					type_YOrN				NULL
												CHECK (AlcoholOutpatientAAndD in('Y','N')),
	EnrolledInTreatmentProgramForMentalHealth type_GlobalCode		NULL,
	MentalHealthInpatientAAndD				type_YOrN				NULL
											CHECK (MentalHealthInpatientAAndD in('Y','N')),
	MentalHealthOutpatientAAndD				type_YOrN				NULL
											CHECK (MentalHealthOutpatientAAndD in('Y','N')),
	EnrolledInAnotherGamblingProgram		type_GlobalCode			NULL,
	GamblingInpatientAAndD					type_YOrN				NULL
											 CHECK (GamblingInpatientAAndD in('Y','N')),
	GamblingOutpatientAAndD					type_YOrN				NULL
											CHECK (GamblingOutpatientAAndD in('Y','N')),
	FiledForBankruptcy						type_YOrN				NULL
											CHECK (FiledForBankruptcy in('Y','N')),
	ConvictedOfGambling						type_YOrN				NULL
											CHECK (ConvictedOfGambling in('Y','N')),
	ExperiencedPhysicalViolence				type_YOrN				NULL
											CHECK (ExperiencedPhysicalViolence in('Y','N')),
	AbuseInRelationship						type_YOrN				NULL
											CHECK (AbuseInRelationship in('Y','N')),
	ControlloedManipulatedByOther			type_YOrN				NULL
											CHECK (ControlloedManipulatedByOther in('Y','N')),	
	CONSTRAINT CustomDocumentGambling_PK PRIMARY KEY CLUSTERED (DocumentVersionId)
)

IF OBJECT_ID('CustomDocumentGambling') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentGambling >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentGambling >>>', 16, 1)
/* 
 * TABLE: CustomDocumentGambling 
 */   
    
ALTER TABLE CustomDocumentGambling ADD CONSTRAINT DocumentVersions_CustomDocumentGambling_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)

PRINT 'STEP 4(U) COMPLETED'
END
  ---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------


IF NOT EXISTS (SELECT [key] FROM SystemConfigurationKeys WHERE [key] = 'CDM_Assessment')
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
				   ,'CDM_Assessment'
				   ,'1.0'
				   )
		PRINT 'STEP 7 COMPLETED'
	END
 GO