  ----------------------------------------------------------------------------------------------------------
  ---Author : Vandana Ojha
  -- Date   : 08/02/2018
  -- Purpose: Ref #133 Texas Customizations
  ------------------------------------------------------------------------------------------------------------
  
GO
	IF NOT EXISTS (SELECT * FROM SCREENS WHERE [SCREENID] = 1314)
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
					  (1314 ,
					  'Link Codes and Program'
					  ,5765					  
					  ,'/ActivityPages/Admin/Detail/PlansLinkCodesandProgram.ascx'
					  ,4
					  )
		    SET IDENTITY_INSERT [SCREENS] OFF
		END
	ELSE
		BEGIN
			UPDATE Screens
			SET 
				ScreenName	=	'Link Codes and Program',
				ScreenType	=	5765,
				ScreenURL	=	'/ActivityPages/Admin/Detail/PlansLinkCodesandProgram.ascx',
				TabId		=	4   
			WHERE ScreenId	=	1314       
		END