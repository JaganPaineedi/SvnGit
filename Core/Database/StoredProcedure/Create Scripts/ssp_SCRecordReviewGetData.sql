IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCRecordReviewGetData]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCRecordReviewGetData]
GO

CREATE PROCEDURE ssp_SCRecordReviewGetData @RecordReviewId INT
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_SCRecordReviewGetData                */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    03/June/2011                                         */
/*                                                                   */
/* Purpose:  Used to display records for any RecordReviewTemplate in order to insert new review  */
/*                                                                   */
/* Input Parameters:   @RecordReviewId      */
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
/*  Date         Author           Purpose                             */
/* 03/june/2011   Karan Garg      Created                             */
/* 13/Sept/2011   Rohit           Update                             */
/* 05/07/2012     Jagdeep         Modify Joins to get data           */
/*  21 Oct 2015    Revathi		  what:Changed code to display Clients LastName and FirstName when ClientType='I' else  OrganizationName.  /   
/								  why:task #609, Network180 Customization  */
/*********************************************************************/
BEGIN
	BEGIN TRY
		/*############## Variables ###################*/
		DECLARE @RecordReviewTemplateId INT

		SET @RecordReviewTemplateId = (
				SELECT TOP 1 RecordReviewTemplateId
				FROM CustomRecordReviews
				WHERE RecordReviewId = @RecordReviewId
				)

		/*********************    Table CustomRecordReviews   ********************/
		SELECT [RecordReviewId]
			,CRR.[CreatedBy]
			,CRR.[CreatedDate]
			,CRR.[ModifiedBy]
			,CRR.[ModifiedDate]
			,CRR.[RecordDeleted]
			,CRR.[DeletedDate]
			,CRR.[DeletedBy]
			,CRR.[RecordReviewTemplateId]
			,[ReviewingStaff]
			,[ClinicianReviewed]
			,CRR.[ClientId]
			,[Status]
			,[AssignedDate]
			,[CompletedDate]
			,[ReviewComments]
			,[Results]
			,[RequestQIReview]
			,
			--Added by Revathi 21 Oct 2015
			CASE 
				WHEN ISNULL(c.ClientType, 'I') = 'I'
					THEN ISNULL(c.LastName, '') + ', ' + ISNULL(c.FirstName, '')
				ELSE ISNULL(c.OrganizationName, '')
				END AS ClientName
			,
			--C.LastName+', '+C.FirstName AS ClientName,            
			CRRT.RecordReviewTemplateName AS TemplateName
			,s1.LastName + ' ' + s1.FirstName AS ReviewingStaffName
			,s2.LastName + ' ' + s2.FirstName AS ClinicianReviewedName
		FROM CustomRecordReviews AS CRR
		INNER JOIN CustomRecordReviewTemplates AS CRRT ON CRR.RecordReviewTemplateId = CRRT.RecordReviewTemplateId
		INNER JOIN Staff s1 ON CRR.ReviewingStaff = s1.StaffId
		LEFT JOIN Staff s2 ON CRR.ClinicianReviewed = s2.StaffId
		LEFT JOIN Clients AS C ON C.ClientId = CRR.ClientId
		--INNER JOIN Staff s2 ON CRR.ClinicianReviewed = s2.StaffId            
		--INNER JOIN Clients AS C ON C.ClientId = CRR.ClientId                        
		WHERE RecordReviewId = @RecordReviewId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCRecordReviewGetData') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                  
				16
				,-- Severity.                                                                  
				1 -- State.                                                                  
				);
	END CATCH
END