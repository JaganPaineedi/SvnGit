--- Insert script for GlobalCode category  DENIALREASON and code name 'Third Party Plan is fully responsible'

 IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE Category = 'DENIALREASON')
BEGIN 
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UsedInCareManagement)
	VALUES ('DENIALREASON','Denial Reason','Y','Y','Y','Y','Y') 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=2551)
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
	(2551,
	'DENIALREASON',
	'Third Party Plan is fully responsible',
	'THIRDPARTYPLANFULLYRESPONSE',
	'Y',
	'N'
	) 
SET IDENTITY_INSERT GlobalCodes OFF
END

