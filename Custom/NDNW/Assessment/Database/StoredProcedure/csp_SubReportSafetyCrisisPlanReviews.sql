/****** Object:  StoredProcedure [dbo].[csp_SubReportSafetyCrisisPlanReviews]    Script Date: 10/15/2014 18:27:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SubReportSafetyCrisisPlanReviews]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SubReportSafetyCrisisPlanReviews]
GO

/****** Object:  StoredProcedure [dbo].[csp_SubReportSafetyCrisisPlanReviews]    Script Date: 10/15/2014 18:27:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_SubReportSafetyCrisisPlanReviews] (@DocumentVersionId INT)
AS
/*************************************************************************************/
/* Stored Procedure: [csp_SubReportSafetyCrisisPlanReviews]                                 */
/* Creation Date:  JAN 5TH ,2015                                                    */
/* Purpose: Gets Data from CustomSafetyCrisisPlanReviews   */
/* Input Parameters: @DocumentVersionId                                              */
/* Purpose: Use For Rdl Report                                                       */
/* Author: Akwinass                                                                  */
/* 26-Feb-2015 Added Extra Columns WRT Valley Customizations 969                                                               */
/*************************************************************************************/
BEGIN
	BEGIN TRY
		SELECT [SafetyCrisisPlanReviewId]    
			  ,[CreatedBy]    
			  ,[CreatedDate]    
			  ,[ModifiedBy]    
			  ,[ModifiedDate]    
			  ,[RecordDeleted]    
			  ,[DeletedBy]    
			  ,[DeletedDate]    
			  ,[DocumentVersionId]    
			  ,[SafetyCrisisPlanReviewed]    
			  ,CASE 
				WHEN [DateReviewed] IS NOT NULL
					THEN CONVERT(VARCHAR(10), [DateReviewed], 101)
				ELSE ''
				END DateReviewed   
			  ,[ReviewEveryXDays]    
			  ,[DescribePlanReview]    
			  ,[CrisisDisposition]    
			  ,CAST(ReviewEveryXDays as varchar(5)) + ' Days' AS [ReviewEveryDaysText] 
			  ,CrisisResolved
			  ,CASE WHEN CrisisResolved ='Y' THEN 'Yes' WHEN CrisisResolved ='N' THEN 'No' ELSE '' END AS CrisisResolvedText
			  ,[NextSafetyPlanReviewDate]          
		  FROM [CustomSafetyCrisisPlanReviews]    
		WHERE ISNULL(RecordDeleted, 'N') = 'N'             
			AND DocumentVersionId = @DocumentVersionId

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SubReportSafetyCrisisPlanReviews') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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