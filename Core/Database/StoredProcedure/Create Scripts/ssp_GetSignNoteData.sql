IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = object_id(N'[dbo].[ssp_GetSignNoteData]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].ssp_GetSignNoteData
GO

CREATE PROCEDURE [dbo].[ssp_GetSignNoteData] @DocumentVersionId INT
	,@LoggedInUserId INT
AS /****************************************************************************
** Author:		Wasif Butt
** Create date: Nov, 14 2013
** Description:	Get Sign Note Screen Data
**	
**	Modifications:
**		Date			Author			Description
**	--------------	------------------	------------------------------------
**	6/4/2014		Wasif Butt		changes for Progress Note MDM section on signature popup
	16/11/2017		Sunil.D			What: Moved From 3.5x to 4.0X and Added ProgressNoteAddOnCodes table to it.
									Why:Andrews Center - Customizations Project #10
**  7/19/2017		Wasif Butt		adding MDMRCMMMOSToxicityMonitoring EI#453
**  8/29/2018		Shankha B 		Added logic for custom handler  
**  09/10/2018     Swatika          What/Why: Added two columns namely "MDMDEstablishedChronicProblems1" and "MDMDEstablishedChronicProblems2" in NoteEMCodeOptions table.
                                     as part of AHN-Customizations task #24.7
**  26/11/2018     Chita Ranjan      What: Added column called "OverrideProcedureCodeId" to NoteEMCodeOptions table.
                                     Why: Harbor Support task #1780
****************************************************************************/
BEGIN
	BEGIN TRY
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
			,ModifierId1
			,ModifierId2
			,ModifierId3
			,ModifierId4
			,ProgramId
			,LocationId
			,StartTime
			,EndTime
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
			,MDMRCMMMOSToxicityMonitoring
			,MDMDEstablishedChronicProblems1
			,MDMDEstablishedChronicProblems2
			,MDMRCMMPPAbruptChangeNeurological
			,OverrideProcedureCodeId
		FROM [NoteEMCodeOptions]
		WHERE (isnull(RecordDeleted, 'N') = 'N') 
			AND (DocumentVersionId = @DocumentVersionId)

		-- Added custom hook for the following section in order to allow flexibility to select procedure codes for E&M
		IF EXISTS (
				SELECT *
				FROM sys.objects
				WHERE object_id = OBJECT_ID(N'[dbo].[scsp_GetEMProcedureCodeAndAddOns]')
					AND type IN (
						N'P'
						,N'PC'
						)
				)
		BEGIN
			EXECUTE scsp_GetEMProcedureCodeAndAddOns @DocumentVersionId
				,@LoggedInUserId
		END
		ELSE -- The following portion is the CORE logic 
		BEGIN
			DECLARE @EffectiveDate DATETIME

			SELECT TOP 1 @EffectiveDate = EffectiveDate
			FROM dbo.Documents AS d
			WHERE InProgressDocumentVersionId = @DocumentVersionId

			SELECT ecpc.EMCodeProcedureCodeId
				,ecpc.CreatedBy
				,ecpc.CreatedDate
				,ecpc.ModifiedBy
				,ecpc.ModifiedDate
				,ecpc.RecordDeleted
				,ecpc.DeletedDate
				,ecpc.DeletedBy
				,ecpc.EMCode
				,ecpc.ProcedureCodeId
				,ecpc.Active
				,ecpc.EffectiveFrom
				,ecpc.EffectiveTo
				,pc.ProcedureCodeName AS ProcedureCodeName
				,pc.DisplayAs AS ProcedureCodeDisplayAs
			FROM dbo.EMCodeProcedureCodes AS ecpc
			JOIN dbo.ProcedureCodes AS pc ON ecpc.ProcedureCodeId = pc.ProcedureCodeId
			WHERE ecpc.Active = 'Y'
				AND isnull(ecpc.RecordDeleted, 'N') = 'N'
				AND pc.Active = 'Y'
				AND isnull(pc.RecordDeleted, 'N') = 'N'
				AND EffectiveFrom <= @EffectiveDate
				AND (
					EffectiveTo IS NULL
					OR EffectiveTo >= @EffectiveDate
					)

			SELECT ProgressNoteAddOnCodeId
				,P.CreatedBy
				,P.CreatedDate
				,P.ModifiedBy
				,P.ModifiedDate
				,P.RecordDeleted
				,P.DeletedBy
				,P.DeletedDate
				,P.DocumentVersionId
				,P.AddOnProcedureCodeId
				,P.AddOnServiceId
				,P.AddOnProcedureCodeStartTime
				,P.AddOnProcedureCodeUnit
				,P.AddOnProcedureCodeUnitType
				,PC.ProcedureCodeName AS AddOnProcedureCodeIdText
				,convert(VARCHAR(2), AddOnProcedureCodeStartTime, 108) AS DisplayStartTime
				,convert(VARCHAR(30), AddOnProcedureCodeUnit) AS UnitTypeDisplay
			FROM ProgressNoteAddOnCodes P
			JOIN ProcedureCodes PC ON PC.ProcedureCodeId = P.AddOnProcedureCodeId
			WHERE isnull(P.RecordDeleted, 'N') = 'N'
				AND isnull(PC.RecordDeleted, 'N') = 'N'
				AND P.DocumentVersionId = @DocumentVersionId
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = convert(VARCHAR, error_number()) + '*****' + convert(VARCHAR(4000), error_message()) + '*****' + isnull(convert(VARCHAR, error_procedure()), 'ssp_GetSignNoteData') + '*****' + convert(VARCHAR, error_line()) + '*****' + convert(VARCHAR, error_severity()) + '*****' + convert(VARCHAR, error_state())

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


