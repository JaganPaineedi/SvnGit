IF NOT EXISTS (
		SELECT 1
		FROM dbo.GroupNoteDocumentCodes
		WHERE Active = 'Y'
			AND GroupNoteCodeId = 115
			AND ServiceNoteCodeId = 115
			AND CopyStoredProcedureName = 'csp_GroupNoteDefaultCopy'
		)
BEGIN
	INSERT INTO dbo.GroupNoteDocumentCodes (
		GroupNoteName
		,Active
		,GroupNoteCodeId
		,ServiceNoteCodeId
		,CopyStoredProcedureName
		)
	VALUES (
		'Default Group Note'
		,-- GroupNoteName - varchar(100)
		'Y'
		,-- Active - type_Active
		115
		,-- GroupNoteCodeId - int
		115
		,-- ServiceNoteCodeId - int
		'csp_GroupNoteDefaultCopy' -- CopyStoredProcedureName - varchar(100)
		)
END

