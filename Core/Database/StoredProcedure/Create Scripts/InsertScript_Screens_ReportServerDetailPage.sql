DECLARE @TabId INT
DECLARE @screenId INT
DECLARE @DocumentCodeId INT


SET @TabId = 4
SET @screenId = 2002


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
				,'Report Server Details' 
				,5761 
				,'/ActivityPages/Admin/Detail/ReportServerDetailPage.ascx' 
				,'' 
				,@TabId ) 
	SET IDENTITY_INSERT dbo.Screens OFF  END

/********************************* SCREENS TABLE END ***************************************/

/************************************ BANNER TABLE *********************************************/

	IF NOT EXISTS (SELECT * FROM dbo.Banners WHERE ScreenId = @screenId)
BEGIN 
		INSERT INTO Banners 
				(BannerName 
				 ,DisplayAs 
				 ,DefaultOrder 
				 ,Custom 
				 ,ScreenId 
				 ,TabId ) 
		VALUES	('Report Server Details' 
				,'Report Server Details' 
				,1
				,'N'
				,@screenId
				,@TabId 
		) 
	 END


/********************************* BANNER TABLE END ***************************************/

