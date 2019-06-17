-- New Directions - Support Go Live #252

IF EXISTS (
		SELECT *
		FROM documentvalidations
		WHERE documentcodeid = 10018
			AND errormessage = 'Further information and justification is required'
		)
BEGIN
	UPDATE documentvalidations
	SET active = 'N'
	WHERE documentcodeid = 10018
		AND errormessage = 'Further information and justification is required'
END
GO

IF EXISTS (
		SELECT *
		FROM documentvalidations
		WHERE documentcodeid = 10018
			AND errormessage = 'Client has been assessed for communicable disease - Dropdown is required'
		)
BEGIN
	UPDATE documentvalidations
	SET active = 'N'
	WHERE documentcodeid = 10018
		AND errormessage = 'Client has been assessed for communicable disease - Dropdown is required'
END
GO

