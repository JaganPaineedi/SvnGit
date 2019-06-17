IF NOT EXISTS (
		SELECT *
		FROM dbo.GlobalCodeCategories
		WHERE Category = 'TIMESHEETACTIVITY'
		)
BEGIN
	INSERT INTO dbo.GlobalCodeCategories (
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
		,UsedInCareManagement
		)
	VALUES (
		'TIMESHEETACTIVITY'
		,'TIMESHEETACTIVITY'
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		,NULL
		,'N'
		,'N'
		,'N'
		,'N'
		)
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories
	SET CategoryName = 'TIMESHEETACTIVITY'
		,Active = 'Y'
	WHERE Category = 'TIMESHEETACTIVITY'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 9407
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		9407
		,'TIMESHEETACTIVITY'
		,'Other'
		,'OTHER'
		,NULL
		,'Y'
		,'N'
		,1
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'TIMESHEETACTIVITY'
		,CodeName = 'Other'
		,Code = 'OTHER'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 1
		,ExternalCode1 = NULL
	WHERE GlobalCodeId = 9407
END