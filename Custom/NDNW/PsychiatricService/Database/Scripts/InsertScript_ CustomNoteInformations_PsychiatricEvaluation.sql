
IF NOT EXISTS (
		SELECT 1
		FROM CustomNoteInformations
		WHERE DocumentCodeId = 21300
			AND InformationText = 'Current Life Events'
		)
BEGIN
	INSERT INTO CustomNoteInformations (
		InformationText
		,InformationToolTipStoredProcedure
		,DocumentCodeId
		)
	VALUES (
		'Current Life Events'
		,'csp_CustomDocumentGetCurrentLifeEvents'
		,21300
		)
END
