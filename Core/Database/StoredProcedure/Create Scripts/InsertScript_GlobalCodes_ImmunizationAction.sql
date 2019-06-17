IF NOT EXISTS (
  SELECT *
  FROM dbo.globalcodecategories
  WHERE category = 'ImmunizationAction'
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
  'ImmunizationAction'
  ,'ImmunizationAction'
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

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Send'
			AND Category = 'ImmunizationAction'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'ImmunizationAction'
		,'Send'
		,'Send'
		,NULL
		,'Y'
		,'N'
		,1
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'ImmunizationAction'
		,CodeName = 'Send'
		,Code = 'Send'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 1
	WHERE CodeName = 'Send'
		AND Category = 'ImmunizationAction'
END


IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Query'
			AND Category = 'ImmunizationAction'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'ImmunizationAction'
		,'Query'
		,'Query'
		,NULL
		,'Y'
		,'N'
		,1
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'ImmunizationAction'
		,CodeName = 'Query'
		,Code = 'Query'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 2
	WHERE CodeName = 'Query'
		AND Category = 'ImmunizationAction'
END