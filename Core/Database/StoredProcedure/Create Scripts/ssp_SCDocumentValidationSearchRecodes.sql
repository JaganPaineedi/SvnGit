IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'ssp_SCDocumentValidationSearchRecode') AND type IN (N'P', N'PC')
		)
BEGIN
	DROP PROCEDURE ssp_SCDocumentValidationSearchRecode;
END;
GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

CREATE PROCEDURE ssp_SCDocumentValidationSearchRecode @Letters varchar(max)
AS
/******************************************************************************
**		File: ssp_SCDocumentValidationSearchRecode.sql
**		Name: ssp_SCDocumentValidationSearchRecode
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
		  select rc.CategoryCode
		  from RecodeCategories as rc
		  where ISNULL(rc.RecordDeleted,'N')='N'
		  and ( rc.CategoryCode like '%' + @Letters + '%' 
			   or rc.CategoryName like '%' + @Letters + '%'
			 )
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000);

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCDocumentValidationSearchRecode') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());

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

