/****** Object:  StoredProcedure [dbo].[ssp_SCLetterUpdateParentScreenTable]    Script Date: 08/13/2015 16:12:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCLetterUpdateParentScreenTable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCLetterUpdateParentScreenTable]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCLetterUpdateParentScreenTable]    Script Date: 08/13/2015 16:12:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCLetterUpdateParentScreenTable] (
	@ParentTableName VARCHAR(800)
	,@ParentPrimaryKeyName VARCHAR(800)
	,@ParentPrimarykeyValue VARCHAR(800)
	,@LetterId INT
	,@UserCode VARCHAR(100)
	,@PageAction VARCHAR(100)
	)
AS
/*********************************************************************/
/* Stored Procedure: [ssp_SCLetterUpdateParentScreenTable]               */
/* Creation Date:  27/AUG/2015                                    */
/* Purpose: To Update Letter Pareent Screen */
/* Input Parameters:   @ParentTableName, @ParentPrimaryKeyName, @ParentPrimarykeyValue, @LetterId, @UserCode, @PageAction*/
/*********************************************************************/
BEGIN TRY
	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = @ParentTableName)
    BEGIN 
		IF COL_LENGTH(@ParentTableName, @ParentPrimaryKeyName) IS NOT NULL AND COL_LENGTH(@ParentTableName, 'LetterId') IS NOT NULL
		BEGIN		
			DECLARE @DynamicSql VARCHAR(MAX) = ''
			SET @DynamicSql = @DynamicSql + ' IF NOT EXISTS(SELECT 1 FROM '+@ParentTableName+' WHERE LetterId = '+CAST(@LetterId AS VARCHAR(25))+' AND ISNULL(RecordDeleted,''N'') = ''N'')'
			SET @DynamicSql = @DynamicSql + ' BEGIN'
			SET @DynamicSql = @DynamicSql + ' INSERT INTO '+@ParentTableName+' (CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,'+@ParentPrimaryKeyName+',LetterId)'
			SET @DynamicSql = @DynamicSql + ' VALUES('''+@UserCode+''',GETDATE(),'''+@UserCode+''',GETDATE(),'+@ParentPrimarykeyValue+','+CAST(@LetterId AS VARCHAR(25))+')'
			SET @DynamicSql = @DynamicSql + ' END'
			EXEC (@DynamicSql)
			
			IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCLetterUpdateParentScreenTable]') AND type in (N'P', N'PC'))
			BEGIN
				EXEC scsp_SCLetterUpdateParentScreenTable @ParentTableName
					,@ParentPrimaryKeyName
					,@ParentPrimarykeyValue
					,@LetterId
					,@UserCode
					,@PageAction
			END
		END
    END
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCLetterUpdateParentScreenTable') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.      
			16
			,-- Severity.      
			1 -- State.      
			);
END CATCH

GO


