IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'[ssp_PMGetClientInfo]')
			AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1
		)
	DROP PROCEDURE [ssp_PMGetClientInfo]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMGetClientInfo]    Script Date: 10/04/2011 15:31:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PMGetClientInfo] @ClientId INT
AS
/****************************************************************************** 
** File: ssp_CMGetClientInfo.sql
** Name: ssp_CMGetClientInfo
** Desc:  
** 
** 
** This template can be customized: 
** 
** Return values: TO retrieve Client Information
** 
** Called by: 
** 
** Parameters: 
** Input			Output 
** ----------		----------- 
** CoveragePlanId   Dropdown values for Rules Tab
** Auth: Mary Suma
** Date: 10/04/2011
******************************************************************************* 
** Change History 
******************************************************************************* 
** Date: 			Author: 			Description: 
/* 19 Oct 2015		Revathi				what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.    
										why:task #609, Network180 Customization*/

******************************************************************************/
--Enumeration used   
BEGIN
	BEGIN TRY
		SELECT ClientId
			,LastName
			,FirstName
			--Added by Revathi  19 Oct 2015
			,CASE 
				WHEN ISNULL(ClientType, 'I') = 'I'
					THEN ISNULL(LastName, '') + ', ' + ISNULL(FirstName, '')
				ELSE ISNULL(OrganizationName, '')
				END AS 'Name'
		FROM clients
		WHERE ISNULL(recorddeleted, 'N') = 'N'
			AND active = 'Y'
			AND ClientId = @ClientId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
		 + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' 
		 + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMGetClientInfo') 
		 + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
		  + CONVERT(VARCHAR, ERROR_SEVERITY())
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
GO

