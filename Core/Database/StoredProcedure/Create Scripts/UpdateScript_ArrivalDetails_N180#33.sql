IF EXISTS (SELECT ScreenID FROM Screens WHERE ScreenID=1078)
BEGIN
	UPDATE Screens
	SET 
		PostUpdateStoredProcedure='ssp_PostUpdateArrivalDetails'
	WHERE ScreenID=1078
END