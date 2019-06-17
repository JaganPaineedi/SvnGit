
IF NOT EXISTS(select category from GlobalCodeCategories where category='TREATMENTTEAMROLE')
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory)
	VALUES('TREATMENTTEAMROLE','TREATMENTTEAMROLE','Y','Y','Y','Y','N')
END








 





