/****** Object:  StoredProcedure [dbo].[ssp_SCGetPreferredActionDetails]    Script Date: 06/27/2017 11:04:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetPreferredActionDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetPreferredActionDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetPreferredActionDetails]    Script Date: 06/27/2017 11:04:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/********************************************************************************                                                  
-- Stored Procedure: dbo.ssp_SCGetPreferredActionDetails                                                 
--                                                  
-- Copyright: Streamline Healthcate Solutions                                                  
--                                                  
-- Purpose: used by 'Action Templates' Details box.                                                  
--                                                  
-- Updates:                                                                                                         
-- Date			 Author          Purpose                                                  
-- 27.JUNE.2017	 Akwinass        Created(Engineering Improvement Initiatives- NBL(I) #536 .       
*********************************************************************************/
CREATE PROCEDURE [dbo].[ssp_SCGetPreferredActionDetails]
AS
BEGIN
	BEGIN TRY
		SELECT PreferredActionTemplateId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedBy
			,DeletedDate
			,TemplateName
		FROM PreferredActionTemplates
		WHERE ISNULL(RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_SCGetPreferredActionDetails') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END

GO