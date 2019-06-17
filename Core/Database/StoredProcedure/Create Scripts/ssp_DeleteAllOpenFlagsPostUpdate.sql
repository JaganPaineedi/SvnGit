/****** Object:  StoredProcedure [dbo].[ssp_DeleteAllOpenFlagsPostUpdate]    Script Date: 10/15/2018 18:45:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_DeleteAllOpenFlagsPostUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_DeleteAllOpenFlagsPostUpdate]
GO

/****** Object:  StoredProcedure [dbo].[ssp_DeleteAllOpenFlagsPostUpdate]    Script Date: 10/15/2018 18:45:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_DeleteAllOpenFlagsPostUpdate]
	  @TrackingProtocolId INT ,  
      @TrackingProtocolFlagIds VARCHAR(250),
      @UserCode VARCHAR(250)
AS 
/********************************************************************************                                                    
-- Stored Procedure: ssp_DeleteAllOpenFlagsPostUpdate
-- Copyright: Streamline Healthcate Solutions
-- Purpose: Procedure to Delete Open Flags(ClientNotes table) while deleting Protocol Flag
-- Author:  Vijay
-- Date:    15 Oct 2018
-- *****History****  
-- Date				Author			Purpose
---------------------------------------------------------------------------------
-- 06 Jun 2018		Vijay			What:Created ssp to Delete Open Flags(ClientNotes table)
									Why:Engineering Improvement Initiatives- NBL(I) - Task#590
*********************************************************************************/  

BEGIN  
	BEGIN TRY  
	
	  CREATE TABLE #TrackingProtocolFlagIdList(TrackingProtocolFlagId INT)
	  INSERT INTO #TrackingProtocolFlagIdList(TrackingProtocolFlagId)
	  SELECT Token FROM dbo.SplitString(@TrackingProtocolFlagIds,',')
	  
	  UPDATE C SET C.RecordDeleted='Y',C.Initials='ProtocolFlagDeleted', C.DeletedBy=@UserCode, C.DeletedDate=GETDATE() 
	  FROM ClientNotes C
	  JOIN #TrackingProtocolFlagIdList T ON T.TrackingProtocolFlagId=C.TrackingProtocolFlagId
	  WHERE C.TrackingProtocolId = @TrackingProtocolId AND ISNULL(C.RecordDeleted,'N')= 'N'
				
	END TRY 
    BEGIN CATCH                                
		DECLARE @Error VARCHAR(8000)                                                                          
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                       
					+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_DeleteAllOpenFlagsPostUpdate')                                                                                                           
					+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                            
					+ '*****' + CONVERT(VARCHAR,ERROR_STATE())                                                        
		RAISERROR                                                                                                           
		(                                                                             
			@Error, -- Message text.         
			16, -- Severity.         
			1 -- State.                                                           
		);                                                                                                        
	END CATCH
END
GO


