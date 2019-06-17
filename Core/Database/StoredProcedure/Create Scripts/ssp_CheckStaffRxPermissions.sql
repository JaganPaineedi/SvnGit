IF EXISTS (
		SELECT *
		FROM sysobjects
		WHERE type = 'P'
			AND name = 'ssp_CheckStaffRxPermissions'
		)
BEGIN
	DROP PROCEDURE ssp_CheckStaffRxPermissions
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[ssp_CheckStaffRxPermissions] (
	@StaffId INT
	,@DeniedRole VARCHAR(MAX)
	,@GrantedRole VARCHAR(MAX)
	)
AS
/******************************************************************************                    
**  File:                     
**  Name: ssp_CheckStaffRxPermissions                    
**  Desc:                     
*******************************************************************************                    
**  Change History                    
*******************************************************************************                    
**  Date:      Author:     Description:                    
**  ---------  --------    -------------------------------------------                    
**  30-OCT-2018  Akwinass	Created. (Task #115 Renaissance - Current Project Tasks)
*************************************************************************************************************************************************/
BEGIN
	BEGIN TRY
		IF OBJECT_ID('tempdb..#StaffRoles') IS NOT NULL
			DROP TABLE #StaffRoles
		CREATE TABLE #StaffRoles (RoleId INT)

		INSERT INTO #StaffRoles (RoleId)
		SELECT DISTINCT RoleId
		FROM StaffRoles
		WHERE StaffId = @StaffId
			AND ISNULL(RecordDeleted, 'N') = 'N'

		DELETE SR
		FROM #StaffRoles SR
		WHERE EXISTS (SELECT 1 FROM [dbo].[fnSplit](@DeniedRole, ',') WHERE item = SR.RoleId)

		INSERT INTO #StaffRoles (RoleId)
		SELECT DISTINCT item
		FROM [dbo].[fnSplit](@GrantedRole, ',')
		WHERE NOT EXISTS (SELECT 1 FROM #StaffRoles SR WHERE SR.RoleId = item)

		IF OBJECT_ID('tempdb..#SystemActions') IS NOT NULL
			DROP TABLE #SystemActions
		CREATE TABLE #SystemActions (ActionId INT)

		INSERT INTO #SystemActions(ActionId)
		SELECT DISTINCT sa.ActionId
		FROM PermissionTemplates pt
		JOIN PermissionTemplateItems pti ON pti.PermissionTemplateId = pt.PermissionTemplateId
		JOIN SystemActions sa ON pti.PermissionItemId = sa.ActionId
		WHERE isnull(pt.RecordDeleted, 'N') = 'N'
			AND isnull(pti.RecordDeleted, 'N') = 'N'
			AND isnull(sa.RecordDeleted, 'N') = 'N'
			AND pt.PermissionTemplateType = 5932
			AND EXISTS(SELECT 1 FROM #StaffRoles SR WHERE SR.RoleId = pt.RoleId)

		--EPCS permission should not be modified by SC
		DELETE FROM #SystemActions WHERe ActionId = 10074

		IF OBJECT_ID('tempdb..#SystemActionsDenied') IS NOT NULL
			DROP TABLE #SystemActionsDenied
		CREATE TABLE #SystemActionsDenied (ActionId INT)

		INSERT INTO #SystemActionsDenied (ActionId)
		SELECT DISTINCT sa.ActionId
		FROM SystemActions sa
		WHERE isnull(sa.RecordDeleted, 'N') = 'N'
			AND sa.ApplicationId = 5
			AND sa.ActionId <> 10074
			AND NOT EXISTS (SELECT 1 FROM StaffPermissions SP WHERE SP.StaffId = @StaffId AND ISNULL(SP.RecordDeleted, 'N') = 'N' AND SP.ActionId = sa.ActionId)
			
		SELECT SA.ActionId
		FROM #SystemActions SA
		JOIN #SystemActionsDenied SAD ON SA.ActionId = SAD.ActionId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_CheckStaffRxPermissions') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                   
				16
				,-- Severity.                                                                                                              
				1 -- State.                                       
				);
	END CATCH
END
