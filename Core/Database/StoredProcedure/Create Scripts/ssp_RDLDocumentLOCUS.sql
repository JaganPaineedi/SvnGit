IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLDocumentLOCUS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLDocumentLOCUS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLDocumentLOCUS] (@DocumentVersionId INT)
AS
/***********************************************************************************/
/* Stored Procedure: [ssp_RDLDocumentLOCUS] 1306292 1306288       */
/* Creation Date:  MAR 18 ,2016                                                    */
/* Purpose: RDL Data from DocumentLocus	   */
/* Input Parameters: @DocumentVersionId                                            */
/* Purpose: Use For Rdl Report                                                     */
/* Author: Shivanand		*/
/* What : created Report for DocumentLocus					*/
/* whay : Task #41 Network 180 - Customizations                              */
/* Modified by Aravind  24-08-2016
 What : Added Logic to get the Total Score - Why   LOCUS - Add Total Score Task #382- Network 180 Environment Issues Tracking*/
/*What : Modified the Logic to get the Total Score Except the LocusResult - Why   LOCUS - Add Total Score Task #382- Network 180 Environment Issues Tracking*/
/*What : Added three new fields to the DocumentLOCUS table		Why : for task#340 CEI - Support Go Live. */
/*******************************************************************************************************************************/

BEGIN
	BEGIN TRY
	
	
	DECLARE @OrganizationName varchar(250)
	Declare @TotalScore INT  
    SELECT TOP 1 @OrganizationName = OrganizationName from SystemConfigurations 
    SELECT @TotalScore = RiskOfHarmScore+FunctionalStatusScore+MedicalAddictiveScore+RecoveryEnvironmentStressScore+RecoveryEnvironmentSupportScore+TreatmentRecoveryScore+EngagementScore
	FROM DocumentLOCUS  
	WHERE  DocumentVersionId=@DocumentVersionId
   
   SELECT 
    @OrganizationName AS OrganizationName
    ,D.ClientId 
	,ISNULL(C.LastName, '') + ' ' + ISNULL(C.FirstName, '') AS ClientName
	,CONVERT(VARCHAR(10), D.EffectiveDate, 101)  AS EffectiveDate	
	,CONVERT(VARCHAR(30), D.EffectiveDate, 108)  AS EffectiveTime			
	,CONVERT(VARCHAR(10), C.DOB, 101) AS DOB	
	,C.Sex 	AS Gender
	,DC.DocumentName	
	,DocumentVersionId	
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
	,LocusScore
	,(SELECT CodeName from dbo.GlobalCodes WHERE Category='LOCUSLEVEL' AND IsNull(RecordDeleted,'N')<>'Y' AND Active='Y' AND ExternalCode1= LocusScore) AS LocusScoreText
	,CAST(RiskOfHarmScore AS INTEGER) as RiskOfHarmScore
	,CAST(FunctionalStatusScore AS INTEGER) as FunctionalStatusScore
	,CAST(MedicalAddictiveScore AS INTEGER) as MedicalAddictiveScore
	,CAST(RecoveryEnvironmentStressScore AS INTEGER) as RecoveryEnvironmentStressScore
	,CAST(RecoveryEnvironmentSupportScore AS INTEGER) as RecoveryEnvironmentSupportScore
	,CAST(TreatmentRecoveryScore AS INTEGER) as TreatmentRecoveryScore
	,CAST(EngagementScore AS INTEGER) as EngagementScore
	,EvaluationNotes
	,CAST(@TotalScore AS INTEGER) as TotalScore 	
	,DL.CurrentLevelOfCare
	,CASE
		WHEN CAST(LocusScore AS INTEGER)=0 Then 'Basic Services for Prevention and Maintenance' 
		When CAST(LocusScore AS INTEGER)=1 Then 'Level One – Recovery Maintenance and Health Management'
		When CAST(LocusScore AS INTEGER) =2 Then 'Level Two – Low Intensity Community Based Services'
		When CAST(LocusScore AS INTEGER) =3 Then 'Level Three – High Intensity Community Based Services'
		When CAST(LocusScore AS INTEGER) =4 Then 'Level Four – Medically Monitored Non-Residential Services'
		When CAST(LocusScore AS INTEGER) =5 Then 'Level Five – Medically Monitored Residential Services'
		When CAST(LocusScore AS INTEGER) =6 Then 'Level Six – Medically Managed Residential Services'
		Else ''
	End	As	RecommendedDisposition
	,(SELECT Top 1 CodeName from dbo.GlobalCodes WHERE Category='LOCUSLevelofCare' AND IsNull(RecordDeleted,'N')<>'Y' AND Active='Y' AND GlobalCodeId= DL.ActualDisposition) AS ActualDisposition
	,(SELECT Top 1 CodeName from dbo.GlobalCodes WHERE Category='LOCUSReasonVariance' AND IsNull(RecordDeleted,'N')<>'Y' AND Active='Y' AND GlobalCodeId= DL.ReasonForVariance) AS ReasonForVariance
	,(SELECT Top 1 CodeName from dbo.GlobalCodes WHERE Category='LOCUSProgram' AND IsNull(RecordDeleted,'N')<>'Y' AND Active='Y' AND GlobalCodeId= DL.ProgramReferredTo) AS ProgramReferredTo	
	FROM DocumentLOCUS DL
    INNER JOIN Documents D ON D.InProgressDocumentVersionId=DL.DocumentVersionId 
    INNER JOIN Clients C ON C.ClientId=D.ClientId
    INNER JOIN DOcumentCodes DC ON DC.DocumentCodeId=D.DocumentCodeId      
	WHERE  DL.DocumentVersionId=@DocumentVersionId 
		AND ISNULL(DL.RecordDeleted, 'N') = 'N'
		AND ISNULL(D.RecordDeleted, 'N') = 'N'
		AND ISNULL(C.RecordDeleted, 'N') = 'N'   
		AND ISNULL(DC.RecordDeleted, 'N') = 'N'     
		
		
  END TRY  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLDocumentLOCUS') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
END    