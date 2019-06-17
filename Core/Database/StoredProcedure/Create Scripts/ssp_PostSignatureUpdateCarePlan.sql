IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PostSignatureUpdateCarePlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PostSignatureUpdateCarePlan]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PostSignatureUpdateCarePlan]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_PostSignatureUpdateCarePlan] (
@DocumentVersionId INT)
AS
/******************************************************************** */
/* Stored Procedure: [ssp_PostSignatureUpdateCarePlan]   2772                 */
/* Creation Date:  24/FEB/2015                                        */
/* Purpose: To Initialize                                             */
/* Called By: Care Plan To do document creation on sign               */
/* Calls:                                                             */
/*                                                                    */
/* Data Modifications:                                                */
/*   Updates:                                                         */
/*  09/May/2016  	Veena 		Post update SP for Care Plan Document */
/*  27/May/2016  	Neelima 		Post update SP for Care Plan Document */
/*  30/May/2016     Veena          Code cleanup     */
/**********************************************************************/
BEGIN
	BEGIN TRY
  --Added by Neelima
		IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCPostUpdateCarePlan]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
			BEGIN
				EXEC scsp_SCPostUpdateCarePlan @DocumentVersionId		
			END
			
	END TRY  

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_PostSignatureUpdateCarePlan') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


