IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCRecordReviewFormDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCRecordReviewFormDetails]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCRecordReviewFormDetails]    Script Date: 02/05/2012 11:43:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCRecordReviewFormDetails] @RecordReviewId INT
AS
/*******************************************************************/
/* Stored Procedure: dbo.ssp_SCRecordReviewFormDetails                */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    03/June/2011                                         */
/*                                                                   */
/* Purpose:  Used to display records for any RecordReviewTemplate in order to insert new review  */
/*                                                                   */
/* Input Parameters:   @RecordReviewTemplateId , @RecordReviewId      */
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
/*  Date         Author          Purpose                             */
/* 03/june/2011   Karan Garg      Created                             */
/* 20/Feb/2012   Jagdeep          Added comma to display  last name and first name  for ReviewingStaffName and ClinicianReviewedName */
/*  21 Oct 2015    Revathi		  what:Changed code to display Clients LastName and FirstName when ClientType='I' else  OrganizationName.  /   
/								  why:task #609, Network180 Customization  */
/*********************************************************************/
BEGIN
	BEGIN TRY
		SELECT RecordReviewId
			,CustomRecordReviews.[CreatedBy]
			,CustomRecordReviews.[CreatedDate]
			,CustomRecordReviews.[ModifiedBy]
			,CustomRecordReviews.[ModifiedDate]
			,CustomRecordReviews.[RecordDeleted]
			,CustomRecordReviews.[DeletedDate]
			,CustomRecordReviews.[DeletedBy]
			,CustomRecordReviews.[RecordReviewTemplateId]
			,[ReviewingStaff]
			,[ClinicianReviewed]
			,CustomRecordReviews.[ClientId]
			,[Status]
			,[AssignedDate]
			,[CompletedDate]
			,[ReviewComments]
			,[Results]
			,[RequestQIReview]
			,
			--Added by Revathi 21 Oct 2015
			CASE 
				WHEN ISNULL(Clients.ClientType, 'I') = 'I'
					THEN ISNULL(Clients.LastName, '') + ', ' + ISNULL(Clients.FirstName, '')
				ELSE ISNULL(Clients.OrganizationName, '')
				END AS ClientName
			,CustomRecordReviewTemplates.RecordReviewTemplateName AS TemplateName
			,s1.LastName + ', ' + s1.FirstName AS ReviewingStaffName
			,s2.LastName + ', ' + s2.FirstName AS ClinicianReviewedName
		FROM CustomRecordReviews
		INNER JOIN CustomRecordReviewTemplates ON CustomRecordReviews.RecordReviewTemplateId = CustomRecordReviewTemplates.RecordReviewTemplateId
		INNER JOIN Staff s1 ON CustomRecordReviews.ReviewingStaff = s1.StaffId
		INNER JOIN Staff s2 ON CustomRecordReviews.ClinicianReviewed = s2.StaffId
		INNER JOIN Clients ON Clients.ClientId = CustomRecordReviews.ClientId
		WHERE RecordReviewId = @RecordReviewId

		SELECT CRI.RecordReviewItemId
			,CRI.CreatedBy
			,CRI.CreatedDate
			,CRI.ModifiedBy
			,CRI.ModifiedDate
			,CRI.RecordDeleted
			,CRI.DeletedDate
			,CRI.DeletedBy
			,CAST(ROW_number() OVER (
					ORDER BY crrti.Section
						,crrti.ItemNumber
					) AS INT) AS srno
			,CRI.RecordReviewTemplateItemId
			,CRI.RecordReviewId
			,CRI.Answer
			,CRI.DocumentVersionId1
			,CRI.DocumentVersionId2
			,CRI.DocumentVersionId3
			,CRRTI.Section
			,CRRTI.Prompt
			,CRRTI.HelpText
			,CRRTI.NAResponseAllowed
			,
			-- document 1
			d.ClientId AS ClientId1
			,d.DocumentId AS DocumentId1
			,isnull(d.ServiceId, 0) AS ServiceId1
			,d.DocumentCodeId AS DocumentCodeId1
			,sr.ScreenId AS ScreenId1
			,CASE 
				WHEN pc.DisplayDocumentAsProcedureCode = 'Y'
					THEN pc.DisplayAs
				ELSE dc.DocumentName
				END AS DocumentName1
			,
			-- document 2
			d2.ClientId AS ClientId2
			,d2.DocumentId AS DocumentId2
			,isnull(d2.ServiceId, 0) AS ServiceId2
			,d2.DocumentCodeId AS DocumentCodeId2
			,sr2.ScreenId AS ScreenId2
			,CASE 
				WHEN pc2.DisplayDocumentAsProcedureCode = 'Y'
					THEN pc2.DisplayAs
				ELSE dc2.DocumentName
				END AS DocumentName2
			,d3.ClientId AS ClientId3
			,
			-- document 3
			d3.DocumentId AS DocumentId3
			,isnull(d3.ServiceId, 0) AS ServiceId3
			,d3.DocumentCodeId AS DocumentCodeId3
			,sr3.ScreenId AS ScreenId3
			,CASE 
				WHEN pc3.DisplayDocumentAsProcedureCode = 'Y'
					THEN pc3.DisplayAs
				ELSE dc3.DocumentName
				END AS DocumentName3
		FROM CustomRecordReviewItems CRI
		INNER JOIN CustomRecordReviewTemplateItems CRRTI ON CRI.RecordReviewTemplateItemId = CRRTI.RecordReviewTemplateItemId
		-- document 1
		LEFT JOIN dbo.DocumentVersions AS dv ON dv.DocumentVersionId = cri.DocumentVersionId1
			AND ISNULL(dv.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Documents d ON d.DocumentId = dv.DocumentId
			AND ISNULL(d.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId
			AND ISNULL(dc.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Screens sr ON sr.DocumentCodeId = d.DocumentCodeId
			AND ISNULL(sr.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN dbo.Banners AS b1 ON b1.ScreenId = sr.ScreenId
			AND b1.Active = 'Y'
			AND ISNULL(b1.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Services s ON s.ServiceId = d.ServiceId
			AND ISNULL(s.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeID
			AND ISNULL(pc.RecordDeleted, 'N') <> 'Y'
		-- document 2
		LEFT JOIN dbo.DocumentVersions AS dv2 ON dv2.DocumentVersionId = cri.DocumentVersionId2
			AND ISNULL(dv2.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Documents d2 ON d2.DocumentId = dv2.DocumentId
			AND ISNULL(d2.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN DocumentCodes dc2 ON dc2.DocumentCodeId = d2.DocumentCodeId
			AND ISNULL(dc2.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Screens sr2 ON sr2.DocumentCodeId = d2.DocumentCodeId
			AND ISNULL(sr2.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN dbo.Banners AS b2 ON b2.ScreenId = sr2.ScreenId
			AND b2.Active = 'Y'
			AND ISNULL(b2.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Services s2 ON s2.ServiceId = d2.ServiceId
			AND ISNULL(s2.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN ProcedureCodes pc2 ON pc2.ProcedureCodeId = s2.ProcedureCodeID
			AND ISNULL(pc2.RecordDeleted, 'N') <> 'Y'
		-- document 3
		LEFT JOIN dbo.DocumentVersions AS dv3 ON dv3.DocumentVersionId = cri.DocumentVersionId3
			AND ISNULL(dv3.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Documents d3 ON d3.DocumentId = dv3.DocumentId
			AND ISNULL(d3.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN DocumentCodes dc3 ON dc3.DocumentCodeId = d3.DocumentCodeId
			AND ISNULL(dc3.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Screens sr3 ON sr3.DocumentCodeId = d3.DocumentCodeId
			AND ISNULL(sr3.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN dbo.Banners AS b3 ON b3.ScreenId = sr3.ScreenId
			AND b3.Active = 'Y'
			AND ISNULL(b3.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Services s3 ON s3.ServiceId = d3.ServiceId
			AND ISNULL(s3.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN ProcedureCodes pc3 ON pc3.ProcedureCodeId = s3.ProcedureCodeID
			AND ISNULL(pc3.RecordDeleted, 'N') <> 'Y'
		WHERE RecordReviewId = @RecordReviewId
		ORDER BY CRRTI.Section
			,CRRTI.ItemNumber
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCRecordReviewFormDetails') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END
GO

