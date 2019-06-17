IF OBJECT_ID('scsp_PMCreateInitialCharge', 'P') IS NOT NULL
	DROP PROC scsp_PMCreateInitialCharge;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE scsp_PMCreateInitialCharge @ChargeId INT
AS
/******************************************************************************************/
--
--	Purpose:		Temporary mod to put insured id in charges.comments for certain coverage plans
--
--	Created Date:	27 Jun 2018
--
--	Change Date		Change By		Reason
--
--	27 Jun 2018		MJensen			Created for ARM enhancements #48
--
/******************************************************************************************/
BEGIN TRY
	UPDATE c
	SET c.Comments = ISNULL(c.comments, '') + ' Insured ID: ' + ccp.InsuredId
	FROM Charges c
	JOIN ClientCoveragePlans ccp ON ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
	WHERE c.ChargeId = @ChargeId
		AND ccp.CoveragePlanId IN (
			360
			,359
			,362
			,361
			,367
			,368
			)
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000);

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'scsp_PMCreateInitialCharge ') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE());

	RAISERROR (
			@Error
			,-- Message text.                                          
			16
			,-- Severity.                                          
			1 -- State.                                          
			);
END CATCH;
GO

