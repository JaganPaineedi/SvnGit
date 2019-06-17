IF EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=40128)
BEGIN
Update GlobalCodes SET CodeName='Involuntary – Civil' WHERE GlobalCodeId=40128
End
IF EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=40129)
BEGIN
Update GlobalCodes SET CodeName='Involuntary – Criminal' WHERE GlobalCodeId=40129
End