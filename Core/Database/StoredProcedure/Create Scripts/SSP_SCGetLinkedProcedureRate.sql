/****** Object:  StoredProcedure [dbo].[SSP_SCGetLinkedProcedureRate]    Script Date: 10/29/2014 15:03:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetLinkedProcedureRate]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCGetLinkedProcedureRate]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCGetLinkedProcedureRate]    Script Date: 10/29/2014 15:03:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetLinkedProcedureRate] @ProcedureRateId BIGINT
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Nov 18, 2015     
-- Description: Retrieves Linked ProcedureRate based on the ProcedureRateId
/*      
 Author			Modified Date			Reason      
   
      
*/
-- =============================================      
BEGIN
	BEGIN TRY	
		DECLARE @Amount MONEY	
		SELECT @Amount = Amount
		FROM ProcedureRates
		WHERE IsNULL(RecordDeleted, 'N') = 'N'
			AND StandardRateID IS NULL
			AND CoveragePlanId IS NULL
			AND ProcedureRateId = @ProcedureRateId
		
		IF ISNULL(@Amount,'') = ''
			SELECT NULL
		ELSE
			SELECT @Amount
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCGetLinkedProcedureRate') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


