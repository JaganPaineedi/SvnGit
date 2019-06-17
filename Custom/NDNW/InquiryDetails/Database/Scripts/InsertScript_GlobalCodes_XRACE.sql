Delete FROM GlobalCodes WHERE Category = 'XRACE'
Delete FROM GlobalCodes WHERE Category = 'XETHNICITY'
Delete FROM GlobalCodes WHERE Category = 'XINTERPRETERNEEDED'
Delete FROM GlobalCodeCategories WHERE Category = 'XRACE'
Delete FROM GlobalCodeCategories WHERE Category = 'XETHNICITY'
Delete FROM GlobalCodeCategories WHERE Category = 'XINTERPRETERNEEDED'

--XRACE
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'XRACE'
			AND ISNULL(RecordDeleted, 'N') = 'N'
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
		)
	VALUES (
		'XRACE'
		,'XRACE'
		,'Y'
		,'N'
		,'N'
		,'Y'
		,NULL
		,'N'
		,'N'
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XRACE'
			AND CodeName = 'Alaskan Native number'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XRACE'
		,'Alaskan Native number'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XRACE'
			AND CodeName = 'American Indian and Alaska Native'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XRACE'
		,'American Indian and Alaska Native'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,2
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XRACE'
			AND CodeName = 'Asian'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XRACE'
		,'Asian'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,3
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XRACE'
			AND CodeName = 'Black/African American'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XRACE'
		,'Black/African American'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,4
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XRACE'
			AND CodeName = 'Native Hawaiian or Other Pacific Islander'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XRACE'
		,'Native Hawaiian or Other Pacific Islander'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,5
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XRACE'
			AND CodeName = 'Other single race'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XRACE'
		,'Other single race'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,6
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XRACE'
			AND CodeName = 'Two or more races'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XRACE'
		,'Two or more races'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,7
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XRACE'
			AND CodeName = 'Unknown'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XRACE'
		,'Unknown'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,8
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XRACE'
			AND CodeName = 'White'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XRACE'
		,'White'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,9
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
--XETHNICITY
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'XETHNICITY'
			AND ISNULL(RecordDeleted, 'N') = 'N'
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
		)
	VALUES (
		'XETHNICITY'
		,'XETHNICITY'
		,'Y'
		,'N'
		,'N'
		,'Y'
		,NULL
		,'N'
		,'N'
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XETHNICITY'
			AND CodeName = 'Cuban'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XETHNICITY'
		,'Cuban'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XETHNICITY'
			AND CodeName = 'Mexican'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XETHNICITY'
		,'Mexican'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,2
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XETHNICITY'
			AND CodeName = 'Not of Hispanic Origin'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XETHNICITY'
		,'Not of Hispanic Origin'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,3
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XETHNICITY'
			AND CodeName = 'Other Hispanic'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XETHNICITY'
		,'Other Hispanic'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,4
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XETHNICITY'
			AND CodeName = 'Puerto Rican'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XETHNICITY'
		,'Puerto Rican'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,5
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XETHNICITY'
			AND CodeName = 'Unknown'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XETHNICITY'
		,'Unknown'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,6
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
--XINTERPRETERNEEDED
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'XINTERPRETERNEEDED'
			AND ISNULL(RecordDeleted, 'N') = 'N'
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
		)
	VALUES (
		'XINTERPRETERNEEDED'
		,'XINTERPRETERNEEDED'
		,'Y'
		,'N'
		,'N'
		,'Y'
		,NULL
		,'N'
		,'N'
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XINTERPRETERNEEDED'
			AND CodeName = 'None'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XINTERPRETERNEEDED'
		,'None'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XINTERPRETERNEEDED'
			AND CodeName = 'Foreign Language'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XINTERPRETERNEEDED'
		,'Foreign Language'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,2
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XINTERPRETERNEEDED'
			AND CodeName = 'Hearing Impaired'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XINTERPRETERNEEDED'
		,'Hearing Impaired'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,3
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END