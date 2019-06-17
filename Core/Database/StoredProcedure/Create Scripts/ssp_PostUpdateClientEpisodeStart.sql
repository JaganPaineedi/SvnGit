
/****** Object:  StoredProcedure [dbo].[ssp_PostUpdateClientEpisodeStart]    Script Date: 07/25/2018 13:28:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PostUpdateClientEpisodeStart]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PostUpdateClientEpisodeStart]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PostUpdateClientEpisodeStart]    Script Date: 07/25/2018 13:28:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
    
     
CREATE PROCEDURE [dbo].[ssp_PostUpdateClientEpisodeStart] (      
   @ScreenKeyId INT      
  ,@StaffId INT      
  ,@CurrentUser VARCHAR(30)      
  ,@CustomParameters XML      
 )      
AS  
 /* **************************************************************************  */      
/* Stored Procedure: [ssp_PostUpdateClientEpisodeStart]						    */      
/* Creation Date:  08/30/2018													*/    
/* Author: Vijay																*/      
/* Called By: Client Information(C) - Episode Start page						*/      
/* Updates:																		*/         
/* 07/25/2018 Vijay   Why:This ssp is for calling custom and Que ssp's
					  What:Engineering Improvement Initiatives- NBL(I)-Task#590 */    
/* ****************************************************************************	*/   
     
BEGIN      
 BEGIN TRY  

   IF EXISTS (SELECT 1 FROM   sys.objects 
                   WHERE  object_id = 
                   Object_id(N'[dbo].[scsp_PostUpdateClientEpisodeStart]') 
                   AND type IN ( N'P', N'PC' ))
   BEGIN
	exec scsp_PostUpdateClientEpisodeStart @ScreenKeyId,@StaffId,@CurrentUser,@CustomParameters
   END
   
	EXEC ssp_QueOnEpisodeStartEvent @ScreenKeyId 
         
    
 END TRY      
      
 BEGIN CATCH      
  DECLARE @Error VARCHAR(8000)      
      
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****'    
   + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_PostUpdateClientEpisodeStart')     
   + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())      
      
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


