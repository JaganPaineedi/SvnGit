--- Insert script for GlobalCode category  DOCUMENTSTATUS and code name 'Error'

 IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE Category = 'DOCUMENTSTATUS')
BEGIN 
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('DOCUMENTSTATUS','Document Status','Y','Y','Y','Y','N','N','Y') 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=26)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes
	(GlobalCodeId,
	Category,
	CodeName,
	Code,
	Active,
	CannotModifyNameOrDelete
	)
	VALUES
	(26,
	'DOCUMENTSTATUS',
	'Error',
	'ERROR',
	'Y',
	'N'
	) 
SET IDENTITY_INSERT GlobalCodes OFF
END

