
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_CMListPageServiceClaims]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_CMListPageServiceClaims]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  

CREATE PROCEDURE [dbo].[scsp_CMListPageServiceClaims]    
AS  
/********************************************************************************      
-- Stored Procedure: dbo.scsp_CMListPageServiceClaims        
--    
-- Copyright: Streamline Healthcate Solutions   
--      
-- Created:             
-- Date          Author       Purpose   
  06-July-2015  Shruthi.S    Added for other filter.Ref #603 Network 180Customizations.
*********************************************************************************/   
BEGIN  
  BEGIN TRY   
 SELECT - 1 AS ClaimDenialOverrideId   
END TRY  
  BEGIN CATCH  
    DECLARE @error varchar(8000)  
  
    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'  
    + CONVERT(varchar(4000), ERROR_MESSAGE())  
    + '*****'  
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),  
    'scsp_CMListPageServiceClaims')  
    + '*****' + CONVERT(varchar, ERROR_LINE())  
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())  
    + '*****' + CONVERT(varchar, ERROR_STATE())  
  
    RAISERROR (@error,-- Message text.  
    16,-- Severity.  
    1 -- State.  
    );  
  END CATCH  
END   