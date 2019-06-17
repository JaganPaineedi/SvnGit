IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'ssp_SCGetDocumentValidationTables') AND type IN (N'P', N'PC')
		)
BEGIN
	DROP PROCEDURE ssp_SCGetDocumentValidationTables;
END;
GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

CREATE PROCEDURE ssp_SCGetDocumentValidationTables @DocumentCodeId int
AS
/******************************************************************************
**		File: ssp_SCGetDocumentValidationTables.sql
**		Name: ssp_SCGetDocumentValidationTables
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
		select @TableList = dc.TableList
		from DocumentCodes as dc
		where dc.DocumentCodeId = @DocumentCodeId
		
		Select a.[name] as TableName,
		a.[object_id] as TableId
		from sys.tables as a
		join ( select item as TableName
			  from dbo.fnSplit(@TableList,',')
			  ) as b on a.[name] = b.TableName
	     where Exists( select 1
				    from sys.columns as c
				    where c.object_id = a.object_id
				    and name = 'DocumentVersionId'
				    )

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000);

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetDocumentValidationTables') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());

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

