/****** Object:  StoredProcedure [dbo].[ssp_InitInternalCollections]    Script Date: 07/24/2015 12:06:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitInternalCollections]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitInternalCollections]
GO

/****** Object:  StoredProcedure [dbo].[ssp_InitInternalCollections]    Script Date: 07/24/2015 12:06:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_InitInternalCollections] (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
/*********************************************************************/
/* Stored Procedure: [ssp_InitInternalCollections]               */
/* Creation Date:  24/JULY/2015                                    */
/* Purpose: To Initialize */
/* Input Parameters:   @ClientID,@StaffID ,@CustomParameters*/
/*********************************************************************/
BEGIN
	BEGIN TRY		
		SELECT TOP 1 'Collections' AS TableName
			,- 1 AS InternalCollectionId	
			,'' AS CreatedBy
			,getdate() AS CreatedDate
			,'' AS ModifiedBy
			,getdate() AS ModifiedDate
			,@ClientID AS ClientId			
		FROM systemconfigurations s
		LEFT OUTER JOIN Collections ON s.Databaseversion = - 1
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_InitInternalCollections]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


