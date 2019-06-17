/* Category :  */
/*Insert Into GlobalCodes */
/*Insert Into GlobalCodeCategories */

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'XGAMBLINGINSURANCE'
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
		'XGAMBLINGINSURANCE'
		,'XGAMBLINGINSURANCE'
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
		WHERE Category = 'XGAMBLINGINSURANCE'
			AND CodeName = '05-Veterans Administration'
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
		'XGAMBLINGINSURANCE'
		,'05-Veterans Administration'
		,'05-Veterans Administration'
		,'Y'
		,'N'
		,1
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XGAMBLINGINSURANCE'
			AND CodeName = '08-Medicaid/OHP'
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
		'XGAMBLINGINSURANCE'
		,'08-Medicaid/OHP'
		,'08-Medicaid/OHP'
		,'Y'
		,'N'
		,2
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XGAMBLINGINSURANCE'
			AND CodeName = '09-Medicare'
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
		'XGAMBLINGINSURANCE'
		,'09-Medicare'
		,'09-Medicare'
		,'Y'
		,'N'
		,3
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XGAMBLINGINSURANCE'
			AND CodeName = '11-Other Private Insurance'
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
		'XGAMBLINGINSURANCE'
		,'11-Other Private Insurance'
		,'11-Other Private Insurance'
		,'Y'
		,'N'
		,4
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XGAMBLINGINSURANCE'
			AND CodeName = '12-Other Public Assistance'
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
		'XGAMBLINGINSURANCE'
		,'12-Other Public Assistance'
		,'12-Other Public Assistance'
		,'Y'
		,'N'
		,5
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XGAMBLINGINSURANCE'
			AND CodeName = '65-OMHAS/AMH'
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
		'XGAMBLINGINSURANCE'
		,'65-OMHAS/AMH'
		,'65-OMHAS/AMH'
		,'Y'
		,'N'
		,6
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XGAMBLINGINSURANCE'
			AND CodeName = '66-State/County Corrections'
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
		'XGAMBLINGINSURANCE'
		,'66-State/County Corrections'
		,'66-State/County Corrections'
		,'Y'
		,'N'
		,7
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XGAMBLINGINSURANCE'
			AND CodeName = '67-Other State/Federal Grant'
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
		'XGAMBLINGINSURANCE'
		,'67-Other State/Federal Grant'
		,'67-Other State/Federal Grant'
		,'Y'
		,'N'
		,8
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XGAMBLINGINSURANCE'
			AND CodeName = '13-None'
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
		'XGAMBLINGINSURANCE'
		,'13-None'
		,'13-None'
		,'Y'
		,'N'
		,9
		)
END
