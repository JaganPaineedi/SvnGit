IF OBJECT_ID('csp_RDLEligibilityUpdateClientCoverage') IS NOT NULL
   DROP PROCEDURE csp_RDLEligibilityUpdateClientCoverage
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON 

GO

CREATE PROCEDURE csp_RDLEligibilityUpdateClientCoverage
   @RequestId INT = NULL
 , @BatchId INT = NULL
 , @ExecutedByStaffId INT
AS
   BEGIN 
   /**************************************************************************************
      Procedure: csp_RDLEligibilityUpdateClientCoverage
      
      Streamline Healthcare Solutions, LLC Copyright 8/16/2018
   
      Purpose: Update individual request or Queue a batch to update for Eligibility change review
   
      Parameters: 
         @RequestId - the request to update
		 @BatchId - the Batch to set to queued status
		 @ExecutedByStaffId - the staff updating 
   
      Output: 
         None
   
      Called By: RDLBatchEligibilityChangeReview
   *****************************************************************************************
      Revision History:
      8/16/2018 - Dknewtson - Created
   
   *****************************************************************************************/

	  IF @RequestId IS NULL AND @BatchId IS NULL
      BEGIN
		SELECT 'A request or batch must be specified' AS UserMessage
		RETURN 
	  END
      

      DECLARE @ErrorMessage VARCHAR(8000)

      DECLARE @UserCode VARCHAR(30)

      SELECT   @UserCode = UserCode
      FROM     Staff
      WHERE    StaffId = @ExecutedByStaffId

		IF @UserCode IS NULL
		BEGIN
			SELECT   'Your Staffid Doesn''t exist. Eligibility Batch was not queued for update.' AS UserMessage
			RETURN
		END
        
		IF @BatchId IS NOT NULL
			AND NOT EXISTS ( SELECT	1
								FROM
									dbo.ElectronicEligibilityVerificationBatches AS eevb
								WHERE
									eevb.ElectronicEligibilityVerificationBatchId = @BatchId
									AND ISNULL(eevb.RecordDeleted, 'N') <> 'Y' )
			BEGIN
				SELECT	'Unable to queue batch for update. Eligibility Batch does not exist.' AS UserMessage;
				RETURN; 
			END; 
		ELSE
			IF @BatchId IS NOT NULL
				BEGIN
					UPDATE	dbo.ElectronicEligibilityVerificationBatches
					SET		[Status] = 2 ,
							ModifiedBy = @UserCode ,
							ModifiedDate = GETDATE()
					WHERE	ElectronicEligibilityVerificationBatchId = @BatchId;

					SELECT	'Successfully queued batch for update.' AS UserMessage;
					RETURN; 
				END;

      DECLARE @UpdateClientCoveragePlanSPName VARCHAR(128) 

      SELECT   @UpdateClientCoveragePlanSPName = eevc.UpdateClientCoveragePlanProcedureName
      FROM     dbo.ElectronicEligibilityVerificationRequests AS eevr
               JOIN dbo.ElectronicEligibilityVerificationPayers AS eevp
                  ON eevp.ElectronicEligibilityVerificationPayerId = eevr.ElectronicEligibilityVerificationPayerId
                     AND ISNULL(eevp.RecordDeleted, 'N') <> 'Y'
               JOIN dbo.ElectronicEligibilityVerificationConfigurations AS eevc
                  ON eevc.ElectronicEligibilityVerificationConfigurationId = eevp.ElectronicEligibilityVerificationConfigurationId
                     AND ISNULL(eevc.RecordDeleted, 'N') <> 'Y'
      WHERE    eevr.EligibilityVerificationRequestId = @RequestId

      IF EXISTS ( SELECT   1
                  FROM     dbo.ElectronicEligibilityVerificationRequests AS eevr
                  WHERE    eevr.EligibilityVerificationRequestId = @RequestId
                           AND eevr.VerifiedXMLResponse IS NULL )
         BEGIN 
            SELECT   '271 Response was not received for this request. Client Coverage was not updated.' AS UserMessage
            RETURN
         END

      IF NOT EXISTS ( SELECT  1
                      FROM    dbo.ElectronicEligibilityVerificationRequests AS eevr
                      WHERE   eevr.EligibilityVerificationRequestId = @RequestId
                              AND ISNULL(eevr.RecordDeleted, 'n') <> 'Y' )
         BEGIN 
            SELECT   '271 Response was not found. Request may have been deleted. Client Coverage was not updated' AS UserMessage
            RETURN
         END
      
      IF @UpdateClientCoveragePlanSPName IS NULL
         OR OBJECT_ID(@UpdateClientCoveragePlanSPName, 'P') IS NULL
         BEGIN
            SELECT   'Client Coverage Update procedure not found. Client Coverage was not updated.' AS UserMessage
            RETURN
         END		


      BEGIN TRY
         EXEC @UpdateClientCoveragePlanSPName @EligibilityVerificationRequestId = @RequestId, -- int
            @UserCode = @UserCode -- varchar(20)

         SELECT   'Client Coverage was updated successfully.' AS UserMessage

         RETURN 
      END TRY
      BEGIN CATCH

         DECLARE @Error VARCHAR(8000)                                                               
         SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
            + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), '[csp_RDLEligibilityUpdateClientCoverage]') + '*****'
            + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
            + CONVERT(VARCHAR, ERROR_STATE()) + ' @RequestId=' + ISNULL(CAST(@RequestId AS VARCHAR(30)),'NULL') + ' @BatchId=' + ISNULL(CAST(@BatchId AS VARCHAR),'NULL')
			+ ' @ExecutedByStaffId=' + CAST(@ExecutedByStaffId AS VARCHAR)

         INSERT   INTO dbo.ErrorLog
                  (
                    ErrorMessage
                  , VerboseInfo
                  , DataSetInfo
                  , ErrorType
                  , CreatedBy
                  , CreatedDate
		          )
         VALUES   (
                    @Error -- ErrorMessage - text
                  , '' -- VerboseInfo - text
                  , ''-- DataSetInfo - text
                  , 'Report' -- ErrorType - varchar(50)
                  , @UserCode-- CreatedBy - type_CurrentUser
                  , GETDATE()  -- CreatedDate - type_CurrentDatetime
		          )     
         SELECT   'There was an error updating client coverage. Details have been logged.' AS UserMessage
      
      END CATCH
      RETURN
   END
