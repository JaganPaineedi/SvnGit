/****** Object:  StoredProcedure [dbo].[ssp_GetEmergencyAccessScreenInformation]    Script Date: 05-10-2017 10:19:44 ******/
DROP PROCEDURE [dbo].[ssp_GetEmergencyAccessScreenInformation]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetEmergencyAccessScreenInformation]    Script Date: 05-10-2017 10:19:44 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[ssp_GetEmergencyAccessScreenInformation] --92,4002    
	@StaffId INT
	,@RoleId INT
	/********************************************************************************                      
-- Stored Procedure: dbo.ssp_GetEmergencyAccessScreenInformation                        
--                      
-- Copyright: Streamline Healthcate Solutions                      
--                      
-- Purpose: selects staff banners and tabs                      
--                      
-- Updates:                                                                             
-- Date        Author   Purpose                      
-- 05.06.2011  Rohit katoch     Created.                      
                   
                     
*********************************************************************************/
AS
DECLARE @ViewStaffPermissions TABLE (
	staffid INT
	,PermissionTemplateType INT
	,PermissionItemId INT
	)

INSERT INTO @ViewStaffPermissions (
	staffid
	,PermissionTemplateType
	,PermissionItemId
	)
SELECT @StaffId AS staffid
	,PermissionTemplates.PermissionTemplateType AS PermissionTemplateType
	,PermissionTemplateItems.PermissionItemId AS PermissionItemId
FROM PermissionTemplates
INNER JOIN PermissionTemplateItems ON PermissionTemplates.PermissionTemplateId = PermissionTemplateItems.PermissionTemplateId
WHERE RoleId = @RoleId
	AND isnull(PermissionTemplates.RecordDeleted, 'N') = 'N'
	AND ISNULL(PermissionTemplateItems.RecordDeleted, 'N') = 'N'

--select b.BannerId from Banners b inner join   @ViewStaffPermissions  vsp on b.BannerId=vsp.PermissionItemId where vsp.PermissionTemplateType=5703 and b.TabId=1           
DECLARE @ScreenId INT
DECLARE @ScreenType INT

IF EXISTS (
		SELECT 1
		FROM @ViewStaffPermissions
		WHERE PermissionItemId = 1
			AND PermissionTemplateType = 5703
		)
BEGIN
	SET @ScreenId = 1
	SET @ScreenType = 5764
END
ELSE
BEGIN
	SET @ScreenId = (
			SELECT TOP 1 ScreenId
			FROM Banners a
			WHERE EXISTS (
					SELECT TOP 1 *
					FROM @ViewStaffPermissions vsp
					WHERE vsp.PermissionItemId = a.BannerId
						AND vsp.PermissionTemplateType = 5703
						AND a.TabId = 1
					)
			ORDER BY TabId
				,ParentBannerId
				,DefaultOrder
				,DisplayAs
			)
	SET @ScreenType = (
			SELECT screentype
			FROM Screens
			WHERE ScreenId = @ScreenId
			)
END

SELECT @ScreenId AS ScreenId
	,@ScreenType AS ScreenType

GO


