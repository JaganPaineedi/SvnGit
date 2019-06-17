IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'ServicesActionItems'
		)
BEGIN
	INSERT INTO [GlobalCodeCategories] (
		Category
		,CategoryName
		,Active
		,AllowAddDelete
		,AllowCodeNameEdit
		,AllowSortOrderEdit
		,UserDefinedCategory
		,HasSubcodes
		)
	VALUES (
		'ServicesActionItems'
		,'ServicesActionItems'
		,'Y'
		,'N'
		,'N'
		,'N'
		,'N'
		,'N'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ServicesActionItems'
			AND CodeName = 'Error'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ServicesActionItems'
		,'Error'
		,'Error'
		,'Y'
		,'N'
		,1
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ServicesActionItems'
			AND CodeName = 'Error, Copy and Move Note'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ServicesActionItems'
		,'Error, Copy and Move Note'
		,'Error, Copy and Move Note'
		,'Y'
		,'N'
		,2
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ServicesActionItems'
			AND CodeName = 'Generate Bundled Service'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ServicesActionItems'
		,'Generate Bundled Service'
		,'Generate Bundled Service'
		,'Y'
		,'N'
		,3
		)
END
