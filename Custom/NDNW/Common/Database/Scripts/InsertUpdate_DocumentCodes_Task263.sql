-- New Directions - Support Go Live Task # 263
IF EXISTS (
		SELECT *
		FROM DocumentCodes
		WHERE DocumentName = 'Medications'
			AND DocumentCodeId = 1622
		)
BEGIN
	UPDATE DocumentCodes
	SET ViewDocumentURL = 'RDLScannedForms'
		,ViewDocumentRDL = 'RDLScannedForms'
		,StoredProcedure = 'ssp_SCGetImageRecords'
	WHERE DocumentCodeId = 1622
		AND DocumentName = 'Medications'
END
GO

