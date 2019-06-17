IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ValidateDocumentsFromDocumentValidations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ValidateDocumentsFromDocumentValidations]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ValidateDocumentsFromDocumentValidations]  
 @DocumentVersionId int    
AS  
   
/**************************************************************  
Created By   : Malathi Shiva
Created Date : 25/Sep/2018 
Description  :Validation Stored procedure 
**************************************************************/
   
-- Declare Variables  
DECLARE @DocumentType varchar(10)  
  
-- Get ClientId  
DECLARE @ClientId int  
DECLARE @EffectiveDate datetime  
DECLARE @StaffId int  
DECLARE @DocumentCodeId int
  
SELECT @ClientId = d.ClientId, @DocumentCodeId = d.DocumentCodeId, @StaffId = d.AuthorId  
FROM Documents d  
WHERE d.InProgressDocumentVersionId = @DocumentVersionId  
  
SET @EffectiveDate = CONVERT(datetime, convert(varchar, getdate(), 101))  

  CREATE TABLE [#validationReturnTable] (        
   TableName varchar(100) null,       
   ColumnName varchar(100) null,       
   ErrorMessage varchar(max) null,
   TabOrder int null,  
   ValidationOrder int null  
   )  
-- Set Variables sql text  
DECLARE @Variables varchar(max)    
SET @Variables = 'DECLARE @DocumentVersionId int  
      SET @DocumentVersionId = ' + convert(varchar(20), @DocumentVersionId) +   
     ' DECLARE @ClientId int  
      SET @ClientId = ' + convert(varchar(20), @ClientId) +   
     'DECLARE @EffectiveDate datetime  
      SET @EffectiveDate = ''' + CONVERT(varchar(20), @EffectiveDate, 101) + '''' +  
     'DECLARE @StaffId int  
      SET @StaffId = ' + CONVERT(varchar(20), @StaffId)  
      

Declare @sql varchar(max)    
    
    
set @Sql = @Variables +  ' ' +     
'Insert into #validationReturnTable    
(TableName,    
ColumnName,    
ErrorMessage,    
TabOrder,    
ValidationOrder    
)'    
+ ' ' + dbo.GetDocumentValidations(@DocumentCodeId,@DocumentType,@DocumentVersionId)    
    
exec (@sql)  

select TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder  from #validationReturnTable order by taborder,ValidationOrder
IF ( @@error != 0 ) 
        BEGIN 
            DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetClientMedicationDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, 
				ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);

            RETURN( 1 ) 
        END 

      RETURN( 0 ) 

GO



  
  
