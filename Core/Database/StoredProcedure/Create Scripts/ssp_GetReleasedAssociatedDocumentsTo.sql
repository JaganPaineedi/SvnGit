/****** Object:  StoredProcedure [dbo].[ssp_GetReleasedAssociatedDocumentsTo]    Script Date: 02/04/2013 10:43:28 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetReleasedAssociatedDocumentsTo]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetReleasedAssociatedDocumentsTo] --314947
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetReleasedAssociatedDocumentsTo]    Script Date: 02/04/2013 10:43:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetReleasedAssociatedDocumentsTo] @ClientId INT
	,@DisclosureNameSearch VARCHAR(50) = NULL
	,@IsDisclosureToSearch VARCHAR(1) = NULL
	/********************************************************************************                                        
-- Stored Procedure: dbo.[ssp_GetReleaseDisclosedTo]                  
--                                        
-- Copyright: Streamline Healthcate Solutions                                        
-- Created By Sunil.D      
   Created Date:21/09/2017                                
-- Purpose: used by  Associated Documents detail page to bind the Associated Documents Dropdown                                        
-- Thresholds-Enhancements  #838                                    
-- Updates:                                                                                               
-- Date        Author      Purpose                                        
 
*********************************************************************************/
AS
BEGIN
	BEGIN TRY 
		IF (@IsDisclosureToSearch = 'Y')
		BEGIN
			EXEC ssp_GetClientDisclosures @ClientId
				,@DisclosureNameSearch
		END 
		ELSE
		BEGIN
			SELECT DISTINCT CAST(CC.ClientContactId AS VARCHAR(12)) + 'C' AS ClientContactId
				,CC.ListAs
				,(CC.FirstName + ', ' + CC.LastName) AS NAME
			FROM ClientContacts AS CC
			WHERE CC.ClientId = @ClientId
				AND ISNULL(CC.RecordDeleted, 'N') = 'N'
				AND Active = 'Y' 
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

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetReleasedAssociatedDocumentsTo') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

