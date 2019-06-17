---->>LABSOFTMSGPRSTATUS
IF NOT EXISTS(SELECT Category from GlobalCodeCategories WHERE Category='LABSOFTMSGPRSTATUS')
BEGIN
INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,Description,UserDefinedCategory,HasSubcodes,UsedInCareManagement)
VALUES('LABSOFTMSGPRSTATUS','HL7 Message Processing Status','Y','Y','Y','Y',NULL,'N','N','Y') 
END


------START Insertion for Category LABSOFTMSGPRSTATUS------------------------------
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=9357)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES(9357,'LABSOFTMSGPRSTATUS','Ready For Processing','READYFORPROCESSING',NULL,'Y','N',1,NULL,NULL,NULL,NULL,NULL) 
SET IDENTITY_INSERT GlobalCodes OFF
END
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=9358)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES(9358,'LABSOFTMSGPRSTATUS','Ready For External System Processing','READYFOREXTERNALSYSTEMPROCESSING',NULL,'Y','N',2,NULL,NULL,NULL,NULL,NULL) 
SET IDENTITY_INSERT GlobalCodes OFF
END
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=9359)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES(9359,'LABSOFTMSGPRSTATUS','Ready For Internal System Processing','READYFORINTERNALSYSTEMPROCESSING',NULL,'Y','N',3,NULL,NULL,NULL,NULL,NULL) 
SET IDENTITY_INSERT GlobalCodes OFF
END
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=9360)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES(9360,'LABSOFTMSGPRSTATUS','Finalized','FINALIZED',NULL,'Y','N',4,NULL,NULL,NULL,NULL,NULL) 
SET IDENTITY_INSERT GlobalCodes OFF
END