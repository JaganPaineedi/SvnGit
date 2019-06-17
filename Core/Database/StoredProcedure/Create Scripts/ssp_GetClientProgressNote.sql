IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[ssp_GetClientProgressNote]') 
                  AND type IN ( N'P', N'PC' )) 
  BEGIN 
      DROP PROCEDURE [dbo].[ssp_GetClientProgressNote]
  END 
  GO 
/****** Object:  StoredProcedure [dbo].[ssp_GetClientProgressNote]    Script Date: 08/27/2012 16:38:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE  [dbo].[ssp_GetClientProgressNote]
@DocumentVersionId INT          
AS 
/****************************************************************************
** Author:		Wasif Butt
** Create date: Nov, 22 2013
** Description:	Create service for the signed progress note
**	
**	Modifications:
**		Date			Author			Description
**	--------------	------------------	------------------------------------
**	6/4/2014		Wasif Butt		changes for Progress Note MDM section on signature popup
**	11/29/2017		Chethan N		What : Added Client Order Control get sp
									Why : Engineering Improvement Initiatives- NBL(I) task #585
****************************************************************************/           
BEGIN      
 BEGIN TRY
 
 --"DocumentProgressNotes"
SELECT  DocumentVersionId
      , CreatedBy
      , CreatedDate
      , ModifiedBy
      , ModifiedDate
      , RecordDeleted
      , DeletedDate
      , DeletedBy
      , TemplateID
      , ClientId
      , TemplateHTML
      , RDLHTML
      , TagsList
	    FROM [DocumentProgressNotes]
  WHERE     (ISNULL(RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId) 
  
  --"NoteEMCodeOptions"
select  [NoteEMCodeOptionId]
      , CreatedBy
      , CreatedDate
      , ModifiedBy
      , ModifiedDate
      , RecordDeleted
      , DeletedDate
      , DeletedBy
      , DocumentVersionId
      , ProcedureCodeId
      , ModifierId1
      , ModifierId2
      , ModifierId3
      , ModifierId4
      , ProgramId
      , LocationId
      , StartTime
      , EndTime
      , HistoryHPILocation
      , HistoryHPIDuration
      , HistoryHPIModifyingFactors
      , HistoryHPIContextOnset
      , HistoryHPIQualityNature
      , HistoryHPITimingFrequency
      , HistoryHPIAssociatedSignsSymptoms
      , HistoryHPISeverity
      , HistoryHPITotalCount
      , HistoryHPIResults
      , HistoryROSConstitutional
      , HistoryROSEarNoseMouthThroat
      , HistoryROSCardiovascular
      , HistoryROSRespiratory
      , HistoryROSSkin
      , HistoryROSPsychiatric
      , HistoryROSHematologicLymphatic
      , HistoryROSEye
      , HistoryROSGastrointestinal
      , HistoryROSGenitourinary
      , HistoryROSMusculoskeletal
      , HistoryROSNeurological
      , HistoryROSEndocrine
      , HistoryROSAllergicImmunologic
      , HistoryROSTotalCount
      , HistoryROSResults
      , HistoryPHFamilyHistory
      , HistoryPHSocialHistory
      , HistoryPHMedicalHistory
      , HistoryPHTotalCount
      , HistoryPHResults
      , HistoryFinalResult
      , ExamBAHead
      , ExamBABack
      , ExamBALeftUpperExtremity
      , ExamBALeftLowerExtremity
      , ExamBAAbdomen
      , ExamBANeck
      , ExamBAChest
      , ExamBARightUpperExtremity
      , ExamBARightLowerExtremity
      , ExamBAGenitaliaButtocks
      , ExamOSConstitutional
      , ExamOSEyes
      , ExamOSEarNoseMouthThroat
      , ExamOSCardiovascular
      , ExamOSRespiratory
      , ExamOSPsychiatric
      , ExamOSGastrointestinal
      , ExamOSGenitourinary
      , ExamOSMusculoskeletal
      , ExamOSSkin
      , ExamOSNeurologic
      , ExamOSHematologicLymphatic
      , ExamTypeOfExam
      , ExamFinalResult
      , MDMDRROClinicalLabs
      , MDMDRROOtherTest
      , MDMDRObtainRecords
      , MDMDRIndependentVisualization
      , MDMDRRORadiologyTest
      , MDMDRDiscussion
      , MDMDRReviewSummarize
      , MDMDRResults
      , MDMDTONewProblem
      , MDMDTOProblems1
      , MDMDTOProblems2
      , MDMDTOProblems3
      , MDMDTOProblems4Plus
      , MDMDTOAdditionalWorkup
      , MDMDTOProblemWorsening1
      , MDMDTOProblemWorsening2
      , MDMDTOResults
      , MDMRCMMResults
      , MDMFinalResult
      , ECEEMCode
      , ECEGuidelines
      , ECETypeOfPatient
      , ECEVisitType
      , ECE50PercentFaceTime
      , ECEMinutes
      , ECAQChronicProblemsAddressed3Plus
      , ECAQAdditionalWorkup
      , ECAQProblemWorsening1
      , ECAQProblemWorsening2
      , ECAQIllnessWithExacerbation
      , ECAQDiscussion
      , ECAQObtainRecords
      , ECAQIndependentVisualization
      , ECAQReviewSummarize
      , ExamBAHeadCount
      , ExamBAHeadTotalCount
      , ExamBABackCount
      , ExamBABackTotalCount
      , ExamBALeftUpperExtremityCount
      , ExamBALeftUpperExtremityTotalCount
      , ExamBALeftLowerExtremityCount
      , ExamBALeftLowerExtremityTotalCount
      , ExamBAAbdomenCount
      , ExamBAAbdomenTotalCount
      , ExamBANeckCount
      , ExamBANeckTotalCount
      , ExamBAChestCount
      , ExamBAChestTotalCount
      , ExamBARightUpperExtremityCount
      , ExamBARightUpperExtremityTotalCount
      , ExamBARightLowerExtremityCount
      , ExamBARightLowerExtremityTotalCount
      , ExamBAGenitaliaButtocksCount
      , ExamBAGenitaliaButtocksTotalCount
      , ExamOSConstitutionalCount
      , ExamOSConstitutionalTotalCount
      , ExamOSEyesCount
      , ExamOSEyesTotalCount
      , ExamOSEarNoseMouthThroatCount
      , ExamOSEarNoseMouthThroatTotalCount
      , ExamOSCardiovascularCount
      , ExamOSCardiovascularTotalCount
      , ExamOSRespiratoryCount
      , ExamOSRespiratoryTotalCount
      , ExamOSPsychiatricCount
      , ExamOSPsychiatricTotalCount
      , ExamOSGastrointestinalCount
      , ExamOSGastrointestinalTotalCount
      , ExamOSGenitourinaryCount
      , ExamOSGenitourinaryTotalCount
      , ExamOSMusculoskeletalCount
      , ExamOSMusculoskeletalTotalCount
      , ExamOSSkinCount
      , ExamOSSkinTotalCount
      , ExamOSNeurologicCount
      , ExamOSNeurologicTotalCount
      , ExamOSHematologicLymphaticCount
      , ExamOSHematologicLymphaticTotalCount
	  , MDMRCMMPPMinorOtherProb1
      , MDMRCMMPPMinorOtherProb2Plus
      , MDMRCMMPPStableChronicMajor1
      , MDMRCMMPPChronicMajorMildExac1Plus
      , MDMRCMMPPAcuteUncomplicated1
      , MDMRCMMPPNewProblem
      , MDMRCMMPPAcuteIllness
      , MDMRCMMPPAcuteComplicatedInjury
      , MDMRCMMPPChronicMajorSevereExac1Plus
      , MDMRCMMPPAcuteChronicThreat
      , MDMRCMMDLabVenipuncture
      , MDMRCMMDNonCardImaging
      , MDMRCMMDPhysTestNoStress
      , MDMRCMMDPhysTestYesStress
      , MDMRCMMDSkinBiopsies
      , MDMRCMMDDeepNeedle
      , MDMRCMMDDiagEndoNoRisk
      , MDMRCMMDDiagEndoYesRisk
      , MDMRCMMDCardImagingNoRisk
      , MDMRCMMDCardImagingYesRisk
      , MDMRCMMDClinicalLab
      , MDMRCMMDObtainFluid
      , MDMRCMMDCardiacElectro
      , MDMRCMMDDiscopgraphy
      , MDMRCMMMOSMedicationManagement
  FROM [NoteEMCodeOptions]
  WHERE     (ISNULL(RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId)     
      
    EXEC ssp_GetClientOrders @DocumentVersionId  
  
          
END TRY    
    
BEGIN CATCH          
 DECLARE @Error VARCHAR(8000)           
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_GetClientProgressNote')                                                                                                 
   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                  
   + '*****' + CONVERT(VARCHAR,ERROR_STATE())    
  RAISERROR    
  (    
   @Error, -- Message text.    
   16,  -- Severity.    
   1  -- State.    
  );    
END CATCH                
END 