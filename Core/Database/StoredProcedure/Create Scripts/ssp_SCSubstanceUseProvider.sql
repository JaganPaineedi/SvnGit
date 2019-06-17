/****** Object:  StoredProcedure [dbo].[ssp_SCProviderRates]    Script Date: 04/21/2014 12:55:25 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCSubstanceUseProvider]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCSubstanceUseProvider]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCSubstanceUseProvider]    Script Date: 04/21/2014 12:55:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCSubstanceUseProvider] (@LoggedInStaffId INT)
AS
/********************************************************************/
/* Stored Procedure: dbo.ssp_SCSubstanceUseProvider							*/
/* Creation Date:  24 11 2014                                    */
/*  Author: Venkatesh MR											*/
/* Purpose: Used in client search to fill provider dropdowns which have the  SubstanceUseProvider*/
/*                                                                  */
/*                                                                  */
/*	Updates:                                                        */
/*  Date          Author       Purpose                              */
-- 04-27-2016   Shankha   Added UNION ALL to support All Providers based on staffid (AspenPointe-Environment Issues #6)
/********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @PrimaryProviderId INT

		SET @PrimaryProviderId = (
				SELECT PrimaryProviderId
				FROM Staff
				WHERE StaffId = @LoggedInStaffId
				)

		SELECT Providers.ProviderId
			,Providers.ProviderName
			,CASE 
				WHEN Providers.ProviderType = 'F'
					THEN Providers.ProviderName
				ELSE Providers.ProviderName + ', ' + Providers.FirstName
				END AS ProviderNameFirtName
		FROM staffProviders
		INNER JOIN Providers ON Providers.ProviderId = staffProviders.ProviderId
		WHERE staffProviders.StaffId = @LoggedInStaffId
			AND isnull(staffProviders.RecordDeleted, 'N') = 'N'
			AND Providers.Active = 'Y'
			AND isnull(Providers.RecordDeleted, 'N') = 'N'
			AND Providers.SubstanceUseProvider = 'Y'
		
		UNION ALL
		
		SELECT Providers.ProviderId
			,Providers.ProviderName
			,CASE 
				WHEN Providers.ProviderType = 'F'
					THEN Providers.ProviderName
				ELSE Providers.ProviderName + ', ' + Providers.FirstName
				END AS ProviderNameFirtName
		FROM Providers
		WHERE Providers.Active = 'Y'
			AND isnull(Providers.RecordDeleted, 'N') = 'N'
			AND Providers.SubstanceUseProvider = 'Y'
			AND EXISTS (
				SELECT 1
				FROM Staff st
				WHERE st.StaffId = @LoggedInStaffId
					AND Isnull(st.AllProviders, 'N') = 'Y'
				)
		ORDER BY Providers.ProviderName

		IF EXISTS (
				SELECT Providers.ProviderId
					,Providers.ProviderName
					,CASE 
						WHEN Providers.ProviderType = 'F'
							THEN Providers.ProviderName
						ELSE Providers.ProviderName + ', ' + Providers.FirstName
						END AS ProviderNameFirtName
				FROM staffProviders
				INNER JOIN Providers ON Providers.ProviderId = staffProviders.ProviderId
				WHERE staffProviders.StaffId = @LoggedInStaffId
					AND isnull(staffProviders.RecordDeleted, 'N') = 'N'
					AND Providers.Active = 'Y'
					AND isnull(Providers.RecordDeleted, 'N') = 'N'
					AND Providers.SubstanceUseProvider = 'Y'
					AND Providers.ProviderId = @PrimaryProviderId
				)
		BEGIN
			SELECT @PrimaryProviderId AS PrimaryProviderId
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCSubstanceUseProvider') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


