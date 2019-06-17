 /****** Object:  StoredProcedure [dbo].[ssp_ValidateLetterTemplates]    Script Date: 01/03/2016 17:54:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ValidateLetterTemplates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ValidateLetterTemplates]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ValidateLetterTemplates]    Script Date: 01/03/2016 17:54:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 
          
CREATE procedure [dbo].[ssp_ValidateLetterTemplates]                                                                                                                                                                                              
@CurrentUsreId INT ,  
@ScreenKeyId INT  
 /******************************************************************************                                                      
**  File: [ssp_ValidateLetterTemplates]                                                  
**  Name: [ssp_ValidateLetterTemplates]                              
**  Desc: For Validation on Letter Templates with same name                 
**  Return values: Resultset having validation messages                                                      
**  Called by:                                                       
**  Parameters:                                  
**  Auth:  Vijeta Sinha                                    
**  Date:  01/03/2017                                                
*******************************************************************************                                                      
**  Change History                                                      
*******************************************************************************                                                      
**  Date:       Author:       Description:                                    
**  1/3/2017  Vijeta Sinha    Add logic to for checking against the same          
**         "Template Name" in table                  
*******************************************************************************/     
AS  
    BEGIN  
  
        BEGIN TRY  
   
 --*TABLE CREATE*--  
            DECLARE @CustomFieldsData TABLE  
                (  
                  LetterTemplateId INT ,  
                  TemplateName VARCHAR(200) ,  
                  LetterCategory INT ,  
                  LetterTemplate VARCHAR(max)   
                )  
   
 --*INSERT LIST*--  
            INSERT  INTO @CustomFieldsData  
                    ( LetterTemplateId ,  
                      TemplateName ,  
                      LetterCategory ,  
                      LetterTemplate 
                 )  
 --*SELECT LIST*--  
                    SELECT  l.LetterTemplateId ,  
                            l.TemplateName ,  
                            l.LetterCategory ,  
                            l.LetterTemplate   
                    FROM    LetterTemplates l 
                    WHERE   l.LetterTemplateId = @ScreenKeyId  
                            AND ISNULL(l.RecordDeleted, 'N') = 'N'  
            DECLARE @validationReturnTable TABLE  
                (  
                  TableName VARCHAR(200) ,  
                  ColumnName VARCHAR(200) ,  
                  ErrorMessage VARCHAR(1000)  
                )             
   
            INSERT  INTO @validationReturnTable  
                    ( TableName ,  
                      ColumnName ,  
                      ErrorMessage                
                 )  
                    SELECT DISTINCT  'LetterTemplates' ,  
                            'TemplateName' ,  
                            'Another Letter Template with same name already exists'  
                    FROM    @CustomFieldsData cfd  
                              JOIN LetterTemplates lt ON lt.TemplateName = cfd.TemplateName  AND cfd.LetterCategory = lt.LetterCategory 
                                                           AND ISNULL(lt.RecordDeleted, 'N') = 'N' AND  lt.LetterTemplateId <> @ScreenKeyId 
                    
                           
                              
            SELECT  TableName ,  
                    ColumnName ,  
                    ErrorMessage  
            FROM    @validationReturnTable  
   
            IF EXISTS ( SELECT  *  
                        FROM    @validationReturnTable )  
                BEGIN           
                    SELECT  1 AS ValidationStatus          
                END          
            ELSE  
                BEGIN          
                    SELECT  0 AS ValidationStatus          
                END  
   
        END TRY  
   
        BEGIN CATCH  
   
            DECLARE @Error VARCHAR(8000)                                                               
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), '[ssp_ValidateLetterTemplates]') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' +
             CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
            RAISERROR                                                                                             
   (                                                               
    @Error, -- Message text.                                                                                            
    16, -- Severity.                                                                                            
    1 -- State.                                                                                            
   );                       
   
        END CATCH  
   
    END  