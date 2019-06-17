--- Insert script for GlobalCode category  DENIALREASON and GlobalCodeId=2586 & 2587
--Heartland East Customizations - Task #19

 IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE Category = 'DENIALREASON')
BEGIN 
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes,UsedInCareManagement)
	VALUES ('DENIALREASON','Denial Reason','Y','Y','Y','Y','N','N','Y') 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=2586)
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
	(2586,
	'DENIALREASON',
	'Add-On Code: no corresponding base claim line found',
	'ADDONCODENOBASECLAIMLINEFOUND',
	'Y',
	'Y'
	) 
SET IDENTITY_INSERT GlobalCodes OFF
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=2587)
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
	(2587,
	'DENIALREASON',
	'Add-On Code: corresponding base claim line has not been approved',
	'ADDONCODEBASECLAIMLINENOTAPPROVED',
	'Y',
	'Y'
	) 
SET IDENTITY_INSERT GlobalCodes OFF
END

