/****** Object:  UserDefinedFunction [dbo].[ssf_SCGetPossibleCollections]    Script Date: 05/12/2015 12:21:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_SCGetPossibleCollections]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_SCGetPossibleCollections]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_SCGetPossibleCollections]    Script Date: 05/12/2015 12:21:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
CREATE FUNCTION [dbo].[ssf_SCGetPossibleCollections] (@Mode VARCHAR(50), @ClientId INT, @CollectionId INT)
/********************************************************************************    
-- Stored Procedure: dbo.ssf_SCGetPossibleCollections      
--    
-- Copyright: Streamline Healthcate Solutions 
--    
-- Updates:                                                           
-- Date			 Author			Purpose    
-- 17-AUG-2015	 Akwinass		What:To Get Possible Collections List page Fields.          
--								Why:task  #936 Valley - Customizations.
-- 18-Dec-2015	 Venkatesh MR	What:Take only current client balance from clients table.          
--								Why:task  #150 Valley Go Live Support
*********************************************************************************/ 
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @Result VARCHAR(MAX) = NULL
	--DECLARE @LastPaymentId INT
	
	--IF @Mode = 'DateOfLastVisitText'
	--BEGIN
	--	SELECT  TOP 1 @Result = CONVERT(VARCHAR, DateOfService, 101)
	--	FROM Services
	--	WHERE ClientId = @ClientId
	--		AND Isnull(RecordDeleted, 'N') <> 'Y'
	--		AND Billable = 'Y'
	--		AND [Status] IN (71,75)
	--	ORDER BY DateOfService DESC
	--END
	--ELSE IF @Mode = 'FinancialResponsible'
	--BEGIN
	--	SELECT TOP 1 @Result = CC.LastName + ', ' + CC.FirstName
	--	FROM ClientContacts CC
	--	JOIN Clients C ON CC.ClientId = C.ClientId
	--	LEFT JOIN GlobalCodes GC ON CC.Relationship = GC.GlobalCodeId
	--	WHERE CC.ClientId = @ClientId
	--		AND ISNULL(CC.RecordDeleted, 'N') = 'N'
	--		AND ISNULL(C.RecordDeleted, 'N') = 'N'
	--		AND ISNULL(CC.FinanciallyResponsible, 'N') = 'Y'
	--		AND ISNULL(CC.Active, 'N') = 'Y'
	--	ORDER BY CC.CreatedDate DESC
	--		,CC.ModifiedDate DESC
	--END
	--ELSE IF @Mode = 'DateOfLastPayment'
	--BEGIN
	--	SELECT TOP 1 @LastPaymentId = LastPaymentId
	--	FROM Clients
	--	WHERE ClientId = @ClientId
	--		AND ISNULL(RecordDeleted, 'N') = 'N'

	--	IF @LastPaymentId IS NOT NULL
	--	BEGIN
	--		SELECT TOP 1 @Result = DateReceived
	--		FROM Payments
	--		WHERE PaymentId = @LastPaymentId
	--			AND ISNULL(RecordDeleted, 'N') = 'N'
	--	END

	--	IF @Result IS NULL
	--	BEGIN
	--		SELECT TOP 1 @Result = CONVERT(VARCHAR, Payments.DateReceived, 101)
	--		FROM Payments
	--		LEFT JOIN Payers ON Payments.PayerId = Payers.PayerId
	--		LEFT JOIN CoveragePlans ON Payments.CoveragePlanId = CoveragePlans.CoveragePlanId
	--		LEFT JOIN Payers Payer2 ON CoveragePlans.PayerId = Payer2.PayerId
	--		LEFT JOIN Clients ON Payments.ClientId = Clients.ClientId
	--		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = Payments.LocationId
	--		LEFT JOIN Staff S ON Payments.CreatedBy = S.UserCode
	--		WHERE ISNULL(Payments.RecordDeleted, 'N') = 'N'
	--			AND Payments.ClientId = @ClientId
	--		ORDER BY Payments.DateReceived DESC
	--	END
	--END
	--ELSE IF @Mode = 'PrimaryProgram'
	--BEGIN
	--	SELECT TOP 1 @Result = P.ProgramCode
	--	FROM ClientPrograms AS cp
	--	INNER JOIN Programs p ON cp.ProgramId = p.ProgramId AND ISNULL(p.RecordDeleted, 'N') = 'N' AND ISNULL(p.Active, 'N') = 'Y'
	--	WHERE cp.ClientId = @ClientId AND ISNULL(cp.RecordDeleted, 'N') = 'N' AND cp.[Status] = 4 AND ISNULL(cp.PrimaryAssignment, 'N') = 'Y'
	--END
	--ELSE IF @Mode = 'DateOfLastVisitId'
	--BEGIN
	--	SELECT  TOP 1 @Result = CAST(ServiceId AS VARCHAR(25))
	--	FROM Services
	--	WHERE ClientId = @ClientId
	--		AND Isnull(RecordDeleted, 'N') <> 'Y'
	--		AND Billable = 'Y'
	--		AND [Status] IN (71,75)
	--	ORDER BY DateOfService DESC
	--END
	--ELSE IF @Mode = 'DateOfLastPaymentId'
	--BEGIN
	--	SELECT TOP 1 @LastPaymentId = LastPaymentId
	--	FROM Clients
	--	WHERE ClientId = @ClientId
	--		AND ISNULL(RecordDeleted, 'N') = 'N'

	--	IF @LastPaymentId IS NOT NULL
	--	BEGIN
	--		SELECT TOP 1 @Result = PaymentId
	--		FROM Payments
	--		WHERE PaymentId = @LastPaymentId
	--			AND ISNULL(RecordDeleted, 'N') = 'N'
	--	END

	--	IF @Result IS NULL
	--	BEGIN
	--		SELECT TOP 1 @Result = CAST(Payments.PaymentId AS VARCHAR(25))
	--		FROM Payments
	--		LEFT JOIN Payers ON Payments.PayerId = Payers.PayerId
	--		LEFT JOIN CoveragePlans ON Payments.CoveragePlanId = CoveragePlans.CoveragePlanId
	--		LEFT JOIN Payers Payer2 ON CoveragePlans.PayerId = Payer2.PayerId
	--		LEFT JOIN Clients ON Payments.ClientId = Clients.ClientId
	--		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = Payments.LocationId
	--		LEFT JOIN Staff S ON Payments.CreatedBy = S.UserCode
	--		WHERE ISNULL(Payments.RecordDeleted, 'N') = 'N'
	--			AND Payments.ClientId = @ClientId
	--		ORDER BY Payments.DateReceived DESC
	--	END
	--END
	--ELSE IF @Mode = 'FinancialActivityId'
	--BEGIN
	--	SELECT TOP 1 @Result = CAST(Payments.FinancialActivityId AS VARCHAR(25))
	--	FROM Payments
	--	LEFT JOIN Payers ON Payments.PayerId = Payers.PayerId
	--	LEFT JOIN CoveragePlans ON Payments.CoveragePlanId = CoveragePlans.CoveragePlanId
	--	LEFT JOIN Payers Payer2 ON CoveragePlans.PayerId = Payer2.PayerId
	--	LEFT JOIN Clients ON Payments.ClientId = Clients.ClientId
	--	LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = Payments.LocationId
	--	LEFT JOIN Staff S ON Payments.CreatedBy = S.UserCode
	--	LEFT JOIN FinancialActivities ON Payments.FinancialActivityId = FinancialActivities.FinancialActivityId
	--	WHERE ISNULL(Payments.RecordDeleted, 'N') = 'N'
	--		AND Payments.ClientId = @ClientId
	--	ORDER BY Payments.DateReceived DESC
	--END
	--ELSE IF @Mode = 'LastPaymentAmount'
	--BEGIN
	--	SELECT TOP 1 @LastPaymentId = LastPaymentId
	--	FROM Clients
	--	WHERE ClientId = @ClientId
	--		AND ISNULL(RecordDeleted, 'N') = 'N'

	--	IF @LastPaymentId IS NOT NULL
	--	BEGIN
	--		SELECT TOP 1 @Result = '$' + CAST(CAST(Payments.Amount AS DECIMAL(18,2)) AS VARCHAR(25))
	--		FROM Payments
	--		WHERE PaymentId = @LastPaymentId
	--			AND ISNULL(RecordDeleted, 'N') = 'N'
	--	END

	--	IF @Result IS NULL
	--	BEGIN
	--		SELECT TOP 1 @Result = '$' + CAST(CAST(Payments.Amount AS DECIMAL(18,2)) AS VARCHAR(25))
	--		FROM Payments
	--		LEFT JOIN Payers ON Payments.PayerId = Payers.PayerId
	--		LEFT JOIN CoveragePlans ON Payments.CoveragePlanId = CoveragePlans.CoveragePlanId
	--		LEFT JOIN Payers Payer2 ON CoveragePlans.PayerId = Payer2.PayerId
	--		LEFT JOIN Clients ON Payments.ClientId = Clients.ClientId
	--		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = Payments.LocationId
	--		LEFT JOIN Staff S ON Payments.CreatedBy = S.UserCode
	--		WHERE ISNULL(Payments.RecordDeleted, 'N') = 'N'
	--			AND Payments.ClientId = @ClientId
	--		ORDER BY Payments.DateReceived DESC
	--	END
	--END
	--ELSE IF @Mode = 'StatusDate'
	--BEGIN
	--	SELECT TOP 1 @Result = CONVERT(VARCHAR, CreatedDate, 101)
	--	FROM CollectionStatusHistory
	--	WHERE CollectionId = @CollectionId
	--		AND ISNULL(RecordDeleted, 'N') = 'N'
	--	ORDER BY CreatedDate DESC
	--END	
	--ELSE IF @Mode = 'LastContactDate'
	--BEGIN	
	--	SELECT TOP 1 @Result = CONVERT(VARCHAR, CCN.ContactDateTime, 101)
	--	FROM ClientContactNotes CCN
	--	INNER JOIN Clients C ON C.ClientId = CCN.ClientId
	--		AND CCN.ClientId = @ClientId
	--		AND ISNULL(C.RecordDeleted, 'N') <> 'Y'
	--		AND ISNULL(CCN.RecordDeleted, 'N') <> 'Y'
	--	WHERE CCN.ContactStatus IN (371)
	--	ORDER BY CCN.ContactDateTime DESC
	--END
	--ELSE IF @Mode = 'LastContactDateId'
	--BEGIN	
	--	SELECT TOP 1 @Result = CAST(ClientContactNoteId AS VARCHAR(25))
	--	FROM ClientContactNotes CCN
	--	INNER JOIN Clients C ON C.ClientId = CCN.ClientId
	--		AND CCN.ClientId = @ClientId
	--		AND ISNULL(C.RecordDeleted, 'N') <> 'Y'
	--		AND ISNULL(CCN.RecordDeleted, 'N') <> 'Y'
	--	WHERE CCN.ContactStatus IN (371)
	--	ORDER BY CCN.ContactDateTime DESC
	--END
	--ELSE IF @Mode = 'NextContactDate'
	--BEGIN	
	--	SELECT TOP 1 @Result = CONVERT(VARCHAR, CCN.ContactDateTime, 101)
	--	FROM ClientContactNotes CCN
	--	INNER JOIN Clients C ON C.ClientId = CCN.ClientId
	--		AND CCN.ClientId = @ClientId
	--		AND ISNULL(C.RecordDeleted, 'N') <> 'Y'
	--		AND ISNULL(CCN.RecordDeleted, 'N') <> 'Y'
	--		AND CAST(CCN.ContactDateTime AS DATE) >= CAST(GETDATE() AS DATE)
	--	WHERE CCN.ContactStatus IN (370)
	--	ORDER BY CCN.ContactDateTime DESC
	--END
	--ELSE IF @Mode = 'NextContactDateId'
	--BEGIN	
	--	SELECT TOP 1 @Result = CAST(ClientContactNoteId AS VARCHAR(25))
	--	FROM ClientContactNotes CCN
	--	INNER JOIN Clients C ON C.ClientId = CCN.ClientId
	--		AND CCN.ClientId = @ClientId
	--		AND ISNULL(C.RecordDeleted, 'N') <> 'Y'
	--		AND ISNULL(CCN.RecordDeleted, 'N') <> 'Y'
	--		AND CAST(CCN.ContactDateTime AS DATE) >= CAST(GETDATE() AS DATE)
	--	WHERE CCN.ContactStatus IN (370)
	--	ORDER BY CCN.ContactDateTime DESC
	--END
	--ELSE
	IF @Mode = 'AmountDue'
	BEGIN	
		DECLARE @UnpostedAmount MONEY

		SELECT @UnpostedAmount = sum(UnpostedAmount)
		FROM Payments
		WHERE ClientId = @ClientID
			AND isnull(RecordDeleted, 'N') = 'N'
		GROUP BY ClientId

		SELECT @Result = CONVERT(VARCHAR, (isnull(CurrentBalance, 0))) --+ isnull(@UnpostedAmount, 0)))
		FROM Clients
		WHERE ClientId = @ClientId
			AND ISNULL(RecordDeleted, 'N') = 'N'
	END

	RETURN @Result
END

GO


