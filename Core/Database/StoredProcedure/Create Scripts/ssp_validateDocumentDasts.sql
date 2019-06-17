
/****** Object:  StoredProcedure [dbo].[ssp_validateDocumentDasts]    Script Date: 04/17/2018  ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_validateDocumentDasts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_validateDocumentDasts]
GO

/****** Object:  StoredProcedure [dbo].[ssp_validateDocumentDasts]    Script Date: 04/17/2018 18:07:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ssp_validateDocumentDasts] 
 @DocumentVersionId int    
AS  
   
/******************************************************************************  
**  
**  Name: ssp_validateDocumentDasts  
**  Desc:   
**  This procedure is used to validate Dast core document  
**  
**  Parameters:  
**  Input       Output  
**              @DocumentVersionId int,  
**  Auth: Chethan N 
**  Date: 04/16/2018  
*******************************************************************************  
**  Change History  
*******************************************************************************  
**  Date:      		Author:   		Description:  
	17/APR/2018		Chethan N		Westbridge-Customizations task #4650
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
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_validateDocumentDasts')                                                 
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                               
   + '*****' + Convert(varchar,ERROR_STATE())                                                                    
                                                                                                                                                      
                                                           
   RAISERROR                                                                                                                                       
   (                                                                                                              
    @Error, -- Message text.                                                                                                                                      
    16, -- Severity.      
    1 -- State.                                                                                                                                      
   );                                                                            
                                                            
 END CATCH 



