/****** Object:  StoredProcedure [dbo].[ssp_SCUpdateBlockBedDetails]    Script Date: 07/24/2015 12:27:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCUpdateBlockBedDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCUpdateBlockBedDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCUpdateBlockBedDetails]    Script Date: 07/24/2015 12:27:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCUpdateBlockBedDetails] @BedId INT,@UserCode VARCHAR(30)
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_SCUpdateBlockBedDetails                 */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    19/SEP/2016                                     */
/*                                                                   */
/* Purpose:  Used to update Block Beds Detail Page                   */
/*                                                                   */
/* Input Parameters: @BedId                                          */
/*                                                                   */
/* Output Parameters:   None                                         */
/*                                                                   */
/*********************************************************************/
BEGIN
	BEGIN TRY	
		UPDATE BlockBeds
		SET RecordDeleted = 'Y'
			,DeletedBy = @UserCode
			,DeletedDate = GETDATE()
		WHERE BedId = @BedId
			AND ISNULL(RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCUpdateBlockBedDetails]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


