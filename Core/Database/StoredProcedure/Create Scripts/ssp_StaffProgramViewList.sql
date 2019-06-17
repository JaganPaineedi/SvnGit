/****** Object:  StoredProcedure [dbo].[ssp_StaffProgramViewList]    Script Date: 08/10/2015 19:38:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_StaffProgramViewList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_StaffProgramViewList]
GO

/****** Object:  StoredProcedure [dbo].[ssp_StaffProgramViewList]    Script Date: 08/10/2015 19:38:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_StaffProgramViewList] (@StaffID INT)
	/********************************************************************************                                                    
-- Stored Procedure: ssp_StaffProgramViewList  
--  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose: Get data to be used to fill the dropdowns in the list page  
--  
-- Author: Vamsi   
-- Date:   10-AUG-2015  

*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		SELECT pv.ProgramViewId
			,pv.ViewName
			,pv.AllPrograms
			,pv.UserStaffId
			,pv.RecordDeleted
		FROM ProgramViews AS pv
		INNER JOIN Staff AS s ON s.StaffId = pv.UserStaffId
		WHERE (s.StaffId = @StaffID)
			AND ISNULL(pv.RecordDeleted, 'N') = 'N'
			AND s.Active = 'Y'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_StaffProgramViewList') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


