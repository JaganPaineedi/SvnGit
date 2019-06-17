-- Date    : 26/July/2017      
-- Added by: Ajay   
-- Purpose : Screen entry for RWQM Work Queue. for AHN-Customization: #44

IF NOT EXISTS (SELECT
    *
  FROM screens
  WHERE ScreenId = 1257)
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
    VALUES (1257, 'RWQM Work Queue', 5762, '/Modules/RWQM/WebPages/RWQMWorkQueueList.ascx', '/Modules/RWQM/WebPages/RWQMActionToolBar.ascx', 1, NULL, NULL, NULL, NULL)
  SET IDENTITY_INSERT dbo.Screens OFF
END
ELSE
BEGIN
  UPDATE Screens
  SET ScreenName = 'RWQM Work Queue',
      ScreenType = 5762,
      ScreenURL = '/Modules/RWQM/WebPages/RWQMWorkQueueList.ascx',
      ScreenToolbarURL = '/Modules/RWQM/WebPages/RWQMActionToolBar.ascx',
      TabId = 1,
      InitializationStoredProcedure = NULL,
      ValidationStoredProcedureUpdate = NULL

  WHERE ScreenId = 1257 and ScreenName = 'RWQM Work Queue'
END 
IF NOT EXISTS (SELECT
    *
  FROM banners
  WHERE screenid = 1257
  AND BannerName = 'RWQM Work Queue')
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
    VALUES ('RWQM Work Queue', 'RWQM Work Queue', 'Y', 1, 'N', 1, 1257, NULL, NULL)
END
ELSE
BEGIN
  UPDATE Banners
  SET BannerName = 'RWQM Work Queue',
      DisplayAs = 'RWQM Work Queue',
      Active = 'Y',
      DefaultOrder = 1,
      Custom = 'N',
      TabId = 1,
      ScreenId = 1257,
      ParentBannerId = NULL
  WHERE screenid = 1257
  AND BannerName = 'RWQM Work Queue'
END
--------------------Custom PopUp---------------------------------
DECLARE @TabId INT  
DECLARE @DefaultOrder INT 
DECLARE @IsCustom VARCHAR(1) 
DECLARE @ScreenToolbarURL VARCHAR(200) 
DECLARE @DetailScreenId INT 
DECLARE @DetailScreenType INT 
DECLARE @DetailScreenDesc VARCHAR(64) 
DECLARE @DetailScreenURL VARCHAR(200) 
 
SET @DetailScreenId = 1258 
SET @DetailScreenType = 5765 
SET @DetailScreenDesc = ''-- 'To update the Action with associated comments' 
SET @DetailScreenURL = '/Modules/RWQM/WebPages/ActionUpdatePopUp.ascx'
SET @ScreenToolbarURL = null 
SET @IsCustom = 'Y' 
SET @DefaultOrder = 1 
SEt @TabId=2

IF @DetailScreenId > 0 
  BEGIN 
      IF NOT EXISTS (SELECT * 
                     FROM   Screens 
                     WHERE  ScreenId = @DetailScreenId) 
        BEGIN 
            SET IDENTITY_INSERT Screens ON 

            INSERT INTO Screens 
                        (ScreenId, 
                         ScreenName, 
                         ScreenType, 
                         ScreenURL,
                         TabId,
                         ScreenToolBarURL) 
            VALUES      (@DetailScreenId, 
                         @DetailScreenDesc, 
                         @DetailScreenType, 
                         @DetailScreenURL, 
                         @TabId,
                         @ScreenToolbarURL) 

            SET IDENTITY_INSERT Screens OFF 
        END 
      ELSE 
        BEGIN 
            UPDATE Screens 
            SET    ScreenName = @DetailScreenDesc, 
                   ScreenType = @DetailScreenType, 
                   ScreenURL = @DetailScreenURL,
                   TabId = @TabId,
                   ScreenToolbarURL = @ScreenToolbarURL 
            WHERE  ScreenId = @DetailScreenId 
        END 
  END 