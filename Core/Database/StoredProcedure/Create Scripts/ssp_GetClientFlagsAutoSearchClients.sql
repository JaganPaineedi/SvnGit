/****** Object:  StoredProcedure [dbo].[ssp_GetClientFlagsAutoSearchClients]    Script Date: 02/01/2018 16:59:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientFlagsAutoSearchClients]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetClientFlagsAutoSearchClients]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetClientFlagsAutoSearchClients]    Script Date: 02/01/2018 16:59:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  Procedure [dbo].[ssp_GetClientFlagsAutoSearchClients]
(@clientToSearch VARCHAR(Max) )            
As 
/********************************************************************************    
-- Stored Procedure: dbo.[ssp_GetClientFlagsAutoSearchClients]      
--  
-- Copyright: Streamline Healthcate Solutions 
--    
-- Created:           
-- Date			Author		Purpose 
  26-04-2018    Vijay		Why:This ssp is for searchable textbox based on ClientId and name
							What:Engineering Improvement Initiatives- NBL(I) - Task#590
*********************************************************************************/         
BEGIN   
 BEGIN TRY   
 
  IF (@clientToSearch <> '')  
  BEGIN  
   SELECT DISTINCT C.ClientId
   ,C.LastName +', '+ C.FirstName + ' ('+Convert(varchar,C.ClientId)+')' AS ClientName
   FROM Clients C
   WHERE (C.ClientId LIKE ('%' + @clientToSearch + '%') 
   OR C.LastName LIKE ('%' + @clientToSearch + '%') 
   OR C.FirstName LIKE ('%' + @clientToSearch + '%') )
   AND ISNULL(C.RecordDeleted, 'N') = 'N'
   ORDER BY ClientName
  END  	
	
--Checking For Errors            
END TRY                                                                            
BEGIN CATCH                                
DECLARE @Error varchar(8000)                                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetClientFlagsAutoSearchClients')                                                                                                           
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                            
    + '*****' + Convert(varchar,ERROR_STATE())                                                        
 RAISERROR                                                                                                           
 (                                                                             
  @Error, -- Message text.                                                                                                          
  16, -- Severity.                                                                                                          
  1 -- State.                                                                                                          
 );                                                                                                        
END CATCH                                                       
END   

GO


