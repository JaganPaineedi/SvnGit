/* Category :  */
/*Insert Into GlobalCodes */
/*Insert Into GlobalCodeCategories */
/* XWRATTESTNUMBER */

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'XWRATTESTNUMBER'
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
		'XWRATTESTNUMBER'
		,'XWRATTESTNUMBER'
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
		WHERE Category = 'XWRATTESTNUMBER'
			AND CodeName = '0- Never'
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
		'XWRATTESTNUMBER'
		,'0- Never'
		,'0- Never'
		,'Y'
		,'Y'
		,1
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XWRATTESTNUMBER'
			AND CodeName = '1- Monthly or less'
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
		'XWRATTESTNUMBER'
		,'1- Monthly or less'
		,'1- Monthly or less'
		,'Y'
		,'Y'
		,2
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XWRATTESTNUMBER'
			AND CodeName = '2- 2-4 times a month'
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
		'XWRATTESTNUMBER'
		,'2- 2-4 times a month'
		,'2- 2-4 times a month'
		,'Y'
		,'Y'
		,3
		)
END



IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XWRATTESTNUMBER'
			AND CodeName = '3- 2-3 times a week'
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
		'XWRATTESTNUMBER'
		,'3- 2-3 times a week'
		,'3- 2-3 times a week'
		,'Y'
		,'Y'
		,4
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XWRATTESTNUMBER'
			AND CodeName = '4- 4 or more times a week'
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
		'XWRATTESTNUMBER'
		,'4- 4 or more times a week'
		,'4- 4 or more times a week'
		,'Y'
		,'Y'
		,5
		)
END
/* Category :  */
/*Insert Into GlobalCodes */
/*Insert Into GlobalCodeCategories */
/* XAuditQuantity */

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'XAuditQuantity'
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
		'XAuditQuantity'
		,'XAuditQuantity'
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
		WHERE Category = 'XAuditQuantity'
			AND CodeName = '0- 1 or 2'
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
		'XAuditQuantity'
		,'0- 1 or 2'
		,'0- 1 or 2'
		,'Y'
		,'Y'
		,1
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XAuditQuantity'
			AND CodeName = '1- 3 or 4'
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
		'XAuditQuantity'
		,'1- 3 or 4'
		,'1- 3 or 4'
		,'Y'
		,'Y'
		,2
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XAuditQuantity'
			AND CodeName = '2- 5 or 6'
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
		'XAuditQuantity'
		,'2- 5 or 6'
		,'2- 5 or 6'
		,'Y'
		,'Y'
		,3
		)
END



IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XAuditQuantity'
			AND CodeName = '3- 7 to 9'
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
		'XAuditQuantity'
		,'3- 7 to 9'
		,'3- 7 to 9'
		,'Y'
		,'Y'
		,4
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XAuditQuantity'
			AND CodeName = '4- 10 or more'
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
		'XAuditQuantity'
		,'4- 10 or more'
		,'4- 10 or more'
		,'Y'
		,'Y'
		,5
		)
END

/* Category :  */
/*Insert Into GlobalCodes */
/*Insert Into GlobalCodeCategories */
/* XAuditFrequency */

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'XAuditFrequency'
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
		'XAuditFrequency'
		,'XAuditFrequency'
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
		WHERE Category = 'XAuditFrequency'
			AND CodeName = '0- never'
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
		'XAuditFrequency'
		,'0- never'
		,'0- never'
		,'Y'
		,'Y'
		,1
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XAuditFrequency'
			AND CodeName = '1- less than monthly'
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
		'XAuditFrequency'
		,'1- less than monthly'
		,'1- less than monthly'
		,'Y'
		,'Y'
		,2
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XAuditFrequency'
			AND CodeName = '2- monthly'
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
		'XAuditFrequency'
		,'2- monthly'
		,'2- monthly'
		,'Y'
		,'Y'
		,3
		)
END



IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XAuditFrequency'
			AND CodeName = '3- weekly'
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
		'XAuditFrequency'
		,'3- weekly'
		,'3- weekly'
		,'Y'
		,'Y'
		,4
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XAuditFrequency'
			AND CodeName = '4- daily or almost daily'
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
		'XAuditFrequency'
		,'4- daily or almost daily'
		,'4- daily or almost daily'
		,'Y'
		,'Y'
		,5
		)
END
/* Category :  */
/*Insert Into GlobalCodes */
/*Insert Into GlobalCodeCategories */
/* XAuditAlcoholInjury */

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'XAuditAlcoholInjury'
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
		'XAuditAlcoholInjury'
		,'XAuditAlcoholInjury'
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
		WHERE Category = 'XAuditAlcoholInjury'
			AND CodeName = '0 - no'
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
		'XAuditAlcoholInjury'
		,'0 - no'
		,'0 - no'
		,'Y'
		,'Y'
		,1
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XAuditAlcoholInjury'
			AND CodeName = '2- yes, but not in the last year'
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
		'XAuditAlcoholInjury'
		,'2- yes, but not in the last year'
		,'2- yes, but not in the last year'
		,'Y'
		,'Y'
		,2
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'XAuditAlcoholInjury'
			AND CodeName = '4- yes, during the last year'
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
		'XAuditAlcoholInjury'
		,'4- yes, during the last year'
		,'4- yes, during the last year'
		,'Y'
		,'Y'
		,3
		)
END

GO



