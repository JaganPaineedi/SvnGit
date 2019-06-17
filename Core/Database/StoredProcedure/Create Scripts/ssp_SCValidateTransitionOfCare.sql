
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCValidateTransitionOfCare]    Script Date: 06/09/2015 05:25:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCValidateTransitionOfCare]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCValidateTransitionOfCare]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_SCValidateTransitionOfCare]    Script Date: 06/09/2015 05:25:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
/******************************************************************************    
**  File: ssp_SCValidateTransitionOfCare.sql    
**  Name: ssp_SCValidateTransitionOfCare    
**  Desc: Provides Clinicians list who is having permission.    
**    
**  Return values: <Return Values>    
**    
**  Called by: <Code file that calls>    
**    
**  Parameters:    
**  Input   Output    
**  ServiceId      -----------    
**    
**  Created By: Veena S Mani    
**  Date:  June 20 2014    
*******************************************************************************    
**  Change History    
*******************************************************************************    
**  Date:  Author:    Description:    
**  --------  --------    -------------------------------------------    
--      
*******************************************************************************/    
CREATE PROCEDURE  [dbo].[ssp_SCValidateTransitionOfCare]     
 @DocumentVersionId int          
AS    
BEGIN    
 BEGIN TRY    
 DECLARE @DocumentType varchar(10)        
        
-- Get ClientId        
DECLARE @ClientId int        
DECLARE @EffectiveDate datetime        
DECLARE @StaffId int        
DECLARE @DocumentCodeId int      
        
SELECT @ClientId = d.ClientId        
FROM Documents d        
WHERE d.InprogressDocumentVersionId = @DocumentVersionId        
        
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
      
Set @DocumentCodeId = (Select DocumentCodeId From Documents Where InprogressDocumentVersionId = @DocumentVersionId)     
Set  @DocumentType=10    
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
  
 Insert into #validationReturnTable          
(TableName,          
ColumnName,          
ErrorMessage,          
TabOrder,          
ValidationOrder          
)  
  
--EXEC csp_SCValidateTransitionOfCare  @DocumentVersionId  
  
select TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder  from #validationReturnTable order by taborder,ValidationOrder     
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCValidateTransitionOfCare') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.    
    16    
    ,-- Severity.    
    1 -- State.    
    );    
 END CATCH    
    
 RETURN    
END 
GO

