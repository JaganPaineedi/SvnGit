--Harbor Enhancements #18

IF EXISTS (SELECT 1 FROM Screens WHERE ScreenId = 772 AND ScreenName like 'Client Order')
BEGIN
	UPDATE Screens SET WarningStoredProcedureComplete ='ssp_WarningClientOrders' WHERE ScreenId = 772 AND ScreenName like 'Client Order'
END 
GO