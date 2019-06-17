DECLARE @ScreenId INT  = 2211

IF NOT EXISTS( SELECT *
			   FROM Screens 
			   WHERE ScreenId = @ScreenId
			   )
			   BEGIN

SET IDENTITY_INSERT Screens ON
INSERT INTO dbo.Screens (ScreenId,ScreenName, ScreenType, ScreenURL, TabId )
SELECT @ScreenId,'Bed Actions',5765,'/WhiteBoard/Office/Custom/BedActions.ascx',1
SET IDENTITY_INSERT Screens OFF
END 
