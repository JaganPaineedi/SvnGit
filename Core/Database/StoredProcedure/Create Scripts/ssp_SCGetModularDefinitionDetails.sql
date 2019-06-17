IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetModularDefinitionDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetModularDefinitionDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/********************************************************************************                                                  
-- Stored Procedure: dbo.ssp_SCGetModularDefinitionDetails                                                 
--                                                  
-- Copyright: Streamline Healthcate Solutions                                                  
--                                                  
-- Purpose: used by 'Manage Roles & Modules' Details.                                                  
--                                                  
-- Updates:                                                                                                         
-- Date			 Author          Purpose                                                  
-- 22.SEP.2017	 Akwinass        Created(Engineering Improvement Initiatives- NBL(I) #561 .       
*********************************************************************************/
CREATE PROCEDURE [dbo].[ssp_SCGetModularDefinitionDetails]
@ManageModuleDefinitionId INT
AS
BEGIN
	BEGIN TRY
		SELECT TOP 1 [ManageModuleDefinitionId]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedBy]
			,[DeletedDate]
			,'' AS JSONxml
			,'' AS FilterJson
		FROM [ManageModuleDefinitions]
		WHERE ISNULL(RecordDeleted, 'N') = 'N' AND ManageModuleDefinitionId >= @ManageModuleDefinitionId
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_SCGetModularDefinitionDetails') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END




GO


