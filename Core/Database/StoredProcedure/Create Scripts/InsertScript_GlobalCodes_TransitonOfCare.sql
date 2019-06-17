/* Ref: Task#25.1 Meaningful Use - Stage 3 */
/* Category :  */
/*Insert Into GlobalCodes */
/*Insert Into GlobalCodeCategories */
/* TRANSITONTYPE */

--Delete FROM [GlobalCodes] WHERE Category = 'TRANSITONTYPE'
--Delete FROM GlobalCodeCategories WHERE Category = 'TRANSITONTYPE'
--Delete FROM [GlobalCodes] WHERE Category = 'CONFIDENTIALITYCODE'
--Delete FROM GlobalCodeCategories WHERE Category = 'CONFIDENTIALITYCODE'

--GlobalCodeCategories
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'TRANSITONTYPE' And ISNULL(RecordDeleted,'N')='N'
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
		'TRANSITONTYPE'
		,'TRANSITONTYPE'
		,'Y'
		,'N'
		,'N'
		,'N'
		,'N'
		,'N'
		)
END

--GlobalCodes
IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'TRANSITONTYPE'
			AND Code = 'Outpatient'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		,[ExternalCode1]
		)
	VALUES (
		'TRANSITONTYPE'
		,'Outpatient'
		,'Outpatient'
		,'Y'
		,'Y'
		,1
		,'O'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'TRANSITONTYPE'
			AND Code = 'Inpatient'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		,[ExternalCode1]
		)
	VALUES (
		'TRANSITONTYPE'
		,'Inpatient'
		,'Inpatient'
		,'Y'
		,'Y'
		,2
		,'I'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'TRANSITONTYPE'
			AND Code = 'Primary Care'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		,[ExternalCode1]
		)
	VALUES (
		'TRANSITONTYPE'
		,'Primary Care'
		,'Primary Care'
		,'Y'
		,'Y'
		,3
		,'P'
		)
END



/* Category :  */
/*Insert Into GlobalCodes */
/*Insert Into GlobalCodeCategories */
/* CONFIDENTIALITYCODE */

--GlobalCodeCategories
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'CONFIDENTIALITYCODE' And ISNULL(RecordDeleted,'N')='N'
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
		'CONFIDENTIALITYCODE'
		,'CONFIDENTIALITYCODE'
		,'Y'
		,'N'
		,'N'
		,'N'
		,'N'
		,'N'
		)
END

--GlobalCodes
IF NOT EXISTS (
		SELECT *
		FROM [GlobalCodes]
		WHERE Category = 'CONFIDENTIALITYCODE'
			AND Code = 'Normal'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		,[ExternalCode1]
		)
	VALUES (
		'CONFIDENTIALITYCODE'
		,'Normal'
		,'Normal'
		,'Y'
		,'Y'
		,1
		,'N'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'CONFIDENTIALITYCODE'
			AND Code = 'Restricted'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		,[ExternalCode1]
		)
	VALUES (
		'CONFIDENTIALITYCODE'
		,'Restricted'
		,'Restricted'
		,'Y'
		,'Y'
		,2
		,'R'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'CONFIDENTIALITYCODE'
			AND Code = 'Very Restricted'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		,[ExternalCode1]
		)
	VALUES (
		'CONFIDENTIALITYCODE'
		,'Very Restricted'
		,'Very Restricted'
		,'Y'
		,'Y'
		,3
		,'V'
		)
END


