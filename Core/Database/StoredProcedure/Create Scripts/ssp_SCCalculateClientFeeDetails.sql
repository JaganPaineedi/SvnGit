/****** Object:  StoredProcedure [dbo].[ssp_SCCalculateClientFeeDetails]    Script Date: 07/24/2015 14:27:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCCalculateClientFeeDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCCalculateClientFeeDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCCalculateClientFeeDetails]    Script Date: 07/24/2015 14:27:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCCalculateClientFeeDetails] @ClientFeeId INT,
@ClientFeeType INT
,@CoveragePlanId INT
,@BeginDate DATETIME
,@EndDate DATETIME
,@PerSessionRatePercentage VARCHAR(25)
,@PerSessionRateAmount VARCHAR(25)
,@PerDayRateAmount VARCHAR(25)
,@PerWeekRateAmount VARCHAR(25)
,@PerMonthRateAmount VARCHAR(25)
,@PerYearRateAmount VARCHAR(25)
,@Comments VARCHAR(25)
,@SetCopayment VARCHAR(25)
,@CollectUpfront VARCHAR(25)
,@CurrentUserId INT
,@ClientId INT
AS
-- =============================================    
-- Author      : Akwinass
-- Date        : 27 July 2015 
-- Purpose     : To Calculate & Update Client Fees. 
-- Updates:                                                           
-- Date			 Author			Purpose
-- 10-NOV-2015	 Akwinass		What:Removed PerDayRatePercentage, PerWeekRatePercentage, PerMonthRatePercentage, PerYearRatePercentage.          
--								Why:task  #995.2 Valley - Customizations
-- 13-Feb-2017	 Venkatesh		What: Updated the PerDayRatePercentage, PerWeekRatePercentage, PerMonthRatePercentage, PerYearRatePercentage in Client Fees. To Avoid unsaved changesin screen          
--								Why:task  #10 TxAce - Customizations
-- =============================================   
BEGIN
	BEGIN TRY
		IF OBJECT_ID('dbo.scsp_SCCalculateClientFeeDetails', 'P') IS NOT NULL
		BEGIN
		CREATE TABLE #RateAmount
		(
		PerSessionRatePercentage VARCHAR(25),
		PerSessionRateAmount VARCHAR(25),
		PerDayRateAmount VARCHAR(25),
		PerWeekRateAmount VARCHAR(25),
		PerMonthRateAmount VARCHAR(25), 
		PerYearRateAmount VARCHAR(25)
		)	
		INSERT INTO #RateAmount
		EXEC scsp_SCCalculateClientFeeDetails @ClientFeeId
			,@ClientFeeType
			,@CoveragePlanId
			,@BeginDate
			,@EndDate
			,@PerSessionRatePercentage
			,@PerSessionRateAmount
			,@PerDayRateAmount
			,@PerWeekRateAmount
			,@PerMonthRateAmount
			,@PerYearRateAmount
			,@Comments
			,@SetCopayment
			,@CollectUpfront
			,@CurrentUserId
			,@ClientId
				
		UPDATE ClientFees SET PerSessionRatePercentage=I.PerSessionRatePercentage,PerSessionRateAmount=I.PerSessionRateAmount,
		PerDayRateAmount=I.PerDayRateAmount,PerWeekRateAmount=I.PerWeekRateAmount,PerMonthRateAmount=I.PerMonthRateAmount,PerYearRateAmount=I.PerYearRateAmount
		FROM (SELECT PerSessionRatePercentage,
		PerSessionRateAmount,
		PerDayRateAmount,
		PerWeekRateAmount,
		PerMonthRateAmount, 
		PerYearRateAmount FROM #RateAmount)I
		WHERE ClientFeeId=@ClientFeeId
		
		SELECT '$' +PerSessionRatePercentage,
		'$' +PerSessionRateAmount,
		'$' +PerDayRateAmount,
		'$' +PerWeekRateAmount,
		'$' +PerMonthRateAmount, 
		'$' +PerYearRateAmount FROM #RateAmount 

		END
	END TRY

	BEGIN CATCH                  
    DECLARE @Error varchar(8000)                              
          SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****'                                            
          + Convert(varchar(4000),ERROR_MESSAGE())                                                   
          + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),                                            
          '[ssp_GetGroupServiceEntryInformation]')                                
          + '*****' + Convert(varchar,ERROR_LINE())                                            
          + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                  
          + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                  
      RAISERROR                                                   
          (                                                   
            @Error, -- Message text.                       
            16, -- Severity.                                                   
            1 -- State.                                                   
          )                   
  END CATCH    
END
GO





