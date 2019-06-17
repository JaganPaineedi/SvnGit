IF NOT EXISTS (
		SELECT *
		FROM GlobalCodes
		WHERE CodeName = 'English'
			AND Category = 'LANGUAGE'
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
		)
	VALUES (
		'LANGUAGE'
		,'English'
		,'English'
		,NULL
		,'Y'
		,'Y'
		,1
		,'en'
		)
END
ELSE
BEGIN
	UPDATE GlobalCodes
	SET Category = 'LANGUAGE'
		,CodeName = 'English'
		,Code = 'English'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 1
		,ExternalCode1 = 'en'
	WHERE CodeName = 'English'
		AND Category = 'LANGUAGE'
END

IF NOT EXISTS (
		SELECT *
		FROM GlobalCodes
		WHERE CodeName = 'French'
			AND Category = 'LANGUAGE'
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
		)
	VALUES (
		'LANGUAGE'
		,'French'
		,'French'
		,NULL
		,'Y'
		,'Y'
		,2
		,'fr'
		)
END
ELSE
BEGIN
	UPDATE GlobalCodes
	SET Category = 'LANGUAGE'
		,CodeName = 'French'
		,Code = 'French'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 2
		,ExternalCode1 = 'fr'
	WHERE CodeName = 'French'
		AND Category = 'LANGUAGE'
END

IF NOT EXISTS (
		SELECT *
		FROM GlobalCodes
		WHERE CodeName = 'Spanish'
			AND Category = 'LANGUAGE'
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
		)
	VALUES (
		'LANGUAGE'
		,'Spanish'
		,'Spanish'
		,NULL
		,'Y'
		,'Y'
		,3
		,'es'
		)
END
ELSE
BEGIN
	UPDATE GlobalCodes
	SET Category = 'LANGUAGE'
		,CodeName = 'Spanish'
		,Code = 'Spanish'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 3
		,ExternalCode1 = 'es'
	WHERE CodeName = 'Spanish'
		AND Category = 'LANGUAGE'
END