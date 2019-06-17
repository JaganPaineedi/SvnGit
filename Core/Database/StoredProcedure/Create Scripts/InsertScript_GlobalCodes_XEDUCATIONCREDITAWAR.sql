IF NOT EXISTS(SELECT Category from GlobalCodeCategories WHERE Category='EDUCATIONCREDITAWAR')
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,Description,UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES('EDUCATIONCREDITAWAR','EDUCATIONCREDITAWAR','Y','Y','Y','Y',NULL,'Y','N','Y') 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='0')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','0','0',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='.25')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','.25','.25',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='.50')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','.50','.50',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='.75')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','.75','.75',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='1.0')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','1.0','1.0',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='1.25')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','1.25','1.25',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='1.50')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','1.50','1.50',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='1.75')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','1.75','1.75',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='2.0')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','2.0','2.0',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='2.25')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','2.25','2.25',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='2.50')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','2.50','2.50',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='2.75')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','2.75','2.75',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='3.0')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','3.0','3.0',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='3.25')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','3.25','3.25',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='3.50')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','3.50','3.50',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='3.75')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','3.75','3.75',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='4.0')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','4.0','4.0',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='4.25')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','4.25','4.25',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='4.50')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','4.50','4.50',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='4.75')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','4.75','4.75',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='5.0')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','5.0','5.0',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='5.25')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','5.25','5.25',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='5.50')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','5.50','5.50',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='5.75')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','5.75','1.75',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='6.0')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','6.0','6.0',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='6.25')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','6.25','6.25',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='6.50')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','6.50','6.50',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='6.75')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','6.75','6.75',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='7.0')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','7.0','7.0',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='7.25')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','7.25','7.25',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='7.50')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','7.50','7.50',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='7.75')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','7.75','7.75',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='EDUCATIONCREDITAWAR' AND CodeName='8.0')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	VALUES('EDUCATIONCREDITAWAR','8.0','8.0',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
END