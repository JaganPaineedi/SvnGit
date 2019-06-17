
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetASAM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetASAM]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetASAM] @DocumentVersionId INT
AS
/*********************************************************************/
/* Stored Procedure: [ssp_SCGetASAM]   */
/*       Date              Author                  Purpose                   */
/*      04-05-2016     Dhanil Manuel               To Retrieve Data #114 SWMBH Enhancements*/
/*********************************************************************/
BEGIN
	BEGIN TRY
		
		SELECT DocumentVersionId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedDate
		,DeletedBy
		,Dimension1LevelOfCare
		,Dimension1Level
		,Dimension1DocumentedRisk
		,Dimension1Comments
		,Dimension1Summary
		,Dimension2LevelOfCare
		,Dimension2Level
		,Dimension2DocumentedRisk
		,Dimension2Comments
		,Dimension2Summary
		,Dimension3LevelOfCare
		,Dimension3Level
		,Dimension3DocumentedRisk
		,Dimension3Comments
		,Dimension3Summary
		,Dimension4LevelOfCare
		,Dimension4Level
		,Dimension4DocumentedRisk
		,Dimension4Comments
		,Dimension4Summary
		,Dimension5LevelOfCare
		,Dimension5Level
		,Dimension5DocumentedRisk
		,Dimension5Comments
		,Dimension5Summary
		,Dimension6LevelOfCare
		,Dimension6Level
		,Dimension6DocumentedRisk
		,Dimension6Comments
		,Dimension6Summary
		,IndicatedReferredLevel
		,ProvidedLevel
		,FinalDeterminationComments
		,FinalDeterminationSummary
		FROM DocumentASAMs
		WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted, 'N') = 'N'

      
	
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetASAM') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


