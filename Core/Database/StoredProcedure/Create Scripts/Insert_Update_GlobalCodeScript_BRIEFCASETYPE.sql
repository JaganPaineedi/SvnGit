IF NOT EXISTS (
		SELECT Category
		FROM GlobalCodeCategories
		WHERE Category = 'BRIEFCASETYPE'
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
		'BRIEFCASETYPE'
		,'Briefcase Type'
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
		WHERE Category = 'BRIEFCASETYPE'
			AND CodeName = 'Service'
			AND Code = 'SERVICE'
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
		'BRIEFCASETYPE'
		,'Service'
		,'SERVICE'
		,'Service'
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
	SET CodeName = 'Service'
		,Code = 'SERVICE'
		,Description = 'Service'
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 1
	WHERE Category = 'BRIEFCASETYPE'
		AND CodeName = 'Service'
		AND Code = 'SERVICE'
END
GO

IF NOT EXISTS (
		SELECT GlobalCodeId
		FROM GlobalCodes
		WHERE Category = 'BRIEFCASETYPE'
			AND CodeName = 'My Preference'
			AND Code = 'MYPREFERENCE'
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
		'BRIEFCASETYPE'
		,'My Preference'
		,'MYPREFERENCE'
		,'My Preference'
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
	SET CodeName = 'My Preference'
		,Code = 'MYPREFERENCE'
		,Description = 'My Preference'
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 2
	WHERE Category = 'BRIEFCASETYPE'
		AND CodeName = 'My Preference'
		AND Code = 'MYPREFERENCE'
END
GO

IF NOT EXISTS (
		SELECT GlobalCodeId
		FROM GlobalCodes
		WHERE Category = 'BRIEFCASETYPE'
			AND CodeName = 'Appointment'
			AND Code = 'APPOINTMENT'
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
		'BRIEFCASETYPE'
		,'Appointment'
		,'APPOINTMENT'
		,'Appointment'
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
	SET CodeName = 'Appointment'
		,Code = 'APPOINTMENT'
		,Description = 'Appointment'
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 3
	WHERE Category = 'BRIEFCASETYPE'
		AND CodeName = 'Appointment'
		AND Code = 'APPOINTMENT'
END
GO