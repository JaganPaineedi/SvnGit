/****** Object:  StoredProcedure [dbo].[ssp_GetHealthMaintenanceTemplates]    Script Date: 06/18/2015 18:24:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetHealthMaintenanceTemplates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetHealthMaintenanceTemplates]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetHealthMaintenanceTemplates]    Script Date: 06/18/2015 18:24:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetHealthMaintenanceTemplates] @HealthMaintenanceTemplateName VARCHAR(100)
AS
BEGIN
	/*******************************************************************************************************/
	/* Stored Procedure: dbo.ssp_GetHealthMaintenanceTemplates                                     */
	/* Creation Date:    07/11/2014                                                                          */
	/* Return Status:                                                                                      */
	/* Calls:                                                                                              */
	/* Data Modifications:                                                                                 */
	/* Updates:                                                                                            */
	/*   Date            Author             Purpose                                                        */
	/*   07/11/2014      PPOTNURU     Created                                                        */
	/********************************/
	BEGIN TRY
		DECLARE @Name VARCHAR(50)

		SET @Name = '%' + @HealthMaintenanceTemplateName + '%'

		SELECT HealthMaintenanceTemplateId
			,TemplateName
		FROM HealthMaintenanceTemplates
		WHERE TemplateName LIKE @Name
			AND Isnull(RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_GetHealthMaintenanceTemplates') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@Error
				,-- Message text.                                 
				16
				,
				-- Severity.                                               
				1 -- State.                                               
				);
	END CATCH
END
GO


