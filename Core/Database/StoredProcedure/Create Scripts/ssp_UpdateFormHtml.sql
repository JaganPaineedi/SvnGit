  
IF EXISTS ( SELECT * 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[ssp_UpdateFormHtml]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
    DROP PROCEDURE [dbo].[ssp_UpdateFormHtml]
END
Go   
/*********************************************************************/                
/* Stored Procedure: dbo.ssp_UpdateFormHtml    --1629         */                
/* Copyright:             */                
/* Creation Date:  12-06-2017                                  */                
/*                                                                   */                
/* Purpose: Same the report data in the table   */               
/*                                                                   */              
/* Input Parameters:       */              
/*                                                                   */                
/* Output Parameters:                                */                
/*                                                                   */                
/* Return: */                
/*                                                                   */                
/* Called By:                                                        */                
/*                                                                   */                
/* Calls:                                                            */                
/*                                                                   */                
/* Data Modifications:                                               */                
/*                                                                   */                
/* Updates:                                                          */                
/*  Date          Author      Purpose                                    */                
/* 06/12/2017   Rajesh S      Created                                    */                
/*********************************************************************/      
CREATE PROCEDURE dbo.ssp_UpdateFormHtml  
@FormId INT  
,@FormHTML VARCHAR(MAX)  
AS  
BEGIN  
BEGIN TRY  
 UPDATE FORMS SET FORMHTML = @FormHTML WHERE FormID = @FormId  
END TRY  
BEGIN CATCH  
DECLARE @Error VARCHAR(8000)                                                                           
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                     
     + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_UpdateFormHtml')                                                                                                         
     + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                          
     + '*****' + CONVERT(VARCHAR,ERROR_STATE())                                                      
  RAISERROR                                                                                                         
  (                                                                           
   @Error,                                                                                                         
   16, -                                                                                                        
   1                                                                                                      
  );  
END CATCH  
    
   
END