SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[ssp_SCClientFeeUpdateCopayment] @ClientFeeId INT
AS -- =============================================    
-- Author      : Akwinass
-- Date        : 06 NOV 2015 
-- Purpose     : To Update Co-payment. 

-- 01/18/2017	NJain	Add a join on ClientId when inserting into ClientCopayments. MFS SGL #56
-- =============================================   
    BEGIN
        BEGIN TRY
            DECLARE @ClientCoveragePlanId INT
            DECLARE @ClientId INT
            DECLARE @Copayment VARCHAR(MAX)		
            DECLARE @CollectUpfront VARCHAR(MAX)
            DECLARE @CoveragePlanId INT

            SELECT TOP 1
                    @ClientId = ClientId
            FROM    ClientFees
            WHERE   ClientFeeId = @ClientFeeId

            SELECT  @ClientCoveragePlanId = CCP.ClientCoveragePlanId
            FROM    CoveragePlans CP
                    LEFT JOIN ClientCoveragePlans CCP ON CCP.CoveragePlanId = CP.CoveragePlanId
                    LEFT JOIN ClientFees CCF ON CCF.CoveragePlanId = CP.CoveragePlanId
            WHERE   ISNULL(CP.RecordDeleted, 'N') = 'N'
                    AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
                    AND CCP.ClientId = @ClientId

            SELECT  @CoveragePlanId = CP.CoveragePlanId
            FROM    CoveragePlans CP
                    LEFT JOIN ClientFees CCF ON CCF.CoveragePlanId = CP.CoveragePlanId
            WHERE   ISNULL(CP.RecordDeleted, 'N') = 'N'
                    AND CCF.ClientId = @ClientId

            SELECT  @CollectUpfront = CC.CollectUpfront
            FROM    ClientFees CC
            WHERE   ISNULL(CC.RecordDeleted, 'N') = 'N'
                    AND CC.ClientFeeId = @ClientFeeId
                    AND CC.ClientId = @ClientId

            SELECT  @Copayment = CC.SetCopayment
            FROM    ClientFees CC
            WHERE   ISNULL(CC.RecordDeleted, 'N') = 'N'
                    AND CC.ClientFeeId = @ClientFeeId
                    AND CC.ClientId = @ClientId
                    AND CC.SetCopayment = 'Y'

            IF ( @Copayment = 'Y'
                 AND @ClientCoveragePlanId IS NOT NULL
               )
                BEGIN
                    INSERT  INTO ClientCopayments
                            ( ClientCoveragePlanId ,
                              CreatedBy ,
                              CreatedDate ,
                              ModifiedBy ,
                              ModifiedDate ,
                              StartDate ,
                              EndDate ,
                              ProcedureCap ,
                              DailyCap ,
                              WeeklyCap ,
                              MonthlyCap ,
                              YearlyCap
				            )
                            SELECT  CCP.ClientCoveragePlanId ,
                                    CCF.CreatedBy ,
                                    GETDATE() ,
                                    CCF.ModifiedBy ,
                                    GETDATE() ,
                                    CCF.StartDate ,
                                    CCF.EndDate ,
                                    CASE WHEN CCF.PerSessionRatePercentage IS NOT NULL THEN CCF.PerSessionRatePercentage
                                         ELSE CCF.PerSessionRateAmount
                                    END ,
                                    CCF.PerDayRateAmount ,
                                    CCF.PerWeekRateAmount ,
                                    CCF.PerMonthRateAmount ,
                                    CCF.PerYearRateAmount
                            FROM    ClientFees CCF
                                    LEFT JOIN ClientCoveragePlans CCP ON CCF.CoveragePlanId = CCP.CoveragePlanId
                                                                         AND CCP.ClientId = CCF.ClientId
                                    LEFT JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
                            WHERE   CCF.SetCopayment = 'Y'
                                    AND CCF.ClientFeeId = @ClientFeeId
                                    AND CCF.ClientId = @ClientId
                END	

            IF ( @Copayment = 'Y'
                 AND @ClientCoveragePlanId IS NOT NULL
               )
                BEGIN
                    UPDATE  C
                    SET     C.CopayCollectUpfront = @CollectUpfront
                    FROM    ClientCoveragePlans C
                            JOIN CoveragePlans CP ON CP.CoveragePlanId = C.CoveragePlanId
                    WHERE   ISNULL(C.RecordDeleted, 'N') = 'N'
                            AND CP.CoveragePlanId = @CoveragePlanId
                            AND C.ClientId = @ClientId
                END

        END TRY

        BEGIN CATCH
        END CATCH
    END
GO

