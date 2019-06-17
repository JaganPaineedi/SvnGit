SET IDENTITY_INSERT Screens ON

IF NOT EXISTS (SELECT 1 FROM Screens WHERE ScreenId = 1171)
BEGIN
	INSERT INTO SCREENS
	(ScreenId,ScreenName,ScreenType,ScreenURL,ScreenToolbarURL,TabId)
	VALUES
	(1171,'Time Sheet',5762,'/Modules/TimeSheet/ListPages/TimesheetListPage.ascx','/ScreenToolBars/TimeSheetListPageToolBar.ascx',1)
END
ELSE
BEGIN
	UPDATE Screens
	SET
	ScreenName='Time Sheet'
	,ScreenType=5762
	,ScreenURL='/Modules/TimeSheet/ListPages/TimesheetListPage.ascx'
	,ScreenToolbarURL='/ScreenToolBars/TimeSheetListPageToolBar.ascx'
	,TabId=1
	WHERE
	ScreenId = 1171
END

IF NOT EXISTS (SELECT 1 FROM Screens WHERE ScreenId = 1172)
BEGIN
	INSERT INTO SCREENS
	(ScreenId,ScreenName,ScreenType,ScreenURL,TabId,InitializationStoredProcedure)
	VALUES
	(1172,'Time Sheet Entry',5761,'/Modules/TimeSheet/Detail/TimeSheetEntry.ascx',1,'ssp_InitTimeSheetEntry')
END
ELSE
BEGIN
	UPDATE Screens
	SET
	ScreenName='Time Sheet Entry'
	,ScreenType=5761
	,ScreenURL='/Modules/TimeSheet/Detail/TimeSheetEntry.ascx'
	,TabId=1
	,InitializationStoredProcedure = 'ssp_InitTimeSheetEntry'
	WHERE
	ScreenId = 1172
END


IF NOT EXISTS (SELECT 1 FROM Screens WHERE ScreenId = 1173)
BEGIN
	INSERT INTO SCREENS
	(ScreenId,ScreenName,ScreenType,ScreenURL,TabId)
	VALUES
	(1173,'Time Sheet Entry OverrideType',5765,'/Modules/TimeSheet/Detail/TimeSheetOverrideType.ascx',1)
END
ELSE
BEGIN
	UPDATE Screens
	SET
	ScreenName='Time Sheet Entry OverrideType'
	,ScreenType=5765
	,ScreenURL='/Modules/TimeSheet/Detail/TimeSheetOverrideType.ascx'
	,TabId=1
	
	WHERE
	ScreenId = 1173
END

--,(1172,'Time Sheet Entry',5761,'/Modules/TimeSheet/Detail/TimeSheetEntry.ascx',NULL,4,'ssp_InitTimeSheetEntry')
--,(1173,'Time Sheet Entry OverrideType',5765,'/Modules/TimeSheet/Detail/TimeSheetOverrideType.ascx',NULL,4,NULL)
SET IDENTITY_INSERT Screens OFF