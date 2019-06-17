  ----------------------------------------------------------------------------------------------------------
  ---Author : Manikandan
  -- Date   : 04/02/2016
  -- Purpose: Added a screen script for 454 Procedure Code Details. Task#652.8 Network 180 Environment Issues Tracking.
  ------------------------------------------------------------------------------------------------------------
  
GO
	IF NOT EXISTS (SELECT * FROM SCREENS WHERE [SCREENID] = 454 )
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
					  (454 ,
					  'Procedure Code Details'
					  ,5761					  
					  ,'/ActivityPages/Admin/Detail/ProcedureRateGeneral.ascx'
					  ,4
					  )
		    SET IDENTITY_INSERT [SCREENS] OFF
		END
	ELSE
		BEGIN
			UPDATE Screens
			SET 
				ScreenName	=	'Procedure Code Details',
				ScreenType	=	5761,
				ScreenURL	=	'/ActivityPages/Admin/Detail/ProcedureRateGeneral.ascx',
				TabId		=	4   
			WHERE ScreenId	=	454       
		END