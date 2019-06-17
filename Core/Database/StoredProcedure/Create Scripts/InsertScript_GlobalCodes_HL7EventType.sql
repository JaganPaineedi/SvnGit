IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE Category = 'HL7EVENTTYPE'
		AND CodeName = 'Q11'
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
		'HL7EVENTTYPE'
		,'Q11'
		,'Q11'
		,NULL
		,'Y'
		,'N'
		,13
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'HL7EVENTTYPE'
		,CodeName = 'Q11'
		,Code = 'Q11'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 13
	WHERE CodeName = 'Q11'
		AND Category = 'HL7EVENTTYPE'
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE Category = 'HL7EVENTTYPE'
		AND CodeName = 'V04'
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
		'HL7EVENTTYPE'
		,'V04'
		,'V04'
		,NULL
		,'Y'
		,'N'
		,14
		)
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'HL7EVENTTYPE'
		,CodeName = 'V04'
		,Code = 'V04'
		,Description = NULL
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 14
	WHERE CodeName = 'V04'
		AND Category = 'HL7EVENTTYPE'
END