IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 10
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		)
	VALUES (
		10
		,'DOCUMENTTYPE'
		,'Native'
		,NULL
		,'Y'
		,'N'
		,1
		,'NATIVE'
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'DOCUMENTTYPE'
		,CodeName = 'Native'
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 1
		,ExternalCode1 = 'NATIVE'
	WHERE GlobalCodeId = 10
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 11
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		)
	VALUES (
		11
		,'DOCUMENTTYPE'
		,'Image'
		,NULL
		,'Y'
		,'N'
		,2
		,'IMAGE'
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'DOCUMENTTYPE'
		,CodeName = 'Image'
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 2
		,ExternalCode1 = 'IMAGE'
	WHERE GlobalCodeId = 11
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 12
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		)
	VALUES (
		12
		,'DOCUMENTTYPE'
		,'View Only'
		,NULL
		,'Y'
		,'N'
		,4
		,'VIEWONLY'
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'DOCUMENTTYPE'
		,CodeName = 'View Only'
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 4
		,ExternalCode1 = 'VIEWONLY'
	WHERE GlobalCodeId = 12
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 14
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		)
	VALUES (
		14
		,'DOCUMENTTYPE'
		,'Letters'
		,NULL
		,'Y'
		,'N'
		,3
		,'Letters'
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'DOCUMENTTYPE'
		,CodeName = 'Letters'
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'N'
		,SortOrder = 3
		,ExternalCode1 = 'Letters'
	WHERE GlobalCodeId = 14
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE GlobalCodeId = 17
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO globalcodes (
		GlobalCodeId
		,Category
		,CodeName
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		17
		,'DOCUMENTTYPE'
		,'Scanned Document'
		,'Used to designate ImageServer based documents'
		,'Y'
		,'Y'
		,99
		)

	SET IDENTITY_INSERT dbo.GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE globalcodes
	SET Category = 'DOCUMENTTYPE'
		,CodeName = 'Scanned Document'
		,Description = 'Used to designate ImageServer based documents'
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,SortOrder = 99
		,ExternalCode1 = NULL
	WHERE GlobalCodeId = 17
END
 