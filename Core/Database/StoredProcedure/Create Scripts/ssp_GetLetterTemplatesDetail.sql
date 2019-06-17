
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetLetterTemplatesDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetLetterTemplatesDetail]
GO

/* Object:  StoredProcedure [dbo].[ssp_GetLetterTemplatesDetail]   Script Date: 09/Feb/2016 */
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO               
CREATE PROCEDURE [dbo].[ssp_GetLetterTemplatesDetail]  -- exec [ssp_GetLetterTemplatesDetail] @LetterTemplateId=30

 @LetterTemplateId int
 /********************************************************************************                                                  
-- Stored Procedure: dbo.ssp_GetLetterTemplatesDetail                                                 
--                                                  
-- Copyright: Streamline Healthcate Solutions                                                  
--                                                  
-- Purpose: used by LetterTemplates list page    
-- Called by: ssp_GetLetterTemplatesDetail  
--              
-- Updates:                                                                                                         
-- Date        Author          Purpose                                                  
-- 12.30.2016  Vijeta s         Created.           
*********************************************************************************/  
AS
Begin
Begin Try


SELECT
    LetterTemplateId,
	TemplateName,
	LetterCategory,
	LetterTemplate,
	RowIdentifier,
	CreatedBy,
	CreatedDate,
	ModifiedBy,
	ModifiedDate,
	RecordDeleted,
	DeletedDate,
	DeletedBy 
FROM    
 LetterTemplates  
WHERE ISNULL(RecordDeleted, 'N') <> 'Y'  
AND LetterTemplateId = @LetterTemplateId  
END TRY 

BEGIN CATCH
DECLARE @Error varchar(8000)                                                                            
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                         
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetLetterTemplatesDetail')                                                                                                             
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