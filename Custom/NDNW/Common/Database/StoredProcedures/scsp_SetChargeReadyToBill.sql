IF OBJECT_ID('scsp_SetChargeReadyToBill', 'P') IS NOT NULL
	DROP PROC scsp_SetChargeReadyToBill;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE scsp_SetChargeReadyToBill @ChargeId INT
AS
/******************************************************************************************/
--
--	Purpose:		Perform custom ready to bill checks
--
--	Created Date:	08 Feb 2019
--
--	Change Date		Change By		Reason
--
--	08 Feb 2019		MJensen			Created for New Directions Enhancements #952
--									Remove auth required errors for Trillium prior to 2/1/2019
--
/******************************************************************************************/
BEGIN TRY
	DECLARE @TrilliumPlanId INT = 316;-- applies only to Trillium coverage plan
	DECLARE @AuthBeginDate DATE = '20190201';-- Auth requirement starts on 1 FEB 2019

	DELETE
	FROM #Errors
	WHERE ErrorType = 4543 -- auth is required
		AND EXISTS (
			SELECT 1
			FROM Charges c
			JOIN Services s ON s.ServiceId = c.ServiceId
			JOIN ClientCoveragePlans ccp ON ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
			WHERE c.ChargeId = @ChargeId
				AND ccp.CoveragePlanId = @TrilliumPlanId
				AND s.DateOfService < @AuthBeginDate
			)
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000);

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'scsp_SetChargeReadyToBill ') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE());

	RAISERROR (
			@Error
			,-- Message text.                                          
			16
			,-- Severity.                                          
			1 -- State.                                          
			);
END CATCH;
GO

