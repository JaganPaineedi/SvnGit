/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientFeeDetails]    Script Date: 07/24/2015 12:27:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientFeeDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientFeeDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientFeeDetails]    Script Date: 07/24/2015 12:27:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetClientFeeDetails] @ClientFeeId INT
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_SCGetClientFeeDetails   137           */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    24/JULY/2015                                         */
/*                                                                   */
/* Purpose:  Used in getdata() for ClientFees Detail Page  */
/*                                                                   */
/* Input Parameters: @ClientFeeId   */
/*                                                                   */
/* Output Parameters:   None                */
/*                                                                   */
/*********************************************************************/
BEGIN
	BEGIN TRY
		SELECT ClientFeeId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedBy
			,DeletedDate
			,ClientId
			,CoveragePlanId
			,ClientFeeType
			,StartDate
			,EndDate
			,PerSessionRatePercentage
			,PerSessionRateAmount
			,PerDayRatePercentage
			,PerDayRateAmount
			,PerWeekRatePercentage
			,PerWeekRateAmount
			,PerMonthRatePercentage
			,PerMonthRateAmount
			,PerYearRatePercentage
			,PerYearRateAmount
			,Comments
			,SetCopayment
			,CollectUpfront
			,AllLocations
			,AllPrograms
			,AllProcedureCodes
			,Priority
			,[dbo].[ssf_SCGetClientFeeLocations](ClientFeeId,'ID') AS Locations
			,[dbo].[ssf_SCGetClientFeePrograms](ClientFeeId,'ID') AS Programs
			,[dbo].[ssf_SCGetClientFeeProcedureCodes](ClientFeeId,'ID') AS ProcedureCodes			
		FROM ClientFees
		WHERE ClientFeeId = @ClientFeeId
			AND ISNULL(RecordDeleted, 'N') = 'N'

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCGetClientFeeDetails]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


