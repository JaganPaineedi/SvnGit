IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[CSP_SCDownloadEDIResponse]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[CSP_SCDownloadEDIResponse]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CSP_SCDownloadEDIResponse]
    (
      @ElectronicEligibilityVerificationConfigurationId INT = NULL
    )
AS
    BEGIN  
        BEGIN TRY  
            DECLARE @GatewayType AS VARCHAR(100)            
            DECLARE @ServiceUrl AS NVARCHAR(300)          
            DECLARE @ReuestTimeOut AS INT          
            DECLARE @ServiceKey AS NVARCHAR(100)          
            DECLARE @ServiceSecret AS NVARCHAR(100)          
            DECLARE @ProcessedCount AS VARCHAR(MAX)
            
            
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
            
            
     
            SELECT  @ProcessedCount = CAST([dbo].[DownloadBatchEligibilityResponse](@ServiceUrl, @ReuestTimeOut, @ServiceKey, @ServiceSecret, @GatewayType) AS VARCHAR(MAX))  
              
            SELECT  @ProcessedCount
        END TRY  
        BEGIN CATCH  
            DECLARE @Error VARCHAR(8000)                                                                             
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), '[CSP_SCDownloadEDIResponse]') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())
            RAISERROR                                                                                                           
  (                                                                             
  @Error, -- Message text.                                                                                                          
  16, -- Severity.                                                                                                          
  1 -- State.                                                                                                          
  );     
        END CATCH  
    END

GO


