/****** Object:  StoredProcedure [dbo].[ssp_PMClaimsProcessingData]    Script Date: 04/16/2012 14:51:11 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMPaymentAdjustmentPostNew]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_PMPaymentAdjustmentPostNew]

/****** Object:  StoredProcedure [dbo].[ssp_PMPaymentAdjustmentPostNew]    Script Date: 04/16/2012 14:51:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Shruthi.S
-- Create date: 8/6/2012
-- Description:	Update the ModifeidDAte and get the latest Payments table data.
-- Aug-10-2015	PradeepA	Added TypeOfPosting,CopayAllocated. SummitPointe Support #547
-- 19 Oct 2015  Revathi    what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.      
--							why:task #609, Network180 Customization 
-- =============================================
CREATE PROCEDURE [dbo].[ssp_PMPaymentAdjustmentPostNew] @PaymentId INT
	,@ModifiedDate DATETIME
AS
BEGIN
	BEGIN TRY
		UPDATE Payments
		SET ModifiedDate = @ModifiedDate
		WHERE PaymentId = @PaymentId

		SELECT P.PaymentId
			,P.FinancialActivityId
			,P.PayerId
			,P.CoveragePlanId
			,P.ClientId
			,
			--Added by Revathi 19 Oct 2015
			CASE 
				WHEN ISNULL(C.ClientType, 'I') = 'I'
					THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
				ELSE ISNULL(C.OrganizationName, '')
				END AS ClientName
			,
			--convert(varchar,P.DateReceived,101) as DateReceived, 
			P.DateReceived
			,P.NameIfNotClient
			,P.ElectronicPayment
			,P.PaymentMethod
			,P.ReferenceNumber
			,P.CardNumber
			,P.ExpirationDate
			,P.Amount
			,P.LocationId
			,P.PaymentSource
			,P.UnpostedAmount
			,P.Comment
			,p.FundsNotReceived
			,p.TypeOfPosting
			,(	
				SELECT SUM(pc.Copayment)
				FROM PaymentCopayments pc
				WHERE pc.PaymentId = @PaymentId
					AND ISNULL(pc.RecordDeleted, 'N') = 'N'
				) AS CopayAllocated
			,P.RowIdentifier
			,P.CreatedBy
			,P.CreatedDate
			,P.ModifiedBy
			,P.ModifiedDate
			,P.RecordDeleted
			,P.DeletedDate
			,P.DeletedBy
		FROM Payments P
		LEFT JOIN Clients C ON C.ClientId = P.ClientId
		WHERE P.PaymentId = @PaymentId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
		+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' 
		+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMPaymentAdjustmentPostNew')
		 + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
		 + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
		 + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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

