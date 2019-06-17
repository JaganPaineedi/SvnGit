/****** Object:  StoredProcedure [dbo].[ssp_SCGetRefundAddress]    Script Date: 12/15/2016 11:28:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetRefundAddress]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetRefundAddress]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetRefundAddress]    Script Date: 12/15/2016 11:28:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetRefundAddress]
	/********************************************************************************                                                    
-- Stored Procedure: [ssp_SCGetRefundAddress]  
--  
-- Copyright: Streamline Healthcare Solutions  
--  
-- Purpose: Procedure to return data for refund "To" and "Address".  
--  
-- Author:  Akwinass  
-- Date:    15-DEC-2016
--  
******************************************************************************* 
** Change History 
******************************************************************************* 
** Date: 			Author: 			Description: 
** 
-------- 			-------- 			--------------- 
-- 16 DEC 2016      Akwinass            Created. (Task #391 in Philhaven Development)					
*******************************************************************************/
@ClientId INT,@CoveragePlanId INT,@ActivityType INT
AS
BEGIN
	BEGIN TRY 
		IF OBJECT_ID('tempdb..#RefundAddress') IS NOT NULL
			DROP TABLE #RefundAddress

		CREATE TABLE #RefundAddress (
			RefundAdjustmentTo VARCHAR(250)
			,RefundAdjustmentAddress VARCHAR(250)
			)

		IF ISNULL(@ActivityType, 0) = 4323
		BEGIN
			INSERT INTO #RefundAddress(RefundAdjustmentTo,RefundAdjustmentAddress)
			SELECT TOP 1 ISNULL(CP.CoveragePlanName,''),ISNULL(CP.AddressDisplay, '')
			FROM CoveragePlans CP
			WHERE CP.CoveragePlanId = @CoveragePlanId
				AND ISNULL(CP.RecordDeleted, 'N') = 'N'
		END

		IF ISNULL(@ActivityType, 0) = 4325
		BEGIN
			INSERT INTO #RefundAddress(RefundAdjustmentTo,RefundAdjustmentAddress)
			SELECT TOP 1 CC.LastName + ', ' + CC.FirstName,CCA.Display
			FROM ClientContacts CC
			JOIN ClientContactAddresses CCA ON CC.ClientContactId = CCA.ClientContactId
			JOIN Clients C ON CC.ClientId = C.ClientId
			WHERE ISNULL(C.RecordDeleted, 'N') = 'N'
				AND ISNULL(CC.RecordDeleted, 'N') = 'N'
				AND ISNULL(CCA.RecordDeleted, 'N') = 'N'
				AND ISNULL(CC.Active,'N') = 'Y'
				AND ISNULL(CC.FinanciallyResponsible,'N') = 'Y'
				AND RTRIM(LTRIM(ISNULL(CCA.[Address],''))) != ''
				AND RTRIM(LTRIM(ISNULL(CC.LastName,''))) != ''
				AND RTRIM(LTRIM(ISNULL(CC.FirstName,''))) != ''
				AND C.ClientId = @ClientId
			ORDER BY CCA.AddressType ASC,CCA.ModifiedDate DESC
			
			IF NOT EXISTS(SELECT 1 FROM #RefundAddress)
			BEGIN
				INSERT INTO #RefundAddress(RefundAdjustmentTo,RefundAdjustmentAddress)
				SELECT TOP 1 C.LastName + ', ' + C.FirstName,CA.Display
				FROM ClientAddresses CA
				JOIN Clients C ON CA.ClientId = C.ClientId
				WHERE ISNULL(C.RecordDeleted, 'N') = 'N'	
					AND ISNULL(CA.RecordDeleted, 'N') = 'N'	
					AND RTRIM(LTRIM(ISNULL([Address],''))) != ''
					AND RTRIM(LTRIM(ISNULL(C.LastName,''))) != ''
					AND RTRIM(LTRIM(ISNULL(C.FirstName,''))) != ''
					AND C.ClientId = @ClientId
				ORDER BY CA.AddressType ASC,CA.ModifiedDate DESC
			END
		END

		SELECT TOP 1 RefundAdjustmentTo
			,RefundAdjustmentAddress
		FROM #RefundAddress
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetRefundAddress') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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