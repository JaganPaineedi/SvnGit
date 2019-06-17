SET IDENTITY_INSERT Screens ON
INSERT INTO dbo.Screens
        ( 
		  ScreenId,
          ScreenName ,
          ScreenType ,
          ScreenURL ,
          TabId ,
          Code
        )
		SELECT 2260,
		'MeasureSetValueSearch',
		5762,
		'/Modules/CQMSolutions/Admin/ListPage/MeasureValueSetSearch.ascx',
		4,
		'MeasureValueSetSearch'
		WHERE NOT EXISTS ( SELECT 1
							FROM Screens AS s
							WHERE  s.ScreenId = 2260
							AND ISNULL(s.RecordDeleted,'N')='N'
						)
SET IDENTITY_INSERT Screens OFF
