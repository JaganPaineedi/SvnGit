/****** Object:  StoredProcedure [dbo].[ssp_SCCalculateClientBalance]    Script Date: 03/07/2017 13:19:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[ssp_SCCalculateClientBalance] @ClientId INT  
/********************************************************************************                                                
-- Stored Procedure: dbo.ssp_SCCalculateClientBalance                                               
--                                                
-- Copyright: Streamline Healthcate Solutions                                                
--                                                
-- Purpose: Calculates and updates client current balance
--                                                
-- Updates:                                                                                                       
-- Date        Author          Purpose                                                
-- 03.27.2014  SFarber         Created.     
-- 03.07.2017  NJain		   Updated to look for c.ClientCoveragePlanId IS NULL instead of ar.CoveragePlanId IS NULL, due to bad data in ARLedger     
*********************************************************************************/
AS
    DECLARE @ErrorMessage VARCHAR(4000)
    DECLARE @ErrorNumber INT
    DECLARE @ErrorSeverity INT
    DECLARE @ErrorState INT
    DECLARE @ErrorLine INT
    DECLARE @ErrorProcedure VARCHAR(200)

    DECLARE @ARLedgerAmount MONEY
    DECLARE @PaymentAmount MONEY
    DECLARE @RefundAmount MONEY

    BEGIN TRY
  
        SELECT  @ARLedgerAmount = SUM(ar.Amount)
        FROM    Services s
                JOIN Charges c ON c.ServiceId = s.ServiceId
                JOIN ARLedger ar ON ar.ChargeId = c.ChargeId
        WHERE   s.ClientId = @ClientId
                --AND ar.CoveragePlanId IS NULL
                AND c.ClientCoveragePlanId IS NULL
                AND ar.LedgerType <> 4202 -- Exclude payments
                AND ISNULL(ar.RecordDeleted, 'N') = 'N'
                AND ISNULL(s.RecordDeleted, 'N') = 'N'
                AND ISNULL(c.RecordDeleted, 'N') = 'N'

        SELECT  @PaymentAmount = SUM(p.Amount)
        FROM    Payments p
        WHERE   p.ClientId = @ClientId
                AND ISNULL(p.RecordDeleted, 'N') = 'N'

        SELECT  @RefundAmount = SUM(r.Amount)
        FROM    Payments p
                JOIN Refunds r ON r.PaymentId = p.PaymentId
        WHERE   p.ClientId = @ClientId
                AND ISNULL(p.RecordDeleted, 'N') = 'N'
                AND ISNULL(r.RecordDeleted, 'N') = 'N'

        BEGIN TRAN

        UPDATE  c
        SET     CurrentBalance = ISNULL(@ARLedgerAmount, 0) - ISNULL(@PaymentAmount, 0) + ISNULL(@RefundAmount, 0)
        FROM    Clients c
        WHERE   c.ClientId = @ClientId
                AND ISNULL(c.CurrentBalance, 0) <> ( ISNULL(@ARLedgerAmount, 0) - ISNULL(@PaymentAmount, 0) + ISNULL(@RefundAmount, 0) )

        COMMIT TRAN

    END TRY
    BEGIN CATCH

        SELECT  @ErrorNumber = ERROR_NUMBER() ,
                @ErrorSeverity = ERROR_SEVERITY() ,
                @ErrorState = ERROR_STATE() ,
                @ErrorLine = ERROR_LINE() ,
                @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-')

        SELECT  @ErrorMessage = 'Error %d, Level %d, State %d, Procedure %s, Line %d, ' + 'Message: ' + ERROR_MESSAGE()
 
        IF @@trancount > 0
            ROLLBACK TRANSACTION

        RAISERROR(@ErrorMessage, @ErrorSeverity, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine)


    END CATCH

    RETURN

GO
