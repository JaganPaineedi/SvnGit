-- Core Bugs Task # 540


IF EXISTS (
		SELECT *
		FROM Screens
		WHERE DocumentcodeId = 1616
		)
BEGIN
	UPDATE Screens
	SET ScreenURL = '/ActivityPages/Client/Detail/Documents/ScannedMedicalRecord.ascx'
		,ScreenType = 5763
		,ScreenName = 'Radiology/Diagnostic Narrative Interpretations'
	WHERE DocumentCodeId = 1616
END

GO

IF EXISTS (
		SELECT *
		FROM Screens
		WHERE DocumentcodeId = 1617
		)
BEGIN
	UPDATE Screens
	SET ScreenURL = '/ActivityPages/Client/Detail/Documents/ScannedMedicalRecord.ascx'
		,ScreenType = 5763
		,ScreenName = 'Radiology/Diagnostic Images'
	WHERE DocumentCodeId = 1617
END

GO

IF EXISTS (
		SELECT *
		FROM Screens
		WHERE DocumentcodeId = 1623
		)
BEGIN
	UPDATE Screens
	SET ScreenURL = '/ActivityPages/Client/Detail/Documents/ScannedMedicalRecord.ascx'
		,ScreenType = 5763
		,ScreenName = 'Labs'
	WHERE DocumentCodeId = 1623
END

GO

IF EXISTS (
		SELECT *
		FROM Screens
		WHERE DocumentcodeId = 1625
		)
BEGIN
	UPDATE Screens
	SET ScreenURL = '/ActivityPages/Client/Detail/Documents/ScannedMedicalRecord.ascx'
		,ScreenType = 5763
		,ScreenName = 'Lab Results As Structured Data'
	WHERE DocumentCodeId = 1625
END


GO

IF EXISTS (
		SELECT *
		FROM Screens
		WHERE DocumentcodeId = 1626
		)
BEGIN
	UPDATE Screens
	SET ScreenURL = '/ActivityPages/Client/Detail/Documents/ScannedMedicalRecord.ascx'
		,ScreenType = 5763
		,ScreenName = 'Lab Results As Non Structured Data'
	WHERE DocumentCodeId = 1626
END


GO

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

GO

IF EXISTS (
		SELECT *
		FROM Screens
		WHERE DocumentcodeId = 1633
		)
BEGIN
	UPDATE Screens
	SET ScreenURL = '/ActivityPages/Client/Detail/Documents/ScannedMedicalRecord.ascx'
		,ScreenType = 5763
		,ScreenName = 'Inpatient Coding Document'
	WHERE DocumentCodeId = 1633
END
GO