/****** Object:  StoredProcedure [dbo].[ssp_GetServiceAssociatedClaimLineId]   ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetServiceAssociatedClaimLineId]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetServiceAssociatedClaimLineId]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetServiceAssociatedClaimLineId]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetServiceAssociatedClaimLineId] @ClaimLineID Int = NULL,@ServiceId Int = NULL
	/*********************************************************************/
	/* Stored Procedure: dbo.ssp_GetServiceAssociatedClaimLineId			*/
	/* Copyright: 2005 Provider Claim Management System					*/
	/*                                                                  */
	/********************************************************************/
	/*	Date			Author			Purpose							*/
	/*  02 JAN 2017     Basudev     Created to get task  #364 CEI SGL*/
	/********************************************************************/
AS
BEGIN
	BEGIN TRY
	IF @ClaimLineID > 0
		SELECT ServiceId FROM ClaimLineServiceMappings where ClaimLineId=@ClaimLineID AND ISNULL(RecordDeleted,'N')='N'
	IF @ServiceId > 0
	SELECT ClaimLineId FROM ClaimLineServiceMappings where ServiceId=@ServiceId AND ISNULL(RecordDeleted,'N')='N'
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetServiceAssociatedClaimLineId') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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

