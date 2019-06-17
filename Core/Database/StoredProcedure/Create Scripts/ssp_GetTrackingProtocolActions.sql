/****** Object:  StoredProcedure [dbo].[ssp_GetTrackingProtocolActions]    Script Date: 02/01/2018 16:59:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetTrackingProtocolActions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetTrackingProtocolActions]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetTrackingProtocolActions]    Script Date: 02/01/2018 16:59:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  Procedure [dbo].[ssp_GetTrackingProtocolActions]
(@actionToSearch VARCHAR(Max) )            
As  
/********************************************************************************    
-- Stored Procedure: dbo.[ssp_GetTrackingProtocolActions]
-- Copyright: Streamline Healthcate Solutions 
--    
-- Created:           
-- Date			Author		Purpose 
  05-02-2018    Vijay		Why:This ssp is for searchable action textbox
							What:Engineering Improvement Initiatives- NBL(I) - Task#590
*********************************************************************************/         
 BEGIN   
 BEGIN TRY   
  
  IF (@actionToSearch <> '')  
  BEGIN  
   SELECT ActionId
   ,[Action]
   FROM SystemActions   
   WHERE [Action] LIKE ('%' + @actionToSearch + '%') 
   AND ISNULL(RecordDeleted, 'N') = 'N'
   ORDER BY [Action] 
  END  
	
--Checking For Errors            
END TRY                                                                            
BEGIN CATCH                                
DECLARE @Error varchar(8000)                                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetTrackingProtocolActions')                                                                                                           
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


