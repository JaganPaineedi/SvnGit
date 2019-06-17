/****** Object:  StoredProcedure [dbo].[ssp_GetClientType]    Script Date: 08/07/2016  ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetClientType]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetClientType]    Script Date: 08/07/2016 
-- Created:           
-- Date			Author				Purpose 
8-July-2016   Basudev Sahu		Created to get ClientType
*********************************************************************************/  
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
  
CREATE PROCEDURE [dbo].[ssp_GetClientType]   
(    
@ClientId INT   
)   
  
AS                                       
 BEGIN    
   
  BEGIN TRY   
   SELECT ClientType FROM ClientS WHERE ClientId = @ClientId AND ISNULL(RecordDeleted, 'N') = 'N'
       
END TRY  
BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetClientType') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.      
    16  
    ,-- Severity.      
    1 -- State.      
    );  
 END CATCH  
END  
   
   
   
				
		