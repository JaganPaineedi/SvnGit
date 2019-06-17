/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentDLA20]    Script Date: 08/19/2014 14:19:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentDLA20]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDocumentDLA20]
GO

/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentDLA20]    Script Date: 08/19/2014 14:19:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[csp_InitCustomDocumentDLA20] (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
/*********************************************************************/
/* Stored Procedure: [csp_InitCustomDocumentDLA20]            */
/* Creation Date:  20 Jan 2016                                      */
/* Author:  K.Soujanya												  */
/* Purpose: To Initialize MHA DLA            					  */
/* Input Parameters:   @ClientID,@StaffID ,@CustomParameters         */
/* Output Parameters:												  */
/* Return:															  */
/* Called By: DLA												  */
/* Calls:                                                            */
/* What:Moved from F&CS to NDNW; Why:New Directions - Support Go Live ,Task#286*/
/* Data Modifications:                                               */
/*   Updates:                                                        */
/*   Date               Author                  Purpose			  */
/*  2nd April 2019       Ponnin					Logic added to pull CustomDailyLivingActivityScores from the last signed DLA20 document. Why: New Directions Call1 Feb 13 2019   */ 
/*********************************************************************/
BEGIN
	BEGIN TRY
	DECLARE @LatestDocumentVersionID INT
declare @clientAge varchar(50)
	    Exec csp_CalculateAge @ClientId, @clientAge out 
	    SET @LatestDocumentVersionID = (
				SELECT TOP 1 CurrentDocumentVersionId
				FROM CustomDocumentDLA20s CDNA
				INNER JOIN Documents Doc ON CDNA.DocumentVersionId = Doc.CurrentDocumentVersionId
				WHERE Doc.ClientId = @ClientID
					AND Doc.[Status] = 22
					AND ISNULL(CDNA.RecordDeleted, 'N') = 'N'
					AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
				ORDER BY Doc.EffectiveDate DESC
					,Doc.ModifiedDate DESC
				)
		SET @LatestDocumentVersionId = ISNULL(@LatestDocumentVersionId, - 1)

		SELECT 'CustomDocumentDLA20s' AS TableName		
			,- 1 AS DocumentVersionId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate			
			,@clientAge as ClientAge
		FROM systemconfigurations s
		
		
		IF(@LatestDocumentVersionID > 0 )
		BEGIN
		   SELECT 'CustomDailyLivingActivityScores' AS TableName
			,DailyLivingActivityScoreId
			,'' AS CreatedBy  
			,GETDATE() AS CreatedDate  
			,'' AS ModifiedBy  
			,GETDATE() AS ModifiedDate  
			,- 1 AS DocumentVersionId  
			,HRMActivityId
			,ActivityScore
			,ActivityComment
			,RowIdentifier
			FROM CustomDailyLivingActivityScores Where DocumentVersionId = @LatestDocumentVersionID  
		END
  
		--LEFT OUTER JOIN CustomDailyLivingActivityScores CDMS ON CDMS.DocumentVersionId = @LatestDocumentVersionID
		
		--Exec csp_InitCustomDocumentMHAdla @ClientID,@StaffID ,@CustomParameters 
		--Exec csp_InitCustomDocumentMHAdlaYouth @ClientID,@StaffID ,@CustomParameters 	
		
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_InitCustomDocumentDLA20') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


