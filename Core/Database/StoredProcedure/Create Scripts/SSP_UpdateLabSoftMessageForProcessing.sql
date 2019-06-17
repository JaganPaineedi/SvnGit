/****** Object:  StoredProcedure [dbo].[SSP_UpdateLabSoftMessageForProcessing]    Script Date: 03/02/2016 17:44:51 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_UpdateLabSoftMessageForProcessing]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_UpdateLabSoftMessageForProcessing]
GO

/****** Object:  StoredProcedure [dbo].[SSP_UpdateLabSoftMessageForProcessing]    Script Date: 03/02/2016 17:44:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_UpdateLabSoftMessageForProcessing] @LabSoftMessageId INT
AS
-- ================================================================  
-- Stored Procedure: SSP_UpdateLabSoftMessageForProcessing  
-- Create Date : Mar 02 2016  
-- Purpose : Update the HL7 Message to Ready For External System Processing.
-- Created By : Pradeep.A  
-- EXEC SSP_UpdateLabSoftMessageForProcessing 258  
-- ================================================================  
-- History --  
-- ================================================================  
BEGIN
	BEGIN TRY
		UPDATE LabSoftMessages
		SET MessageProcessingState = 9358--Ready For External System Processing
		   ,MessageStatus = NULL
		WHERE LabSoftMessageId = @LabSoftMessageId
			AND ISNULL(RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_UpdateLabSoftMessageForProcessing') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


