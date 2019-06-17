IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PostUpdateRoleDefinition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PostUpdateRoleDefinition]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create proc [dbo].[ssp_PostUpdateRoleDefinition]                                                 
                  
@ScreenKeyId int,                  
@StaffId int,                  
@CurrentUser varchar(30),                  
@CustomParameters xml                   
as                                                
/*********************************************************************/                                                
/* Stored Procedure: dbo.ssp_PostUpdateRoleDefinition                         */                                                
/* Creation Date:    24/09/2010                                         */                                                
/*                                                                   */                                                
/* Purpose:           */                                                
/*                                                                   */                                                 
/* Input Parameters:           */                                                
/*                                                                   */                                                
/* Output Parameters:                                                */                                                
/*                                                                   */                                                
/* Return Status:                                                    */                                                
/*                                                                   */                                                
/* Called By:       */                                                
/*                                                                   */                                                
/* Calls:                                                            */                                                
/*                                                                   */                                                
/* Data Modifications:                                               */                                                
/*                                                                   */                                                
/* Updates:                                                          */                                                
/*   Date                   Author      Purpose                                    */                                                 
/*  24/09/2010              Shifali     Created                                    */    
/*  05/11/2015              Md Khusro   Replace ModifiedBy and ModifiedDate columns with DeletedBy and DeletedDate for Record Deleted condition
    8/16/2017               Hemant      Included the RecordDeleted Check for GlobalCodes table.
                                        Network180 Support Go Live #307
    SEP.27.2018             Akwinass    What: Added Rx Permissions
										Why: #21 Renaissance - Dev Items
*/                                              
                                                                             
/*********************************************************************/                                             
  
BEGIN  
   
 Begin TRY     
    
  --Following option is reqd for xml operations                
  SET ARITHABORT ON   
  Declare @RoleAction varchar(10)    
  --set @RoleAction = @CustomParameters.value('(/Root/Parameters/@RoleAction)[1]', 'varchar(10)' )               
  SELECT @RoleAction= T.c.query('RoleAction').value('.','VARCHAR(20)') FROM   @CustomParameters.nodes('/Root')  T(c)  
  
  IF(@RoleAction = 'ADDROLE')  
  BEGIN  
   
   Insert into PermissionTemplates   
   (PermissionTemplateType,  
   RoleId,  
   CreatedBy,  
   ModifiedBy)  
   Select  
   GlobalCodeId,  
   @ScreenKeyId,  
   @CurrentUser,  
   @CurrentUser  
   From GlobalCodes  
   Where Category = 'PERMISSIONTEMPLATETP' 
   AND IsNull(RecordDeleted, 'N') = 'N'
   AND Active = 'Y' 
    
  END  
   
  ELSE IF (@RoleAction = 'DeleteRole')  
  BEGIN  
   
   Update PermissionTemplateItems  
   set RecordDeleted='Y',  
   DeletedBy=@CurrentUser,  
   DeletedDate=GETDATE()  
   Where PermissionItemId   
   in  
   (Select PermissionTemplateId from PermissionTemplates  
   Where RoleId=@ScreenKeyId)  
        
   Update PermissionTemplates  
   set RecordDeleted='Y',  
   DeletedBy=@CurrentUser,  
   DeletedDate=GETDATE()  
   Where RoleId = @ScreenKeyId  
    
  END  

  --SEP.27.2018 Akwinass
  DECLARE @RoleId VARCHAR(250)
  DECLARE @PermissionTemplateType VARCHAR(250)
  DECLARE @UnsavedDateTime VARCHAR(250)
  SET @RoleId = @CustomParameters.value('(/Root/Parameters/@RoleId)[1]', 'VARCHAR(250)') 
  SET @PermissionTemplateType = @CustomParameters.value('(/Root/Parameters/@PermissionTemplateType)[1]', 'VARCHAR(250)')
  SET @UnsavedDateTime = @CustomParameters.value('(/Root/Parameters/@UnsavedDateTime)[1]', 'VARCHAR(250)')
  
  IF @PermissionTemplateType = '5932' AND ISNUMERIC(@RoleId) = 1
  BEGIN
		IF OBJECT_ID('tempdb..#SystemActionsAllowed') IS NOT NULL
			DROP TABLE #SystemActionsAllowed
		CREATE TABLE #SystemActionsAllowed (ActionId INT,ActionName VARCHAR(250), ModifiedDate DATETIME)

		IF OBJECT_ID('tempdb..#SystemActionsDenied') IS NOT NULL
			DROP TABLE #SystemActionsDenied
		CREATE TABLE #SystemActionsDenied (ActionId INT,ActionName VARCHAR(250), ModifiedDate DATETIME)

		IF OBJECT_ID('tempdb..#TempStaff') IS NOT NULL
			DROP TABLE #TempStaff
		CREATE TABLE #TempStaff (StaffId INT)

		INSERT INTO #SystemActionsAllowed(ActionId,ActionName,ModifiedDate)
		SELECT DISTINCT sa.ActionId,sa.[Action],pti.ModifiedDate
		FROM PermissionTemplates pt
		JOIN PermissionTemplateItems pti ON pti.PermissionTemplateId = pt.PermissionTemplateId
		JOIN SystemActions sa ON pti.PermissionItemId = sa.ActionId
		WHERE isnull(pt.RecordDeleted, 'N') = 'N'
			AND isnull(pti.RecordDeleted, 'N') = 'N'
			AND isnull(sa.RecordDeleted, 'N') = 'N'
			AND pt.PermissionTemplateType = 5932
			AND pt.RoleId = CAST(@RoleId AS INT)
			AND pti.ModifiedDate >= CAST(@UnsavedDateTime AS DATETIME)
			AND pti.ModifiedBy = @CurrentUser

		INSERT INTO #SystemActionsDenied(ActionId,ActionName,ModifiedDate)
		SELECT DISTINCT sa.ActionId,sa.[Action],pti.DeletedDate
		FROM PermissionTemplates pt
		JOIN PermissionTemplateItems pti ON pti.PermissionTemplateId = pt.PermissionTemplateId
		JOIN SystemActions sa ON pti.PermissionItemId = sa.ActionId
		WHERE isnull(pt.RecordDeleted, 'N') = 'N'
			AND isnull(pti.RecordDeleted, 'N') = 'Y'
			AND isnull(sa.RecordDeleted, 'N') = 'N'
			AND pt.PermissionTemplateType = 5932
			AND pt.RoleId = CAST(@RoleId AS INT)
			AND pti.DeletedDate >= CAST(@UnsavedDateTime AS DATETIME)
			AND pti.DeletedBy = @CurrentUser

       
		DELETE A
		FROM #SystemActionsAllowed A
		JOIN #SystemActionsDenied D ON A.ActionId = D.ActionId
		WHERE A.ModifiedDate < D.ModifiedDate

		DELETE D
		FROM #SystemActionsDenied D
		JOIN #SystemActionsAllowed A ON D.ActionId = A.ActionId
		WHERE D.ModifiedDate < A.ModifiedDate

		INSERT INTO #TempStaff(StaffId)
		SELECT DISTINCT StaffId FROM StaffRoles SR WHERE SR.RoleId = CAST(@RoleId AS INT) AND ISNULL(RecordDeleted, 'N') = 'N'

		-------------Grant Permission---------------------------
		IF OBJECT_ID('tempdb..#TempStaffPermissions') IS NOT NULL
			DROP TABLE #TempStaffPermissions
		CREATE TABLE #TempStaffPermissions (StaffId INT,ActionId INT,ModifiedDate DATETIME)

		INSERT INTO #TempStaffPermissions(ActionId,ModifiedDate,StaffId)
		SELECT DISTINCT SA.ActionId,SA.ModifiedDate,TF.StaffId
		FROM #SystemActionsAllowed SA
		CROSS JOIN #TempStaff TF
		ORDER BY TF.StaffId

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
		SELECT DISTINCT SA.ActionId,SA.ModifiedDate,TF.StaffId
		FROM #SystemActionsDenied SA
		CROSS JOIN #TempStaff TF
		ORDER BY TF.StaffId

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
    
  DECLARE @Error varchar(8000)                                
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())   
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_PostUpdateRoleDefinition')   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())    
  + '*****' + Convert(varchar,ERROR_STATE())   
  RAISERROR                                                                                               
  (                                                               
   @Error, -- Message text.   
   16, -- Severity.   
   1 -- State.   
  );      
 END CATCH  
END  