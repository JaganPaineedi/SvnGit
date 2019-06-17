
/****** Object:  StoredProcedure [dbo].[ssp_validateDocumentPHQ9]    Script Date: 08/18/2015  ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_validateDocumentPHQ9]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_validateDocumentPHQ9]
GO

/****** Object:  StoredProcedure [dbo].[ssp_validateDocumentPHQ9]    Script Date: 06/30/2014 18:07:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ssp_validateDocumentPHQ9] 
 @DocumentVersionId int    
AS  
   
/******************************************************************************  
**  
**  Name: ssp_validateDocumentPHQ9  
**  Desc:   
**  This procedure is used to validate PHQ9A core document  
**  
**  Parameters:  
**  Input       Output  
**              @DocumentVersionId int,  
**  Auth: Vijay 
**  Date: 08/18/2015  
*******************************************************************************  
**  Change History  
*******************************************************************************  
**  Date:      	Author:   		Description:  
**  08/18/2015  Vijay     		This procedure is used to validate PHQ9 core document   , Project :Post Certification and task no:11
**	02/24/2017	PVanderWeele	Removed CREATE [#validationReturnTable] statement and SELECT FROM #validationReturnTable. This was causing a bug
								where any validation in ssp_SCValidateDocument or scsp_SCValidateDocument to be skipped
*******************************************************************************/
 
BEGIN TRY  

DECLARE @DocumentType VARCHAR(10)
DECLARE @DocumentCodeId INT

SET @DocumentCodeId = (
		SELECT TOP 1 DocumentCodeId
		FROM Documents
		WHERE InprogressDocumentVersionId = @DocumentVersionId
		)

DECLARE @Variables VARCHAR(max)

SET @Variables = 'DECLARE @DocumentVersionId int  
      SET @DocumentVersionId = ' + convert(VARCHAR(20), @DocumentVersionId) + ''

DECLARE @sql VARCHAR(max)

SET @Sql = @Variables + ' ' + 'Insert into #validationReturnTable    
(TableName,    
ColumnName,    
ErrorMessage,    
TabOrder,    
ValidationOrder    
)' + ' ' + dbo.GetDocumentValidations(@DocumentCodeId, @DocumentType, @DocumentVersionId)

EXEC (@sql)

END TRY                                                       
                                                                                       
BEGIN CATCH                                               
  DECLARE @Error varchar(8000)                                                                                                         
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                       
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_validateDocumentPHQ9')                                                 
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                               
   + '*****' + Convert(varchar,ERROR_STATE())                                                                    
                                                                                                                                                      
                                                           
   RAISERROR                                                                                                                                       
   (                                                                                                              
    @Error, -- Message text.                                                                                                                                      
    16, -- Severity.      
    1 -- State.                                                                                                                                      
   );                                                                            
                                                            
 END CATCH 



