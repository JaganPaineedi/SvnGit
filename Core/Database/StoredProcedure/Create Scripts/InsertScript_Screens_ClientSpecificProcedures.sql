DECLARE @ScreenId INT
DECLARE @ScreenType INT
DECLARE @ScreenName VARCHAR(64)
DECLARE @ScreenURL VARCHAR(200)
DECLARE @TabId INT

SET @ScreenId = 1225
SET @ScreenType = 5761
SET @ScreenName = 'Client Specific Default Procedure'
SET @ScreenURL = '/ActivityPages/Office/Detail/GroupServices/ClientSpecificProcedure.ascx'
SET @TabId = 1


IF NOT EXISTS (
		SELECT ScreenId
		FROM Screens
		WHERE ScreenId = @ScreenId
		)
BEGIN
	SET IDENTITY_INSERT Screens ON

	INSERT INTO [Screens] (
		  ScreenId
		,[ScreenName]
		,[ScreenType]
		,[ScreenURL]
		,[TabId]		
		)
	VALUES (
		 @ScreenId
		,@ScreenName
		,@ScreenType
		,@ScreenURL		
		,@TabId	
		)

	SET IDENTITY_INSERT Screens OFF
END
ELSE
BEGIN
	UPDATE screens
	SET screenname = @ScreenName
	   ,screentype = @ScreenType
	   ,screenurl  = @ScreenURL			
	WHERE screenid = @ScreenId
END