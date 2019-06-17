/****** Object:  StoredProcedure [dbo].[ssp_SCGetLetterTemplatesColumnsList]    Script Date: 07/05/2016 12:59:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetLetterTemplatesColumnsList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetLetterTemplatesColumnsList]
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCGetLetterTemplatesColumnsList]    Script Date: 07/05/2016 12:59:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_SCGetLetterTemplatesColumnsList]    
AS    
 /********************************************************************************                                                                                                                  
-- Stored Procedure: ssp_SCGetLetterTemplatesColumnsList    
--                                                                                                                  
-- Copyright: Streamline Healthcate Solutions                                                                                                                  
--                                                                                                                  
-- Purpose: To get the list of all TemplateName of LetterTemplates tables in the database.    
-- Parameters:    
-- Input   : -                                                                                                                                                                                                                                    
-- Author:  Vijeta Sinha                                                                                                          
-- Creation Date: September 28,2016    
*********************************************************************************/     
BEGIN    
 BEGIN TRY    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
   
select DISTINCT TemplateName from LetterTemplates where ISNULL(RecordDeleted,'N')='N' order by TemplateName 
  
 END TRY                                        
 BEGIN CATCH                                                    
 DECLARE @Error varchar(8000)                                                                      
    SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetLetterTemplatesColumnsList')                                            
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                        
    + '*****' + Convert(varchar,ERROR_STATE())                                                                      
                                                                     
    RAISERROR                                                                       
    (                                                            
  @Error, -- Message text.                                                                      
  16, -- Severity.                                                                      
  1 -- State.                                                                      
    );                                                       
 End CATCH                                                                                                             
                                                 
    
END 
GO


