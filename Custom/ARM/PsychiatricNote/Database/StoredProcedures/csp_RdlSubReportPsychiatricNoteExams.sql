/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportPsychiatricNoteExams]    Script Date: 07/24/2015 10:40:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportPsychiatricNoteExams]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportPsychiatricNoteExams]
GO

CREATE PROCEDURE [dbo].[csp_RdlSubReportPsychiatricNoteExams] --1171
@DocumentVersionId INT    
AS    
/*********************************************************************/    
/* Stored Procedure: [csp_RdlSubReportPsychiatricNoteExams] 738144  */    
/*       Date              Author                  Purpose                   */    
/*      14-07-2015       Vijay Yadav               To Retrieve Data  for RDL   */ 
/*      12-07-206        Pabitra                   Fixed the RDL Issue CSGL#214 */ 
/*      06/07/2017          Pabitra             TxAce Customizations #22 */
   
/*********************************************************************/    
BEGIN    
 BEGIN TRY 
 declare @EffectiveDate datetime    
declare @ClientId int   
  
 SELECT TOP 1 @EffectiveDate = EffectiveDate ,  
   @ClientId=ClientId   
   FROM Documents  
   WHERE InProgressDocumentVersionId = @DocumentVersionId   
   AND ISNULL(RecordDeleted,'N')='N'  
 DECLARE @IntegerCodeId INT

		SET @IntegerCodeId = (
				SELECT integercodeid
				FROM dbo.Ssf_recodevaluescurrent('XPSYCHIATRICNOTEVITAL')
				)

		DECLARE @CurrentVitalDate AS DATETIME
		DECLARE @CurrentLatestHealthRecordFormated VARCHAR(max)

		SET @CurrentVitalDate = (
				SELECT Max(healthrecorddate)
				FROM clienthealthdataattributes 
				WHERE clientid = @ClientID AND ISNULL(RecordDeleted,'N')='N'
				)
		SET @CurrentLatestHealthRecordFormated = ''
		
				SET @CurrentLatestHealthRecordFormated = (
					SELECT CONVERT(VARCHAR, @CurrentVitalDate, 101)
					)
		
		DECLARE @CountofPrevious AS INT
		DECLARE @SecondLatestHealthRecord AS DATETIME
		DECLARE @PreviousVitalsWithDate VARCHAR(max)

		SET @PreviousVitalsWithDate = ''

		DECLARE @SecondLatestHealthRecordFormated VARCHAR(max)

		SET @SecondLatestHealthRecordFormated = ''


		
		SET @CountofPrevious = (
				SELECT Count(DISTINCT healthrecorddate)
				FROM clienthealthdataattributes
				WHERE clientid = @ClientID
				)

		IF (@CountofPrevious > 1)
		BEGIN
			SET @SecondLatestHealthRecord = (
					SELECT DISTINCT healthrecorddate
					FROM clienthealthdataattributes
					WHERE clientid = @ClientID
						AND healthrecorddate = (
							SELECT Min(healthrecorddate)
							FROM (
								SELECT DISTINCT TOP (2) healthrecorddate
								FROM clienthealthdataattributes
								WHERE clientid = @ClientID AND ISNULL(RecordDeleted,'N')='N'
								ORDER BY healthrecorddate DESC
								) T
							)
					)

			SET @SecondLatestHealthRecordFormated = (
					SELECT CONVERT(VARCHAR, @SecondLatestHealthRecord, 101)
					)
		END
	  DECLARE @ThirdLatestHealthRecord AS DATETIME  
	  
  DECLARE @ThirdLatestHealthRecordFormated VARCHAR(max)  
  
  SET @ThirdLatestHealthRecordFormated = ''  
		
			IF (@CountofPrevious > 2)
		BEGIN
	 SET @ThirdLatestHealthRecord = (  
     SELECT DISTINCT healthrecorddate  
     FROM clienthealthdataattributes  
     WHERE clientid = @ClientID  
      AND healthrecorddate = (  
       SELECT Min(healthrecorddate)  
       FROM (  
        SELECT DISTINCT TOP (3) healthrecorddate  
        FROM clienthealthdataattributes  
        WHERE clientid = @ClientID AND ISNULL(RecordDeleted,'N')='N'
        ORDER BY healthrecorddate DESC  
        ) T  
       )  
     )  

			   SET @ThirdLatestHealthRecordFormated = (  
     SELECT CONVERT(VARCHAR, @ThirdLatestHealthRecord, 101)  
     )  
		END
		   
   SELECT 
   ('Current Vitals '+@CurrentLatestHealthRecordFormated) AS CurrentvitalDate
	   		,('Previous Vitals '+@SecondLatestHealthRecordFormated) AS PreviousvitalDate
	   		,('Previous Vitals '+@ThirdLatestHealthRecordFormated) AS ThirdPreviousvitalDate

		  ,DocumentVersionId
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
  FROM CustomDocumentPsychiatricNoteExams CD       
  WHERE           
  CD.DocumentVersionId = @DocumentVersionId      
      
     
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RdlSubReportPsychiatricNoteExams') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.    
    16    
    ,-- Severity.    
    1 -- State.    
    );    
 END CATCH    
END    