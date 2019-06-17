IF EXISTS ( SELECT * 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[ssp_GetFormHTML]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
    DROP PROCEDURE [dbo].[ssp_GetFormHTML]
END
Go   
/*********************************************************************/              
/* Stored Procedure: dbo.ssp_GetFormHTM    --1629         */              
/* Copyright:             */              
/* Creation Date:  12-06-2017                                  */              
/*                                                                   */              
/* Purpose:Get the Form html field from forms table         */             
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
CREATE PROCEDURE dbo.ssp_GetFormHTML   
@FormId INT    
AS    
BEGIN    
    
DECLARE @HTML NVARCHAR(MAX)    
    
SELECT @HTML = FormHtml from Forms where FormId = @FormId    
 
    
SELECT @HTML FormHtml    
END