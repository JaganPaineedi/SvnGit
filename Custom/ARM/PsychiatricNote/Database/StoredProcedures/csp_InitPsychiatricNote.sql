/****** Object:  StoredProcedure [dbo].[csp_InitPsychiatricNote]    Script Date: 07/07/2015 16:26:11 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitPsychiatricNote]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_InitPsychiatricNote]
GO

/****** Object:  StoredProcedure [dbo].[csp_InitPsychiatricNote]    Script Date: 07/07/2015 16:26:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_InitPsychiatricNote] (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
/******************************************************************************
**		File: 
**		Name: csp_InitPsychiatricNote 3,1,''
**		Desc: 
**
**		This template can be customized:
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**
**		Auth: 
**		Date: 06/23/2016
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      11/17/2016      Pabitra                 EM Note  - fields to Initialze Subsequent Notes
**												Why:Camino - Support Go Live Task#122
**      01/24/2017      jcarlson			    Camino SGL 274 - change if(@clientAge>18) to if(@clientAge>=18) when determining if child or adult
**      04/07/2017      Pabitra                 Texas Customizations #58  Added code for Coloring the previously selected Checkboxes
/*      06 June  2017   Pabitra                 What: Modefied the Csp to show Previous Records 
                 								Why :Texas-Customizations #58 */
/*      06/07/2017          Pabitra             TxAce Customizations #22 */	                  										
/*      17 August 2017  Vijeta                  What: Modefied the Csp to show column 'MedicalRecordsRelevantResults' for "This visit's Relevant Results"
                 								Why :Camino - Support Go Live #525 */
*******************************************************************************/
BEGIN
	BEGIN TRY
		
		DECLARE @LatestDocumentVersionID INT
		DECLARE @ClientFirstName VARCHAR(max);
		DECLARE @PrimaryEpisodeWorkerID INT
		DECLARE @PrimaryEpisodeWorker VARCHAR(250)
		DECLARE @PrimaryEpisodeWorkerAge INT
		DECLARE @AgeOut VARCHAR(10)
		DECLARE @index INT
		DECLARE @UserCode VARCHAR(300)
		DECLARE @lastPlan VARCHAR(max)
		DECLARE @chiefComplaint VARCHAR(max)
		DECLARE @LabsLastOrdered VARCHAR(max)
		
		DECLARE @SubjectiveText  VARCHAR(max)
		DECLARE @PsychiatricHistoryComments VARCHAR(max)
		DECLARE @MedicalHistoryComments VARCHAR(max)
		DECLARE @FamilyHistoryComments VARCHAR(max)
		DECLARE @SocialHistoryComments VARCHAR(max)
		DECLARE @SubstanceUse VARCHAR(max)
		DECLARE @AllergiesSmoke VARCHAR(max)
		DECLARE @AllergiesSmokePerday VARCHAR(max)
		
		DECLARE @AllergiesTobacouse VARCHAR(max)
		DECLARE @AllergiesCaffeineConsumption VARCHAR(max)
		DECLARE @Pregnant VARCHAR(max)
		
		DECLARE @MedicalRecordsRelevantResults VARCHAR(max)
		DECLARE @MedicalRecordsPreviousResults VARCHAR(max)
		DECLARE @PresentingProblem VARCHAR(max)
		DECLARE @FULLCOMBINED VARCHAR(MAX)
		DECLARE @GENDER VARCHAR(50)
		DECLARE @clientAge varchar(10)
		DECLARE @LINEBREAK AS varchar(2)  
        SET @LINEBREAK = CHAR(13) + CHAR(10)  
        DECLARE @child_adult varchar(10)
        DECLARE @ReviewMusculoskeletal  CHAR(1)
        DECLARE @ReviewConstitutional  CHAR(1)
        DECLARE @ReviewEarNoseMouthThroat  CHAR(1)
        DECLARE @ReviewGenitourinary  CHAR(1)
        DECLARE @ReviewGastrointestinal  CHAR(1)
        DECLARE @ReviewIntegumentary  CHAR(1)
        DECLARE @ReviewEndocrine  CHAR(1)
        DECLARE @ReviewNeurological  CHAR(1)
        DECLARE @ReviewImmune  CHAR(1)
        DECLARE @ReviewEyes  CHAR(1)
        DECLARE @ReviewRespiratory  CHAR(1)
        DECLARE @ReviewCardio  CHAR(1)
        DECLARE @ReviewHemLymph  CHAR(1)
        DECLARE @ReviewOthersNegative  CHAR(1)
        DECLARE @ReviewComments  VARCHAR(max)
        DECLARE @lastOrdersComments VARCHAR(max)
        
        
        
		--PresentingProblem
		
	
		SELECT @UserCode = UserCode
		FROM Staff
		WHERE StaffId = @StaffID

		SELECT @ClientFirstName = isnull(FirstName, '')
		FROM Clients
		WHERE ClientId = @ClientID
		
		SELECT @GENDER = isnull(Sex, '')
		FROM Clients
		WHERE ClientId = @ClientID
		
	    SET	@clientAge=(SELECT dbo.[GetAge](C.DOB, GETDATE()) FROM ClientS C WHERE C.ClientId=@ClientID)
		--EXEC csp_CalculateAge @ClientId,@clientAge OUTPUT
		
		if(@clientAge>=18)
		begin
		set @child_adult='A'
		end
		else
		begin
		set @child_adult='C'
		end

		EXEC csp_GetLabsOrder @ClientID,@LabsLastOrdered OUTPUT

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

		SELECT @lastPlan = CONVERT(VARCHAR(10), CreatedDate, 101) + ' - ' + [PlanComment]
		FROM CustomDocumentPsychiatricNoteMDMs CDS
		WHERE CDS.DocumentVersionId = @LatestDocumentVersionID
		
		
		SELECT @lastOrdersComments = OrdersComments
		FROM CustomDocumentPsychiatricNoteMDMs CDS
		WHERE CDS.DocumentVersionId = @LatestDocumentVersionID
		
		DECLARE @NurseMonitorPillBox CHAR(1)
		DECLARE @NurseMonitorPillBoxcheck CHAR(1)
		
		SELECT @NurseMonitorPillBoxcheck = CDS.NurseMonitorPillBox
		FROM CustomDocumentPsychiatricNoteMDMs CDS
		WHERE CDS.DocumentVersionId = @LatestDocumentVersionID
		IF(@NurseMonitorPillBoxcheck='Y')
		BEGIN
		SET @NurseMonitorPillBox =@NurseMonitorPillBoxcheck
		END
		ELSE 
		BEGIN
		SET @NurseMonitorPillBox='N'
		END
		
		
        IF(@NurseMonitorPillBoxcheck='Y')
		BEGIN
        DECLARE @NurseMonitorComment VARCHAR(MAX)
        SELECT @NurseMonitorComment = CDS.NurseMonitorComment
		FROM CustomDocumentPsychiatricNoteMDMs CDS
		WHERE CDS.DocumentVersionId = @LatestDocumentVersionID
		END
		ELSE
		BEGIN
		SET @NurseMonitorComment=''
		END
		
		
		DECLARE @NurseMonitorFrequency INT
	    SELECT @NurseMonitorFrequency = CDS.NurseMonitorFrequency
		FROM CustomDocumentPsychiatricNoteMDMs CDS
		WHERE CDS.DocumentVersionId = @LatestDocumentVersionID
	
		
		SELECT  @chiefComplaint = ChiefComplaint,
		       @PsychiatricHistoryComments = PsychiatricHistoryComments,
		       @MedicalHistoryComments = MedicalHistoryComments,
		       @FamilyHistoryComments = FamilyHistoryComments,
		       @SocialHistoryComments = SocialHistoryComments,
		       @AllergiesSmoke = AllergiesSmoke,
		       @SubstanceUse = SubstanceUse,
		       @AllergiesSmokePerday = AllergiesSmokePerday,
		       @AllergiesTobacouse = AllergiesTobacouse,
		       @AllergiesCaffeineConsumption = AllergiesCaffeineConsumption,
		       @ReviewMusculoskeletal = ReviewMusculoskeletal,
		       @ReviewConstitutional =ReviewConstitutional,
		       @ReviewEarNoseMouthThroat=ReviewEarNoseMouthThroat,
		       @ReviewGenitourinary = ReviewGenitourinary,
		       @ReviewGastrointestinal = ReviewGastrointestinal,
		       @ReviewIntegumentary = ReviewIntegumentary,
		       @ReviewEndocrine =ReviewEndocrine,
		       @ReviewNeurological =ReviewNeurological,
		       @ReviewImmune = ReviewImmune,
		       @ReviewEyes = ReviewEyes,
		       @ReviewRespiratory = ReviewRespiratory,
		       @ReviewCardio = ReviewCardio,
		       @ReviewHemLymph = ReviewHemLymph,
		       @ReviewOthersNegative = ReviewOthersNegative,
		       @ReviewComments = ReviewComments
		FROM CustomDocumentPsychiatricNoteGenerals CDS
		WHERE CDS.DocumentVersionId = @LatestDocumentVersionID
		

		
		
if(@LatestDocumentVersionID =-1)

		begin
		 if(@GENDER ='F')
		   
		      begin
		      
		         if(@clientAge >55 or @clientAge <9)
		             BEGIN
		             set @Pregnant='A'
		             END
		      end
		    else
		        begin
		         set @Pregnant='A'
		        end   
		
		  
		 end
else
		 begin
		   SELECT @Pregnant = Pregnant
		      FROM CustomDocumentPsychiatricNoteGenerals CDS
		      WHERE CDS.DocumentVersionId = @LatestDocumentVersionID
		         
		  end
		
		SELECT @PresentingProblem = PresentingProblem
		FROM CustomDocumentPsychiatricNoteGenerals CDS
		WHERE CDS.DocumentVersionId = @LatestDocumentVersionID
		
        DECLARE @SideEffects  CHAR(1)
        	
        DECLARE @SideEffectsComments  VARCHAR(MAX)
          DECLARE @LastMenstrualPeriod  VARCHAR(MAX)

        SELECT @SideEffects = SideEffects,
               @SideEffectsComments=SideEffectsComments,
               @LastMenstrualPeriod=LastMenstrualPeriod
		FROM CustomDocumentPsychiatricNoteGenerals CDS
		WHERE CDS.DocumentVersionId = @LatestDocumentVersionID

			

		DECLARE @Count INT

		SET @Count = (
				SELECT Count(DocumentVersionId)
				FROM CustomPsychiatricNoteProblems CDS
				INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = CDS.ProblemStatus
					AND ISNULL(CDS.RecordDeleted, 'N') <> 'Y'
					AND ISNULL(GC.RecordDeleted, 'N') <> 'Y'
				WHERE DocumentVersionId = @LatestDocumentVersionID
					AND GC.CodeName <> 'Resolved'
				)

		SELECT 'CustomDocumentPsychiatricNoteGenerals' AS TableName
			,- 1 AS DocumentVersionId
			,@UserCode AS CreatedBy
			,GETDATE() AS CreratedDate
			,@UserCode AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,'Y' AS ReviewPsychiatric
			,@ReviewMusculoskeletal  AS ReviewMusculoskeletal
            ,@ReviewConstitutional  AS ReviewConstitutional
            ,@ReviewEarNoseMouthThroat AS ReviewEarNoseMouthThroat
            ,@ReviewGenitourinary  AS ReviewGenitourinary 
            ,@ReviewGastrointestinal  AS  ReviewGastrointestinal 
            ,@ReviewIntegumentary   AS ReviewIntegumentary
            ,@ReviewEndocrine   AS ReviewEndocrine
            ,@ReviewNeurological  AS  ReviewNeurological
            ,@ReviewImmune AS ReviewImmune 
            ,@ReviewEyes  AS ReviewEyes
            ,@ReviewRespiratory AS ReviewRespiratory 
            ,@ReviewCardio  AS ReviewCardio
            ,@ReviewHemLymph AS ReviewHemLymph
            ,@ReviewOthersNegative AS  ReviewOthersNegative 
            ,@ReviewComments AS ReviewComments 
			,@child_adult as AdultChildAdolescent 
			,@lastPlan AS PlanLastVisit
			,@chiefComplaint AS ChiefComplaint
			,@PsychiatricHistoryComments as PsychiatricHistoryComments
			,@FamilyHistoryComments as FamilyHistoryComments
			,@SocialHistoryComments as SocialHistoryComments
			,@MedicalHistoryComments as MedicalHistoryComments
			,@SubstanceUse as SubstanceUse
			,@AllergiesSmoke as AllergiesSmoke
			,@AllergiesSmokePerday as AllergiesSmokePerday
			,@AllergiesTobacouse as AllergiesTobacouse
			,@AllergiesCaffeineConsumption as AllergiesCaffeineConsumption
			,@Pregnant as Pregnant
			,@PresentingProblem as PresentingProblem
			,@SideEffects AS SideEffects
			,@SideEffectsComments  AS SideEffectsComments
			,@GENDER as Sex
			,@clientAge as Age
			,@LastMenstrualPeriod as LastMenstrualPeriod
			,@LatestDocumentVersionID AS LatestDocumentVersionID
		FROM systemconfigurations s
		LEFT JOIN CustomDocumentPsychiatricNoteGenerals CDS ON CDS.DocumentVersionId = @LatestDocumentVersionID

			SELECT 'CustomPsychiatricNoteProblems' AS TableName
				,- 1 AS DocumentVersionId
				,@UserCode AS CreatedBy
				,GETDATE() AS CreatedDate
				,@UserCode AS ModifiedBy
				,GETDATE() AS ModifiedDate
				,SubjectiveText
				,TypeOfProblem
				,Severity
				,Duration
				,TimeOfDayAllday
				,TimeOfDayMorning
				,TimeOfDayAfternoon
				,TimeOfDayNight
				,'' AS ContextOtherText
				,ContextText			--Added by sunil Camino - Support Go Live #241
				,LocationHome
				,LocationWork
				,LocationSchool
				,LocationEveryWhere
				,LocationOther
				,LocationOtherText
				,AssociatedSignsSymptoms
				,AssociatedSignsSymptomsOtherText
				,ModifyingFactors
			    ,ProblemStatus
			FROM systemconfigurations s
			LEFT JOIN CustomPsychiatricNoteProblems CDS ON CDS.DocumentVersionId = @LatestDocumentVersionID
		--END

		SELECT 'CustomDocumentPsychiatricNoteExams' AS TableName
		,- 1 AS DocumentVersionId
		,@UserCode AS CreatedBy
		,GETDATE() AS CreatedDate
		,@UserCode AS ModifiedBy
		,GETDATE() AS ModifiedDate
		,ReviewWithChanges
		,Speech
		,GeneralAppearance
		,PsychiatricNoteExamLanguage
		,MoodAndAffect
		,AttensionSpanAndConcentration
		,ThoughtContentCognision
		,Associations
		,AbnormalorPsychoticThoughts
		,Orientation
		,FundOfKnowledge
		,InsightAndJudgement
		,InsightAndJudgementStatus
		,Memory
		,MuscleStrengthorTone
		,GaitandStation
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
		,LanguageDifficultyNaming
		,LanguageDifficultyRepeating
		,MoodHappy
		,MoodSad
		,MoodAnxious
		,MoodAngry
		,MoodIrritable
		,MoodElation
		,MoodNormal
		,AffectEuthymic
		,AffectDysphoric
		,AffectAnxious
		,AffectIrritable
		,AffectBlunted
		,AffectLabile
		,AffectEuphoric
		,AffectCongruent
		,AttensionPoorAttension
		,AttensionDistractible
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
		,AssociationsLoose
		,AssociationsClanging
		,AssociationsWordsalad
		,AssociationsCircumstantial
		,AssociationsTangential
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
		,OrientationPerson
		,OrientationPlace
		,OrientationTime
		,OrientationSituation
		,FundOfKnowledgeCurrentEvents
		,FundOfKnowledgePastHistory
		,FundOfKnowledgeVocabulary
		,InsightAndJudgementSubstance
		,MuscleStrengthorToneAtrophy
		,MuscleStrengthorToneAbnormal
		,GaitandStationRestlessness
		,GaitandStationStaggered
		,GaitandStationShuffling
		,GaitandStationUnstable
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
		,Case GeneralPoorlyAddresses when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousGeneralPoorlyAddresses
		,Case GeneralPoorlyGroomed when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousGeneralPoorlyGroomed
		,Case GeneralDisheveled when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousGeneralDisheveled
		,Case GeneralOdferous when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousGeneralOdferous
		,Case GeneralDeformities when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousGeneralDeformities
		,Case GeneralPoorNutrion when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousGeneralPoorNutrion
		,Case GeneralRestless when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousGeneralRestless
		,Case GeneralPsychometer when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousGeneralPsychometer
		,Case GeneralHyperActive when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousGeneralHyperActive
		,Case GeneralEvasive when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousGeneralEvasive
		,Case GeneralInAttentive when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousGeneralInAttentive
		,Case GeneralPoorEyeContact when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousGeneralPoorEyeContact
		,Case GeneralHostile when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousGeneralHostile
		,Case SpeechIncreased when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousSpeechIncreased
		,Case SpeechDecreased when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousSpeechDecreased
		,Case SpeechPaucity when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousSpeechPaucity
		,Case SpeechHyperverbal when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousSpeechHyperverbal
		,Case SpeechPoorArticulations when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousSpeechPoorArticulations
		,Case SpeechLoud when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousSpeechLoud
		,Case SpeechSoft when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousSpeechSoft
		,Case SpeechMute when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousSpeechMute
		,Case SpeechStuttering when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousSpeechStuttering
		,Case SpeechImpaired when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousSpeechImpaired
		,Case SpeechPressured when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousSpeechPressured
		,Case SpeechFlight when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousSpeechFlight
		,Case LanguageDifficultyNaming when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousLanguageDifficultyNaming
		,Case LanguageDifficultyRepeating when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousLanguageDifficultyRepeating
		,Case MoodHappy when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousMoodHappy
		,Case MoodSad when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousMoodSad
		,Case MoodAnxious when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousMoodAnxious
		,Case MoodAngry when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousMoodAngry
		,Case MoodIrritable when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousMoodIrritable
		,Case MoodElation when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousMoodElation
		,Case MoodNormal when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousMoodNormal
		,Case AffectEuthymic when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousAffectEuthymic
		,Case AffectDysphoric when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousAffectDysphoric
		,Case AffectAnxious when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousAffectAnxious
		,Case AffectIrritable when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousAffectIrritable
		,Case AffectBlunted when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousAffectBlunted
		,Case AffectLabile when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousAffectLabile
		,Case AffectEuphoric when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousAffectEuphoric
		,Case AffectCongruent when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousAffectCongruent
		,Case AttensionPoorConcentration when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousAttensionPoorConcentration
		,Case AttensionPoorAttension when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousAttensionPoorAttension
		,Case AttensionDistractible when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousAttensionDistractible
		,Case TPDisOrganised when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousTPDisOrganised
		,Case TPBlocking when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousTPBlocking
		,Case TPPersecution when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousTPPersecution
		,Case TPBroadCasting when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousTPBroadCasting
		,Case TPDetrailed when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousTPDetrailed
		,Case TPThoughtinsertion when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousTPThoughtinsertion
		,Case TPIncoherent when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousTPIncoherent
		,Case TPRacing when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousTPRacing
		,Case TPIllogical when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousTPIllogical
		,Case TCDelusional when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousTCDelusional
		,Case TCParanoid when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousTCParanoid
		,Case TCIdeas when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousTCIdeas
		,Case TCThoughtInsertion when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousTCThoughtInsertion
		,Case TCThoughtWithdrawal when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousTCThoughtWithdrawal
		,Case TCThoughtBroadcasting when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousTCThoughtBroadcasting
		,Case TCReligiosity when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousTCReligiosity
		,Case TCGrandiosity when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousTCGrandiosity
		,Case TCPerserveration when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousTCPerserveration
		,Case TCObsessions when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousTCObsessions
		,Case TCWorthlessness when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousTCWorthlessness
		,Case TCLoneliness when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousTCLoneliness
		,Case TCGuilt when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousTCGuilt
		,Case TCHopelessness when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousTCHopelessness
		,Case TCHelplessness when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousTCHelplessness
		,Case CAPoorKnowledget when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousCAPoorKnowledget
		,Case CAConcrete when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousCAConcrete
		,Case CAUnable when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousCAUnable
		,Case CAPoorComputation when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousCAPoorComputation
		,Case AssociationsLoose when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousAssociationsLoose
		,Case AssociationsClanging when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousAssociationsClanging
		,Case AssociationsWordsalad when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousAssociationsWordsalad
		,Case AssociationsCircumstantial when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousAssociationsCircumstantial		
		,Case AssociationsTangential when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousAssociationsTangential
		,Case PDAuditoryHallucinations when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousPDAuditoryHallucinations
		,Case PDVisualHallucinations when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousPDVisualHallucinations		
		,Case PDCommandHallucinations when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousPDCommandHallucinations
		,Case PDDelusions when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousPDDelusions
		,Case PDPreoccupation when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousPDPreoccupation		
		,Case PDOlfactoryHallucinations when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousPDOlfactoryHallucinations
		,Case PDGustatoryHallucinations when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousPDGustatoryHallucinations
		,Case PDTactileHallucinations when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousPDTactileHallucinations	
		,Case PDSomaticHallucinations when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousPDSomaticHallucinations
		,Case PDIllusions when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousPDIllusions
		,Case OrientationPerson when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousOrientationPerson
		,Case OrientationPlace when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousOrientationPlace
		,Case OrientationTime when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousOrientationTime
		,Case OrientationSituation when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousOrientationSituation		
		,Case FundOfKnowledgeCurrentEvents when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousFundOfKnowledgeCurrentEvents
		,Case FundOfKnowledgePastHistory when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousFundOfKnowledgePastHistory
		,Case FundOfKnowledgeVocabulary when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousFundOfKnowledgeVocabulary		
		,Case InsightAndJudgementSubstance when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousInsightAndJudgementSubstance
		,Case MuscleStrengthorToneAtrophy when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousMuscleStrengthorToneAtrophy
		,Case MuscleStrengthorToneAbnormal when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousMuscleStrengthorToneAbnormal	
		,Case GaitandStationRestlessness when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousGaitandStationRestlessness
		,Case GaitandStationStaggered when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousGaitandStationStaggered
		,Case GaitandStationShuffling when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousGaitandStationShuffling
		,Case GaitandStationUnstable when 'Y'
		then 'Y'
		else 'N' end  
		AS PreviousGaitandStationUnstable
		,MentalStatusComments
		FROM systemconfigurations s
		LEFT JOIN CustomDocumentPsychiatricNoteExams CDS ON CDS.DocumentVersionId = @LatestDocumentVersionID
	
		
      SELECT @MedicalRecordsRelevantResults = MedicalRecordsRelevantResults
		FROM CustomDocumentPsychiatricNoteMDMs CDS
		WHERE CDS.DocumentVersionId = @LatestDocumentVersionID
		
		    SELECT @MedicalRecordsPreviousResults = MedicalRecordsPreviousResults
		FROM CustomDocumentPsychiatricNoteMDMs CDS
		WHERE CDS.DocumentVersionId = @LatestDocumentVersionID
	
		Declare @createddate1PR varchar(max)
		Declare @createddate1RR varchar(max)
		DECLARE @createddate varchar(max)
		set @createddate=( select  CONVERT(VARCHAR(10), CreatedDate, 101) as  CreatedDate FROM CustomDocumentPsychiatricNoteMDMs CDS
		WHERE CDS.DocumentVersionId = @LatestDocumentVersionID)
	
		
		IF(@MedicalRecordsPreviousResults IS NOT NULL)
		BEGIN
		SET @createddate1PR =@createddate +' :'
		END
		ELSE
		BEGIN
	    SET @createddate1PR=''
		END
		IF(@MedicalRecordsRelevantResults IS NOT NULL)
		BEGIN
			SET @createddate1RR =@createddate +' :'
		END
		ELSE
		BEGIN
		SET @createddate1RR =''
		END
	
	set @FULLCOMBINED= @createddate1RR  + ISNULL(@MedicalRecordsRelevantResults,'')+ @LINEBREAK + @createddate1PR+ ISNULL(@MedicalRecordsPreviousResults,'');


		SELECT 'CustomDocumentPsychiatricNoteMDMs' AS TableName
			,- 1 AS DocumentVersionId
			,@UserCode AS CreatedBy
			,GETDATE() AS CreatedDate
			,@UserCode AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,@lastPlan AS PlanLastVisitMDM
			,@lastOrdersComments AS LabsLastOrder
			,@lastOrdersComments AS MedicalRecordsLabsOrderedLastvisit
			--,@LabsLastOrdered as MedicalRecordsLabsOrderedLastvisit
			,@FULLCOMBINED as MedicalRecordsPreviousResults
			,case 
			when (MedicalRecordsRelevantResults IS NOT NULL)
			then @createddate +' :' +MedicalRecordsRelevantResults 
			else '' end as MedicalRecordsRelevantResults
			,'Y'as PatientConsent
			,'Y' as RisksBenefits
			,@NurseMonitorPillBox as NurseMonitorPillBox
			,@NurseMonitorComment  AS NurseMonitorComment
			,@NurseMonitorFrequency AS NurseMonitorFrequency
 		FROM systemconfigurations s
		LEFT JOIN CustomDocumentPsychiatricNoteMDMs CDS ON CDS.DocumentVersionId = @LatestDocumentVersionID

		--init aims
		--DECLARE @LatestDocumentVersionID INT
	DECLARE @EffectiveDate Datetime
	DECLARE @PreviousAIMSTotalScore INT
	
	   
           
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
    SELECT @PreviousAIMSTotalScore=AIMSTotalScore FROM CustomDocumentPsychiatricAIMSs WHERE DocumentVersionId=@LatestDocumentVersionID
	IF (@LatestDocumentVersionID is not null)
	BEGIN
	SELECT 'CustomDocumentPsychiatricAIMSs'  AS TableName
		,@LatestDocumentVersionID AS DocumentVersionId
		,@UserCode AS CreatedBy
		,GETDATE() AS CreatedDate
		,@UserCode AS ModifiedBy
		,GETDATE() AS ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,CONVERT(VARCHAR(12),@EffectiveDate,101) AS PreviousEffectiveDate
	,MuscleFacialExpression as PreviousMuscleFacialExpression
	,LipsPerioralArea as PreviousLipsPerioralArea
	,Jaw as PreviousJaw
	,Tongue as PreviousTongue
	,ExtremityMovementsUpper as PreviousExtremityMovementsUpper
	,ExtremityMovementsLower as PreviousExtremityMovementsLower
	,NeckShouldersHips as PreviousNeckShouldersHips
	,SeverityAbnormalMovements as PreviousSeverityAbnormalMovements
	,IncapacitationAbnormalMovements as PreviousIncapacitationAbnormalMovements
	,PatientAwarenessAbnormalMovements as PreviousPatientAwarenessAbnormalMovements
	,CurrentProblemsTeeth  as PreviousCurrentProblemsTeeth
	,DoesPatientWearDentures as PreviousDoesPatientWearDentures
	,@PreviousAIMSTotalScore as PreviousAIMSTotalScore 
	,AIMSPositveNegative AS PreviousAIMSPositveNegative
	FROM systemconfigurations s
	LEFT OUTER JOIN CustomDocumentPsychiatricAIMSs  ON DocumentVersionId = @LatestDocumentVersionID
	
	END
	ELSE
	BEGIN
      SET @LatestDocumentVersionId = - 1
      SELECT 'CustomDocumentPsychiatricAIMSs' AS TableName
		,- 1 AS DocumentVersionId
		,@UserCode AS CreatedBy
		,GETDATE() AS CreatedDate
		,@UserCode AS ModifiedBy
		,GETDATE() AS ModifiedDate
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
	    ,AIMSPositveNegative
	    ,SetDeafultForMovements
	FROM systemconfigurations s
	                   LEFT OUTER JOIN CustomDocumentPsychiatricAIMSs  ON DocumentVersionId = @LatestDocumentVersionID
    END
		--end

		SELECT 'CustomDocumentPsychiatricNoteChildAdolescents' AS TableName
			,- 1 AS DocumentVersionId
			,@UserCode AS CreatedBy
			,GETDATE() AS CreatedDate
			,@UserCode AS ModifiedBy
			,GETDATE() AS ModifiedDate
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
		FROM systemconfigurations s
		LEFT JOIN CustomDocumentPsychiatricNoteChildAdolescents CDS ON CDS.DocumentVersionId = @LatestDocumentVersionID

		EXEC ssp_InitCustomDiagnosisStandardInitializationNew @ClientID
			,@StaffID
			,@CustomParameters

		-----NoteEMCodeOptions
		SELECT TOP 1 'NoteEMCodeOptions' AS TableName
			,- 1 AS 'DocumentVersionId'
			,@UserCode AS CreatedBy
			,getdate() AS CreatedDate
			,@UserCode AS ModifiedBy
			,getdate() AS ModifiedDate
		FROM systemconfigurations s
		LEFT JOIN NoteEMCodeOptions ON s.Databaseversion = - 1
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_InitPsychiatricNote') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

