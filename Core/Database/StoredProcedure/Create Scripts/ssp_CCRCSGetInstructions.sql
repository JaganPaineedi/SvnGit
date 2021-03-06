/****** Object:  StoredProcedure [dbo].[ssp_CCRCSGetInstructions]    Script Date: 06/09/2015 03:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRCSGetInstructions]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[ssp_CCRCSGetInstructions]
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
			;

		WITH Instructions_CTE (
			InstructionDate
			,InstructionDesc
			,InstructionAddInfo
			,InstructionDateFormatted
			)
		AS (
			SELECT ''Feb-12-2013''
				,''Patient may continue to experience low grade fever and chills.''
				,''Related to Community acquired pneumonia''
				,''20130212103800''
			)
		SELECT *
		FROM Instructions_CTE
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + ''*****'' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), ''ssp_CCRCSGetInstructions'') + ''*****'' + CONVERT(VARCHAR, ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR, ERROR_SEVERITY()) + ''*****'' + CONVERT(VARCHAR, ERROR_STATE())

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
