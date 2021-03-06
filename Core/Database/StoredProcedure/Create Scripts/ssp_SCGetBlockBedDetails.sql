/****** Object:  StoredProcedure [dbo].[ssp_SCGetBlockBedDetails]    Script Date: 07/24/2015 12:27:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetBlockBedDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetBlockBedDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetBlockBedDetails]    Script Date: 07/24/2015 12:27:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetBlockBedDetails] @BedId INT
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_SCGetBlockBedDetails                    */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    19/SEP/2016                                     */
/*                                                                   */
/* Purpose:  Used to get Block Beds Detail Page                      */
/*                                                                   */
/* Input Parameters: @BedId                                          */
/*                                                                   */
/* Output Parameters:   None                                         */
/*                                                                   */
/*********************************************************************/
BEGIN
	BEGIN TRY			
		SELECT [BlockBedId]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedBy]
			,[DeletedDate]
			,[BedId]
			,[StartDate]
			,[EndDate]
			,[BlockedReason]
			,[BlockedReasonComment]
			,[StartDate] AS StartTime
			,[EndDate] AS EndTime
		FROM [BlockBeds]
		WHERE BedId = @BedId
			AND ISNULL(RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCGetBlockBedDetails]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


