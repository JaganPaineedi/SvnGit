IF NOT EXISTS (
		SELECT *
		FROM GlobalCodes
		WHERE GlobalCodeId = 8550
		)
BEGIN
	SET IDENTITY_INSERT dbo.GlobalCodes ON

	INSERT INTO GlobalCodes (
		GlobalCodeId
		,Category
		,CodeName
		,Code
		,Active
		,CannotModifyNameOrDelete
		,ExternalCode1
		,SortOrder
		)
	VALUES (
		8550
		,'ORDERMODE'
		,'Electronic'
		,'Electronic'
		,'Y'
		,'Y'
		,NULL
		,4
		)

	SET IDENTITY_INSERT dbo.globalcodes OFF
END