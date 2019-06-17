-- Date    : 26/July/2017      
-- Added by: Ajay   
-- Purpose : Screen entry for RWQM Rules. for AHN-Customization: #44

IF NOT EXISTS (SELECT
    *
  FROM screens
  WHERE ScreenId = 1256)
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
    VALUES (1256, 'RWQM Rules', 5762, '/Modules/RWQM/WebPages/RWQMRuleList.ascx', '', 4, NULL, NULL, NULL, NULL)
  SET IDENTITY_INSERT dbo.Screens OFF
END
ELSE
BEGIN
  UPDATE Screens
  SET ScreenName = 'RWQM Rules',
      ScreenType = 5762,
      ScreenURL = '/Modules/RWQM/WebPages/RWQMRuleList.ascx',
      ScreenToolbarURL = NULL,
      TabId = 4,
      InitializationStoredProcedure = NULL,
      ValidationStoredProcedureUpdate = NULL

  WHERE ScreenId = 1256
END
IF NOT EXISTS (SELECT
    *
  FROM screens
  WHERE ScreenId = 1255)
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
    VALUES (1255, 'RWQM Rules Detail', 5761, '/Modules/RWQM/WebPages/RWQMRuleDetail.ascx', '', 4, NULL, NULL, NULL, NULL)

  SET IDENTITY_INSERT dbo.Screens OFF
END
ELSE
BEGIN
  UPDATE Screens
  SET ScreenName = 'RWQM Rules Detail',
      ScreenType = 5761,
      ScreenURL = '/Modules/RWQM/WebPages/RWQMRuleDetail.ascx',
      ScreenToolbarURL = NULL,
      TabId = 4,
      InitializationStoredProcedure = NULL,
      ValidationStoredProcedureUpdate = NULL

  WHERE ScreenId = 1255
END

IF NOT EXISTS (SELECT
    *
  FROM banners
  WHERE screenid = 1256
  AND BannerName = 'RWQM Rules')
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
    VALUES ('RWQM Rules', 'RWQM Rules', 'Y', 1, 'N', 4, 1256, NULL, NULL)
END
ELSE
BEGIN
  UPDATE Banners
  SET BannerName = 'RWQM Rules',
      DisplayAs = 'RWQM Rules',
      Active = 'Y',
      DefaultOrder = 1,
      Custom = 'N',
      TabId = 4,
      ScreenId = 1256,
      ParentBannerId = NULL
  WHERE screenid = 1256
  AND BannerName = 'RWQM Rules'
END