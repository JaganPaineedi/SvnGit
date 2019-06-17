IF NOT EXISTS (
		SELECT Category
		FROM GlobalCodeCategories
		WHERE Category = 'SEXUALORIENTATION'
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
		'SEXUALORIENTATION'
		,'SEXUALORIENTATION'
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
		FROM GlobalCodes
		WHERE CodeName = 'Lesbian, gay or homosexual'
			AND Category = 'SEXUALORIENTATION'
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
		'SEXUALORIENTATION'
		,'Lesbian, gay or homosexual'
		,'Lesbian, gay or homosexual'
		,NULL
		,'Y'
		,'Y'
		,1
		,'38628009'
		)
END
ELSE
BEGIN
	UPDATE GlobalCodes
	SET Category = 'SEXUALORIENTATION'
		,CodeName = 'Lesbian, gay or homosexual'
		,Code = 'Lesbian, gay or homosexual'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 1
		,ExternalCode1 = '38628009'
	WHERE CodeName = 'Lesbian, gay or homosexual'
		AND Category = 'SEXUALORIENTATION'
END

IF NOT EXISTS (
		SELECT *
		FROM GlobalCodes
		WHERE CodeName = 'Straight or heterosexual'
			AND Category = 'SEXUALORIENTATION'
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
		'SEXUALORIENTATION'
		,'Straight or heterosexual'
		,'Straight or heterosexual'
		,NULL
		,'Y'
		,'Y'
		,2
		,'20430005'
		)
END
ELSE
BEGIN
	UPDATE GlobalCodes
	SET Category = 'SEXUALORIENTATION'
		,CodeName = 'Straight or heterosexual'
		,Code = 'Straight or heterosexual'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 2
		,ExternalCode1 = '20430005'
	WHERE CodeName = 'Straight or heterosexual'
		AND Category = 'SEXUALORIENTATION'
END

IF NOT EXISTS (
		SELECT *
		FROM GlobalCodes
		WHERE CodeName = 'Bisexual'
			AND Category = 'SEXUALORIENTATION'
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
		'SEXUALORIENTATION'
		,'Bisexual'
		,'Bisexual'
		,NULL
		,'Y'
		,'Y'
		,3
		,'42035005'
		)
END
ELSE
BEGIN
	UPDATE GlobalCodes
	SET Category = 'SEXUALORIENTATION'
		,CodeName = 'Bisexual'
		,Code = 'Bisexual'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 3
		,ExternalCode1 = '42035005'
	WHERE CodeName = 'Bisexual'
		AND Category = 'SEXUALORIENTATION'
END

IF NOT EXISTS (
		SELECT *
		FROM GlobalCodes
		WHERE CodeName = 'Don’t know'
			AND Category = 'SEXUALORIENTATION'
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
		'SEXUALORIENTATION'
		,'Don’t know'
		,'Don’t know'
		,NULL
		,'Y'
		,'Y'
		,4
		,'UNK'
		)
END
ELSE
BEGIN
	UPDATE GlobalCodes
	SET Category = 'SEXUALORIENTATION'
		,CodeName = 'Don’t know'
		,Code = 'Don’t know'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 4
		,ExternalCode1 = 'UNK'
	WHERE CodeName = 'Don’t know'
		AND Category = 'SEXUALORIENTATION'
END

IF NOT EXISTS (
		SELECT *
		FROM GlobalCodes
		WHERE CodeName = 'Other'
			AND Category = 'SEXUALORIENTATION'
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
		'SEXUALORIENTATION'
		,'Other'
		,'Other'
		,NULL
		,'Y'
		,'Y'
		,5
		,'OTH'
		)
END
ELSE
BEGIN
	UPDATE GlobalCodes
	SET Category = 'SEXUALORIENTATION'
		,CodeName = 'Other'
		,Code = 'Other'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 5
		,ExternalCode1 = 'OTH'
	WHERE CodeName = 'Other'
		AND Category = 'SEXUALORIENTATION'
END