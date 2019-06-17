-- 08/06/2018	Msood		Porter Starke-Support Go Live Task #46

If Not Exists(Select *
	from GlobalCodeCategories
	where Category ='SULIVINGARRANGEMENT')
Begin
	Insert into GlobalCodeCategories ( Category,              CategoryName,            Active, AllowAddDelete, AllowSortOrderEdit, AllowCodeNameEdit, UserDefinedCategory, HasSubCodes )
	Values                           ( 'SULIVINGARRANGEMENT', 'SU Living Arrangement', 'Y',    'Y',            'Y',                'Y',               'N',                 'N'         )
End
Else
	Update GlobalCodeCategories
	Set Active              = 'Y'
	,   AllowAddDelete      = 'Y'
	,   AllowSortOrderEdit  = 'Y'
	,   AllowCodeNameEdit   = 'Y'
	,   UserDefinedCategory = 'N'
	,   HasSubCodes         = 'N'
	where Category ='SULIVINGARRANGEMENT'
Go

