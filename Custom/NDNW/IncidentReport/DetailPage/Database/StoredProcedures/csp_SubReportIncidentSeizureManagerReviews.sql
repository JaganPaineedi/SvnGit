IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_SubReportIncidentSeizureManagerReviews]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_SubReportIncidentSeizureManagerReviews] 
GO

CREATE PROCEDURE [dbo].[csp_SubReportIncidentSeizureManagerReviews] (@IncidentReportManagerReviewId INT)
AS
/********************************************************************************                                                       
--      
-- Copyright: Streamline Healthcare Solutions      
/*    Date        Author            Purpose */
    
*********************************************************************************/
BEGIN TRY
	SELECT C.IncidentReportSeizureManagerFollowUpId
		,C.CreatedBy
		,C.CreatedDate
		,C.ModifiedBy
		,C.ModifiedDate
		,C.RecordDeleted
		,C.DeletedBy
		,C.DeletedDate
		,C.IncidentReportId
		,C.ManagerFollowUpManagerId
		,C.SignedBy
		,(case when isnull(C.ManagerFollowUpAdministratorNotified,'N') = 'Y' then 'Yes'
		   else 'No' end) as  ManagerFollowUpAdministratorNotified 
		,SS.LastName + ',' + SS.FirstName AS ManagerFollowUpManager
		,Convert(VARCHAR(10), C.ManagerFollowUpAdminDateOfNotification, 101) AS ManagerFollowUpAdminDateOfNotification
	,(right('0' + LTRIM(SUBSTRING(CONVERT(VARCHAR, C.ManagerFollowUpAdminTimeOfNotification, 100), 13, 2)), 2) + ':' + SUBSTRING(CONVERT(VARCHAR, C.ManagerFollowUpAdminTimeOfNotification, 100), 16, 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, C.ManagerFollowUpAdminTimeOfNotification, 100), 18, 2)) AS ManagerFollowUpAdminTimeOfNotification
		,C.ManagerReviewFollowUp
		,Convert(VARCHAR(10), C.SignedDate, 101) AS SignedDate
		,C.PhysicalSignature
		,C.CurrentStatus
		,C.InProgressStatus
		,SA.LastName + ',' + SA.FirstName AS Administrator
		,S.LastName + ',' + S.FirstName AS SignedByName
	FROM CustomIncidentReportSeizureManagerFollowUps C
	LEFT JOIN Staff SS ON SS.StaffId = C.ManagerFollowUpManagerId
	LEFT JOIN Staff SA ON SA.StaffId = C.ManagerFollowUpAdministrator 
	LEFT JOIN Staff S ON S.StaffId = C.SignedBy
	WHERE ISNull(C.RecordDeleted, 'N') = 'N'
		AND C.IncidentReportSeizureManagerFollowUpId = @IncidentReportManagerReviewId
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_SubReportIncidentSeizureManagerReviews') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                      
			16
			,-- Severity.                      
			1 -- State.                      
			);
END CATCH
