IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetModularDefinitionModuleNames]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetModularDefinitionModuleNames]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/********************************************************************************                                                  
-- Stored Procedure: dbo.ssp_SCGetModularDefinitionModuleNames                                                 
--                                                  
-- Copyright: Streamline Healthcate Solutions                                                  
--                                                  
-- Purpose: To get "Module Names" used by 'Manage Roles & Modules' Details.                                                  
--                                                  
-- Updates:                                                                                                         
-- Date			 Author          Purpose                                                  
-- 22.SEP.2017	 Akwinass        Created(Engineering Improvement Initiatives- NBL(I) #561 .       
*********************************************************************************/
CREATE PROCEDURE [dbo].[ssp_SCGetModularDefinitionModuleNames]
AS
BEGIN
	BEGIN TRY
		SELECT DISTINCT MMS.ManageModuleScreenId
			,MMS.ModuleScreenName
		FROM ManageModuleScreens MMS
		WHERE ISNULL(MMS.RecordDeleted, 'N') = 'N'
			AND (
				EXISTS (
					SELECT 1
					FROM ManageModuleScreenDetails MMSD
					JOIN Screens S ON MMSD.ScreenId = S.ScreenId
					JOIN Banners B ON S.ScreenId = B.ScreenId
						AND ISNULL(MMSD.RecordDeleted, 'N') = 'N'
						AND ISNULL(S.RecordDeleted, 'N') = 'N'
						AND ISNULL(B.Active, 'N') = 'Y'
					WHERE MMSD.ManageModuleScreenId = MMS.ManageModuleScreenId
					)
				OR EXISTS (
					SELECT 1
					FROM ManageModuleScreenDetails MMSD
					JOIN Screens S ON MMSD.ScreenId = S.ScreenId
					LEFT JOIN Banners B ON S.ScreenId = B.ScreenId
						AND ISNULL(MMSD.RecordDeleted, 'N') = 'N'
						AND ISNULL(S.RecordDeleted, 'N') = 'N'
					WHERE MMSD.ManageModuleScreenId = MMS.ManageModuleScreenId
						AND B.BannerId IS NULL
					)
				)
		ORDER BY MMS.ModuleScreenName ASC
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_SCGetModularDefinitionModuleNames') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

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


