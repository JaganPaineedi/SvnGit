IF OBJECT_ID('ssp_PostClientFeeAdjustments') IS NOT NULL
	DROP PROCEDURE ssp_PostClientFeeAdjustments
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

create PROCEDURE dbo.ssp_PostClientFeeAdjustments
    (
      @AdjustmentCode INT ,
      @ClientIdInput INT = NULL ,
      @ServiceIdInput INT = NULL ,
      @DateOfServiceStart DATETIME = NULL ,
      @DateofServiceEnd DATETIME = NULL 
    )
/******************************************************************************          
--     
--  Stored Procedure: ssp_PostClientFeeAdjustments    
--  Copyright: Streamline Healthcare Solutions
--            
--  Purpose: post client fees adjustments
--          
--  Date        Author      Description   
--  ----------  ----------  ---------------------------------------------------   
--  09.25.2015  SFarber     Created    
--  11.10.2015  SFarber     Added temp code to set the All flags
--  01.27.2016  SFarber     Modified to check for SetCopayment = 'N'
--	06.30.2016  NJain		Implemented as Core
							Changed UserCode to CLIENTFEEADJUSTMENT for Adjustments posting
							Added Parameters: @ClientIdInput, @ServiceIdInput, @DateOfServiceStart, @DateofServiceEnd
--  07.06.2017  NJain		Updated for Daily Cap. AP AGL #253 				
--  07.19.2017	NJain		Modified to include existing Client Fee Adjustment in the Open Balance calculation  AP AGL #253
--  07.21.2017	NJain		Modified to distribute adjustments according to existing balances on the services  AP AGL #253			
--  07.24.2017  Dknewtson   Updated code to include cap calculations (imitating client copays in Care Management written by Slavik, operates on the same table) - Journey SGL 162,122
*******************************************************************************/
AS
    DECLARE @ChargeId INT
    DECLARE @AdjustmentAmount MONEY     
	DECLARE @ClientFeeAmount MONEY
    DECLARE @CurrentResponsibility money
    DECLARE @ClientId INT
    DECLARE @DateOfService DATETIME      
    DECLARE @FinancialActivityId INT
    DECLARE @AccountingPeriodId INT
    DECLARE @ServiceId INT  
    DECLARE @ChargeAccountingPeriodByDateOfService CHAR(1)

         
    BEGIN TRY  

--
-- Temp code to make sure All flags are set properly
--
        UPDATE  cf
        SET     AllProcedureCodes = 'Y'
        FROM    ClientFees cf
        WHERE   ISNULL(cf.RecordDeleted, 'N') = 'N'
                AND ISNULL(cf.AllProcedureCodes, 'N') <> 'Y'
                AND NOT EXISTS ( SELECT *
                                 FROM   dbo.ClientFeeProcedureCodes cfpc
                                 WHERE  cfpc.ClientFeeId = cf.ClientFeeId
                                        AND ISNULL(cfpc.RecordDeleted, 'N') = 'N' )

        UPDATE  cf
        SET     AllPrograms = 'Y'
        FROM    ClientFees cf
        WHERE   ISNULL(cf.RecordDeleted, 'N') = 'N'
                AND ISNULL(cf.AllPrograms, 'N') <> 'Y'
                AND NOT EXISTS ( SELECT *
                                 FROM   dbo.ClientFeePrograms cfp
                                 WHERE  cfp.ClientFeeId = cf.ClientFeeId
                                        AND ISNULL(cfp.RecordDeleted, 'N') = 'N' )

        UPDATE  cf
        SET     AllLocations = 'Y'
        FROM    ClientFees cf
        WHERE   ISNULL(cf.RecordDeleted, 'N') = 'N'
                AND ISNULL(cf.AllLocations, 'N') <> 'Y'
                AND NOT EXISTS ( SELECT *
                                 FROM   dbo.ClientFeeLocations cfl
                                 WHERE  cfl.ClientFeeId = cf.ClientFeeId
                                        AND ISNULL(cfl.RecordDeleted, 'N') = 'N' )

        UPDATE  cf
        SET     AllProcedureCodes = 'N'
        FROM    ClientFees cf
        WHERE   ISNULL(cf.RecordDeleted, 'N') = 'N'
                AND ISNULL(cf.AllProcedureCodes, 'Y') <> 'N'
                AND EXISTS ( SELECT *
                             FROM   dbo.ClientFeeProcedureCodes cfpc
                             WHERE  cfpc.ClientFeeId = cf.ClientFeeId
                                    AND ISNULL(cfpc.RecordDeleted, 'N') = 'N' )

        UPDATE  cf
        SET     AllPrograms = 'N'
        FROM    ClientFees cf
        WHERE   ISNULL(cf.RecordDeleted, 'N') = 'N'
                AND ISNULL(cf.AllPrograms, 'Y') <> 'N'
                AND EXISTS ( SELECT *
                             FROM   dbo.ClientFeePrograms cfp
                             WHERE  cfp.ClientFeeId = cf.ClientFeeId
                                    AND ISNULL(cfp.RecordDeleted, 'N') = 'N' )

        UPDATE  cf
        SET     AllLocations = 'N'
        FROM    ClientFees cf
        WHERE   ISNULL(cf.RecordDeleted, 'N') = 'N'
                AND ISNULL(cf.AllLocations, 'Y') <> 'N'
                AND EXISTS ( SELECT *
                             FROM   dbo.ClientFeeLocations cfl
                             WHERE  cfl.ClientFeeId = cf.ClientFeeId
                                    AND ISNULL(cfl.RecordDeleted, 'N') = 'N' ) 
----------------------------------------------------------------------------------
  -- curse over all services where an applicable client fee exists




  -- Check accounting period configuration
        SELECT  @ChargeAccountingPeriodByDateOfService = ISNULL(sc.ChargeAccountingPeriodByDateOfService, 'N')
        FROM    SystemConfigurations sc    

        DECLARE cur_Adjustments CURSOR
        FOR
          SELECT DISTINCT
                  s.ServiceId
				, s.DateOfService
                , s.ClientId
          FROM    dbo.Services AS s
                  JOIN dbo.Charges AS c
                     ON c.ServiceId = s.ServiceId
                        AND c.ClientCoveragePlanId IS NULL
                        AND ISNULL(c.Priority, 0) = 0
                        AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
                        AND EXISTS ( SELECT  1 -- current client responsibility is not 0
                                     FROM    dbo.ARLedger al
                                     WHERE   al.ChargeId = c.ChargeId
                                             AND ISNULL(al.RecordDeleted, 'N') <> 'Y'
                                             AND al.LedgerType <> 4202
                                     GROUP BY al.ChargeId
                                     HAVING  SUM(al.Amount) > 0.00 )
          WHERE   s.Status = 75
                  AND ISNULL(s.RecordDeleted, 'N') <> 'Y'
				  AND (@ClientIdInput IS NULL OR s.ClientId = @ClientIdInput)
				  AND (@ServiceIdInput IS NULL OR s.ServiceId = @ServiceIdInput)
				  AND (@DateOfServiceStart IS NULL OR @DateOfServiceStart < s.DateOfService)
				  AND (@DateofServiceEnd IS NULL OR DATEDIFF(DAY,s.DateOfService,@DateofServiceEnd)>= 0)
                  AND EXISTS ( SELECT  1
                               FROM    dbo.ClientFees AS cf
                               WHERE   cf.ClientId = s.ClientId
                                       AND ISNULL(cf.RecordDeleted, 'N') <> 'Y'
                                       AND DATEDIFF(DAY, cf.StartDate, s.DateOfService) >= 0
                                       AND (cf.EndDate IS NULL OR DATEDIFF(DAY, s.DateOfService, cf.EndDate) >= 0)
                                       AND (
                                             ISNULL(cf.AllPrograms, 'N') = 'Y'
                                             OR EXISTS ( SELECT   1
                                                         FROM     dbo.ClientFeePrograms AS cfp
                                                         WHERE    cfp.ProgramId = s.ProgramId
                                                                  AND cfp.ClientFeeId = cf.ClientFeeId
                                                                  AND ISNULL(cfp.RecordDeleted, 'N') <> 'Y' )
                                           )
                                       AND (
                                             ISNULL(cf.AllProcedureCodes, 'N') = 'Y'
                                             OR EXISTS ( SELECT   1
                                                         FROM     dbo.ClientFeeProcedureCodes AS cfpc
                                                         WHERE    cfpc.ProcedureCodeId = s.ProcedureCodeId
                                                                  AND cfpc.ClientFeeId = cf.ClientFeeId
                                                                  AND ISNULL(cfpc.RecordDeleted, 'N') <> 'Y' )
                                           )
                                       AND (
                                             ISNULL(cf.AllLocations, 'N') = 'Y'
                                             OR EXISTS ( SELECT   1
                                                         FROM     dbo.ClientFeeLocations AS cfl
                                                         WHERE    cfl.LocationId = s.LocationId
                                                                  AND cfl.ClientFeeId = cf.ClientFeeId
                                                                  AND ISNULL(cfl.RecordDeleted, 'N') <> 'Y' )
                                           ) )
				ORDER BY s.DateOfService desc
     
        OPEN cur_Adjustments      
      
        FETCH cur_Adjustments INTO @ServiceId, @DateOfService, @ClientId
      
        WHILE @@fetch_status = 0
            BEGIN      

                SELECT  @ChargeId = c.ChargeId
                FROM    Charges c
                WHERE   c.ServiceId = @ServiceId
                        AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
                        AND c.ClientCoveragePlanId IS NULL
                        AND ISNULL(c.Priority, 0) = 0

                SELECT  @CurrentResponsibility = SUM(Amount) -- current client responsibility
                FROM    dbo.ARLedger AS al
                WHERE   al.ChargeId = @ChargeId
                        AND ISNULL(al.RecordDeleted, 'N') <> 'Y'
                        AND al.LedgerType <> 4202

				SELECT @ClientFeeAmount = dbo.ssf_PMCalculateClientFee(@ServiceId) 
				
				SELECT @AdjustmentAmount = @CurrentResponsibility - @ClientFeeAmount

				IF @AdjustmentAmount > 0.00
				BEGIN
       
					IF @ChargeAccountingPeriodByDateOfService = 'Y'
						BEGIN      
							SELECT TOP 1
									@AccountingPeriodId = ap.AccountingPeriodId
							FROM    AccountingPeriods ap
							WHERE   ap.StartDate <= @DateOfService
									AND DATEADD(dd, 1, ap.EndDate) > @DateOfService
									AND ap.OpenPeriod = 'Y'
									AND ISNULL(ap.RecordDeleted, 'N') = 'N'
							ORDER BY ap.StartDate      
	      
						END      
					ELSE
						BEGIN      
							SELECT TOP 1
									@AccountingPeriodId = ap.AccountingPeriodId
							FROM    AccountingPeriods ap
							WHERE   ap.StartDate <= GETDATE()
									AND DATEADD(dd, 1, ap.EndDate) > GETDATE()
									AND ISNULL(ap.RecordDeleted, 'N') = 'N'
							ORDER BY ap.StartDate
						END      

					BEGIN TRAN      
  
					INSERT  INTO FinancialActivities
							( ClientId ,
							  ActivityType ,
							  CreatedBy ,
							  CreatedDate ,
							  ModifiedBy ,
							  ModifiedDate
							)
					VALUES  ( @ClientId ,
							  4326 ,
							  'CLIENTFEEADJUSTMENT' ,
							  GETDATE() ,
							  'CLIENTFEEADJUSTMENT' ,
							  GETDATE()
							)            
      
					SET @FinancialActivityId = SCOPE_IDENTITY()
  
					EXEC ssp_PMPaymentAdjustmentPost @UserCode = 'CLIENTFEEADJUSTMENT', @FinancialActivityId = @FinancialActivityId, @PaymentId = NULL, @Adjustment1 = @AdjustmentAmount, @AdjustmentCode1 = @AdjustmentCode, @PostedAccountingPeriodId = @AccountingPeriodId, @ChargeId = @ChargeId, @ServiceId = @ServiceId, @DateOfService = @DateOfService, @ClientId = @ClientId, @CoveragePlanId = NULL, @ERTransferPosting = 'N', @FinancialActivityLineId = NULL      
        
					COMMIT TRAN      

				END 
				FETCH cur_Adjustments INTO @ServiceId, @DateOfService, @ClientId
      
            END      
      
        CLOSE cur_Adjustments      
        DEALLOCATE cur_Adjustments      
  
     
    END TRY      
    BEGIN CATCH          
      
        DECLARE @Error VARCHAR(8000)          
        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_UpdateChargeAllowedAmounts') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())          
            
        IF @@trancount > 1
            ROLLBACK TRAN      
       
        RAISERROR (@Error, 16, 1);          
      
    END CATCH  

GO

