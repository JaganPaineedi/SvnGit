/****** Object:  StoredProcedure [dbo].[ssp_GetReleasedDisclosedTo]    Script Date: 02/04/2013 10:43:28 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetReleasedDisclosedTo]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetReleasedDisclosedTo] --314947
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetReleasedDisclosedTo]    Script Date: 02/04/2013 10:43:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetReleasedDisclosedTo] @ClientId INT
	,@DisclosureNameSearch VARCHAR(50) = NULL
	,@IsDisclosureToSearch VARCHAR(1) = NULL
	/********************************************************************************                                        
-- Stored Procedure: dbo.[ssp_GetReleaseDisclosedTo]                  
--                                        
-- Copyright: Streamline Healthcate Solutions                                        
--                                        
-- Purpose: used by  Disclosure detail page to bind the DisclosedTo Dropdown                                        
--                                        
-- Updates:                                                                                               
-- Date        Author      Purpose                                        
-- 07.01.2010  Sahil Bhagat     Created.                                              
-- 10.01.2013  Samrat		Added code for getting Organization Informations  
-- 7/27/2015   Hemant       Added select query for ExternalReferralProviders 
                            what:- once a contact is selected it should pre-populate the contact's mailing address into the disclosure screen
                            - once a contact is selected it should pre-populate the contact's fax number and name into the fax screen
                            why:Faxing from SC ;Network 180 - Customizations #613 
-- Oct/12/2015  Hemant      Added new stored procedure "ssp_GetClientDisclosures" to implement the autosearch functionality for Disclosed to dropdown.                                    
-- Oct/30/2015  Hemant      commented select Query for ExternalReferralProviders table.
							Why:Request from Dropdown should display only client contacts.However ExternalReferralProviders table is handled in "ssp_GetClientDisclosures". 
							Project:Newaygo - Support #381
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		-- BEGIN Oct/12/2015  Hemant 
		IF (@IsDisclosureToSearch = 'Y')
		BEGIN
			EXEC ssp_GetClientDisclosures @ClientId
				,@DisclosureNameSearch
		END
				-- END Oct/12/2015  Hemant  
		ELSE
		BEGIN
			SELECT DISTINCT CAST(CC.ClientContactId AS VARCHAR(12)) + 'C' AS ClientContactId
				,CC.ListAs
				,(CC.FirstName + ', ' + CC.LastName) AS NAME
			FROM ClientContacts AS CC
			WHERE CC.ClientId = @ClientId
				AND ISNULL(CC.RecordDeleted, 'N') = 'N'
				AND Active = 'Y'
			
			--UNION
			
			--SELECT CAST(ExternalReferralProviderId AS VARCHAR(12)) + 'E' AS ClientContactId
			--	,ISNULL(ERP.LastName, '') + CASE 
			--		WHEN ERP.LastName <> ''
			--			THEN ', '
			--		ELSE ''
			--		END + ISNULL(ERP.FirstName, ERP.NAME) AS 'ListAs'
			--	,NAME
			--FROM ExternalReferralProviders ERP
			--WHERE NAME IS NOT NULL
			--	AND ISNULL(ERP.RecordDeleted, 'N') = 'N'
			--	AND Active = 'Y'

			--Added by samrat against the task #114 InteractDevelopmentImplementations    
			SELECT DEOrganizationId
				,OrganizationName
			FROM DEOrganizations
			WHERE Active = 'Y'
				AND IsSenderOrganization <> 'Y'
				AND ISNULL(RecordDeleted, 'N') = 'N'
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetReleasedDisclosedTo') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

