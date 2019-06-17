  ----------------------------------------------------------------------------------------------------------
  ---Author : Suneel N
  -- Date   : 25/07/2017
  -- Purpose: Ref #1262 HARBOR - Enhancements
  ------------------------------------------------------------------------------------------------------------
  
/********************************* SCREENS TABLE *****************************************/
	IF NOT EXISTS (SELECT * FROM SCREENS WHERE [SCREENID] = 1266)
		BEGIN
		  SET IDENTITY_INSERT [SCREENS] ON
			INSERT INTO [SCREENS]
					  ([SCREENID]
					  ,[SCREENNAME]
					  ,[SCREENTYPE]
					  ,[SCREENURL]
					  ,[TABID]
					  )
				VALUES 
					  (1266 ,
					  'Staff Preferences Notifications'
					  ,5761					  
					  ,'/ActivityPages/Office/Detail/MyPreferencesNotifications.ascx'
					  ,1
					  )
		    SET IDENTITY_INSERT [SCREENS] OFF
		END
	ELSE
		BEGIN
			UPDATE Screens
			SET 
				ScreenName	=	'Staff Preferences Notifications',
				ScreenType	=	5761,
				ScreenURL	=	'/ActivityPages/Office/Detail/MyPreferencesNotifications.ascx',
				TabId		=	1   
			WHERE ScreenId	=	1266       
		END
/********************************* SCREENS TABLE END *****************************************/		

IF EXISTS(SELECT 1 FROM dbo.Screens WHERE ScreenId in (17,1206) and ScreenName = 'My Preferences')
BEGIN
  UPDATE screens SET ScreenURL='/ActivityPages/Office/Detail/MyPreferencesDetail.ascx' WHERE ScreenId in (17,1206) AND ISNULL(RecordDeleted,'N')='N'
END	