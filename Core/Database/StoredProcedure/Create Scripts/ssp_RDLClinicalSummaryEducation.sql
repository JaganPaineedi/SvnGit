/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryEducation]    Script Date: 06/09/2015 04:09:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClinicalSummaryEducation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[ssp_RDLClinicalSummaryEducation]      
	(
	@ServiceId INT = NULL
	,@ClientId INT
	,@DocumentVersionId INT = NULL
	)
AS
BEGIN
/**************************************************************  
Created By   : Veena S Mani 
Created Date : 28-02-2014  
Description  : Used to Get Education list data 
**  02/05/2014   Veena S Mani        Added parameters ClientId and EffectiveDate-Meaningful Use #18            

**************************************************************/
	BEGIN TRY
		DECLARE @DOS DATETIME = NULL

		IF (@ClientId IS NULL	AND @ServiceId <> 0	)
		BEGIN
			SELECT @ClientId = ClientId
				,@DOS = dateofservice
			FROM services
			WHERE serviceid = @ServiceId
		END
				
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + ''*****'' 
		+ Convert(VARCHAR(4000), ERROR_MESSAGE()) + ''*****'' 
		+ isnull(Convert(VARCHAR, ERROR_PROCEDURE()), ''ssp_RDLClinicalSummaryEducation'') + ''*****''
		+ Convert(VARCHAR, ERROR_LINE()) + ''*****''
		 + Convert(VARCHAR, ERROR_SEVERITY()) + ''*****'' 
		 + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                      
				16
				,-- Severity.                                                                                                      
				1 -- State.                                                                                                      
				);
	END CATCH
END' 
END
GO
