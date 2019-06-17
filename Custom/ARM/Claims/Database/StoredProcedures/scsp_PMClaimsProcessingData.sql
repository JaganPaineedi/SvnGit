IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'scsp_PMClaimsProcessingData')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	DROP PROCEDURE scsp_PMClaimsProcessingData;
END;
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[scsp_PMClaimsProcessingData]
	/********************************************************************************                                                        
-- Stored Procedure: scsp_PMClaimsProcessingData      
--      
-- Copyright: Streamline Healthcare Solutions      
--      
-- Purpose: Custom procedure to modify the claim file names       
--      
-- Author:  Mark Jensen      
-- Date:    05/05/2017      
--      
-- *****History****      

-- 05/05/2017	MJensen		Created							
*********************************************************************************/
	@ClaimProcessId INT
	,@ClaimBatchId INT
AS
BEGIN
	BEGIN TRY
		-- create a custom file name for Partner Solutions claim format
		DECLARE @ClaimFormatId INT = 10011
		DECLARE @UPI CHAR(5) = '12679'

		UPDATE CB
		SET CB.[FileName] = 'SC' + cf.ProductionOrTest + '0' + @UPI + CAST((
					SELECT COUNT(*)
					FROM ClaimBatches cb1
					WHERE CAST(cb1.CreatedDate AS DATE) = CAST(cb.CreatedDate AS DATE)
						AND cb1.ClaimBatchId < cb.ClaimBatchId
						AND cb1.ClaimFormatId = @ClaimFormatId
					) + 1 AS VARCHAR(max)) + '.' + RIGHT('00' + CAST(DATEPART(DayOfYear, GETDATE()) AS VARCHAR(Max)), 3) + RIGHT('0' + CAST(DATEPART(YEAR, GETDATE()) - 2000 AS VARCHAR(MAX)), 2)
		FROM ClaimBatches CB
		JOIN ClaimFormats cf ON CB.ClaimFormatId = cf.ClaimFormatId
		WHERE (
				CB.ClaimBatchId = @ClaimBatchId
				OR CB.ClaimProcessId = @ClaimProcessId
				)
			AND CB.ClaimFormatId = @ClaimFormatId
			AND ISNULL(CB.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'scsp_PMClaimsProcessingData') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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

