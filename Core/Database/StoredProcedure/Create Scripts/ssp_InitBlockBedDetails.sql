/****** Object:  StoredProcedure [dbo].[ssp_InitBlockBedDetails]    Script Date: 07/24/2015 12:06:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitBlockBedDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitBlockBedDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_InitBlockBedDetails]    Script Date: 07/24/2015 12:06:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_InitBlockBedDetails] (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
/*********************************************************************/
/* Stored Procedure: [ssp_InitBlockBedDetails]                       */
/* Creation Date:  19/SEP/2016                                       */
/* Purpose: To Initialize Block Beds                                 */
/* Input Parameters:   @ClientID,@StaffID ,@CustomParameters         */
/*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @BedId INT
		SET @BedId = @CustomParameters.value('(/Root/Parameters/@BedId)[1]', 'INT')
		
		SELECT 'BlockBeds' AS TableName
			,- 1 AS BlockBedId	
			,'' AS CreatedBy
			,getdate() AS CreatedDate
			,'' AS ModifiedBy
			,getdate() AS ModifiedDate
			,@BedId AS BedId		
		FROM systemconfigurations s
		LEFT OUTER JOIN BedAssignmentOverlappingProgramMappings ON s.Databaseversion = - 1
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_InitBlockBedDetails]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


