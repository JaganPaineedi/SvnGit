--NEW SUB GLOBAL CODE FOR XRESOURCETYPE
IF EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId = 8291)
BEGIN
	IF NOT EXISTS ( SELECT  * FROM    GlobalSubCodes WHERE   SubCodeName = 'Adult' ) 
	BEGIN
		INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
		VALUES(8291,'Adult',NULL,'Y','Y',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
	END	
	
	IF NOT EXISTS ( SELECT  * FROM    GlobalSubCodes WHERE   SubCodeName = 'Adolescent' ) 
	BEGIN
		INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
		VALUES(8291,'Adolescent',NULL,'Y','Y',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
	END
    
	IF NOT EXISTS ( SELECT  * FROM    GlobalSubCodes WHERE   SubCodeName = 'Children' ) 
	BEGIN
		INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
		VALUES(8291,'Children',NULL,'Y','Y',3,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
	END		
END

IF EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId = 8292)
BEGIN
	IF NOT EXISTS ( SELECT  * FROM    GlobalSubCodes WHERE   SubCodeName = 'Standard' ) 
	BEGIN
		INSERT INTO GlobalSubCodes(GlobalCodeId,SubCodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
		VALUES(8292,'Standard',NULL,'Y','Y',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
	END		
END

--NEW GLOBAL CODE FOR APPOINTMENT TYPE
IF NOT EXISTS (SELECT GlobalCodeId FROM GlobalCodes WHERE CodeName='Resource' AND Category='APPOINTMENTTYPE')
BEGIN
	INSERT INTO GlobalCodes(Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color) 
	VALUES('APPOINTMENTTYPE','Resource',NULL,'Y','Y',1,'Y',NULL,NULL,NULL,NULL,NULL,'ff00c000')
END