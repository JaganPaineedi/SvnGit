IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_StaffRolePermissionRxCopy]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_StaffRolePermissionRxCopy]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[ssp_StaffRolePermissionRxCopy]
@RoleIdTo INT,  
@RoleIdFrom INT,  
@PermissionTemplateType INT = null,    
@UserCode VARCHAR(30)                
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
	IF (@PermissionTemplateType = 5932 OR ISNULL(@PermissionTemplateType,0) <=0) AND ISNULL(@RoleIdTo,0) > 0 AND ISNULL(@RoleIdFrom,0) > 0
	BEGIN
		IF OBJECT_ID('tempdb..#SystemActionsAllowed') IS NOT NULL
			DROP TABLE #SystemActionsAllowed
		CREATE TABLE #SystemActionsAllowed (ActionId INT,ActionName VARCHAR(250))

		IF OBJECT_ID('tempdb..#SystemActionsDenied') IS NOT NULL
			DROP TABLE #SystemActionsDenied
		CREATE TABLE #SystemActionsDenied (ActionId INT,ActionName VARCHAR(250))

		IF OBJECT_ID('tempdb..#TempStaff') IS NOT NULL
			DROP TABLE #TempStaff
		CREATE TABLE #TempStaff (StaffId INT)

		INSERT INTO #SystemActionsAllowed(ActionId,ActionName)
		SELECT DISTINCT sa.ActionId,sa.[Action]
		FROM PermissionTemplates pt
		JOIN PermissionTemplateItems pti ON pti.PermissionTemplateId = pt.PermissionTemplateId
		JOIN SystemActions sa ON pti.PermissionItemId = sa.ActionId
		WHERE isnull(pt.RecordDeleted, 'N') = 'N'
			AND isnull(pti.RecordDeleted, 'N') = 'N'
			AND isnull(sa.RecordDeleted, 'N') = 'N'
			AND pt.PermissionTemplateType = 5932
			AND pt.RoleId = CAST(@RoleIdFrom AS INT)

		INSERT INTO #TempStaff(StaffId)
		SELECT DISTINCT StaffId FROM StaffRoles SR WHERE SR.RoleId = CAST(@RoleIdTo AS INT) AND ISNULL(RecordDeleted, 'N') = 'N'

		-------------Grant Permission---------------------------
		IF OBJECT_ID('tempdb..#TempStaffPermissions') IS NOT NULL
			DROP TABLE #TempStaffPermissions
		CREATE TABLE #TempStaffPermissions (StaffId INT,ActionId INT)

		INSERT INTO #TempStaffPermissions(ActionId,StaffId)
		SELECT DISTINCT SA.ActionId,TF.StaffId
		FROM #SystemActionsAllowed SA
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
 END TRY  
 BEGIN CATCH  
    
  DECLARE @Error varchar(8000)                                
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())   
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_StaffRolePermissionRxCopy')   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())    
  + '*****' + Convert(varchar,ERROR_STATE())   
  RAISERROR                                                                                               
  (                                                               
   @Error, -- Message text.   
   16, -- Severity.   
   1 -- State.   
  );      
 END CATCH  
END  