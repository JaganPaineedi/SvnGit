/****** Object:  StoredProcedure [dbo].[csp_validateCustomASAMs]    Script Date: 06/30/2014 18:07:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomASAMs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomASAMs]
GO

/****** Object:  StoredProcedure [dbo].[csp_validateCustomASAMs]    Script Date: 06/30/2014 18:07:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_validateCustomASAMs]  
 @DocumentVersionId int    
AS  
   
/**************************************************************  
Created By   : Akwinass
Created Date : 24 nov 2014 
Description  : Used to Validate Custom ASAM Document  
Called From  : ASAM Screens
/*  Date			  Author				  Description */
/*  01-DEC-2014		  Akwinass				  Created    */

**************************************************************/
 
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
Exec csp_validateDocumentsTableSelect @DocumentVersionId, 40034, @DocumentType, @Variables    

select TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder  from #validationReturnTable order by taborder,ValidationOrder
if @@error <> 0 goto error    
End    
   
if @@error <> 0 goto error    
    
return   
  
error:    
raiserror 50000 'csp_validateCustomASAMs failed.  Please contact your system administrator.'  

GO


