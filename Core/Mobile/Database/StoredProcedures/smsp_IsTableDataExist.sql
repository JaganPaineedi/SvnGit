/****** Object:  StoredProcedure [dbo].[SMSP_IsTableDataExist]    Script Date: 10/24/2016 12:52:21 PM ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[smsp_IsTableDataExist]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[smsp_IsTableDataExist]
GO

/****** Object:  StoredProcedure [dbo].[SMSP_IsTableDataExist]    Script Date: 10/24/2016 12:52:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[smsp_IsTableDataExist] (
	@PrimaryKeyValue INT
	,@PrimaryKeyName VARCHAR(100)
	,@TableName VARCHAR(100)
	,@Active CHAR(1) = ''
	)
AS
BEGIN
	BEGIN TRY
		DECLARE @query NVARCHAR(MAX)

		SET @query = 'Select 1 FROM ' + @TableName + ' WHERE ' + @PrimaryKeyName + '=' + Convert(VARCHAR(100), @PrimaryKeyValue)

		IF @Active != ''
			SET @query += ' AND Active=''' + @Active + ''''

		EXECUTE sp_executesql @query
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SMSP_IsTableDataExist') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


