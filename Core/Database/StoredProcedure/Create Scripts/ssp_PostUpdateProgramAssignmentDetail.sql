
/****** Object:  StoredProcedure [dbo].[ssp_PostUpdateProgramAssignmentDetail]    Script Date: 07/25/2018 13:28:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PostUpdateProgramAssignmentDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PostUpdateProgramAssignmentDetail]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PostUpdateProgramAssignmentDetail]    Script Date: 07/25/2018 13:28:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
    
     
CREATE PROCEDURE [dbo].[ssp_PostUpdateProgramAssignmentDetail] (      
   @ScreenKeyId INT      
  ,@StaffId INT      
  ,@CurrentUser VARCHAR(30)      
  ,@CustomParameters XML      
 )      
AS  
 /* **************************************************************************  */      
/* Stored Procedure: [ssp_PostUpdateProgramAssignmentDetail]					*/      
/* Creation Date:  07/25/2018													*/    
/* Author: Vijay																*/      
/* Called By: Program Assignment Details page									*/      
/* Updates:																		*/         
/* 07/25/2018 Vijay   Why:This ssp is for calling Que ssp's 
					  What:Engineering Improvement Initiatives- NBL(I)-Task#590 */    
/* ****************************************************************************	*/   
     
BEGIN      
 BEGIN TRY  

   DECLARE @ClientStatus int  
   DECLARE @ClientID int 
   Select @ClientStatus = [Status], @ClientID = ClientId  from ClientPrograms where ClientProgramId = @ScreenKeyId 
   
   IF EXISTS (SELECT 1 FROM   sys.objects 
                   WHERE  object_id = 
                   Object_id(N'[dbo].[scsp_PostUpdateProgramAssignmentDetail]') 
                   AND type IN ( N'P', N'PC' ))
   BEGIN
	exec scsp_PostUpdateProgramAssignmentDetail @ScreenKeyId,@StaffId,@CurrentUser,@CustomParameters
   END
   
   
   IF (@ClientStatus = 1) --Requested
   BEGIN
	EXEC ssp_QueOnProgramRequestedEvent @ScreenKeyId 
   END
   ELSE IF(@ClientStatus = 4) --Enrolled
   BEGIN
    EXEC ssp_QueOnProgramEnrollmentEvent @ScreenKeyId 
   END
   ELSE IF(@ClientStatus = 5) --Discharged
   BEGIN
    EXEC ssp_QueOnProgramDischargeEvent @ScreenKeyId 
   END
    
    
 END TRY      
      
 BEGIN CATCH      
  DECLARE @Error VARCHAR(8000)      
      
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****'    
   + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_PostUpdateProgramAssignmentDetail')     
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


