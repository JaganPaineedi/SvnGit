IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCCheckClientFeeInitCSPExists]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCCheckClientFeeInitCSPExists]
GO

CREATE PROCEDURE [dbo].[ssp_SCCheckClientFeeInitCSPExists] (
	@InitcspName VARCHAR(1000)
	)
AS
/*********************************************************************/
/* Stored Procedure: [ssp_SCCheckClientFeeInitCSPExists]                  */
/* Creation Date:  20/JULY/2015                                     */
/* Purpose: To check Initialize DFA CSP Exists or Not                         */
/* Input Parameters:   @InitcspName                           */
/*********************************************************************/
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].['+@InitcspName+']') AND type IN (N'P',N'PC'))
		BEGIN
			SELECT 'Yes' AS IsExists
		END
		ELSE
		BEGIN
			SELECT TOP 0 'No'  AS IsExists
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCCheckClientFeeInitCSPExists]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                      
				16
				,-- Severity.                                                                                                      
				1 -- State.                                                                                                      
				);
	END CATCH
END
 