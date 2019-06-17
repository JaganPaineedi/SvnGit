
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateIndividualServiceNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateIndividualServiceNote]
GO

/****** Object:  StoredProcedure [dbo].[csp_ValidateIndividualServiceNote]    Script Date:  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROCEDURE csp_ValidateIndividualServiceNote @DocumentVersionId INT  
  
 /********************************************************************************                                                     
--    
-- Copyright: Streamline Healthcare Solutions    
-- "Individual Service Note"  
-- Purpose: 
--    
-- Author 
-- Date:     
--    
-- *****History****    
/*  Date			Author			Description */  
/*  24/02/2015      Bernardin       To get validations */ 
*********************************************************************************/  
AS  
BEGIN    
  
     
-- Declare Variables    
DECLARE @DocumentType varchar(10)    
    
-- Get ClientId    
DECLARE @ClientId int    
DECLARE @EffectiveDate datetime    
DECLARE @StaffId int    
DECLARE @DocumentCodeId int  
DECLARE @ServiceId int

Begin Try
    
SELECT @ClientId = d.ClientId,@ServiceId = ServiceId    
FROM Documents d    
WHERE d.CurrentDocumentVersionId = @DocumentVersionId    
    
SELECT @StaffId = d.AuthorId    
FROM Documents d    
WHERE d.CurrentDocumentVersionId = @DocumentVersionId    
    
SET @EffectiveDate = CONVERT(datetime, convert(varchar, getdate(), 101))    
  
 CREATE TABLE [#validationReturnTable] (          
   TableName varchar(100) null,         
   ColumnName varchar(100) null,         
   ErrorMessage varchar(max) null,  
   TabOrder int null,    
   ValidationOrder int null    
   )    
  
--Set @DocumentCodeId = (Select DocumentCodeId From Documents Where CurrentDocumentVersionId = @DocumentVersionId)  
    
-- Set Variables sql text    
DECLARE @Variables varchar(max)      
SET @Variables = 'DECLARE @DocumentVersionId int    
      SET @DocumentVersionId = ' + convert(varchar(20), @DocumentVersionId) +    
     --'DECLARE @DocumentType varchar(10)    
     -- SET @DocumentType = ' +''''+ @DocumentType+'''' +    
     ' DECLARE @ClientId int    
      SET @ClientId = ' + convert(varchar(20), @ClientId) +     
     'DECLARE @EffectiveDate datetime    
      SET @EffectiveDate = ''' + CONVERT(varchar(20), @EffectiveDate, 101) + '''' +    
     'DECLARE @StaffId int    
      SET @StaffId = ' + CONVERT(varchar(20), @StaffId)+  
     'DECLARE @ServiceId int    
      SET @ServiceId = ' + CONVERT(varchar(20), @ServiceId)  
    
-- Exec csp_validateDocumentsTableSelect to determine validation list      
If Not Exists (Select 1 From CustomDocumentValidationExceptions where DocumentVersionId = @DocumentVersionId and DocumentValidationid is null)      
Begin      
Exec csp_validateDocumentsTableSelect @DocumentVersionId, 11145, @DocumentType, @Variables      
  
select TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder  from #validationReturnTable order by ValidationOrder       
End      
    
 End Try
 
  BEGIN CATCH          
   DECLARE @Error varchar(8000)                                                 
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                        
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_ValidateIndividualServiceNote')                                                                               
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                
   + '*****' + Convert(varchar,ERROR_STATE())                                           
   RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );             
 END CATCH          
END