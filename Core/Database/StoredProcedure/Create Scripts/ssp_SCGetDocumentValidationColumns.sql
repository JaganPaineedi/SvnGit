IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'ssp_SCGetDocumentValidationColumns') AND type IN (N'P', N'PC')
		)
BEGIN
	DROP PROCEDURE ssp_SCGetDocumentValidationColumns;
END;
GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

CREATE PROCEDURE ssp_SCGetDocumentValidationColumns @DocumentCodeId INT
AS
/******************************************************************************
**		File: ssp_SCGetDocumentValidationColumns.sql
**		Name: ssp_SCGetDocumentValidationColumns
**		Desc: 
**
**		This template can be customized:
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**		Input							Output
**     ----------							-----------
**
**		Auth: 
**		Date: 
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**	    11/25/2016      jcarlson			    created
*******************************************************************************/
BEGIN
	BEGIN TRY

		  declare @TableList varchar(max);
		  select @TableList = TableList
		  from DocumentCodes as dc 
		  where dc.DocumentCodeId = @DocumentCodeId

		  select c.[name] as ColumnName,
		  col.DATA_TYPE as DataType,
		  col.IS_NULLABLE as IsNullable,
		  col.DOMAIN_NAME as DomainName,
		  col.CHARACTER_MAXIMUM_LENGTH as [MaxLength],
		  col.ORDINAL_POSITION as [OrdinalPosition],
		  t.[object_id] as TableId,
		  t.[name] as TableName,
		  c.column_id as ColumnId
		  from sys.columns as c
		  join sys.tables as t on c.[object_id] = t.[object_id]
		  join dbo.fnSplit(@TableList,',') as i on t.[name] = i.item
		  join INFORMATION_SCHEMA.COLUMNS as col on c.[name] = col.COLUMN_NAME
		  and col.TABLE_NAME = t.[name]
		  where c.name not in ('CreatedBy','CreatedDate','ModifiedBy','ModifiedDate','RecordDeleted','DeletedBy','DeletedDate','DocumentVersionId')
		  and c.is_identity = 0
		  order by t.[name],col.ORDINAL_POSITION

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000);

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetDocumentValidationColumns') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());

		RAISERROR (
				@Error,
				-- Message text.                                                                     
				16,
				-- Severity.                                                            
				1 -- State.                                                         
				);
	END CATCH;
END;
GO

