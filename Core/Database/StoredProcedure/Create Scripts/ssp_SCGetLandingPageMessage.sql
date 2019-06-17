IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetLandingPageMessage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetLandingPageMessage]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetLandingPageMessage] @StaffId AS INT  
AS  
/************************************************************************/  
/* Stored Procedure: ssp_SCGeLandingPageMessage      */  
/* Creation Date:  24 Dec 2014           */  
/* Purpose: Gets Landing Page Message     */  
/* Input Parameters: StaffId         */  
/* Output Parameters:             */  
/* Author: Chethan N                                        
/*   Updates:                                                          */                                                                                 
/*       Date              Author                  Purpose            */    
         1/08/2016         Pavani           TO get top 1 Landing Page Message
                                            Engineering Improvement Initiatives- NBL(I)#391    
 */  
/************************************************************************/  
BEGIN  
 SELECT TOP 1 LPM.Description  
  ,LPM.LandingPageMessageId  
  ,LPM.Message  
  ,SMA.ModifiedDate  
  ,LPM.ModifiedBy  
 FROM LandingPageMessages LPM  
 LEFT JOIN StaffMessageAcknowledgements SMA ON SMA.LandingPageMessageId = LPM.LandingPageMessageId  
  AND ISNULL(SMA.RecordDeleted, 'N') = 'N'  
  AND SMA.StaffId = @StaffId  
 INNER JOIN Staff S ON S.StaffId = @StaffId  
 WHERE (  
   SMA.LandingPageMessageId IS NULL  
   OR CAST(ISNULL(SMA.ModifiedDate, '1900-01-01') AS DATETIME) < CAST(LPM.ModifiedDate AS DATETIME)  
   )  
  AND (  
   (  
    LPM.StartDate IS NULL  
    OR LPM.StartDate <= GETDATE()  
    )  
   AND (  
    LPM.EndDate IS NULL  
    OR LPM.EndDate >= GETDATE()  
    )  
   )  
  AND ISNULL(S.NonStaffUser, 'N') = ISNULL(LPM.Active, 'N')  
  AND ISNULL(LPM.RecordDeleted, 'N') = 'N'  
 ORDER BY LPM.LandingPageMessageId DESC  
  
 IF (@@error != 0)  
 BEGIN  

   DECLARE @Error varchar(8000)                                                           
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                         
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetLandingPageMessage')                                                                                         
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