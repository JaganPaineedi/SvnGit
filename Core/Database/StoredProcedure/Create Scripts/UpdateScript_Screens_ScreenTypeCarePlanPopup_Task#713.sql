

IF EXISTS (SELECT * FROM Screens Where ScreenId=1087 AND ScreenType=5763)
BEGIN
	UPDATE Screens SET ScreenType=5765 Where ScreenId=1087 
END   