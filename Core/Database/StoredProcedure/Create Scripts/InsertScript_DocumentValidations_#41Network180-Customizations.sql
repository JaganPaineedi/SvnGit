-----------------------------------------------
--Author : Shruthi.S
--Date   : 02/05/2016
--Purpose: Added validations.Ref : #41 Netwokr180-Customziations.
--15/07/2016 Added new validation for sub checkboxes as per discussion with Katie.Ref : #41 Network180-Customizations.
------------------------------------------------
Declare @DocumentCodeId int
set @DocumentCodeId =1638 
DELETE FROM  DocumentValidations WHERE DocumentCodeId=1638 AND TableName='DocumentLOCUS'

INSERT INTO [documentvalidations] ([Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[SectionName])VALUES
('Y',@DocumentCodeId,NULL,NULL,1,'DocumentLOCUS','MinimalRiskOfHarmNoIndication','FROM DocumentLOCUS WHERE DocumentVersionId=@DocumentVersionId  
AND ( EXISTS(select 1 FROM DocumentLOCUS WHERE DocumentVersionId=@DocumentVersionId and (
ISNULL(MinimalRiskOfHarmNoIndication,''N'') = ''N''  AND
ISNULL(MinimalRiskOfHarmClearAbility,''N'') = ''N''  AND
ISNULL(LowRiskOfHarmNoCurrentSuicidal,''N'') =''N''  AND
ISNULL(LowRiskOfHarmOccasionalSubstance,''N'') =''N'' AND
ISNULL(LowRiskOfHarmPeriodsInPast,''N'') =''N'' AND
ISNULL(ModerateRiskOfHarmSignificant,''N'') =''N'' AND
ISNULL(ModerateRiskOfHarmNoActiveSuicidal,''N'') =''N'' AND
ISNULL(ModerateRiskOfHarmHistoryOfChronic,''N'') =''N'' AND
ISNULL(ModerateRiskOfHarmBinge,''N'') =''N'' AND
ISNULL(ModerateRiskOfHarmSomeEvidence,''N'') =''N'' AND
ISNULL(SeriousRiskOfHarmCurrentSuicidal,''N'') =''N'' AND
ISNULL(SeriousRiskOfHarmHistoryOfChronic,''N'') =''N'' AND
ISNULL(SeriousRiskOfHarmRecentPattern,''N'') =''N'' AND
ISNULL(SeriousRiskOfHarmClearCompromise,''N'') =''N'' AND
ISNULL(ExtremeRiskOfHarmCurrentSuicidal,''N'') =''N'' AND
ISNULL(ExtremeRiskOfHarmRepeatedEpisodes,''N'') =''N'' AND
ISNULL(ExtremeRiskOfHarmExtremeCompromise,''N'') =''N''
)) OR 
EXISTS (select 1 FROM DocumentLOCUS WHERE DocumentVersionId=@DocumentVersionId and (
ISNULL(MinimalImpairmentNoMore,''N'') = ''N''  AND
ISNULL(MildImpairmentExperiencing,''N'') = ''N''  AND
ISNULL(MildImpairmentRecentExperience,''N'') = ''N''  AND
ISNULL(MildImpairmentDevelopingMinor,''N'') = ''N''  AND
ISNULL(MildImpairmentDemonstrating,''N'') = ''N''  AND
ISNULL(ModerateImpairmentRecentConflict,''N'') = ''N''  AND
ISNULL(ModerateImpairmentAppearance,''N'') = ''N''  AND
ISNULL(ModerateImpairmentSignificantDisturbances,''N'') = ''N''  AND
ISNULL(ModerateImpairmentSignificantDeterioration,''N'') = ''N''  AND
ISNULL(ModerateImpairmentOngoing,''N'') = ''N''  AND
ISNULL(ModerateImpairmentRecentGains,''N'') = ''N''  AND
ISNULL(SeriousImpairmentSeriousDecrease,''N'') = ''N''  AND
ISNULL(SeriousImpairmentSignificantWithdrawal,''N'') = ''N''  AND
ISNULL(SeriousImpairmentConsistentFailure,''N'') = ''N''  AND
ISNULL(SeriousImpairmentSeriousDisturbances,''N'') = ''N''  AND
ISNULL(SeriousImpairmentInability,''N'') =''N''  AND
ISNULL(SevereImpairmentExtremeDeterioration,''N'') =''N''  AND
ISNULL(SevereImpairmentDevelopmentComplete,''N'') =''N''  AND
ISNULL(SevereImpairmentCompleteNeglect,''N'') =''N''  AND
ISNULL(SevereImpairmentExtremeDistruptions,''N'') =''N''  AND
ISNULL(SevereImpairmentCompleteInability,''N'') =''N''  
))
OR EXISTS(select 1 FROM DocumentLOCUS WHERE DocumentVersionId=@DocumentVersionId and (
 ISNULL(NoComorbidityNoEvidence,''N'') =''N''  AND
 ISNULL(NoComorbidityAnyIllnesses,''N'') =''N''  AND
 ISNULL(MinorComorbidityExistence,''N'') =''N''  AND
 ISNULL(MinorComorbidityOccasional,''N'') =''N''  AND
 ISNULL(MinorComorbidityMayOccasionally,''N'') =''N''  AND
 ISNULL(SignificantComorbidityPotential,''N'') =''N''  AND
 ISNULL(SignificantComorbidityCreated,''N'') =''N''  AND
 ISNULL(SignificantComorbidityAdversely,''N'') =''N''  AND
 ISNULL(SignificantComorbidityOngoing,''N'') =''N''  AND
 ISNULL(SignificantComorbidityRecentSubstance,''N'') =''N''  AND
 ISNULL(SignificantComorbiditySignificant,''N'') =''N''  AND
 ISNULL(MajorComorbidityHighLikelihood,''N'') =''N''  AND
 ISNULL(MajorComorbidityExistence,''N'') =''N''  AND
 ISNULL(MajorComorbidityOutcome,''N'') =''N''  AND
 ISNULL(MajorComorbidityUncontrolled,''N'') =''N''  AND
 ISNULL(MajorComorbidityPsychiatric,''N'') =''N''  AND
 ISNULL(SevereComorbiditySignificant,''N'') =''N''  AND
 ISNULL(SevereComorbidityPresence,''N'') =''N''  AND
 ISNULL(SevereComorbidityUncontrolled,''N'') =''N''  AND
 ISNULL(SevereComorbiditySerereSubstance,''N'') =''N''  AND
 ISNULL(SevereComorbidityAcute,''N'') =''N''
))
OR EXISTS(select 1 FROM DocumentLOCUS WHERE DocumentVersionId=@DocumentVersionId and (
 ISNULL(LowStressEssentially,''N'') =''N''  AND
 ISNULL(LowStressNoRecent,''N'') =''N''  AND
 ISNULL(LowStressNoMajor,''N'') =''N''  AND
 ISNULL(LowStressMaterial,''N'') =''N''  AND
 ISNULL(LowStressLiving,''N'') =''N''  AND
 ISNULL(LowStressNoPressure,''N'') =''N''  AND
 ISNULL(MildlyStressPresence,''N'') =''N''  AND
 ISNULL(MildlyStressTransition,''N'') =''N''  AND
 ISNULL(MildlyStressCircumstances,''N'') =''N''  AND
 ISNULL(MildlyStressRecentOnset,''N'') =''N''  AND
 ISNULL(MildlyStressPotential,''N'') =''N''  AND
 ISNULL(MildlyStressPerformance,''N'') =''N''  AND
 ISNULL(ModeratelyStressSignificantDiscord,''N'') =''N''  AND
 ISNULL(ModeratelyStressSignificantTransition,''N'') =''N''  AND
 ISNULL(ModeratelyStressRecentImportant,''N'') =''N''  AND
 ISNULL(ModeratelyStressConcern,''N'') =''N''  AND
 ISNULL(ModeratelyStressDanger,''N'') =''N''  AND
 ISNULL(ModeratelyStressEasyExposure,''N'') =''N''  AND
 ISNULL(ModeratelyStressPerception,''N'') =''N''  AND
 ISNULL(HighlyStressSerious,''N'') =''N''  AND
 ISNULL(HighlyStressSevere,''N'') =''N''  AND
 ISNULL(HighlyStressInability,''N'') =''N''  AND
 ISNULL(HighlyStressRecentOnset,''N'') =''N''  AND
 ISNULL(HighlyStressDifficulty,''N'') =''N''  AND
 ISNULL(HighlyStressEpisodes,''N'') =''N''  AND
 ISNULL(HighlyStressOverwhelming,''N'') =''N''  AND
 ISNULL(ExtremelyStressAcutely,''N'') =''N''  AND
 ISNULL(ExtremelyStressUnavoidable,''N'') =''N''  AND
 ISNULL(ExtremelyStressIncarceration,''N'') =''N''  AND
 ISNULL(ExtremelyStressSevere,''N'') =''N''  AND
 ISNULL(ExtremelyStressSustained,''N'') =''N''  AND
 ISNULL(ExtremelyStressChaotic,''N'') =''N''
))

OR EXISTS(select 1 FROM DocumentLOCUS WHERE DocumentVersionId=@DocumentVersionId and (
 ISNULL(HighlySupportivePlentiful,''N'') =''N''  AND
 ISNULL(HighlySupportiveEffective,''N'') =''N''  AND
 ISNULL(SupportiveResources,''N'') =''N''  AND
 ISNULL(SupportiveSomeElements,''N'') =''N''  AND
 ISNULL(SupportiveProfessional,''N'') =''N''  AND
 ISNULL(LimitedSupportFew,''N'') =''N''  AND
 ISNULL(LimitedSupportUsual,''N'') =''N''  AND
 ISNULL(LimitedSupportPersons,''N'') =''N''  AND
 ISNULL(LimitedSupportResources,''N'') =''N''  AND
 ISNULL(LimitedSupportLimited,''N'') =''N''  AND
 ISNULL(MinimalSupportVeryFew,''N'') =''N''  AND
 ISNULL(MinimalSupportUsual,''N'') =''N''  AND
 ISNULL(MinimalSupportExisting,''N'') =''N''  AND
 ISNULL(MinimalSupportClient,''N'') =''N''  AND
 ISNULL(NoSupportSources,''N'') =''N''
))
OR EXISTS (select 1 FROM DocumentLOCUS WHERE DocumentVersionId=@DocumentVersionId and (
 ISNULL(FullyResponsiveNoPriorExperience,''N'') =''N''  AND
 ISNULL(FullyResponsivePriorExperience,''N'') =''N''  AND
 ISNULL(FullyResponsiveSuccessful,''N'') =''N''  AND
 ISNULL(SignificantResponsePrevious,''N'') =''N''  AND
 ISNULL(SignificantResponseRecovery,''N'') =''N''  AND
 ISNULL(ModerateResponseCurrentTreatment,''N'') =''N''  AND
 ISNULL(ModerateResponsePreviousTreatment,''N'') =''N''  AND
 ISNULL(ModerateResponseUnclear,''N'') =''N''  AND
 ISNULL(ModerateResponseLeastPartial,''N'') =''N''  AND
 ISNULL(PoorResponsePrevious,''N'') =''N''  AND
 ISNULL(NegligibleResponsePast,''N'') =''N''  AND
 ISNULL(PoorResponseAttempts,''N'') =''N''  AND
 ISNULL(NegligibleResponseSymptoms,''N'') =''N'' 
))
OR EXISTS (select 1 FROM DocumentLOCUS WHERE DocumentVersionId=@DocumentVersionId and (
 ISNULL(OptimalEngagementComplete,''N'') =''N''  AND
 ISNULL(OptimalEngagementActively,''N'') =''N''  AND
 ISNULL(OptimalEngagementEnthusiastic,''N'') =''N''  AND
 ISNULL(OptimalEngagementUnderstands,''N'') =''N''  AND
 ISNULL(PositiveEngagementSignificant,''N'') =''N''  AND
 ISNULL(PositiveEngagementWilling,''N'') =''N''  AND
 ISNULL(PositiveEngagementPositive,''N'') =''N''  AND
 ISNULL(PositiveEngagementShows,''N'') =''N''  AND
 ISNULL(LimitedEngagementSomeVariability,''N'') =''N''  AND
 ISNULL(LimitedEngagementLimitedDesire,''N'') =''N''  AND
 ISNULL(LimitedEngagementRelatesToTreatment,''N'') =''N''  AND
 ISNULL(LimitedEngagementNotUseResources,''N'') =''N''  AND
 ISNULL(LimitedEngagementLimitedAbility,''N'') =''N''  AND
 ISNULL(MinimalEngagementRarely,''N'') =''N''  AND
 ISNULL(MinimalEngagementNoDesire,''N'') =''N''  AND
 ISNULL(MinimalEngagementRelatesPoorly,''N'') =''N''  AND
 ISNULL(MinimalEngagementAvoidsContact,''N'') =''N''  AND
 ISNULL(MinimalEngagementNotAccept,''N'') =''N''  AND
 ISNULL(UnengagedNoAwareness,''N'') =''N''  AND
 ISNULL(UnengagedInability,''N'') =''N''  AND
 ISNULL(UnengagedUnable,''N'') =''N''  AND
 ISNULL(UnengagedExtremely,''N'') =''N''  
 )))','At least one response needs to be selected per tab before calculating the summary.',1,'At least one response needs to be selected per tab before calculating the summary.',NULL)


INSERT INTO [documentvalidations] ([Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[SectionName])VALUES
('Y',@DocumentCodeId,NULL,NULL,1,'DocumentLOCUS','ExtremeRiskOfHarmCurrentSuicidal','FROM DocumentLOCUS WHERE DocumentVersionId=@DocumentVersionId  
AND  EXISTS(select 1 FROM DocumentLOCUS WHERE DocumentVersionId=@DocumentVersionId and (
	ISNULL(ExtremeRiskOfHarmCurrentSuicidal,''N'') =''Y'' AND 
	ISNULL(ExtremeRiskOfHarmWithoutExpressed,''N'') =''N'' AND
	ISNULL(ExtremeRiskOfHarmWithHistory,''N'') =''N'' AND
	ISNULL(ExtremeRiskOfHarmPresenceOfCommand,''N'') =''N'' 
  )) ',
'Risk of Harm - Extreme Risk of Harm - At least one sub-checkbox must be selected.',2,
'Risk of Harm - Extreme Risk of Harm - At least one sub-checkbox must be selected.',NULL)

INSERT INTO [documentvalidations] ([Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[SectionName])VALUES
('Y',@DocumentCodeId,NULL,NULL,4,'DocumentLOCUS','ExtremelyStressAcutely','FROM DocumentLOCUS WHERE DocumentVersionId=@DocumentVersionId  
AND EXISTS(select 1 FROM DocumentLOCUS WHERE DocumentVersionId=@DocumentVersionId and (
    ISNULL(ExtremelyStressAcutely,''N'') =''Y'' AND
    ISNULL(ExtremelyStressOngoing,''N'') =''N'' AND
    ISNULL(ExtremelyStressWitnessing,''N'') =''N'' AND
    ISNULL(ExtremelyStressPersecution,''N'') =''N'' AND
    ISNULL(ExtremelyStressSudden,''N'') =''N''
  )) ',
'Recovery Environ- Stress - Extremely Stressful Environment  - At least one sub-checkbox must be selected.',3,
'Recovery Environ- Stress - Extremely Stressful Environment  - At least one sub-checkbox must be selected.',NULL)