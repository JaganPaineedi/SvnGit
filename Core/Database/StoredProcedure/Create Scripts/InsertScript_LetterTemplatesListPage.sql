DECLARE @TabId INT
DECLARE @screenId INT

SET @TabId = 4
SET @screenId = 1203


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
				,'Letter Templates' 
				,5762
				,'/ActivityPages/Admin/ListPages/LetterTemplateslistPage.ascx' 
				,'' 
				,@TabId )
	SET IDENTITY_INSERT dbo.Screens OFF  END
	
/********************************* SCREENS TABLE END ***************************************/

/************************************ BANNER TABLE *********************************************/

	IF NOT EXISTS (SELECT * FROM dbo.Banners WHERE ScreenId = @screenId)
BEGIN 
--SET IDENTITY_INSERT dbo.Banners ON 
		INSERT INTO Banners 
				(BannerName 
				 ,DisplayAs 
				 ,DefaultOrder 
				 ,Custom 
				 ,ScreenId 
				 ,TabId ) 
		VALUES	('Letter Templates' 
				,'Letter Templates' 
				,1
				,'N'
				,@screenId
				,@TabId 
		) 
	--SET IDENTITY_INSERT dbo.Banners OFF 
	 END 
/********************************* BANNER TABLE END ***************************************/

