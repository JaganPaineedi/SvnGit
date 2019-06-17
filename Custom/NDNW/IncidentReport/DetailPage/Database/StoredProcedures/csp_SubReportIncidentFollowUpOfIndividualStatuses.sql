IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_SubReportIncidentFollowUpOfIndividualStatuses]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_SubReportIncidentFollowUpOfIndividualStatuses]
GO

CREATE PROCEDURE [dbo].[csp_SubReportIncidentFollowUpOfIndividualStatuses] (@IncidentReportFollowUpOfIndividualStatusId INT)
AS
/********************************************************************************                                                       
--      
-- Copyright: Streamline Healthcare Solutions      
/*    Date			Author			Purpose */
 12 April 2019		Vithobha		Fixed the latent issue by adding missing columns, New Directions - Enhancements: #26
    
*********************************************************************************/
BEGIN TRY
	SELECT C.IncidentReportFollowUpOfIndividualStatusId
		,C.CreatedBy
		,C.CreatedDate
		,C.ModifiedBy
		,C.ModifiedDate
		,C.RecordDeleted
		,C.DeletedBy
		,C.DeletedDate
		,C.IncidentReportId
		,C.FollowUpIndividualStatusNurseStaffEvaluating
		,C.FollowUpIndividualStatusStaffCompletedNotification
		,C.SignedBy
		,C.FollowUpIndividualStatusCredentialTitle
		,C.FollowUpIndividualStatusDetailsOfInjury
		,C.FollowUpIndividualStatusComments
		,CASE C.FollowUpIndividualStatusFamilyGuardianCustodianNotified
			WHEN 'Y'
				THEN 'Yes'
			WHEN 'N'
				THEN 'NO'
			END AS FollowUpIndividualStatusFamilyGuardianCustodianNotified
		,Convert(VARCHAR(10), C.FollowUpIndividualStatusDateOfNotification, 101) AS FollowUpIndividualStatusDateOfNotification
		,(right('0' + LTRIM(SUBSTRING(CONVERT(VARCHAR, C.FollowUpIndividualStatusTimeOfNotification, 100), 13, 2)), 2) + ':' + SUBSTRING(CONVERT(VARCHAR, C.FollowUpIndividualStatusTimeOfNotification, 100), 16, 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, C.FollowUpIndividualStatusTimeOfNotification, 100), 18, 2)) AS FollowUpIndividualStatusTimeOfNotification
		,C.FollowUpIndividualStatusNameOfFamilyGuardianCustodian
		,C.FollowUpIndividualStatusDetailsOfNotification
		,convert(VARCHAR, C.SignedDate, 101) AS SignedDate
		,C.PhysicalSignature
		,C.CurrentStatus
		,C.InProgressStatus
		,S.LastName + ',' + S.FirstName AS NurseStaffEvaluating
		,SS.LastName + ',' + SS.FirstName AS StaffCompletedNotification
		,SSS.LastName + ',' + SSS.FirstName AS SignedByName
		,dbo.csf_GetGlobalCodeNameById(C.NoteType) AS NoteType
		,Convert(VARCHAR(10), C.NoteStart, 101) AS  NoteStart
		,Convert(VARCHAR(10), C.NoteEnd, 101) AS  NoteEnd
		,NoteComment
	FROM CustomIncidentReportFollowUpOfIndividualStatuses C
	LEFT JOIN Staff S ON S.StaffId = C.FollowUpIndividualStatusNurseStaffEvaluating
	LEFT JOIN Staff SS ON SS.StaffId = C.FollowUpIndividualStatusStaffCompletedNotification
	LEFT JOIN Staff SSS ON SSS.StaffId = C.SignedBy
	WHERE ISNull(C.RecordDeleted, 'N') = 'N'
		AND IncidentReportFollowUpOfIndividualStatusId = @IncidentReportFollowUpOfIndividualStatusId
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_SubReportIncident FollowUpIndividualStatus') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                      
			16
			,-- Severity.                      
			1 -- State.                      
			);
END CATCH
