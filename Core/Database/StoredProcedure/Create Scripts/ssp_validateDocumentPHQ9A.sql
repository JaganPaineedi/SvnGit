
/****** Object:  StoredProcedure [dbo].[ssp_validateDocumentPHQ9A]    Script Date: 07/20/2015  ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_validateDocumentPHQ9A]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_validateDocumentPHQ9A]
GO

/****** Object:  StoredProcedure [dbo].[ssp_validateDocumentPHQ9A]    Script Date: 06/30/2014 18:07:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ssp_validateDocumentPHQ9A] 
 @DocumentVersionId int    
AS  
   
/******************************************************************************  
**  
**  Name: ssp_validateDocumentPHQ9A  
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
**  Date:        Author:   Description:  
**  08/18/2015   Vijay     To create PHQ9-A document as a core document  , Project :Post Certification and task no:12
*******************************************************************************/
 
DECLARE @DocumentType VARCHAR(10)
DECLARE @DocumentCodeId INT

CREATE TABLE [#validationReturnTable] (
	TableName VARCHAR(100) NULL
	,ColumnName VARCHAR(100) NULL
	,ErrorMessage VARCHAR(max) NULL
	,TabOrder INT NULL
	,ValidationOrder INT NULL
	)

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

SELECT TableName
	,ColumnName
	,ErrorMessage
	,TabOrder
	,ValidationOrder
FROM #validationReturnTable
ORDER BY taborder
	,ValidationOrder

IF @@error <> 0
	GOTO error

RETURN

error:

RAISERROR 50000 'ssp_validateDocumentPHQ9A failed.  Please contact your system administrator.'

GO



