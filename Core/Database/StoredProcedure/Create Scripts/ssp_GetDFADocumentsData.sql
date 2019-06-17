IF EXISTS ( SELECT * 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[ssp_GetDFADocumentsData]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
    DROP PROCEDURE [dbo].[ssp_GetDFADocumentsData]
END
Go   
/*********************************************************************/              
/* Stored Procedure: dbo.ssp_GetDFADocumentsData    --1629         */              
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
/* 07/12/2017   Rajesh S      Get Sp                                  */              
/*********************************************************************/      
CREATE PROCEDURE dbo.ssp_GetDFADocumentsData --1373302      
@DocumentVersionId INT      
AS      
BEGIN      
BEGIN TRY    
    
 DECLARE @TableList varchar(max)      
       
 SELECT       
 @TableList = TableList      
 FROM      
 Documents D      
 JOIN DocumentCodes DS ON D.DocumentCodeId = DS.DocumentCodeId      
 WHERE D.InProgressDocumentVersionId = @DocumentVersionId      
       
 DECLARE @TableName Table      
 (      
  TableName varchar(300)      
 )       
       
 INSERT INTO @TableName      
 SELECT * FROM dbo.fnSplit(@TableList,',')      
       
  
   
 DECLARE @SelectTables NVARCHAR(MAX)      
       
 SET @SelectTables = (      
       
 SELECT STUFF((      
 SELECT ' SELECT * FROM '+tablename+'  WHERE DOCUMENTVERSIONID='+CAST(@DocumentVersionId AS VARCHAR(100))  + CHAR(13)+CHAR(10)            
  FROM @TableName FOR XML PATH(''),TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, ''))      
        
 EXECUTE sp_executesql @SelectTables      
     
 END TRY    
 BEGIN CATCH    
 DECLARE @ErrorMessage NVARCHAR(MAX)        
 DECLARE @ErrorSeverity INT        
 DECLARE @ErrorState INT    SET @ErrorMessage =  ERROR_MESSAGE()        
 SET @ErrorSeverity =  ERROR_SEVERITY()        
 SET @ErrorState =  ERROR_STATE()        
 RAISERROR  (@ErrorMessage,@ErrorSeverity,@ErrorState);       
 END CATCH    
       
END