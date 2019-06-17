-- A Renewed Mind - Support Task # 404
IF EXISTS (
		SELECT *
		FROM DocumentCodes
		WHERE DocumentCodeId = 1622
		)
BEGIN
	UPDATE DocumentCodes
	SET ViewDocumentURL = 'RDLScannedForms'
		,Storedprocedure = 'ssp_SCGetImageRecords'
		,RequiresSignature = 'N'
		,ViewDocumentRDL = 'RDLScannedForms'
	WHERE DocumentCodeId = 1622
END

IF EXISTS (
		SELECT *
		FROM Screens
		WHERE DocumentcodeId = 1622
		)
BEGIN
	UPDATE Screens
	SET ScreenURL = '/ActivityPages/Client/Detail/Documents/ScannedMedicalRecord.ascx'
		,ScreenType = 5763
		,ScreenName = 'Medications'
	WHERE DocumentCodeId = 1622
END

IF EXISTS (
		SELECT *
		FROM Screens
		WHERE DocumentcodeId = 1627
		)
BEGIN
	UPDATE Screens
	SET ScreenURL = '/ActivityPages/Client/Detail/Documents/ScannedMedicalRecord.ascx'
		,ScreenType = 5763
		,ScreenName = 'Lab Orders'
	WHERE DocumentCodeId = 1627
END