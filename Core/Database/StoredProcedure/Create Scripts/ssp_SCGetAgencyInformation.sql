IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'[ssp_SCGetAgencyInformation]')
			AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1
		)
	DROP PROCEDURE [dbo].[ssp_SCGetAgencyInformation]
GO

CREATE PROCEDURE [dbo].[ssp_SCGetAgencyInformation]
AS
-----------------------------------------------------------
-- Stored Procedure: ssp_SCGetAgencyInformation
-- Copyright: Streamline Healthcare Solutions
-- Purpose: Retrieve AgencyInformation
--
-- Author:  Pradeep
-- Date:    02 Feb 2012
-- History
-- 10/06/2015	PradeepA	Added GetProviderNamefromAgencyForEligibilityVerification key to get the ProviderName based on the value.
-----------------------------------------------------------
BEGIN
	DECLARE @ProviderNamefromAgencyForEligibilityVerification CHAR(1)
	DECLARE @ProviderNameForEligibilityVerification VARCHAR(MAX)

	SELECT @ProviderNamefromAgencyForEligibilityVerification = dbo.ssf_GetSystemConfigurationKeyValue('GETPROVIDERNAMEFROMAGENCYFORELIGIBILITYVERIFICATION')

	IF ISNULL(@ProviderNamefromAgencyForEligibilityVerification, 'Y') = 'Y' 
	BEGIN
		SELECT AgencyName
			,Address
			,City
			,STATE
			,ZipCode
			,AddressDisplay
			,PaymentAddress
			,PaymentCity
			,PaymentState
			,PaymentZip
			,PaymentAddressDisplay
			,TaxId
			,CountyFIPS
			,MainPhone
			,IntakePhone
			,BillingPhone
			,BillingContact
			,ProviderId
			,NationalProviderId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
		FROM Agency
	END
	ELSE
	BEGIN
		SELECT @ProviderNameForEligibilityVerification = dbo.ssf_GetSystemConfigurationKeyValue('PROVIDERNAMEFORELIGIBILITYVERIFICATION')

		SELECT @ProviderNameForEligibilityVerification AS AgencyName
			,Address
			,City
			,STATE
			,ZipCode
			,AddressDisplay
			,PaymentAddress
			,PaymentCity
			,PaymentState
			,PaymentZip
			,PaymentAddressDisplay
			,TaxId
			,CountyFIPS
			,MainPhone
			,IntakePhone
			,BillingPhone
			,BillingContact
			,ProviderId
			,NationalProviderId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
		FROM Agency
	END
END
GO

