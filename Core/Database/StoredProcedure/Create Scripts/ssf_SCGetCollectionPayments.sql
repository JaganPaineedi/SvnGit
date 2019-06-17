/****** Object:  UserDefinedFunction [dbo].[ssf_SCGetCollectionPayments]    Script Date: 05/12/2015 12:21:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_SCGetCollectionPayments]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_SCGetCollectionPayments]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_SCGetCollectionPayments]    Script Date: 05/12/2015 12:21:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
CREATE FUNCTION [dbo].[ssf_SCGetCollectionPayments] (@PaymentId INT,@FinancialActivityId INT)
/********************************************************************************    
-- Stored Procedure: dbo.ssf_SCGetCollectionPayments      
--    
-- Copyright: Streamline Healthcate Solutions 
--    
-- Updates:                                                           
-- Date			 Author			Purpose    
-- 26-AUG-2015	 Akwinass		What:To Get Payment Post Date.          
--								Why:task  #936 Valley - Customizations.
*********************************************************************************/ 
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @Result VARCHAR(MAX) = ''	
	DECLARE @TotalCount INT = 0
	
	SELECT @TotalCount = COUNT(arl.ARLedgerId)
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
	
	SELECT TOP 1 @Result = CONVERT(VARCHAR(10), arl.PostedDate, 101) + ' ' + ISNULL(SUBSTRING(CONVERT(VARCHAR, arl.PostedDate, 100), 13, 2) + ':' + SUBSTRING(CONVERT(VARCHAR, arl.PostedDate, 100), 16, 2) + ' ' + SUBSTRING(CONVERT(VARCHAR, arl.PostedDate, 100), 18, 2), '')
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
	ORDER BY arl.PostedDate DESC
	
	IF @Result <> '' AND @TotalCount > 1
	BEGIN
		SET @Result = @Result + '...'
	END

	RETURN @Result
END

GO


