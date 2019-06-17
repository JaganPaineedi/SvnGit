IF NOT EXISTS (
		SELECT *
		FROM GlobalCodes
		WHERE GlobalCodeId = 6512
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
		6512
		,'ORDERSTATUS'
		,'Nurse Reviewed'
		,'NurseReviewed'
		,'Y'
		,'Y'
		,NULL
		,0
		)

	SET IDENTITY_INSERT dbo.globalcodes OFF
END