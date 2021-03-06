/****** Object:  StoredProcedure [dbo].[csp_RDLCustomAssessmentHRM]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomAssessmentHRM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomAssessmentHRM]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomAssessmentHRM]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create   PROCEDURE   [dbo].[csp_RDLCustomAssessmentHRM]        
(
@DocumentVersionId int          
)                
AS                
          
Begin          
/************************************************************************/                                                
/* Stored Procedure: [csp_RDLCustomHRMAssessment]						*/                                                                             
/* Copyright: 2008 Streamline SmartCare									*/                                                                                      
/* Creation Date:  July 10, 2008										*/                                                
/*																		*/                                                
/* Purpose: Gets Data from CustomAssessment,SystemConfigurations,		*/
/*			Staff,Documents,Clients,GlobalCodes,Pharmacy				*/                                               
/*																		*/                                              
/* Input Parameters: DocumentID,Version									*/                                              
/* Output Parameters:													*/                                                
/* Purpose: Use For Rdl Report											*/                                      
/* Calls:																*/                                                
/* Author: Rupali Patil													*/                                                
/************************************************************************/                  

SELECT	(Select OrganizationName from SystemConfigurations) as OrganizationName
		,''Italic'' as QuestionFontStyle
		,''500'' as QuestionFontWeight
		,d.ClientId
		,Clients.LastName + '', '' + Clients.FirstName as ClientName
		,Staff2.LastName + '', '' + Staff2.FirstName as ClinicianName
		,d.EffectiveDate
		,CHA.[CurrentAssessmentDate]
		,CHA.[PreviousAssessmentDate]
		,Case CHA.[AssessmentType] 
			When ''I'' then ''Initial'' 
			When ''A'' then ''Annual'' 
			When ''U'' then ''Update''
			When ''S'' then ''Screen''
		 End as [AssessmentType]
		,Case CHA.[AdultOrChild]
			When ''A'' then ''Adult''
			When ''C'' then ''Child''
			Else ''''
		 End as AdultOrChild
		,CHA.[ClientDOB]
		,CHA.[ChildHasNoParentalConsent]
		,CHA.[ClientHasGuardian]
		,CHA.[GuardianName]
		,CHA.[GuardianAddress]
		,CHA.[GuardianPhone]
		,dbo.csf_GetGlobalCodeNameById(CHA.GuardianType) as GuardianType
		,CHA.[ClientInDDPopulation]
		,CHA.[ClientInSAPopulation]
		,CHA.[ClientINMHPopulation]
		,CHA.[PreviousDiagnosisText]
		,dbo.csf_GetGlobalCodeNameById(CHA.ReferralType) as ReferralType
		,dbo.csf_GetGlobalCodeNameById(CHA.CurrentLivingArrangement) as CurrentLivingArrangement
		,CHA.CurrentPrimaryCarePhysician
		,CHA.[PresentingProblem]
		,CHA.ReasonForUpdate
		,CHA.DesiredOutcomes
--------- CAFAS
		,CHA.[CAFASDate]
		,Staff1.FirstName + '' '' + Staff1.LastName as RaterClinician
		,dbo.csf_GetGlobalCodeNameById(CHA.CAFASInterval) as CAFASInterval
		,CHA.[SchoolPerformance]
		,CHA.[SchoolPerformanceComment]
		,CHA.[HomePerformance]
		,CHA.[HomePerfomanceComment]
		,CHA.[CommunityPerformance]
		,CHA.[CommunityPerformanceComment]
		,CHA.[BehaviorTowardsOther]
		,CHA.[BehaviorTowardsOtherComment]
		,CHA.[MoodsEmotion]
		,CHA.[MoodsEmotionComment]
		,CHA.[SelfHarmfulBehavior]
		,CHA.[SelfHarmfulBehaviorComment]
		,CHA.[SubstanceUse]
		,CHA.[SubstanceUseComment]
		,CHA.[Thinkng]
		,CHA.[ThinkngComment]
--		,SubScaleScore1
		,CHA.[PrimaryFamilyMaterialNeeds]
		,CHA.[PrimaryFamilyMaterialNeedsComment]
		,CHA.[SurrogateMaterialNeeds]
		,CHA.[SurrogateMaterialNeedsComment]
		,CHA.[PrimaryFamilySocialSupport]
		,CHA.[PrimaryFamilySocialSupportComment]
		,CHA.[NonCustodialMaterialNeeds]
		,CHA.[NonCustodialMaterialNeedsComment]
		,CHA.[SurrogateSocialSupport]
		,CHA.[SurrogateSocialSupportComment]
		,CHA.[NonCustodialSocialSupport]
		,CHA.[NonCustodialSocialSupportComment]
--		,SubScaleScore2
		
----------- Developmental Disabilities Eligibility Criteria
		,DDEPreviouslyMet
		,DDAttributableMentalPhysicalLimitation
		,DDDxAxisI
		,DDDxAxisII
		,DDDxAxisIII
		,DDDxAxisIV
		,DDDxAxisV
		,DDDxSource
		,DDManifestBeforeAge22
		,DDContinueIndefinitely
		,DDLimitSelfCare
		,DDLimitLanguage
		,DDLimitLearning
		,DDLimitMobility
		,DDLimitSelfDirection
		,DDLimitEconomic
		,DDLimitIndependentLiving
		,DDNeedMulitpleSupports

---------------UNCOPE
		,UncopeApplicable
		,UncopeApplicableReason
		,UncopeQuestionU
		,UncopeQuestionN
		,UncopeQuestionC
		,UncopeQuestionO
		,UncopeQuestionP
		,UncopeQuestionE
		,SubstanceUseNeedsList

----------- Psychosocial Adult
		,PsCurrentHealthIssues
		,PsCurrentHealthIssuesComment
		,PsCurrentHealthIssuesNeedsList
		
		,PsClientAbuseIssues
		,PsClientAbuesIssuesComment
		,PsClientAbuseIssuesNeedsList

		,PsLegalIssues
		,PsLegalIssuesComment
		,PsLegalIssuesNeedsList

		,PsCulturalEthnicIssues
		,PsCulturalEthnicIssuesComment
		,PsCulturalEthnicIssuesNeedsList

		,PsSpiritualityIssues
		,PsSpiritualityIssuesComment
		,PsSpiritualityIssuesNeedsList

		,HistMentalHealthTx
		,HistMentalHealthTxComment

		,HistFamilyMentalHealthTx
		,HistFamilyMentalHealthTxComment

		,HistPreviousDx
		,HistPreviousDxComment

		,PsTraumaticIncident
		,PsTraumaticIncidentComment
		,PsTraumaticIncidentNeedsList

--------- Psychosocial Child
--		,PsPhysicalIssues
--		,PsPhysicalIssuesComment
--		,PsPhysicalIssuesNeedsList

		,PsDevelopmentalMilestones
		,PsDevelopmentalMilestonesComment
		,PsDevelopmentalMilestonesNeedsList

		,PsPrenatalExposure
		,PsPrenatalExposureComment
		,PsPrenatalExposureNeedsList

		,PsChildMentalHealthHistory
		,PsChildMentalHealthHistoryComment
		,PsChildMentalHealthHistoryNeedsList

		,PsChildEnvironmentalFactors
		,PsChildEnvironmentalFactorsComment
		,PsChildEnvironmentalFactorsNeedsList

		,PsImmunizations
		,PsImmunizationsComment
		,PsImmunizationsNeedsList

		,PsLanguageFunctioning
		,PsLanguageFunctioningComment
		,PsLanguageFunctioningNeedsList

		,PsVisualFunctioning
		,PsVisualFunctioningComment
		,PsVisualFunctioningNeedsList

		,PsIntellectualFunctioning
		,PsIntellectualFunctioningComment
		,PsIntellectualFunctioningNeedsList

		,PsLearningAbility
		,PsLearningAbilityComment
		,PsLearningAbilityNeedsList

		,PsPeerInteraction
		,PsPeerInteractionComment
		,PsPeerInteractionNeedsList

		,PsChildHousingIssues
		,PsChildHousingIssuesComment
		,PsChildHousingIssuesNeedsList

--		,PsClientAbuseIssues
--		,PsClientAbuesIssuesComment
--		,PsClientAbuseIssuesNeedsList

		,PsSexuality
		,PsSexualityComment
		,PsSexualityNeedsList

		,PsFamilyFunctioning
		,PsFamilyFunctioningComment
		,PsFamilyFunctioningNeedsList

--		,PsLegalIssues
--		,PsLegalIssuesComment
--		,PsLegalIssuesNeedsList

--		,PsCulturalEthnicIssues
--		,PsCulturalEthnicIssuesComment
--		,PsCulturalEthnicIssuesNeedsList

--		,PsSpiritualityIssues
--		,PsSpiritualityIssuesComment
--		,PsSpiritualityIssuesNeedsList

		,PsParentalParticipation
		,PsParentalParticipationComment
		,PsParentalParticipationNeedsList

--		,PsTraumaticIncident
--		,PsTraumaticIncidentComment
--		,PsTraumaticIncidentNeedsList

		,PsSchoolHistory
		,PsSchoolHistoryComment
		,PsSchoolHistoryNeedsList

-------- Psychosocial DD
--		,PsClientAbuseIssues
--		,PsClientAbuesIssuesComment
--		,PsClientAbuseIssuesNeedsList

--		,PsLegalIssues
--		,PsLegalIssuesComment
--		,PsLegalIssuesNeedsList

--		,PsCulturalEthnicIssues
--		,PsCulturalEthnicIssuesComment
--		,PsCulturalEthnicIssuesNeedsList

--		,PsSpiritualityIssues
--		,PsSpiritualityIssuesComment
--		,PsSpiritualityIssuesNeedsList

		-- history
--		,HistMentalHealthTx
--		,HistMentalHealthTxComment
--		
--		,HistFamilyMentalHealthTx
--		,HistFamilyMentalHealthTxComment

		,HistDevelopmental
		,HistDevelopmentalComment

		,HistResidential
		,HistResidentialComment

		,HistOccupational
		,HistOccupationalComment

		,HistLegalFinancial
		,HistLegalFinancialComment

------- 
		,PsGrossFineMotor
		,PsGrossFineMotorComment
		,PsGrossFineMotorNeedsList

		,PsSensoryPerceptual
		,PsSensoryPerceptualComment
		,PsSensoryPerceptualNeedsList

		,PsCognitiveFunction
		,PsCognitiveFunctionComment
		,PsCognitiveFunctionNeedsList

		,PsCommunicativeFunction
		,PsCommunicativeFunctionComment
		,PsCommunicativeFunctionNeedsList

		,PsCurrentPsychoSocialFunctiion
		,PsCurrentPsychoSocialFunctiionComment
		,PsCurrentPsychoSocialFunctiionNeedsList

		,PsAdaptiveEquipment
		,PsAdaptiveEquipmentComment
		,PsAdaptiveEquipmentNeedsList

		,PsSafetyMobilityHome
		,PsSafetyMobilityHomeComment
		,PsSafetyMobilityHomeNeedsList
		,LTRIM(RTRIM(PsHealthSafetyChecklistComplete)) AS PsHealthSafetyChecklistComplete
		,PsAccessibilityIssues
		,PsAccessibilityIssuesComment
		,PsAccessibilityIssuesNeedsList

		,PsEvacuationTraining
		,PsEvacuationTrainingComment
		,PsEvacuationTrainingNeedsList

		,Ps24HourSetting
		,Ps24HourSettingComment
		,Ps24HourSettingNeedsList


		,RTRIM(LTRIM(Ps24HourNeedsAwakeSupervision)) AS Ps24HourNeedsAwakeSupervision

		,PsSpecialEdEligibility
		,PsSpecialEdEligibilityComment
		,PsSpecialEdEligibilityNeedsList
		
		,PsSpecialEdEnrolled
		,PsSpecialEdEnrolledComment
		,PsSpecialEdEnrolledNeedsList

		,PsEmployer
		,PsEmployerComment
		,PsEmployerNeedsList

		,PsEmploymentIssues
		,PsEmploymentIssuesComment
		,PsEmploymentIssuesNeedsList


		,PsRestrictionsOccupational
		,PsRestrictionsOccupationalComment
		,PsRestrictionsOccupationalNeedsList
		
		,PsFunctionalAssessmentNeeded
		,PsPlanDevelopmentNeeded
		,PsAdvocacyNeeded
		,PsLinkingNeeded

		,PsDDInformationProvidedBy


		,PsMedicationsComment,                                
		PsEducationComment,
		PsEducation,
		PsEducationNeedsList,
		PsMedications,
		PsMedicationsNeedsList

		,ClientStrengthsNarrative
		,CHA.NaturalSupportSufficiency
		,NaturalSupportNeedsList
		,CHA.CommunityActivitiesCurrentDesired
		,CHA.CrisisPlanningClientHasPlan
		,CHA.CrisisPlanningDesired
		,CHA.CrisisPlanningMoreInfo
		,CHA.CrisisPlanningNarrative
		,CHA.CrisisPlanningNeedsList

		,CHA.AdvanceDirectiveClientHasDirective
		,CHA.AdvanceDirectiveDesired
		,CHA.AdvanceDirectiveMoreInfo
		,CHA.AdvanceDirectiveNarrative
		,CHA.AdvanceDirectiveNeedsList

		,CHA.SuicideActive
		,CHA.SuicideBehaviorsPastHistory
		,CHA.SuicideIdeation
		,CHA.SuicideMeans
		,CHA.SuicideNeedsList
		,CHA.SuicideNotPresent
		,CHA.SuicideOtherRiskSelf
		,CHA.SuicideOtherRiskSelfComment
		,CHA.SuicidePassive
		,CHA.SuicidePlan
		,CHA.SuicidePriorAttempt

		,CHA.HomicideActive
		,CHA.HomicideBehaviorsPastHistory
		,CHA.HomicideIdeation
		,CHA.HomicideMeans
		,CHA.HomicideNeedsList
		,CHA.HomicideNotPresent
		,CHA.HomicdeOtherRiskOthers
		,CHA.HomicideOtherRiskOthersComment
		,CHA.HomicidePassive
		,CHA.HomicidePlan
		,CHA.HomicidePriorAttempt

		,CHA.PhysicalAgressionNotPresent
		,CHA.PhysicalAgressionSelf
		,CHA.PhysicalAgressionOthers
		,CHA.PhysicalAgressionCurrentIssue
		,CHA.PhysicalAgressionNeedsList
		,CHA.PhysicalAgressionBehaviorsPastHistory
		,CHA.RiskAccessToWeapons
		,CHA.RiskAppropriateForAdditionalScreening
		,CHA.RiskClinicalIntervention
		,CHA.RiskOtherFactors

		-- Summary
		,CHA.ClinicalSummary
		,CHA.DischargeCriteria

		-- Pre-plan
		,CHA.Participants
		,CHA.TimeLocation
		,CHA.IssuesToAvoid
		,CHA.IssuesToDiscuss
		,CHA.PrePlanIndependentFacilitatorDiscussed
		,CHA.PrePlanIndependentFacilitatorDesired
		,CHA.Facilitator
		,CHA.CommunicationAccomodations
		,CHA.SelfDeterminationDesired
		,CHA.FiscalIntermediaryDesired
		,CHA.PrePlanFiscalIntermediaryComment
		,CHA.PrePlanGuardianContacted
		,CHA.SourceOfPrePlanningInfo
		,CHA.PamphletGiven
		,CHA.PamphletDiscussed

		,CHA.AssessmentAddtionalInformation
		,CHA.ClientIsAppropriateForTreatment
		,CHA.SecondOpinionNoticeProvided
		,CHA.TreatmentNarrative

		,CHA.OutsideReferralsGiven
		,CHA.ReferralsNarrative

		,CHA.AssessmentsNeeded
		,CHA.TreatmentAccomodation
		,dbo.GetAge(Clients.DOB, cha.[CurrentAssessmentDate]) as ClientAge
		,StaffAxisV
		,StaffAxisVReason
		
		
From Documents d
join documentVersions dv on dv.DocumentId = d.DocumentId and isnull(d.RecordDeleted,''N'')<>''Y''
Join CustomHRMAssessments as CHA on cha.DocumentVersionId = dv.DocumentVersionId
Join Clients on Clients.ClientId = d.ClientId
--Join Clients on Clients.ClientId = Documents.ClientId
Left Join Staff Staff1 on Staff1.StaffId = CHA.RaterClinician
Left Join Staff as Staff2 on Staff2.StaffId = d.AuthorId

cross Join CustomConfigurations cc
Where dv.DocumentVersionId = @DocumentVersionId

--Checking For Errors                                                
If (@@error!=0)                                                
	Begin                                                
		RAISERROR  20006   ''[csp_RDLCustomAssessmentsHRM] : An Error Occured''                                                 
		Return                                                
	End   
End
' 
END
GO
