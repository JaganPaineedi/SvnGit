/****** Object:  StoredProcedure [dbo].[ssp_SCGetCurrentClientNames]    Script Date: 06/27/2017 10:21:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetCurrentClientNames]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetCurrentClientNames]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetCurrentClientNames]    Script Date: 06/27/2017 10:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create PROCEDURE [dbo].[ssp_SCGetCurrentClientNames] @Name VARCHAR(50) = ''
	,@Mode VARCHAR(10) = 'SEARCH'
	,@ClientId INT = NULL
	,@StaffId INT = NULL
AS
/*********************************************************************/
/* Stored Procedure: ssp_SCGetCurrentClientNames                     */
/* Creation Date:  27/JUNE/2017                                      */
/* Purpose: To Get Clients                                           */
/* Input Parameters: @Mode,@ClientId,@StaffId                        */
/* Output Parameters:                                                */
/* Return:                                                           */
/* Called By: "Search OR Open this client" drop down                 */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/* Updates:                                                          */
/* Date              Author                  Purpose                 */
/* 27/JUNE/2017      Akwinass                Created(Engineering Improvement Initiatives- NBL(I) #536 ).*/
/* 09 January 2018   Manjunath K             Added ClientType check while returning ClientName For Core Bugs #2511*/
/* 17/MAY/2018       Akwinass                Added logic to work for organization clients(Core Bugs #2611).*/
/* 22/MAY/2018       Akwinass                ClientType check included for LastName, FirstName search(Core Bugs #2611).*/
/*********************************************************************/
BEGIN
	BEGIN TRY
		IF @Mode = 'GET'
		BEGIN
			DECLARE @LastName VARCHAR(150)
			DECLARE @FirstName VARCHAR(150)			
			SELECT TOP 1 @LastName = item FROM dbo.fnSplitWithIndex(@Name,',') WHERE [index] = 0
			SELECT TOP 1 @FirstName = item FROM dbo.fnSplitWithIndex(@Name,',') WHERE [index] = 1
			
			IF ISNULL(@LastName,'') <> '' AND ISNULL(@FirstName,'') <> ''
			BEGIN
				SELECT Clients.ClientId
					,Clients.LastName + ', ' + Clients.FirstName + ' (' + CAST(Clients.ClientId AS VARCHAR(50)) + ')' AS ClientName
					,Clients.LastName
					,Clients.FirstName
				FROM Clients			
				WHERE ISNULL(Clients.RecordDeleted, 'N') = 'N'
					AND Clients.Active = 'Y'
					AND Clients.LastName LIKE @LastName + '%'
					AND Clients.FirstName LIKE @FirstName + '%'
					AND ISNULL(Clients.ClientType, 'I') = 'I' -- 22/MAY/2018 Akwinass
					AND EXISTS(SELECT 1 FROM StaffClients SC WHERE SC.ClientId = Clients.ClientId AND SC.StaffId = @StaffId)
				ORDER BY ClientName ASC
			END
			ELSE IF ISNULL(@LastName,'') <> '' AND ISNULL(@FirstName,'') = ''
			BEGIN			
				SELECT Clients.ClientId
					,CASE WHEN ISNULL(Clients.ClientType, 'I') = 'O' THEN Clients.OrganizationName + ' (' + CAST(Clients.ClientId AS VARCHAR(50)) + ')' ELSE  Clients.LastName + ', ' + Clients.FirstName + ' (' + CAST(Clients.ClientId AS VARCHAR(50)) + ')' END AS ClientName -- 17/MAY/2018 Akwinass
					,ISNULL(Clients.LastName,'') AS LastName -- 17/MAY/2018 Akwinass
					,ISNULL(Clients.FirstName,'') AS FirstName -- 17/MAY/2018 Akwinass
				FROM Clients			
				WHERE ISNULL(Clients.RecordDeleted, 'N') = 'N'
					AND Clients.Active = 'Y'
					AND (Clients.LastName LIKE @LastName + '%' OR Clients.OrganizationName LIKE @LastName + '%') -- 17/MAY/2018 Akwinass
					AND EXISTS(SELECT 1 FROM StaffClients SC WHERE SC.ClientId = Clients.ClientId AND SC.StaffId = @StaffId)
				ORDER BY ClientName ASC
			END
			ELSE IF ISNULL(@LastName,'') = '' AND ISNULL(@FirstName,'') <> ''
			BEGIN			
				SELECT Clients.ClientId
					,CASE WHEN Clients.ClientType = 'O' THEN Clients.OrganizationName + ' (' + CAST(Clients.ClientId AS VARCHAR(50)) + ')' ELSE  Clients.LastName + ', ' + Clients.FirstName + ' (' + CAST(Clients.ClientId AS VARCHAR(50)) + ')' END AS ClientName -- 17/MAY/2018 Akwinass
					,ISNULL(Clients.LastName,'') AS LastName -- 17/MAY/2018 Akwinass
					,ISNULL(Clients.FirstName,'') AS FirstName -- 17/MAY/2018 Akwinass
				FROM Clients			
				WHERE ISNULL(Clients.RecordDeleted, 'N') = 'N'
					AND Clients.Active = 'Y'
					AND (Clients.FirstName LIKE @FirstName + '%' OR Clients.OrganizationName LIKE @FirstName + '%') -- 17/MAY/2018 Akwinass
					AND EXISTS(SELECT 1 FROM StaffClients SC WHERE SC.ClientId = Clients.ClientId AND SC.StaffId = @StaffId)
				ORDER BY ClientName ASC
			END
		END
		ELSE IF @Mode = 'SEARCH'
		BEGIN
			SELECT Clients.ClientId
			,CASE   
				WHEN ISNULL(Clients.ClientType, 'I') = 'I'   --09 January 2018   Manjunath K
				THEN Clients.LastName + ', ' + Clients.FirstName + ' (' + CAST(Clients.ClientId AS VARCHAR(50)) + ')' 
				ELSE ISNULL(Clients.OrganizationName, '') + ' (' + CAST(Clients.ClientId AS VARCHAR(50)) + ')' 
			 END AS ClientName  
				,Clients.LastName
				,Clients.FirstName
			FROM Clients			
			WHERE Clients.ClientId = @ClientId
				AND ISNULL(Clients.RecordDeleted, 'N') = 'N'
				AND Clients.Active = 'Y'
				AND EXISTS(SELECT 1 FROM StaffClients SC WHERE SC.ClientId = Clients.ClientId AND SC.StaffId = @StaffId)
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetCurrentClientNames') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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