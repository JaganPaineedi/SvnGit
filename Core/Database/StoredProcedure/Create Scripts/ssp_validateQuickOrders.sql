IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_validateQuickOrders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_validateQuickOrders]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_validateQuickOrders] @documentVersionId INT
-- ============================================================================================================================   
-- Author      : Akwinass.D 
-- Date        : 15/MAY/2018
-- Purpose     : To validate data for "Quick Orders" Document
-- Updates:
-- Date			Author    Purpose 
-- 15/MAY/2018  Akwinass  Created.(Task #650 in Engineering Improvement Initiatives- NBL(I)) */
-- ============================================================================================================================
AS
BEGIN
	DECLARE @DocumentType VARCHAR(10)
	DECLARE @ClientId INT
	DECLARE @EffectiveDate DATETIME
	DECLARE @StaffId INT
	DECLARE @DocumentCodeId INT

	BEGIN TRY		
		SELECT TOP 1 @ClientId = d.ClientId, @StaffId = d.AuthorId
		FROM Documents AS d
		JOIN DocumentVersions AS dv ON dv.DocumentId = d.DocumentId
		WHERE dv.DocumentVersionId = @DocumentVersionId

		SET @EffectiveDate = CONVERT(DATETIME, convert(VARCHAR, getdate(), 101))

		CREATE TABLE [#validationReturnTable] (
			TableName VARCHAR(100) NULL
			,ColumnName VARCHAR(100) NULL
			,ErrorMessage VARCHAR(max) NULL
			,TabOrder INT NULL
			,ValidationOrder INT NULL
			)

		DECLARE @Variables VARCHAR(max)

		SET @Variables = 'DECLARE @DocumentVersionId int  
		  SET @DocumentVersionId = ' + convert(VARCHAR(20), @DocumentVersionId) + ' DECLARE @ClientId int  
		  SET @ClientId = ' + convert(VARCHAR(20), @ClientId) + 'DECLARE @EffectiveDate datetime  
		  SET @EffectiveDate = ''' + CONVERT(VARCHAR(20), @EffectiveDate, 101) + '''' + 'DECLARE @StaffId int  
		  SET @StaffId = ' + CONVERT(VARCHAR(20), @StaffId)

		IF NOT EXISTS (
				SELECT 1
				FROM CustomDocumentValidationExceptions
				WHERE DocumentVersionId = @DocumentVersionId
					AND DocumentValidationid IS NULL
				)
		BEGIN
			DELETE FROM #validationReturnTable
			EXEC csp_validateDocumentsTableSelect @DocumentVersionId
				,1653
				,@DocumentType
				,@Variables
		END

		SELECT TableName
			,ColumnName
			,ErrorMessage
			,TabOrder
			,ValidationOrder
		FROM #validationReturnTable
		ORDER BY taborder
			,ValidationOrder
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_validateQuickOrders') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,/* Message text.*/ 16
				,/* Severity.*/ 1 /*State.*/
				);
	END CATCH
END

GO