IF EXISTS (
		SELECT *
		FROM sysobjects
		WHERE type = 'P'
			AND name = 'ssp_SCPostUpdateStaffDetails'
		)
BEGIN
	DROP PROCEDURE ssp_SCPostUpdateStaffDetails
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[ssp_SCPostUpdateStaffDetails] (
	@ScreenKeyId INT
	,@StaffId INT
	,@CurrentUser VARCHAR(30)
	,@CustomParameters XML
	)
AS
/******************************************************************************                    
**  File:                     
**  Name: ssp_SCPostUpdateStaffDetails                    
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
		--Following option is reqd for xml operations                                
		SET ARITHABORT ON

		DECLARE @Flag VARCHAR(250)

		SET @Flag = @CustomParameters.value('(/Root/Parameters/@Flag)[1]', 'varchar(40)')

		IF ISNULL(@Flag,'') = 'RxPermissions'
		BEGIN
			IF OBJECT_ID('tempdb..#StaffRoles') IS NOT NULL
				DROP TABLE #StaffRoles
			CREATE TABLE #StaffRoles (RoleId INT)

			INSERT INTO #StaffRoles (RoleId)
			SELECT DISTINCT RoleId
			FROM StaffRoles
			WHERE StaffId = @ScreenKeyId
				AND ISNULL(RecordDeleted, 'N') = 'N'

			IF OBJECT_ID('tempdb..#SystemActionsAllowed') IS NOT NULL
				DROP TABLE #SystemActionsAllowed
			CREATE TABLE #SystemActionsAllowed (ActionId INT)

			INSERT INTO #SystemActionsAllowed(ActionId)
			SELECT DISTINCT sa.ActionId
			FROM PermissionTemplates pt
			JOIN PermissionTemplateItems pti ON pti.PermissionTemplateId = pt.PermissionTemplateId
			JOIN SystemActions sa ON pti.PermissionItemId = sa.ActionId
			WHERE isnull(pt.RecordDeleted, 'N') = 'N'
				AND isnull(pti.RecordDeleted, 'N') = 'N'
				AND isnull(sa.RecordDeleted, 'N') = 'N'
				AND pt.PermissionTemplateType = 5932
				AND EXISTS(SELECT 1 FROM #StaffRoles SR WHERE SR.RoleId = pt.RoleId)			

			IF OBJECT_ID('tempdb..#SystemActionsDenied') IS NOT NULL
				DROP TABLE #SystemActionsDenied
			CREATE TABLE #SystemActionsDenied (ActionId INT)

			INSERT INTO #SystemActionsDenied (ActionId)
			SELECT DISTINCT sa.ActionId
			FROM SystemActions sa
			WHERE isnull(sa.RecordDeleted, 'N') = 'N'
				AND sa.ApplicationId = 5
				AND sa.ActionId <> 10074
				AND NOT EXISTS (SELECT 1 FROM #SystemActionsAllowed SP WHERE SP.ActionId = sa.ActionId)

			--EPCS permission should not be modified by SC
			DELETE FROM #SystemActionsAllowed WHERe ActionId = 10074
			DELETE FROM #SystemActionsDenied WHERe ActionId = 10074
			

			-------------Grant Permission---------------------------
			IF OBJECT_ID('tempdb..#TempStaffPermissions') IS NOT NULL
				DROP TABLE #TempStaffPermissions
			CREATE TABLE #TempStaffPermissions (StaffId INT,ActionId INT,ModifiedDate DATETIME)

			INSERT INTO #TempStaffPermissions(ActionId,ModifiedDate,StaffId)
			SELECT DISTINCT SA.ActionId,GETDATE(),@ScreenKeyId
			FROM #SystemActionsAllowed SA		

			UPDATE SP
			SET ModifiedDate = TSP.ModifiedDate
				,ModifiedBy = @CurrentUser
			FROM StaffPermissions SP
			JOIN #TempStaffPermissions TSP ON SP.StaffId = TSP.StaffId AND SP.ActionId = TSP.ActionId
			WHERE ISNULL(SP.RecordDeleted, 'N') = 'N'

			INSERT INTO StaffPermissions(StaffId,ActionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowIdentifier)
			SELECT TSP.StaffId,TSP.ActionId,@CurrentUser,TSP.ModifiedDate,@CurrentUser,TSP.ModifiedDate,NEWID()
			FROM #TempStaffPermissions TSP
			WHERE NOT EXISTS (SELECT 1 FROM StaffPermissions SP WHERE SP.ActionId = TSP.ActionId AND SP.StaffId = TSP.StaffId AND ISNULL(SP.RecordDeleted, 'N') = 'N')
			ORDER BY TSP.StaffId
			--------------------------------------------------------


			-------------Deny Permission----------------------------
			IF OBJECT_ID('tempdb..#TempStaffPermissionsDeny') IS NOT NULL
				DROP TABLE #TempStaffPermissionsDeny
			CREATE TABLE #TempStaffPermissionsDeny (StaffId INT,ActionId INT,ModifiedDate DATETIME)

			INSERT INTO #TempStaffPermissionsDeny(ActionId,ModifiedDate,StaffId)
			SELECT DISTINCT SA.ActionId,GETDATE(),@ScreenKeyId
			FROM #SystemActionsDenied SA

			UPDATE SP
			SET DeletedDate = TSP.ModifiedDate
				,DeletedBy = @CurrentUser
				,RecordDeleted = 'Y'
			FROM StaffPermissions SP
			JOIN #TempStaffPermissionsDeny TSP ON SP.StaffId = TSP.StaffId AND SP.ActionId = TSP.ActionId
			WHERE ISNULL(SP.RecordDeleted, 'N') = 'N'
			--------------------------------------------------------			
		END		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCPostUpdateStaffDetails') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                   
				16
				,-- Severity.                                                                                                              
				1 -- State.                                       
				);
	END CATCH
END
