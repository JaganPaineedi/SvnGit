IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCInsertLandingMessageAcknowledgement]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCInsertLandingMessageAcknowledgement]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SSP_SCInsertLandingMessageAcknowledgement] @StaffId AS INT  
 ,@LandingPageMessageId AS INT  
AS  
/************************************************************************/  
/* Stored Procedure: SSP_SCInsertLandingMessageAcknowledgement      */  
/* Creation Date:  24 Dec 2014           */  
/* Purpose: To Insert the Landing Page Acknowledgement     */  
/* Input Parameters: StaffId         */  
/* Output Parameters:             */  
/* Author: Chethan N                      
/*   Updates:                                                          */                                                               
/*       Date              Author					Purpose            */   */  
/*       01/08/2016        Pavani					Insert/update record based on Messageid and StaffId
													Engineering Improvement Initiatives- NBL(I)#391 */  
/************************************************************************/  
BEGIN  
 IF NOT EXISTS (  
   SELECT *  
   FROM StaffMessageAcknowledgements  
   WHERE StaffId = @StaffId  
    AND LandingPageMessageId = @LandingPageMessageId  
   )  
 BEGIN  
  INSERT INTO StaffMessageAcknowledgements (  
   StaffId  
   ,IsAcknowledged  
   ,LandingPageMessageId  
   ,ModifiedDate  
   )  
  VALUES (  
   @StaffId  
   ,'Y'  
   ,@LandingPageMessageId  
   ,GETDATE()  
   )  
 END  
 ELSE  
 BEGIN  
  UPDATE StaffMessageAcknowledgements  
  SET ModifiedDate = GETDATE()  
  WHERE StaffId = @StaffId  
   AND LandingPageMessageId = @LandingPageMessageId  
 END  
  
 IF (@@error != 0)  
 BEGIN  
   DECLARE @Error varchar(8000)                                                           
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                         
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'SSP_SCInsertLandingMessageAcknowledgement')                                                                                         
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                          
    + '*****' + Convert(varchar,ERROR_STATE())                                      
  RAISERROR                                                                                         
  (                                                           
   @Error, -- Message text.                                                                                        
   16, -- Severity.                                                                                        
   1 -- State.                                                                                        
   );      
  
  RETURN  
 END  
END