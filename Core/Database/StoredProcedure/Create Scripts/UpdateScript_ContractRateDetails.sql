IF EXISTS(SELECT ScreenId FROM Screens WHERE ScreenId=1161 AND ScreenType=5761 AND  ScreenName='Contracted Rates Detail' AND ValidationStoredProcedureUpdate is null)
BEGIN
 UPDATE Screens SET ValidationStoredProcedureUpdate='ssp_ValidateCoveragePlans' WHERE ScreenId=1161
END 