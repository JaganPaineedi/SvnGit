/****** Object:  StoredProcedure [dbo].[ssp_GetPatientCity]    Script Date: 06/30/2014 18:07:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetPatientCity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetPatientCity]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetPatientCity]    Script Date: 06/30/2014 18:07:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

       
CREATE  PROCEDURE [dbo].[ssp_GetPatientCity]        
/*********************************************************************************/        
-- Copyright: Streamline Healthcate Solutions        
--        
--        
-- Author:  Swatika        
-- Date:    13 DEC 2018           
-- Purpose: Created SP to fetch patient city  
        
/*********************************************************************************/        
        
       
 @ClientId INT,    
 @DocumentId INT ,    
 @EffectiveDate DATETIME    
         
AS        
BEGIN   
     BEGIN TRY      
			
			DECLARE @Result VARCHAR(20)=''      
  
     Select @Result=ISNULL(City,'')      
     from ClientAddresses where ClientId=@ClientId Order by 1     
            
      SELECT CASE @Result when '' THEN '<span style=''color:black''><b> &nbsp;&nbsp;No City Found</b></span>' ELSE  '<span style=''color:black''>&nbsp;&nbsp;'+@Result+ '</span>'  END               
       END TRY  
     

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetPatientCity') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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
    
    
    