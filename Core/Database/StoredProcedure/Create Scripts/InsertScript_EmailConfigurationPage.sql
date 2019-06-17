---------------------------Internal Collections Email Configuration Detail Page---------------------------------------
IF NOT EXISTS (
		SELECT ScreenId
		FROM Screens
		WHERE ScreenId = 2256
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
		2256
		,'Email Configuration'
		,5761
		,'/ActivityPages/Admin/Detail/EmailConfigurationPage.ascx'
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
ELSE
BEGIN
	UPDATE screens
	SET ScreenName = 'Email Configuration'
		,ScreenType = 5761
		,ScreenURL = '/ActivityPages/Admin/Detail/EmailConfigurationPage.ascx'
		,ScreenToolbarURL = NULL
		,TabId = 4
		,InitializationStoredProcedure = NULL--'ssp_InitEmailConfiguration'
		,ValidationStoredProcedureUpdate = NULL
		,ValidationStoredProcedureComplete = NULL
		,WarningStoredProcedureComplete = NULL
		,PostUpdateStoredProcedure = NULL
		,RefreshPermissionsAfterUpdate = NULL
		,DocumentCodeId = NULL
		,CustomFieldFormId = NULL
		,HelpURL = NULL
		,MessageReferenceType = NULL
		,PrimaryKeyName = NULL
		,WarningStoreProcedureUpdate = NULL
	WHERE ScreenId = 2256
END
---------------------------End----------------------------------------------------------------------
/************************************ BANNER TABLE *********************************************/

	IF NOT EXISTS (SELECT * FROM dbo.Banners WHERE ScreenId = 2256)
BEGIN 
--SET IDENTITY_INSERT dbo.Banners ON 
		INSERT INTO Banners 
				(BannerName 
				 ,DisplayAs 
				 ,DefaultOrder 
				 ,Custom 
				 ,ScreenId 
				 ,TabId ) 
		VALUES	('Email Configuration' 
				,'Email Configuration' 
				,1
				,'N'
				,2256
				,4
		) 
	--SET IDENTITY_INSERT dbo.Banners OFF 
	 END 
/********************************* BANNER TABLE END ***************************************/