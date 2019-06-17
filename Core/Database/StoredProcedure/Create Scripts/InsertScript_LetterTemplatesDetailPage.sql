DECLARE @TabId INT
DECLARE @screenId INT

SET @TabId = 4
SET @screenId = 1202

/********************************* SCREENS TABLE *****************************************/
IF NOT EXISTS (SELECT * FROM screens WHERE ScreenId = @screenId) 
	BEGIN SET IDENTITY_INSERT dbo.Screens ON 
		INSERT INTO Screens 
				(SCREENID 
				 ,SCREENNAME 
				 ,SCREENTYPE 
				 ,SCREENURL 
				 ,SCREENTOOLBARURL 
				 ,TabId
				 ,ValidationStoredProcedureUpdate)  
		VALUES	(@screenId 
				,'Letter Templates Detail' 
				,5761 
				,'/ActivityPages/Admin/Detail/LetterTemplatesDetail.ascx' 
				,'' 
				,@TabId 
				,'ssp_ValidateLetterTemplates')
	SET IDENTITY_INSERT dbo.Screens OFF  END

/********************************* SCREENS TABLE END ***************************************/



