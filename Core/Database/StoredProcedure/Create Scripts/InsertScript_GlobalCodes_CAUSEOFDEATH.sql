IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Cardiac Arrest'
			AND Category = 'CAUSEOFDEATH'
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
		'CAUSEOFDEATH'
		,'Cardiac Arrest'
		,'Cardiac Arrest'
		,NULL
		,'Y'
		,'Y'
		,1
		,'410429000'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'CAUSEOFDEATH'
		,CodeName = 'Cardiac Arrest'
		,Code = 'Cardiac Arrest'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 1
		,ExternalCode1 = '410429000'
	WHERE CodeName = 'Cardiac Arrest'
		AND Category = 'CAUSEOFDEATH'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Head Trauma'
			AND Category = 'CAUSEOFDEATH'
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
		'CAUSEOFDEATH'
		,'Head Trauma'
		,'Head Trauma'
		,NULL
		,'Y'
		,'Y'
		,2
		,'312972009'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'CAUSEOFDEATH'
		,CodeName = 'Head Trauma'
		,Code = 'Head Trauma'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 2
		,ExternalCode1 = '312972009'
	WHERE CodeName = 'Head Trauma'
		AND Category = 'CAUSEOFDEATH'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Cerebrovascular Accident'
			AND Category = 'CAUSEOFDEATH'
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
		'CAUSEOFDEATH'
		,'Cerebrovascular Accident'
		,'Cerebrovascular Accident'
		,NULL
		,'Y'
		,'Y'
		,3
		,'230690007'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'CAUSEOFDEATH'
		,CodeName = 'Cerebrovascular Accident'
		,Code = 'Cerebrovascular Accident'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 3
		,ExternalCode1 = '230690007'
	WHERE CodeName = 'Cerebrovascular Accident'
		AND Category = 'CAUSEOFDEATH'
END