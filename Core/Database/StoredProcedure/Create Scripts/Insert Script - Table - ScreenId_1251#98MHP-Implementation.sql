  ----------------------------------------------------------------------------------------------------------
  ---Author : Suneel N
  -- Date   : 20/06/2017
  -- Purpose: Ref #98 MHP - Implementation
  ------------------------------------------------------------------------------------------------------------
  
GO
	IF NOT EXISTS (SELECT * FROM SCREENS WHERE [SCREENID] = 1251)
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
					  (1251 ,
					  'Link Procedure Code and Degree'
					  ,5765					  
					  ,'/ActivityPages/Admin/Detail/PlansLinkCodeAndDegree.ascx'
					  ,4
					  )
		    SET IDENTITY_INSERT [SCREENS] OFF
		END
	ELSE
		BEGIN
			UPDATE Screens
			SET 
				ScreenName	=	'Link Procedure Code and Degree',
				ScreenType	=	5765,
				ScreenURL	=	'/ActivityPages/Admin/Detail/PlansLinkCodeAndDegree.ascx',
				TabId		=	4   
			WHERE ScreenId	=	1251       
		END