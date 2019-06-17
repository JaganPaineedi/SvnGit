/****** Object:  StoredProcedure [dbo].[ssp_GetPatientFirstNameOnly]    Script Date: 06/30/2014 18:07:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetPatientFirstNameOnly]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetPatientFirstNameOnly]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetPatientFirstNameOnly]    Script Date: 06/30/2014 18:07:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
     
CREATE  PROCEDURE [dbo].[ssp_GetPatientFirstNameOnly]      
/*********************************************************************************/      
-- Copyright: Streamline Healthcate Solutions      
--      
--      
-- Author:  Vaibhav      
-- Date:    19 Sep 2018         
-- Purpose: Created SP to fetch Patient Name        
     
/*********************************************************************************/      
      
     
 @ClientId INT,  
 @DocumentId INT ,  
 @EffectiveDate DATETIME  
       
AS      
BEGIN 
     BEGIN TRY      
      
    DECLARE @Name VARCHAR (Max)  
 Select @Name  = CASE   
   WHEN ISNULL(ClientType, 'I') = 'I'  
    THEN ISNULL(FirstName, '')   
   ELSE ISNULL(OrganizationName, '')  
   END  
      from Clients where clientId=@ClientId    
     
     SELECT  ISNULL(@Name,'')+''   
      END TRY  
      BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetPatientFirstNameOnly') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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
  
  
  
  
  