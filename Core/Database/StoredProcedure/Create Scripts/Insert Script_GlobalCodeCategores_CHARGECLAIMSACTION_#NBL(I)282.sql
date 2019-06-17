--------------GlobalCodeCategories CHARGECLAIMSACTION------------------------------
IF NOT EXISTS(SELECT Category from GlobalCodeCategories WHERE Category='CHARGECLAIMSACTION')
BEGIN
INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,Description,UserDefinedCategory,HasSubcodes,UsedInPracticeManagement,UsedInCareManagement)
VALUES('CHARGECLAIMSACTION','ChargeClaimsAction','Y','Y','Y','Y',NULL,'N','N',NULL,NULL) 
END
GO

---START Insertion for GlobalCodes CHARGECLAIMSACTION------------------------------

SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CHARGECLAIMSACTION' and GlobalCodeId=7501)
BEGIN

INSERT INTO GlobalCodes(GlobalCodeId, Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES(7501,'CHARGECLAIMSACTION','Mark Ready to Bill',NULL,'Y','Y',1,NULL,NULL,NULL,NULL,NULL) 

END
SET IDENTITY_INSERT GlobalCodes OFF

SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CHARGECLAIMSACTION' and GlobalCodeId=7502)
BEGIN

INSERT INTO GlobalCodes(GlobalCodeId, Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES(7502,'CHARGECLAIMSACTION','Remove from Ready to Bill',NULL,'Y','Y',2,NULL,NULL,NULL,NULL,NULL) 

END
SET IDENTITY_INSERT GlobalCodes OFF

SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CHARGECLAIMSACTION' and GlobalCodeId=7503)
BEGIN

INSERT INTO GlobalCodes(GlobalCodeId, Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES(7503,'CHARGECLAIMSACTION','Mark as Flagged',NULL,'Y','Y',3,NULL,NULL,NULL,NULL,NULL) 

END
SET IDENTITY_INSERT GlobalCodes OFF

SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CHARGECLAIMSACTION' and GlobalCodeId=7504)
BEGIN

INSERT INTO GlobalCodes(GlobalCodeId, Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES(7504,'CHARGECLAIMSACTION','Remove Flagged',NULL,'Y','Y',4,NULL,NULL,NULL,NULL,NULL) 

END
SET IDENTITY_INSERT GlobalCodes OFF

SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CHARGECLAIMSACTION' and GlobalCodeId=3705)
BEGIN

INSERT INTO GlobalCodes(GlobalCodeId, Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES(3705,'CHARGECLAIMSACTION','Mark as Rebill',NULL,'Y','Y',5,NULL,NULL,NULL,NULL,NULL) 

END
SET IDENTITY_INSERT GlobalCodes OFF

SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CHARGECLAIMSACTION' and GlobalCodeId=3706)
BEGIN

INSERT INTO GlobalCodes(GlobalCodeId, Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES(3706,'CHARGECLAIMSACTION','Remove from Rebill',NULL,'Y','Y',6,NULL,NULL,NULL,NULL,NULL) 

END
SET IDENTITY_INSERT GlobalCodes OFF

SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CHARGECLAIMSACTION' and GlobalCodeId=3707)
BEGIN

INSERT INTO GlobalCodes(GlobalCodeId, Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES(3707,'CHARGECLAIMSACTION','Mark as Do Not Bill',NULL,'Y','Y',7,NULL,NULL,NULL,NULL,NULL) 

END
SET IDENTITY_INSERT GlobalCodes OFF

SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CHARGECLAIMSACTION' and GlobalCodeId=3708)
BEGIN

INSERT INTO GlobalCodes(GlobalCodeId, Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES(3708,'CHARGECLAIMSACTION','Remove from Do Not Bill',NULL,'Y','Y',8,NULL,NULL,NULL,NULL,NULL) 

END
SET IDENTITY_INSERT GlobalCodes OFF

SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CHARGECLAIMSACTION' and GlobalCodeId=3709)
BEGIN

INSERT INTO GlobalCodes(GlobalCodeId, Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES(3709,'CHARGECLAIMSACTION','Mark claim line To Be Voided',NULL,'Y','Y',9,NULL,NULL,NULL,NULL,NULL) 

END
SET IDENTITY_INSERT GlobalCodes OFF

SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CHARGECLAIMSACTION' and GlobalCodeId=3710)
BEGIN

INSERT INTO GlobalCodes(GlobalCodeId, Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES(3710,'CHARGECLAIMSACTION','Mark claim line To Be Replaced',NULL,'Y','Y',10,NULL,NULL,NULL,NULL,NULL) 

END
SET IDENTITY_INSERT GlobalCodes OFF
GO