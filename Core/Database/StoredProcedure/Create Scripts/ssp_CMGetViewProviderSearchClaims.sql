/****** Object:  StoredProcedure [dbo].[ssp_CMGetViewProviderSearchClaims]    Script Date: 12/12/2014 14:52:08 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetViewProviderSearchClaims]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_CMGetViewProviderSearchClaims]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CMGetViewProviderSearchClaims]    Script Date: 12/12/2014 14:52:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_CMGetViewProviderSearchClaims] @ClientId INT = NULL
	,@StaffId INT = NULL
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_CMGetViewProviderSearchClaimsClaims     */
/* Copyright: 2005 Provider Claim Management System      */
/* Creation Date:  09/10/2006           */
/*                                                                   */
/* Purpose: Gets the Data from ViewProviderSearchClaims Table              */
/*                                                                   */
/* Input Parameters:None            */
/*                                                                   */
/* Output Parameters:             */
/*                                                                   */
/* Return: Returns Data from ViewProviderSearchClaims Table     */
/*                                                                   */
/* Called By: GetAllStaffProvider() Method in Provider Class Of DataService      */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/* Date        Author       Purpose                                  */
/* 02/07/2014  Shruthi.S    To retrieve                                         */
/* 09/10/2014  Shruthi.S    Changed datatype of TaxID to char.Since the tax id accepts character(Sites.TaxID datatype is char).Ref #26.02 Care Management to SmartCare Env. Issues Tracking.*/
/* 29/OCT/2014  SuryaBalan  Ref #78 Care Management to SmartCare Env. Issues Tracking.*/
/* 12/Dec/2014 Arjun K R   If AllInsurer is Y in the staff table then we select insurer from insurers table instead of staffinsurers. This changes are Made in the select statement*/
/* 17/Jan/2015 Kiran       Improving the Speed*/
/* 08/Feb/2015 dknewtson   Wrapped record delete checks with ISNULL to handle null cases.*/
/* 21/Mar/2018 Prem        What:Introducing new System Configuration Key ('SetDaysToDisplayProvidersAfterContractEndDate') and based on key value we are checking the contract end date.
                           Why:Users should be able to see all Active providers without regard to contract end-dates as part of SWMBH - Support 1393 */
/*********************************************************************/
BEGIN
    
	CREATE TABLE #Providers (
		RadioButton CHAR(1)
		,ViewProviderId INT
		,ProviderName VARCHAR(500)
		,SiteName VARCHAR(500)
		,TaxID CHAR(9)
		,TaxIDType VARCHAR(50)
		,ProviderId INT
		,PlaceOfService INT
		,[Address] VARCHAR(500)
		,SiteId INT
		)

	DECLARE @NumberofDays INT --- Added By prem 22-03-2015

	SET @NumberofDays = dbo.ssf_GetSystemConfigurationKeyValue('SetDaysToDisplayProvidersAfterContractEndDate')

	DECLARE @AllProviders VARCHAR(1)

	SET @AllProviders = (
			SELECT TOP 1 ISNULL(AllProviders, 'N')
			FROM staff
			WHERE StaffId = @StaffId
			)

	DECLARE @AllInsurers VARCHAR(1)

	SET @AllInsurers = (
			SELECT TOP 1 ISNULL(ALLInsurers, 'N')
			FROM staff
			WHERE StaffId = @StaffId
			)

	IF ISNULL(@StaffId, 0) > 0
	BEGIN
		INSERT INTO #Providers
		SELECT VPS.RadioButton
			,VPS.ID
			,VPS.ProviderName
			,VPS.SiteName
			,VPS.TaxID
			,VPS.TaxIDType
			,VPS.ProviderId
			,VPS.PlaceOfService
			,VPS.[Address]
			,VPS.SiteId
		FROM ViewProviderSearchClaims VPS
		WHERE (
				EXISTS (
					SELECT 1
					FROM dbo.StaffInsurers ui
					JOIN dbo.ProviderInsurers pia ON pia.InsurerId = ui.InsurerId
					JOIN dbo.Contracts c ON c.InsurerId = ui.InsurerId
						AND c.ProviderId = pia.ProviderId
					WHERE ui.StaffId = @StaffId
						AND c.StartDate <= GETDATE()
						AND (
							c.EndDate IS NULL
							OR c.EndDate >= DATEADD(dd, -(@NumberofDays), GETDATE())
							) --- Added By prem 23-03-2015 
						AND ISNULL(ui.RecordDeleted, 'N') = 'N'
						AND ISNULL(pia.RecordDeleted, 'N') = 'N'
						AND ISNULL(c.RecordDeleted, 'N') = 'N'
						AND pia.ProviderId = VPS.ProviderId
						AND @AllInsurers = 'N'
					)
				OR EXISTS (
					SELECT 1
					FROM dbo.Insurers ui
					JOIN dbo.ProviderInsurers pia ON pia.InsurerId = ui.InsurerId
					JOIN dbo.Contracts c ON c.InsurerId = ui.InsurerId
						AND c.ProviderId = pia.ProviderId
						AND c.StartDate <= GETDATE()
						AND (
							c.EndDate IS NULL
							OR c.EndDate >= DATEADD(dd, -(@NumberofDays), GETDATE())
							) --- Added By prem 23-03-2015
						AND ISNULL(ui.RecordDeleted, 'N') = 'N'
						AND ISNULL(pia.RecordDeleted, 'N') = 'N'
						AND ISNULL(c.RecordDeleted, 'N') = 'N'
						AND pia.ProviderId = VPS.ProviderId
						AND @AllInsurers = 'Y'
					)
				)
			AND (
				EXISTS (
					SELECT ProviderId
					FROM staffproviders
					WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
						AND staffid = @StaffId
						AND VPS.ProviderId = ProviderId
						AND @AllProviders = 'N'
					)
				OR EXISTS (
					SELECT ProviderId
					FROM Providers
					WHERE isnull(RecordDeleted, 'N') <> 'Y'
						AND VPS.ProviderId = ProviderId
						AND @AllProviders = 'Y'
					)
				)
			--ORDER BY 3, 4        
	END
	ELSE
	BEGIN
		IF ISNULL(@ClientId, 0) > 0
		BEGIN
			INSERT INTO #Providers
			SELECT VPS.RadioButton
				,VPS.ID
				,VPS.ProviderName
				,VPS.SiteName
				,VPS.TaxID
				,VPS.TaxIDType
				,VPS.ProviderId
				,VPS.PlaceOfService
				,VPS.[Address]
				,VPS.SiteId
			FROM ViewProviderSearchClaims VPS
			WHERE EXISTS (
					SELECT 1
					FROM ProviderClients PC
					WHERE PC.ClientId = @ClientId
						AND PC.ProviderId = VPS.ProviderId
						AND (
							EXISTS (
								SELECT ProviderId
								FROM staffproviders
								WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
									AND staffid = @StaffId
									AND PC.ProviderId = ProviderId
									AND @AllProviders = 'N'
								)
							OR EXISTS (
								SELECT ProviderId
								FROM Providers
								WHERE isnull(RecordDeleted, 'N') <> 'Y'
									AND PC.ProviderId = ProviderId
									AND @AllProviders = 'Y'
								)
							)
						AND ISNULL(PC.RecordDeleted, 'N') = 'N'
					)
				--ORDER BY 3, 4        
		END
		ELSE
		BEGIN
			INSERT INTO #Providers
			SELECT RadioButton
				,ID
				,ProviderName
				,SiteName
				,TaxID
				,TaxIDType
				,ProviderId
				,PlaceOfService
				,[Address]
				,SiteId
			FROM ViewProviderSearchClaims
				--ORDER BY 3, 4        
		END
	END

	SELECT *
	FROM #Providers p
	ORDER BY ProviderName
		,SiteName

	--Checking For Errors        
	IF (@@error != 0)
	BEGIN
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_CMGetViewProviderSearchClaims') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,16
				,- 1
				);
	END
END
