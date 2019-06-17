/****** Object:  StoredProcedure [dbo].[ssp_SCGetFinancialActivityClientPayments]    Script Date: 02/09/2015 12:40:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetFinancialActivityClientPayments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetFinancialActivityClientPayments]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetFinancialActivityClientPayments]    Script Date: 02/09/2015 12:40:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetFinancialActivityClientPayments] (
	@ClientId INT
	,@StaffId INT
	,@FromDate DATETIME
	,@ToDate DATETIME
	,@ActivityType INT
	,@PayerType VARCHAR(10) = ''
	)
AS
/********************************************************************************                                                        
-- Stored Procedure: ssp_SCGetFinancialActivityClientPayments      
--      
-- Copyright: Streamline Healthcate Solutions      
--      
-- Purpose: Query to return data for the Client Payments.      
--      
-- Author:  Akwinass      
-- Date:    04 Feb 2015     
--      
-- *****History**** 
-- Updates
-- 8/8/2016  MD Hussain		Added condition to check the client Id in ARLedger table for Payer Payment condition w.r.t task #763 Valley - Support Go Live
*********************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @CustomFilters TABLE (PaymentId INT NOT NULL,StaffId INT)

		INSERT INTO @CustomFilters (PaymentId,StaffId)
		SELECT Payments.PaymentId,S.StaffId
		FROM Payments
		LEFT JOIN Payers ON Payments.PayerId = Payers.PayerId
		LEFT JOIN CoveragePlans ON Payments.CoveragePlanId = CoveragePlans.CoveragePlanId
		LEFT JOIN Payers Payer2 ON CoveragePlans.PayerId = Payer2.PayerId
		LEFT JOIN Clients ON Payments.ClientId = Clients.ClientId
		LEFT JOIN FinancialActivities ON FinancialActivities.FinancialActivityId = Payments.FinancialActivityId
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = Payments.LocationId
		LEFT JOIN Staff S ON Payments.CreatedBy = S.UserCode
		WHERE ISNULL(Payments.RecordDeleted, 'N') = 'N'
			 AND FinancialActivities.ActivityType = @ActivityType

		IF @ActivityType = 4325
		BEGIN
			SELECT Payments.DateReceived AS ActivityDate
				,'Client Payment' AS Activity
				,'Payment Amount ' + '$' + convert(VARCHAR, Payments.Amount, 10) + ' – Current Balance $' + CASE WHEN CHARINDEX('-', convert(VARCHAR(30), isnull(Payments.UnpostedAmount, 0.00), 1)) > 0 THEN '(' + SUBSTRING(convert(VARCHAR(30), isnull(Payments.UnpostedAmount, 0.00), 1), 2, LEN(convert(VARCHAR(30), isnull(Payments.UnpostedAmount, 0.00), 1))) + ')' ELSE convert(VARCHAR(30), isnull(Payments.UnpostedAmount, 0.00), 1) END AS [Description]
				,S.LastName + ', ' + S.FirstName AS Staff
				,Payments.PaymentID
				,Payments.FinancialActivityId
			FROM @CustomFilters a
			JOIN Payments ON (Payments.PaymentId = a.PaymentId)
			LEFT JOIN Payers ON Payments.PayerId = Payers.PayerId
			LEFT JOIN CoveragePlans ON Payments.CoveragePlanId = CoveragePlans.CoveragePlanId
			LEFT JOIN Clients ON Payments.ClientId = Clients.ClientId
			LEFT JOIN GlobalCodes ON GlobalCodes.GlobalCodeId = Payments.PaymentMethod
			LEFT JOIN FinancialActivities ON FinancialActivities.FinancialActivityId = Payments.FinancialActivityId
			LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = Payments.LocationId
			LEFT JOIN ErBatches erb ON ERB.PaymentiD = Payments.PAYMENTID
			LEFT JOIN Staff S ON a.StaffId = S.StaffId
			WHERE (a.StaffId = @StaffId OR @StaffId = 0)
				AND (Payments.ClientId = @ClientId OR @ClientId = 0)
				AND CAST(Payments.DateReceived AS DATE) >= CAST(@FromDate AS DATE)
				AND CAST(Payments.DateReceived AS DATE) <= CAST(@ToDate AS DATE)
		END

		IF @ActivityType = 4323 AND @PayerType = 'PLAN'
		BEGIN
			SELECT Payments.DateReceived AS ActivityDate
				,'Payer Payment' AS Activity
				,ISNULL(CoveragePlans.DisplayAs, '') + ' – ' + CAST((
						SELECT count(s.ServiceId)
						FROM Arledger arl
						JOIN FinancialActivityLines fal ON fal.FinancialActivityLineId = arl.FinancialActivityLineId
						JOIN Charges ch ON ch.ChargeId = arl.ChargeId
						JOIN Services s ON s.ServiceId = ch.ServiceId
						JOIN Clients c ON c.ClientId = s.ClientId				
						JOIN ProcedureCodes pc ON pc.ProcedurecodeId = s.ProcedureCodeId				
						WHERE ISNULL(arl.ErrorCorrection, 'N') = 'N'
							AND ISNULL(arl.RecordDeleted, 'N') = 'N'
							AND fal.FinancialActivityId = Payments.FinancialActivityId
							AND c.ClientId = @ClientId
						) AS VARCHAR(10)) + ' services  – $' + convert(VARCHAR, Payments.Amount, 10)
				,S.LastName + ', ' + S.FirstName AS Staff
				,Payments.PaymentID
				,Payments.FinancialActivityId
			FROM @CustomFilters a
			JOIN Payments ON (Payments.PaymentId = a.PaymentId)
			JOIN CoveragePlans ON Payments.CoveragePlanId = CoveragePlans.CoveragePlanId AND ISNULL(CoveragePlans.Capitated,'N') = 'N'
			LEFT JOIN ClientCoveragePlans ccp ON CoveragePlans.CoveragePlanId = ccp.CoveragePlanId
			LEFT JOIN Payers ON Payments.PayerId = Payers.PayerId
			LEFT JOIN Staff S ON a.StaffId = S.StaffId
			WHERE (a.StaffId = @StaffId OR @StaffId = 0)
				AND (ccp.ClientId = @ClientId OR @ClientId = 0)
				--- Added by MD on 8/8/2016
				AND (@ClientId = 0 OR EXISTS(SELECT 1 FROM ARLedger ar WHERE Payments.PaymentId = ar.PaymentId and ar.ClientId=@ClientId))
				-----END-------------------
				AND CAST(Payments.DateReceived AS DATE) >= CAST(@FromDate AS DATE)
				AND CAST(Payments.DateReceived AS DATE) <= CAST(@ToDate AS DATE)
		END

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetFinancialActivityClientPayments') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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

--IF @ActivityType = 4323 AND @PayerType = 'PAYER'
--BEGIN
--	SELECT Payments.DateReceived AS ActivityDate
--		,'Payer Payment' AS Activity
--		,ISNULL(Payers.PayerName, '') + ' – ' + CAST((
--				SELECT count(s.ServiceId)
--				FROM Arledger arl
--				JOIN FinancialActivityLines fal ON fal.FinancialActivityLineId = arl.FinancialActivityLineId
--				JOIN Charges ch ON ch.ChargeId = arl.ChargeId
--				JOIN Services s ON s.ServiceId = ch.ServiceId
--				JOIN Clients c ON c.ClientId = s.ClientId				
--				JOIN ProcedureCodes pc ON pc.ProcedurecodeId = s.ProcedureCodeId				
--				WHERE ISNULL(arl.ErrorCorrection, 'N') = 'N'
--					AND ISNULL(arl.RecordDeleted, 'N') = 'N'
--					AND fal.FinancialActivityId = Payments.FinancialActivityId
--					AND c.ClientId = @ClientId
--				) AS VARCHAR(10)) + ' services  – $' + convert(VARCHAR, Payments.Amount, 10)
--		,S.LastName + ', ' + S.FirstName AS Staff
--		,Payments.PaymentID
--		,Payments.FinancialActivityId
--	FROM @CustomFilters a
--	JOIN Payments ON (Payments.PaymentId = a.PaymentId)
--	JOIN Payers ON Payments.PayerId = Payers.PayerId
--	LEFT JOIN CoveragePlans ON Payments.CoveragePlanId = CoveragePlans.CoveragePlanId
--	LEFT JOIN Staff S ON a.StaffId = S.StaffId
--	WHERE (a.StaffId = @StaffId OR @StaffId = 0)
--		AND CAST(Payments.DateReceived AS DATE) >= CAST(@FromDate AS DATE)
--		AND CAST(Payments.DateReceived AS DATE) <= CAST(@ToDate AS DATE)
--		AND (select COUNT(p.PayerId) from Payers p join CoveragePlans c on p.PayerId = c.PayerId and ISNULL(c.Capitated,'N') = 'Y' where p.PayerId = Payers.PayerId ) = 0
--END


