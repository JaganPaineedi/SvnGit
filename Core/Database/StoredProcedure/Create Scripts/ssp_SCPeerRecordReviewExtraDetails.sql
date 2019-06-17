IF EXISTS (
		SELECT *
		FROM sysobjects
		WHERE type = 'P'
			AND NAME = 'ssp_SCPeerRecordReviewExtraDetails'
		)
BEGIN
	DROP PROCEDURE ssp_SCPeerRecordReviewExtraDetails
END
GO

CREATE PROCEDURE ssp_SCPeerRecordReviewExtraDetails @recordReviewId INT
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_SCPeerRecordReviewExtraDetails                */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    15/June/2011                                         */
/*                                                                   */
/* Purpose:  Used to get the template details assigned to a particular staff member */
/*                                                                   */
/* Input Parameters:   @recordReviewId        */
/*                                                                   */
/* Output Parameters:   None                */
/*                                                                   */
/* Return:  0=success, otherwise an error number                     */
/*                                                                   */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*  Date          Author          Purpose                             */
/* 15/june/2011   Karan Garg      Created                             */
/* 24/Mar/2014    Ponnin		  Moved from Threshold's 'Record Review' and changed to Core SP - For task #22 of Customization Bugs */
/*  21 Oct 2015    Revathi		  what:Changed code to display Clients LastName and FirstName when ClientType='I' else  OrganizationName.  /   
/								  why:task #609, Network180 Customization  */
/*********************************************************************/
BEGIN
	BEGIN TRY
		SELECT RecordReviews.RecordReviewId
			,RecordReviews.CreatedBy
			,RecordReviews.CreatedDate
			,RecordReviews.ModifiedBy
			,RecordReviews.ModifiedDate
			,RecordReviews.RecordDeleted
			,RecordReviews.DeletedDate
			,RecordReviews.DeletedBy
			,RecordReviews.RecordReviewTemplateId
			,RecordReviews.ReviewingStaff
			,RecordReviews.ClinicianReviewed
			,RecordReviews.ClientId
			,RecordReviews.STATUS
			,RecordReviews.AssignedDate
			,RecordReviews.CompletedDate
			,RecordReviews.ReviewComments
			,RecordReviews.Results
			,RecordReviews.RequestQIReview
			,RecordReviewTemplates.RecordReviewTemplateName
			,
			--Added by Revathi 21 Oct 2015
			CASE 
				WHEN ISNULL(Clients.ClientType, 'I') = 'I'
					THEN ISNULL(Clients.LastName, '') + ', ' + ISNULL(Clients.FirstName, '')
				ELSE ISNULL(Clients.OrganizationName, '')
				END AS ClientName
		FROM RecordReviews
		INNER JOIN RecordReviewTemplates ON RecordReviews.RecordReviewTemplateId = RecordReviewTemplates.RecordReviewTemplateId
		INNER JOIN Clients ON RecordReviews.ClientId = Clients.ClientId
		WHERE RecordReviews.RecordReviewId = @recordReviewId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCPeerRecordReviewExtraDetails') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                    
				16
				,-- Severity.                                                    
				1 -- State.                                                    
				);
	END CATCH
END