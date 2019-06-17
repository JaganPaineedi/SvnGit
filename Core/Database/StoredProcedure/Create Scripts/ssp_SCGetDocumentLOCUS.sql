/****** Object:  StoredProcedure [dbo].[ssp_SCGetDocumentLOCUS]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDocumentLOCUS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetDocumentLOCUS]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetDocumentLOCUS]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************                                   
**  File: ssp_SCGetDocumentLOCUS 1306292 1306288                                            
**  Name: ssp_SCGetLOCUS                        
**  Desc: GetData for Locus Document
**  Called by:                                                 
**  Parameters:                            
**  Auth:  Ponnin Selvan                              
**  Date:  March 10 2016
/* What :  created Locus Document				*/
/* whay : Task #41 Network 180 - Customizations                              */
*******************************************************************************                                                
**  Change History                                          
*******************************************************************************                                          
**  Date:			Author:			Description:                                    
	03 Nov 2016		Alok Kumar		Added three new fields to the DocumentLOCUS table for task#340 CEI - Support Go Live.
	
*******************************************************************************/                                    
CREATE PROCEDURE  [dbo].[ssp_SCGetDocumentLOCUS]                                                                   
(                                                                                                                                                           
  @DocumentVersionId int                                                                           
)                                                                              
As                                                                          
BEGIN                                                            
   BEGIN TRY   
   
   EXEC ssp_CalculateLOCUSDimensionScore @DocumentVersionId                                                          
                                                                                                       
		SELECT DocumentVersionId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedBy
			,DeletedDate
			,MinimalRiskOfHarmNoIndication
			,MinimalRiskOfHarmClearAbility
			,LowRiskOfHarmNoCurrentSuicidal
			,LowRiskOfHarmOccasionalSubstance
			,LowRiskOfHarmPeriodsInPast
			,ModerateRiskOfHarmSignificant
			,ModerateRiskOfHarmNoActiveSuicidal
			,ModerateRiskOfHarmHistoryOfChronic
			,ModerateRiskOfHarmBinge
			,ModerateRiskOfHarmSomeEvidence
			,SeriousRiskOfHarmCurrentSuicidal
			,SeriousRiskOfHarmHistoryOfChronic
			,SeriousRiskOfHarmRecentPattern
			,SeriousRiskOfHarmClearCompromise
			,ExtremeRiskOfHarmCurrentSuicidal
			,ExtremeRiskOfHarmWithoutExpressed
			,ExtremeRiskOfHarmWithHistory
			,ExtremeRiskOfHarmPresenceOfCommand
			,ExtremeRiskOfHarmRepeatedEpisodes
			,ExtremeRiskOfHarmExtremeCompromise
			,MinimalImpairmentNoMore
			,MildImpairmentExperiencing
			,MildImpairmentRecentExperience
			,MildImpairmentDevelopingMinor
			,MildImpairmentDemonstrating
			,ModerateImpairmentRecentConflict
			,ModerateImpairmentAppearance
			,ModerateImpairmentSignificantDisturbances
			,ModerateImpairmentSignificantDeterioration
			,ModerateImpairmentOngoing
			,ModerateImpairmentRecentGains
			,SeriousImpairmentSeriousDecrease
			,SeriousImpairmentSignificantWithdrawal
			,SeriousImpairmentConsistentFailure
			,SeriousImpairmentSeriousDisturbances
			,SeriousImpairmentInability
			,SevereImpairmentExtremeDeterioration
			,SevereImpairmentDevelopmentComplete
			,SevereImpairmentCompleteNeglect
			,SevereImpairmentExtremeDistruptions
			,SevereImpairmentCompleteInability
			,NoComorbidityNoEvidence
			,NoComorbidityAnyIllnesses
			,MinorComorbidityExistence
			,MinorComorbidityOccasional
			,MinorComorbidityMayOccasionally
			,SignificantComorbidityPotential
			,SignificantComorbidityCreated
			,SignificantComorbidityAdversely
			,SignificantComorbidityOngoing
			,SignificantComorbidityRecentSubstance
			,SignificantComorbiditySignificant
			,MajorComorbidityHighLikelihood
			,MajorComorbidityExistence
			,MajorComorbidityOutcome
			,MajorComorbidityUncontrolled
			,MajorComorbidityPsychiatric
			,SevereComorbiditySignificant
			,SevereComorbidityPresence
			,SevereComorbidityUncontrolled
			,SevereComorbiditySerereSubstance
			,SevereComorbidityAcute
			,LowStressEssentially
			,LowStressNoRecent
			,LowStressNoMajor
			,LowStressMaterial
			,LowStressLiving
			,LowStressNoPressure
			,MildlyStressPresence
			,MildlyStressTransition
			,MildlyStressCircumstances
			,MildlyStressRecentOnset
			,MildlyStressPotential
			,MildlyStressPerformance
			,ModeratelyStressSignificantDiscord
			,ModeratelyStressSignificantTransition
			,ModeratelyStressRecentImportant
			,ModeratelyStressConcern
			,ModeratelyStressDanger
			,ModeratelyStressEasyExposure
			,ModeratelyStressPerception
			,HighlyStressSerious
			,HighlyStressSevere
			,HighlyStressInability
			,HighlyStressRecentOnset
			,HighlyStressDifficulty
			,HighlyStressEpisodes
			,HighlyStressOverwhelming
			,ExtremelyStressAcutely
			,ExtremelyStressOngoing
			,ExtremelyStressWitnessing
			,ExtremelyStressPersecution
			,ExtremelyStressSudden
			,ExtremelyStressUnavoidable
			,ExtremelyStressIncarceration
			,ExtremelyStressSevere
			,ExtremelyStressSustained
			,ExtremelyStressChaotic
			,HighlySupportivePlentiful
			,HighlySupportiveEffective
			,SupportiveResources
			,SupportiveSomeElements
			,SupportiveProfessional
			,LimitedSupportFew
			,LimitedSupportUsual
			,LimitedSupportPersons
			,LimitedSupportResources
			,LimitedSupportLimited
			,MinimalSupportVeryFew
			,MinimalSupportUsual
			,MinimalSupportExisting
			,MinimalSupportClient
			,NoSupportSources
			,FullyResponsiveNoPriorExperience
			,FullyResponsivePriorExperience
			,FullyResponsiveSuccessful
			,SignificantResponsePrevious
			,SignificantResponseRecovery
			,ModerateResponseCurrentTreatment
			,ModerateResponsePreviousTreatment
			,ModerateResponseUnclear
			,ModerateResponseLeastPartial
			,PoorResponsePrevious
			,PoorResponseAttempts
			,NegligibleResponsePast
			,NegligibleResponseSymptoms
			,OptimalEngagementComplete
			,OptimalEngagementActively
			,OptimalEngagementEnthusiastic
			,OptimalEngagementUnderstands
			,PositiveEngagementSignificant
			,PositiveEngagementWilling
			,PositiveEngagementPositive
			,PositiveEngagementShows
			,LimitedEngagementSomeVariability
			,LimitedEngagementLimitedDesire
			,LimitedEngagementRelatesToTreatment
			,LimitedEngagementNotUseResources
			,LimitedEngagementLimitedAbility
			,MinimalEngagementRarely
			,MinimalEngagementNoDesire
			,MinimalEngagementRelatesPoorly
			,MinimalEngagementAvoidsContact
			,MinimalEngagementNotAccept
			,UnengagedNoAwareness
			,UnengagedInability
			,UnengagedUnable
			,UnengagedExtremely
			,CAST(LocusScore AS INTEGER) as LocusScore
			,(SELECT CodeName from dbo.GlobalCodes WHERE Category='LOCUSLEVEL' AND IsNull(RecordDeleted,'N')<>'Y' AND Active='Y' AND ExternalCode1= LocusScore) AS LocusScoreText
			,CAST(RiskOfHarmScore AS INTEGER) as RiskOfHarmScore
			,CAST(FunctionalStatusScore AS INTEGER) as FunctionalStatusScore
			,CAST(MedicalAddictiveScore AS INTEGER) as MedicalAddictiveScore
			,CAST(RecoveryEnvironmentStressScore AS INTEGER) as RecoveryEnvironmentStressScore
			,CAST(RecoveryEnvironmentSupportScore AS INTEGER) as RecoveryEnvironmentSupportScore
			,CAST(TreatmentRecoveryScore AS INTEGER) as TreatmentRecoveryScore
			,CAST(EngagementScore AS INTEGER) as EngagementScore
			,EvaluationNotes
			--,@CurrentLevelOfCare As CurrentLevelOfCare
			,CurrentLevelOfCare
			,CASE 
				When CAST(LocusScore AS INTEGER)=0 Then 'Basic Services for Prevention and Maintenance'
				When CAST(LocusScore AS INTEGER)=1 Then 'Level One – Recovery Maintenance and Health Management'
				When CAST(LocusScore AS INTEGER) =2 Then 'Level Two – Low Intensity Community Based Services'
				When CAST(LocusScore AS INTEGER) =3 Then 'Level Three – High Intensity Community Based Services'
				When CAST(LocusScore AS INTEGER) =4 Then 'Level Four – Medically Monitored Non-Residential Services'
				When CAST(LocusScore AS INTEGER) =5 Then 'Level Five – Medically Monitored Residential Services'
				When CAST(LocusScore AS INTEGER) =6 Then 'Level Six – Medically Managed Residential Services'
				Else ''
			End	As	RecommendedDisposition
			,ActualDisposition
			,ReasonForVariance
			,ProgramReferredTo
		FROM DocumentLOCUS
		WHERE (ISNULL(RecordDeleted, 'N') = 'N')
			AND (DocumentVersionId = @DocumentVersionId)                                  
                                        
    
	
 END TRY                                        
                                                           
 BEGIN CATCH                                                            
   DECLARE @Error varchar(8000)                                                                                               
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                              
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_SCGetDocumentLOCUS]')                                                                                               
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                              
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                            
 END CATCH                                          
End 

GO


