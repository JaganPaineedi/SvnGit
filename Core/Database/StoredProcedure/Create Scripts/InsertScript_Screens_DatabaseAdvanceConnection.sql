DECLARE @TabId INT
DECLARE @screenId INT

SET @TabId = 4
SET @screenId = 2007


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
				,'Connection String Info' 
				,5765
				,'/ActivityPages/Admin/Detail/DatabaseAdvanceConnection.ascx' 
				,'' 
				,@TabId )
	SET IDENTITY_INSERT dbo.Screens OFF  END
	
/********************************* SCREENS TABLE END ***************************************/