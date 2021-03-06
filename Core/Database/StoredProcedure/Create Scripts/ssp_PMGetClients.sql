IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'[ssp_PMGetClients]')
			AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1
		)
	DROP PROCEDURE [dbo].[ssp_PMGetClients]
GO

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PMGetClients] @ClientId INT
AS
BEGIN
	BEGIN TRY
		/****************************************************************************** 
** File: ssp_PMGetClients.sql
** Name: ssp_PMGetClients
** Desc: This SP returns the client name
** 
** This template can be customized: 
** 
** Return values: 
** 
** Called by: 
** 
** Parameters: 
** Input Output 
** ---------- ----------- 
** 
** Auth: Veena S Mani
** Date: 05/10/2011
******************************************************************************* 
** Change History 
******************************************************************************* 
** Date: 			Author: 			Description: 
** 19 Oct 2015		Revathi				what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.    
										why:task #609, Network180 Customization
-------- 			-------- 			--------------- 

*******************************************************************************/
		SELECT ClientId
			,LastName
			,FirstName
			,
			--Added by Revathi  19 Oct 2015
			CASE 
				WHEN ISNULL(ClientType, 'I') = 'I'
					THEN ISNULL(LastName, '') + ', ' + ISNULL(FirstName, '')
				ELSE ISNULL(OrganizationName, '')
				END AS 'Name'
		FROM clients
		WHERE isnull(recorddeleted, 'N') = 'N'
			AND ClientId = @ClientId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
		 + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' 
		 + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMGetClients')
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

	RETURN
END