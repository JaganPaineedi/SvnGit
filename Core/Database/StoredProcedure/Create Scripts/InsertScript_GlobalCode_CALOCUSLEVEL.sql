-- Created By : Kaushal Pandey
-- Created On : 26-11-2018
-- Purpose    : Created new copy of LOCUS TO CALOCUS for task#21 	MHP - Enhancements - CALOCUS
			
---GlobalCodeCategory---------

IF NOT EXISTS(SELECT Category from GlobalCodeCategories WHERE Category='CALOCUSLEVEL' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInCareManagement)
	VALUES('CALOCUSLEVEL','CALOCUSLEVEL','Y','Y','Y','Y',NULL,'N','N','Y') 
END
GO

--GlobalCode entries------------
---START Insertion for Category CALOCUSLEVEL------------------------------
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CALOCUSLEVEL' AND Code = 'Basic Services' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
	VALUES('CALOCUSLEVEL','Basic Services','Basic Services',NULL,'Y','N',Null,'0',NULL,NULL,NULL,NULL) 
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CALOCUSLEVEL' AND Code = 'Recovery Maint and Health Mgmt' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
	VALUES('CALOCUSLEVEL','Recovery Maintenance and Health Management','Recovery Maint and Health Mgmt',NULL,'Y','N',Null,'1',NULL,NULL,NULL,NULL) 
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CALOCUSLEVEL' AND CODE='Low Intensity Community Svcs' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
	VALUES('CALOCUSLEVEL','Low Intensity Community Based Services','Low Intensity Community Svcs',NULL,'Y','N',Null,'2',NULL,NULL,NULL,NULL) 
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CALOCUSLEVEL' AND CODE = 'High Intensity Community Svcs' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
	VALUES('CALOCUSLEVEL','High Intensity Community Based Services','High Intensity Community Svcs',NULL,'Y','N',Null,'3',NULL,NULL,NULL,NULL) 
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CALOCUSLEVEL' AND CODE = 'Med Monitored Non-Residential' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
	VALUES('CALOCUSLEVEL','Medically Monitored Non-Residential Services','Med Monitored Non-Residential',NULL,'Y','N',Null,'4',NULL,NULL,NULL,NULL) 
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CALOCUSLEVEL' AND CODE='Med Monitored Residential' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
	VALUES('CALOCUSLEVEL','Medically Monitored Residential Services','Med Monitored Residential',NULL,'Y','N',Null,'5',NULL,NULL,NULL,NULL) 
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CALOCUSLEVEL' AND CODE='Medically Managed Residential Services' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
	VALUES('CALOCUSLEVEL','Medically Managed Residential Services','Medically Managed Residential Services',NULL,'Y','N',Null,'6',NULL,NULL,NULL,NULL) 
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CALOCUSLEVEL' AND CODE='None' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
	VALUES('CALOCUSLEVEL','None','None',NULL,'Y','N',Null,'99',NULL,NULL,NULL,NULL) 
END
GO