IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetPatientMarritalStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetPatientMarritalStatus]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
         
CREATE  PROCEDURE [dbo].[ssp_GetPatientMarritalStatus] 
(
 @ClientId INT,    
 @DocumentId INT ,    
 @EffectiveDate DATETIME       
)         
/*********************************************************************************/          
-- Copyright: Streamline Healthcate Solutions          
--          
--          
-- Author:  Swatika           
-- Date:    17 DEC 2018             
-- Purpose: Created SP to fetch client Marrital Status  
          
/*********************************************************************************/          

AS          
BEGIN     
     BEGIN TRY        
   DECLARE @Result VARCHAR(20)=''      
   
    
   SELECT  @Result=(SELECT  dbo.csf_GetGlobalCodeNameById(MaritalStatus)  
     from Clients where ClientId=@ClientId)
            
      SELECT CASE @Result when '' THEN '<span style=''color:black''><b> &nbsp;&nbsp;No Data Found</b></span>' ELSE  '<span style=''color:black''>&nbsp;&nbsp;'+@Result+ '</span>'  END               
       END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetPatientMarritalStatus') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
              
END     