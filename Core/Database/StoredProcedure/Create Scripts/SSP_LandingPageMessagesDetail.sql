 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_LandingPageMessagesDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_LandingPageMessagesDetail]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 CREATE Procedure [dbo].[SSP_LandingPageMessagesDetail]    
/********************************************************************************                                                            
-- Stored Procedure: SSP_LandingPageMessagesDetail          
--          
-- Copyright: Streamline Healthcate Solutions          
--          
-- Purpose: To display Messages In DitailPage        
--          
-- Author:  Vamsi          
-- Date:    Dec 08 2014          
--           
-- *****History****          
-- Author:    Date   Reason          
-- Vamsi   Dec 08 2014   Crated for Macon County - Design# 50.1 
-- Pavani   01/08/2016   Added StartDate,EndDate
                         Task Engineering Improvement Initiatives- NBL(I)#391 
*********************************************************************************/     
@LandingPageMessageId INT      
AS      
BEGIN      
  BEGIN TRY      
    SELECT  LandingPageMessageId       
     , CreatedBy       
     , CreatedDate       
     , ModifiedBy       
     , ModifiedDate       
     , RecordDeleted       
     , DeletedBy       
     , DeletedDate       
     , Message    
     , Description    
     , Active    
     -- Pavani   01/08/2016
     ,StartDate            
     ,EndDate  
    FROM  LandingPageMessages       
    WHERE LandingPageMessageId=@LandingPageMessageId and  isnull(RecordDeleted, 'N') = 'N'      
  END TRY      
  BEGIN CATCH              
  DECLARE @Error varchar(8000)                                                             
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                           
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'SSP_LandingPageMessagesDetail')                                                                                           
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