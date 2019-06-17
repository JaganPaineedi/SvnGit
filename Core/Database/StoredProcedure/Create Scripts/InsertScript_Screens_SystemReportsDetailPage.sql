DECLARE @TabId INT
DECLARE @screenId INT

SET @TabId = 4
SET @screenId = 2004

/********************************* SCREENS TABLE *****************************************/
IF NOT EXISTS (SELECT * FROM screens WHERE ScreenId = @screenId) 
	BEGIN SET IDENTITY_INSERT dbo.Screens ON 
		INSERT INTO Screens 
				(SCREENID 
				 ,SCREENNAME 
				 ,SCREENTYPE 
				 ,SCREENURL 
				 ,SCREENTOOLBARURL 
				 ,TabId) 
		VALUES	(@screenId 
				,'System Report Details' 
				,5761 
				,'/ActivityPages/Admin/Detail/SystemReportDetailPage.ascx' 
				,'' 
				,@TabId )
	SET IDENTITY_INSERT dbo.Screens OFF  END

/********************************* SCREENS TABLE END ***************************************/



