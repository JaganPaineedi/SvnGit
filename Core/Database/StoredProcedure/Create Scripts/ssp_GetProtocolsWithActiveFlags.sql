/****** Object:  StoredProcedure [dbo].[ssp_GetProtocolsWithActiveFlags]    Script Date: 02/01/2018 16:59:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetProtocolsWithActiveFlags]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetProtocolsWithActiveFlags]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetProtocolsWithActiveFlags]    Script Date: 02/01/2018 16:59:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  Procedure [dbo].[ssp_GetProtocolsWithActiveFlags]
(@ClientId INT
 )   
As  
/********************************************************************************    
-- Stored Procedure: dbo.[ssp_GetProtocolsWithActiveFlags]
-- Copyright: Streamline Healthcate Solutions 
--    
-- Created:           
-- Date			Author		Purpose 
  01-02-2018    Vijay		Why:This ssp is for loading all Active Flag Protocols
							What:Engineering Improvement Initiatives- NBL(I) - Task#590
*********************************************************************************/         
 BEGIN   
 BEGIN TRY   
 
  SELECT TP.TrackingProtocolId,
   TP.ProtocolName 
   FROM TrackingProtocols TP
   LEFT JOIN ClientNotes CN ON CN.TrackingProtocolId = TP.TrackingProtocolId AND ISNULL(CN.RecordDeleted, 'N') = 'N'
   WHERE CN.ClientId = @ClientId
	   AND TP.Active='Y'
	   AND EXISTS(Select 1 From TrackingProtocolFlags TPF Where TPF.TrackingProtocolId = TP.TrackingProtocolId AND TPF.Active = 'Y' 
				  AND ISNULL(TPF.RecordDeleted, 'N') = 'N')
	   AND ISNULL(TP.RecordDeleted, 'N') = 'N'	   	    
	   Group By  TP.TrackingProtocolId, TP.ProtocolName
	   ORDER BY TP.ProtocolName
    
--Checking For Errors            
END TRY                                                                            
BEGIN CATCH                                
DECLARE @Error varchar(8000)                                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetProtocolsWithActiveFlags')                                                                                                           
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
