
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'ResultsReviewComment'
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
		'ResultsReviewComment'
		,'ResultsReviewComment'
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		,'N'
		,'N'
		)
END