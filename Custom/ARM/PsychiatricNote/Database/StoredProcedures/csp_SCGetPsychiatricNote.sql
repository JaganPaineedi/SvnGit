/****** Object:  StoredProcedure [dbo].[csp_SCGetPsychiatricNote]    Script Date: 07/10/2015 11:39:47 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetPsychiatricNote]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_SCGetPsychiatricNote] --1252
GO

/****** Object:  StoredProcedure [dbo].[csp_SCGetPsychiatricNote] 737260   Script Date: 07/10/2015 11:39:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_SCGetPsychiatricNote] @DocumentVersionId INT
AS
/*********************************************************************/
/* Stored Procedure: [csp_SCGetPsychiatricNote] 737275   */
/*       Date              Author                  Purpose                   */
/*      13-11-2015        Lakshmi Kanth            To Retrieve Data           */
/*      08/24/2016         Pabitra                 Task CSGL #77   Added missing columns -ThoughtProcessComment,MentalStatusAdditionalComment  */
/*      04/07/2017         Pabitra                 Texas Customizations#58 Added code for color check boxes*/
/*      06 June  2017  Pabitra                 What: Modefied the Csp to show Previous Records 
                 								Why :Texas-Customizations #58 */
/*      06/07/2017          Pabitra             TxAce Customizations #22 */	 
/*      07/25/2017          Pabitra             TxAce Customizations #107 */
--     11/17/2017          Mrunali              What:Added table  CustomPsychiatricNoteMedicationHistory
--                                              Why:Thresholds - Support #1072                             
	                 										                										
/*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @ClientId INT
		
		SELECT @ClientId = ClientId
		FROM Documents
		WHERE InProgressDocumentVersionId = @DocumentVersionId
			AND IsNull(RecordDeleted, 'N') = 'N'

		DECLARE @PrimaryEpisodeWorkerID INT
		DECLARE @PrimaryEpisodeWorker VARCHAR(250)
		DECLARE @PrimaryEpisodeWorkerAge INT
		DECLARE @AgeOut VARCHAR(10)
		DECLARE @index INT
		DECLARE @LatestDocumentVersionID INT
		DECLARE @GENDER VARCHAR(50)
		DECLARE @clientAge varchar(10)
		
		SELECT @GENDER = isnull(Sex, '')
		FROM Clients
		WHERE ClientId = @ClientID
		
	    SET	@clientAge=(SELECT dbo.[GetAge](C.DOB, GETDATE()) FROM ClientS C WHERE C.ClientId=@ClientID)

		SET @LatestDocumentVersionID = (
				SELECT TOP 1 CurrentDocumentVersionId
				FROM CustomDocumentPsychiatricNoteGenerals CDNA
				INNER JOIN Documents Doc ON CDNA.DocumentVersionId = Doc.CurrentDocumentVersionId
				WHERE Doc.ClientId = @ClientID
					AND Doc.[Status] = 22
					AND ISNULL(CDNA.RecordDeleted, 'N') = 'N'
					AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
					AND Doc.DocumentCodeId = 60000
				ORDER BY Doc.EffectiveDate DESC
					,Doc.ModifiedDate DESC
				)
			
		SET @LatestDocumentVersionId = ISNULL(@LatestDocumentVersionId, - 1)
		
		
		DECLARE @PreviousGeneralPoorlyAddresses CHAR(1)
		DECLARE @PreviousGeneralPoorlyGroomed CHAR(1)
		DECLARE @PreviousGeneralDisheveled CHAR(1)
		DECLARE @PreviousGeneralOdferous CHAR(1)
		DECLARE @PreviousGeneralDeformities CHAR(1)
		DECLARE @PreviousGeneralPoorNutrion CHAR(1)
		DECLARE @PreviousGeneralRestless CHAR(1)
		DECLARE @PreviousGeneralPsychometer CHAR(1)
		DECLARE @PreviousGeneralHyperActive CHAR(1)
		DECLARE @PreviousGeneralEvasive CHAR(1)
		DECLARE @PreviousGeneralInAttentive CHAR(1)
		DECLARE @PreviousGeneralPoorEyeContact CHAR(1)
		DECLARE @PreviousGeneralHostile CHAR(1)
		DECLARE @PreviousSpeechIncreased CHAR(1)
		DECLARE @PreviousSpeechDecreased CHAR(1)
		DECLARE @PreviousSpeechPaucity CHAR(1)
		DECLARE @PreviousSpeechHyperverbal CHAR(1)
		DECLARE @PreviousSpeechPoorArticulations CHAR(1)
		DECLARE @PreviousSpeechLoud CHAR(1)
		DECLARE @PreviousSpeechSoft CHAR(1)
		DECLARE @PreviousSpeechMute CHAR(1)
		DECLARE @PreviousSpeechStuttering CHAR(1)
		DECLARE @PreviousSpeechImpaired CHAR(1)
		DECLARE @PreviousSpeechPressured CHAR(1)
		DECLARE @PreviousSpeechFlight CHAR(1)
		DECLARE @PreviousLanguageDifficultyNaming CHAR(1)
		DECLARE @PreviousLanguageDifficultyRepeating CHAR(1)
		DECLARE @PreviousMoodHappy CHAR(1)
		DECLARE @PreviousMoodSad CHAR(1)
		DECLARE @PreviousMoodAnxious CHAR(1)
		DECLARE @PreviousMoodAngry CHAR(1)
		DECLARE @PreviousMoodIrritable CHAR(1)
		DECLARE @PreviousMoodElation CHAR(1)
		DECLARE @PreviousMoodNormal CHAR(1)
		DECLARE @PreviousAffectEuthymic CHAR(1)
		DECLARE @PreviousAffectDysphoric CHAR(1)
		DECLARE @PreviousAffectAnxious CHAR(1)
		DECLARE @PreviousAffectIrritable CHAR(1)
		DECLARE @PreviousAffectBlunted CHAR(1)
		DECLARE @PreviousAffectLabile CHAR(1)
		DECLARE @PreviousAffectEuphoric CHAR(1)
		DECLARE @PreviousAffectCongruent CHAR(1)
		DECLARE @PreviousAttensionPoorConcentration CHAR(1)
		DECLARE @PreviousAttensionPoorAttension CHAR(1)
		DECLARE @PreviousAttensionDistractible CHAR(1)
		DECLARE @PreviousTPDisOrganised CHAR(1)
		DECLARE @PreviousTPBlocking CHAR(1)
		DECLARE @PreviousTPPersecution CHAR(1)
		DECLARE @PreviousTPBroadCasting CHAR(1)
		DECLARE @PreviousTPDetrailed CHAR(1)
		DECLARE @PreviousTPThoughtinsertion CHAR(1)
		DECLARE @PreviousTPIncoherent CHAR(1)
		DECLARE @PreviousTPRacing CHAR(1)
		DECLARE @PreviousTPIllogical CHAR(1)
		DECLARE @PreviousTCDelusional CHAR(1)
		DECLARE @PreviousTCParanoid CHAR(1)
		DECLARE @PreviousTCIdeas CHAR(1)
		DECLARE @PreviousTCThoughtInsertion CHAR(1)
		DECLARE @PreviousTCThoughtWithdrawal CHAR(1)
		DECLARE @PreviousTCThoughtBroadcasting CHAR(1)
		DECLARE @PreviousTCReligiosity CHAR(1)
		DECLARE @PreviousTCGrandiosity CHAR(1)
		DECLARE @PreviousTCPerserveration CHAR(1)
		DECLARE @PreviousTCObsessions CHAR(1)
		DECLARE @PreviousTCWorthlessness CHAR(1)
		DECLARE @PreviousTCLoneliness CHAR(1)
		DECLARE @PreviousTCGuilt CHAR(1)
		DECLARE @PreviousTCHopelessness CHAR(1)
		DECLARE @PreviousTCHelplessness CHAR(1)
		DECLARE @PreviousCAPoorKnowledget CHAR(1)
		DECLARE @PreviousCAConcrete CHAR(1)
		DECLARE @PreviousCAUnable CHAR(1)
		DECLARE @PreviousCAPoorComputation CHAR(1)
		DECLARE @PreviousAssociationsLoose CHAR(1)
		DECLARE @PreviousAssociationsClanging CHAR(1)
		DECLARE @PreviousAssociationsWordsalad CHAR(1)
		DECLARE @PreviousAssociationsCircumstantial CHAR(1)
		DECLARE @PreviousAssociationsTangential CHAR(1)
		DECLARE @PreviousPDAuditoryHallucinations CHAR(1)
		DECLARE @PreviousPDVisualHallucinations CHAR(1)
		DECLARE @PreviousPDCommandHallucinations CHAR(1)
		DECLARE @PreviousPDDelusions CHAR(1)
		DECLARE @PreviousPDPreoccupation CHAR(1)
		DECLARE @PreviousPDOlfactoryHallucinations CHAR(1)
		DECLARE @PreviousPDGustatoryHallucinations CHAR(1)
		DECLARE @PreviousPDTactileHallucinations CHAR(1)
		DECLARE @PreviousPDSomaticHallucinations CHAR(1)
		DECLARE @PreviousPDIllusions CHAR(1)
		DECLARE @PreviousOrientationPerson CHAR(1)
		DECLARE @PreviousOrientationPlace CHAR(1)
		DECLARE @PreviousOrientationTime CHAR(1)
		DECLARE @PreviousOrientationSituation CHAR(1)
		DECLARE @PreviousFundOfKnowledgeCurrentEvents CHAR(1)
		DECLARE @PreviousFundOfKnowledgePastHistory CHAR(1)
		DECLARE @PreviousFundOfKnowledgeVocabulary CHAR(1)
		DECLARE @PreviousInsightAndJudgementSubstance CHAR(1)
		DECLARE @PreviousMuscleStrengthorToneAtrophy CHAR(1)
		DECLARE @PreviousMuscleStrengthorToneAbnormal CHAR(1)
		DECLARE @PreviousGaitandStationRestlessness CHAR(1)
		DECLARE @PreviousGaitandStationStaggered CHAR(1)
		DECLARE @PreviousGaitandStationShuffling CHAR(1)
		DECLARE @PreviousGaitandStationUnstable CHAR(1)

		SELECT  @PreviousGeneralPoorlyAddresses= CASE GeneralPoorlyAddresses WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousGeneralPoorlyGroomed= CASE GeneralPoorlyGroomed WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousGeneralDisheveled = CASE GeneralDisheveled WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousGeneralOdferous = CASE GeneralPoorlyGroomed WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousGeneralDeformities = CASE GeneralDeformities WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousGeneralPoorNutrion = CASE GeneralPoorNutrion WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousGeneralRestless = CASE GeneralRestless WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousGeneralPsychometer = CASE GeneralPsychometer WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousGeneralEvasive = CASE GeneralEvasive WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousGeneralInAttentive = CASE GeneralInAttentive WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousGeneralPoorEyeContact = CASE GeneralPoorEyeContact WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousGeneralHostile = CASE GeneralHostile WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousSpeechIncreased = CASE SpeechIncreased WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousSpeechDecreased = CASE SpeechDecreased WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousSpeechPaucity = CASE SpeechPaucity WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousSpeechHyperverbal = CASE SpeechHyperverbal WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousSpeechPoorArticulations = CASE SpeechPoorArticulations WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousSpeechLoud = CASE SpeechLoud WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousSpeechSoft = CASE SpeechSoft WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousSpeechMute = CASE SpeechMute WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousSpeechStuttering = CASE SpeechStuttering WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousSpeechImpaired = CASE SpeechImpaired WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousSpeechPressured = CASE SpeechPressured WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousSpeechFlight = CASE SpeechFlight WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousLanguageDifficultyNaming = CASE LanguageDifficultyNaming WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousLanguageDifficultyRepeating = CASE LanguageDifficultyRepeating WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousMoodHappy = CASE MoodHappy WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousMoodSad = CASE MoodSad WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousMoodAnxious = CASE MoodAnxious WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousMoodAngry = CASE MoodAngry WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousMoodIrritable = CASE MoodIrritable WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousMoodElation = CASE MoodElation  WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousMoodNormal = CASE MoodNormal WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousAffectEuthymic   = CASE AffectEuthymic WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousAffectDysphoric = CASE AffectDysphoric WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousAffectAnxious = CASE AffectAnxious  WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousAffectIrritable = CASE AffectIrritable WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousAffectBlunted = CASE AffectBlunted WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousAffectLabile = CASE AffectLabile WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousAffectEuphoric = CASE AffectEuphoric WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousAffectCongruent = CASE AffectCongruent WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousAttensionPoorConcentration = CASE AttensionPoorConcentration WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousAttensionPoorAttension = CASE AttensionPoorAttension WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousAttensionDistractible = CASE AttensionDistractible WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousTPDisOrganised = CASE TPDisOrganised WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousTPBlocking = CASE TPBlocking  WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousTPPersecution = CASE TPPersecution WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousTPBroadCasting = CASE TPBroadCasting WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousTPDetrailed = CASE TPDetrailed WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousTPThoughtinsertion = CASE TPThoughtinsertion WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousTPIncoherent = CASE TPIncoherent WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END	
		,@PreviousTPRacing  = CASE TPRacing WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousTPIllogical  = CASE TPIllogical WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousTCDelusional  = CASE TCDelusional WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousTCParanoid  = CASE TCParanoid WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousTCThoughtInsertion   = CASE TCThoughtInsertion  WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousTCThoughtWithdrawal  = CASE TCThoughtWithdrawal WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousTCThoughtBroadcasting  = CASE TCThoughtBroadcasting WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousTCReligiosity  = CASE TCReligiosity WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousTCGrandiosity  = CASE TCGrandiosity WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousTCPerserveration  = CASE TCPerserveration WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousTCObsessions  = CASE TCObsessions WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousTCWorthlessness  = CASE TCWorthlessness  WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousTCLoneliness  = CASE TCLoneliness WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousTCGuilt  = CASE TCGuilt WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousTCHopelessness  = CASE TCHopelessness WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousTCHelplessness  = CASE TCHelplessness WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousCAPoorKnowledget  = CASE CAPoorKnowledget WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousCAConcrete  = CASE CAConcrete WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END	
		,@PreviousCAUnable   = CASE CAUnable WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousCAPoorComputation   = CASE CAPoorComputation WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousAssociationsLoose   = CASE AssociationsLoose WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousAssociationsClanging   = CASE AssociationsClanging WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousAssociationsWordsalad   = CASE AssociationsWordsalad WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousAssociationsCircumstantial   = CASE AssociationsCircumstantial WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousAssociationsTangential   = CASE AssociationsTangential WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousPDAuditoryHallucinations   = CASE PDAuditoryHallucinations WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousPDVisualHallucinations   = CASE PDVisualHallucinations WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousPDCommandHallucinations   = CASE PDCommandHallucinations  WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousPDDelusions   = CASE PDDelusions WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousPDPreoccupation   = CASE PDPreoccupation WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousPDOlfactoryHallucinations   = CASE PDOlfactoryHallucinations WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousPDGustatoryHallucinations   = CASE PDGustatoryHallucinations WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousPDTactileHallucinations   = CASE PDTactileHallucinations  WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousPDSomaticHallucinations    = CASE PDSomaticHallucinations WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousPDIllusions    = CASE PDIllusions WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousOrientationPerson    = CASE OrientationPerson WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousOrientationPlace    = CASE OrientationPlace WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousOrientationSituation     = CASE OrientationSituation WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousFundOfKnowledgeCurrentEvents    = CASE FundOfKnowledgeCurrentEvents WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousFundOfKnowledgePastHistory    = CASE FundOfKnowledgePastHistory WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousFundOfKnowledgeVocabulary    = CASE FundOfKnowledgeVocabulary WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousInsightAndJudgementSubstance    = CASE InsightAndJudgementSubstance WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousMuscleStrengthorToneAtrophy     = CASE MuscleStrengthorToneAtrophy WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousMuscleStrengthorToneAbnormal     = CASE MuscleStrengthorToneAbnormal WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousGaitandStationRestlessness     = CASE GaitandStationRestlessness WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousGaitandStationStaggered     = CASE GaitandStationStaggered  WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousGaitandStationShuffling     = CASE GaitandStationShuffling WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		,@PreviousGaitandStationUnstable     = CASE GaitandStationUnstable WHEN 'Y'
		THEN 'Y' ELSE 'N'
		END
		 FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@LatestDocumentVersionId
		
		

		SELECT DocumentVersionId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedBy
			,DeletedDate
			,AdultChildAdolescent
			,PersonPresent
			,ChiefComplaint
			,SideEffects
			,SideEffectsComments
			,PlanLastVisit
			,PsychiatricHistory
			,PsychiatricHistoryComments
			,FamilyHistory
			,FamilyHistoryComments
			,SocialHistory
			,SocialHistoryComments
			,ReviewPsychiatric
			,ReviewMusculoskeletal
			,ReviewConstitutional
			,ReviewEarNoseMouthThroat
			,ReviewGenitourinary
			,ReviewGastrointestinal
			,ReviewIntegumentary
			,ReviewEndocrine
			,ReviewNeurological
			,ReviewImmune
			,ReviewEyes
			,ReviewRespiratory
			,ReviewCardio
			,ReviewHemLymph
			,ReviewOthersNegative
			,ReviewComments
			,SubstanceUse
			,Pregnant
			,LastMenstrualPeriod
			,PresentingProblem
			,AllergiesText
			,AllergiesSmoke
			,AllergiesSmokePerday
			,AllergiesTobacouse
			,AllergiesCaffeineConsumption
			,@GENDER as Sex
			,@clientAge as Age
			,MedicalHistory
            ,MedicalHistoryComments 
            ,SUAlcohol
			,SUAmphetamines
			,SUBenzos
			,SUCocaine
			,SUMarijuana
			,SUOpiates
			,SUOthers
			,SUHallucinogen
			,SUInhalant 
			,SUAlcoholDiagnosis
			,SUAmphetaminesDiagnosis
			,SUBenzosDiagnosis
			,SUCocaineDiagnosis
			,SUMarijuanaDiagnosis
			,SUOpiatesDiagnosis
			,SUOthersDiagnosis
			,SUHallucinogenDiagnosis
			,SUInhalantDiagnosis 
			,CASE 
				WHEN @LatestDocumentVersionId = - 1
					THEN 'Y'
				ELSE 'N'
				END AS Initial
		FROM CustomDocumentPsychiatricNoteGenerals
		WHERE DocumentVersionId = @DocumentVersionId
			AND ISNULL(RecordDeleted, 'N') = 'N'

		SELECT PsychiatricNoteProblemId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedBy
			,DeletedDate
			,DocumentVersionId
			,SubjectiveText
			,TypeOfProblem
			,Severity
			,Duration
			,TimeOfDayAllday
			,TimeOfDayMorning
			,TimeOfDayAfternoon
			,TimeOfDayNight
			,ContextText
			,LocationHome
			,LocationSchool
			,LocationWork
			,LocationEverywhere
			,LocationOther
			,LocationOtherText
			,AssociatedSignsSymptoms
			,AssociatedSignsSymptomsOtherText
			,ModifyingFactors
			,ProblemStatus
			,DiscussLongActingInjectable
			,ProblemMDMComments
			,ICD10Code
		FROM CustomPsychiatricNoteProblems
		WHERE DocumentVersionId = @DocumentVersionId
			AND ISNULL(RecordDeleted, 'N') = 'N'

		EXEC csp_GetCustomPsyExternalReferralProviders @DocumentVersionId

		EXEC csp_GetCustomDocumentPsyExternalReferralProviders @DocumentVersionId

		SELECT 
		 DocumentVersionId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,ReviewWithChanges
		,MusculoskeletalMuscleNormal
		,MusculoskeletalMuscleAbnormal
		,MusculoskeletalMuscleTone
		,MusculoskeletalMuscleComment
		,MusculoskeletalMuscleTicsTremors
		,MusculoskeletalMuscleEPS
		,GaitStationNormal
		,GaitStationAbnormal
		,AlertOriented
		,AlertOrientedComment
		,Grooming
		,GroomingComment
		,EyeContact
		,EyeContactComment
		,Cooperative
		,CooperativeComment
		,MentalStatusGeneral
		,Speech
		,SpeechComment
		,Psychomotor
		,PsychomotorComment
		,MoodEuthymic
		,MoodLabile
		,MoodDysphoric
		,MoodElevated
		,MoodAnxious
		,MoodIrritable
		,MoodExpansive
		,MoodComment
		,AffectBroad
		,AffectFlat
		,AffectBlunted
		,AffectConstricted
		,AffectGuarded
		,AffectComment
		,ThoughtProcessLogical
		,ThoughtProcessIllogical
		,ThoughtProcessCircumstantial
		,ThoughtProcessTangential
		,ThoughtProcessFlightOfIdeas
		,ThoughtProcessPreoccupied
		,ThoughtProcessAuditoryHallucinations
		,ThoughtProcessDelusions
		,ThoughtProcessVisualHallucinations
		,ThoughtProcessParanoia
		,ThoughtProcessGrandiose
		,ThoughtProcessReferential
		,ThoughtProcessPovertyOfThought
		,ThoughtProcessLooseAssociations
		,ThoughtProcessComment
		,Suicidal
		,SuicidalIdeation
		,SuicidalIntent
		,SuicidalPlan
		,SuicidalComment
		,Homicidal
		,HomicidalIdeation
		,HomicidalIntent
		,HomicidalPlan
		,HomicidalCommnet
		,MemoryRecall
		,MemoryRecallComment
		,Intelligence
		,InsightJudgment
		,InsightJudgmentComment
		,MentalStatusAdditionalComment
		,GeneralAppearance
		,GeneralPoorlyAddresses
		,GeneralPoorlyGroomed
		,GeneralDisheveled
		,GeneralOdferous
		,GeneralDeformities
		,GeneralPoorNutrion
		,GeneralRestless
		,GeneralPsychometer
		,GeneralHyperActive
		,GeneralEvasive
		,GeneralInAttentive
		,GeneralPoorEyeContact
		,GeneralHostile
		,SpeechIncreased
		,SpeechDecreased
		,SpeechPaucity
		,SpeechHyperverbal
		,SpeechPoorArticulations
		,SpeechLoud
		,SpeechSoft
		,SpeechMute
		,SpeechStuttering
		,SpeechImpaired
		,SpeechPressured
		,SpeechFlight
		,PsychiatricNoteExamLanguage
		,LanguageDifficultyNaming
		,LanguageDifficultyRepeating
		,MoodAndAffect
		,MoodHappy
		,MoodSad
		,MoodAngry
		,MoodElation
		,MoodNormal
		,AffectEuthymic
		,AffectDysphoric
		,AffectAnxious
		,AffectIrritable
		,AffectLabile
		,AffectEuphoric
		,AffectCongruent
		,AttensionSpanAndConcentration
		,AttensionPoorConcentration
		,AttensionPoorAttension
		,AttensionDistractible
		,ThoughtContentCognision
		,TPDisOrganised
		,TPBlocking
		,TPPersecution
		,TPBroadCasting
		,TPDetrailed
		,TPThoughtinsertion
		,TPIncoherent
		,TPRacing
		,TPIllogical
		,TCDelusional
		,TCParanoid
		,TCIdeas
		,TCThoughtInsertion
		,TCThoughtWithdrawal
		,TCThoughtBroadcasting
		,TCReligiosity
		,TCGrandiosity
		,TCPerserveration
		,TCObsessions
		,TCWorthlessness
		,TCLoneliness
		,TCGuilt
		,TCHopelessness
		,TCHelplessness
		,CAPoorKnowledget
		,CAConcrete
		,CAUnable
		,CAPoorComputation
		,Associations
		,AssociationsLoose
		,AssociationsClanging
		,AssociationsWordsalad
		,AssociationsCircumstantial
		,AssociationsTangential
		,AbnormalorPsychoticThoughts
		,PsychosisOrDisturbanceOfPerception
		,PDAuditoryHallucinations
		,PDVisualHallucinations
		,PDCommandHallucinations
		,PDDelusions
		,PDPreoccupation
		,PDOlfactoryHallucinations
		,PDGustatoryHallucinations
		,PDTactileHallucinations
		,PDSomaticHallucinations
		,PDIllusions
		,PDCurrentSuicideIdeation
		,PDCurrentSuicidalPlan
		,PDCurrentSuicidalIntent
		,PDCurrentHomicidalIdeation
		,PDMeanstocarry
		,PDCurrentHomicidalPlans
		,PDCurrentHomicidalIntent
		,PDMeansToCarryNew
		,Orientation
		,OrientationPerson
		,OrientationPlace
		,OrientationTime
		,OrientationSituation
		,FundOfKnowledge
		,FundOfKnowledgeCurrentEvents
		,FundOfKnowledgePastHistory
		,FundOfKnowledgeVocabulary
		,InsightAndJudgement
		,InsightAndJudgementStatus
		,InsightAndJudgementSubstance
		,Memory
		,MemoryImmediate
		,MemoryRecent
		,MemoryRemote
		,MuscleStrengthorTone
		,MuscleStrengthorToneAtrophy
		,MuscleStrengthorToneAbnormal
		,GaitandStation
		,GaitandStationRestlessness
		,GaitandStationStaggered
		,GaitandStationShuffling
		,GaitandStationUnstable
		,@PreviousGeneralPoorlyAddresses AS PreviousGeneralPoorlyAddresses
		,@PreviousGeneralPoorlyGroomed AS PreviousGeneralPoorlyGroomed
		,@PreviousGeneralDisheveled AS PreviousGeneralDisheveled
		,@PreviousGeneralOdferous AS PreviousGeneralOdferous
		,@PreviousGeneralDeformities AS PreviousGeneralDeformities
		,@PreviousGeneralPoorNutrion AS PreviousGeneralPoorNutrion
		,@PreviousGeneralRestless AS PreviousGeneralRestless
		,@PreviousGeneralPsychometer AS PreviousGeneralPsychometer
		,@PreviousGeneralHyperActive AS PreviousGeneralHyperActive
		,@PreviousGeneralEvasive AS PreviousGeneralEvasive
		,@PreviousGeneralInAttentive AS PreviousGeneralInAttentive
		,@PreviousGeneralPoorEyeContact AS PreviousGeneralPoorEyeContact
		,@PreviousGeneralHostile AS PreviousGeneralHostile
		,@PreviousSpeechIncreased AS PreviousSpeechIncreased
		,@PreviousSpeechDecreased AS PreviousSpeechDecreased
		,@PreviousSpeechPaucity AS PreviousSpeechPaucity
		,@PreviousSpeechHyperverbal AS PreviousSpeechHyperverbal
		,@PreviousSpeechPoorArticulations AS PreviousSpeechPoorArticulations
		,@PreviousSpeechLoud AS PreviousSpeechLoud
		,@PreviousSpeechSoft AS PreviousSpeechSoft
		,@PreviousSpeechMute AS PreviousSpeechMute
		,@PreviousSpeechStuttering AS PreviousSpeechStuttering
		,@PreviousSpeechImpaired AS PreviousSpeechImpaired
		,@PreviousSpeechPressured AS PreviousSpeechPressured
		,@PreviousSpeechFlight AS PreviousSpeechFlight
		,@PreviousLanguageDifficultyNaming AS PreviousLanguageDifficultyNaming
		,@PreviousLanguageDifficultyRepeating AS PreviousLanguageDifficultyRepeating
		,@PreviousMoodHappy AS PreviousMoodHappy
		,@PreviousMoodSad AS PreviousMoodSad
		,@PreviousMoodAnxious AS PreviousMoodAnxious
		,@PreviousMoodAngry AS PreviousMoodAngry
		,@PreviousMoodIrritable AS PreviousMoodIrritable
		,@PreviousMoodElation AS PreviousMoodElation
		,@PreviousMoodNormal AS PreviousMoodNormal
		,@PreviousAffectEuthymic AS PreviousAffectEuthymic
		,@PreviousAffectDysphoric AS PreviousAffectDysphoric
		,@PreviousAffectAnxious AS PreviousAffectAnxious
		,@PreviousAffectIrritable AS PreviousAffectIrritable
		,@PreviousAffectBlunted AS PreviousAffectBlunted
		,@PreviousAffectLabile AS PreviousAffectLabile
		,@PreviousAffectEuphoric AS PreviousAffectEuphoric
		,@PreviousAffectCongruent AS PreviousAffectCongruent
		,@PreviousAttensionPoorConcentration AS PreviousAttensionPoorConcentration
		,@PreviousAttensionPoorAttension AS PreviousAttensionPoorAttension
		,@PreviousAttensionDistractible AS PreviousAttensionDistractible
		,@PreviousTPDisOrganised AS PreviousTPDisOrganised
		,@PreviousTPBlocking AS PreviousTPBlocking
		,@PreviousTPPersecution AS PreviousTPPersecution
		,@PreviousTPBroadCasting AS PreviousTPBroadCasting
		,@PreviousTPDetrailed AS PreviousTPDetrailed
		,@PreviousTPThoughtinsertion AS PreviousTPThoughtinsertion
		,@PreviousTPIncoherent AS PreviousTPIncoherent
		,@PreviousTPRacing AS PreviousTPRacing
		,@PreviousTPIllogical AS PreviousTPIllogical
		,@PreviousTCDelusional AS PreviousTCDelusional
		,@PreviousTCParanoid AS PreviousTCParanoid
		,@PreviousTCIdeas AS PreviousTCIdeas
		,@PreviousTCThoughtInsertion AS PreviousTCThoughtInsertion
		,@PreviousTCThoughtWithdrawal AS PreviousTCThoughtWithdrawal
		,@PreviousTCThoughtBroadcasting AS PreviousTCThoughtBroadcasting
		,@PreviousTCReligiosity AS PreviousTCReligiosity
		,@PreviousTCGrandiosity AS PreviousTCGrandiosity 
		,@PreviousTCPerserveration AS PreviousTCPerserveration
		,@PreviousTCObsessions AS PreviousTCObsessions
		,@PreviousTCWorthlessness AS PreviousTCWorthlessness
		,@PreviousTCLoneliness AS PreviousTCLoneliness
		,@PreviousTCGuilt AS PreviousTCGuilt
		,@PreviousTCHopelessness AS PreviousTCHopelessness
		,@PreviousTCHelplessness AS PreviousTCHelplessness
		,@PreviousCAPoorKnowledget AS PreviousCAPoorKnowledget
		,@PreviousCAConcrete AS PreviousCAConcrete
		,@PreviousCAUnable AS PreviousCAUnable
		,@PreviousCAPoorComputation AS PreviousCAPoorComputation
		,@PreviousAssociationsLoose AS PreviousAssociationsLoose
		,@PreviousAssociationsClanging AS PreviousAssociationsClanging
		,@PreviousAssociationsWordsalad AS PreviousAssociationsWordsalad
		,@PreviousAssociationsCircumstantial AS PreviousAssociationsCircumstantial
		,@PreviousAssociationsTangential AS PreviousAssociationsTangential
		,@PreviousPDAuditoryHallucinations AS PreviousPDAuditoryHallucinations
		,@PreviousPDVisualHallucinations AS PreviousPDVisualHallucinations
		,@PreviousPDCommandHallucinations AS PreviousPDCommandHallucinations
		,@PreviousPDDelusions AS PreviousPDDelusions
		,@PreviousPDPreoccupation AS PreviousPDPreoccupation
		,@PreviousPDOlfactoryHallucinations AS PreviousPDOlfactoryHallucinations
		,@PreviousPDGustatoryHallucinations AS PreviousPDGustatoryHallucinations
		,@PreviousPDTactileHallucinations AS PreviousPDTactileHallucinations
		,@PreviousPDSomaticHallucinations AS PreviousPDSomaticHallucinations
		,@PreviousPDIllusions AS PreviousPDIllusions
		,@PreviousOrientationPerson AS PreviousOrientationPerson
		,@PreviousOrientationPlace AS PreviousOrientationPlace
		,@PreviousOrientationTime AS PreviousOrientationTime
		,@PreviousOrientationSituation AS PreviousOrientationSituation
		,@PreviousFundOfKnowledgeCurrentEvents AS PreviousFundOfKnowledgeCurrentEvents
		,@PreviousFundOfKnowledgePastHistory AS PreviousFundOfKnowledgePastHistory
		,@PreviousFundOfKnowledgeVocabulary AS PreviousFundOfKnowledgeVocabulary
		,@PreviousInsightAndJudgementSubstance AS PreviousInsightAndJudgementSubstance
		,@PreviousMuscleStrengthorToneAtrophy AS PreviousMuscleStrengthorToneAtrophy
		,@PreviousMuscleStrengthorToneAbnormal AS PreviousMuscleStrengthorToneAbnormal
		,@PreviousGaitandStationRestlessness AS PreviousGaitandStationRestlessness
		,@PreviousGaitandStationStaggered AS  PreviousGaitandStationStaggered
		,@PreviousGaitandStationShuffling AS PreviousGaitandStationShuffling
		,@PreviousGaitandStationUnstable AS PreviousGaitandStationUnstable
		,MentalStatusComments
		,GeneralAppearanceOthers
		,GeneralAppearanceOtherComments
		,SpeechOthers
		,SpeechOtherComments
		,LanguageOthers
		,LanguageOtherComments
		,MoodOthers
		,MoodOtherComments
		,AffectOthers
		,AffectOtherComments
		,AttentionSpanOthers
		,AttentionSpanOtherComments
		,ThoughtProcessOthers
		,ThoughtProcessOtherComments
		,ThoughtContentOthers
		,ThoughtContentOtherComments
		,CognitiveAbnormalitiesOthers
		,CognitiveAbnormalitiesOtherComments
		,AssociationsOthers
		,AssociationsOtherComments
		,AbnormalPsychoticOthers
		,AbnormalPsychoticOthersComments
		,OrientationOthers
		,OrientationOtherComments
		,FundOfKnowledgeOthers
		,FundOfKnowledgeOtherComments
		,InsightAndJudgementOthers
		,InsightAndJudgementOtherComments
		,MemoryOthers
		,MemoryOtherComments
		,MuscleStrengthOthers
		,MuscleStrengthOtherComments
		,GaitAndStationOthers
		,GaitAndStationOtherComments
		FROM CustomDocumentPsychiatricNoteExams
		WHERE DocumentVersionId = @DocumentVersionId
			AND ISNULL(RecordDeleted, 'N') = 'N'

		SELECT DocumentVersionId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedBy
			,DeletedDate
			,MedicalRecords
			,DiagnosticTest
			,CollaborationOfCare
			,Labs
			,Other
			,LabsSelected
			,MedicalRecordsComments
			,OrderedMedications
			,MedicationsReviewed
			,RisksBenefits
			,NewlyEmergentSideEffects
			,LabOrder
			,EKG
			,RadiologyOrder
			,Consultations
			,OrdersComments
			,LabsLastOrder
			,PlanLastVisitMDM
			,[PlanComment]
			,PatientConsent
			,MoreThanFifty
			,InformationAndEducation
			,MedicationsDiscontinued
			,NurseMonitorPillBox
			,NextPhysicianVisit
			,NurseMonitorFrequency
			,NurseMonitorComment
			,NurseMonitorFrequencyOther
			,DecisionMakingSchizophrenia
			,DecisionMakingSchizophreniaStatus
			,DecisionMakingAnxiety
			,DecisionMakingAnxietyStatus
			,DecisionMakingWeightLoss
			,DecisionMakingWeightLossStatus
			,DecisionMakingInsomnia
			,DecisionMakingInsomniaStatus
			,MedicalRecordsRelevantResults
			,MedicalRecordsPreviousResults
			,ReviewClinicalLabs
			,ReviewRadiologyTest
			,ReviewOtherTest
			,DiscussionOfTestResults
			,DecisionToObtainByOthers
			,ReviewSummarizedOldRecords
			,IndependentVisualization
			,LevelOfRisk
			,MedicationReconciliation
			
		FROM CustomDocumentPsychiatricNoteMDMs
		WHERE DocumentVersionId = @DocumentVersionId
			AND ISNULL(RecordDeleted, 'N') = 'N'

		--aims
		--DECLARE @LatestDocumentVersionID INT
	DECLARE @EffectiveDate Datetime
	DECLARE @PreviousAIMSTotalScore INT
	--DECLARE @ClientID INT
	DECLARE @PreviousExtremityMovementsUpper INT
    DECLARE @PreviousMuscleFacialExpression INT
    DECLARE @PreviousLipsPerioralArea INT
    DECLARE @PreviousJaw INT
    DECLARE @PreviousTongue INT
    DECLARE @PreviousExtremityMovementsLower INT
    DECLARE @PreviousNeckShouldersHips INT
    DECLARE @PreviousSeverityAbnormalMovements INT
    DECLARE @PreviousPatientAwarenessAbnormalMovements INT
    DECLARE @PreviousIncapacitationAbnormalMovements INT
    DECLARE @PreviousCurrentProblemsTeeth Varchar(10)
    DECLARE @PreviousDoesPatientWearDentures Varchar(10)
    DECLARE @PreviousAIMSPositveNegative Varchar(10)
	
	SELECT @ClientID = Doc.ClientId  FROM Documents Doc where doc.CurrentDocumentVersionId=@DocumentVersionId
	
	 SET  @LatestDocumentVersionID =  (SELECT TOP 1
                    CDP.DocumentVersionId 
                   -- @EffectiveDate = Doc.EffectiveDate
            FROM    CustomDocumentPsychiatricAIMSs CDP ,
                    Documents Doc
            WHERE   CDP.DocumentVersionId = Doc.CurrentDocumentVersionId
                    AND Doc.ClientId = @ClientID
                    AND Doc.Status = 22
                    AND ISNULL(CDP.RecordDeleted, 'N') = 'N'
                    AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
                    AND Doc.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101))
                    ORDER BY Doc.EffectiveDate DESC ,
                    Doc.ModifiedDate DESC ) 
         SELECT @EffectiveDate = EffectiveDate FROM  Documents WHERE  CurrentDocumentVersionId= @LatestDocumentVersionID             
  IF @LatestDocumentVersionID IS NOT NULL
	BEGIN
		SELECT 
	 @PreviousExtremityMovementsUpper = ExtremityMovementsUpper
	,@PreviousAIMSTotalScore=AIMSTotalScore
	,@PreviousMuscleFacialExpression =MuscleFacialExpression
	,@PreviousLipsPerioralArea = LipsPerioralArea
	,@PreviousJaw = Jaw
	,@PreviousTongue = Tongue
	,@PreviousExtremityMovementsLower = ExtremityMovementsLower
	,@PreviousNeckShouldersHips = NeckShouldersHips
	,@PreviousSeverityAbnormalMovements = SeverityAbnormalMovements
	,@PreviousPatientAwarenessAbnormalMovements = PatientAwarenessAbnormalMovements
	,@PreviousIncapacitationAbnormalMovements = IncapacitationAbnormalMovements
	,@PreviousCurrentProblemsTeeth= CurrentProblemsTeeth
	,@PreviousDoesPatientWearDentures = DoesPatientWearDentures
	,@PreviousAIMSPositveNegative  = AIMSPositveNegative
	FROM CustomDocumentPsychiatricAIMSs  
    WHERE DocumentVersionId =@LatestDocumentVersionID and ISNULL(RecordDeleted,'N') = 'N' 
 
   	END
   	
	
	
	SELECT  DocumentVersionId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,MuscleFacialExpression
		,LipsPerioralArea
		,Jaw
		,Tongue
		,ExtremityMovementsUpper
		,ExtremityMovementsLower
		,NeckShouldersHips
		,SeverityAbnormalMovements
		,IncapacitationAbnormalMovements
		,PatientAwarenessAbnormalMovements
		,CurrentProblemsTeeth
		,DoesPatientWearDentures
		,AIMSTotalScore
	,@PreviousMuscleFacialExpression as PreviousMuscleFacialExpression
	,@PreviousLipsPerioralArea as PreviousLipsPerioralArea
	,@PreviousJaw as PreviousJaw
	,@PreviousTongue as PreviousTongue
	,@PreviousExtremityMovementsUpper as PreviousExtremityMovementsUpper
	,@PreviousExtremityMovementsLower as PreviousExtremityMovementsLower
	,@PreviousNeckShouldersHips as PreviousNeckShouldersHips
	,@PreviousSeverityAbnormalMovements as PreviousSeverityAbnormalMovements
	,@PreviousIncapacitationAbnormalMovements as PreviousIncapacitationAbnormalMovements
	,@PreviousPatientAwarenessAbnormalMovements as PreviousPatientAwarenessAbnormalMovements
	,@PreviousCurrentProblemsTeeth as PreviousCurrentProblemsTeeth
	,@PreviousDoesPatientWearDentures as PreviousDoesPatientWearDentures
	,@PreviousAIMSTotalScore as PreviousAIMSTotalScore 
	,CONVERT(VARCHAR(12),@EffectiveDate,101) AS PreviousEffectiveDate
	,AIMSComments
	,AIMSPositveNegative
	,@PreviousAIMSPositveNegative AS PreviousAIMSPositveNegative 
	,SetDeafultForMovements	
    FROM CustomDocumentPsychiatricAIMSs  
    WHERE DocumentVersionId = @DocumentVersionId and ISNULL(RecordDeleted,'N') = 'N'  
		--end

		SELECT DocumentVersionId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedBy
			,DeletedDate
			,ProblemsLabors
			,ProblemsPregnancy
			,PrenatalExposure
			,CurrentHealthIssues
			,ChildDevlopmental
			,SexualityIssues
			,CurrentImmunizations
			,HealthFunctioningComment
			,FunctioningLanguage
			,FunctioningVisual
			,FunctioningIntellectual
			,FunctioningLearning
			,AreasOfConcernComment
			,FamilyMentalHealth
			,FamilyCurrentHousingIssues
			,FamilyParticipate
			,ChildAbuse
			,FamilyDynamicsComment
			,CASE 
				WHEN @LatestDocumentVersionId = - 1
					THEN 'Y'
				ELSE 'N'
				END AS Initial
		FROM CustomDocumentPsychiatricNoteChildAdolescents
		WHERE DocumentVersionId = @DocumentVersionId
			AND ISNULL(RecordDeleted, 'N') = 'N'

		--Diagnosis  
		EXEC ssp_SCGetDataDiagnosisNew @DocumentVersionId
	
		
		-- NoteEMCodeOptions  
		SELECT NoteEMCodeOptionId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
			,DocumentVersionId
			,ProcedureCodeId
			,ProgramId
			,LocationId
			,StartTime
			,EndTime
			,ModifierId1
			,ModifierId2
			,ModifierId3
			,ModifierId4
			,HistoryHPILocation
			,HistoryHPIDuration
			,HistoryHPIModifyingFactors
			,HistoryHPIContextOnset
			,HistoryHPIQualityNature
			,HistoryHPITimingFrequency
			,HistoryHPIAssociatedSignsSymptoms
			,HistoryHPISeverity
			,HistoryHPITotalCount
			,HistoryHPIResults
			,HistoryROSConstitutional
			,HistoryROSEarNoseMouthThroat
			,HistoryROSCardiovascular
			,HistoryROSRespiratory
			,HistoryROSSkin
			,HistoryROSPsychiatric
			,HistoryROSHematologicLymphatic
			,HistoryROSEye
			,HistoryROSGastrointestinal
			,HistoryROSGenitourinary
			,HistoryROSMusculoskeletal
			,HistoryROSNeurological
			,HistoryROSEndocrine
			,HistoryROSAllergicImmunologic
			,HistoryROSTotalCount
			,HistoryROSResults
			,HistoryPHFamilyHistory
			,HistoryPHSocialHistory
			,HistoryPHMedicalHistory
			,HistoryPHTotalCount
			,HistoryPHResults
			,HistoryFinalResult
			,ExamBAHead
			,ExamBABack
			,ExamBALeftUpperExtremity
			,ExamBALeftLowerExtremity
			,ExamBAAbdomen
			,ExamBANeck
			,ExamBAChest
			,ExamBARightUpperExtremity
			,ExamBARightLowerExtremity
			,ExamBAGenitaliaButtocks
			,ExamOSConstitutional
			,ExamOSEyes
			,ExamOSEarNoseMouthThroat
			,ExamOSCardiovascular
			,ExamOSRespiratory
			,ExamOSPsychiatric
			,ExamOSGastrointestinal
			,ExamOSGenitourinary
			,ExamOSMusculoskeletal
			,ExamOSSkin
			,ExamOSNeurologic
			,ExamOSHematologicLymphatic
			,ExamTypeOfExam
			,ExamFinalResult
			,MDMDRROClinicalLabs
			,MDMDRROOtherTest
			,MDMDRObtainRecords
			,MDMDRIndependentVisualization
			,MDMDRRORadiologyTest
			,MDMDRDiscussion
			,MDMDRReviewSummarize
			,MDMDRResults
			,MDMDTONewProblem
			,MDMDTOProblems1
			,MDMDTOProblems2
			,MDMDTOProblems3
			,MDMDTOProblems4Plus
			,MDMDTOAdditionalWorkup
			,MDMDTOProblemWorsening1
			,MDMDTOProblemWorsening2
			,MDMDTOResults
			,MDMRCMMResults
			,MDMFinalResult
			,ECEEMCode
			,ECEGuidelines
			,ECETypeOfPatient
			,ECEVisitType
			,ECE50PercentFaceTime
			,ECEMinutes
			,ECAQChronicProblemsAddressed3Plus
			,ECAQAdditionalWorkup
			,ECAQProblemWorsening1
			,ECAQProblemWorsening2
			,ECAQIllnessWithExacerbation
			,ECAQDiscussion
			,ECAQObtainRecords
			,ECAQIndependentVisualization
			,ECAQReviewSummarize
			,ExamBAHeadCount
			,ExamBAHeadTotalCount
			,ExamBABackCount
			,ExamBABackTotalCount
			,ExamBALeftUpperExtremityCount
			,ExamBALeftUpperExtremityTotalCount
			,ExamBALeftLowerExtremityCount
			,ExamBALeftLowerExtremityTotalCount
			,ExamBAAbdomenCount
			,ExamBAAbdomenTotalCount
			,ExamBANeckCount
			,ExamBANeckTotalCount
			,ExamBAChestCount
			,ExamBAChestTotalCount
			,ExamBARightUpperExtremityCount
			,ExamBARightUpperExtremityTotalCount
			,ExamBARightLowerExtremityCount
			,ExamBARightLowerExtremityTotalCount
			,ExamBAGenitaliaButtocksCount
			,ExamBAGenitaliaButtocksTotalCount
			,ExamOSConstitutionalCount
			,ExamOSConstitutionalTotalCount
			,ExamOSEyesCount
			,ExamOSEyesTotalCount
			,ExamOSEarNoseMouthThroatCount
			,ExamOSEarNoseMouthThroatTotalCount
			,ExamOSCardiovascularCount
			,ExamOSCardiovascularTotalCount
			,ExamOSRespiratoryCount
			,ExamOSRespiratoryTotalCount
			,ExamOSPsychiatricCount
			,ExamOSPsychiatricTotalCount
			,ExamOSGastrointestinalCount
			,ExamOSGastrointestinalTotalCount
			,ExamOSGenitourinaryCount
			,ExamOSGenitourinaryTotalCount
			,ExamOSMusculoskeletalCount
			,ExamOSMusculoskeletalTotalCount
			,ExamOSSkinCount
			,ExamOSSkinTotalCount
			,ExamOSNeurologicCount
			,ExamOSNeurologicTotalCount
			,ExamOSHematologicLymphaticCount
			,ExamOSHematologicLymphaticTotalCount
			,MDMRCMMPPMinorOtherProb1
			,MDMRCMMPPMinorOtherProb2Plus
			,MDMRCMMPPStableChronicMajor1
			,MDMRCMMPPChronicMajorMildExac1Plus
			,MDMRCMMPPAcuteUncomplicated1
			,MDMRCMMPPNewProblem
			,MDMRCMMPPAcuteIllness
			,MDMRCMMPPAcuteComplicatedInjury
			,MDMRCMMPPChronicMajorSevereExac1Plus
			,MDMRCMMPPAcuteChronicThreat
			,MDMRCMMDLabVenipuncture
			,MDMRCMMDNonCardImaging
			,MDMRCMMDPhysTestNoStress
			,MDMRCMMDPhysTestYesStress
			,MDMRCMMDSkinBiopsies
			,MDMRCMMDDeepNeedle
			,MDMRCMMDDiagEndoNoRisk
			,MDMRCMMDDiagEndoYesRisk
			,MDMRCMMDCardImagingNoRisk
			,MDMRCMMDCardImagingYesRisk
			,MDMRCMMDClinicalLab
			,MDMRCMMDObtainFluid
			,MDMRCMMDCardiacElectro
			,MDMRCMMDDiscopgraphy
			,MDMRCMMMOSMedicationManagement
		FROM NoteEMCodeOptions
		WHERE DocumentVersionId = @DocumentVersionId
			AND ISNULL(RecordDeleted, 'N') = 'N'

			
					--CustomPsychiatricNoteSubstanceUses
		SELECT
		 PsychiatricNoteSubstanceUseId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,DocumentVersionId
		,DocumentDiagnosisCodeId
		,SubstanceUseName
		FROM CustomPsychiatricNoteSubstanceUses
		WHERE DocumentVersionId = @DocumentVersionId
			AND ISNULL(RecordDeleted, 'N') = 'N'
			
			
		SELECT
		PsychiatricNoteMedicationHistoryId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,DocumentVersionId
		,ClientMedicationId
		,MedicalStatus
		
		
	
		FROM CustomPsychiatricNoteMedicationHistory
		WHERE DocumentVersionId = @DocumentVersionId
			
		
			
	END TRY

	BEGIN CATCH
DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SCGetPsychiatricNote') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.  
				16
				,-- Severity.  
				1 -- State.  
				);
	END CATCH
END
GO

