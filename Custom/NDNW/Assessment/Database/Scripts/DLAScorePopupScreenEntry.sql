
IF NOT EXISTS (
		SELECT *
		FROM dbo.Screens
		WHERE ScreenId =22309
		)
BEGIN
SET IDENTITY_INSERT Screens ON
INSERT INTO [Screens] (
		ScreenId
		,[ScreenName]
		,[ScreenType]
		,[ScreenURL]
		,[TabId]
		,[DocumentCodeId]
		)
	VALUES (
		 22309
		,'Scale'
		,5765
		,'Custom/Assessment/WebPages/DLAScalePopup.ascx'
		,2
		,null
		)
SET IDENTITY_INSERT Screens OFF		
END
