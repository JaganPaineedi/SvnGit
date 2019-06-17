/*************************************************************************************                                                   
-- Purpose: Screen script for Group Template.
--  
-- Author:  Akwinass
-- Date:    13-APRIL-2016
--  
-- *****History****  
**************************************************************************************/
IF NOT EXISTS (
		SELECT *
		FROM screens
		WHERE ScreenId = 1181
		)
BEGIN
	SET IDENTITY_INSERT dbo.Screens ON

	INSERT INTO screens (
		ScreenId
		,ScreenName
		,ScreenType
		,ScreenURL
		,ScreenToolbarURL
		,TabId
		,InitializationStoredProcedure
		,ValidationStoredProcedureUpdate
		,ValidationStoredProcedureComplete
		,WarningStoredProcedureComplete
		,PostUpdateStoredProcedure
		,RefreshPermissionsAfterUpdate
		,DocumentCodeId
		,CustomFieldFormId
		,HelpURL
		,MessageReferenceType
		,PrimaryKeyName
		,WarningStoreProcedureUpdate
		)
	VALUES (
		1181
		,'Group Template'
		,5761		
		,'/Modules/Attendance/Office/Detail/GroupTemplate.ascx'
		,'/Modules/Attendance/Office/Detail/GroupTemplateToolbar.ascx'
		,1
		,'ssp_InitGroupTemplate'
		,'ssp_SCValidateGroupTemplate'
		,NULL
		,NULL
		,'ssp_PostUpdateGroupTemplate'
		,NULL
		,NULL
		,NULL
		,'../Help/overview.htm'
		,NULL
		,NULL
		,NULL
		)

	SET IDENTITY_INSERT dbo.Screens OFF
END
ELSE
BEGIN
	UPDATE screens
	SET ScreenName = 'Group Template'
		,ScreenType = 5761
		,ScreenURL = '/Modules/Attendance/Office/Detail/GroupTemplate.ascx'
		,ScreenToolbarURL = '/Modules/Attendance/Office/Detail/GroupTemplateToolbar.ascx'
		,TabId = 1
		,InitializationStoredProcedure = 'ssp_InitGroupTemplate'
		,ValidationStoredProcedureUpdate = 'ssp_SCValidateGroupTemplate'
		,ValidationStoredProcedureComplete = NULL
		,WarningStoredProcedureComplete = NULL
		,PostUpdateStoredProcedure = 'ssp_PostUpdateGroupTemplate'
		,RefreshPermissionsAfterUpdate = NULL
		,DocumentCodeId = NULL
		,CustomFieldFormId = NULL
		,HelpURL = '../Help/overview.htm'
		,MessageReferenceType = NULL
		,PrimaryKeyName = NULL
		,WarningStoreProcedureUpdate = NULL
	WHERE ScreenId = 1181
END
GO

---------------------------Group Template Pop-up Page---------------------------------------
IF NOT EXISTS (
		SELECT ScreenId
		FROM Screens
		WHERE ScreenId = 1194
		)
BEGIN
	SET IDENTITY_INSERT Screens ON

	INSERT INTO [Screens] (
		ScreenId
		,[ScreenName]
		,[ScreenType]
		,[ScreenURL]
		,[TabId]
		,[HelpURL] 
		)
	VALUES (
		1194
		,'Group Template Pop-up'
		,5765
		,'/Modules/Attendance/Office/Custom/GroupTemplatePopUp.ascx'
		,1	
		,'../Help/overview.htm'	
		)

	SET IDENTITY_INSERT Screens OFF
END
ELSE
BEGIN
	UPDATE screens
	SET screenname = 'Group Template Pop-up'
		,screentype = 5765
		,screenurl = '/Modules/Attendance/Office/Custom/GroupTemplatePopUp.ascx'
		,tabid = 1
		,HelpURL = '../Help/overview.htm'
	WHERE screenid = 1194
END 
---------------------------End----------------------------------------------------------------------
