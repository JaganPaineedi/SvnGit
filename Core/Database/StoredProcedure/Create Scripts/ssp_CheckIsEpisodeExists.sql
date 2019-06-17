/****** Object:  StoredProcedure [dbo].[ssp_CheckIsEpisodeExists]    Script Date: 06/11/2018 03:53:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CheckIsEpisodeExists]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_CheckIsEpisodeExists]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CheckIsEpisodeExists]   Script Date: 06/11/2018 03:53:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[ssp_CheckIsEpisodeExists]        
           
/********************************************************************************                                                                
-- Stored Procedure: dbo.ssp_CheckIsEpisodeExists                                                                  
--                                                                
-- Copyright: Streamline Healthcate Solutions                                                                
--                                                                
-- Purpose: Used to Check if a client's episode is already exists.                                                        
--                                                                
-- Updates:                                                                                                                       
-- Date    Author   Purpose                                                                
-- 24 Oct 2011  VIKAS KASHYAP Created.                                                                      
*********************************************************************************/                 
@ClientId INT,    
@InquiryId INT                
as                
BEGIN                                                       
 BEGIN TRY  
              
  declare @EpisodeExists char(1)    
  IF EXISTS(    
    SELECT ClientEpisodeId     
    FROM ClientEpisodes CE    
    WHERE ISNULL(CE.RecordDeleted,'N')<>'Y'    
    AND CE.ClientId=@ClientId    
    AND CE.Status!=102    
    AND GETDATE()>CE.RegistrationDate    
   )           
 BEGIN    
  SET @EpisodeExists='Y'    
 END    
  ELSE    
 BEGIN    
      
  SET @EpisodeExists='N'    
     
 END    
     
 SELECT @EpisodeExists    
             
 END TRY                                          
 BEGIN CATCH                                                      
 DECLARE @Error varchar(8000)                                                                        
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                         
 + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_CheckIsEpisodeExists')                                              
 + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                          
 + '*****' + Convert(varchar,ERROR_STATE())                                                                        
                                                                
 RAISERROR                                                                         
 (                                                              
 @Error, -- Message text.                                                                        
 16, -- Severity.                                                                        
 1 -- State.                                                                        
 );                                                         
 End CATCH                                                                                                               
                                               
End     
GO 