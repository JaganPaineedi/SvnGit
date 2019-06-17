IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLIncidentReportFallSupervisorFollowUps]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_RDLIncidentReportFallSupervisorFollowUps]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLIncidentReportFallSupervisorFollowUps]    Script Date: 11/27/2013 16:30:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_RDLIncidentReportFallSupervisorFollowUps] (@IncidentReportFallSupervisorFollowUpId INT)
AS
/*********************************************************************/
/* Stored Procedure: dbo.[csp_RDLIncidentReportFallSupervisorFollowUps]                */
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:   06-May-2015                                     */
/*                                                                   */
/* Purpose:  Get Data for CustomIncidentReportFallSupervisorFollowUps Pages */
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
*/
/*********************************************************************/
BEGIN
	BEGIN TRY
		SELECT (S.LastName + ', ' + S.FirstName) AS SupervisorName
			,(S1.LastName + ', ' + S1.FirstName) AS Administrator
			,(S2.LastName + ', ' + S2.FirstName) AS StaffCompletedNotification
			,(S3.LastName + ', ' + S3.FirstName) AS SignedBy
			,CIRFS.FallSupervisorFollowUpFollowUp AS FollowUp
			,CASE CIRFS.FallSupervisorFollowUpAdministratorNotified
				WHEN 'Y'
					THEN 'Yes'
				WHEN 'N'
					THEN 'NO'
				END AS AdministratorNotified
			,CONVERT(VARCHAR(10), CIRFS.FallSupervisorFollowUpAdminDateOfNotification, 101) AS AdminDateOfNotification
			,(right('0' + LTRIM(SUBSTRING(CONVERT(VARCHAR, CIRFS.FallSupervisorFollowUpAdminTimeOfNotification, 100), 13, 2)), 2) + ':' + SUBSTRING(CONVERT(VARCHAR, CIRFS.FallSupervisorFollowUpAdminTimeOfNotification, 100), 16, 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, CIRFS.FallSupervisorFollowUpAdminTimeOfNotification, 100), 18, 2)) AS TimeOfNotification
			,CASE CIRFS.FallSupervisorFollowUpFamilyGuardianCustodianNotified
				WHEN 'Y'
					THEN 'Yes'
				WHEN 'N'
					THEN 'NO'
				END AS FamilyGuardianCustodianNotified
			,CONVERT(VARCHAR(10), CIRFS.FallSupervisorFollowUpFGCDateOfNotification, 101) AS FGCDateOfNotification
			,(right('0' + LTRIM(SUBSTRING(CONVERT(VARCHAR, CIRFS.FallSupervisorFollowUpFGCTimeOfNotification, 100), 13, 2)), 2) + ':' + SUBSTRING(CONVERT(VARCHAR, CIRFS.FallSupervisorFollowUpFGCTimeOfNotification, 100), 16, 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, CIRFS.FallSupervisorFollowUpFGCTimeOfNotification, 100), 18, 2)) AS FGCTimeOfNotification
			,CIRFS.FallSupervisorFollowUpNameOfFamilyGuardianCustodian AS NameOfFamilyGuardianCustodian
			,CIRFS.FallSupervisorFollowUpDetailsOfNotification AS DetailsOfNotification
			,CONVERT(VARCHAR(10), CIRFS.SignedDate, 101) AS SignedDate
			,CIRFS.PhysicalSignature
			,dbo.csf_GetGlobalCodeNameById(CIRFS.CurrentStatus) AS CurrentStatus
			,dbo.csf_GetGlobalCodeNameById(CIRFS.InProgressStatus) AS InProgressStatus
			,(case when isnull(CIRFS.SupervisorFollowUpManagerNotified,'N') = 'Y' then 'Yes'
		   else 'No' end) as  SupervisorFollowUpManagerNotified 
		,SM.LastName + ',' + SM.FirstName AS SupervisorFollowUpManager
		,Convert(VARCHAR(10), CIRFS.SupervisorFollowUpManagerDateOfNotification, 101) AS SupervisorFollowUpManagerDateOfNotification
	,(right('0' + LTRIM(SUBSTRING(CONVERT(VARCHAR, CIRFS.SupervisorFollowUpManagerTimeOfNotification, 100), 13, 2)), 2) + ':' + SUBSTRING(CONVERT(VARCHAR, CIRFS.SupervisorFollowUpManagerTimeOfNotification, 100), 16, 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, CIRFS.SupervisorFollowUpManagerTimeOfNotification, 100), 18, 2)) AS SupervisorFollowUpManagerTimeOfNotification	
		FROM CustomIncidentReportFallSupervisorFollowUps CIRFS
		LEFT JOIN Staff S ON CIRFS.FallSupervisorFollowUpSupervisorName = S.StaffId
			AND isnull(S.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Staff S1 ON CIRFS.FallSupervisorFollowUpAdministrator = S1.StaffId
			AND isnull(S1.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Staff S2 ON CIRFS.FallSupervisorFollowUpStaffCompletedNotification = S2.StaffId
			AND isnull(S2.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Staff S3 ON CIRFS.SignedBy = S3.StaffId
			AND isnull(S3.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Staff SM ON SM.StaffId = CIRFS.SupervisorFollowUpManager

		WHERE CIRFS.IncidentReportFallSupervisorFollowUpId = @IncidentReportFallSupervisorFollowUpId
			AND isnull(CIRFS.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLIncidentReportFallSupervisorFollowUps') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.  
				16
				,-- Severity.  
				1 -- State.  
				);
	END CATCH
END
