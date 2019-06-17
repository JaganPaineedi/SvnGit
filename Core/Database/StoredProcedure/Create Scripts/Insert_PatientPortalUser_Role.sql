-- Now insert data in all related staff permission tables
IF NOT EXISTS (
		SELECT GlobalCodeId
		FROM GlobalCodes
		WHERE Category = 'STAFFROLE'
			AND CodeName = 'PATIENTPORTALUSER'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'STAFFROLE'
		,'PATIENTPORTALUSER'
		,'PATIENTPORTALUSER'
		,NULL
		,'Y'
		,'Y'
		,NULL
		,'CLIENTSTAFF'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END

BEGIN
	DECLARE @PatientPortalRoleId INT

	SELECT TOP 1 @PatientPortalRoleId = GlobalCodeId
	FROM GlobalCodes
	WHERE Category = 'STAFFROLE'
		AND CodeName = 'PATIENTPORTALUSER'
		AND ISNULL(RecordDeleted, 'N') = 'N'

	UPDATE BANNERS
	SET Active = 'Y'
	WHERE ScreenId IN (
			5
			,13
			,45
			,715
			,718
			,721
			,775
			,973
			,977
			,985
			,984
			)

	-- Insert into PermissionTemplates
	INSERT INTO PermissionTemplates (
		RoleId
		,PermissionTemplateType
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		)
	SELECT @PatientPortalRoleId
		,G.GlobalCodeId
		,'SHSDBA'
		,GetDate()
		,'SHSDBA'
		,GetDate()
	FROM GlobalCodes G
	WHERE G.Category = 'PERMISSIONTEMPLATETP'
		AND ISNULL(G.RecordDeleted, 'N') = 'N'
		AND NOT EXISTS (
			SELECT 1
			FROM PermissionTemplates SR
			WHERE SR.PermissionTemplateType = G.GlobalCodeId
				AND SR.RoleId = @PatientPortalRoleId
				AND ISNULL(SR.RecordDeleted, 'N') = 'N'
			)

	DECLARE @PermissionTemplateId INT

	SELECT TOP 1 @PermissionTemplateId = PermissionTemplateId
	FROM PermissionTemplates
	WHERE RoleId = @PatientPortalRoleId
		AND PermissionTemplateType = 5703
		AND ISNULL(RecordDeleted, 'N') = 'N'

	-- Insert into PermissionTemplateItems for Banners
	INSERT INTO PermissionTemplateItems (
		PermissionTemplateId
		,PermissionItemId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		)
	SELECT @PermissionTemplateId
		,B.BannerId
		,'SHSDBA'
		,GetDate()
		,'SHSDBA'
		,GetDate()
	FROM Banners B
	WHERE B.ScreenId IN (
			5
			,13
			,45
			,715
			,718
			,721
			,775
			,973
			,977
			,985
			,984
			)
		AND isnull(B.RecordDeleted, 'N') = 'N'
		AND B.Active = 'Y'
		AND NOT EXISTS (
			SELECT 1
			FROM PermissionTemplateItems SR
			WHERE SR.PermissionTemplateId = @PermissionTemplateId
				AND SR.PermissionItemId = B.BannerId
				AND B.ScreenId IN (
					5
					,13
					,45
					,715
					,718
					,721
					,775
					,973
					,977
					,985
					,984
					)
				AND ISNULL(SR.RecordDeleted, 'N') = 'N'
			)

	SELECT TOP 1 @PermissionTemplateId = PermissionTemplateId
	FROM PermissionTemplates
	WHERE RoleId = @PatientPortalRoleId
		AND PermissionTemplateType = 5702
		AND ISNULL(RecordDeleted, 'N') = 'N'

	-- Insert into PermissionTemplateItems for DocumentCodes
	INSERT INTO PermissionTemplateItems (
		PermissionTemplateId
		,PermissionItemId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		)
	SELECT @PermissionTemplateId
		,B.DocumentCodeId
		,'SHSDBA'
		,GetDate()
		,'SHSDBA'
		,GetDate()
	FROM DocumentCodes B
	WHERE B.DocumentCodeId = 5
		AND isnull(B.RecordDeleted, 'N') = 'N'
		AND NOT EXISTS (
			SELECT 1
			FROM PermissionTemplateItems SR
			WHERE SR.PermissionTemplateId = @PermissionTemplateId
				AND SR.PermissionItemId = B.DocumentCodeId
				AND ISNULL(SR.RecordDeleted, 'N') = 'N'
			)
END
