
/****** Object:  StoredProcedure [dbo].[ssp_validateDocumentSuicideRiskAssessment]    Script Date: 14/10/2015  ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_validateDocumentSuicideRiskAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_validateDocumentSuicideRiskAssessment]
GO

/****** Object:  StoredProcedure [dbo].[ssp_validateDocumentSuicideRiskAssessment]    Script Date: 06/30/2014 18:07:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ssp_validateDocumentSuicideRiskAssessment] 
 @DocumentVersionId int    
AS  
   
/******************************************************************************  
**  
**  Name: ssp_validateDocumentSuicideRiskAssessment  
**  Desc:   
**  This procedure is used to validate Suicide Risk Assessment core document  
**  
**  Parameters:  
**  Input       Output  
**              @DocumentVersionId int,  
**  Auth: Seema 
**  Date: 14/10/2015  
*******************************************************************************  
**  Change History  
*******************************************************************************  
**  Date:        Author:   Description:  
**  14/10/2015   Seema     This procedure is used to validate Suicide Risk Assessment core document   , Project :Post Certification and task no:20
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

RAISERROR 50000 'ssp_validateDocumentSuicideRiskAssessment failed.  Please contact your system administrator.'

GO



