-- Insert script for global codes related to category : PCHMTFREQUENCYTYPE
-- Diagnosis Changes (ICD10)# 14
--->>PCHMTFREQUENCYTYPE
IF NOT EXISTS(SELECT Category from GlobalCodeCategories WHERE Category='PCHMTFREQUENCYTYPE')
BEGIN
INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,Description,UserDefinedCategory,HasSubcodes,UsedInPracticeManagement,UsedInCareManagement)
VALUES('PCHMTFREQUENCYTYPE','Primary care health maintinance template frequency','Y','Y','Y','Y',NULL,'N','N','Y','Y') 
END
GO
------Start Insertion for Category PCHMTFREQUENCYTYPE------------------------------
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=8145)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Color)
VALUES(8145,'PCHMTFREQUENCYTYPE','Day(s)','DAYS',NULL,'Y','Y',1,NULL,NULL,NULL,NULL,NULL,null) 
SET IDENTITY_INSERT GlobalCodes OFF
END
GO
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=8146)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,CODE,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Color)
VALUES(8146,'PCHMTFREQUENCYTYPE','Week(s)','WEEKS',NULL,'Y','Y',2,NULL,NULL,NULL,NULL,NULL,null) 
SET IDENTITY_INSERT GlobalCodes OFF
END
GO
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=8147)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,CODE,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Color)
VALUES(8147,'PCHMTFREQUENCYTYPE','Month(s)','MONTHS',NULL,'Y','Y',3,NULL,NULL,NULL,NULL,NULL,null) 
SET IDENTITY_INSERT GlobalCodes OFF
END
GO
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=8148)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,CODE,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Color)
VALUES(8148,'PCHMTFREQUENCYTYPE','Year(s)','YEARS',NULL,'Y','Y',4,NULL,NULL,NULL,NULL,NULL,null) 
SET IDENTITY_INSERT GlobalCodes OFF
END
GO

------
