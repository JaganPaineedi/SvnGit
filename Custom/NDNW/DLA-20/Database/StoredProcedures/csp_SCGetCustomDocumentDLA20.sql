/****** Object:  StoredProcedure [dbo].[csp_RDLClientFaceSheetReport]    Script Date: 10/23/2014 09:59:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentDLA20]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentDLA20]
GO
/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentDLA20]    Script Date: 10/23/2014 09:59:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_SCGetCustomDocumentDLA20] (@DocumentVersionId INT)
AS
/*********************************************************************/
/* Stored Procedure: [csp_SCGetCustomDocumentDLA20]           */
/* Creation Date:  20 Jan 2017                                       */
/* Author:  K.Soujanya												  */
/* Purpose: To Get DLA Information			  */
/* Input Parameters:   @DocumentVersionId							  */
/* Output Parameters:												  */
/* Return:															  */
/* Called By: MHA - DLA										  */
/* Calls:                                                            */
/* What:Moved from F&CS to NDNW; Why:New Directions - Support Go Live ,Task#286*/
/* Data Modifications:                                               */
/*   Updates:                                                        */
/*       Date              Author                  Purpose			  */
/*********************************************************************/
BEGIN TRY
	DECLARE @ClientId INT
	DECLARE @clientAge VARCHAR(50)

	SET @ClientId = (
			SELECT ClientId
			FROM documents doc
			INNER JOIN DocumentVersions docv ON docv.DocumentId = doc.DocumentId
			WHERE DocumentVersionId = @DocumentVersionId
				AND ISNULL(docv.RecordDeleted, 'N') <> 'Y'
			)

	EXEC csp_CalculateAge @ClientId
		,@clientAge OUT

	-----Previous DLA Average Score --------------		
	DECLARE @latestDLADocumentVersionId INT;
	DECLARE @nQuestionsAnswered FLOAT
	DECLARE @avgDLAScore FLOAT
	DECLARE @sumDLAScore FLOAT

	SELECT TOP 1 @latestDLADocumentVersionId = CurrentDocumentVersionId
	FROM CustomYouthDLAScores C
	INNER JOIN Documents Doc ON C.DocumentVersionId = Doc.CurrentDocumentVersionId
	WHERE Doc.ClientId = @ClientID
		AND isnull(C.RecordDeleted, 'N') <> 'Y'
		AND isnull(C.ActivityScore, 0) <> 0
		AND Doc.STATUS = 22
		AND IsNull(C.RecordDeleted, 'N') = 'N'
		AND IsNull(Doc.RecordDeleted, 'N') = 'N'
		AND Doc.EffectiveDate <= GetDate()
	ORDER BY Doc.EffectiveDate ASC
		,Doc.ModifiedDate ASC

	SELECT @nQuestionsAnswered = count(*)
		,@sumDLAScore = sum(dla.ActivityScore)
	FROM CustomYouthDLAScores AS dla
	WHERE dla.DocumentVersionId = @latestDLADocumentVersionId
		AND isnull(dla.RecordDeleted, 'N') <> 'Y'
		AND isnull(dla.ActivityScore, 0) <> 0;

	SET @avgDLAScore = (@sumDLAScore / @nQuestionsAnswered)

	SELECT CCD.DocumentVersionId
		,CCD.[CreatedBy]
		,CCD.[CreatedDate]
		,CCD.[ModifiedBy]
		,CCD.[ModifiedDate]
		,CCD.[RecordDeleted]
		,CCD.[DeletedDate]
		,CCD.[DeletedBy]
		,@clientAge AS ClientAge
		,CAST(@avgDLAScore AS VARCHAR(10)) AS LatestAverageDLA
		,NoDLA
	FROM [CustomDocumentDLA20s] CCD
	WHERE ISNull(CCD.RecordDeleted, 'N') = 'N'
		AND CCD.DocumentVersionId = @DocumentVersionId

	SELECT DailyLivingActivityScoreId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,DocumentVersionId
		,HRMActivityId
		,ActivityScore
		,ActivityComment
		,RowIdentifier
	FROM CustomDailyLivingActivityScores
	WHERE ISNull(RecordDeleted, 'N') = 'N'
		AND DocumentVersionId = @DocumentVersionId

	SELECT YouthDLAScoreId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,DocumentVersionId
		,DailyLivingActivityId
		,ActivityScore
		,ActivityComment
	FROM CustomYouthDLAScores
	WHERE ISNull(RecordDeleted, 'N') = 'N'
		AND DocumentVersionId = @DocumentVersionId
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SCGetCustomDocumentDLA20') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                      
			16
			,-- Severity.                      
			1 -- State.                      
			);
END CATCH
GO
