IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_SendElectronicElectronicBatchRequest]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_SendElectronicElectronicBatchRequest]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SendElectronicElectronicBatchRequest]
    (
      @ElectronicEligibilityVerificationConfigurationId INT = NULL
    )
AS -- =============================================        
-- Author:  Pradeep A        
-- Create date: June 13, 2012        
-- Description: To Send the Subbatch request.        
-- Mar-11-2016	Pradeep.A	Added new variable for Getting SubBatchCount. Sending new Batch will be done based on this value.
--                          If @SubBatchCount = 0 then only send the batch request. If no Skip that request.	
-- 06/09/2017	NJain	Added parameter @ElectronicEligibilityVerificationConfigurationId to support multiple configurations. AP Implementation #488					
-- =============================================        
    BEGIN TRY
        DECLARE @InputXml AS XML
        DECLARE @BatchId AS INT
        DECLARE @CreatedBy AS NVARCHAR(MAX)
        DECLARE @SubBatchCount INT
        DECLARE @GatewayType AS VARCHAR(100)
        DECLARE @ServiceUrl AS NVARCHAR(300)
        DECLARE @ReuestTimeOut AS INT
        DECLARE @ServiceKey AS NVARCHAR(100)
        DECLARE @ServiceSecret AS NVARCHAR(100)
		
		
        IF @ElectronicEligibilityVerificationConfigurationId IS NULL
            BEGIN
		
                SELECT  @ElectronicEligibilityVerificationConfigurationId = ( SELECT TOP 1
                                                                                        ElectronicEligibilityVerificationConfigurationId
                                                                              FROM      dbo.ElectronicEligibilityVerificationConfigurations
                                                                            )
		
            END
		
		
        SELECT  @ServiceUrl = WebServiceURL ,
                @ReuestTimeOut = RequestTimeoutSeconds * 1000 ,
                @ServiceKey = WebServiceUserName ,
                @ServiceSecret = WebServicePassword ,
                @GatewayType = ProviderName
        FROM    ElectronicEligibilityVerificationConfigurations
        WHERE   ElectronicEligibilityVerificationConfigurationId = @ElectronicEligibilityVerificationConfigurationId
	
        DECLARE C1 CURSOR READ_ONLY
        FOR
            SELECT  InputXml ,
                    ElectronicEligibilityVerificationBatchId ,
                    CreatedBy
            FROM    dbo.ElectronicEligibilityVerificationBatches
            WHERE   [status] = 0
                    AND ISNULL(RecordDeleted, 'N') = 'N'

        OPEN c1

        FETCH NEXT
	FROM C1
	INTO @InputXml, @BatchId, @CreatedBy

        WHILE @@Fetch_Status = 0
            BEGIN
                SELECT  @SubBatchCount = COUNT(*)
                FROM    ElectronicEligibilityVerificationSubBatches
                WHERE   ElectronicEligibilityVerificationBatchId = @BatchId
                        AND ISNULL(RecordDeleted, 'N') = 'N'

                IF @SubBatchCount = 0
                    BEGIN
                        DECLARE @input NVARCHAR(MAX)

                        SET @input = CAST(@InputXml AS NVARCHAR(MAX));

                        EXEC ProcessBatchEligibilityRequestCheck @ServiceUrl, @ReuestTimeOut, @ServiceKey, @ServiceSecret, @GatewayType, @input, @BatchId, @CreatedBy, 99
                    END

                FETCH NEXT
		FROM C1
		INTO @InputXml, @BatchId, @CreatedBy
            END

        CLOSE C1

        DEALLOCATE C1
    END TRY

    BEGIN CATCH
        DECLARE @Error VARCHAR(8000)

        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), '[ssp_SendElectronicElectronicBatchRequest]') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

        RAISERROR (
			@Error
			,-- Message text.                                                                                                        
			16
			,-- Severity.                                                                                                        
			1 -- State.                                                                                                        
			);
    END CATCH

GO


