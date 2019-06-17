
/****** Object:  StoredProcedure [dbo].[CSP_UpdateSignatureDetail]    Script Date: 05/12/2015 18:51:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CSP_UpdateSignatureDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CSP_UpdateSignatureDetail]
GO


/****** Object:  StoredProcedure [dbo].[CSP_UpdateSignatureDetail]    Script Date: 05/12/2015 18:51:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CSP_UpdateSignatureDetail] (
	@PKID INT
	,@SignedBy INT
	,@TableName VARCHAR(100)
	,@PhysicalSignature image 
)
AS
/********************************************************************************                                                       
--      
-- Copyright: Streamline Healthcare Solutions      
/*    Date			Author				Purpose */
   12 May 2015		Vithobha			To update sign information
   12 April 2019	Vithobha			Fixed the latent issue by adding the missing columns, New Directions - Enhancements: #26
*********************************************************************************/
BEGIN TRY

if(@TableName='CustomIncidentReportDetails')
begin
	UPDATE CustomIncidentReportDetails 
	set SignedBy=@SignedBy, SignedDate=getdate(),CurrentStatus=22,InProgressStatus=22,  PhysicalSignature=@PhysicalSignature
	where IncidentReportDetailId=@PKID

	INSERT INTO [CustomIncidentReportDetails]
			   ([CreatedBy]
			   ,[CreatedDate]
			   ,[ModifiedBy]
			   ,[ModifiedDate]
			   ,[RecordDeleted]
			   ,[DeletedBy]
			   ,[DeletedDate]
			   ,[IncidentReportId]
			   ,[DetailsStaffNotifiedForInjury]
			   ,[SignedBy]
			   ,[DetailsDescriptionOfincident]
			   ,[DetailsActionsTakenByStaff]
			   ,[DetailsWitnesses]
			   ,[DetailsDateStaffNotified]
			   ,[DetailsTimestaffNotified]
			   ,[DetailsNoMedicalStaffNotified]
			   ,[SignedDate]
			   ,[PhysicalSignature]
			   ,[CurrentStatus]
			   ,[InProgressStatus]
			   ,[DetailsSupervisorFlaggedId])  

	SELECT top 1
		CI.CreatedBy
		,CI.CreatedDate
		,CI.ModifiedBy
		,CI.ModifiedDate
		,CI.RecordDeleted
		,CI.DeletedBy
		,CI.DeletedDate
		,CI.IncidentReportId
		,CI.DetailsStaffNotifiedForInjury
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
	 WHERE ISNull(CI.RecordDeleted, 'N') = 'N'  
	  AND CI.IncidentReportDetailId =   @PKID
	  order by CI.IncidentReportDetailId desc
	  
	  SELECT top 1
		IncidentReportDetailId
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
	  order by CI.IncidentReportDetailId desc
	  
	  	UPDATE CustomIncidentReports SET DetailVersionStatus = (
					SELECT TOP 1 InProgressStatus
					FROM CustomIncidentReportDetails
					WHERE IncidentReportDetailId = @PKID
					ORDER BY IncidentReportDetailId DESC
					)
					WHERE IncidentReportId = (SELECT TOP 1 IncidentReportId
					FROM CustomIncidentReportDetails
					WHERE IncidentReportDetailId = @PKID
					ORDER BY IncidentReportDetailId DESC)
	  
end	
if(@TableName='CustomIncidentReportFollowUpOfIndividualStatuses')
begin
	UPDATE CustomIncidentReportFollowUpOfIndividualStatuses 
	set SignedBy=@SignedBy, SignedDate=getdate(),CurrentStatus=22,InProgressStatus=22,  PhysicalSignature=@PhysicalSignature
	where IncidentReportFollowUpOfIndividualStatusId=@PKID
	
	INSERT INTO [CustomIncidentReportFollowUpOfIndividualStatuses]
           ([CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate]
           ,[RecordDeleted]
           ,[DeletedBy]
           ,[DeletedDate]
           ,[IncidentReportId]
           ,[FollowUpIndividualStatusNurseStaffEvaluating]
           ,[FollowUpIndividualStatusStaffCompletedNotification]
           ,[SignedBy]
           ,[FollowUpIndividualStatusCredentialTitle]
           ,[FollowUpIndividualStatusDetailsOfInjury]
           ,[FollowUpIndividualStatusComments]
           ,[FollowUpIndividualStatusFamilyGuardianCustodianNotified]
           ,[FollowUpIndividualStatusDateOfNotification]
           ,[FollowUpIndividualStatusTimeOfNotification]
           ,[FollowUpIndividualStatusNameOfFamilyGuardianCustodian]
           ,[FollowUpIndividualStatusDetailsOfNotification]
           ,[SignedDate]
           ,[PhysicalSignature]
           ,[CurrentStatus]
           ,[InProgressStatus]
           ,[NoteType]
			,[NoteStart]
			,[NoteEnd]
			,[NoteComment])
           
	SELECT top 1
	CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
	,CR.FollowUpIndividualStatusNurseStaffEvaluating
	,CR.FollowUpIndividualStatusStaffCompletedNotification
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
	,CR.NoteType
	,CR.NoteStart
	,CR.NoteEnd
	,CR.NoteComment
	FROM CustomIncidentReportFollowUpOfIndividualStatuses CR
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		AND IncidentReportFollowUpOfIndividualStatusId = @PKID
		order by CR.IncidentReportFollowUpOfIndividualStatusId desc
		
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
	,CR.NoteType
	,CR.NoteStart
	,CR.NoteEnd
	,CR.NoteComment
	FROM CustomIncidentReportFollowUpOfIndividualStatuses CR
	 left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		order by CR.IncidentReportFollowUpOfIndividualStatusId desc
		
			UPDATE CustomIncidentReports SET FollowUpOfIndividualStatusVersionStatus = (
					SELECT TOP 1 InProgressStatus
					FROM CustomIncidentReportFollowUpOfIndividualStatuses
					WHERE IncidentReportFollowUpOfIndividualStatusId = @PKID
					ORDER BY IncidentReportFollowUpOfIndividualStatusId DESC
					)
					WHERE IncidentReportId = (SELECT TOP 1 IncidentReportId
					FROM CustomIncidentReportFollowUpOfIndividualStatuses
					WHERE IncidentReportFollowUpOfIndividualStatusId = @PKID
					ORDER BY IncidentReportFollowUpOfIndividualStatusId DESC
					)
end

if(@TableName='CustomIncidentReportSupervisorFollowUps')
begin
	UPDATE CustomIncidentReportSupervisorFollowUps 
	set SignedBy=@SignedBy, SignedDate=getdate(),CurrentStatus=22,InProgressStatus=22,  PhysicalSignature=@PhysicalSignature
	where IncidentReportSupervisorFollowUpId=@PKID
	
	INSERT INTO [CustomIncidentReportSupervisorFollowUps]
           ([CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate]
           ,[RecordDeleted]
           ,[DeletedBy]
           ,[DeletedDate]
           ,[IncidentReportId]
           ,[SupervisorFollowUpSupervisorName]
           ,[SupervisorFollowUpAdministrator]
           ,[SupervisorFollowUpStaffCompletedNotification]
           ,[SignedBy]
           ,[SupervisorFollowUpFollowUp]
           ,[SupervisorFollowUpAdministratorNotified]
           ,[SupervisorFollowUpAdminDateOfNotification]
           ,[SupervisorFollowUpAdminTimeOfNotification]
           ,[SupervisorFollowUpFamilyGuardianCustodianNotified]
           ,[SupervisorFollowUpFGCDateOfNotification]
           ,[SupervisorFollowUpFGCTimeOfNotification]
           ,[SupervisorFollowUpNameOfFamilyGuardianCustodian]
           ,[SupervisorFollowUpDetailsOfNotification]
           ,[SupervisorFollowUpAggressionPhysical]
           ,[SupervisorFollowUpAggressionVerbal]
           ,[SupervisorFollowUpBehavioralRestraint]
           ,[SupervisorFollowUpElopementOffCampus]
           ,[SupervisorFollowUpElopementOnCampus]
           ,[SupervisorFollowUpContraband]
           ,[SupervisorFollowUpPropertyDamage]
           ,[SupervisorFollowUpPropertyDestruction]
           ,[SupervisorFollowUpSearchSeizure]
           ,[SupervisorFollowUpSelfInjury]
           ,[SupervisorFollowUpSuicideAttempt]
           ,[SupervisorFollowUpSuicideThreatGesture]
           ,[SupervisorFollowUpOutbreakOfDisease]
           ,[SupervisorFollowUpIllness]
           ,[SupervisorFollowUpHospitalizationMedical]
           ,[SupervisorFollowUpHospitalizationPsychiatric]
           ,[SupervisorFollowUpTripToER]
           ,[SupervisorFollowUpAllegedAbuse]
           ,[SupervisorFollowUpMisuseOfFundsProperty]
           ,[SupervisorFollowUpViolationOfRights]
           ,[SupervisorFollowUpIndividualToIndividualInjury]
           ,[SupervisorFollowUpInjury]
           ,[SupervisorFollowUpInjuryFromRestraint]
           ,[SupervisorFollowUpFireDepartmentInvolvement]
           ,[SupervisorFollowUpPoliceInvolvement]
           ,[SupervisorFollowUpChokingSwallowingDifficulty]
           ,[SupervisorFollowUpDeath]
           ,[SupervisorFollowUpDrugUsePossession]
           ,[SupervisorFollowUpOutOfProgramArea]
           ,[SupervisorFollowUpSexualIncident]
           ,[SupervisorFollowUpOther]
           ,[SupervisorFollowUpOtherComments]
           ,[SignedDate]
           ,[PhysicalSignature]
           ,[CurrentStatus]
           ,[InProgressStatus]
           ,[SupervisorFollowUpManagerNotified]
			,[SupervisorFollowUpManager]
			,[SupervisorFollowUpManagerDateOfNotification]
			,[SupervisorFollowUpManagerTimeOfNotification])
           
           SELECT top 1
	CR.CreatedBy
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
		AND CR.IncidentReportSupervisorFollowUpId = @PKID
		order by CR.IncidentReportSupervisorFollowUpId desc
		
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
		order by CR.IncidentReportSupervisorFollowUpId desc
		
		UPDATE CustomIncidentReports SET SupervisorFollowUpVersionStatus = (
					SELECT TOP 1 InProgressStatus
					FROM CustomIncidentReportSupervisorFollowUps
					WHERE IncidentReportSupervisorFollowUpId = @PKID
					ORDER BY IncidentReportSupervisorFollowUpId DESC
					)
					WHERE IncidentReportId = (SELECT TOP 1 IncidentReportId
					FROM CustomIncidentReportSupervisorFollowUps
					WHERE IncidentReportSupervisorFollowUpId = @PKID
					ORDER BY IncidentReportSupervisorFollowUpId DESC
					)
end

if(@TableName='CustomIncidentReportManagerFollowUps')
begin
UPDATE CustomIncidentReportManagerFollowUps 
	set SignedBy=@SignedBy, SignedDate=getdate(),CurrentStatus=22,InProgressStatus=22,  PhysicalSignature=@PhysicalSignature
	where IncidentReportManagerFollowUpId=@PKID
	INSERT INTO [CustomIncidentReportManagerFollowUps]
           ([CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate]
           ,[RecordDeleted]
           ,[DeletedBy]
           ,[DeletedDate]
           ,[IncidentReportId]
           ,[ManagerFollowUpManagerId]
           ,[SignedBy]
           ,[ManagerFollowUpAdministratorNotified]
           ,[ManagerFollowUpAdministrator]
           ,[ManagerFollowUpAdminDateOfNotification]
           ,[ManagerFollowUpAdminTimeOfNotification]
           ,[ManagerReviewFollowUp]
           ,[SignedDate]
           ,[PhysicalSignature]
           ,[CurrentStatus]
           ,[InProgressStatus])
           
           SELECT top 1
	CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
	,CR.ManagerFollowUpManagerId
	,CR.SignedBy
	,CR.ManagerFollowUpAdministratorNotified
	,CR.ManagerFollowUpAdministrator
	,CR.ManagerFollowUpAdminDateOfNotification
	,CR.ManagerFollowUpAdminTimeOfNotification
	,CR.ManagerReviewFollowUp
	,CR.SignedDate
	,CR.PhysicalSignature
	,CR.CurrentStatus
	,CR.InProgressStatus
	FROM CustomIncidentReportManagerFollowUps CR
	left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		AND IncidentReportManagerFollowUpId = @PKID
		order by CR.IncidentReportManagerFollowUpId desc
		
		SELECT top 1
	CR.IncidentReportManagerFollowUpId
	,CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
	,CR.ManagerFollowUpManagerId
	,CASE WHEN ISNULL(CR.SignedBy,'') = '' THEN '' ELSE ISNULL(S.LastName, '') + ', ' + ISNULL(S.FirstName, '') end as  StaffName
	,CR.SignedBy
	,CR.ManagerFollowUpAdministratorNotified
	,CR.ManagerFollowUpAdministrator
	,CR.ManagerFollowUpAdminDateOfNotification
	,CR.ManagerFollowUpAdminTimeOfNotification
	,CR.ManagerReviewFollowUp
	,CR.SignedDate
	,CR.PhysicalSignature
	,CR.CurrentStatus
	,CR.InProgressStatus
	FROM CustomIncidentReportManagerFollowUps CR
	left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		order by CR.IncidentReportManagerFollowUpId desc
		
		UPDATE CustomIncidentReports SET ManagerFollowUpStatus = (
					SELECT TOP 1 InProgressStatus
					FROM CustomIncidentReportManagerFollowUps
					WHERE IncidentReportManagerFollowUpId = @PKID
					ORDER BY IncidentReportManagerFollowUpId DESC
					)
					WHERE IncidentReportId = (SELECT TOP 1 IncidentReportId
					FROM CustomIncidentReportManagerFollowUps
					WHERE IncidentReportManagerFollowUpId = @PKID
					ORDER BY IncidentReportManagerFollowUpId DESC
					)
end	
	
if(@TableName='CustomIncidentReportAdministratorReviews')
begin
UPDATE CustomIncidentReportAdministratorReviews 
	set SignedBy=@SignedBy, SignedDate=getdate(),CurrentStatus=22,InProgressStatus=22,  PhysicalSignature=@PhysicalSignature
	where IncidentReportAdministratorReviewId=@PKID
	INSERT INTO [CustomIncidentReportAdministratorReviews]
           ([CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate]
           ,[RecordDeleted]
           ,[DeletedBy]
           ,[DeletedDate]
           ,[IncidentReportId]
           ,[AdministratorReviewAdministrator]
           ,[SignedBy]
           ,[AdministratorReviewAdministrativeReview]
           ,[AdministratorReviewFiledReportableIncident]
           ,[AdministratorReviewComments]
           ,[SignedDate]
           ,[PhysicalSignature]
           ,[CurrentStatus]
           ,[InProgressStatus])
           
           SELECT top 1
	CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
	,CR.AdministratorReviewAdministrator
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
		AND IncidentReportAdministratorReviewId = @PKID
		order by CR.IncidentReportAdministratorReviewId desc
		
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
		order by CR.IncidentReportAdministratorReviewId desc
		
		UPDATE CustomIncidentReports SET AdministratorReviewVersionStatus = (
					SELECT TOP 1 InProgressStatus
					FROM CustomIncidentReportAdministratorReviews
					WHERE IncidentReportAdministratorReviewId = @PKID
					ORDER BY IncidentReportAdministratorReviewId DESC
					)
					WHERE IncidentReportId = (SELECT TOP 1 IncidentReportId
					FROM CustomIncidentReportAdministratorReviews
					WHERE IncidentReportAdministratorReviewId = @PKID
					ORDER BY IncidentReportAdministratorReviewId DESC
					)
end	
	if(@TableName='CustomIncidentReportFallDetails')
begin
	UPDATE CustomIncidentReportFallDetails 
		set SignedBy=@SignedBy, SignedDate=getdate(),CurrentStatus=22,InProgressStatus=22,  PhysicalSignature=@PhysicalSignature
		where IncidentReportFallDetailId=@PKID
	INSERT INTO [CustomIncidentReportFallDetails]
           ([CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate]
           ,[RecordDeleted]
           ,[DeletedBy]
           ,[DeletedDate]
           ,[IncidentReportId]
           ,[SignedBy]
           ,[FallDetailsDescribeIncident]
           ,[FallDetailsCauseOfIncident]
           ,[FallDetailsCauseOfIncidentText]
           ,[FallDetailsNone]
           ,[FallDetailsCane]
           ,[FallDetailsSeatLapBelt]
           ,[FallDetailsWheelchair]
           ,[FallDetailsGaitBelt]
           ,[FallDetailsWheellchairTray]
           ,[FallDetailsWalker]
           ,[FallDetailsMafosBraces]
           ,[FallDetailsHelmet]
           ,[FallDetailsChestHarness]
           ,[FallDetailsOther]
           ,[FallDetailsOtherText]
           ,[FallDetailsIncidentOccurredWhile]
           ,[FallDetailsFootwearAtTimeOfIncident]
           ,[FallDetailsWheelsLocked]
           ,[FallDetailsWhereBedWheelsUnlocked]
           ,[FallDetailsNA]
           ,[FallDetailsFullLength]
           ,[FallDetails2Half]
           ,[FallDetails4Half]
           ,[FallDetailsBothSidesUp]
           ,[FallDetailsOneSideUp]
           ,[FallDetailsBumperPads]
           ,[FallDetailsFurtherDescription]
           ,[FallDetailsFurtherDescriptiontext]
           ,[FallDetailsWasAnAlarmPresent]
           ,[FallDetailsAlarmSoundedDuringIncident]
           ,[FallDetailsAlarmDidNotSoundDuringIncident]
           ,[FallDetailsBedMat]
           ,[FallDetailsBeam]
           ,[FallDetailsBabyMonitor]
           ,[FallDetailsFloorMat]
           ,[FallDetailsMagneticClip]
           ,[FallDetailsTypeOfAlarmOtherText]
           ,[FallDetailsTypeOfAlarmOther]
           ,[FallDetailsDescriptionOfincident]
           ,[FallDetailsActionsTakenByStaff]
           ,[FallDetailsWitnesses]
           ,[FallDetailsStaffNotifiedForInjury]
           ,[FallDetailsDateStaffNotified]
           ,[FallDetailsTimestaffNotified]
           ,[FallDetailsNoMedicalStaffNotified]
           ,[SignedDate]
           ,[PhysicalSignature]
           ,[CurrentStatus]
           ,[InProgressStatus]
           ,[FallDetailsSupervisorFlaggedId])	
           
           SELECT top 1
	CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
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
		AND IncidentReportFallDetailId = @PKID
		order by CR.IncidentReportFallDetailId desc
		
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
		order by CR.IncidentReportFallDetailId desc
		
		UPDATE CustomIncidentReports SET FallDetailVersionStatus = (
					SELECT TOP 1 InProgressStatus
					FROM CustomIncidentReportFallDetails
					WHERE IncidentReportFallDetailId = @PKID
					ORDER BY IncidentReportFallDetailId DESC
					)
					WHERE IncidentReportId = (SELECT TOP 1 IncidentReportId
					FROM CustomIncidentReportFallDetails
					WHERE IncidentReportFallDetailId = @PKID
					ORDER BY IncidentReportFallDetailId DESC
					)
end

	if(@TableName='CustomIncidentReportFallFollowUpOfIndividualStatuses')
begin
	UPDATE CustomIncidentReportFallFollowUpOfIndividualStatuses 
		set SignedBy=@SignedBy, SignedDate=getdate(),CurrentStatus=22,InProgressStatus=22,  PhysicalSignature=@PhysicalSignature
		where IncidentReportFallFollowUpOfIndividualStatusId=@PKID
		
		INSERT INTO [CustomIncidentReportFallFollowUpOfIndividualStatuses]
           ([CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate]
           ,[RecordDeleted]
           ,[DeletedBy]
           ,[DeletedDate]
           ,[IncidentReportId]
           ,[FallFollowUpIndividualStatusNurseStaffEvaluating]
           ,[FallFollowUpIndividualStatusStaffCompletedNotification]
           ,[SignedBy]
           ,[FallFollowUpIndividualStatusCredentialTitle]
           ,[FallFollowUpIndividualStatusDetailsOfInjury]
           ,[FallFollowUpIndividualStatusNoTreatmentNoInjury]
           ,[FallFollowUpIndividualStatusFirstAidOnly]
           ,[FallFollowUpIndividualStatusMonitor]
           ,[FallFollowUpIndividualStatusToPrimaryCareProviderClinicEvaluation]
           ,[FallFollowUpIndividualStatusToEmergencyRoom]
           ,[FallFollowUpIndividualStatusOther]
           ,[FallFollowUpIndividualStatusOtherText]
           ,[FallFollowUpIndividualStatusComments]
           ,[FallFollowUpIndividualStatusFamilyGuardianCustodianNotified]
           ,[FallFollowUpIndividualStatusDateOfNotification]
           ,[FallFollowUpIndividualStatusTimeOfNotification]
           ,[FallFollowUpIndividualStatusNameOfFamilyGuardianCustodian]
           ,[FallFollowUpIndividualStatusDetailsOfNotification]
           ,[SignedDate]
           ,[PhysicalSignature]
           ,[CurrentStatus]
           ,[InProgressStatus]
           ,[NoteType]
           ,NoteStart
           ,NoteEnd
           ,NoteComment
           )
           
           SELECT top 1
	CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
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
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		AND IncidentReportFallFollowUpOfIndividualStatusId = @PKID
	order by CR.IncidentReportFallFollowUpOfIndividualStatusId desc
	
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
	order by CR.IncidentReportFallFollowUpOfIndividualStatusId desc
	
	UPDATE CustomIncidentReports SET FallFollowUpOfIndividualStatusVersionStatus = (
					SELECT TOP 1 InProgressStatus
					FROM CustomIncidentReportFallFollowUpOfIndividualStatuses
					WHERE IncidentReportFallFollowUpOfIndividualStatusId = @PKID
					ORDER BY IncidentReportFallFollowUpOfIndividualStatusId DESC
					)
					WHERE IncidentReportId = (SELECT TOP 1 IncidentReportId
					FROM CustomIncidentReportFallFollowUpOfIndividualStatuses
					WHERE IncidentReportFallFollowUpOfIndividualStatusId = @PKID
					ORDER BY IncidentReportFallFollowUpOfIndividualStatusId DESC
					)
end
	if(@TableName='CustomIncidentReportFallSupervisorFollowUps')
begin
	UPDATE CustomIncidentReportFallSupervisorFollowUps 
		set SignedBy=@SignedBy, SignedDate=getdate(),CurrentStatus=22,InProgressStatus=22,  PhysicalSignature=@PhysicalSignature
		where IncidentReportFallSupervisorFollowUpId=@PKID
		INSERT INTO [CustomIncidentReportFallSupervisorFollowUps]
           ([CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate]
           ,[RecordDeleted]
           ,[DeletedBy]
           ,[DeletedDate]
           ,[IncidentReportId]
           ,[FallSupervisorFollowUpSupervisorName]
           ,[FallSupervisorFollowUpAdministrator]
           ,[FallSupervisorFollowUpStaffCompletedNotification]
           ,[SignedBy]
           ,[FallSupervisorFollowUpFollowUp]
           ,[FallSupervisorFollowUpAdministratorNotified]
           ,[FallSupervisorFollowUpAdminDateOfNotification]
           ,[FallSupervisorFollowUpAdminTimeOfNotification]
           ,[FallSupervisorFollowUpFamilyGuardianCustodianNotified]
           ,[FallSupervisorFollowUpFGCDateOfNotification]
           ,[FallSupervisorFollowUpFGCTimeOfNotification]
           ,[FallSupervisorFollowUpNameOfFamilyGuardianCustodian]
           ,[FallSupervisorFollowUpDetailsOfNotification]
           ,[SignedDate]
           ,[PhysicalSignature]
           ,[CurrentStatus]
           ,[InProgressStatus]
			,SupervisorFollowUpManagerNotified
			,SupervisorFollowUpManager
			,SupervisorFollowUpManagerDateOfNotification
			,SupervisorFollowUpManagerTimeOfNotification)
           SELECT top 1 
	CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
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
	,SupervisorFollowUpManagerNotified
	,SupervisorFollowUpManager
	,SupervisorFollowUpManagerDateOfNotification
	,SupervisorFollowUpManagerTimeOfNotification
	FROM CustomIncidentReportFallSupervisorFollowUps CR
	left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		AND IncidentReportFallSupervisorFollowUpId = @PKID
	order by IncidentReportFallSupervisorFollowUpId desc
	
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
	,SupervisorFollowUpManagerNotified
	,SupervisorFollowUpManager
	,SupervisorFollowUpManagerDateOfNotification
	,SupervisorFollowUpManagerTimeOfNotification
	FROM CustomIncidentReportFallSupervisorFollowUps CR
	left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
	order by IncidentReportFallSupervisorFollowUpId desc
	
	UPDATE CustomIncidentReports SET FallSupervisorFollowUpVersionStatus = (
					SELECT TOP 1 InProgressStatus
					FROM CustomIncidentReportFallSupervisorFollowUps
					WHERE IncidentReportFallSupervisorFollowUpId = @PKID
					ORDER BY IncidentReportFallSupervisorFollowUpId DESC
					)
					WHERE IncidentReportId = (SELECT TOP 1 IncidentReportId
					FROM CustomIncidentReportFallSupervisorFollowUps
					WHERE IncidentReportFallSupervisorFollowUpId = @PKID
					ORDER BY IncidentReportFallSupervisorFollowUpId DESC
					)
end
if(@TableName='CustomIncidentReportFallManagerFollowUps')
begin
UPDATE CustomIncidentReportFallManagerFollowUps 
	set SignedBy=@SignedBy, SignedDate=getdate(),CurrentStatus=22,InProgressStatus=22,  PhysicalSignature=@PhysicalSignature
	where IncidentReportFallManagerFollowUpId=@PKID
	INSERT INTO [CustomIncidentReportFallManagerFollowUps]
           ([CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate]
           ,[RecordDeleted]
           ,[DeletedBy]
           ,[DeletedDate]
           ,[IncidentReportId]
           ,[ManagerFollowUpManagerId]
           ,[SignedBy]
           ,[ManagerFollowUpAdministratorNotified]
           ,[ManagerFollowUpAdministrator]
           ,[ManagerFollowUpAdminDateOfNotification]
           ,[ManagerFollowUpAdminTimeOfNotification]
           ,[ManagerReviewFollowUp]
           ,[SignedDate]
           ,[PhysicalSignature]
           ,[CurrentStatus]
           ,[InProgressStatus])
           
           SELECT top 1
	CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
	,CR.ManagerFollowUpManagerId
	,CR.SignedBy
	,CR.ManagerFollowUpAdministratorNotified
	,CR.ManagerFollowUpAdministrator
	,CR.ManagerFollowUpAdminDateOfNotification
	,CR.ManagerFollowUpAdminTimeOfNotification
	,CR.ManagerReviewFollowUp
	,CR.SignedDate
	,CR.PhysicalSignature
	,CR.CurrentStatus
	,CR.InProgressStatus
	FROM CustomIncidentReportFallManagerFollowUps CR
	left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		AND IncidentReportFallManagerFollowUpId = @PKID
		order by CR.IncidentReportFallManagerFollowUpId desc
		
		SELECT top 1
	CR.IncidentReportFallManagerFollowUpId
	,CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
	,CR.ManagerFollowUpManagerId
	,CASE WHEN ISNULL(CR.SignedBy,'') = '' THEN '' ELSE ISNULL(S.LastName, '') + ', ' + ISNULL(S.FirstName, '') end as  StaffName
	,CR.SignedBy
	,CR.ManagerFollowUpAdministratorNotified
	,CR.ManagerFollowUpAdministrator
	,CR.ManagerFollowUpAdminDateOfNotification
	,CR.ManagerFollowUpAdminTimeOfNotification
	,CR.ManagerReviewFollowUp
	,CR.SignedDate
	,CR.PhysicalSignature
	,CR.CurrentStatus
	,CR.InProgressStatus
	FROM CustomIncidentReportFallManagerFollowUps CR
	left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		order by CR.IncidentReportFallManagerFollowUpId desc
		
		UPDATE CustomIncidentReports SET FallManagerFollowUpStatus = (
					SELECT TOP 1 InProgressStatus
					FROM CustomIncidentReportFallManagerFollowUps
					WHERE IncidentReportFallManagerFollowUpId = @PKID
					ORDER BY IncidentReportFallManagerFollowUpId DESC
					)
					WHERE IncidentReportId = (SELECT TOP 1 IncidentReportId
					FROM CustomIncidentReportFallManagerFollowUps
					WHERE IncidentReportFallManagerFollowUpId = @PKID
					ORDER BY IncidentReportFallManagerFollowUpId DESC
					)
end	
	if(@TableName='CustomIncidentReportFallAdministratorReviews')
begin
	UPDATE CustomIncidentReportFallAdministratorReviews 
		set SignedBy=@SignedBy, SignedDate=getdate(),CurrentStatus=22,InProgressStatus=22,  PhysicalSignature=@PhysicalSignature
		where IncidentReportFallAdministratorReviewId=@PKID
		
		INSERT INTO [CustomIncidentReportFallAdministratorReviews]
           ([CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate]
           ,[RecordDeleted]
           ,[DeletedBy]
           ,[DeletedDate]
           ,[IncidentReportId]
           ,[FallAdministratorReviewAdministrator]
           ,[SignedBy]
           ,[FallAdministratorReviewAdministrativeReview]
           ,[FallAdministratorReviewFiledReportableIncident]
           ,[FallAdministratorReviewComments]
           ,[SignedDate]
           ,[PhysicalSignature]
           ,[CurrentStatus]
           ,[InProgressStatus])
           SELECT top 1
	CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
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
		AND IncidentReportFallAdministratorReviewId = @PKID
	order by IncidentReportFallAdministratorReviewId desc
	
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
	order by IncidentReportFallAdministratorReviewId desc
	
	UPDATE CustomIncidentReports SET FallAdministratorReviewVersionStatus = (
					SELECT TOP 1 InProgressStatus
					FROM CustomIncidentReportFallAdministratorReviews
					WHERE IncidentReportFallAdministratorReviewId = @PKID
					ORDER BY IncidentReportFallAdministratorReviewId DESC
					)
					WHERE IncidentReportId = (SELECT TOP 1 IncidentReportId
					FROM CustomIncidentReportFallAdministratorReviews
					WHERE IncidentReportFallAdministratorReviewId = @PKID
					ORDER BY IncidentReportFallAdministratorReviewId DESC
					)
end

	if(@TableName='CustomIncidentSeizureDetails')
begin
	UPDATE CustomIncidentSeizureDetails 
		set SignedBy=@SignedBy, SignedDate=getdate(),CurrentStatus=22,InProgressStatus=22,  PhysicalSignature=@PhysicalSignature
		where IncidentSeizureDetailId=@PKID
		
		INSERT INTO [CustomIncidentSeizureDetails]
           ([CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate]
           ,[RecordDeleted]
           ,[DeletedBy]
           ,[DeletedDate]
           ,[IncidentReportId]
           ,[IncidentSeizureDetailsStaffNotifiedForInjury]
           ,[SignedBy]
           ,[IncidentSeizureDetailsDescriptionOfIncident]
           ,[IncidentSeizureDetailsActionsTakenByStaff]
           ,[IncidentSeizureDetailsWitnesses]
           ,[IncidentSeizureDetailsDateStaffNotified]
           ,[IncidentSeizureDetailsTimeStaffNotified]
           ,[IncidentSeizureDetailsNoMedicalStaffNotified]
           ,[SignedDate]
           ,[PhysicalSignature]
           ,[CurrentStatus]
           ,[InProgressStatus]
           ,[IncidentSeizureDetailsSupervisorFlaggedId])
           
           SELECT top 1
	CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
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
		AND IncidentSeizureDetailId = @PKID
	order by IncidentSeizureDetailId desc
	
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
	order by IncidentSeizureDetailId desc
	
	UPDATE CustomIncidentReports SET SeizureDetailVersionStatus = (
					SELECT TOP 1 InProgressStatus
					FROM CustomIncidentSeizureDetails
					WHERE IncidentSeizureDetailId = @PKID
					ORDER BY IncidentSeizureDetailId DESC
					)
					WHERE IncidentReportId = (SELECT TOP 1 IncidentReportId
					FROM CustomIncidentSeizureDetails
					WHERE IncidentSeizureDetailId = @PKID
					ORDER BY IncidentSeizureDetailId DESC
					)
end

	if(@TableName='CustomIncidentReportSeizureFollowUpOfIndividualStatuses')
begin
	UPDATE CustomIncidentReportSeizureFollowUpOfIndividualStatuses 
		set SignedBy=@SignedBy, SignedDate=getdate(),CurrentStatus=22,InProgressStatus=22,  PhysicalSignature=@PhysicalSignature
		where IncidentReportSeizureFollowUpOfIndividualStatusId=@PKID
		
	INSERT INTO [CustomIncidentReportSeizureFollowUpOfIndividualStatuses]
           ([CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate]
           ,[RecordDeleted]
           ,[DeletedBy]
           ,[DeletedDate]
           ,[IncidentReportId]
           ,[SeizureFollowUpIndividualStatusNurseStaffEvaluating]
           ,[SeizureFollowUpIndividualStatusStaffCompletedNotification]
           ,[SignedBy]
           ,[SeizureFollowUpIndividualStatusCredentialTitle]
           ,[SeizureFollowUpIndividualStatusDetailsOfInjury]
           ,[SeizureFollowUpIndividualStatusComments]
           ,[SeizureFollowUpIndividualStatusFamilyGuardianCustodianNotified]
           ,[SeizureFollowUpIndividualStatusDateOfNotification]
           ,[SeizureFollowUpIndividualStatusTimeOfNotification]
           ,[SeizureFollowUpIndividualStatusNameOfFamilyGuardianCustodian]
           ,[SeizureFollowUpIndividualStatusDetailsOfNotification]
           ,[SignedDate]
           ,[PhysicalSignature]
           ,[CurrentStatus]
           ,[InProgressStatus]
			,SeizureDetailsO2Given
			,SeizureDetailsLiterMin
			,SeizureDetailsEmergencyMedicationsGiven
			,NoteType
			,NoteStart
			,NoteEnd
			,NoteComment)	

           SELECT top 1
	CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
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
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		AND IncidentReportSeizureFollowUpOfIndividualStatusId = @PKID
	order by IncidentReportSeizureFollowUpOfIndividualStatusId desc
	
	SELECT top 1
	CR.CreatedBy
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
	order by IncidentReportSeizureFollowUpOfIndividualStatusId desc
	
	UPDATE CustomIncidentReports SET SeizureFollowUpOfIndividualStatusVersionStatus = (
					SELECT TOP 1 InProgressStatus
					FROM CustomIncidentReportSeizureFollowUpOfIndividualStatuses
					WHERE IncidentReportSeizureFollowUpOfIndividualStatusId = @PKID
					ORDER BY IncidentReportSeizureFollowUpOfIndividualStatusId DESC
					)
					WHERE IncidentReportId = (SELECT TOP 1 IncidentReportId
					FROM CustomIncidentReportSeizureFollowUpOfIndividualStatuses
					WHERE IncidentReportSeizureFollowUpOfIndividualStatusId = @PKID
					ORDER BY IncidentReportSeizureFollowUpOfIndividualStatusId DESC
					)
end

	if(@TableName='CustomIncidentReportSeizureSupervisorFollowUps')
begin
	UPDATE CustomIncidentReportSeizureSupervisorFollowUps 
		set SignedBy=@SignedBy, SignedDate=getdate(),CurrentStatus=22,InProgressStatus=22,  PhysicalSignature=@PhysicalSignature
		where IncidentReportSeizureSupervisorFollowUpId=@PKID
		
		INSERT INTO [CustomIncidentReportSeizureSupervisorFollowUps]
           ([CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate]
           ,[RecordDeleted]
           ,[DeletedBy]
           ,[DeletedDate]
           ,[IncidentReportId]
           ,[SeizureSupervisorFollowUpSupervisorName]
           ,[SeizureSupervisorFollowUpAdministrator]
           ,[SeizureSupervisorFollowUpStaffCompletedNotification]
           ,[SignedBy]
           ,[SeizureSupervisorFollowUpFollowUp]
           ,[SeizureSupervisorFollowUpAdministratorNotified]
           ,[SeizureSupervisorFollowUpAdminDateOfNotification]
           ,[SeizureSupervisorFollowUpAdminTimeOfNotification]
           ,[SeizureSupervisorFollowUpFamilyGuardianCustodianNotified]
           ,[SeizureSupervisorFollowUpFGCDateOfNotification]
           ,[SeizureSupervisorFollowUpFGCTimeOfNotification]
           ,[SeizureSupervisorFollowUpNameOfFamilyGuardianCustodian]
           ,[SeizureSupervisorFollowUpDetailsOfNotification]
           ,[SignedDate]
           ,[PhysicalSignature]
           ,[CurrentStatus]
           ,[InProgressStatus]
			,SupervisorFollowUpManagerNotified
			,SupervisorFollowUpManager
			,SupervisorFollowUpManagerDateOfNotification
			,SupervisorFollowUpManagerTimeOfNotification)
           SELECT top 1
	CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
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
	,SupervisorFollowUpManagerNotified
	,SupervisorFollowUpManager
	,SupervisorFollowUpManagerDateOfNotification
	,SupervisorFollowUpManagerTimeOfNotification
	FROM CustomIncidentReportSeizureSupervisorFollowUps CR
	left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		AND IncidentReportSeizureSupervisorFollowUpId = @PKID
	order by IncidentReportSeizureSupervisorFollowUpId desc
	
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
	,SupervisorFollowUpManagerNotified
	,SupervisorFollowUpManager
	,SupervisorFollowUpManagerDateOfNotification
	,SupervisorFollowUpManagerTimeOfNotification
	FROM CustomIncidentReportSeizureSupervisorFollowUps CR
	left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
	order by IncidentReportSeizureSupervisorFollowUpId desc
	
		UPDATE CustomIncidentReports SET SeizureSupervisorFollowUpVersionStatus = (
					SELECT TOP 1 InProgressStatus
					FROM CustomIncidentReportSeizureSupervisorFollowUps
					WHERE IncidentReportSeizureSupervisorFollowUpId = @PKID
					ORDER BY IncidentReportSeizureSupervisorFollowUpId DESC
					)
					WHERE IncidentReportId = (SELECT TOP 1 IncidentReportId
					FROM CustomIncidentReportSeizureSupervisorFollowUps
					WHERE IncidentReportSeizureSupervisorFollowUpId = @PKID
					ORDER BY IncidentReportSeizureSupervisorFollowUpId DESC
					)
end
if(@TableName='CustomIncidentReportSeizureManagerFollowUps')
begin
UPDATE CustomIncidentReportSeizureManagerFollowUps 
	set SignedBy=@SignedBy, SignedDate=getdate(),CurrentStatus=22,InProgressStatus=22,  PhysicalSignature=@PhysicalSignature
	where IncidentReportSeizureManagerFollowUpId=@PKID
	INSERT INTO [CustomIncidentReportSeizureManagerFollowUps]
           ([CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate]
           ,[RecordDeleted]
           ,[DeletedBy]
           ,[DeletedDate]
           ,[IncidentReportId]
           ,[ManagerFollowUpManagerId]
           ,[SignedBy]
           ,[ManagerFollowUpAdministratorNotified]
           ,[ManagerFollowUpAdministrator]
           ,[ManagerFollowUpAdminDateOfNotification]
           ,[ManagerFollowUpAdminTimeOfNotification]
           ,[ManagerReviewFollowUp]
           ,[SignedDate]
           ,[PhysicalSignature]
           ,[CurrentStatus]
           ,[InProgressStatus])
           
           SELECT top 1
	CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
	,CR.ManagerFollowUpManagerId
	,CR.SignedBy
	,CR.ManagerFollowUpAdministratorNotified
	,CR.ManagerFollowUpAdministrator
	,CR.ManagerFollowUpAdminDateOfNotification
	,CR.ManagerFollowUpAdminTimeOfNotification
	,CR.ManagerReviewFollowUp
	,CR.SignedDate
	,CR.PhysicalSignature
	,CR.CurrentStatus
	,CR.InProgressStatus
	FROM CustomIncidentReportSeizureManagerFollowUps CR
	left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		AND IncidentReportSeizureManagerFollowUpId = @PKID
		order by CR.IncidentReportSeizureManagerFollowUpId desc
		
		SELECT top 1
	CR.IncidentReportSeizureManagerFollowUpId
	,CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
	,CR.ManagerFollowUpManagerId
	,CASE WHEN ISNULL(CR.SignedBy,'') = '' THEN '' ELSE ISNULL(S.LastName, '') + ', ' + ISNULL(S.FirstName, '') end as  StaffName
	,CR.SignedBy
	,CR.ManagerFollowUpAdministratorNotified
	,CR.ManagerFollowUpAdministrator
	,CR.ManagerFollowUpAdminDateOfNotification
	,CR.ManagerFollowUpAdminTimeOfNotification
	,CR.ManagerReviewFollowUp
	,CR.SignedDate
	,CR.PhysicalSignature
	,CR.CurrentStatus
	,CR.InProgressStatus
	FROM CustomIncidentReportSeizureManagerFollowUps CR
	left JOIN Staff S ON S.StaffId= CR.SignedBy  
	WHERE ISNull(CR.RecordDeleted, 'N') = 'N'
		order by CR.IncidentReportSeizureManagerFollowUpId desc
		
		UPDATE CustomIncidentReports SET SeizureManagerFollowUpStatus = (
					SELECT TOP 1 InProgressStatus
					FROM CustomIncidentReportSeizureManagerFollowUps
					WHERE IncidentReportSeizureManagerFollowUpId = @PKID
					ORDER BY IncidentReportSeizureManagerFollowUpId DESC
					)
					WHERE IncidentReportId = (SELECT TOP 1 IncidentReportId
					FROM CustomIncidentReportSeizureManagerFollowUps
					WHERE IncidentReportSeizureManagerFollowUpId = @PKID
					ORDER BY IncidentReportSeizureManagerFollowUpId DESC
					)
end	
	if(@TableName='CustomIncidentReportSeizureAdministratorReviews')
begin
	UPDATE CustomIncidentReportSeizureAdministratorReviews 
		set SignedBy=@SignedBy, SignedDate=getdate(),CurrentStatus=22,InProgressStatus=22,  PhysicalSignature=@PhysicalSignature
		where IncidentReportSeizureAdministratorReviewId=@PKID
		
		INSERT INTO [CustomIncidentReportSeizureAdministratorReviews]
           ([CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate]
           ,[RecordDeleted]
           ,[DeletedBy]
           ,[DeletedDate]
           ,[IncidentReportId]
           ,[SeizureAdministratorReviewAdministrator]
           ,[SignedBy]
           ,[SeizureAdministratorReviewAdministrativeReview]
           ,[SeizureAdministratorReviewFiledReportableIncident]
           ,[SeizureAdministratorReviewComments]
           ,[SignedDate]
           ,[PhysicalSignature]
           ,[CurrentStatus]
           ,[InProgressStatus])
           SELECT top 1
	CR.CreatedBy
	,CR.CreatedDate
	,CR.ModifiedBy
	,CR.ModifiedDate
	,CR.RecordDeleted
	,CR.DeletedBy
	,CR.DeletedDate
	,CR.IncidentReportId
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
		AND IncidentReportSeizureAdministratorReviewId = @PKID
	order by IncidentReportSeizureAdministratorReviewId desc
	
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
	order by IncidentReportSeizureAdministratorReviewId desc
		
		UPDATE CustomIncidentReports SET SeizureAdministratorReviewVersionStatus = (
					SELECT TOP 1 InProgressStatus
					FROM CustomIncidentReportSeizureAdministratorReviews
					WHERE IncidentReportSeizureAdministratorReviewId = @PKID
					ORDER BY IncidentReportSeizureAdministratorReviewId DESC
					)
					WHERE IncidentReportId = (SELECT TOP 1 IncidentReportId
					FROM CustomIncidentReportSeizureAdministratorReviews
					WHERE IncidentReportSeizureAdministratorReviewId = @PKID
					ORDER BY IncidentReportSeizureAdministratorReviewId DESC
					)
end
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'CSP_UpdateSignatureDetail') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                      
			16
			,-- Severity.                      
			1 -- State.                      
			);
END CATCH
GO


