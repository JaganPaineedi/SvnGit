/****** Object:  StoredProcedure [dbo].[ssp_GetClientServiceAreas]    Script Date: 06/02/2015 13:54:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientServiceAreas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetClientServiceAreas]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetClientServiceAreas]    Script Date: 06/02/2015 13:54:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetClientServiceAreas] @ClientID BIGINT
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Jun 02, 2015     
-- Description: Get the ServiceAreas for the Client   
/*      
 Author			Modified Date			Reason      
   
      
*/
-- =============================================      
BEGIN
	BEGIN TRY
		 ;     
            WITH    ServiceAreaList ( ServiceAreaId, ServiceAreaName )  
                      AS ( SELECT   SA.ServiceAreaId ,  
                                    SA.ServiceAreaName  
                           FROM     ClientCoveragePlans CCP  
                                    JOIN CoveragePlanServiceAreas CPS ON CPS.CoveragePlanId = CCP.CoveragePlanId  
                                                                         AND ISNULL(CPS.RecordDeleted, 'N') = 'N'  
                                    JOIN ServiceAreas SA ON SA.ServiceAreaId = CPS.ServiceAreaId  
                                                            AND ISNULL(SA.RecordDeleted, 'N') = 'N'  
                                    JOIN dbo.ClientCoverageHistory cch ON cch.ClientCoveragePlanId = CCP.ClientCoveragePlanId  
                                                                          AND cch.ServiceAreaId = SA.ServiceAreaId  
                                                                          AND ISNULL(cch.RecordDeleted, 'N') = 'N'  
                           WHERE    CCP.ClientId = @ClientID  
                                    AND ISNULL(CCP.RecordDeleted, 'N') = 'N'  
                         )  
                SELECT DISTINCT  
                        ServiceAreaId ,  
                        serviceareaname  
                FROM    ServiceAreaList  
                ORDER BY ServiceAreaName    
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetClientServiceAreas') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);
	END CATCH
END

GO


