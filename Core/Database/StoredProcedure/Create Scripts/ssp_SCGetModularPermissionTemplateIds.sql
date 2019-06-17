IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetModularPermissionTemplateIds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetModularPermissionTemplateIds]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/********************************************************************************                                                  
-- Stored Procedure: dbo.ssp_SCGetModularPermissionTemplateIds                                                 
--                                                  
-- Copyright: Streamline Healthcate Solutions                                                  
--                                                  
-- Purpose: used by 'Manage Roles & Modules' Details.                                                  
--                                                  
-- Updates:                                                                                                         
-- Date			 Author          Purpose                                                  
-- 31.JULY.2017	 Akwinass        Created(Engineering Improvement Initiatives- NBL(I) #561 .       
*********************************************************************************/
CREATE PROCEDURE [dbo].[ssp_SCGetModularPermissionTemplateIds]
@RoleIds VARCHAR(MAX),
@TemplateItemIds VARCHAR(MAX)
AS
BEGIN
	BEGIN TRY
		IF OBJECT_ID('tempdb..#Roles') IS NOT NULL
			DROP TABLE #Roles
		CREATE TABLE #Roles (RoleId INT)
		
		IF OBJECT_ID('tempdb..#TemplateItems') IS NOT NULL
			DROP TABLE #TemplateItems
		CREATE TABLE #TemplateItems (PermissionTemplateItemId INT)

		INSERT INTO #Roles (RoleId)
		SELECT CAST(item AS INT)
		FROM dbo.fnSplit(@RoleIds, ',') 
		WHERE ISNULL(item, '') <> ''
		
		INSERT INTO #TemplateItems (PermissionTemplateItemId)
		SELECT CAST(item AS INT)
		FROM dbo.fnSplit(@TemplateItemIds, ',') 
		WHERE ISNULL(item, '') <> ''
		
		SELECT PermissionTemplateId
			,RoleId
			,PermissionTemplateType
			,RowIdentifier
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
		FROM PermissionTemplates PT
		WHERE PT.PermissionTemplateType IN (5921,5701,5920,5703)
			AND ISNULL(PT.RecordDeleted, 'N') = 'N'
			AND EXISTS (
					SELECT 1
					FROM #Roles TmpR
					WHERE TmpR.RoleId = PT.RoleId
					)
			
		SELECT PTI.PermissionTemplateItemId
			,PTI.PermissionTemplateId
			,PTI.PermissionItemId
			,PTI.RowIdentifier
			,PTI.CreatedBy
			,PTI.CreatedDate
			,PTI.ModifiedBy
			,PTI.ModifiedDate
			,PTI.RecordDeleted
			,PTI.DeletedDate
			,PTI.DeletedBy
		FROM PermissionTemplateItems PTI
		JOIN PermissionTemplates PT ON PT.PermissionTemplateId = PTI.PermissionTemplateId
			AND ISNULL(PT.RecordDeleted, 'N') = 'N'
		WHERE ISNULL(PTI.RecordDeleted, 'N') = 'N'
			AND PT.PermissionTemplateType IN (5921,5701,5920,5703)
			AND EXISTS (
				SELECT 1
				FROM #TemplateItems TmpTI
				WHERE TmpTI.PermissionTemplateItemId = PTI.PermissionTemplateItemId
				)


	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_SCGetModularPermissionTemplateIds') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

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


