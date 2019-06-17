IF OBJECT_ID('csp_EligibilityProcessQueuedBatches') IS NOT NULL
   DROP PROCEDURE csp_EligibilityProcessQueuedBatches
GO

SET ANSI_NULLS ON 
SET QUOTED_IDENTIFIER ON 
GO

CREATE PROCEDURE csp_EligibilityProcessQueuedBatches
   @ModifiedDaysBack INT = 3
AS
   BEGIN
/**************************************************************************************
   Procedure: csp_EligibilityProcessQueuedBatches
   
   Streamline Healthcare Solutions, LLC Copyright 8/16/2018

   Purpose: Process batches in status 2

   Parameters: 
      None

   Output: 
      None

   Called By: SQL Job
*****************************************************************************************
   Revision History:
   8/16/2018 - Dknewtson - Created

*****************************************************************************************/

      DECLARE @RequestId INT 
      DECLARE @UserCode VARCHAR(30) 
      DECLARE @UpdateStoredProcedure VARCHAR(100)

      DECLARE cur_requests CURSOR
      FOR
         SELECT   eevr.EligibilityVerificationRequestId
                , eevb.ModifiedBy
                , eevc.UpdateClientCoveragePlanProcedureName
         FROM     dbo.ElectronicEligibilityVerificationBatches AS eevb
                  JOIN dbo.ElectronicEligibilityVerificationRequests AS eevr
                     ON eevr.ElectronicEligibilityVerificationBatchId = eevb.ElectronicEligibilityVerificationBatchId
                        AND ISNULL(eevr.RecordDeleted, 'N') <> 'Y'
                  JOIN dbo.ElectronicEligibilityVerificationPayers AS eevp
                     ON eevp.ElectronicEligibilityVerificationPayerId = eevr.ElectronicEligibilityVerificationPayerId
                        AND ISNULL(eevp.RecordDeleted, 'N') <> 'Y'
                  JOIN dbo.ElectronicEligibilityVerificationConfigurations AS eevc
                     ON eevc.ElectronicEligibilityVerificationConfigurationId = eevp.ElectronicEligibilityVerificationConfigurationId
                        AND ISNULL(eevc.RecordDeleted, 'N') <> 'Y'
         WHERE    eevb.[Status] = 2
                  AND ISNULL(eevb.RecordDeleted, 'N') <> 'Y'
                  AND DATEDIFF(DAY, eevb.ModifiedDate, GETDATE()) <= @ModifiedDaysBack
		 ORDER BY eevr.DateOfServiceStart ASC

      OPEN cur_requests

      FETCH NEXT FROM cur_requests INTO @RequestId, @UserCode, @UpdateStoredProcedure

      WHILE @@FETCH_STATUS = 0
         BEGIN
            BEGIN TRY
               BEGIN TRAN
            
               EXEC @UpdateStoredProcedure @RequestId, @UserCode

               COMMIT TRAN
            END TRY
            BEGIN CATCH
               ROLLBACK TRAN 
            
               EXEC dbo.ssp_RethrowError

            END CATCH 

            FETCH NEXT FROM cur_requests INTO @RequestId, @UserCode, @UpdateStoredProcedure
        
         END
      CLOSE cur_requests
      DEALLOCATE cur_requests

      UPDATE   dbo.ElectronicEligibilityVerificationBatches
      SET      [Status] = 3
      WHERE    [Status] = 2
               AND ISNULL(RecordDeleted, 'N') <> 'Y'
               AND DATEDIFF(DAY, ModifiedDate, GETDATE()) <= @ModifiedDaysBack

      RETURN
   END 
GO
