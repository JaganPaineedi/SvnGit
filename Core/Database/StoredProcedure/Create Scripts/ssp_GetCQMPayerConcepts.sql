/****** Object:  StoredProcedure [dbo].[ssp_GetCQMPayerConcepts]    Script Date: 05/10/2017 12:23:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetCQMPayerConcepts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetCQMPayerConcepts]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetCQMPayerConcepts]    Script Date: 05/10/2017 12:23:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetCQMPayerConcepts] 
AS
/*********************************************************************/
/* Stored Procedure: [ssp_GetCQMPayerConcepts]              */
/* Creation Date:  20/Jul/2015                                     */
/* Purpose: To get Payer Concept Code            */
/* Output Parameters:   */
/* Returns The Table for Payer Concept Code*/
/* Called By:                                                       */
/* Data Modifications:                                              */
/*   Updates:                                                       */
/*   Date			Author			Purpose								*/
/*   05/Feb/2018	Chethan N		Created								*/	
/********************************************************************/
BEGIN
	BEGIN TRY
		SELECT PayerCode, PayerCode + ' - ' + PayerDescription AS PayerDescription
		FROM CQMPayerConcepts
		WHERE ISNULL(RecordDeleted, 'N') = 'N'
		AND PayerCode IS NOT NULL
		ORDER By PayerCode
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_GetCQMPayerConcepts') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@Error
				,-- Message text.       
				16
				,-- Severity.       
				1 -- State.       
				);
	END CATCH

	RETURN
END

GO


