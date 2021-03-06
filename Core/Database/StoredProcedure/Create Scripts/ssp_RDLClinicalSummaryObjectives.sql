/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryObjectives]    Script Date: 06/09/2015 04:09:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClinicalSummaryObjectives]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[ssp_RDLClinicalSummaryObjectives] (
	@ServiceId INT = NULL
	,@ClientId INT
	,@DocumentVersionId INT = NULL
	,@NeedId INT
	)
AS
/******************************************************************************
                    
  **  Date:			Author:				Description:                    
  **  --------		--------			-------------------------------------------   
  **  03/09/2014   Revathi              what:Get ClinicalSummaryObjectives 
                                        why:task #36 MeaningfulUse        
  *******************************************************************************/
BEGIN
	BEGIN TRY
		IF EXISTS (
				SELECT 1
				FROM sys.objects
				WHERE object_id = OBJECT_ID(N''[dbo].[scsp_RDLClinicalSummaryObjectives]'')
					AND type IN (N''P'',N''PC'')
				)
		BEGIN
			EXEC csp_RDLClinicalSummaryObjectives @ServiceId
				,@ClientId
				,@DocumentVersionId
				,@NeedId
		END
		ELSE
		BEGIN
			SELECT 0 AS ObjectiveId
				,0 AS GoalId
				,0 AS ObjectiveNumber
				,''No Objectives'' AS ObjectiveText
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + ''*****'' 
		+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + ''*****'' 
		+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), ''ssp_RDLClinicalSummaryObjectives'') + ''*****'' 
		+ CONVERT(VARCHAR, ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR, ERROR_SEVERITY()) + ''*****'' 
		+ CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                            
				16
				,-- Severity.                                                                                                            
				1 -- State.                                                                                                            
				);
	END CATCH
END
' 
END
GO
