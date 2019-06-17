/****** Object:  StoredProcedure [dbo].[csp_validateCustomSUDischarges]    Script Date: 06/30/2014 18:07:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomSUDischarges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomSUDischarges]
GO

/****** Object:  StoredProcedure [dbo].[csp_validateCustomSUDischarges]    Script Date: 06/30/2014 18:07:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_validateCustomSUDischarges]  
 @DocumentVersionId int    
AS  
   
/**************************************************************  
Created By   : Akwinass
Created Date : 06 MAR 2015 
Description  : Used to Validate Custom SU Discharges Document  
Called From  : ASAM Screens
/*  Date			  Author				  Description */
/*  06-MAR-2015		  Akwinass				  Created    */
-- 23-March-2015 SuryaBalan Copied from Valley New Directions for Task #8 New Directions-Customization

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
Exec csp_validateDocumentsTableSelect @DocumentVersionId, 46221, @DocumentType, @Variables    

select TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder  from #validationReturnTable order by taborder,ValidationOrder
if @@error <> 0 goto error    
End    
   
if @@error <> 0 goto error    
    
return   
  
error:    
raiserror 50000 'csp_validateCustomSUDischarges failed.  Please contact your system administrator.'  

GO


