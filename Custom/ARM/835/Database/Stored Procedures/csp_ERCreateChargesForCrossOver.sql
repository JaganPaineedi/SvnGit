IF OBJECT_ID('csp_ERCreateChargesForCrossOver') IS NOT NULL 
   DROP PROCEDURE csp_ERCreateChargesForCrossOver
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE csp_ERCreateChargesForCrossOver
       @TransferAdjustmentCode INT
AS 
       BEGIN
/**************************************************************************************
   Procedure: csp_ERCreateChargesForCrossOver
   
   Streamline Healthcare Solutions, LLC Copyright 2016

   Purpose: Create charges for cross over claims via $0 transfers

   Parameters: 
      @TransferAdjustmentCode - Adjustment code for $0 transfers

   Output: 
      None

   Called By: Job
*****************************************************************************************
   Revision History:
   12-JAN-2016 - Dknewtson - Created
   22-FEB-2016 - Dknewtson - Added check for billed date into select list for Cross over source charges.
                           - Removed record delete checks to coverage plans and client coverage plans.

*****************************************************************************************/

SET NOCOUNT ON
      
             DECLARE @UserCode VARCHAR(30)= 'CROSSOVER'

             DECLARE @ClientId INT
                    ,@ServiceId INT
                    ,@DateOfService DATETIME
                    ,@ProcedureCodeId INT
                    ,@ClinicianId INT
                    ,@ClientCoveragePlanId INT
                    ,@CoveragePlanId INT
                    ,@NextClientCoveragePlanId INT
                    ,@FinancialActivityId INT
                    ,@FinancialActivityLineId INT
                    ,@TransferToChargeId INT
                    ,@ChargeId INT
                    ,@FinancialActivityVersion INT                        
  
             DECLARE @PostedAccountingPeriodId INT            
  
             SELECT @PostedAccountingPeriodId = AccountingPeriodId
             FROM   AccountingPeriods
             WHERE  StartDate <= GETDATE()
                    AND DATEADD(dd, 1, EndDate) > GETDATE()           

             DECLARE cur_crossovercharges CURSOR
             FOR
                     SELECT ccp.ClientId
                           ,s.ServiceId
                           ,s.DateOfService
                           ,s.ProcedureCodeId
                           ,s.ClinicianId
                           ,ccp.ClientCoveragePlanId
                           ,cp.CoveragePlanId
                           ,c.ChargeId
                     FROM   Charges c
                            JOIN ClientCoveragePlans ccp
                                ON c.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                                   --AND ISNULL(ccp.RecordDeleted, 'N') <> 'Y'
                            JOIN dbo.CoveragePlans cp
                                ON ccp.CoveragePlanId = cp.CoveragePlanId
                                   --AND ISNULL(cp.RecordDeleted, 'N') <> 'Y'
                            JOIN dbo.ssf_RecodeValuesCurrent('CROSSOVERCLAIMSOURCE') src
                                ON src.IntegerCodeId = cp.CoveragePlanId
                            JOIN dbo.Services s
                                ON s.ServiceId = c.ServiceId
                                   AND ISNULL(s.RecordDeleted, 'N') <> 'Y'
                                   AND [Status] = 75
                            JOIN dbo.Clients c2
                                ON s.ClientId = c2.ClientId
                                   AND ISNULL(c2.RecordDeleted, 'N') <> 'Y'
                     WHERE  ISNULL(c.RecordDeleted, 'N') <> 'Y'
                           -- charge has been billed to the source.
                           AND c.FirstBilledDate IS NOT NULL 


             OPEN cur_crossovercharges

             FETCH NEXT FROM cur_crossovercharges INTO @ClientId --INT
                   , @ServiceId --INT
                   , @DateOfService --DATETIME
                   , @ProcedureCodeId --INT
                   , @ClinicianId --INT
                   , @ClientCoveragePlanId --INT
                   , @CoveragePlanId --INT
                   , @ChargeId

             WHILE @@Fetch_Status = 0 
                   BEGIN
  
                         
                         BEGIN TRY
                               BEGIN TRAN                       
  
                               set @NextClientCoveragePlanId = NULL

                               EXEC dbo.ssp_PMGetNextBillablePayer @ClientId = @ClientId, -- int
                                @ServiceId = @ServiceId, -- int
                                @DateOfService = @DateOfService, -- datetime
                                @ProcedureCodeId = @ProcedureCodeId, -- int
                                @ClinicianId = @ClinicianId, -- int
                                @ClientCoveragePlanId = @ClientCoveragePlanId, -- int
                                @NextClientCoveragePlanId = @NextClientCoveragePlanId OUTPUT -- int

                               IF @NextClientCoveragePlanId IS NOT NULL 
                                  AND EXISTS ( SELECT   1
                                           FROM     dbo.ClientCoveragePlans ccp
                                                    JOIN dbo.CoveragePlans cp
                                                        ON ccp.CoveragePlanId = cp.CoveragePlanId
                                                           AND ISNULL(cp.RecordDeleted, 'N') <> 'Y'
                                                    JOIN dbo.ssf_RecodeValuesCurrent('CROSSOVERCLAIMDESTINATION') dest
                                                        ON dest.IntegerCodeId = cp.CoveragePlanId
                                           WHERE    ISNULL(ccp.RecordDeleted, 'N') <> 'Y'
                                                    AND ccp.ClientCoveragePlanId = @NextClientCoveragePlanId )
                                  AND NOT EXISTS ( SELECT   1
                                                   FROM     dbo.Charges c
                                                   WHERE    c.ServiceId = @ServiceId
                                                            AND c.ClientCoveragePlanId = @NextClientCoveragePlanId
                                                            AND ISNULL(c.RecordDeleted, 'N') <> 'Y' ) 
                                  
                                  BEGIN
                
                                        SET @FinancialActivityId = NULL     
                
                                        INSERT  INTO FinancialActivities
                                                ( 
                                                 CoveragePlanId
                                                ,ClientId
                                                ,ActivityType
                                                ,CreatedBy
                                                ,CreatedDate
                                                ,ModifiedBy
                                                ,ModifiedDate
                                                )
                                        VALUES  ( 
                                                 NULL
                                                ,@ClientId
                                                ,4326
                                                ,@UserCode
                                                ,GETDATE()
                                                ,@UserCode
                                                ,GETDATE()
                                                )   
                                    
                                        SET @FinancialActivityId = SCOPE_IDENTITY()   
	
                                        SET @FinancialActivityLineId = NULL
  
                                        INSERT  INTO FinancialActivityLines
                                                ( 
                                                 FinancialActivityId
                                                ,ChargeId
                                                ,CurrentVersion
                                                ,Flagged
                                                ,Comment
                                                ,CreatedBy
                                                ,CreatedDate
                                                ,ModifiedBy
                                                ,ModifiedDate
			                                       )
                                        VALUES  ( 
                                                 @FinancialActivityId
                                                ,@ChargeId
                                                ,1
                                                ,NULL
                                                ,NULL
                                                ,@UserCode
                                                ,GETDATE()
                                                ,@UserCode
                                                ,GETDATE()
                                                )                         

                                        SET @FinancialActivityLineId = SCOPE_IDENTITY()

                                        SET @FinancialActivityVersion = 1
                        --EXEC dbo.ssp_PMPaymentAdjustmentPost @UserCode = '', -- varchar(30) this won't work since it will just return instead of posting the transfer

                                        SET @TransferToChargeId = NULL
                                       
                                        EXEC ssp_PMCreateCharge @UserCode, @ServiceId, @DateOfService,
                                            @NextClientCoveragePlanId, @TransferToChargeId OUTPUT
  
                                        --PRINT @TransferToChargeId

                                        IF @TransferToChargeId IS NOT NULL
                                        BEGIN                                      
                           -- set do not bill since these are cross overs
                                        UPDATE  Charges
                                        SET     DoNotBill = 'Y'
                                        WHERE   ChargeId = @TransferToChargeId           
                           
                           	                                            

                                        INSERT  INTO ARLedger
                                                ( 
                                                 ChargeId
                                                ,FinancialActivityLineId
                                                ,FinancialActivityVersion
                                                ,LedgerType
                                                ,Amount
                                                ,PaymentId
                                                ,AdjustmentCode
                                                ,AccountingPeriodId
                                                ,PostedDate
                                                ,ClientId
                                                ,CoveragePlanId
                                                ,DateOfService
                                                ,ErrorCorrection
                                                ,CreatedBy
                                                ,CreatedDate
                                                ,ModifiedBy
                                                ,ModifiedDate
		                                          )
                                        VALUES  ( 
                                                 @ChargeId
                                                ,@FinancialActivityLineId
                                                ,@FinancialActivityVersion
                                                ,4204
                                                ,0
                                                ,NULL
                                                ,@TransferAdjustmentCode
                                                ,@PostedAccountingPeriodId
                                                ,GETDATE()
                                                ,@ClientId
                                                ,@CoveragePlanId
                                                ,@DateOfService
                                                ,NULL
                                                ,@UserCode
                                                ,GETDATE()
                                                ,@UserCode
                                                ,GETDATE()
                                                )     
                                                    
                                        INSERT  INTO ARLedger
                                                ( 
                                                 ChargeId
                                                ,FinancialActivityLineId
                                                ,FinancialActivityVersion
                                                ,LedgerType
                                                ,Amount
                                                ,PaymentId
                                                ,AdjustmentCode
                                                ,AccountingPeriodId
                                                ,PostedDate
                                                ,ClientId
                                                ,CoveragePlanId
                                                ,DateOfService
                                                ,ErrorCorrection
                                                ,CreatedBy
                                                ,CreatedDate
                                                ,ModifiedBy
                                                ,ModifiedDate
			                                       )
                                        VALUES  ( 
                                                 @TransferToChargeId
                                                ,@FinancialActivityLineId
                                                ,@FinancialActivityVersion
                                                ,4204
                                                ,0
                                                ,NULL
                                                ,@TransferAdjustmentCode
                                                ,@PostedAccountingPeriodId
                                                ,GETDATE()
                                                ,@ClientId
                                                ,NULL
                                                ,@DateOfService
                                                ,NULL
                                                ,@UserCode
                                                ,GETDATE()
                                                ,@UserCode
                                                ,GETDATE()
                                                )
                                                                   
                                      END                
                                  END
                                  
                               COMMIT TRAN
                         END TRY
                         BEGIN CATCH

                               IF @@Trancount > 0 
                                  ROLLBACK TRAN
                               EXEC dbo.ssp_SQLErrorHandler

                         END CATCH

                           -- Don't need to create open charges since amount is always 0

             FETCH NEXT FROM cur_crossovercharges INTO @ClientId --INT
                   , @ServiceId --INT
                   , @DateOfService --DATETIME
                   , @ProcedureCodeId --INT
                   , @ClinicianId --INT
                   , @ClientCoveragePlanId --INT
                   , @CoveragePlanId --INT
                   , @ChargeId

                   END    

             CLOSE cur_crossovercharges
             DEALLOCATE cur_crossovercharges



       END
GO
