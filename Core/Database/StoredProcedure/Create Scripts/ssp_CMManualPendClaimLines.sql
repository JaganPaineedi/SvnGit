IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMManualPendClaimLines]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_CMManualPendClaimLines]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_CMManualPendClaimLines] @ClaimlineId INT
	,@StaffId INT
	,@Usercode VARCHAR(30)
	/*********************************************************************                          
-- Stored Procedure: dbo.ssp_CMManualPendClaimLines                
-- Copyright: 2005 ClaimLines  
-- Created BY: K.Soujanya             
-- Creation Date:  06/Nov/2018                                     
--                                                                 
-- Purpose: Created SP.Update ClaimLines (OverridePendedReason='Y') when user overring the ClaimLines.         
--          Task #591 -  SWMBH - Enhancements                                                                                                    
****************************************************************************/
AS
BEGIN TRY
	BEGIN
		IF EXISTS (
				SELECT ClaimLineId
				FROM ClaimLines
				WHERE ClaimLineId = @ClaimlineId
				)
		BEGIN
			UPDATE ClaimLines
			SET STATUS = 2027 -- Pended
				,ModifiedBy = @UserCode
				,ModifiedDate = getdate()
			WHERE ClaimLineId = @ClaimlineId
		END

		IF EXISTS (
				SELECT ClaimLineId
				FROM ClaimLineHistory
				WHERE ClaimLineId = @ClaimlineId
				)
		BEGIN
			INSERT INTO ClaimLineHistory (
				ClaimLineId
				,Activity
				,ActivityDate
				,STATUS
				,ActivityStaffId
				,AdjudicationId
				,Reason
				,CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				)
			SELECT TOP 1 clh.ClaimLineId
				,2015 -- Manual Pend
				,getdate()
				,2027 --Pended
				,@StaffId
				,clh.AdjudicationId
				,clh.Reason
				,@UserCode
				,getdate()
				,@UserCode
				,getdate()
			FROM ClaimLineHistory clh
			WHERE ClaimLineId = @ClaimlineId
			ORDER BY ClaimLineHistoryId DESC
		END
	END
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), '[ssp_CMManualPendClaimLines]') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                                  
			16
			,-- Severity.                                  
			1 -- State.                                  
			);
END CATCH
GO


