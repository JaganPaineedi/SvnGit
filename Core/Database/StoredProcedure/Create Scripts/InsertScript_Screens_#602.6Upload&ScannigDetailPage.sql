  ----------------------------------------------------------------------------------------------------------
  ---Author : Manikandan
  -- Date   : 04/02/2016
  -- Purpose: Added a screen script for  Upload File Detail(741)and Scanned Medical Record Detail(742). Task#602.6 Network 180 Environment Issues Tracking.
  ------------------------------------------------------------------------------------------------------------
  
GO
	IF NOT EXISTS (SELECT * FROM SCREENS WHERE [SCREENID] = 741 )
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
					  (741 ,
					  'Upload File Detail'
					  ,5765					  
					  ,'/ActivityPages/Office/Custom/UploadMedicalRecordDetail.ascx'
					  ,2
					  )
		    SET IDENTITY_INSERT [SCREENS] OFF
		END
	ELSE
		BEGIN
			UPDATE Screens
			SET 
				ScreenName	=	'Upload File Detail',
				ScreenType	=	5765,
				ScreenURL	=	'/ActivityPages/Office/Custom/UploadMedicalRecordDetail.ascx',
				TabId		=	2   
			WHERE ScreenId	=	741       
		END
		
		IF NOT EXISTS (SELECT * FROM SCREENS WHERE [SCREENID] = 742 )
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
					  (742 ,
					  'Scanned Medical Record Detail'
					  ,5765					  
					  ,'/ActivityPages/Office/Custom/ScannedImageMedicalRecordDetail.ascx'
					  ,2
					  )
		    SET IDENTITY_INSERT [SCREENS] OFF
		END
	ELSE
		BEGIN
			UPDATE Screens
			SET 
				ScreenName	=	'Scanned Medical Record Detail',
				ScreenType	=	5765,
				ScreenURL	=	'/ActivityPages/Office/Custom/ScannedImageMedicalRecordDetail.ascx',
				TabId		=	2   
			WHERE ScreenId	=	742       
		END