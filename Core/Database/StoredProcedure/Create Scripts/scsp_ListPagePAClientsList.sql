IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_ListPagePAClientsList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_ListPagePAClientsList]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 Create procedure [dbo].[scsp_ListPagePAClientsList]  @SortExpression VARCHAR(100)  
 ,@OtherFilter INT  
 ,@ProviderId INT  
 ,@TreamentId INT                                                                                    
                                                                   
/********************************************************************************                                                                                
-- Stored Procedure: dbo.scsp_ListPagePAClientsList                                                                                  
--                                                                                
-- Copyright: Streamline Healthcate Solutions                                                                                
--                                                                                
-- Purpose: Customization support for PA Clients list page depending on the custom filter selection                                                                          
--                                                                                
-- Updates:                                                                                                                                       
-- Date			Author   Purpose       
--30 Aug 16016 Vithobha  CREATED for AspenPointe-Environment Issues: #45       
       
*********************************************************************************/                                                                                
AS                                                                                
BEGIN                                           
BEGIN TRY    
 
 select null    
              
END TRY                                   
BEGIN CATCH                                              
                                            
DECLARE @Error varchar(8000)                                                                                           
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())           
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'scsp_ListPagePAClientsList')                                                                                                                         
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


