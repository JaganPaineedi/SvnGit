IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE CategoryName = 'ExtCollectionOther'
			AND Category = 'ExtCollectionOther'
		)
BEGIN
	INSERT INTO GlobalCodeCategories (
		Category
		,CategoryName
		,Active
		,AllowAddDelete
		,AllowCodeNameEdit
		,AllowSortOrderEdit
		,[Description]
		,UserDefinedCategory
		,HasSubcodes
		,UsedInPracticeManagement
		)
	VALUES (
		'ExtCollectionOther'
		,'ExtCollectionOther'
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		,NULL
		,'N'
		,'N'
		,'Y'
		)
END


