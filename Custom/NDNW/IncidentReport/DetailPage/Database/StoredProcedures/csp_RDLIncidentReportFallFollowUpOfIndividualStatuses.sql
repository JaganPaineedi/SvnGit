IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLIncidentReportFallFollowUpOfIndividualStatuses]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_RDLIncidentReportFallFollowUpOfIndividualStatuses]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLIncidentReportFallFollowUpOfIndividualStatuses]    Script Date: 11/27/2013 16:30:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_RDLIncidentReportFallFollowUpOfIndividualStatuses] (@IncidentReportFallFollowUpOfIndividualStatusId INT)
AS
/*********************************************************************/
/* Stored Procedure: dbo.[csp_RDLIncidentReportFallFollowUpOfIndividualStatuses]                */
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:   06-May-2015                                     */
/*                                                                   */
/* Purpose:  Get Data for CustomIncidentReportFallFollowUpOfIndividualStatuses Pages */
/*                                                                   */
/* Input Parameters:  @IncidentReportFallFollowUpOfIndividualStatusId           */
/*                                                                   */
/* Output Parameters:   None                   */
/*                                                                   */
/* Return:  0=success, otherwise an error number                     */
/*                                                                   */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                        */
/* */
/* Data Modifications:   */
/*      */
/* Updates:                                          
 Date			Author			Purpose       
 ----------		---------		--------------------------------------                                                                               
 07-May-2015	Ravichandra		what:Use For Rdl Report  
								why:task #818 Woods – Customizations
12 April 2019	Vithobha		Fixed the latent issue by adding the missing columns, New Directions - Enhancements: #26	*/
/*********************************************************************/
BEGIN
	BEGIN TRY
		SELECT (S.LastName + ', ' + S.FirstName) AS NurseStaffEvaluating
			,(S1.LastName + ', ' + S1.FirstName) AS StaffCompletedNotification
			,(S2.LastName + ', ' + S2.FirstName) AS SignedBy
			,CIRFI.FallFollowUpIndividualStatusCredentialTitle AS CredentialTitle
			,CIRFI.FallFollowUpIndividualStatusDetailsOfInjury AS DetailsOfInjury
			,CIRFI.FallFollowUpIndividualStatusNoTreatmentNoInjury AS NoTreatmentNoInjury
			,CIRFI.FallFollowUpIndividualStatusFirstAidOnly AS FirstAidOnly
			,CIRFI.FallFollowUpIndividualStatusMonitor AS Monitor
			,CIRFI.FallFollowUpIndividualStatusToPrimaryCareProviderClinicEvaluation AS ToPrimaryCareProviderClinicEvaluation
			,CIRFI.FallFollowUpIndividualStatusToEmergencyRoom AS ToEmergencyRoom
			,CIRFI.FallFollowUpIndividualStatusOther AS Other
			,CIRFI.FallFollowUpIndividualStatusOtherText AS OtherText
			,CIRFI.FallFollowUpIndividualStatusComments AS Comments
			,CASE CIRFI.FallFollowUpIndividualStatusFamilyGuardianCustodianNotified
				WHEN 'Y'
					THEN 'Yes'
				WHEN 'N'
					THEN 'NO'
				END AS FamilyGuardianCustodianNotified
			,CONVERT(VARCHAR(10), CIRFI.FallFollowUpIndividualStatusDateOfNotification, 101) AS DateOfNotification
			,(right('0' + LTRIM(SUBSTRING(CONVERT(VARCHAR, CIRFI.FallFollowUpIndividualStatusTimeOfNotification, 100), 13, 2)), 2) + ':' + SUBSTRING(CONVERT(VARCHAR, CIRFI.FallFollowUpIndividualStatusTimeOfNotification, 100), 16, 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, CIRFI.FallFollowUpIndividualStatusTimeOfNotification, 100), 18, 2)) AS TimeOfNotification
			,CIRFI.FallFollowUpIndividualStatusNameOfFamilyGuardianCustodian AS NameOfFamilyGuardianCustodian
			,CIRFI.FallFollowUpIndividualStatusDetailsOfNotification AS DetailsOfNotification
			,CONVERT(VARCHAR(10), CIRFI.SignedDate, 101) AS SignedDate
			,CIRFI.PhysicalSignature
			,dbo.csf_GetGlobalCodeNameById(CIRFI.CurrentStatus) AS CurrentStatus
			,dbo.csf_GetGlobalCodeNameById(CIRFI.InProgressStatus) AS InProgressStatus
			,dbo.csf_GetGlobalCodeNameById(CIRFI.NoteType) AS NoteType
			,Convert(VARCHAR(10), CIRFI.NoteStart, 101) AS  NoteStart
			,Convert(VARCHAR(10), CIRFI.NoteEnd, 101) AS  NoteEnd
			,CIRFI.NoteComment
		FROM CustomIncidentReportFallFollowUpOfIndividualStatuses CIRFI
		LEFT JOIN Staff S ON CIRFI.FallFollowUpIndividualStatusNurseStaffEvaluating = S.StaffId
			AND isnull(S.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Staff S1 ON CIRFI.FallFollowUpIndividualStatusStaffCompletedNotification = S1.StaffId
			AND isnull(S1.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Staff S2 ON CIRFI.SignedBy = S2.StaffId
			AND isnull(S2.RecordDeleted, 'N') <> 'Y'
		WHERE CIRFI.IncidentReportFallFollowUpOfIndividualStatusId = @IncidentReportFallFollowUpOfIndividualStatusId
			AND isnull(CIRFI.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLIncidentReportFallFollowUpOfIndividualStatuses') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.  
				16
				,-- Severity.  
				1 -- State.  
				);
	END CATCH
END
