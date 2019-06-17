DECLARE @TabId INT
DECLARE @BannerName varchar(100)
DECLARE @ScreenId int

SET @TabId = 4
SET @BannerName = 'Error Log Viewer'
SET @ScreenId = 1305

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