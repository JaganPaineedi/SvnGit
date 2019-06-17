IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClinicalSummaryDataOfService]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLClinicalSummaryDataOfService]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLClinicalSummaryDataOfService]
 (
  @ServiceId INT = NULL
	,@ClientId INT
	,@DocumentVersionId INT = NULL
	,@FilterString varchar(max)= NULL)
AS
-- =============================================  
/*
Date				Author				Purpose
28-May-2015			Revathi				what:Get  prevention Plan Summary
										why:task #18  New Directions - Customizations
*/
-- =============================================  
BEGIN
	BEGIN TRY
	 DECLARE @DOS varchar(10)
	 IF @ServiceId IS NOT NULL
	  SELECT @DOS=CONVERT(varchar,DateOfService,101) FROM Services WHERE ServiceId=@ServiceId
	  --ELSE IF @DocumentVersionId IS NOT NULL
	  -- SELECT @DOS=CONVERT(varchar,EffectiveDate,101) FROM Documents WHERE InProgressDocumentVersionId=@DocumentVersionId
	   
	   SELECT @DOS As DataOfService
	  
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(max)

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
		+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' 
		+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLClinicalSummaryDataOfService') 
		+ '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
		+ '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
		+ '*****' + CONVERT(VARCHAR, ERROR_STATE())

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
GO
