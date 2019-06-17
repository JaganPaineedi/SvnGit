-- Date    : 26/July/2017      
-- Added by: Ajay   
-- Purpose : Screen entry for Actions, for AHN-Customization: #44

IF NOT EXISTS (SELECT
    *
  FROM screens
  WHERE ScreenId = 1254)
BEGIN
  SET IDENTITY_INSERT dbo.Screens ON

  INSERT INTO screens (screenid
  , ScreenName
  , ScreenType
  , screenurl
  , ScreenToolbarURL
  , TabId
  , InitializationStoredProcedure
  , DocumentCodeId
  , HelpURL
  , ValidationStoredProcedureComplete)
    VALUES (1254, 'Actions', 5762, '/Modules/RWQM/WebPages/ActionList.ascx', '', 4, NULL, NULL, NULL, NULL)

  SET IDENTITY_INSERT dbo.Screens OFF
END
ELSE
BEGIN
  UPDATE Screens
  SET ScreenName = 'Actions',
      ScreenType = 5762,
      ScreenURL = '/Modules/RWQM/WebPages/ActionList.ascx',
      ScreenToolbarURL = NULL,
      TabId = 4,
      InitializationStoredProcedure = NULL,
      ValidationStoredProcedureUpdate = NULL

  WHERE ScreenId = 1254
END
IF NOT EXISTS (SELECT
    *
  FROM screens
  WHERE ScreenId = 1253)
BEGIN
  SET IDENTITY_INSERT dbo.Screens ON

  INSERT INTO screens (screenid
  , ScreenName
  , ScreenType
  , screenurl
  , ScreenToolbarURL
  , TabId
  , InitializationStoredProcedure
  , DocumentCodeId
  , HelpURL
  , ValidationStoredProcedureComplete)
    VALUES (1253, 'Action Detail', 5761, '/Modules/RWQM/WebPages/ActionDetail.ascx', '', 4, NULL, NULL, NULL, NULL)

  SET IDENTITY_INSERT dbo.Screens OFF
END
ELSE
BEGIN
  UPDATE Screens
  SET ScreenName = 'Action Detail',
      ScreenType = 5761,
      ScreenURL = '/Modules/RWQM/WebPages/ActionDetail.ascx',
      ScreenToolbarURL = NULL,
      TabId = 4,
      InitializationStoredProcedure = NULL,
      ValidationStoredProcedureUpdate = NULL

  WHERE ScreenId = 1253
END

IF NOT EXISTS (SELECT
    *
  FROM banners
  WHERE screenid = 1254
  AND BannerName = 'Actions')
BEGIN
  INSERT INTO banners (BannerName
  , DisplayAs
  , Active
  , DefaultOrder
  , Custom
  , TabId
  , ScreenId
  , ScreenParameters
  , ParentBannerId)
    VALUES ('Actions', 'Actions', 'Y', 1, 'N', 4, 1254, NULL, NULL)
END
ELSE
BEGIN
  UPDATE Banners
  SET BannerName = 'Actions',
      DisplayAs = 'Actions',
      Active = 'Y',
      DefaultOrder = 1,
      Custom = 'N',
      TabId = 4,
      ScreenId = 1254,
      ParentBannerId = NULL
  WHERE screenid = 1254
  AND BannerName = 'Actions'
END