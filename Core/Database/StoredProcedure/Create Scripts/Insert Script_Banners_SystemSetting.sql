DECLARE @TabId INT
DECLARE @BannerName varchar(100)
DECLARE @ScreenId int

SET @TabId = 4
SET @BannerName = 'System Settings'
SET @ScreenId = 1060

/************************************ BANNER TABLE *********************************************/

	IF NOT EXISTS (SELECT * FROM dbo.Banners WHERE BannerName = @BannerName)
BEGIN 
		INSERT INTO Banners 
				(BannerName 
				 ,DisplayAs 
				 ,DefaultOrder 
				 ,Custom 
				 ,ScreenId 
				 ,TabId ) 
		VALUES	(@BannerName 
				,@BannerName
				,1
				,'N'
				,@screenId
				,@TabId 
		) 
	 END 
/********************************* BANNER TABLE END ***************************************/
	 
/********************************* BANNER TABLE Update ***************************************/
IF EXISTS (SELECT * FROM dbo.Banners WHERE ScreenId = 1060)
BEGIN
Update Banners SET ParentBannerId=(select BannerId FROM Banners where BannerName = @BannerName) where ScreenId=1060
END
/********************************* BANNER TABLE Update END ***************************************/

/********************************* BANNER TABLE Update ***************************************/
IF EXISTS (SELECT * FROM dbo.Banners WHERE ScreenId = 2002)
BEGIN
Update Banners SET ParentBannerId=(select BannerId FROM Banners where BannerName = @BannerName) where ScreenId=2002
END
/********************************* BANNER TABLE Update END ***************************************/
/********************************* BANNER TABLE Update ***************************************/
IF EXISTS (SELECT * FROM dbo.Banners WHERE ScreenId = 2005)
BEGIN
Update Banners SET ParentBannerId=(select BannerId FROM Banners where BannerName = @BannerName) where ScreenId=2005
END
/********************************* BANNER TABLE Update END ***************************************/





