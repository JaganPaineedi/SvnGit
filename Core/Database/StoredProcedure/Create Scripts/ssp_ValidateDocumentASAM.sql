/****** Object:  StoredProcedure [dbo].[ssp_ValidateDocumentASAM]    Script Date: 06/30/2014 18:07:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ValidateDocumentASAM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ValidateDocumentASAM]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_ValidateDocumentASAM]  
 @DocumentVersionId int    
AS  
   
/*********************************************************************/
/* Stored Procedure: [ssp_ValidateDocumentASAM]   */
/*       Date              Author                  Purpose                   */
/*      04-05-2016     Dhanil Manuel               Validations  */
/*********************************************************************/
 
DECLARE @DocumentType varchar(10)
DECLARE @ClientId int  
DECLARE @EffectiveDate datetime  
DECLARE @StaffId int  
DECLARE @DocumentCodeId int
  
SELECT @ClientId = d.ClientId  
FROM Documents d  
WHERE d.InProgressDocumentVersionId = @DocumentVersionId  
  
SELECT @StaffId = d.AuthorId  
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

  
DECLARE @Variables varchar(max)    
SET @Variables = 'DECLARE @DocumentVersionId int  
      SET @DocumentVersionId = ' + convert(varchar(20), @DocumentVersionId) +    
     ' DECLARE @ClientId int  
      SET @ClientId = ' + convert(varchar(20), @ClientId) +   
     'DECLARE @EffectiveDate datetime  
      SET @EffectiveDate = ''' + CONVERT(varchar(20), @EffectiveDate, 101) + '''' +  
     'DECLARE @StaffId int  
      SET @StaffId = ' + CONVERT(varchar(20), @StaffId)  
  

If Not Exists (Select 1 From CustomDocumentValidationExceptions where DocumentVersionId = @DocumentVersionId and DocumentValidationid is null)    
Begin
Exec csp_validateDocumentsTableSelect @DocumentVersionId, 2701, @DocumentType, @Variables


select TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder  from #validationReturnTable order by taborder,ValidationOrder
if @@error <> 0 goto error    
End    
   
if @@error <> 0 goto error    
    
return   
  
error:    
raiserror 50000 'ssp_ValidateDocumentASAM failed.  Please contact your system administrator.'  

GO


