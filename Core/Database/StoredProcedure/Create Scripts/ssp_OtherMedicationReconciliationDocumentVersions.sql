/****** Object:  StoredProcedure [dbo].[ssp_OtherMedicationReconciliationDocumentVersions]    Script Date: 05/19/2016 14:53:13 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_OtherMedicationReconciliationDocumentVersions]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_OtherMedicationReconciliationDocumentVersions]
GO

/****** Object:  StoredProcedure [dbo].[ssp_OtherMedicationReconciliationDocumentVersions]    Script Date: 05/19/2016 14:53:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_OtherMedicationReconciliationDocumentVersions] @ClientId INT
AS
/******************************************************************************                
**  File:                 
**  Name: ssp_OtherMedicationReconciliationDocumentVersions                
**  Desc: Retrieves a list of document versions for select client based on   
**   last signed document per documentcodeid  
**           
**                
**  Return values: List of DocumentVersionId, Name                
**                 
**  Called by:                   
**                              
**  Parameters:                
**  Input       Output                
**     ----------       -----------                
**                
**  Auth: Neha                
**  Date: Oct 08, 2018                
*******************************************************************************                
**  Change History                
*******************************************************************************                
**  Date:  Author:    Description:                
**  --------  --------    -------------------------------------------                
*******************************************************************************/
BEGIN
	BEGIN TRY
	
IF object_id('dbo.scsp_OtherMedicationReconciliationDocumentVersions', 'P') IS NOT NULL
		BEGIN
			EXEC scsp_OtherMedicationReconciliationDocumentVersions @ClientId
				
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
	


