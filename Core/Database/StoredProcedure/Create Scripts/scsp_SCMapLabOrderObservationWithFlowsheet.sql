/****** Object:  StoredProcedure [dbo].[scsp_SCMapLabOrderObservationWithFlowsheet]    Script Date: 10/29/2014 15:03:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCMapLabOrderObservationWithFlowsheet]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[scsp_SCMapLabOrderObservationWithFlowsheet]
GO

/****** Object:  StoredProcedure [dbo].[scsp_SCMapLabOrderObservationWithFlowsheet]    Script Date: 10/29/2014 15:03:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[scsp_SCMapLabOrderObservationWithFlowsheet] 
@InboundMessage XML,
@LabSoftMessageId INT
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Sept 22, 2015  
-- Description: Parse the Lab Order Message      
/*      
 Author			Modified Date			Reason      
   
      
*/
-- =============================================      
BEGIN
	BEGIN TRY
		EXEC csp_SCMapLabOrderObservationWithFlowsheet @InboundMessage,@LabSoftMessageId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'scsp_SCMapLabOrderObservationWithFlowsheet') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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
