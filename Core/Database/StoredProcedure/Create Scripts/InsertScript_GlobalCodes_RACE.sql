IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Asian'
			AND Category = 'RACE'
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
		,ExternalCode1
		)
	VALUES (
		'RACE'
		,'Asian'
		,'Asian'
		,NULL
		,'Y'
		,'Y'
		,1
		,'2028-9'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'RACE'
		,CodeName = 'Asian'
		,Code = 'Asian'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 1
		,ExternalCode1 = '2028-9'
	WHERE CodeName = 'Asian'
		AND Category = 'RACE'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Samoan'
			AND Category = 'RACE'
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
		,ExternalCode1
		)
	VALUES (
		'RACE'
		,'Samoan'
		,'Samoan'
		,NULL
		,'Y'
		,'Y'
		,2
		,'2080-0'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'RACE'
		,CodeName = 'Samoan'
		,Code = 'Samoan'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 2
		,ExternalCode1 = '2080-0'
	WHERE CodeName = 'Samoan'
		AND Category = 'RACE'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Native Hawaiian'
			AND Category = 'RACE'
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
		,ExternalCode1
		)
	VALUES (
		'RACE'
		,'Native Hawaiian'
		,'Native Hawaiian'
		,NULL
		,'Y'
		,'Y'
		,3
		,'2076-8'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'RACE'
		,CodeName = 'Native Hawaiian'
		,Code = 'Native Hawaiian'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 3
		,ExternalCode1 = '2076-8'
	WHERE CodeName = 'Native Hawaiian'
		AND Category = 'RACE'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Haitian'
			AND Category = 'RACE'
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
		,ExternalCode1
		)
	VALUES (
		'RACE'
		,'Haitian'
		,'Haitian'
		,NULL
		,'Y'
		,'Y'
		,4
		,'2071-9'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'RACE'
		,CodeName = 'Haitian'
		,Code = 'Haitian'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 4
		,ExternalCode1 = '2071-9'
	WHERE CodeName = 'Haitian'
		AND Category = 'RACE'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Dominica Islander'
			AND Category = 'RACE'
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
		,ExternalCode1
		)
	VALUES (
		'RACE'
		,'Dominica Islander'
		,'Dominica Islander'
		,NULL
		,'Y'
		,'Y'
		,5
		,'2070-1'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'RACE'
		,CodeName = 'Dominica Islander'
		,Code = 'Dominica Islander'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 5
		,ExternalCode1 = '2070-1'
	WHERE CodeName = 'Dominica Islander'
		AND Category = 'RACE'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Black or African American'
			AND Category = 'RACE'
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
		,ExternalCode1
		)
	VALUES (
		'RACE'
		,'Black or African American'
		,'Black or African American'
		,NULL
		,'Y'
		,'Y'
		,6
		,'2054-5'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'RACE'
		,CodeName = 'Black or African American'
		,Code = 'Black or African American'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 6
		,ExternalCode1 = '2054-5'
	WHERE CodeName = 'Black or African American'
		AND Category = 'RACE'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Dominican'
			AND Category = 'RACE'
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
		,ExternalCode1
		)
	VALUES (
		'RACE'
		,'Dominican'
		,'Dominican'
		,NULL
		,'Y'
		,'Y'
		,7
		,'2069-3'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'RACE'
		,CodeName = 'Dominican'
		,Code = 'Dominican'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 7
		,ExternalCode1 = '2069-3'
	WHERE CodeName = 'Dominican'
		AND Category = 'RACE'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Blackfoot Sioux'
			AND Category = 'RACE'
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
		,ExternalCode1
		)
	VALUES (
		'RACE'
		,'Blackfoot Sioux'
		,'Blackfoot Sioux'
		,NULL
		,'Y'
		,'Y'
		,8
		,'1610-5'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'RACE'
		,CodeName = 'Blackfoot Sioux'
		,Code = 'Blackfoot Sioux'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 8
		,ExternalCode1 = '1610-5'
	WHERE CodeName = 'Blackfoot Sioux'
		AND Category = 'RACE'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'French'
			AND Category = 'RACE'
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
		,ExternalCode1
		)
	VALUES (
		'RACE'
		,'French'
		,'French'
		,NULL
		,'Y'
		,'Y'
		,9
		,'2111-3'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'RACE'
		,CodeName = 'French'
		,Code = 'French'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 9
		,ExternalCode1 = '2111-3'
	WHERE CodeName = 'French'
		AND Category = 'RACE'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Japanese'
			AND Category = 'RACE'
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
		,ExternalCode1
		)
	VALUES (
		'RACE'
		,'Japanese'
		,'Japanese'
		,NULL
		,'Y'
		,'Y'
		,10
		,'2039-6'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'RACE'
		,CodeName = 'Japanese'
		,Code = 'Japanese'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 10
		,ExternalCode1 = '2039-6'
	WHERE CodeName = 'Japanese'
		AND Category = 'RACE'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'American Indian or Alaskan Native'
			AND Category = 'RACE'
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
		,ExternalCode1
		)
	VALUES (
		'RACE'
		,'American Indian or Alaskan Native'
		,'American Indian or Alaskan Native'
		,NULL
		,'Y'
		,'Y'
		,11
		,'1002-5'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'RACE'
		,CodeName = 'American Indian or Alaskan Native'
		,Code = 'American Indian or Alaskan Native'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 11
		,ExternalCode1 = '1002-5'
	WHERE CodeName = 'American Indian or Alaskan Native'
		AND Category = 'RACE'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'White'
			AND Category = 'RACE'
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
		,ExternalCode1
		)
	VALUES (
		'RACE'
		,'White'
		,'White'
		,NULL
		,'Y'
		,'Y'
		,12
		,'2106-3'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'RACE'
		,CodeName = 'White'
		,Code = 'White'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 12
		,ExternalCode1 = '2106-3'
	WHERE CodeName = 'White'
		AND Category = 'RACE'
END