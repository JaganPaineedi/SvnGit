IF NOT EXISTS (
		SELECT *
		FROM screens
		WHERE ScreenId = 1178
		)
BEGIN
	SET IDENTITY_INSERT dbo.Screens ON

	INSERT INTO screens (
		screenid
		,ScreenName
		,ScreenType
		,screenurl
		,ScreenToolbarURL
		,TabId
		,InitializationStoredProcedure
		,DocumentCodeId
		,HelpURL
		,ValidationStoredProcedureComplete
		)
	VALUES (
		1178
		,'Census Management – Swing Bed'
		,5761
		,'/BedBoard/Office/Detail/SwingBeds.ascx'
		,''
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		)

	SET IDENTITY_INSERT dbo.Screens OFF
END
ELSE
BEGIN
	UPDATE Screens
	SET ScreenName = 'Census Management – Swing Bed'
		,ScreenType = 5761
		,ScreenURL = '/BedBoard/Office/Detail/SwingBeds.ascx'
		,ScreenToolbarURL = NULL
		,TabId = 1
		,InitializationStoredProcedure = NULL
		,ValidationStoredProcedureUpdate = '' 
		,ValidationStoredProcedureComplete = NULL
		,WarningStoredProcedureComplete = ''
		,DocumentCodeId = NULL
		,CustomFieldFormId = NULL
	WHERE ScreenId = 1178
END

IF NOT EXISTS (
		SELECT *
		FROM screens
		WHERE ScreenId = 1179
		)
BEGIN
	SET IDENTITY_INSERT dbo.Screens ON

	INSERT INTO screens (
		screenid
		,ScreenName
		,ScreenType
		,screenurl
		,ScreenToolbarURL
		,TabId
		,InitializationStoredProcedure
		,DocumentCodeId
		,HelpURL
		,ValidationStoredProcedureComplete
		)
	VALUES (
		1179
		,'Swap Beds'
		,5765
		,'/BedBoard/Office/Detail/SwapBeds.ascx'
		,''
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		)

	SET IDENTITY_INSERT dbo.Screens OFF
END
ELSE
BEGIN
	UPDATE Screens
	SET ScreenName = 'Swap Beds'
		,ScreenType = 5765
		,ScreenURL = '/BedBoard/Office/Detail/SwapBeds.ascx'
		,ScreenToolbarURL = NULL
		,TabId = 1
		,InitializationStoredProcedure = NULL
		,ValidationStoredProcedureUpdate = '' 
		,ValidationStoredProcedureComplete = NULL
		,WarningStoredProcedureComplete = ''
		,DocumentCodeId = NULL
		,CustomFieldFormId = NULL
	WHERE ScreenId = 1179
END

--select * from BedBoardStatusChangeDropdowns

-- update BedBoardStatusChangeDropdowns set dropdownoptions='Admit,Schedule Admission,Swing Bed'  where BedCensusStatusChangeDropdownId=1
update BedBoardStatusChangeDropdowns set dropdownoptions='Bed Change,Transfer,On Leave,Discharge,Schedule Bed Change,Schedule Transfer,Schedule On Leave,Schedule Discharge,Swap Beds'  where BedCensusStatusChangeDropdownId=2
