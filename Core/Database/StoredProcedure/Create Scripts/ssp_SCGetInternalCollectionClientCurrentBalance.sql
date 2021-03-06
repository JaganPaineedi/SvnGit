/****** Object:  StoredProcedure [dbo].[ssp_SCGetInternalCollectionClientCurrentBalance]    Script Date: 07/24/2015 12:27:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetInternalCollectionClientCurrentBalance]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetInternalCollectionClientCurrentBalance]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetInternalCollectionClientCurrentBalance]    Script Date: 07/24/2015 12:27:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetInternalCollectionClientCurrentBalance] @ClientId INT,@Code VARCHAR(100)
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_SCGetInternalCollectionClientCurrentBalance   137           */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    12/AUG/2015                                         */
/*                                                                   */
/* Purpose:  Used to Get Client Informations  */
/*                                                                   */
/* Input Parameters: @ClientId, @Code   */
/*                                                                   */
/* Output Parameters:   None                */
/*                                                                   */
/*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @CollectionStatus INT
		DECLARE @CollectionStatusText VARCHAR(250)

		SELECT TOP 1 @CollectionStatus = GlobalCodeId
			,@CollectionStatusText = CodeName
		FROM GlobalCodes
		WHERE ISNULL(Category, '') = 'COLLECTIONSTATUS'
			AND ISNULL(Code, '') = @Code
			AND ISNULL(RecordDeleted, 'N') = 'N'
			AND ISNULL(Active, 'N') = 'Y'

		SELECT TOP 1 CurrentBalance
			,@CollectionStatus AS CollectionStatus
			,@CollectionStatusText AS CollectionStatusText
		FROM Clients C
		WHERE C.ClientId = @ClientId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'	
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCGetInternalCollectionClientCurrentBalance]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


