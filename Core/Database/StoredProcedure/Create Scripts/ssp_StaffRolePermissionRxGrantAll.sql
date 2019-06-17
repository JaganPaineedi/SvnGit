IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_StaffRolePermissionRxGrantAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_StaffRolePermissionRxGrantAll]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[ssp_StaffRolePermissionRxGrantAll]
@RoleId INT,    
@PermissionTemplateType INT = null,    
@UserCode VARCHAR(30),
@Mode VARCHAR(30)                     
as                                                
-- ============================================================================================================================   
-- Author      : Akwinass.D 
-- Date        : 26/OCT/2018
-- Purpose     : Grant all rx permissions based on Role
-- Updates:
-- Date			Author    Purpose 
-- 26/OCT/2018  Akwinass  Created.(Task #115 in Renaissance - Current Project Tasks)
-- ============================================================================================================================                                            
  
BEGIN  
   
 BEGIN TRY

  IF (@PermissionTemplateType = 5932 OR ISNULL(@PermissionTemplateType,0) <=0) AND ISNULL(@RoleId,0) > 0
  BEGIN
		IF OBJECT_ID('tempdb..#SystemActions') IS NOT NULL
			DROP TABLE #SystemActions
		CREATE TABLE #SystemActions (ActionId INT,ActionName VARCHAR(250))

		IF OBJECT_ID('tempdb..#TempStaff') IS NOT NULL
			DROP TABLE #TempStaff
		CREATE TABLE #TempStaff (StaffId INT)

		INSERT INTO #SystemActions(ActionId,ActionName)
		SELECT DISTINCT sa.ActionId,sa.[Action]
		FROM SystemActions sa
		WHERE isnull(sa.RecordDeleted, 'N') = 'N'
			AND sa.ApplicationId = 5
			AND sa.ActionId <> 10074

		INSERT INTO #TempStaff(StaffId)
		SELECT DISTINCT StaffId FROM StaffRoles SR WHERE SR.RoleId = CAST(@RoleId AS INT) AND ISNULL(RecordDeleted, 'N') = 'N'

		IF ISNULL(@Mode,'') = 'GrantAll'
		BEGIN
			-------------Grant Permission---------------------------
			IF OBJECT_ID('tempdb..#TempStaffPermissions') IS NOT NULL
				DROP TABLE #TempStaffPermissions
			CREATE TABLE #TempStaffPermissions (StaffId INT,ActionId INT)

			INSERT INTO #TempStaffPermissions(ActionId,StaffId)
			SELECT DISTINCT SA.ActionId,TF.StaffId
			FROM #SystemActions SA
			CROSS JOIN #TempStaff TF
			ORDER BY TF.StaffId

			--EPCS permission should not be modified by SC
			DELETE FROM #TempStaffPermissions WHERe ActionId = 10074

			UPDATE SP
			SET ModifiedDate = GETDATE()
				,ModifiedBy = @UserCode
			FROM StaffPermissions SP
			JOIN #TempStaffPermissions TSP ON SP.StaffId = TSP.StaffId AND SP.ActionId = TSP.ActionId
			WHERE ISNULL(SP.RecordDeleted, 'N') = 'N'

			INSERT INTO StaffPermissions(StaffId,ActionId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RowIdentifier)
			SELECT TSP.StaffId,TSP.ActionId,@UserCode,GETDATE(),@UserCode,GETDATE(),NEWID()
			FROM #TempStaffPermissions TSP
			WHERE NOT EXISTS (SELECT 1 FROM StaffPermissions SP WHERE SP.ActionId = TSP.ActionId AND SP.StaffId = TSP.StaffId AND ISNULL(SP.RecordDeleted, 'N') = 'N')
			ORDER BY TSP.StaffId	
			--------------------------------------------------------
		END

		IF ISNULL(@Mode,'') = 'RemoveAll'
		BEGIN
			-------------Deny Permission----------------------------
			IF OBJECT_ID('tempdb..#TempStaffPermissionsDeny') IS NOT NULL
				DROP TABLE #TempStaffPermissionsDeny
			CREATE TABLE #TempStaffPermissionsDeny (StaffId INT,ActionId INT)

			INSERT INTO #TempStaffPermissionsDeny(ActionId,StaffId)
			SELECT DISTINCT SA.ActionId,TF.StaffId
			FROM #SystemActions SA
			CROSS JOIN #TempStaff TF
			ORDER BY TF.StaffId

			--EPCS permission should not bemodified by SC
			DELETE FROM #TempStaffPermissionsDeny WHERe ActionId = 10074

			UPDATE SP
			SET DeletedDate = GETDATE()
				,DeletedBy = @UserCode
				,RecordDeleted = 'Y'
			FROM StaffPermissions SP
			JOIN #TempStaffPermissionsDeny TSP ON SP.StaffId = TSP.StaffId AND SP.ActionId = TSP.ActionId
			WHERE ISNULL(SP.RecordDeleted, 'N') = 'N'
			--------------------------------------------------------
		END
  END 
 END TRY  
 BEGIN CATCH  
    
  DECLARE @Error varchar(8000)                                
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())   
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_StaffRolePermissionRxGrantAll')   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())    
  + '*****' + Convert(varchar,ERROR_STATE())   
  RAISERROR                                                                                               
  (                                                               
   @Error, -- Message text.   
   16, -- Severity.   
   1 -- State.   
  );      
 END CATCH  
END  