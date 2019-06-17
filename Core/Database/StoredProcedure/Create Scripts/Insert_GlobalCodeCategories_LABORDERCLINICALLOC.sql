-- Global Code Categories
IF NOT EXISTS (
		SELECT *
		FROM dbo.globalcodecategories
		WHERE category = 'LABORDERCLINICALLOC'
		)
BEGIN
	INSERT INTO dbo.globalcodecategories (
		category
		,categoryname
		,active
		,allowadddelete
		,allowcodenameedit
		,allowsortorderedit
		,description
		,userdefinedcategory
		,hassubcodes
		,usedinpracticemanagement
		,usedincaremanagement
		)
	VALUES (
		'LABORDERCLINICALLOC'
		,'LAB ORDER CLINICAL LOCATION'
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
