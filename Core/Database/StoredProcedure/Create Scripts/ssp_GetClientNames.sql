/****** Object:  StoredProcedure [dbo].[ssp_GetClientNames]    Script Date: 02/09/2016 12:39:46 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientNames]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetClientNames]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetClientNames]    Script Date: 02/09/2016 12:39:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetClientNames] (
		@ClientName VARCHAR(50)  
	)
	/********************************************************************/
	/* Stored Procedure: dbo.ssp_GetClientNames				*/
	/* Creation Date:  05 Aug,2011                                      */
	/*                                                                  */
	/* Purpose: get Client Names based on client name*/
	/*                                                                  */
	/* Input Parameters: @ClientName        */
	/*                                                                  */
	/* Output Parameters:												*/
	/*                                                                  */
	/*  Date                  Author                 Purpose			*/
	/* 17/03/2016             Venkatesh				 Created	-	As per task Renaissance - Dev Items - #780	*/
	/********************************************************************/
AS
BEGIN
	BEGIN TRY

	 CREATE TABLE #ContactNoteClientsList
	 (
		ClientId INT,
		ClientName VARCHAR(200)
	 )
	 
	 Insert into #ContactNoteClientsList
	 Select ClientId, LastName + ', ' + FirstName + ' (' + CAST(ClientId AS VARCHAR(50)) + ')' as ClientName FROM Clients WHERE Active='Y' AND ISNULL(RecordDeleted, 'N') = 'N'  

	 
	  DECLARE @Name VARCHAR(50)       
	  SET @Name= '%'+ @ClientName + '%'      
	  SELECT Top 5 ClientId, ClientName FROM #ContactNoteClientsList WHERE ClientName like @Name 
  END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetClientNames') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


