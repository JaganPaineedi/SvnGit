-- Created By : Nandita S
-- Created On : 31 March 2016
-- Purpose    : Insert script for inserting GlobalCodeCategories, GlobalCodes to map the LOCUS level against its level description

---GlobalCodeCategory---------

IF NOT EXISTS(SELECT Category from GlobalCodeCategories WHERE Category='LOCUSLEVEL' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInCareManagement)
	VALUES('LOCUSLEVEL','LOCUSLEVEL','Y','Y','Y','Y',NULL,'N','N','Y') 
END
GO

--GlobalCode entries------------
---START Insertion for Category LOCUSLEVEL------------------------------
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=2770 AND Category='LOCUSLEVEL' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	SET IDENTITY_INSERT GlobalCodes ON
	INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
	VALUES(2770,'LOCUSLEVEL','Basic Services','Basic Services',NULL,'Y','N',Null,'0',NULL,NULL,NULL,NULL) 
	SET IDENTITY_INSERT GlobalCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=2771 AND Category='LOCUSLEVEL' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	SET IDENTITY_INSERT GlobalCodes ON
	INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
	VALUES(2771,'LOCUSLEVEL','Recovery Maintenance and Health Management','Recovery Maint and Health Mgmt',NULL,'Y','N',Null,'1',NULL,NULL,NULL,NULL) 
	SET IDENTITY_INSERT GlobalCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=2772 AND Category='LOCUSLEVEL' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	SET IDENTITY_INSERT GlobalCodes ON
	INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
	VALUES(2772,'LOCUSLEVEL','Low Intensity Community Based Services','Low Intensity Community Svcs',NULL,'Y','N',Null,'2',NULL,NULL,NULL,NULL) 
	SET IDENTITY_INSERT GlobalCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=2773 AND Category='LOCUSLEVEL' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	SET IDENTITY_INSERT GlobalCodes ON
	INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
	VALUES(2773,'LOCUSLEVEL','High Intensity Community Based Services','High Intensity Community Svcs',NULL,'Y','N',Null,'3',NULL,NULL,NULL,NULL) 
	SET IDENTITY_INSERT GlobalCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=2774 AND Category='LOCUSLEVEL' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	SET IDENTITY_INSERT GlobalCodes ON
	INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
	VALUES(2774,'LOCUSLEVEL','Medically Monitored Non-Residential Services','Med Monitored Non-Residential',NULL,'Y','N',Null,'4',NULL,NULL,NULL,NULL) 
	SET IDENTITY_INSERT GlobalCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=2775 AND Category='LOCUSLEVEL' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	SET IDENTITY_INSERT GlobalCodes ON
	INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
	VALUES(2775,'LOCUSLEVEL','Medically Monitored Residential Services','Med Monitored Residential',NULL,'Y','N',Null,'5',NULL,NULL,NULL,NULL) 
	SET IDENTITY_INSERT GlobalCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=2776 AND Category='LOCUSLEVEL' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	SET IDENTITY_INSERT GlobalCodes ON
	INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
	VALUES(2776,'LOCUSLEVEL','Medically Managed Residential Services','Medically Managed Residential Services',NULL,'Y','N',Null,'6',NULL,NULL,NULL,NULL) 
	SET IDENTITY_INSERT GlobalCodes OFF
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=2777 AND Category='LOCUSLEVEL' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	SET IDENTITY_INSERT GlobalCodes ON
	INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
	VALUES(2777,'LOCUSLEVEL','None','None',NULL,'Y','N',Null,'99',NULL,NULL,NULL,NULL) 
	SET IDENTITY_INSERT GlobalCodes OFF
END
GO