/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientFeeInsurance]    Script Date: 07/24/2015 14:27:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientFeeInsurance]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientFeeInsurance]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientFeeInsurance]    Script Date: 07/24/2015 14:27:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetClientFeeInsurance]
	(@ClientFeeId INT)
AS
-- =============================================    
-- Author      : Akwinass
-- Date        : 10 NOV 2015 
-- Purpose     : Get Client Coverage Plans (Insurance). 
-- =============================================   
BEGIN
	BEGIN TRY
		DECLARE @ClientId INT = 0
		DECLARE @CoveragePlanId INT = 0

		SELECT TOP 1 @ClientId = ClientId
			,@CoveragePlanId = CoveragePlanId
		FROM ClientFees
		WHERE ClientFeeId = @ClientFeeId
			AND ISNULL(RecordDeleted, 'N') = 'N'

		SELECT CCP.ClientCoveragePlanId
			,CCP.CreatedBy
			,CCP.CreatedDate
			,CCP.ModifiedBy
			,CCP.ModifiedDate
			,CCP.RecordDeleted
			,CCP.DeletedDate
			,CCP.DeletedBy
			,CCP.ClientId
			,CCP.CoveragePlanId
			,CCP.InsuredId
			,CCP.GroupNumber
			,CCP.GroupName
			,CCP.ClientIsSubscriber
			,CCP.SubscriberContactId
			,CCP.CopayCollectUpfront
			,CCP.Deductible
			,CCP.ClientHasMonthlyDeductible
			,CCP.PlanContactPhone
			,CCP.LastVerified
			,CCP.VerifiedBy
			,CCP.MedicareSecondaryInsuranceType
			,CCP.Comment
			,CCP.AuthorizationRequiredOverride
			,CCP.NoAuthorizationRequiredOverride
			,CCP.OverrideClaim
			,CCP.CoveragePlanName
			,CCP.ElectronicClaimsPayerId
			,CCP.ElectronicClaimsOfficeNumber
			,CCP.AddressDisplay
			,CCP.ContactName
			,CCP.ContactPhone
			,CCP.ContactFax
			,CCP.ClaimInformationComment
			,CCP.OrganizationName
			,CCP.OrganizationContactName
			,CCP.OrganizationTelephone
			,CCP.OrganizationFax
			,CCP.OrganizationClaimAddress
			,CCP.OrganizationEmailAddress
			,CCP.OrganizationCommentText
		FROM ClientCoveragePlans CCP
		JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
		WHERE CCP.ClientId = @ClientId
			AND CP.CoveragePlanId = @CoveragePlanId
			AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
			AND ISNULL(CP.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
	END CATCH
END

GO


