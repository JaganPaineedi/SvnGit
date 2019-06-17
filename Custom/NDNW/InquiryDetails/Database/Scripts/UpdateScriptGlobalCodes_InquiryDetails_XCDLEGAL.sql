IF EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='XCDLEGAL')
BEGIN
Update GlobalCodes SET CodeName='Involuntary – Civil' WHERE Category='XCDLEGAL' and  CodeName='Involuntary ? Civil'
Update GlobalCodes SET CodeName='Involuntary – Criminal' WHERE Category='XCDLEGAL' and  CodeName='Involuntary ? Criminal'
End
