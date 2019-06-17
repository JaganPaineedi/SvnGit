-------------------------------------------------
--Author : Hemant Kumar
--Date   : 03/21/2016
--Purpose: To Insert Screen entry Harbor - Support #869
-------------------------------------------------


-- Provider Documents Screen Entry

IF NOT EXISTS (
		SELECT ScreenId
		FROM Screens
		WHERE ScreenId = 1193
		)
BEGIN
	SET IDENTITY_INSERT Screens ON

	INSERT INTO Screens (
		ScreenId
		,ScreenName
		,ScreenType
		,ScreenURL
		,DocumentCodeId
		,TabId
		,InitializationStoredProcedure
		,ScreenToolbarUrl
		,HelpURL
		)
	VALUES (
		1193
		,'Add New Reviewer'
		,5765
		,'/CommonUserControls/AddNewReviewerPopUp.ascx'
		,NULL
		,2
		,NULL
		,NULL
		,NULL
		)

	SET IDENTITY_INSERT Screens OFF
END