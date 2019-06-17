IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'ssp_SCDVAInsertValidationFromShortcut') AND type IN (N'P', N'PC')
		)
BEGIN
	DROP PROCEDURE ssp_SCDVAInsertValidationFromShortcut;
END;
GO

CREATE PROCEDURE ssp_SCDVAInsertValidationFromShortcut @UserId INT, @UserCode VARCHAR(30), @DocumentCodeId INT, @TableName VARCHAR(max), @ColumnName VARCHAR(max), @TabName VARCHAR(max), @TabOrder INT
AS
/******************************************************************************
**		File: 
**		Name: ssp_SCDVAInsertValidationFromShortcut
**		Desc: The purpose of this sp is to insert a new validation record into DynamicValidations field
			 when the user presses crtl+alt+v. This will create a new row with min init fields.
**
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**
**		Auth: jcarlson
**		Date: 9/25/2018
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**        9/25/2018          jcarlson             created
*******************************************************************************/
DECLARE @error VARCHAR(max);
DECLARE @customError BIT = 0;

BEGIN TRY
	DECLARE @Table INT, @Column INT;

	SELECT @Table = a.object_id
	FROM sys.tables AS a
	WHERE a.NAME = @TableName

	SELECT @Column = a.column_id
	FROM sys.columns AS a
	WHERE a.object_id = @Table AND a.NAME = @ColumnName

	IF (@Table IS NULL)
	BEGIN
		SET @error = 'Table ' + @TableName + ' does not exist in target environment';
		SET @customError = 1;

		RAISERROR (@error, 16, 1);
	END

	IF (@Column IS NULL)
	BEGIN
		SET @error = 'Column ' + @ColumnName + ' does not belong to table ' + @TableName;
		SET @customError = 1;

		RAISERROR (@error, 16, 1);
	END

	DECLARE @Order INT = 1;

	SELECT @Order = isnull(MAX(a.[ValidationOrder]), 0) + 1
	FROM DocumentValidations AS a
	WHERE ISNULL(a.RecordDeleted, 'N') = 'N' AND a.DocumentCodeId = @DocumentCodeId

	DECLARE @ControlType INT = 1;

	INSERT INTO DocumentValidations (CreatedBy, ModifiedBy, DocumentCodeId, Active, TabName, TabOrder, [ValidationOrder], [TableName], [ColumnName], ErrorMessage, ValidationLogic)
	SELECT @UserCode, @UserCode, @DocumentCodeId, 'N', @TabName, @TabOrder, @Order, @TableName, @ColumnName, 'Placeholder message for table ' + @TableName + ' and column ' + @ColumnName, ' FROM DocumentVersions as dv' + CHAR(13) + CHAR(10) + ' JOIN ' + @TableName + ' as table_1 on dv.DocumentVersionId = table_1.DocumentVersionId ' + CHAR(13) + CHAR(10) + ' WHERE table_1.' + @ColumnName + ' IS NULL';

	INSERT INTO DocumentValidationConditions (CreatedBy, ModifiedBy, DocumentValidationId, [TableName], [ColumnName], ConditionAction, ConditionType)
	SELECT @UserCode, @UserCode, SCOPE_IDENTITY(), @TableName, @ColumnName, 9523, 9529
END TRY

BEGIN CATCH
	IF (@customError = 0)
	BEGIN
		SELECT @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCDVAInsertValidationFromShortcut') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());
	END

	RAISERROR ( @Error, 16,  1 );

	
END CATCH;