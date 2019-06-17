IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetIncidentReport]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_GetIncidentReport]-- 63
GO

CREATE PROCEDURE [dbo].[csp_GetIncidentReport] (@IncidentReportId INT)
AS
/********************************************************************************                                                       
--      
-- Copyright: Streamline Healthcare Solutions      
/*    Date        Author            Purpose */
    
*********************************************************************************/
BEGIN TRY
	
	SELECT CIR.IncidentReportId
		,CIR.CreatedBy
		,CIR.CreatedDate
		,CIR.ModifiedBy
		,CIR.ModifiedDate
		,CIR.RecordDeleted
		,CIR.DeletedBy
		,CIR.DeletedDate
		,CIR.IncidentReportDetailId
		,CIR.IncidentReportFollowUpOfIndividualStatusId
		,CIR.IncidentReportSupervisorFollowUpId
		,CIR.IncidentReportAdministratorReviewId
		,CIR.IncidentReportFallDetailId
		,CIR.IncidentReportFallFollowUpOfIndividualStatusId
		,CIR.IncidentReportFallSupervisorFollowUpId
		,CIR.IncidentReportFallAdministratorReviewId
		,CIR.IncidentSeizureDetailId
		,CIR.IncidentReportSeizureFollowUpOfIndividualStatusId
		,CIR.IncidentReportSeizureSupervisorFollowUpId
		,CIR.IncidentReportSeizureAdministratorReviewId
		,CIR.DetailVersionStatus
		,CIR.FollowUpOfIndividualStatusVersionStatus
		,CIR.SupervisorFollowUpVersionStatus
		,CIR.AdministratorReviewVersionStatus
		,CIR.FallDetailVersionStatus
		,CIR.FallFollowUpOfIndividualStatusVersionStatus
		,CIR.FallSupervisorFollowUpVersionStatus
		,CIR.FallAdministratorReviewVersionStatus
		,CIR.SeizureDetailVersionStatus
		,CIR.SeizureFollowUpOfIndividualStatusVersionStatus
		,CIR.SeizureSupervisorFollowUpVersionStatus
		,CIR.SeizureAdministratorReviewVersionStatus
		,CIR.ClientId
		,CIR.ClientId as ID
		,C.LastName+','+C.FirstName as Individual
		,CONVERT(VARCHAR(10), C.DOB, 101) As DOB
		,CIR.IncidentReportManagerFollowUpId
		,CIR.IncidentReportSeizureManagerFollowUpId
		,CIR.IncidentReportFallManagerFollowUpId
		,CIR.ManagerFollowUpStatus
		,CIR.SeizureManagerFollowUpStatus
		,CIR.FallManagerFollowUpStatus
	FROM CustomIncidentReports CIR
	left join Clients C On C.ClientId=CIR.ClientId
	WHERE ISNull(CIR.RecordDeleted, 'N') = 'N'	AND IncidentReportId = @IncidentReportId
		
		
	SELECT CIRG.IncidentReportGeneralId
		,CIRG.CreatedBy
		,CIRG.CreatedDate
		,CIRG.ModifiedBy
		,CIRG.ModifiedDate
		,CIRG.RecordDeleted
		,CIRG.DeletedBy
		,CIRG.DeletedDate
		,CIRG.IncidentReportId
		,CIRG.GeneralProgram
		,CIRG.GeneralDateOfIncident
		, CIRG.GeneralTimeOfIncident
		,CIRG.GeneralResidence
		,CIRG.GeneralDateStaffNotified
		,CIRG.GeneralSame
		,CIRG.GeneralTimeStaffNotified
		,CIRG.GeneralLocationOfIncident
		,CIRG.GeneralLocationDetails
		,CIRG.GeneralLocationDetailsText
		,CIRG.GeneralIncidentCategory
		,CIRG.GeneralSecondaryCategory
		,G.CodeName AS GeneralIncidentCategoryText
		,G.Code AS GeneralIncidentCategoryCode
		,CIRG.GeneralSecondaryCategory
		,SG.SubCodeName AS GeneralSecondaryCategoryText
		,SG.Code AS GeneralSecondaryCategoryCode
	FROM CustomIncidentReportGenerals CIRG
	LEFT JOIN GlobalCodes G ON G.GlobalCodeId = GeneralIncidentCategory
	LEFT JOIN GlobalSubCodes SG ON SG.GlobalSubCodeId = CIRG.GeneralSecondaryCategory
	WHERE ISNull(CIRG.RecordDeleted, 'N') = 'N'
		AND ISNull(G.RecordDeleted, 'N') = 'N'
		AND CIRG.IncidentReportId = @IncidentReportId

	SELECT top 1
	CI.IncidentReportDetailId
	,CI.CreatedBy
	,CI.CreatedDate
	,CI.ModifiedBy
	,CI.ModifiedDate
	,CI.RecordDeleted
	,CI.DeletedBy
	,CI.DeletedDate
	,CI.IncidentReportId
	,CI.DetailsStaffNotifiedForInjury
	,CASE WHEN ISNULL(CI.SignedBy,'') = '' THEN '' ELSE ISNULL(S.LastName, '') + ', ' + ISNULL(S.FirstName, '') end as  StaffName
	,CI.SignedBy
	,CI.DetailsDescriptionOfincident
	,CI.DetailsActionsTakenByStaff
	,CI.DetailsWitnesses
	,CI.DetailsDateStaffNotified
	,CI.DetailsTimestaffNotified
	,CI.DetailsNoMedicalStaffNotified
	,SignedDate
	,CI.PhysicalSignature
	,CI.CurrentStatus
	,CI.InProgressStatus
	,CI.DetailsSupervisorFlaggedId
 FROM CustomIncidentReportDetails  CI
  left JOIN Staff S ON S.StaffId= CI.SignedBy  
 WHERE ISNull(CI.RecordDeleted, 'N') = 'N'  
  AND CI.IncidentReportId =   @IncidentReportId
  order by CI.IncidentReportDetailId desc

	SELECT top 1
	CR.IncidentReportFollowUpOfIndividualStatusId
	,CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
	,CR.FollowUpIndividualStatusNurseStaffEvaluating
	,CR.FollowUpIndividualStatusStaffCompletedNotification
	,CASE WHEN ISNULL(CR.SignedBy,'') = '' THEN '' ELSE ISNULL(S.LastName, '') + ', ' + ISNULL(S.FirstName, '') end as  StaffName
	,CR.SignedBy
	,CR.FollowUpIndividualStatusCredentialTitle
	,CR.FollowUpIndividualStatusDetailsOfInjury
	,CR.FollowUpIndividualStatusComments
	,CR.FollowUpIndividualStatusFamilyGuardianCustodianNotified
	,CR.FollowUpIndividualStatusDateOfNotification
	,CR.FollowUpIndividualStatusTimeOfNotification
	,CR.FollowUpIndividualStatusNameOfFamilyGuardianCustodian
	,CR.FollowUpIndividualStatusDetailsOfNotification
	,CR.SignedDate
	,CR.PhysicalSignature
	,CR.CurrentStatus
	,CR.InProgressStatus
	,NoteType
	,NoteStart
	,NoteEnd
	,NoteComment
	FROM CustomIncidentReportFollowUpOfIndividualStatuses CR
	 left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		AND IncidentReportId = @IncidentReportId
		order by CR.IncidentReportFollowUpOfIndividualStatusId desc

	SELECT top 1
	CR.IncidentReportSupervisorFollowUpId
	,CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
	,CR.SupervisorFollowUpSupervisorName
	,CR.SupervisorFollowUpAdministrator
	,CR.SupervisorFollowUpStaffCompletedNotification
	,CASE WHEN ISNULL(CR.SignedBy,'') = '' THEN '' ELSE ISNULL(S.LastName, '') + ', ' + ISNULL(S.FirstName, '') end as  StaffName
	,CR.SignedBy
	,CR.SupervisorFollowUpFollowUp
	,CR.SupervisorFollowUpAdministratorNotified
	,CR.SupervisorFollowUpAdminDateOfNotification
	,CR.SupervisorFollowUpAdminTimeOfNotification
	,CR.SupervisorFollowUpFamilyGuardianCustodianNotified
	,CR.SupervisorFollowUpFGCDateOfNotification
	,CR.SupervisorFollowUpFGCTimeOfNotification
	,CR.SupervisorFollowUpNameOfFamilyGuardianCustodian
	,CR.SupervisorFollowUpDetailsOfNotification
	,CR.SupervisorFollowUpAggressionPhysical
	,CR.SupervisorFollowUpAggressionVerbal
	,CR.SupervisorFollowUpBehavioralRestraint
	,CR.SupervisorFollowUpElopementOffCampus
	,CR.SupervisorFollowUpElopementOnCampus
	,CR.SupervisorFollowUpContraband
	,CR.SupervisorFollowUpPropertyDamage
	,CR.SupervisorFollowUpPropertyDestruction
	,CR.SupervisorFollowUpSearchSeizure
	,CR.SupervisorFollowUpSelfInjury
	,CR.SupervisorFollowUpSuicideAttempt
	,CR.SupervisorFollowUpSuicideThreatGesture
	,CR.SupervisorFollowUpOutbreakOfDisease
	,CR.SupervisorFollowUpIllness
	,CR.SupervisorFollowUpHospitalizationMedical
	,CR.SupervisorFollowUpHospitalizationPsychiatric
	,CR.SupervisorFollowUpTripToER
	,CR.SupervisorFollowUpAllegedAbuse
	,CR.SupervisorFollowUpMisuseOfFundsProperty
	,CR.SupervisorFollowUpViolationOfRights
	,CR.SupervisorFollowUpIndividualToIndividualInjury
	,CR.SupervisorFollowUpInjury
	,CR.SupervisorFollowUpInjuryFromRestraint
	,CR.SupervisorFollowUpFireDepartmentInvolvement
	,CR.SupervisorFollowUpPoliceInvolvement
	,CR.SupervisorFollowUpChokingSwallowingDifficulty
	,CR.SupervisorFollowUpDeath
	,CR.SupervisorFollowUpDrugUsePossession
	,CR.SupervisorFollowUpOutOfProgramArea
	,CR.SupervisorFollowUpSexualIncident
	,CR.SupervisorFollowUpOther
	,CR.SupervisorFollowUpOtherComments
	,CR.SignedDate
	,CR.PhysicalSignature
	,CR.CurrentStatus
	,CR.InProgressStatus
	,CR.SupervisorFollowUpManagerNotified
	,CR.SupervisorFollowUpManager
	,CR.SupervisorFollowUpManagerDateOfNotification
	,CR.SupervisorFollowUpManagerTimeOfNotification
	FROM CustomIncidentReportSupervisorFollowUps CR
	left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		AND CR.IncidentReportId = @IncidentReportId
		order by CR.IncidentReportSupervisorFollowUpId desc

	SELECT top 1
	CR.IncidentReportAdministratorReviewId
	,CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
	,CR.AdministratorReviewAdministrator
	,CASE WHEN ISNULL(CR.SignedBy,'') = '' THEN '' ELSE ISNULL(S.LastName, '') + ', ' + ISNULL(S.FirstName, '') end as  StaffName
	,CR.SignedBy
	,CR.AdministratorReviewAdministrativeReview
	,CR.AdministratorReviewFiledReportableIncident
	,CR.AdministratorReviewComments
	,CR.SignedDate
	,CR.PhysicalSignature
	,CR.CurrentStatus
	,CR.InProgressStatus
	FROM CustomIncidentReportAdministratorReviews CR
	left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		AND IncidentReportId = @IncidentReportId
		order by CR.IncidentReportAdministratorReviewId desc

	SELECT top 1
	CR.IncidentReportFallDetailId
	,CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
	,CASE WHEN ISNULL(CR.SignedBy,'') = '' THEN '' ELSE ISNULL(S.LastName, '') + ', ' + ISNULL(S.FirstName, '') end as  StaffName
	,CR.SignedBy
	,CR.FallDetailsDescribeIncident
	,CR.FallDetailsCauseOfIncident
	,CR.FallDetailsCauseOfIncidentText
	,CR.FallDetailsNone
	,CR.FallDetailsCane
	,CR.FallDetailsSeatLapBelt
	,CR.FallDetailsWheelchair
	,CR.FallDetailsGaitBelt
	,CR.FallDetailsWheellchairTray
	,CR.FallDetailsWalker
	,CR.FallDetailsMafosBraces
	,CR.FallDetailsHelmet
	,CR.FallDetailsChestHarness
	,CR.FallDetailsOther
	,CR.FallDetailsOtherText
	,CR.FallDetailsIncidentOccurredWhile
	,CR.FallDetailsFootwearAtTimeOfIncident
	,CR.FallDetailsWheelsLocked
	,CR.FallDetailsWhereBedWheelsUnlocked
	,CR.FallDetailsNA
	,CR.FallDetailsFullLength
	,CR.FallDetails2Half
	,CR.FallDetails4Half
	,CR.FallDetailsBothSidesUp
	,CR.FallDetailsOneSideUp
	,CR.FallDetailsBumperPads
	,CR.FallDetailsFurtherDescription
	,CR.FallDetailsFurtherDescriptiontext
	,CR.FallDetailsWasAnAlarmPresent
	,CR.FallDetailsAlarmSoundedDuringIncident
	,CR.FallDetailsAlarmDidNotSoundDuringIncident
	,CR.FallDetailsBedMat
	,CR.FallDetailsBeam
	,CR.FallDetailsBabyMonitor
	,CR.FallDetailsFloorMat
	,CR.FallDetailsMagneticClip
	,CR.FallDetailsTypeOfAlarmOtherText
	,CR.FallDetailsTypeOfAlarmOther
	,CR.FallDetailsDescriptionOfincident
	,CR.FallDetailsActionsTakenByStaff
	,CR.FallDetailsWitnesses
	,CR.FallDetailsStaffNotifiedForInjury
	,CR.FallDetailsDateStaffNotified
	,CR.FallDetailsTimestaffNotified
	,CR.FallDetailsNoMedicalStaffNotified
	,CR.SignedDate
	,CR.PhysicalSignature
	,CR.CurrentStatus
	,CR.InProgressStatus
	,CR.FallDetailsSupervisorFlaggedId
	FROM CustomIncidentReportFallDetails CR
	left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		AND IncidentReportId = @IncidentReportId
		order by CR.IncidentReportFallDetailId desc

	SELECT top 1
	IncidentReportFallFollowUpOfIndividualStatusId
	,CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
	,CASE WHEN ISNULL(CR.SignedBy,'') = '' THEN '' ELSE ISNULL(S.LastName, '') + ', ' + ISNULL(S.FirstName, '') end as  StaffName
	,FallFollowUpIndividualStatusNurseStaffEvaluating
	,FallFollowUpIndividualStatusStaffCompletedNotification
	,SignedBy
	,FallFollowUpIndividualStatusCredentialTitle
	,FallFollowUpIndividualStatusDetailsOfInjury
	,FallFollowUpIndividualStatusNoTreatmentNoInjury
	,FallFollowUpIndividualStatusFirstAidOnly
	,FallFollowUpIndividualStatusMonitor
	,FallFollowUpIndividualStatusToPrimaryCareProviderClinicEvaluation
	,FallFollowUpIndividualStatusToEmergencyRoom
	,FallFollowUpIndividualStatusOther
	,FallFollowUpIndividualStatusOtherText
	,FallFollowUpIndividualStatusComments
	,FallFollowUpIndividualStatusFamilyGuardianCustodianNotified
	,FallFollowUpIndividualStatusDateOfNotification
	,FallFollowUpIndividualStatusTimeOfNotification
	,FallFollowUpIndividualStatusNameOfFamilyGuardianCustodian
	,FallFollowUpIndividualStatusDetailsOfNotification
	,SignedDate
	,PhysicalSignature
	,CurrentStatus
	,InProgressStatus
	,NoteType
	,NoteStart
	,NoteEnd
	,NoteComment
	FROM CustomIncidentReportFallFollowUpOfIndividualStatuses CR
	left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		AND IncidentReportId = @IncidentReportId
	order by CR.IncidentReportFallFollowUpOfIndividualStatusId desc

	SELECT top 1 
	IncidentReportFallSupervisorFollowUpId
	,CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
	,CASE WHEN ISNULL(CR.SignedBy,'') = '' THEN '' ELSE ISNULL(S.LastName, '') + ', ' + ISNULL(S.FirstName, '') end as  StaffName
	,FallSupervisorFollowUpSupervisorName
	,FallSupervisorFollowUpAdministrator
	,FallSupervisorFollowUpStaffCompletedNotification
	,SignedBy
	,FallSupervisorFollowUpFollowUp
	,FallSupervisorFollowUpAdministratorNotified
	,FallSupervisorFollowUpAdminDateOfNotification
	,FallSupervisorFollowUpAdminTimeOfNotification
	,FallSupervisorFollowUpFamilyGuardianCustodianNotified
	,FallSupervisorFollowUpFGCDateOfNotification
	,FallSupervisorFollowUpFGCTimeOfNotification
	,FallSupervisorFollowUpNameOfFamilyGuardianCustodian
	,FallSupervisorFollowUpDetailsOfNotification
	,SignedDate
	,PhysicalSignature
	,CurrentStatus
	,InProgressStatus
	,CR.SupervisorFollowUpManagerNotified
	,CR.SupervisorFollowUpManager
	,CR.SupervisorFollowUpManagerDateOfNotification
	,CR.SupervisorFollowUpManagerTimeOfNotification
	FROM CustomIncidentReportFallSupervisorFollowUps CR
	left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		AND IncidentReportId = @IncidentReportId
	order by IncidentReportFallSupervisorFollowUpId desc
 
	SELECT top 1
	IncidentReportFallAdministratorReviewId
	,CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
	,CASE WHEN ISNULL(CR.SignedBy,'') = '' THEN '' ELSE ISNULL(S.LastName, '') + ', ' + ISNULL(S.FirstName, '') end as  StaffName
	,FallAdministratorReviewAdministrator
	,SignedBy
	,FallAdministratorReviewAdministrativeReview
	,FallAdministratorReviewFiledReportableIncident
	,FallAdministratorReviewComments
	,SignedDate
	,PhysicalSignature
	,CurrentStatus
	,InProgressStatus
	FROM CustomIncidentReportFallAdministratorReviews CR
	left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		AND IncidentReportId = @IncidentReportId
	order by IncidentReportFallAdministratorReviewId desc
	
	SELECT IncidentReportSeizureDetailId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,IncidentReportId
		,SeizureDetailsSweating
		,SeizureDetailsUrinaryFecalIncontinence
		,SeizureDetailsTonicStiffnessOfArms
		,SeizureDetailsTonicStiffnessOfLegs
		,SeizureDetailsClonicTwitchingOfArms
		,SeizureDetailsClonicTwitchingOfLegs
		,SeizureDetailsPupilsDilated
		,SeizureDetailsAnyAbnormalEyeMovements
		,SeizureDetailsPostictalPeriod
		,SeizureDetailsVagalNerveStimulator
		,SeizureDetailsSwipedMagnet
		,SeizureDetailsNumberOfSwipes
		,SeizureDetailsPulseRate
		,SeizureDetailsBreathing
		,SeizureDetailsColor
		,SeizureDetailsTurnClientsHeadSide
		,SeizureDetailsClientSuctioned
		,SeizureDetailsClothingLoosended
		,SeizureDetailsAirwayCleared
		,SeizureDetailsO2Given
		,SeizureDetailsLiterMin
		,SeizureDetailsAreaCleared
		,SeizureDetailsPlacedClientOnTheFloor
		,SeizureDetailsEmergencyMedicationsGiven
		,SeizureDetailsPutClientToBed
		,SeizureDetailsNotescomments
	FROM CustomIncidentReportSeizureDetails
	WHERE ISNull(RecordDeleted, 'N') = 'N'
		AND IncidentReportId = @IncidentReportId

	SELECT CIRS.IncidentReportSeizureId
		,CIRS.CreatedBy
		,CIRS.CreatedDate
		,CIRS.ModifiedBy
		,CIRS.ModifiedDate
		,CIRS.RecordDeleted
		,CIRS.DeletedBy
		,CIRS.DeletedDate
		,CIRS.IncidentReportSeizureDetailId
		,CIRS.TimeOfSeizure
		,CIRS.DurationOfSeizureMin
		,CIRS.DurationOfSeizureSec
		,Cast(CIRS.DurationOfSeizureMin AS VARCHAR) + ' ' + CASE 
			WHEN CIRS.DurationOfSeizureMin = 1
				THEN 'minute'
			ELSE 'minutes'
			END + ' ' + cast(CIRS.DurationOfSeizureSec AS VARCHAR) + '' + CASE 
			WHEN CIRS.DurationOfSeizureSec = 1
				THEN 'second'
			ELSE 'seconds'
			END AS DurationOfSeizure
		,cast(ROW_NUMBER() OVER (
				ORDER BY CIRS.IncidentReportSeizureId
				) AS INT) AS NoOfSeizure
	FROM CustomIncidentReportSeizures CIRS
	LEFT JOIN CustomIncidentReportSeizureDetails CIRSD ON CIRSD.IncidentReportSeizureDetailId = CIRS.IncidentReportSeizureDetailId
	WHERE ISNull(CIRS.RecordDeleted, 'N') = 'N'
		AND CIRSD.IncidentReportId = @IncidentReportId

	SELECT top 1
	IncidentSeizureDetailId
	,CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
	,CASE WHEN ISNULL(CR.SignedBy,'') = '' THEN '' ELSE ISNULL(S.LastName, '') + ', ' + ISNULL(S.FirstName, '') end as  StaffName
	,IncidentSeizureDetailsStaffNotifiedForInjury
	,SignedBy
	,IncidentSeizureDetailsDescriptionOfIncident
	,IncidentSeizureDetailsActionsTakenByStaff
	,IncidentSeizureDetailsWitnesses
	,IncidentSeizureDetailsDateStaffNotified
	,IncidentSeizureDetailsTimeStaffNotified
	,IncidentSeizureDetailsNoMedicalStaffNotified
	,SignedDate
	,PhysicalSignature
	,CurrentStatus
	,InProgressStatus
	,IncidentSeizureDetailsSupervisorFlaggedId
	FROM CustomIncidentSeizureDetails CR
	left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		AND IncidentReportId = @IncidentReportId
	order by IncidentSeizureDetailId desc
	
	SELECT top 1
	IncidentReportSeizureFollowUpOfIndividualStatusId
	,CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
	,CASE WHEN ISNULL(CR.SignedBy,'') = '' THEN '' ELSE ISNULL(S.LastName, '') + ', ' + ISNULL(S.FirstName, '') end as  StaffName
	,SeizureFollowUpIndividualStatusNurseStaffEvaluating
	,SeizureFollowUpIndividualStatusStaffCompletedNotification
	,SignedBy
	,SeizureFollowUpIndividualStatusCredentialTitle
	,SeizureFollowUpIndividualStatusDetailsOfInjury
	,SeizureFollowUpIndividualStatusComments
	,SeizureFollowUpIndividualStatusFamilyGuardianCustodianNotified
	,SeizureFollowUpIndividualStatusDateOfNotification
	,SeizureFollowUpIndividualStatusTimeOfNotification
	,SeizureFollowUpIndividualStatusNameOfFamilyGuardianCustodian
	,SeizureFollowUpIndividualStatusDetailsOfNotification
	,SignedDate
	,PhysicalSignature
	,CurrentStatus
	,InProgressStatus
	,SeizureDetailsO2Given
	,SeizureDetailsLiterMin
	,SeizureDetailsEmergencyMedicationsGiven
	,NoteType
	,NoteStart
	,NoteEnd
	,NoteComment
	FROM CustomIncidentReportSeizureFollowUpOfIndividualStatuses CR
	left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		AND IncidentReportId = @IncidentReportId
	order by IncidentReportSeizureFollowUpOfIndividualStatusId desc
	

	SELECT top 1
	IncidentReportSeizureSupervisorFollowUpId
	,CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
	,CASE WHEN ISNULL(CR.SignedBy,'') = '' THEN '' ELSE ISNULL(S.LastName, '') + ', ' + ISNULL(S.FirstName, '') end as  StaffName
	,SeizureSupervisorFollowUpSupervisorName
	,SeizureSupervisorFollowUpAdministrator
	,SeizureSupervisorFollowUpStaffCompletedNotification
	,SignedBy
	,SeizureSupervisorFollowUpFollowUp
	,SeizureSupervisorFollowUpAdministratorNotified
	,SeizureSupervisorFollowUpAdminDateOfNotification
	,SeizureSupervisorFollowUpAdminTimeOfNotification
	,SeizureSupervisorFollowUpFamilyGuardianCustodianNotified
	,SeizureSupervisorFollowUpFGCDateOfNotification
	,SeizureSupervisorFollowUpFGCTimeOfNotification
	,SeizureSupervisorFollowUpNameOfFamilyGuardianCustodian
	,SeizureSupervisorFollowUpDetailsOfNotification
	,SignedDate
	,PhysicalSignature
	,CurrentStatus
	,InProgressStatus
	,CR.SupervisorFollowUpManagerNotified
	,CR.SupervisorFollowUpManager
	,CR.SupervisorFollowUpManagerDateOfNotification
	,CR.SupervisorFollowUpManagerTimeOfNotification
		FROM CustomIncidentReportSeizureSupervisorFollowUps CR
	left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		AND IncidentReportId = @IncidentReportId
	order by IncidentReportSeizureSupervisorFollowUpId desc

	SELECT top 1
	IncidentReportSeizureAdministratorReviewId
	,CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
	,CASE WHEN ISNULL(CR.SignedBy,'') = '' THEN '' ELSE ISNULL(S.LastName, '') + ', ' + ISNULL(S.FirstName, '') end as  StaffName
	,SeizureAdministratorReviewAdministrator
	,SignedBy
	,SeizureAdministratorReviewAdministrativeReview
	,SeizureAdministratorReviewFiledReportableIncident
	,SeizureAdministratorReviewComments
	,SignedDate
	,PhysicalSignature
	,CurrentStatus
	,InProgressStatus
	FROM CustomIncidentReportSeizureAdministratorReviews CR
	left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		AND IncidentReportId = @IncidentReportId
	order by IncidentReportSeizureAdministratorReviewId desc
	
	SELECT top 1
	IncidentReportManagerFollowUpId
	,CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
	,CASE WHEN ISNULL(CR.SignedBy,'') = '' THEN '' ELSE ISNULL(S.LastName, '') + ', ' + ISNULL(S.FirstName, '') end as  StaffName
	,ManagerFollowUpManagerId
	,ManagerFollowUpAdministratorNotified
	,ManagerFollowUpAdministrator
	,ManagerFollowUpAdminDateOfNotification
	,ManagerFollowUpAdminTimeOfNotification
	,ManagerReviewFollowUp
	,SignedDate
	,PhysicalSignature
	,CurrentStatus
	,InProgressStatus
	,SignedBy
	FROM CustomIncidentReportManagerFollowUps CR
	left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		AND IncidentReportId = @IncidentReportId
	order by IncidentReportManagerFollowUpId desc
	
	SELECT top 1
	IncidentReportFallManagerFollowUpId
	,CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
	,CASE WHEN ISNULL(CR.SignedBy,'') = '' THEN '' ELSE ISNULL(S.LastName, '') + ', ' + ISNULL(S.FirstName, '') end as  StaffName
	,ManagerFollowUpManagerId
	,ManagerFollowUpAdministratorNotified
	,ManagerFollowUpAdministrator
	,ManagerFollowUpAdminDateOfNotification
	,ManagerFollowUpAdminTimeOfNotification
	,ManagerReviewFollowUp
	,SignedDate
	,PhysicalSignature
	,CurrentStatus
	,InProgressStatus
	,SignedBy
	FROM CustomIncidentReportFallManagerFollowUps CR
	left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		AND IncidentReportId = @IncidentReportId
	order by IncidentReportFallManagerFollowUpId desc
	
	SELECT top 1
	IncidentReportSeizureManagerFollowUpId
	,CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
	,CASE WHEN ISNULL(CR.SignedBy,'') = '' THEN '' ELSE ISNULL(S.LastName, '') + ', ' + ISNULL(S.FirstName, '') end as  StaffName
	,ManagerFollowUpManagerId
	,ManagerFollowUpAdministratorNotified
	,ManagerFollowUpAdministrator
	,ManagerFollowUpAdminDateOfNotification
	,ManagerFollowUpAdminTimeOfNotification
	,ManagerReviewFollowUp
	,SignedDate
	,PhysicalSignature
	,CurrentStatus
	,InProgressStatus
	,SignedBy
	FROM CustomIncidentReportSeizureManagerFollowUps CR
	left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		AND IncidentReportId = @IncidentReportId
	order by IncidentReportSeizureManagerFollowUpId desc
	
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_GetIncidentReport') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                      
			16
			,-- Severity.                      
			1 -- State.                      
			);
END CATCH