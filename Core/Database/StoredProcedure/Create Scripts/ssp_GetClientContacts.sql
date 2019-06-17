/****** Object:  StoredProcedure [dbo].[ssp_GetClientContacts]    Script Date: 05/03/2013 11:54:00 ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientContacts]') AND type IN (N'P',N'PC'))
	DROP PROCEDURE [dbo].[ssp_GetClientContacts]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetClientContacts]    Script Date: 05/03/2013 11:54:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetClientContacts]
	/*************************************************************/
	/* Stored Procedure: dbo.ssp_GetClientContacts	             */
	/* Creation Date:  Nov 04 2014                                 */
	/* Purpose: To Get Client Contacts 				 */
	/*  Date                  Author                 Purpose     */
	/* Nov 04 2014            Varun           Created     */
	/* Oct 16 2015			  Revathi	 	  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.           
												 why:task #609, Network180 Customization  */
												 
	/* Nov 27 2017			  Mrunali	 	  what:Changed code to display only Active Clients.           
												 why:task Woods - Support Go Live# 769  */

	/*************************************************************/
	@ClientId INT
AS
BEGIN
	BEGIN TRY
		SELECT ClientContacts.ClientContactId
 ,ClientContacts.ClientId
 --Added by Revathi Oct 16 2015
 ,(select case when  ISNULL(Clients.ClientType,'I')='I' then ISNULL(Clients.LastName,'') + ', ' + ISNULL(Clients.FirstName,'') else ISNULL(Clients.OrganizationName,'') end from Clients where ClientId=@ClientId) AS Client
 ,ClientContacts.LastName + ', ' + ClientContacts.FirstName AS Contact
 ,ClientContacts.Active
FROM ClientContacts
INNER JOIN GlobalCodes ON GlobalCodes.GlobalCodeId = ClientContacts.Relationship
 AND ISNULL(GlobalCodes.RecordDeleted, 'N') <> 'Y'
 AND GlobalCodes.Category = 'RELATIONSHIP'
WHERE (ISNULL(ClientContacts.RecordDeleted, 'N') <> 'Y')
 AND (ClientContacts.ClientId = @ClientId)
 AND (ClientContacts.Active = 'Y')    

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetClientContacts') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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

