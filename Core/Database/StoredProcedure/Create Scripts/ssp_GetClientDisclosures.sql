IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientDisclosures]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetClientDisclosures]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetClientDisclosures] @ClientId INT
	,@DisclosureNameSearch VARCHAR(max)
	/********************************************************************************                                        
-- Stored Procedure: dbo.[ssp_GetClientDisclosures]                  
--                                        
-- Copyright: Streamline Healthcate Solutions                                        
--                                        
-- Purpose: used by  Disclosure detail page to bind the DisclosedTo Dropdown                                        
--                                        
-- Updates:                                                                                               
-- Date        Author      Purpose                                        
-- 07.01.2010  Hemant      Created.                                              
                                    
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @DisclosureName VARCHAR(50)

		SET @DisclosureName = '%' + @DisclosureNameSearch + '%'

		SELECT DISTINCT CAST(CC.ClientContactId AS VARCHAR(12)) + 'C' AS ClientContactId
			,CC.ListAs
			,(CC.FirstName + ', ' + CC.LastName) AS NAME
		FROM ClientContacts AS CC
		WHERE CC.ClientId = @ClientId
			AND (
				CC.FirstName LIKE @DisclosureName
				OR CC.LastName LIKE @DisclosureName
				OR CC.ListAs LIKE @DisclosureName
				)
			AND ISNULL(CC.RecordDeleted, 'N') = 'N'
			AND Active = 'Y'
		
		UNION
		
		SELECT CAST(ExternalReferralProviderId AS VARCHAR(12)) + 'E' AS ClientContactId
			,ISNULL(ERP.LastName, '') + CASE 
				WHEN ERP.LastName <> ''
					THEN ', '
				ELSE ''
				END + ISNULL(ERP.FirstName, ERP.NAME) AS 'ListAs'
			,NAME
		FROM ExternalReferralProviders ERP
		WHERE NAME IS NOT NULL
			AND ISNULL(ERP.RecordDeleted, 'N') = 'N'
			AND Active = 'Y'
			AND (
				ERP.LastName LIKE @DisclosureName
				OR ERP.LastName LIKE @DisclosureName
				OR ERP.NAME LIKE @DisclosureName
				)
		ORDER BY ListAs

		SELECT DEOrganizationId
			,OrganizationName
		FROM DEOrganizations
		WHERE Active = 'Y'
			AND IsSenderOrganization <> 'Y'
			AND ISNULL(RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetClientDisclosures') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

