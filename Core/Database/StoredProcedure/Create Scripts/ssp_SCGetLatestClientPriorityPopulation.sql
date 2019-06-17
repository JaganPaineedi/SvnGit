IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetLatestClientPriorityPopulation]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetLatestClientPriorityPopulation] 
GO

/*********************************************************************/
/* Stored Procedure: [ssp_SCGetLatestClientPriorityPopulation]              */
/* Date              Author                  Purpose                  */
/* 06/19/2015        Hemant                  To initialize the LatestClientPriorityPopulation   */
/*********************************************************************/
/**  Change History **/                                                                         
/********************************************************************************/                                                                           
/**  Date:    Author:     Description: **/                                                                         
/**  --------  --------    ------------------------------------------- */  

CREATE PROCEDURE [dbo].[ssp_SCGetLatestClientPriorityPopulation] @ClientId INT 
 
AS
BEGIN
	BEGIN TRY
	
	

IF OBJECT_ID('dbo.scsp_SCGetLatestClientPriorityPopulation', 'P') IS NOT NULL
   BEGIN
   exec scsp_SCGetLatestClientPriorityPopulation  @ClientId   
   END
	END TRY 

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetLatestClientPriorityPopulation') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END
GO

