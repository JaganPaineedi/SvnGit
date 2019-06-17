/****** Object:  StoredProcedure [dbo].[ssp_SCValidateGroupTemplate]    Script Date: 04/04/2016 11:20:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCValidateGroupTemplate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCValidateGroupTemplate]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCValidateGroupTemplate]    Script Date: 04/04/2016 11:20:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCValidateGroupTemplate] (
	@CurrentUserId INT
	,@ScreenKeyId INT
	)
/**************************************************************  
Created By   : Akwinass
Created Date : 13-APRIL-2016 
Description  : Used to Validate Group Template  
Called From  : Group Template Screens
/*  Date			  Author				  Description */
/*  13-APRIL-2016	  Akwinass				  Created    */
/*  14-APRIL-2016	  Akwinass				  Included Overlapping Date Condition with Existing Group (167.1 in Valley - Support Go Live)*/
**************************************************************/   
AS
BEGIN
	BEGIN TRY
		DECLARE @validationReturnTable TABLE (
			TableName VARCHAR(100) NULL
			,ColumnName VARCHAR(100) NULL
			,ErrorMessage VARCHAR(max) NULL
			,TabOrder INT NULL
			,ValidationOrder INT NULL
			)
		
		DECLARE @StartDate DATETIME
		DECLARE @EndDate DATETIME
		DECLARE @GroupId DATETIME
		DECLARE @GroupTemplateId INT
		DECLARE @DocumentVersionId INT
		DECLARE @DocumentCodeId INT
		DECLARE @ValidationStoredProcedureUpdate VARCHAR(100)
		DECLARE @ValidationStoredProcedureComplete VARCHAR(100)

		SELECT TOP 1 @StartDate = StartDate
			,@EndDate = EndDate
			,@GroupId = GroupId
			,@GroupTemplateId = GroupTemplateId
		FROM GroupTemplates
		WHERE DocumentId = @ScreenKeyId
			AND ISNULL(RecordDeleted, 'N') = 'N'
			
		SELECT TOP 1 @DocumentVersionId = CurrentDocumentVersionId
			,@DocumentCodeId = DocumentCodeId
		FROM Documents
		WHERE DocumentId = @ScreenKeyId
			AND ISNULL(RecordDeleted, 'N') = 'N'
		
		SELECT TOP 1 @ValidationStoredProcedureUpdate = ValidationStoredProcedureUpdate
		FROM Screens
		WHERE DocumentCodeId = @DocumentCodeId
			AND ISNULL(RecordDeleted, 'N') = 'N'
			
		SELECT TOP 1 @ValidationStoredProcedureComplete = ValidationStoredProcedureComplete
		FROM Screens
		WHERE DocumentCodeId = @DocumentCodeId
			AND ISNULL(RecordDeleted, 'N') = 'N'		
		
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'GroupTemplates','StartDate','Group Template - Start Date is required.',0,1
		FROM GroupTemplates
		WHERE GroupTemplateId = @GroupTemplateId
			AND StartDate IS NULL
			AND ISNULL(RecordDeleted, 'N') = 'N'
			
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'GroupTemplates','StartDate','Group Template - End Date is required.',0,1
		FROM GroupTemplates
		WHERE GroupTemplateId = @GroupTemplateId
			AND EndDate IS NULL
			AND ISNULL(RecordDeleted, 'N') = 'N'
			
		INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
		SELECT 'GroupTemplates','StartDate','Group Template - End Date should be greater than Start Date.',0,1
		FROM GroupTemplates
		WHERE GroupTemplateId = @GroupTemplateId
			AND CAST(EndDate AS DATE) < CAST(StartDate AS DATE)
			AND EndDate IS NOT NULL
			AND StartDate IS NOT NULL
			AND ISNULL(RecordDeleted, 'N') = 'N'			
		
		IF NOT EXISTS(SELECT 1 FROM @validationReturnTable)
		BEGIN
			INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
			SELECT 'GroupTemplates','StartDate','Group Template - Start Date is overlapping with existing group template.',0,1
			FROM GroupTemplates
			WHERE GroupTemplateId <> @GroupTemplateId
				AND CAST(StartDate AS DATE) = CAST(@StartDate AS DATE)
				AND EndDate IS NULL
				AND StartDate IS NOT NULL
				AND GroupId = @GroupId
				AND ISNULL(RecordDeleted, 'N') = 'N'
		END
		
		IF NOT EXISTS(SELECT 1 FROM @validationReturnTable)
		BEGIN
			INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
			SELECT 'GroupTemplates','EndDate','Group Template - End Date is overlapping with existing group template.',0,1
			FROM GroupTemplates
			WHERE GroupTemplateId <> @GroupTemplateId
				AND CAST(StartDate AS DATE) = CAST(@EndDate AS DATE)
				AND EndDate IS NULL
				AND StartDate IS NOT NULL
				AND GroupId = @GroupId
				AND ISNULL(RecordDeleted, 'N') = 'N'
		END
		
		IF NOT EXISTS(SELECT 1 FROM @validationReturnTable)
		BEGIN	
			INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
			SELECT 'GroupTemplates','StartDate','Group Template - Start Date is overlapping with existing group template.',0,1
			FROM GroupTemplates
			WHERE GroupTemplateId <> @GroupTemplateId
				AND CAST(@StartDate AS DATE) BETWEEN CAST(StartDate AS DATE) AND CAST(EndDate AS DATE)
				AND EndDate IS NOT NULL
				AND StartDate IS NOT NULL
				AND GroupId = @GroupId
				AND ISNULL(RecordDeleted, 'N') = 'N'
		END
		
		IF NOT EXISTS(SELECT 1 FROM @validationReturnTable)
		BEGIN
			INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
			SELECT 'GroupTemplates','StartDate','Group Template - Date is overlapping with existing group template.',0,1
			FROM GroupTemplates
			WHERE GroupTemplateId <> @GroupTemplateId
				AND CAST(StartDate AS DATE) BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
				AND EndDate IS NOT NULL
				AND StartDate IS NOT NULL
				AND GroupId = @GroupId
				AND ISNULL(RecordDeleted, 'N') = 'N'
		END
		
		IF NOT EXISTS(SELECT 1 FROM @validationReturnTable)
		BEGIN	
			INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
			SELECT 'GroupTemplates','EndDate','Group Template - End Date is overlapping with existing group template.',0,1
			FROM GroupTemplates
			WHERE GroupTemplateId <> @GroupTemplateId
				AND CAST(@EndDate AS DATE) BETWEEN CAST(StartDate AS DATE) AND CAST(EndDate AS DATE)
				AND EndDate IS NOT NULL
				AND StartDate IS NOT NULL
				AND GroupId = @GroupId
				AND ISNULL(RecordDeleted, 'N') = 'N'
		END
		
		IF NOT EXISTS(SELECT 1 FROM @validationReturnTable)
		BEGIN	
			INSERT INTO @validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
			SELECT 'GroupTemplates','EndDate','Group Template - End Date is overlapping with existing group template.',0,1
			FROM GroupTemplates
			WHERE GroupTemplateId <> @GroupTemplateId
				AND CAST(EndDate AS DATE) BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
				AND EndDate IS NOT NULL
				AND StartDate IS NOT NULL
				AND GroupId = @GroupId
				AND ISNULL(RecordDeleted, 'N') = 'N'
		END
		
		IF NOT EXISTS(SELECT 1 FROM @validationReturnTable)
		BEGIN			
			IF ISNULL(@ValidationStoredProcedureUpdate,'') <> ''
			BEGIN	
				INSERT INTO @validationReturnTable(TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)		
				EXEC @ValidationStoredProcedureUpdate @CurrentUserId,@ScreenKeyId
			END
			
			IF ISNULL(@ValidationStoredProcedureComplete,'') <> ''
			BEGIN
				INSERT INTO @validationReturnTable(TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)
				EXEC @ValidationStoredProcedureComplete @DocumentVersionId
			END
		END	

		SELECT TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder FROM @validationReturnTable
		ORDER BY taborder,ValidationOrder

		IF EXISTS (SELECT * FROM @validationReturnTable)
		BEGIN
			SELECT 1 AS ValidationStatus
		END
		ELSE
		BEGIN
			SELECT 0 AS ValidationStatus
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCValidateGroupTemplate') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                            
				16
				,-- Severity.                                                                                    
				1 -- State.                                                                                                            
				);
	END CATCH
END

GO


