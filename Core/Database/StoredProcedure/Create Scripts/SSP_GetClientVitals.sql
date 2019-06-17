
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetClientVitals]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetClientVitals]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
 CREATE PROCEDURE [dbo].[SSP_GetClientVitals] (  
  @ClientId INT  
 ,@HealthDataTemplateId INT  
 ,@StartDate DATETIME = NULL  
 ,@EndDate DATETIME = NULL  
 )  
 /********************************************************************************                                                                          
-- Stored Procedure: dbo.SSP_GetClientVitals.sql                                                                            
--   SSP_GetClientVitals 4,110                                                                       
-- Copyright: Streamline Healthcate Solutions                                                                                                                                                 
-- 30/05/2018 Pabitra New Vital Design             

*********************************************************************************/  
AS  
BEGIN  
 BEGIN TRY 
 
EXEC SCSP_GetClientVitals @ClientId,@HealthDataTemplateId,@StartDate,@EndDate 
  
  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_GetClientVitals.sql') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.                    
    16  
    ,-- Severity.                    
    1 -- State.                    
    );  
 END CATCH  
  
END  