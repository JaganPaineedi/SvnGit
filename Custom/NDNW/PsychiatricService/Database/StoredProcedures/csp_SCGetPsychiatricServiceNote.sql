/****** Object:  StoredProcedure [dbo].[csp_SCGetPsychiatricServiceNote]    Script Date: 06/30/2014 18:07:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetPsychiatricServiceNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetPsychiatricServiceNote]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCGetPsychiatricServiceNote]    Script Date: 06/30/2014 18:07:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_SCGetPsychiatricServiceNote] @DocumentVersionId INT
AS
/*********************************************************************/
/* Stored Procedure: [csp_SCGetPsychiatricServiceNote]   */
/*       Date              Author                  Purpose                   */
/*      11-18-2014     Dhanil Manuel               To Retrieve Data           */
/*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @ClientId int                                                                                                                                                                                               
		SELECT @ClientId = ClientId from Documents where                                                                            
		InProgressDocumentVersionId = @DocumentVersionId and IsNull(RecordDeleted,'N')= 'N' 
        
        declare @PrimaryEpisodeWorkerID int
		declare @PrimaryEpisodeWorker Varchar(250)  
		declare @PrimaryEpisodeWorkerAge int  
		DECLARE @AgeOut varchar(10)    
		DECLARE @index int
		SELECT @PrimaryEpisodeWorkerID = PrimaryClinicianId from Clients where                                                                                                                                                                                         
		ClientId = @ClientID and IsNull(RecordDeleted,'N')= 'N'      

		Exec csp_CalculateAge @ClientID, @AgeOut out    

		set @index=(select CHARINDEX(' ', @AgeOut ))    
		set @PrimaryEpisodeWorkerAge = substring(@AgeOut,0,@index)    


		select @PrimaryEpisodeWorker=S.lastname +', '+ S.firstname  from Staff S
		where S.StaffId=@PrimaryEpisodeWorkerID and Isnull(S.RecordDeleted,'N') ='N'
        
        select 
        DocumentVersionId,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		NextPsychiatricAppointment,
		SummaryAndRecommendations,
		MedicationListAtTheTimeOfTransition,
	    cast(@PrimaryEpisodeWorker as varchar) as PrimaryEpisodeWorker,
        cast(@PrimaryEpisodeWorkerAge as varchar) as Age	
			
		FROM CustomDocumentPsychiatricServiceNoteGenerals
		WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted, 'N') = 'N'
		
		select 
		DocumentVersionId,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		NextPsychiatricAppointment,
		SummaryAndRecommendations,
		MedicationListAtTheTimeOfTransition,
		ChiefComplaint,
		SubjectiveAndObjective,
		AssessmentAndPlan,
		MedicalHistoryReviewedNoChanges,
		MedicalHistoryReviewedWithChanges,
		MedicalHistoryComments,
		FamilyHistoryReviewedNoChanges,
		FamilyHistoryReviewedWithChanges,
		FamilyHistoryComments,
		SocialHistoryReviewedNoChanges,
		SocialHistoryReviewedWithChanges,
		SocialHistoryComments,
		ReviewOfSystemPsych,
		ReviewOfSystemSomaticConcerns,
		ReviewOfSystemConstitutional,
		ReviewOfSystemEarNoseMouthThroat,
		ReviewOfSystemGI,
		ReviewOfSystemGU,
		ReviewOfSystemIntegumentary,
		ReviewOfSystemEndo,
		ReviewOfSystemNeuro,
		ReviewOfSystemImmune,
		ReviewOfSystemEyes,
		ReviewOfSystemResp,
		ReviewOfSystemCardioVascular,
		ReviewOfSystemHemLymph,
		ReviewOfSystemMusculo,
		ReviewOfSystemAllOthersNegative,
		ReviewOfSystemComments
		from
		CustomDocumentPsychiatricServiceNoteHistory
		WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted, 'N') = 'N'
		
		
		select
		PsychiatricServiceNoteProblemId,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		DocumentVersionId,
		ProblemText,
		Severity,
		Duration,
		Intensity,
		IntensityText,
		TimeOfDayMorning,
		TimeOfDayNoon,
		TimeOfDayAfternoon,
		TimeOfDayEvening,
		TimeOfDayNight,
		ContextHome,
		ContextSchool,
		ContextWork,
		ContextCommunity,
		ContextOther,
		ContextOtherText,
		AssociatedSignsSymptoms,
		AssociatedSignsSymptomsOtherText,
		ModifyingFactors,
		ProblemStatus
		from
		CustomPsychiatricServiceNoteProblems
		WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted, 'N') = 'N'
		
		select 
		DocumentVersionId,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		AppropriatelyDressed,
		GeneralAppearanceUnkept,
		GeneralAppearanceOther,
		GeneralAppearanceOtherText,
		MuscleStrengthNormal,
		MuscleStrengthAbnormal,
		MusculoskeletalTone,
		GaitNormal,
		GaitAbnormal,
		TicsTremorsAbnormalMovements,
		EPS,
		AppearanceBehavior,
		AppearanceBehaviorComments,
		Speech,
		SpeechComments,
		ThoughtProcess,
		ThoughtProcessComments,
		Associations,
		AssociationsComments,
		AbnormalPsychoticThoughts,
		AbnormalPsychoticThoughtsComments,
		JudgmentAndInsight,
		JudgmentAndInsightComments,
		Orientation,
		OrientationComments,
		RecentRemoteMemory,
		RecentRemoteMemoryComments,
		AttentionConcentration,
		AttentionConcentrationComments,
		[Language],
		LanguageCommments,
		FundOfKnowledge,
		FundOfKnowledgeComments,
		MoodAndAffect,
		MoodAndAffectComments
		from
		CustomDocumentPsychiatricServiceNoteExams
		WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted, 'N') = 'N'
		
		select 
		DocumentVersionId,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		MedicalRecords,
		DiagnosticTest,
		Labs,
		LabsSelected,
		MedicalRecordsComments,
		OrderedMedications,
		RisksBenefits,
		NewlyEmergentSideEffects,
		LabOrder,
		RadiologyOrder,
		Consultations,
		OrdersComments
		from
		CustomDocumentPsychiatricServiceNoteMDMs
		WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted, 'N') = 'N'
		
		--Diagnosis
		exec ssp_SCGetDataDiagnosisNew  @DocumentVersionId  
		
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
            WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted, 'N') = 'N'

	
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SCGetPsychiatricServiceNote') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


