/****** Object:  StoredProcedure [dbo].[ssp_SCGetArledgerAmountSum]    Script Date: 12/15/2016 11:28:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetArledgerAmountSum]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetArledgerAmountSum]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetArledgerAmountSum]    Script Date: 12/15/2016 11:28:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetArledgerAmountSum]
	/********************************************************************************                                                    
-- Stored Procedure: [ssp_SCGetArledgerAmountSum]  
--  
-- Copyright: Streamline Healthcare Solutions  
--  
-- Purpose: To return sum of Arledger Amount.  
--  
-- Author:  Akwinass  
-- Date:    20-DEC-2016
--  
******************************************************************************* 
** Change History 
******************************************************************************* 
** Date: 			Author: 			Description: 
** 
-------- 			-------- 			--------------- 
-- 20 DEC 2016      Akwinass            Created. (Task #391 in Philhaven Development)
-- 21 DEC 2016      Akwinass            Payments table used to get applied amount. (Task #391 in Philhaven Development)
*******************************************************************************/
@FinancialActivityId INT,@Mode VARCHAR(10) = NULL
AS
BEGIN
	BEGIN TRY
		DECLARE @Payments INT
		SELECT ((Amount) - (CASE WHEN ISNULL(UnpostedAmount, 0) < 0 AND ISNULL(@Mode,'') = 'validate' THEN 0 ELSE ISNULL(UnpostedAmount, 0) END)) AS SUMAmount FROM Payments WHERE FinancialActivityId = @FinancialActivityId
		
		--SELECT -SUM(CASE WHEN arl.LedgerType = 4202 THEN arl.Amount ELSE 0 END) AS SUMAmount
		--FROM Arledger arl
		--JOIN FinancialActivityLines fal ON fal.FinancialActivityLineId = arl.FinancialActivityLineId
		--JOIN Charges ch ON ch.ChargeId = arl.ChargeId
		--JOIN Services s ON s.ServiceId = ch.ServiceId
		--JOIN Clients c ON c.ClientId = s.ClientId
		--LEFT JOIN OpenCharges oc ON oc.ChargeId = ch.ChargeId
		--JOIN ProcedureCodes pc ON pc.ProcedurecodeId = s.ProcedureCodeId
		--LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = s.UnitType
		--WHERE ISNULL(arl.ErrorCorrection, 'N') = 'N'
		--	AND fal.FinancialActivityId = @FinancialActivityId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetArledgerAmountSum') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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