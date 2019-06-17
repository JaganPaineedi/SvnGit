
IF EXISTS ( SELECT * 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[ssp_ImportDFAScript]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
    DROP PROCEDURE [dbo].[ssp_ImportDFAScript]
END
Go

CREATE PROCEDURE [dbo].[ssp_ImportDFAScript]    
@DFAScript NVARCHAR(MAX)    
AS   
/*********************************************************************/              
/* Stored Procedure: dbo.ssp_ImportDFAScript            */              
/* Copyright:             */              
/* Creation Date:  12-06-2017                                  */              
/*                                                                   */              
/* Purpose: Import dfa script         */             
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
BEGIN TRY    
   
 EXEC sp_executesql @DFAScript    
    
END TRY    
BEGIN CATCH    
   
 DECLARE @ErrorMessage NVARCHAR(MAX)    
 DECLARE @ErrorSeverity INT    
 DECLARE @ErrorState INT    
 SET @ErrorMessage =  ERROR_MESSAGE()    
 SET @ErrorSeverity =  ERROR_SEVERITY()    
 SET @ErrorState =  ERROR_STATE()    
 RAISERROR  (@ErrorMessage,@ErrorSeverity,@ErrorState);  
END CATCH    
    
END