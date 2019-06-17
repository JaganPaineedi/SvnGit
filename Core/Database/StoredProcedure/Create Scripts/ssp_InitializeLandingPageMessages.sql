 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitializeLandingPageMessages]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitializeLandingPageMessages]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[ssp_InitializeLandingPageMessages] (                
 @StaffID INT ,          
 @clientId int,          
 @CustomParameters XML               
 )                
AS                
-- =============================================================                
-- Author      : Pavani                
-- Date        : 01/08/2016                 
-- Purpose     : Initializing SP Created for LandingPageMessages.
--              Task Engineering Improvement Initiatives- NBL(I)#391                 
-- =============================================================                
BEGIN                
 BEGIN TRY        
                
 SELECT 'LandingPageMessages' AS TableName                
  ,-1 AS LandingPageMessageId                
  ,'' AS CreatedBy                
  ,GETDATE() AS CreatedDate                
  ,'' AS ModifiedBy                
  ,GETDATE() AS ModifiedDate                
  ,LPM.RecordDeleted                
  ,LPM.DeletedDate                
  ,LPM.DeletedBy        
  ,LPM.Message                
  ,'<div> <p style="text-align:center"><strong>SmartCare Disruption Notice</strong></p>  <p><strong>Description</strong>: Planned updates resulting in SmartCare being unavailable during the scheduled maintenance window.</p>  <p><strong>Start Time: Saturday July&nbsp;30th, 2016 @ 21:00 CST</strong></p>  <p><strong><strong>Outage Duration</strong>: &nbsp;21:00 CST - 23.45 CST</strong></p>  <p><strong>Thank you,</strong></p>  <p><strong>BRT</strong>&nbsp;</p> </div> ' as Description      
  ,LPM.Active      
  ,LPM.StartDate      
  ,LPM.EndDate                
  from systemconfigurations s left outer join [LandingPageMessages] LPM       
on s.Databaseversion = -1              
 END TRY                
                
 BEGIN CATCH    
  DECLARE @Error varchar(8000)                                                           
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                         
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_InitializeLandingPageMessages')                                                                                         
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