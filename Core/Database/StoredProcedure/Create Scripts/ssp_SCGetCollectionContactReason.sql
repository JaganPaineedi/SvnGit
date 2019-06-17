/****** Object:  StoredProcedure [dbo].[ssp_SCGetCollectionContactReason]    Script Date: 08/10/2015 19:38:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetCollectionContactReason]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetCollectionContactReason]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetCollectionContactReason]    Script Date: 08/10/2015 19:38:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetCollectionContactReason]
	/********************************************************************************                                                    
-- Stored Procedure: ssp_SCGetCollectionContactReason  
--  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose: Get data to be used to fill the dropdowns in the list page  
--  
-- Author: Akwinass   
-- Date:   24-AUG-2015  

*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		CREATE TABLE #ContactNoteReason (ContactReason INT)

		INSERT INTO #ContactNoteReason (ContactReason)
		SELECT R.IntegerCodeId
		FROM Recodes R
		JOIN RecodeCategories RC ON R.RecodeCategoryId = RC.RecodeCategoryId
		WHERE ISNULL(R.RecordDeleted, 'N') = 'N'
			AND ISNULL(RC.RecordDeleted, 'N') = 'N'
			AND ISNULL(RC.CategoryCode, '') = 'InternalCollectionsCommunications'

		SELECT GC.GlobalCodeId, GC.CodeName, GC.CodeName, GC.ExternalCode1
		FROM GlobalCodes GC
		WHERE GC.Category = 'CONTACTNOTEREASON'
			AND ISNULL(GC.Active, 'N') = 'Y'
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
			AND GC.GlobalCodeId IN (
				SELECT R.IntegerCodeId
				FROM Recodes R
				JOIN RecodeCategories RC ON R.RecodeCategoryId = RC.RecodeCategoryId
				WHERE ISNULL(R.RecordDeleted, 'N') = 'N'
					AND ISNULL(RC.RecordDeleted, 'N') = 'N'
					AND ISNULL(RC.CategoryCode, '') = 'InternalCollectionsCommunications'
				)
		ORDER BY GC.SortOrder, GC.CodeName ASC
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetCollectionContactReason') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


