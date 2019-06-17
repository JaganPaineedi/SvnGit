IF NOT EXISTS(SELECT Category from GlobalCodeCategories WHERE Category='CONTACTNOTEREFTYPE')
BEGIN
INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,Description,UserDefinedCategory,HasSubcodes,UsedInCareManagement)
VALUES('CONTACTNOTEREFTYPE','CONTACTNOTEREFTYPE','Y','N','N','Y',NULL,'N','N','N') 
END
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=9378)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Code)
VALUES(9378,'CONTACTNOTEREFTYPE','Charge','NULL','Y','N',1,NULL,NULL,NULL,NULL,NULL,'CHARGE') 
SET IDENTITY_INSERT GlobalCodes OFF
END
GO
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=9379)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Code)
VALUES(9379,'CONTACTNOTEREFTYPE','Claim Line Item','NULL','Y','N',2,NULL,NULL,NULL,NULL,NULL,'CLAIMLINEITEM') 
SET IDENTITY_INSERT GlobalCodes OFF
END
GO
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=9380)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Code)
VALUES(9380,'CONTACTNOTEREFTYPE','Authorization','NULL','Y','N',3,NULL,NULL,NULL,NULL,NULL,'AUTHORIZATION') 
SET IDENTITY_INSERT GlobalCodes OFF
END
GO
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=9381)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Code)
VALUES(9381,'CONTACTNOTEREFTYPE','Contact Note','NULL','Y','N',4,NULL,NULL,NULL,NULL,NULL,'CONTACTNOTE') 
SET IDENTITY_INSERT GlobalCodes OFF
END
GO



