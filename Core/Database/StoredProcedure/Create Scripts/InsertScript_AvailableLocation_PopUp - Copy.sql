-- =============================================   
-- Author:   Chita Ranjan
-- Create date: Mar 26, 2018
-- Description: Added a Screen entry for Available clients in the class room PopUp
/*  
   Modified Date    Modidifed By    Purpose  
*/ 
-- =============================================     
IF NOT EXISTS (
		SELECT *
		FROM screens
		WHERE ScreenId = 1300
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
		1300
		,'Available Locations'
		, 5765
		,'/ActivityPages/Admin/Detail/PlansLocationCodes.ascx'
		,NULL
		,4
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)

	SET IDENTITY_INSERT dbo.Screens OFF
END



