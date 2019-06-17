/****** Object:  StoredProcedure [dbo].[ssp_GetTrackingProtocolFlagsById]    Script Date: 02/01/2018 16:59:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetTrackingProtocolFlagsById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetTrackingProtocolFlagsById]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetTrackingProtocolFlagsById]    Script Date: 02/01/2018 16:59:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  Procedure [dbo].[ssp_GetTrackingProtocolFlagsById] 
(@ClientNoteId INT)
As   
/********************************************************************************    
-- Stored Procedure: dbo.[ssp_GetTrackingProtocolFlagsById]   
-- Copyright: Streamline Healthcare Solutions 
--    
-- Created:           
-- Date			Author		Purpose 
  09-02-2018    Vijay		What:This ssp is to get CanBeCompletedNoSoonerThan filed value for validation purpose
							Why:Engineering Improvement Initiatives- NBL(I) - Task#590
*********************************************************************************/         
BEGIN   
 BEGIN TRY  
	DECLARE @Output INT
	DECLARE @DueDate DATETIME
	DECLARE @CanBeCompletedNoSoonerThan INT
	SET @CanBeCompletedNoSoonerThan = 0
	SET @Output = 0  
	     
   SELECT  @DueDate = CN.DueDate,
		   @CanBeCompletedNoSoonerThan = TPF.CanBeCompletedNoSoonerThan
		   From ClientNotes CN 
		   JOIN TrackingProtocolFlags TPF ON TPF.TrackingProtocolFlagId=CN.TrackingProtocolFlagId
		   WHERE CN.ClientNoteId=@ClientNoteId 
			AND ISNULL(CN.RecordDeleted, 'N') = 'N'
			AND ISNULL(TPF.RecordDeleted, 'N') = 'N'
   
   IF DATEADD(d, -@CanBeCompletedNoSoonerThan, @DueDate) <= GETDATE() 
	BEGIN
		SET @Output = 0
	END
	ELSE
	BEGIN
		SET @Output = @CanBeCompletedNoSoonerThan
	END 
	
	SELECT @Output
	
--Checking For Errors            
END TRY                                                                            
BEGIN CATCH                                
DECLARE @Error varchar(8000)                                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetTrackingProtocolFlagsById')                                                                                                           
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


