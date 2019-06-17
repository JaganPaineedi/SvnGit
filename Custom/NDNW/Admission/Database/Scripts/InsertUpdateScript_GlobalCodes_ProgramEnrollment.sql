DELETE
FROM GlobalCodes
WHERE Category = 'XFACILITY'
	AND Active = 'Y'
	AND GlobalCodeId > 10000

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'XFACILITY'
		)
BEGIN
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XFACILITY','XFACILITY','Y','Y','Y','Y','Y','N') 
END




IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE Category = 'XFACILITY'
			AND CodeName = 'Baker House'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'XFACILITY'
		,'Baker House'
		,NULL
		,'Y'
		,'N'
		,1
		)
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE Category = 'XFACILITY'
			AND CodeName = 'Developmental Disabilities'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'XFACILITY'
		,'Developmental Disabilities'
		,NULL
		,'Y'
		,'N'
		,2
		)
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE Category = 'XFACILITY'
			AND CodeName = 'Elkhorn'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'XFACILITY'
		,'Elkhorn'
		,NULL
		,'Y'
		,'N'
		,2
		)
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE Category = 'XFACILITY'
			AND CodeName = 'NDN Behavioral Health & Wellness'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'XFACILITY'
		,'NDN Behavioral Health & Wellness'
		,NULL
		,'Y'
		,'N'
		,3
		)
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE Category = 'XFACILITY'
			AND CodeName = 'Other'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'XFACILITY'
		,'Other'
		,NULL
		,'Y'
		,'N'
		,4
		)
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE Category = 'XFACILITY'
			AND CodeName = 'Recovery Village'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'XFACILITY'
		,'Recovery Village'
		,NULL
		,'Y'
		,'N'
		,5
		)
END