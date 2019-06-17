
--GlobalCode Category XEVENTINSURER
--Created By Swapan Mohan
--Created on 28 Dec 2012
If NOT EXISTS(SELECT 1 FROM GlobalCodeCategories WHERE Category='XEVENTINSURER')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes)
	VALUES ('XEVENTINSURER','XEVENTINSURER','Y','Y','Y','Y','Y','N')
END	

IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category='XEVENTINSURER' and CodeName='KCMHSAS')
BEGIN
	INSERT INTO [GlobalCodes]([Category],[CodeName],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XEVENTINSURER','KCMHSAS','Y','N',1)
END

IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category='XEVENTINSURER' and CodeName='KCMHSAS SA')
BEGIN
	INSERT INTO [GlobalCodes]([Category],[CodeName],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('XEVENTINSURER','KCMHSAS SA','Y','N',2)
END

GO


----------------------------------------------------4---------------------------------------------