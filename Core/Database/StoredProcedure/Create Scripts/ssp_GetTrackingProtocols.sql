/****** Object:  StoredProcedure [dbo].[ssp_GetTrackingProtocols]    Script Date: 02/01/2018 16:59:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetTrackingProtocols]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetTrackingProtocols]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetTrackingProtocols]    Script Date: 02/01/2018 16:59:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  Procedure [dbo].[ssp_GetTrackingProtocols]
(@ClientId INT,
@ProtocolName VARCHAR(Max)
 )   
As  
/********************************************************************************    
-- Stored Procedure: dbo.[ssp_GetTrackingProtocols]
-- Copyright: Streamline Healthcate Solutions 
--    
-- Created:           
-- Date			Author		Purpose 
  01-02-2018    Vijay		Why:This ssp is for loading all protocols in a dropdown\searchable textbox
							What:Engineering Improvement Initiatives- NBL(I) - Task#590
*********************************************************************************/         
 BEGIN   
 BEGIN TRY   
 
  IF(@ClientId <> -1 AND ISNULL(@ProtocolName, '') = '')  
  BEGIN
	  SELECT DISTINCT TP.TrackingProtocolId,
	   TP.ProtocolName 
	   FROM TrackingProtocols TP
	   LEFT JOIN ClientNotes CN ON CN.TrackingProtocolId = TP.TrackingProtocolId --AND ISNULL(CN.RecordDeleted, 'N') = 'N'
	   WHERE CN.ClientId = @ClientId
	   --AND TP.Active='Y'
	   --AND ISNULL(TP.RecordDeleted, 'N') = 'N'
	   ORDER BY ProtocolName  
  END
  ELSE IF (@ClientId = 0 AND ISNULL(@ProtocolName, '') <> '')  
  BEGIN  
	   SELECT DISTINCT TP.TrackingProtocolId
	   ,TP.ProtocolName 
	   FROM TrackingProtocols TP
	   LEFT JOIN ClientNotes CN ON CN.TrackingProtocolId = TP.TrackingProtocolId AND ISNULL(CN.RecordDeleted, 'N') = 'N'
	   WHERE TP.ProtocolName LIKE ('%' + @ProtocolName + '%') 
	   --AND CN.ClientId = @ClientId
	   AND TP.Active ='Y'
	   AND ISNULL(TP.RecordDeleted, 'N') = 'N'
	   ORDER BY TP.ProtocolName  
  END 
  ELSE IF(@ClientId = -1 AND ISNULL(@ProtocolName, '') = '')
  BEGIN
	   SELECT TrackingProtocolId,
	   ProtocolName 
	   FROM TrackingProtocols
	   WHERE ISNULL(RecordDeleted, 'N') = 'N'
	   AND Active='Y'
	   ORDER BY ProtocolName  
  END  
  ELSE IF(@ClientId = -1 AND ISNULL(@ProtocolName, '') <> '')
  BEGIN
	   SELECT TrackingProtocolId,
	   ProtocolName 
	   FROM TrackingProtocols TP
	   LEFT JOIN GlobalCodes GC on GC.GlobalCodeId = TP.CreateProtocol AND GC.Category = 'CREATEPROTOCOL' AND GC.Code='Manually'
	   WHERE TP.ProtocolName LIKE ('%' + @ProtocolName + '%')
	   AND ISNULL(TP.RecordDeleted, 'N') = 'N'
	   AND TP.Active='Y'
	   ORDER BY TP.ProtocolName  
  END
  
--Checking For Errors            
END TRY                                                                            
BEGIN CATCH                                
DECLARE @Error varchar(8000)                                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetTrackingProtocols')                                                                                                           
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


