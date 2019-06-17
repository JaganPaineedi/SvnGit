
/****** Object:  StoredProcedure [dbo].[ssp_ReportCheckInsurerId]    Script Date: 09/06/2016 17:06:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ReportCheckInsurerId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ReportCheckInsurerId]
GO


/****** Object:  StoredProcedure [dbo].[ssp_ReportCheckInsurerId]    Script Date: 09/06/2016 17:06:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_ReportCheckInsurerId]  
   
/****************************************  
Name:  csp_ReportCheckInsurerId  
Purpose: to gather Insurer specific Id if needed for DW Reporting  
Created: APR-09-2014  
Created By: dharvey  
  
MODIFICATIONS:  
  
 Date  User   Description  
 ------  ----------  ------------------------  
   
****************************************/  
AS  
BEGIN
	BEGIN TRY 
	
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'SystemConfigurations')  
 BEGIN  
  SELECT CareManagementInsurerId AS InsurerId, CareManagementInsurerName InsurerName  
  FROM dbo.SystemConfigurations  
  GROUP BY CareManagementInsurerId, CareManagementInsurerName  
 END  
ELSE  
 BEGIN  
  SELECT NULL AS InsurerId, 'All' AS InsurerName  
 END  
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_ReportCheckInsurerId') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

