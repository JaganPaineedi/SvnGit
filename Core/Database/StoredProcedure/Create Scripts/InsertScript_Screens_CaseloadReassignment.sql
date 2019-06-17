/*  
  Please change these variables for supporting a new page/document/widget  
  Screen Types:  
      None:               0,  
        Detail:             5761,  
        List:               5762,  
        Document:           5763,  
        Summary:            5764,  
        Custom:             5765,  
        ExternalScreen:     5766  
*/ 
--------------------------------------------------------------------------------------------

DECLARE @OfficeTabId INT 
DECLARE @CustomStart INT 
DECLARE @DefaultOrder INT 
DECLARE @IsCustom VARCHAR(1) 
DECLARE @ListScreenId INT 
DECLARE @ListScreenName VARCHAR(64) 
DECLARE @ListScreenDesc VARCHAR(64) 
DECLARE @ListScreenType INT 
DECLARE @ListScreenURL VARCHAR(200) 
DECLARE @ListScreenToolbarURL VARCHAR(200)
DECLARE @TabId INT 
DECLARE @DetailScreenId INT
DECLARE @DetailScreenType INT
DECLARE @DetailScreenName VARCHAR(64)
DECLARE @DetailScreenDesc  VARCHAR(64)
DECLARE @DetailScreenURL VARCHAR(200) 


SET @OfficeTabId = 1 
SET @ListScreenId = 1221
SET @ListScreenName = 'Reassignment' 
SET @ListScreenDesc = 'Reassignment' 
SET @ListScreenType = 5762 
SET @ListScreenURL = '/Modules/CaseloadReassignment/Office/ListPages/Reassignment.ascx'
SET @ListScreenToolbarURL = '/Modules/CaseloadReassignment/Office/ScreenToolBars/ReassignmentToolBar.ascx' 


IF NOT EXISTS (SELECT * 
               FROM   screens 
               WHERE  screenid = @ListScreenId) 
  BEGIN 
      SET IDENTITY_INSERT Screens ON 

      INSERT INTO Screens 
                  (ScreenId, 
                   ScreenName, 
                   ScreenType, 
                   ScreenURL, 
                   TabId,
                   ScreenToolbarURL) 
      VALUES      (@ListScreenId, 
                   @ListScreenDesc, 
                   @ListScreenType, 
                   @ListScreenURL, 
                   @OfficeTabId,
                   @ListScreenToolbarURL) 

      SET IDENTITY_INSERT Screens OFF 
  END 
ELSE 
  BEGIN 
      UPDATE Screens 
      SET    ScreenName = @ListScreenDesc, 
             ScreenType = @ListScreenType, 
             ScreenURL = @ListScreenURL, 
             TabId = @OfficeTabId,
             ScreenToolbarURL = @ListScreenToolbarURL
      WHERE  ScreenId = @ListScreenId 
  END 
 /*  
  Add to Banners  
*/
-----Caseload Reassignment Banner---------------
IF NOT EXISTS (
		SELECT *
		FROM Banners
		WHERE ScreenId = @ListScreenId
			AND BannerName = 'Caseload Reassignment'
		)
BEGIN
	INSERT INTO Banners (
		BannerName
		,DisplayAs
		,DefaultOrder
		,Custom
		,TabId
		,ParentBannerId
		,ScreenId
		,Active
		)
	VALUES (
		'Caseload Reassignment'
		,'Caseload Reassignment'
		,1
		,'N'
		,1
		,NULL
		,1221
		,'Y'
		)
END

-- Script for Re-assignment Pop Up

SET @TabId = 1 
SET @DetailScreenId = 1222
SET @DetailScreenType = 5765 
SET @DetailScreenName = 'Re-assignment Pop Up'  
SET @DetailScreenDesc = 'Re-assignment Pop Up' 
SET @DetailScreenURL = '/Modules/CaseloadReassignment/Office/Custom/ReassignmentPopup.ascx' 
SET @DefaultOrder = 1 

IF NOT EXISTS (
		SELECT *
		FROM screens
		WHERE screenid = @DetailScreenId
		)
BEGIN
	SET IDENTITY_INSERT screens ON

	INSERT INTO screens (
		screenid
		,screenname
		,screentype
		,screenurl
		,tabid
		,InitializationStoredProcedure
		)
	VALUES (
		@DetailScreenId
		,@DetailScreenDesc
		,@DetailScreenType
		,@DetailScreenURL
		,@TabId
		,NULL
		)  

	SET IDENTITY_INSERT screens OFF
END
ELSE
BEGIN
	UPDATE screens
	SET screenname = @DetailScreenDesc
		,screentype = @DetailScreenType
		,screenurl = @DetailScreenURL
		,tabid = @TabId
	WHERE screenid = @DetailScreenId
END


-- Script for Discrepancy Pop Up

SET @TabId = 1 
SET @DetailScreenId = 1228
SET @DetailScreenType = 5765 
SET @DetailScreenName = 'Discrepancy Pop Up'  
SET @DetailScreenDesc = 'Discrepancy Pop Up' 
SET @DetailScreenURL = '/Modules/CaseloadReassignment/Office/Custom/DiscrepancyPopUp.ascx' 
SET @DefaultOrder = 1 

IF NOT EXISTS (
		SELECT *
		FROM screens
		WHERE screenid = @DetailScreenId
		)
BEGIN
	SET IDENTITY_INSERT screens ON

	INSERT INTO screens (
		screenid
		,screenname
		,screentype
		,screenurl
		,tabid
		,InitializationStoredProcedure
		)
	VALUES (
		@DetailScreenId
		,@DetailScreenDesc
		,@DetailScreenType
		,@DetailScreenURL
		,@TabId
		,NULL
		)  

	SET IDENTITY_INSERT screens OFF
END
ELSE
BEGIN
	UPDATE screens
	SET screenname = @DetailScreenDesc
		,screentype = @DetailScreenType
		,screenurl = @DetailScreenURL
		,tabid = @TabId
	WHERE screenid = @DetailScreenId
END




