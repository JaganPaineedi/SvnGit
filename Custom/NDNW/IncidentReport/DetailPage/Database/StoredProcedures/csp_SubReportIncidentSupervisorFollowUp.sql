IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_SubReportIncidentSupervisorFollowUp]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_SubReportIncidentSupervisorFollowUp] --151
GO

CREATE PROCEDURE [dbo].[csp_SubReportIncidentSupervisorFollowUp] (@IncidentReportSupervisorFollowUpId INT)
AS
/********************************************************************************                                                       
--      
-- Copyright: Streamline Healthcare Solutions      
/*    Date        Author            Purpose */
    
*********************************************************************************/
BEGIN TRY
	SELECT C.IncidentReportSupervisorFollowUpId
		,C.CreatedBy
		,C.CreatedDate
		,C.ModifiedBy
		,C.ModifiedDate
		,C.RecordDeleted
		,C.DeletedBy
		,C.DeletedDate
		,C.IncidentReportId
		,C.SupervisorFollowUpSupervisorName
		,C.SupervisorFollowUpAdministrator
		,C.SupervisorFollowUpStaffCompletedNotification
		,C.SignedBy
		,C.SupervisorFollowUpFollowUp
		,CASE C.SupervisorFollowUpAdministratorNotified
			WHEN 'Y'
				THEN 'Yes'
			WHEN 'N'
				THEN 'NO'
			END AS SupervisorFollowUpAdministratorNotified
		,Convert(VARCHAR(10), C.SupervisorFollowUpAdminDateOfNotification, 101) AS SupervisorFollowUpAdminDateOfNotification
		,(right('0' + LTRIM(SUBSTRING(CONVERT(VARCHAR, C.SupervisorFollowUpAdminTimeOfNotification, 100), 13, 2)), 2) + ':' + SUBSTRING(CONVERT(VARCHAR, C.SupervisorFollowUpAdminTimeOfNotification, 100), 16, 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, C.SupervisorFollowUpAdminTimeOfNotification, 100), 18, 2)) AS SupervisorFollowUpAdminTimeOfNotification
		,CASE C.SupervisorFollowUpFamilyGuardianCustodianNotified
			WHEN 'Y'
				THEN 'Yes'
			WHEN 'N'
				THEN 'NO'
			END AS SupervisorFollowUpFamilyGuardianCustodianNotified
		,Convert(VARCHAR(10), C.SupervisorFollowUpFGCDateOfNotification, 101) AS SupervisorFollowUpFGCDateOfNotification
		,(right('0' + LTRIM(SUBSTRING(CONVERT(VARCHAR, C.SupervisorFollowUpFGCTimeOfNotification, 100), 13, 2)), 2) + ':' + SUBSTRING(CONVERT(VARCHAR, C.SupervisorFollowUpFGCTimeOfNotification, 100), 16, 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, C.SupervisorFollowUpFGCTimeOfNotification, 100), 18, 2)) AS SupervisorFollowUpFGCTimeOfNotification
		,C.SupervisorFollowUpNameOfFamilyGuardianCustodian
		,C.SupervisorFollowUpDetailsOfNotification
		,C.SupervisorFollowUpAggressionPhysical
		,C.SupervisorFollowUpAggressionVerbal
		,C.SupervisorFollowUpBehavioralRestraint
		,C.SupervisorFollowUpElopementOffCampus
		,C.SupervisorFollowUpElopementOnCampus
		,C.SupervisorFollowUpContraband
		,C.SupervisorFollowUpPropertyDamage
		,C.SupervisorFollowUpPropertyDestruction
		,C.SupervisorFollowUpSearchSeizure
		,C.SupervisorFollowUpSelfInjury
		,C.SupervisorFollowUpSuicideAttempt
		,C.SupervisorFollowUpSuicideThreatGesture
		,C.SupervisorFollowUpOutbreakOfDisease
		,C.SupervisorFollowUpIllness
		,C.SupervisorFollowUpHospitalizationMedical
		,C.SupervisorFollowUpHospitalizationPsychiatric
		,C.SupervisorFollowUpTripToER
		,C.SupervisorFollowUpAllegedAbuse
		,C.SupervisorFollowUpMisuseOfFundsProperty
		,C.SupervisorFollowUpViolationOfRights
		,C.SupervisorFollowUpIndividualToIndividualInjury
		,C.SupervisorFollowUpInjury
		,C.SupervisorFollowUpInjuryFromRestraint
		,C.SupervisorFollowUpFireDepartmentInvolvement
		,C.SupervisorFollowUpPoliceInvolvement
		,C.SupervisorFollowUpChokingSwallowingDifficulty
		,C.SupervisorFollowUpDeath
		,C.SupervisorFollowUpDrugUsePossession
		,C.SupervisorFollowUpOutOfProgramArea
		,C.SupervisorFollowUpSexualIncident
		,C.SupervisorFollowUpOther
		,C.SupervisorFollowUpOtherComments
		,convert(VARCHAR, C.SignedDate, 101) AS SignedDate
		,C.PhysicalSignature
		,C.CurrentStatus
		,C.InProgressStatus
		,S.LastName + ',' + S.FirstName AS Supervisor
		,SS.LastName + ',' + SS.FirstName AS Administrator
		,SSS.LastName + ',' + SSS.FirstName AS SupervisorFollowUp
		,SSSS.LastName + ',' + SSSS.FirstName AS SignedByName
		,(case when isnull(C.SupervisorFollowUpManagerNotified,'N') = 'Y' then 'Yes'
		   else 'No' end) as  SupervisorFollowUpManagerNotified 
		,SM.LastName + ',' + SM.FirstName AS SupervisorFollowUpManager
		,Convert(VARCHAR(10), C.SupervisorFollowUpManagerDateOfNotification, 101) AS SupervisorFollowUpManagerDateOfNotification
	,(right('0' + LTRIM(SUBSTRING(CONVERT(VARCHAR, C.SupervisorFollowUpManagerTimeOfNotification, 100), 13, 2)), 2) + ':' + SUBSTRING(CONVERT(VARCHAR, C.SupervisorFollowUpManagerTimeOfNotification, 100), 16, 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, C.SupervisorFollowUpManagerTimeOfNotification, 100), 18, 2)) AS SupervisorFollowUpManagerTimeOfNotification	
	FROM CustomIncidentReportSupervisorFollowUps C
	LEFT JOIN Staff S ON S.StaffId = C.SupervisorFollowUpSupervisorName
	LEFT JOIN Staff SS ON SS.StaffId = C.SupervisorFollowUpAdministrator
	LEFT JOIN Staff SSS ON SSS.StaffId = C.SupervisorFollowUpStaffCompletedNotification
	LEFT JOIN Staff SM ON SM.StaffId = C.SupervisorFollowUpManager
	LEFT JOIN Staff SSSS ON SSSS.StaffId = C.SignedBy
	WHERE ISNull(C.RecordDeleted, 'N') = 'N'
		AND IncidentReportSupervisorFollowUpId = @IncidentReportSupervisorFollowUpId
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_SubReportIncidentSupervisorFollowUp') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                      
			16
			,-- Severity.                      
			1 -- State.                      
			);
END CATCH
