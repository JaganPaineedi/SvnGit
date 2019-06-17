IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[SSP_SCAutoSendBatchRequest]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[SSP_SCAutoSendBatchRequest]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[SSP_SCAutoSendBatchRequest]
    (
      @BatchType AS VARCHAR(100) ,
      @ElectronicEligibilityVerificationConfigurationId INT = NULL
    )
AS -- =============================================  
-- Author:  Pradeep A
-- Create date: July 06, 2012  
-- Description: Automatic Send batch requests.
-- 06/09/2017	NJain	Added parameter @ElectronicEligibilityVerificationConfigurationId to support multiple configurations. AP Implementation #488
-- 16-03-2018   P Narayana Added the sp call csp_SCQueryElectronicEligibilitySpecificPlansBatchVerificationData for 
--              for Specific Coverage Plan(s) Batch Eligibility for Task #1162,Thresholds Enhancements
-- =============================================
    BEGIN

        DECLARE @BatchName AS VARCHAR(200)
        DECLARE @BatchID AS INT
        DECLARE @NoRowsAfffected AS INT
        DECLARE @CreateBy AS VARCHAR(100)
	
        SET @CreateBy = SYSTEM_USER
		
        IF @ElectronicEligibilityVerificationConfigurationId IS NULL
            BEGIN
		
                SELECT  @ElectronicEligibilityVerificationConfigurationId = ( SELECT TOP 1
                                                                                        ElectronicEligibilityVerificationConfigurationId
                                                                              FROM      dbo.ElectronicEligibilityVerificationConfigurations
                                                                            )
		
            END
		
		
        IF @BatchType = 'M'
            BEGIN
                SET @BatchName = 'Monthly Batch Eligibility ' + CONVERT(VARCHAR(20), GETDATE(), 100)
                SET @BatchType = 'csp_SCQueryElectronicEligibilityMonthyBatchVerificationData'
            END
        ELSE
            IF @BatchType = 'D'
                BEGIN
                    SET @BatchName = 'Daily Batch Eligibility ' + CONVERT(VARCHAR(20), GETDATE(), 100)	
                    SET @BatchType = 'csp_SCQueryElectronicEligibilityDailyBatchVerificationData'
                END
         ELSE -- 16-03-2018   P Narayana
            IF @BatchType = 'C'
                BEGIN
                    SET @BatchName = 'Specific Coverage Plan(s) Batch Eligibility ' + CONVERT(VARCHAR(20), GETDATE(), 100)	
                    SET @BatchType = 'csp_SCQueryElectronicEligibilitySpecificPlansBatchVerificationData'
                END
                  
        BEGIN TRY		
            EXEC @BatchID= ssp_SCCreateElectronicEligibilityVerificationBatchId @BatchName, @CreateBy, 'R'
				
            EXEC @NoRowsAfffected= SSP_SCSaveBatchEligibilityRequestCheck @BatchID, @CreateBy, @BatchType	
		
            EXEC ssp_SendElectronicElectronicBatchRequest @ElectronicEligibilityVerificationConfigurationId
	    
        END TRY
        BEGIN CATCH
            DECLARE @Error VARCHAR(8000)                                                                   
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), '[SSP_SCAutoSendBatchRequest]') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())
            RAISERROR                                                                                                 
		(                                                                   
		 @Error, -- Message text.                                                                                                
		 16, -- Severity.                                                                                                
		 1 -- State.                                                                                                
		 ); 
        END CATCH
    END


GO


