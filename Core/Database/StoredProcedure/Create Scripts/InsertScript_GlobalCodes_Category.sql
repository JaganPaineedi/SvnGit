-- ASAMDOCUMNETEDRISK

IF NOT EXISTS (
		SELECT *
		FROM dbo.GlobalCodeCategories
		WHERE Category = 'ASAMDOCUMENTEDRISK'
		)
BEGIN
	INSERT INTO dbo.GlobalCodeCategories (
		Category
		,CategoryName
		,Active
		,AllowAddDelete
		,AllowCodeNameEdit
		,AllowSortOrderEdit
		,[Description]
		,UserDefinedCategory
		,HasSubcodes
		,UsedInPracticeManagement
		,UsedInCareManagement
		)
	VALUES (
		'ASAMDOCUMENTEDRISK'
		,'Documented Risk'
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		,NULL
		,'Y'
		,'N'
		,'N'
		,'N'
		)
END

DELETE FROM GlobalCodes WHERE Category = 'ASAMDOCUMENTEDRISK'
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
	VALUES (9387,'ASAMDOCUMENTEDRISK','Low',NULL,'Y','N',1,'')
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
	VALUES (9388,'ASAMDOCUMENTEDRISK','Moderate',NULL,'Y','N',2,'')
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
	VALUES (9389,'ASAMDOCUMENTEDRISK','High',NULL,'Y','N',3,'')

SET IDENTITY_INSERT GlobalCodes OFF	
	
	-- ASAMLEVEL
IF NOT EXISTS (
		SELECT *
		FROM dbo.GlobalCodeCategories
		WHERE Category = 'ASAMLEVEL'
		)
BEGIN
	INSERT INTO dbo.GlobalCodeCategories (
		Category
		,CategoryName
		,Active
		,AllowAddDelete
		,AllowCodeNameEdit
		,AllowSortOrderEdit
		,[Description]
		,UserDefinedCategory
		,HasSubcodes
		,UsedInPracticeManagement
		,UsedInCareManagement
		)
	VALUES (
		'ASAMLEVEL'
		,'Level'
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		,NULL
		,'Y'
		,'N'
		,'N'
		,'N'
		)
END

DELETE FROM GlobalCodes WHERE Category = 'ASAMLEVEL'
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
	VALUES (9390,'ASAMLEVEL','Level 0.5',NULL,'Y','N',1,'')
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
	VALUES (9391,'ASAMLEVEL','OPT – Level 1',NULL,'Y','N',2,'')
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
	VALUES (9392,'ASAMLEVEL','Level 1',NULL,'Y','N',3,'')
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
	VALUES (9393,'ASAMLEVEL','Level 2.1',NULL,'Y','N',4,'')
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
	VALUES (9394,'ASAMLEVEL','Level 2.5',NULL,'Y','N',5,'')
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
	VALUES (9395,'ASAMLEVEL','Level 3.1',NULL,'Y','N',6,'')
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
	VALUES (9396,'ASAMLEVEL','Level 3.3',NULL,'Y','N',7,'')
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
	VALUES (9397,'ASAMLEVEL','Level 3.5',NULL,'Y','N',8,'')
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
	VALUES (9398,'ASAMLEVEL','Level 3.7',NULL,'Y','N',9,'')
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
	VALUES (9399,'ASAMLEVEL','Level 4',NULL,'Y','N',10,'')

SET IDENTITY_INSERT GlobalCodes OFF