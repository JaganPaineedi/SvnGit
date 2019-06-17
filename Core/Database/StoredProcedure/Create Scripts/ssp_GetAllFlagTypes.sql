/****** Object:  StoredProcedure [dbo].[Ssp_getallflagtypes]    Script Date: 09/21/2017 10:20:43 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[Ssp_getallflagtypes]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[Ssp_getallflagtypes]
GO

/****** Object:  StoredProcedure [dbo].[Ssp_getallflagtypes]    Script Date: 09/21/2017 10:20:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Ssp_getallflagtypes] @StaffId INT
	/********************************************************************************                                                  
-- Stored Procedure: ssp_GetAllFlagTypes  
-- Copyright: Streamline Healthcate Solutions  
-- Purpose: Procedure to return data for the Flag Types list page.  
-- Author:  Avi Goyal  
-- Date:    07 Jan 2015  
--  
-- *****History****  
-- Date         Author             Purpose  
--------------------------------------------------------------------------------  
-- 07 Jan 2015  Avi Goyal       What: Created  
                                Why : Network-180 Customizaions Task #600  
-- 20-08-2015   Hiren           -FlagType should be not null-task#56-Key Point - Environment Issues Tracking 
-- May 27 2015  PradeepA        What : Added Active column  
                                Why  : Bradford Environment Issue Tracking #26  
   14-March-2015  Sachin        Checking Not exist Condition Task :- Network180 Support Go Live #922  
   8/1/2017     Hemant          What:Modified the code to fix the Permission issue for Flags  
                                Why:Network180 Support Go Live #307  
   9/21/2017    Shankha         Why: Bear River - Support Go Live # 338  
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		SELECT DISTINCT FT.FlagTypeId
			,FT.FlagType
			,FT.Active
		FROM flagtypes AS FT
		WHERE Isnull(FT.recorddeleted, 'N') = 'N'
			AND FT.flagtype IS NOT NULL
			AND (
				EXISTS (
					SELECT 1
					FROM viewstaffpermissions V
					WHERE V.permissiontemplatetype = 5928
						AND V.permissionitemid = FT.flagtypeid
						AND V.staffid = @StaffId
					)
				OR ISNULL(FT.PermissionedFlag, 'N') = 'N' -- added by Shankha for Bear River# 338
				)
		ORDER BY flagtype ASC
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_GetAllFlagTypes') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + 
			'*****' + CONVERT(VARCHAR, Error_state())

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


