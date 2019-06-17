--Global Codes for CANS Document
--Date: July-02-2013
--Author: Md Hussain Khusro

IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodeCategories WHERE Category = 'XCANSDocType')
	BEGIN
		Insert into GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,Description,UserDefinedCategory,HasSubcodes,UsedInPracticeManagement,UsedInCareManagement,ExternalReferenceId) values
		('XCANSDocType','Document Type','Y','Y','Y','Y',NULL,'Y','N',NULL,NULL,NULL)
	END
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'XCANSDocType' AND CodeName='Initial')
	BEGIN
		Insert into GlobalCodes(Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		values('XCANSDocType','Initial','Y','N',1)
	END
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'XCANSDocType' AND CodeName='reassessment')
	BEGIN
		Insert into GlobalCodes(Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		values('XCANSDocType','reassessment','Y','N',2)
	END
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'XCANSDocType' AND CodeName='Transition/Discharge')
	BEGIN
		Insert into GlobalCodes(Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		values('XCANSDocType','Transition/Discharge','Y','N',3)
	END
	
