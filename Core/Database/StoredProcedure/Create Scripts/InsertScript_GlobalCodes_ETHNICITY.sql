IF NOT EXISTS (
		SELECT Category
		FROM GlobalCodeCategories
		WHERE Category = 'ETHNICITY'
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
		'ETHNICITY'
		,'ETHNICITY'
		,'Y'
		,'N'
		,'N'
		,'N'
		,NULL
		,'N'
		,'N'
		,'N'
		)
END
GO

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Hispanic or Latino'
			AND Category = 'ETHNICITY'
		)
BEGIN
	INSERT INTO globalcodes (
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
		'ETHNICITY'
		,'Hispanic or Latino'
		,'Hispanic or Latino'
		,NULL
		,'Y'
		,'Y'
		,3
		,'2135-2'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'ETHNICITY'
		,CodeName = 'Hispanic or Latino'
		,Code = 'Hispanic or Latino'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 3
		,ExternalCode1 = '2135-2'
	WHERE CodeName = 'Hispanic or Latino'
		AND Category = 'ETHNICITY'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Not Hispanic or Latino'
			AND Category = 'ETHNICITY'
		)
BEGIN
	INSERT INTO globalcodes (
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
		'ETHNICITY'
		,'Not Hispanic or Latino'
		,'Not Hispanic or Latino'
		,NULL
		,'Y'
		,'Y'
		,1
		,'2186-5'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'ETHNICITY'
		,CodeName = 'Not Hispanic or Latino'
		,Code = 'Not Hispanic or Latino'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 1
		,ExternalCode1 = '2186-5'
	WHERE CodeName = 'Not Hispanic or Latino'
		AND Category = 'ETHNICITY'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Dominican'
			AND Category = 'ETHNICITY'
		)
BEGIN
	INSERT INTO globalcodes (
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
		'ETHNICITY'
		,'Dominican'
		,'Dominican'
		,NULL
		,'Y'
		,'Y'
		,2
		,'2184-0'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'ETHNICITY'
		,CodeName = 'Dominican'
		,Code = 'Dominican'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 2
		,ExternalCode1 = '2184-0'
	WHERE CodeName = 'Dominican'
		AND Category = 'ETHNICITY'
END