---->>ClientConsents
IF NOT EXISTS(SELECT Category from GlobalCodeCategories WHERE Category='ClientConsents')
BEGIN
INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,Description,UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
VALUES('ClientConsents','Client Declined To Provide','Y','N','N','N',NULL,'N','N','Y') 
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=6051)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
	INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,
	SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
	VALUES(6051,'ClientConsents','Date of Birth',NULL,'Y','Y',1,'Date of Birth',NULL,NULL,NULL,NULL) 
SET IDENTITY_INSERT GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE GlobalCodes SET CodeName = 'Date of Birth', Active = 'Y', CannotModifyNameOrDelete='N' ,SortOrder=1
	WHERE GlobalCodeId=6051
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=6047)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
	INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,
	SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
	VALUES(6047,'ClientConsents','Sex',NULL,'Y','Y',2,'Sex',NULL,NULL,NULL,NULL) 
SET IDENTITY_INSERT GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE GlobalCodes SET CodeName = 'Sex', Active = 'Y', CannotModifyNameOrDelete='N',SortOrder=2
	WHERE GlobalCodeId=6047
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=6048)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
	INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,
	SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
	VALUES(6048,'ClientConsents','Race',NULL,'Y','Y',3,'Race',NULL,NULL,NULL,NULL) 
SET IDENTITY_INSERT GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE GlobalCodes SET CodeName = 'Race', Active = 'Y', CannotModifyNameOrDelete='N',SortOrder=3
	WHERE GlobalCodeId=6048
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=6049)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
	INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,
	SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
	VALUES(6049,'ClientConsents','Primary/Preferred Language',NULL,'Y','Y',4,'Primary/Preferred Lang',NULL,NULL,NULL,NULL) 
SET IDENTITY_INSERT GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE GlobalCodes SET CodeName = 'Primary/Preferred Language', Active = 'Y', CannotModifyNameOrDelete='N',SortOrder=4
	WHERE GlobalCodeId=6049
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=6050)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
	INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,
	SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
	VALUES(6050,'ClientConsents','Hispanic Origin',NULL,'Y','Y',5,'Hispanic Origin',NULL,NULL,NULL,NULL) 
SET IDENTITY_INSERT GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE GlobalCodes SET CodeName = 'Hispanic Origin', Active = 'Y', CannotModifyNameOrDelete='N',SortOrder=5
	WHERE GlobalCodeId=6050
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=9405)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
	INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,
	SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
	VALUES(9405,'ClientConsents','Gender Identity',NULL,'Y','N',6,'Gender Identity',NULL,NULL,NULL,NULL) 
SET IDENTITY_INSERT GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE GlobalCodes SET CodeName = 'Gender Identity', Active = 'Y', CannotModifyNameOrDelete='N',SortOrder=6
	WHERE GlobalCodeId=9405
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=9406)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
	INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,
	SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
	VALUES(9406,'ClientConsents','Sexual Orientation',NULL,'Y','N',7,'Sexual Orientation',NULL,NULL,NULL,NULL) 
SET IDENTITY_INSERT GlobalCodes OFF
END
ELSE
BEGIN
	UPDATE GlobalCodes SET CodeName = 'Sexual Orientation', Active = 'Y', CannotModifyNameOrDelete='N',SortOrder=7
	WHERE GlobalCodeId=9406
END
GO