-- 07/19/2018	Msood	Journey-Support Go Live Task #200

IF EXISTS (SELECT *
	FROM GlobalCodeCategories
	WHERE Category = 'EDUCATIONALSTATUS')
BEGIN
	UPDATE GlobalCodeCategories
	SET AllowAddDelete    = 'Y'
	,   AllowCodeNameEdit = 'Y'
	WHERE Category = 'EDUCATIONALSTATUS'
END
GO
