IF NOT EXISTS (
		SELECT Category
		FROM GlobalCodeCategories
		WHERE Category = 'REFRESHTOKENTIMETYPE'
		)
BEGIN
	INSERT INTO GlobalCodeCategories (
		Category
		,CategoryName
		,Active
		,AllowAddDelete
		,AllowCodeNameEdit
		,AllowSortOrderEdit
		,Description
		,UserDefinedCategory
		,HasSubcodes
		,UsedInPracticeManagement
		)
	VALUES (
		'REFRESHTOKENTIMETYPE'
		,'Refresh Token Life Time Type'
		,'Y'
		,'N'
		,'N'
		,'N'
		,NULL
		,'N'
		,'N'
		,'Y'
		)
END

IF NOT EXISTS (
		SELECT GlobalCodeId
		FROM GlobalCodes
		WHERE Category = 'REFRESHTOKENTIMETYPE'
			AND CodeName = 'Day'
			AND Code = 'TOKENLIFETIMEDAY'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		)
	VALUES (
		'REFRESHTOKENTIMETYPE'
		,'Day'
		,'TOKENLIFETIMEDAY'
		,'Day'
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
ELSE
BEGIN
	UPDATE GlobalCodes
	SET CodeName = 'Day'
		,Code = 'TOKENLIFETIMEDAY'
		,Description = 'Day'
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 1
	WHERE Category = 'REFRESHTOKENTIMETYPE'
		AND CodeName = 'Day'
		AND Code = 'TOKENLIFETIMEDAY'
END
GO

IF NOT EXISTS (
		SELECT GlobalCodeId
		FROM GlobalCodes
		WHERE Category = 'REFRESHTOKENTIMETYPE'
			AND CodeName = 'Hour'
			AND Code = 'TOKENLIFETIMEHOUR'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		)
	VALUES (
		'REFRESHTOKENTIMETYPE'
		,'Hour'
		,'TOKENLIFETIMEHOUR'
		,'Hour'
		,'Y'
		,'Y'
		,2
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
ELSE
BEGIN
	UPDATE GlobalCodes
	SET CodeName = 'Hour'
		,Code = 'TOKENLIFETIMEHOUR'
		,Description = 'Hour'
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 2
	WHERE Category = 'REFRESHTOKENTIMETYPE'
		AND CodeName = 'Hour'
		AND Code = 'TOKENLIFETIMEHOUR'
END
GO

IF NOT EXISTS (
		SELECT GlobalCodeId
		FROM GlobalCodes
		WHERE Category = 'REFRESHTOKENTIMETYPE'
			AND CodeName = 'Minute'
			AND Code = 'TOKENLIFETIMEMINUTE'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		)
	VALUES (
		'REFRESHTOKENTIMETYPE'
		,'Minute'
		,'TOKENLIFETIMEMINUTE'
		,'Minute'
		,'Y'
		,'Y'
		,3
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
ELSE
BEGIN
	UPDATE GlobalCodes
	SET CodeName = 'Minute'
		,Code = 'TOKENLIFETIMEMINUTE'
		,Description = 'Minute'
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 3
	WHERE Category = 'REFRESHTOKENTIMETYPE'
		AND CodeName = 'Minute'
		AND Code = 'TOKENLIFETIMEMINUTE'
END
GO