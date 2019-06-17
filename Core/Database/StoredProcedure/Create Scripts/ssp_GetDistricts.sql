 IF object_id('ssp_GetDistricts', 'P') IS NOT NULL
	DROP PROCEDURE dbo.ssp_GetDistricts
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
 CREATE PROCEDURE [dbo].[ssp_GetDistricts] 
AS  
-- =============================================  
-- Author:  Abhishek S  
-- Create date: 29/04/2018  
-- Description: To get all Districts.PEP-Customization: 10005.  
--Modified By   Date          Reason    
-- =============================================  
BEGIN TRY  
---------SchoolDistricts              
Select SchoolDistrictId  
,DistrictName  
From SchoolDistricts WHERE
 ISNULL(RecordDeleted,'N')='N' ORDER BY DistrictName
  
  
END TRY    
BEGIN CATCH  
 DECLARE @Error VARCHAR(8000)  
  
 SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetDistrictName') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
 RAISERROR (  
   @Error  
   ,-- Message text.                                      
   16  
   ,-- Severity.                                      
   1 -- State.                                      
   );  
END CATCH  