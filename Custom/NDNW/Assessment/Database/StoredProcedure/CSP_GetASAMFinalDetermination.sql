/****** Object:  StoredProcedure [dbo].[CSP_GetASAMFinalDetermination]    Script Date: 03/10/2015 11:03:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CSP_GetASAMFinalDetermination]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CSP_GetASAMFinalDetermination]
GO

/****** Object:  StoredProcedure [dbo].[CSP_GetASAMFinalDetermination]    Script Date: 03/10/2015 11:03:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[CSP_GetASAMFinalDetermination] @ClientId INT
AS
/*Purpose: To get FinalDeterminationComments from CustomDocumentASAMs       */
/* Return:   FinalDeterminationComments from CustomDocumentASAMs       */
/* Called By: Assessment         */
/* Data Modifications:                 */
/*   Updates:                  */
/*   Date              Author                Purpose      */
--13 Jan 2015		Vithobha   to get FinalDeterminationComments from CustomDocumentASAMs    
--10 Mar 2015		Akwinass   Initialized from Most recent signed ASAM Final Determination (Task #109 in Valley Client Acceptance Testing Issues)
BEGIN
	BEGIN TRY
		DECLARE @LatestDocumentVersionID INT
		DECLARE @EffectiveDate DATETIME
		DECLARE @Months DECIMAL(10, 5)

		SELECT TOP 1 @LatestDocumentVersionID = CurrentDocumentVersionId
			,@EffectiveDate = EffectiveDate
		FROM CustomDocumentASAMs CDCD
		INNER JOIN Documents Doc ON CDCD.DocumentVersionId = Doc.CurrentDocumentVersionId
		WHERE Doc.ClientId = @ClientID
			AND Doc.[Status] = 22
			AND ISNULL(CDCD.RecordDeleted, 'N') = 'N'
			AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
		ORDER BY Doc.ModifiedDate DESC

		SET @LatestDocumentVersionId = ISNULL(@LatestDocumentVersionId, - 1)

		IF @EffectiveDate IS NOT NULL
		BEGIN
			SET @Months = CASE WHEN DATEDIFF(d, @EffectiveDate, GETDATE()) > 30 THEN DATEDIFF(d, @EffectiveDate, GETDATE()) / 30.0 ELSE 0 END

			IF @Months > 6
			BEGIN
				SET @LatestDocumentVersionId = - 1
			END
		END

		IF EXISTS(SELECT C.FinalDeterminationComments FROM CustomDocumentASAMs C WHERE C.DocumentVersionId = @LatestDocumentVersionId)
		BEGIN
			SELECT CASE WHEN ISNULL(C.FinalDeterminationComments,'') = '' THEN 'No ASAM' ELSE ISNULL(C.FinalDeterminationComments,'No ASAM') END AS FinalDeterminationComments FROM CustomDocumentASAMs C WHERE C.DocumentVersionId = @LatestDocumentVersionId
		END
		ELSE
		BEGIN
			SELECT 'No ASAM' AS FinalDeterminationComments
		END
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'CSP_GetASAMFinalDetermination') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


