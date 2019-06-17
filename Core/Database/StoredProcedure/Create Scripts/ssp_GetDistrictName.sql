
/****** Object:  StoredProcedure [dbo].[ssp_GetDistrictName]    Script Date: 06/04/2018 15:42:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetDistrictName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetDistrictName]
GO



/****** Object:  StoredProcedure [dbo].[ssp_GetDistrictName]    Script Date: 06/04/2018 15:42:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_GetDistrictName] (@DistrictName Varchar(250))  
AS  
-- =============================================  
-- Author:  Pradeep Y   
-- Create date: 18/04/2018  
-- Description: To get all previous District.PEP-Customization: 10005.  
--Modified By   Date          Reason    
-- =============================================  
BEGIN TRY  
---------SchoolDistricts              
Select SchoolDistrictId  
,DistrictName  
From SchoolDistricts  
Where DistrictName like ''+@DistrictName+''  
AND ISNULL(RecordDeleted,'N')='N'  
  
  
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
GO


