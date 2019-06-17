----------------------------------------   Screens Table   -----------------------------------  
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
DECLARE @ScreenName VARCHAR(100)
DECLARE @ScreenType INT
DECLARE @ScreenURL VARCHAR(200)
DECLARE @ScreenToolbarURL VARCHAR(200)
DECLARE @TabId INT
DECLARE @ScreenCode VARCHAR(100)

SET @ScreenName = 'Match Screen'
SET @ScreenType = 5765
SET @ScreenURL = '/Modules/MessageInterface/ActivityPages/Admin/Detail/MatchPopUpScreen.ascx'
SET @ScreenToolbarURL = NULL
SET @TabId = 4
SET @ScreenCode = 'MatchMessageInterface'

IF NOT EXISTS (
		SELECT ScreenId
		FROM Screens
		WHERE Code = @ScreenCode
		)
BEGIN
	INSERT INTO [Screens] (
		 [ScreenName]
		,[ScreenType]
		,[ScreenURL]
		,[TabId]
		,[Code]
		)
	VALUES (
		 @ScreenName
		,@ScreenType
		,@ScreenURL
		,@TabId
		,@ScreenCode
		)
END
		-----------------------------------------------END--------------------------------------------  
