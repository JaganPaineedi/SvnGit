IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetSISTempReports]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetSISTempReports]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetSISTempReports] 
(@DocumentVersionId INT)
AS
-- Author:  <Jayashree Behera>                            
-- Create date: <3 Nov 2015>                                    
             
/*     Date              Author                     Purpose                                    */
/*********************************************************************/
BEGIN
	BEGIN TRY
		BEGIN
			EXEC SCSP_GetSISTempReports @DocumentVersionId
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetSISTempReports') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                  
				16
				,-- Severity.                                                                                                  
				1 -- State.                                                                             
				);
	END CATCH
END
