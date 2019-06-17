IF EXISTS ( SELECT * 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[ssp_SaveDFAReportHtml]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
    DROP PROCEDURE [dbo].[ssp_SaveDFAReportHtml]
END
Go  
CREATE PROCEDURE dbo.ssp_SaveDFAReportHtml        
@DocumentVersionId INT        
,@DFAReportHTML VARCHAR(MAX)        
    
AS      
/*********************************************************************/                
/* Stored Procedure: dbo.ssp_SaveDFAReportHtml    --1629         */                
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
BEGIN        
BEGIN TRY        
        
 IF NOT EXISTS(SELECT 1 FROM DocumentRDLHTMLs  WHERE DocumentVersionId = @DocumentVersionId)        
 BEGIN        
    
   INSERT INTO DocumentRDLHTMLs  (DocumentVersionId,DocumentRDLHTML)        
  VALUES(@DocumentVersionId,@DFAReportHTML)         
 END        
 ELSE        
 BEGIN        
  UPDATE DocumentRDLHTMLs  SET  DocumentRDLHTML = @DFAReportHTML WHERE DocumentVersionId = @DocumentVersionId        
 END        
         
END TRY        
BEGIN CATCH        
 DECLARE @Error VARCHAR(8000)                                                                                 
   SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                           
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_SaveDFAReportHtml')                                                                                                               
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