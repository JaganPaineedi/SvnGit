IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMUpdateClaimLinesOnActionSelection]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_CMUpdateClaimLinesOnActionSelection]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_CMUpdateClaimLinesOnActionSelection] @ClaimlineId INT
	,@StaffId INT
	,@Usercode VARCHAR(30)
	,@Action VARCHAR(250)
	/*********************************************************************                          
-- Stored Procedure: dbo.ssp_CMUpdateClaimLinesOnActionSelection                
-- Copyright: 2005 ClaimLines               
-- Creation Date:  30/oct/2018                                     
--                                                                 
-- Purpose: Created SP to update ClaimLines based on selection of Action in ClaimLine list ppage.         
--          Task #591 - SWMBH - Enhancements                                                                                        
-- Input Parameters:   
--                                 
-- Updates                                                                   
-- Modified Date    Modified By       Purpose                
****************************************************************************/
AS
BEGIN TRY
	IF (@Action = 'Add to Under Review')
	BEGIN
		IF EXISTS (
				SELECT ClaimLineId
				FROM ClaimLines
				WHERE ClaimLineId = @ClaimlineId
				)
		BEGIN
			UPDATE ClaimLines
			SET ClaimLineUnderReview = 'Y'
				,ModifiedBy = @UserCode
				,ModifiedDate = getdate()
			WHERE ClaimLineId = @ClaimlineId
				AND isnull(RecordDeleted, 'N') <> 'Y'
		END
		  EXEC dbo.ssp_CMManageOpenClaims @ClaimLineId = @ClaimlineId, @UserCode = @UserCode
		
	END

	IF (@Action = 'Remove From Under Review')
	BEGIN
		IF EXISTS (
				SELECT ClaimLineId
				FROM ClaimLines
				WHERE ClaimLineId = @ClaimlineId
				)
		BEGIN
			UPDATE ClaimLines
			SET ClaimLineUnderReview = 'N'
				,ModifiedBy = @UserCode
				,ModifiedDate = getdate()
			WHERE ClaimLineId = @ClaimlineId
				AND isnull(RecordDeleted, 'N') <> 'Y'
		END
		
         EXEC dbo.ssp_CMManageOpenClaims @ClaimLineId = @ClaimlineId, @UserCode = @UserCode

	END

	IF (@Action = 'Mark as Final Status')
	BEGIN
		IF EXISTS (
				SELECT ClaimLineId
				FROM ClaimLines
				WHERE ClaimLineId = @ClaimlineId
				)
		BEGIN
			UPDATE ClaimLines
			SET FinalStatus = 'Y'
				,ModifiedBy = @UserCode
				,ModifiedDate = getdate()
			WHERE ClaimLineId = @ClaimlineId
				AND isnull(RecordDeleted, 'N') <> 'Y'
		END
	END

	IF (@Action = 'Revert Final Status')
	BEGIN
		IF EXISTS (
				SELECT ClaimLineId
				FROM ClaimLines
				WHERE ClaimLineId = @ClaimlineId
				)
		BEGIN
			UPDATE ClaimLines
			SET FinalStatus = 'N'
				,ModifiedBy = @UserCode
				,ModifiedDate = getdate()
			WHERE ClaimLineId = @ClaimlineId
				AND isnull(RecordDeleted, 'N') <> 'Y'
		END
	END
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), '[ssp_CMUpdateClaimLinesOnActionSelection]') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                                  
			16
			,-- Severity.                                  
			1 -- State.                                  
			);
END CATCH
GO


