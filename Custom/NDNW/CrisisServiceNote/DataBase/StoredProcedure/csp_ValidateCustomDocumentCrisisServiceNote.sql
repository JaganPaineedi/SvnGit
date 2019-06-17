/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentCrisisServiceNote]  ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentCrisisServiceNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentCrisisServiceNote]
GO


/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentCrisisServiceNote]  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_ValidateCustomDocumentCrisisServiceNote]  
 @DocumentVersionId int    
AS  
   
/**************************************************************  
Created By   : Vichee
Created Date : 08 Apr 2015 
Description  : Used to Validate Custom Crisis Service Note  
Called From  : Crisis Service Note
/*  Date			  Author				  Description */
/*  08-APR-2015		  Vichee				  Created    */

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

--CREATE TABLE #CustomAcuteServicesPrescreens (    
-- DocumentVersionId INT
-- ,RiskSuicideHomicidePlanDetails INT
-- )
 
--  INSERT INTO #CustomAcuteServicesPrescreens (    
--  DocumentVersionId
-- ,RiskSuicideHomicidePlanDetails
-- )
--  SELECT DocumentVersionId
--  ,RiskSuicideHomicidePlanDetails
  
--   FROM CustomAcuteServicesPrescreens a 
--   WHERE a.documentVersionId = @DocumentVersionId    
--   AND isnull(a.RecordDeleted, 'N') = 'N' 

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
Exec csp_validateDocumentsTableSelect @DocumentVersionId, 60006, @DocumentType, @Variables  

if @@error <> 0 goto error  
select TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder  from #validationReturnTable order by taborder,ValidationOrder    
End      
     
if @@error <> 0 goto error      
      
return     
    
error:      
raiserror 50000 'csp_ValidateCustomDocumentCrisisServiceNote failed.  Please contact your system administrator.'   
GO


