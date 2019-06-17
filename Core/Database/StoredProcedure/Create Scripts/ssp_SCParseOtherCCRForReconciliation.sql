/****** Object:  StoredProcedure [dbo].[ssp_SCParseOtherCCRForReconciliation]    Script Date: 05/19/2016 14:55:17 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCParseOtherCCRForReconciliation]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCParseOtherCCRForReconciliation]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCParseOtherCCRForReconciliation]    Script Date: 05/19/2016 14:55:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[ssp_SCParseOtherCCRForReconciliation] @ExternalReferenceId INT
AS /*********************************************************************/
/* Stored Procedure: dbo.ssp_SCParseOtherCCRForReconciliation   1         */
/* Creation Date:    21/Aug/2017                */
/* Purpose:  To Get Other External Medications from XML data                */
/*    Exec ssp_SCParseOtherCCRForReconciliation                                              */
/* Input Parameters:                           */
/* Date         Author   Purpose              */
/* 08/Oct/2018  Neha     Task #6120.1 Comprehensive Customizations   */
/*********************************************************************/
BEGIN
	BEGIN TRY
		
		IF object_id('dbo.scsp_SCParseOtherCCRForReconciliation', 'P') IS NOT NULL
		BEGIN
			EXEC scsp_SCParseOtherCCRForReconciliation @ExternalReferenceId
				
		END
			
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(max)

		SET @Error = convert(VARCHAR, error_number()) + '*****' + convert(VARCHAR(4000), error_message()) + '*****' + isnull(convert(VARCHAR, error_procedure()), 'ssp_SCParseOtherCCRForReconciliation') + '*****' + convert(VARCHAR, error_line()) + '*****' + convert(VARCHAR, error_severity()) + '*****' + convert(VARCHAR, error_state())

		RAISERROR (
				@Error
				,
				-- Message text.                                                                                               
				16
				,
				-- Severity.                                                                                               
				1
				-- State.                                                                                             
				);
	END CATCH
END
