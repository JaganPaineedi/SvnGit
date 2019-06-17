--- Insert script for GlobalCode category  PROVIDERAUTHSTATUS and code name 'Consumer Appeal'
-- Task Network 180 Support Go Live #913
 IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE Category = 'PROVIDERAUTHSTATUS')
BEGIN 
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UsedInCareManagement,UserDefinedCategory,HasSubcodes)
	VALUES ('PROVIDERAUTHSTATUS','Consumer Appeal','Y','Y','Y','Y','Y','N','N') 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=2052)
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
	(2052,
	'PROVIDERAUTHSTATUS',
	'Consumer Appeal',
	'CONSUMERAPPEAL',
	'Y',
	'N'
	) 
SET IDENTITY_INSERT GlobalCodes OFF
END

