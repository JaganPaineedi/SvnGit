 IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE CodeName = 'Ethnicity'
			AND Category = 'ClientConsents'
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
		'ClientConsents'
		,'Ethnicity'
		,'Ethnicity'
		,NULL
		,'Y'
		,'N'
		,8
		,'Ethnicity'
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'ClientConsents'
		,CodeName = 'Ethnicity'
		,Code = 'Ethnicity'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 8
		,ExternalCode1 = 'Ethnicity'
	WHERE CodeName = 'Ethnicity'
		AND Category = 'ClientConsents'
END