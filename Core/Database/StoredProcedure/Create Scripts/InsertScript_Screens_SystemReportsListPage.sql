DECLARE @TabId INT
DECLARE @screenId INT

SET @TabId = 4
SET @screenId = 2005


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
				,'System Reports' 
				,5762
				,'/ActivityPages/Admin/ListPages/SystemReportsListPage.ascx' 
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
		VALUES	('System Reports' 
				,'System Reports' 
				,1
				,'N'
				,@screenId
				,@TabId 
		) 
	 END 

update banners set DefaultOrder=3 where ScreenId=2005
/********************************* BANNER TABLE END ***************************************/

