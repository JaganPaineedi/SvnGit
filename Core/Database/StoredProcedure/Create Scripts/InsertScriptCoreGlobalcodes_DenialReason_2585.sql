--- Insert script for GlobalCode category  DENIALREASON and code name 'Claim line is identified for review and manual approval'
--Heartland East Customizations - Task #19

 IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE Category = 'DENIALREASON')
BEGIN 
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes,UsedInCareManagement)
	VALUES ('DENIALREASON','Denial Reason','Y','Y','Y','Y','N','N','Y') 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=2585)
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
	(2585,
	'DENIALREASON',
	'Claim line is identified for review and manual approval',
	'CLAIMLINEFORREVIEWMANUALAPPROVAL',
	'Y',
	'Y'
	) 
SET IDENTITY_INSERT GlobalCodes OFF
END

