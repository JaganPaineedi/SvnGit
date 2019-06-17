IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_SubReportIncidentAdministratorReviews]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_SubReportIncidentAdministratorReviews] 
GO

CREATE PROCEDURE [dbo].[csp_SubReportIncidentAdministratorReviews] (@IncidentReportAdministratorReviewId INT)
AS
/********************************************************************************                                                       
--      
-- Copyright: Streamline Healthcare Solutions      
/*    Date        Author            Purpose */
   12 April 2019	Vithobha		Fixed the latent issue by adding Other label for AdministratorReviewFiledReportableIncident column, New Directions - Enhancements: #26
    
*********************************************************************************/
BEGIN TRY
	SELECT C.IncidentReportAdministratorReviewId
		,C.CreatedBy
		,C.CreatedDate
		,C.ModifiedBy
		,C.ModifiedDate
		,C.RecordDeleted
		,C.DeletedBy
		,C.DeletedDate
		,C.IncidentReportId
		,C.AdministratorReviewAdministrator
		,C.SignedBy
		,C.AdministratorReviewAdministrativeReview
		,CASE C.AdministratorReviewFiledReportableIncident
			WHEN 'Y'
				THEN 'Yes'
			WHEN 'N'
				THEN 'No'
			WHEN 'O'  
				THEN 'Other' 
			END AS AdministratorReviewFiledReportableIncident
		,C.AdministratorReviewComments
		,Convert(VARCHAR(10), C.SignedDate, 101) AS SignedDate
		,C.PhysicalSignature
		,C.CurrentStatus
		,C.InProgressStatus
		,SS.LastName + ',' + SS.FirstName AS Administrator
		,S.LastName + ',' + S.FirstName AS SignedByName
	FROM CustomIncidentReportAdministratorReviews C
	LEFT JOIN Staff SS ON SS.StaffId = C.AdministratorReviewAdministrator
	LEFT JOIN Staff S ON S.StaffId = C.SignedBy
	WHERE ISNull(C.RecordDeleted, 'N') = 'N'
		AND C.IncidentReportAdministratorReviewId = @IncidentReportAdministratorReviewId
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_SubReportIncidentAdministratorReviews') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                      
			16
			,-- Severity.                      
			1 -- State.                      
			);
END CATCH
