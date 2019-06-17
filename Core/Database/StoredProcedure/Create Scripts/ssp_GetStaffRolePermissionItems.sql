IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetStaffRolePermissionItems]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetStaffRolePermissionItems]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/***********************************************************************************************************************                          
-- Stored Procedure: dbo.ssp_GetStaffRolePermissionItems                            
--                          
-- Copyright: Streamline Healthcate Solutions                          
--                          
-- Purpose: gets staff role permission items for Role Definition tab                       
--                          
-- Updates:                                                                                 
-- Date        Author      Purpose                          
-- 07.06.2010  SFarber     Created.           
-- 07.12.2010  SFarber     Added audit columns.   
-- 24.09.2010  Shifali	   Added Tables PermissionTemplates and PermissionTemplateItems 		
-- 06.12.2011  SFarber     Modified to set PermissionTemplateId if not set
-- 06.11.2012  Rakesh      Set the varchar(500) for column PermissionItemName,ParentName and PermissionTemplateTypeName   
-- 06.26.2015  Wasif Butt  Limit PermissionTemplateItems based on @PermissionTemplateType 
-- 10.06.2016  Akwinass    Included #PermissionTemplateItems to return respective PermissionTemplates and 
--						   PermissionTemplateItems (Task #1019 in Philhaven Testing Issues)
-- 01.12.2017  tmu		   Modified to use #PermissionItems instead of @PermissionItems, as per Philhaven #122
-- 26.12.2018  Venkatesh   Added parameter PermissionItemName to get the Permission Items based on Permission Item Name. Ref Task: Engineering Improvement Initiatives- NBL(I) #449.1
***********************************************************************************************************************/

CREATE PROCEDURE [dbo].[ssp_GetStaffRolePermissionItems] 
	@RoleId INT
	,@PermissionTemplateType INT
	,@ParentId INT = NULL
	,@PermissionStatus CHAR(1) = NULL -- 'G' - granted, 'D' - Denied, NULL - all  
	,@PermissionItemName VARCHAR(100)=''    
AS
BEGIN
	BEGIN TRY
		IF ISNULL(@PermissionStatus, '') <> 'G'
			AND ISNULL(@PermissionStatus, '') <> 'D'
			SET @PermissionStatus = NULL

		-- tmu modification here =======================================================================================
		-- Modified from table variable to temporary table to improve performance as per Philhaven Support #122
		CREATE TABLE #PermissionItems 
		(
			PermissionTemplateType INT
			,PermissionTemplateTypeName VARCHAR(500)
			,PermissionItemId INT
			,PermissionItemName VARCHAR(500)
			,ParentId INT
			,ParentName VARCHAR(500)
			,Denied CHAR(1)
			,Granted CHAR(1)
			,PermissionTemplateItemId INT
			,PermissionTemplateId INT
		)

		-- Get all available permission items    
		INSERT INTO #PermissionItems 
		(
			PermissionTemplateType
			,PermissionTemplateTypeName
			,PermissionItemId
			,PermissionItemName
			,ParentId
			,ParentName
		)
		EXEC ssp_GetPermissionItems @PermissionTemplateType = NULL

		-- Everything is denied by default    
		UPDATE #PermissionItems
		SET Granted = 'N', Denied = 'Y'

		-- Apply role permissions    
		UPDATE pit
		SET Granted = 'Y'
			,Denied = 'N'
			,PermissionTemplateItemId = pti.PermissionTemplateItemId
			,PermissionTemplateId = pt.PermissionTemplateId
		FROM #PermissionItems pit
		JOIN PermissionTemplates pt ON pt.PermissionTemplateType = pit.PermissionTemplateType
		JOIN PermissionTemplateItems pti ON pti.PermissionTemplateId = pt.PermissionTemplateId
			AND pti.PermissionItemId = pit.PermissionItemId
		WHERE pt.RoleId = @RoleId
			AND isnull(pt.RecordDeleted, 'N') = 'N'
			AND isnull(pti.RecordDeleted, 'N') = 'N'

		-- Set PermissionTemplateId if not set
		UPDATE pit
		SET PermissionTemplateId = pt.PermissionTemplateId
		FROM #PermissionItems pit
		JOIN PermissionTemplates pt ON pt.PermissionTemplateType = pit.PermissionTemplateType
		WHERE pt.RoleId = @RoleId
			AND pit.PermissionTemplateId IS NULL
			AND isnull(pt.RecordDeleted, 'N') = 'N'

		-- 10.06.2016  Akwinass   
		IF OBJECT_ID('tempdb..#PermissionTemplateItems') IS NOT NULL
			DROP TABLE #PermissionTemplateItems

		CREATE TABLE #PermissionTemplateItems (
			PermissionTemplateType INT
			,PermissionTemplateTypeName VARCHAR(5000)
			,PermissionItemId INT
			,PermissionItemName VARCHAR(5000)
			,ParentId INT
			,ParentName VARCHAR(5000)
			,Denied CHAR(1)
			,Granted CHAR(1)
			,PermissionTemplateItemId INT
			,PermissionTemplateId INT
			,RowIdentifier UNIQUEIDENTIFIER NOT NULL
			,CreatedBy VARCHAR(30)
			,CreatedDate DATETIME
			,ModifiedBy VARCHAR(30)
			,ModifiedDate DATETIME
			,RecordDeleted CHAR(1)
			,DeletedDate DATETIME
			,DeletedBy VARCHAR(30)
			)

		-- Main select 
		INSERT INTO #PermissionTemplateItems -- 10.06.2016  Akwinass
		SELECT pit.PermissionTemplateType
			,pit.PermissionTemplateTypeName
			,pit.PermissionItemId
			,pit.PermissionItemName
			,pit.ParentId
			,pit.ParentName
			,pit.Denied
			,pit.Granted
			,CASE 
				WHEN pit.PermissionTemplateItemId IS NULL
					THEN convert(INT, 0 - row_number() OVER (
								ORDER BY pit.PermissionTemplateItemId DESC
								))
				ELSE pit.PermissionTemplateItemId
				END AS PermissionTemplateItemId
			,pit.PermissionTemplateId
			,ISNULL(pti.RowIdentifier, NEWID()) AS RowIdentifier
			,ISNULL(pti.CreatedBy, 'shc') AS CreatedBy
			,ISNULL(pti.CreatedDate, GETDATE()) AS CreatedDate
			,ISNULL(pti.ModifiedBy, 'SHC') AS ModifiedBy
			,ISNULL(pti.ModifiedDate, GETDATE()) AS ModifiedDate
			,pti.RecordDeleted
			,pti.DeletedDate
			,pti.DeletedBy
		FROM #PermissionItems pit
		LEFT JOIN PermissionTemplateItems pti ON pti.PermissionTemplateItemId = pit.PermissionTemplateItemId
		WHERE 
		       (@PermissionItemName='' OR @PermissionItemName=NULL  OR (pit.PermissionItemName like '%'+@PermissionItemName+'%' or pit.PermissionItemName like '%'+@PermissionItemName+'%'))    
			AND
				(
				pit.PermissionTemplateType = @PermissionTemplateType
				OR @PermissionTemplateType IS NULL
				)
			AND (
				pit.ParentId = @ParentId
				OR @ParentId IS NULL
				)
			AND (
				(
					pit.Granted = 'Y'
					AND @PermissionStatus = 'G'
					)
				OR (
					pit.Denied = 'Y'
					AND @PermissionStatus = 'D'
					)
				OR @PermissionStatus IS NULL
				)
		ORDER BY pit.PermissionTemplateTypeName
			,pit.ParentName
			,pit.PermissionItemName

		SELECT PermissionTemplateType
			,PermissionTemplateTypeName
			,PermissionItemId
			,PermissionItemName
			,ParentId
			,ParentName
			,Denied
			,Granted
			,PermissionTemplateItemId
			,PermissionTemplateId
			,RowIdentifier
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
		FROM #PermissionTemplateItems

		--PermissionTemplates--              
		SELECT PT.PermissionTemplateId
			,PT.RoleId
			,PT.PermissionTemplateType
			,PT.RowIdentifier
			,PT.CreatedBy
			,PT.CreatedDate
			,PT.ModifiedBy
			,PT.ModifiedDate
			,PT.RecordDeleted
			,PT.DeletedDate
			,PT.DeletedBy
		FROM PermissionTemplates PT
		WHERE isnull(PT.RecordDeleted, 'N') <> 'Y'
			AND PT.RoleId = @RoleId
			-- 10.06.2016  Akwinass
			AND EXISTS (
				SELECT 1
				FROM #PermissionTemplateItems PTI
				WHERE PTI.PermissionTemplateId = PT.PermissionTemplateId
				)

		--PermissionTemplateItems--              
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
		WHERE isnull(PTI.RecordDeleted, 'N') <> 'Y'
			-- 10.06.2016  Akwinass
			AND EXISTS (
				SELECT 1
				FROM #PermissionTemplateItems TPTI
				WHERE TPTI.PermissionTemplateId = PTI.PermissionTemplateId
					AND TPTI.PermissionItemId = PTI.PermissionItemId
				)
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetStaffRolePermissionItems') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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
