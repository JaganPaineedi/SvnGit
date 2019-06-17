IF EXISTS ( SELECT * 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[ssp_CheckSinglePageDocumentDFA]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
    DROP PROCEDURE [dbo].[ssp_CheckSinglePageDocumentDFA]
END
Go  
CREATE PROCEDURE dbo.ssp_CheckSinglePageDocumentDFA --1629  
@DocumentCodeId INT  
AS  
/*********************************************************************/              
/* Stored Procedure: dbo.ssp_CheckSinglePageDocumentDFA    --1629         */              
/* Copyright:             */              
/* Creation Date:  12-06-2017                                  */              
/*                                                                   */              
/* Purpose:Check if the document is single page DFA          */             
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
/*  Date        	 Author      Purpose                                    */              
/* 06/12/2017   Rajesh S      Created                                    */              
/*********************************************************************/    
BEGIN  
 DECLARE @GenericRDL VARCHAR(100)  
,@SinglePageName VARCHAR(200)  
  
SET  @GenericRDL = 'RDLDFACommonReport'  
SET @SinglePageName = 'DFASingleTabDocuments.ascx'  
  
IF EXISTS(  
  SELECT   
  '1'  
  FROM  
  DocumentCodes DC   
  JOIN Screens SC ON SC.DocumentCodeId = DC.DocumentCodeId  
  WHERE   
  DC.DocumentCodeId = @DocumentCodeId --1629  
  AND ISNULL(CONVERT(VARCHAR,DC.ViewDocumentRDL),'') = @GenericRDL  
  AND ISNULL(DC.FormCollectionId,0)!=0  
  AND SC.ScreenURL LIKE '%'+@SinglePageName   
 )  
 BEGIN  
  
  SELECT * FROM  
  DocumentCodes  DC   
  JOIN FormCollectionForms FCF ON FCF.FormCollectionId=DC.FormCollectionId WHERE DocumentCodeId = @DocumentCodeId  
 END  
 ELSE  
 BEGIN  
  RETURN 1  
 END  
END