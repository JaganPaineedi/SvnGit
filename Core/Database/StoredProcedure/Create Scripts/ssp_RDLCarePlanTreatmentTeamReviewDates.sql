/****** Object:  StoredProcedure [dbo].[ssp_RDLCarePlanTreatmentTeamReviewDates]    Script Date: 01/13/2015 15:06:23 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLCarePlanTreatmentTeamReviewDates]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLCarePlanTreatmentTeamReviewDates]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLCarePlanTreatmentTeamReviewDates]    Script Date: 01/13/2015 15:06:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLCarePlanTreatmentTeamReviewDates] 
	(
	@DocumentVersionId AS INT
	)
AS
/***********************************************************************************************************************
-- Copyright: Streamline Healthcate Solutions
-- Called By : This stored procedure is called from SubReportGLDSTDTreatmentTeam rdl.
-- Date:				Author:			Description:  
   12/June/2018			Irfan			What:Created ssp to add the Review Dates section with two fields in the Rdl to dislay the same on Pdf of
											 Individualized Service Plan(Care Plan) document.
										Why :Customer needs Review Dates section to be displayed on pdf of Individualized Service Plan (Care Plan) as per the task PEP-Environmental Issues Tracking -#85	 
------*****************Modifiction History********************************************************--------------------*/

BEGIN
	BEGIN TRY
		SELECT CASE WHEN DCP.ReviewEntireCarePlan IS NOT NULL THEN GC.CodeName
				  WHEN DCP.ReviewEntireCarePlanDate IS NOT NULL THEN CONVERT(VARCHAR(10),DCP.ReviewEntireCarePlanDate,101)
				  ELSE NULL END AS ReviewEntireCarePlan
		    ,DCP.CarePlanReviewComments	AS CarePlanReviewComments  
		FROM DocumentCarePlans DCP
		JOIN Documents D ON D.InProgressDocumentVersionId = DCP.DocumentVersionId
		JOIN DocumentVersions Dv ON DV.DocumentVersionId = DCP.DocumentVersionId
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = DCP.ReviewEntireCarePlan
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'			
		WHERE DCP.DocumentVersionId = @DocumentVersionId
		AND ISNULL(D.RecordDeleted, 'N')='N'
		AND ISNULL(DCP.RecordDeleted, 'N')='N'	
		AND ISNULL(DV.RecordDeleted, 'N')='N'	
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLCarePlanTreatmentTeamReviewDates') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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
