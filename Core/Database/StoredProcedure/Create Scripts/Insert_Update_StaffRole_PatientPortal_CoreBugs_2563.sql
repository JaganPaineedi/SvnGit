IF EXISTS (
		SELECT *
		FROM GlobalCodes
		WHERE Category = 'STAFFROLE'
			AND CodeName = 'PATIENTPORTALUSER'
		)
BEGIN
	UPDATE GlobalCodes
	SET Code = 'PATIENTPORTALUSER'
		,CodeName = 'PATIENTPORTALUSER'
		,Active = 'Y'
		,CannotModifyNameOrDelete = 'Y'
		,ExternalCode1 = 'CLIENTSTAFF'
	WHERE Category = 'STAFFROLE'
		AND CodeName = 'PATIENTPORTALUSER'
END
ELSE
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,Active
		,CannotModifyNameOrDelete
		,ExternalCode1
		)
	VALUES (
		'STAFFROLE'
		,'PATIENTPORTALUSER'
		,'PATIENTPORTALUSER'
		,'Y'
		,'Y'
		,'CLIENTSTAFF'
		)
GO

