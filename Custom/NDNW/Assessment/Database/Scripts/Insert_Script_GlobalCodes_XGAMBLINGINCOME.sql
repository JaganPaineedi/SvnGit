/* Category :XGAMBLINGINCOME  */
/*Insert Into GlobalCodes */
/*Insert Into GlobalCodeCategories */

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'XGAMBLINGINCOME'
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
		'XGAMBLINGINCOME'
		,'XGAMBLINGINCOME'
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		,'N'
		,'N'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XGAMBLINGINCOME'
			AND CodeName = '1-Wages,Salary'
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
		'XGAMBLINGINCOME'
		,'1-Wages,Salary'
		,'1-Wages,Salary'
		,'Y'
		,'N'
		,1
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XGAMBLINGINCOME'
			AND CodeName = '5-Public Assistance'
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
		'XGAMBLINGINCOME'
		,'5-Public Assistance'
		,'5-Public Assistance'
		,'Y'
		,'N'
		,2
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XGAMBLINGINCOME'
			AND CodeName = '7-Pension'
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
		'XGAMBLINGINCOME'
		,'7-Pension'
		,'7-Pension'
		,'Y'
		,'N'
		,3
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XGAMBLINGINCOME'
			AND CodeName = '9-Other'
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
		'XGAMBLINGINCOME'
		,'9-Other'
		,'9-Other'
		,'Y'
		,'N'
		,4
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XGAMBLINGINCOME'
			AND CodeName = '0-None'
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
		'XGAMBLINGINCOME'
		,'0-None'
		,'0-None'
		,'Y'
		,'N'
		,5
		)
END

