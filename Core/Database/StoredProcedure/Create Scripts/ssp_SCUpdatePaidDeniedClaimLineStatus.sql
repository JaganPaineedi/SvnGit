/****** Object:  StoredProcedure [dbo].[ssp_SCUpdatePaidDeniedClaimLineStatus]    Script Date: 26/11/2018 07:35:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCUpdatePaidDeniedClaimLineStatus]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCUpdatePaidDeniedClaimLineStatus]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCUpdatePaidDeniedClaimLineStatus]    Script Date: 26/11/2018 07:35:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCUpdatePaidDeniedClaimLineStatus]
	/********************************************************************************      
Stored Procedure: dbo.ssp_SCUpdatePaidDeniedClaimLineStatus    
    
Purpose: To Update Paid/Denied Claim Lines status as Final status as a nightly job 
--to update claim lines as a nightly job for Claimlines
    
  Date      Author       Purpose    
11/26/2018  K.Soujanya   what-: Created sp and this can be set up as job.This will automatically check the ‘Final Status’ checkbox on Claim Line Detail screen after the days entered on Insurer screen. Why: SWMBH - Enhancements#591

*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		CREATE TABLE #ClaimLineFinalStatus (ClaimLineId INT)

		INSERT INTO #ClaimLineFinalStatus (ClaimLineId)
		SELECT cl.ClaimLineId
		FROM ClaimLines cl
		JOIN Claims c ON cl.ClaimId = c.ClaimId
		JOIN Insurers AS i ON i.InsurerId = c.InsurerId
		JOIN ClaimLineHistory clh ON cl.ClaimLineId = clh.ClaimLineId
		WHERE isnull(c.RecordDeleted, 'N') = 'N'
			AND isnull(cl.RecordDeleted, 'N') = 'N'
			AND isnull(i.RecordDeleted, 'N') = 'N'
			AND isnull(clh.RecordDeleted, 'N') = 'N'
			AND (
				(
					cl.[STATUS] = 2026 -- Paid Status
					AND I.ClaimFinalStatusPaidDays >= (DATEDIFF(day, (clh.ActivityDate), GETDATE()))
					)
				OR (
					cl.[STATUS] = 2024 -- Denied Status
					AND I.ClaimFinalStatusDeniedDays >= DATEDIFF(day, (clh.ActivityDate), GETDATE())
					)
				)

		UPDATE cl
		SET FinalStatus = 'Y'
			,ModifiedBy = 'Job SWMBH#591'
			,ModifiedDate = GETDATE()
		FROM ClaimLines cl
		JOIN #ClaimLineFinalStatus c ON cl.ClaimLineId = c.ClaimLineId
		WHERE isnull(cl.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(MAX)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCUpdatePaidDeniedClaimLineStatus') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


