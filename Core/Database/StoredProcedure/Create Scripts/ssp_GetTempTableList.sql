IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetTempTableList]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetTempTableList]
GO

CREATE PROCEDURE [dbo].[ssp_GetTempTableList] (@TableList VARCHAR(max))
AS
/*********************************************************************/
/* Stored Procedure: [ssp_GetTempTableList]				             */
/* Creation Date:  12 April 2016									 */
/* Purpose: To Get Temp Tables										 */
/* Input Parameters:   							                     */
/* Data Modifications:                                               */
/* Updates:														     */
/* Date              Author            Purpose						 */
/*-------------------------------------------------------------------*/
/* 04/12/2016       Vamsi            What:To get Temporary Tables  
                                     Why :Key Point - Support Go Live#131       */
/*********************************************************************/
BEGIN TRY
	SELECT TEMP.item AS TempTable
	FROM dbo.FNSPLIT(@TableList, ',') AS TEMP
	WHERE TEMP.item NOT IN (
			SELECT NAME
			FROM sys.Tables
			)
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetTempTableList') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                      
			16
			,-- Severity.                      
			1 -- State.                      
			);
END CATCH
