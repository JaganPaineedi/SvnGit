/****** Object:  StoredProcedure [dbo].[ssp_SCGetCollectionsFinancialActivityLines]    Script Date: 03/12/2015 18:17:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetCollectionsFinancialActivityLines]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetCollectionsFinancialActivityLines]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetCollectionsFinancialActivityLines]    Script Date: 03/12/2015 18:17:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetCollectionsFinancialActivityLines] @PaymentId INT
	,@FinancialActivityId INT
AS
-- =============================================    
-- Author      : Akwinass.D 
-- Date        : 27/AUG/2015  
-- Purpose     : To Get Payment Financial Activity Lines Records. 
-- Date              Author                  Purpose                   */
-- ============================================= 
BEGIN
	BEGIN TRY		
		SELECT CONVERT(VARCHAR(10), arl.PostedDate, 101) + ' ' + ISNULL(SUBSTRING(CONVERT(VARCHAR, arl.PostedDate, 100), 13, 2) + ':' + SUBSTRING(CONVERT(VARCHAR, arl.PostedDate, 100), 16, 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, arl.PostedDate, 100), 18, 2), '') AS PostedDate
		,arl.PaymentId
		,arl.FinancialActivityLineId
		,fal.FinancialActivityId
		FROM Arledger arl
		JOIN FinancialActivityLines fal ON fal.FinancialActivityLineId = arl.FinancialActivityLineId
		JOIN Charges ch ON ch.ChargeId = arl.ChargeId
		JOIN Services s ON s.ServiceId = ch.ServiceId
		JOIN Clients c ON c.ClientId = s.ClientId
		LEFT JOIN OpenCharges oc ON oc.ChargeId = ch.ChargeId
		JOIN ProcedureCodes pc ON pc.ProcedurecodeId = s.ProcedureCodeId
		LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = s.UnitType
		WHERE ISNULL(arl.ErrorCorrection, 'N') = 'N'
			AND fal.FinancialActivityId = @FinancialActivityId
		ORDER BY arl.PostedDate ASC
	END TRY

	BEGIN CATCH
		IF (@@error != 0)
		BEGIN
			RAISERROR 20006 'ssp_SCGetCollectionsFinancialActivityLines: An Error Occured'

			RETURN
		END
	END CATCH
END

GO


