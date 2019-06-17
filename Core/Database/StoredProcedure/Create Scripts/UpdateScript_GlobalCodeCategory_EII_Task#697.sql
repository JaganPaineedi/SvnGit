
-- 08/06/2018	Msood	What: Changed UserDefinedCategory ='N' as it is core Global Code Category
If Exists (Select * from GlobalCodeCategories where Category ='ASAMLEVEL')
Begin
Update GlobalCodeCategories Set UserDefinedCategory ='N'where Category ='ASAMLEVEL'
End
Go