/********************************************************************************************
Author    :  Malathi Shiva  
CreatedDate  :  08 Sept 2014  
Purpose    :  GlobalCodes insert/update for Categories : LANGUAGE, RACE, HISPANICORIGIN, XINTERPRETERNEEDED, XSECODARYLANGUAGE
*********************************************************************************************/
--Category = 'LANGUAGE'   

DELETE
           FROM   GlobalCodes 
           WHERE  Category = 'LANGUAGE' 
                  AND Active = 'Y' and GlobalCodeId > 10000
      
IF EXISTS (SELECT 1 
           FROM   GlobalCodes 
           WHERE  Category = 'LANGUAGE' 
                  AND Active = 'N') 
  BEGIN 
      UPDATE GlobalCodes 
      SET    Active = 'Y' 
      WHERE  Category = 'LANGUAGE' 
  END 
DELETE
           FROM   GlobalCodes 
           WHERE  Category = 'XSECODARYLANGUAGE' 
                  AND Active = 'Y' and GlobalCodeId > 10000  
  
        
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'XSECODARYLANGUAGE'
		)
BEGIN
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XSECODARYLANGUAGE','XSECODARYLANGUAGE','Y','Y','Y','Y','Y','N') 
END
      
      
  IF NOT EXISTS(SELECT 1  
              FROM   GlobalCodes  
              WHERE  Category = 'XSECODARYLANGUAGE'  
                     AND CodeName = 'None')  
  BEGIN  
      INSERT INTO GlobalCodes  
                  (Category,CodeName,Active,CannotModifyNameOrDelete,Code)  
      VALUES      ('XSECODARYLANGUAGE','None','Y','N','None')  
  END
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XCOMMMETHOD') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XCOMMMETHOD','XCOMMMETHOD','Y','Y','Y','Y','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XCOMMMETHOD' 
                     AND CodeName = 'Verbal') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XCOMMMETHOD','Verbal','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XCOMMMETHOD' 
                     AND CodeName = 'Sign language') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XCOMMMETHOD','Sign language','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XCOMMMETHOD' 
                     AND CodeName = 'Written') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XCOMMMETHOD','Written','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XCOMMMETHOD' 
                     AND CodeName = 'Augmentative Devices') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XCOMMMETHOD','Augmentative Devices','Y','N') 
  END 

--Category = 'XINTERPRETERNEEDED' 
DELETE
           FROM   GlobalCodes 
           WHERE  Category = 'XINTERPRETERNEEDED'    
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XINTERPRETERNEEDED') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XINTERPRETERNEEDED','XINTERPRETERNEEDED','Y','Y','Y','Y','Y' 
                   , 
                   'N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XINTERPRETERNEEDED' 
                     AND CodeName = 'Yes') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XINTERPRETERNEEDED','Yes','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XINTERPRETERNEEDED' 
                     AND CodeName = 'No') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XINTERPRETERNEEDED','No','Y','N') 
  END 

--Category = 'XSECODARYLANGUAGE'

DELETE
           FROM   GlobalCodes 
           WHERE  Category = 'XSECODARYLANGUAGE' 
                  AND Active = 'Y' and GlobalCodeId > 10000    
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XSECODARYLANGUAGE') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XSECODARYLANGUAGE','XSECODARYLANGUAGE','Y','Y','Y','Y','Y', 
                   'N' 
      ) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSECODARYLANGUAGE') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Achinese','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Acoli','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Adangme','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Afar','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Akan','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Albanian-alb','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Arabic','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Armenian-arm','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Armenian -hye','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Bosnian','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Cambodian','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Chinese-Cantonese','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Croatian','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Efik','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','English','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Farsi','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','French','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','German-ger','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','German-deu','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Greek','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Hebrew','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Hindi','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Hmong','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Italian','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Japanese','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Karen','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Kirundian','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Korean','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Kurdish','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Laotian','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Navajo NativeAmerican','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Portuguese','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Romanian','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Russian','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Samoan','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Serbian','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Sign languages','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Somalian','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Spanish','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Sudanese','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Swahili','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Tamil','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Thai','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Tibetan','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Tongan','Y','N') 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','UTE Native American','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Vietnamese','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Zulu','Y','N') 
       INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSECODARYLANGUAGE','Other','Y','N') 
  END 

--Category = 'XPATIENTTYPE'    
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XPATIENTTYPE') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XPATIENTTYPE','XPATIENTTYPE','Y','Y','Y','Y','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XPATIENTTYPE') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XPATIENTTYPE','Test A','Y','N') 

      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XPATIENTTYPE','Test B','Y','N') 
  END 
  
  
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Achinese'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Achinese'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Acoli'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Acoli'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Adangme'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Adangme'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Afar'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Afar'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Akan'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Akan'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Albanian-alb'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Albanian-alb'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Arabic'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Arabic'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Armenian-arm'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Armenian-arm'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Armenian -hye'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Armenian -hye'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Bosnian'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Bosnian'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Cambodian'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Cambodian'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Chinese-Cantonese'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Chinese-Cantonese'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Croatian'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Croatian'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Efik'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Efik'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'English'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'English'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Farsi'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Farsi'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'French'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'French'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'German-ger'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'German-ger'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'German-deu'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'German-deu'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Greek'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Greek'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Hebrew'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Hebrew'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Hindi'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Hindi'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Hmong'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Hmong'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Italian'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Italian'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Japanese'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Japanese'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Karen'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Karen'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Kirundian'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Kirundian'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Korean'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Korean'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Kurdish'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Kurdish'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Laotian'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Laotian'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Navajo NativeAmerican'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Navajo NativeAmerican'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Portuguese'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Portuguese'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Romanian'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Romanian'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Russian'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Russian'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Samoan'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Samoan'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Serbian'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Serbian'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Sign languages'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Sign languages'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Somalian'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Somalian'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Spanish'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Spanish'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Sudanese'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Sudanese'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Swahili'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Swahili'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Tamil'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Tamil'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Thai'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Thai'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Tibetan'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Tibetan'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Tongan'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Tongan'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'UTE Native American'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'UTE Native American'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Vietnamese'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Vietnamese'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'LANGUAGE'
			AND CodeName = 'Zulu'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Zulu'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'Other'
			AND CodeName = 'Zulu'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'LANGUAGE'
		,'Other'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END


--Category = 'MARITALSTATUS'   
DELETE
           FROM   GlobalCodes 
           WHERE  Category = 'MARITALSTATUS' 
                  AND Active = 'Y' and GlobalCodeId > 10000


IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'MARITALSTATUS'
			AND CodeName = 'Never married'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'MARITALSTATUS'
		,'Never married'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'MARITALSTATUS'
			AND CodeName = 'Married'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'MARITALSTATUS'
		,'Married'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'MARITALSTATUS'
			AND CodeName = 'Separated'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'MARITALSTATUS'
		,'Separated'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'MARITALSTATUS'
			AND CodeName = 'Divorced'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'MARITALSTATUS'
		,'Divorced'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'MARITALSTATUS'
			AND CodeName = 'Widowed'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'MARITALSTATUS'
		,'Widowed'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'MARITALSTATUS'
			AND CodeName = 'Unknown'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'MARITALSTATUS'
		,'Unknown'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'MARITALSTATUS'
			AND CodeName = 'Living as married'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'MARITALSTATUS'
		,'Living as married'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END



--Category = 'HISPANICORIGIN'

DELETE
           FROM   GlobalCodes 
           WHERE  Category = 'HISPANICORIGIN' 
                  AND Active = 'Y' and GlobalCodeId > 10000
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'HISPANICORIGIN'
			AND CodeName = 'Hispanic (Puerto Rico)'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'HISPANICORIGIN'
		,'Hispanic (Puerto Rico)'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'HISPANICORIGIN'
			AND CodeName = 'Hispanic (Mexican)'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'HISPANICORIGIN'
		,'Hispanic (Mexican)'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'HISPANICORIGIN'
			AND CodeName = 'Hispanic (Cuban)'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'HISPANICORIGIN'
		,'Hispanic (Cuban)'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'HISPANICORIGIN'
			AND CodeName = 'Hispanic (No Specific Origin)'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'HISPANICORIGIN'
		,'Hispanic (No Specific Origin)'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'HISPANICORIGIN'
			AND CodeName = 'Not of Hispanic Origin'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'HISPANICORIGIN'
		,'Not of Hispanic Origin'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'HISPANICORIGIN'
			AND CodeName = 'Unknown'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'HISPANICORIGIN'
		,'Unknown'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
--Category = 'RACE'

DELETE
           FROM   GlobalCodes 
           WHERE  Category = 'RACE' 
                  AND Active = 'Y' and GlobalCodeId > 10000
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'RACE'
			AND CodeName = 'American Indian or Alaskan native'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'RACE'
		,'American Indian or Alaskan native'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'RACE'
			AND CodeName = 'Asian'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'RACE'
		,'Asian'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'RACE'
			AND CodeName = 'Black or African American'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'RACE'
		,'Black or African American'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'RACE'
			AND CodeName = 'White'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'RACE'
		,'White'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'RACE'
			AND CodeName = 'Other Single Race'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'RACE'
		,'Other Single Race'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'RACE'
			AND CodeName = 'Native Hawaiian or other'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'RACE'
		,'Native Hawaiian or other'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'RACE'
			AND CodeName = 'Pacific islander'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'RACE'
		,'Pacific islander'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'RACE'
			AND CodeName = 'Two or More Races'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'RACE'
		,'Two or More Races'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'RACE'
			AND CodeName = 'Unknown race'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'RACE'
		,'Unknown race'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 

--Category = 'XTRIBALAFFILIATION'

DELETE
           FROM   GlobalCodes 
           WHERE  Category = 'XTRIBALAFFILIATION' 
                  AND Active = 'Y' and GlobalCodeId > 10000
                  IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XTRIBALAFFILIATION') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XTRIBALAFFILIATION','XTRIBALAFFILIATION','Y','Y','Y','Y','Y','N') 
  END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XTRIBALAFFILIATION'
			AND CodeName = '01=Burns Paiute Tribe'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XTRIBALAFFILIATION'
		,'01=Burns Paiute Tribe'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XTRIBALAFFILIATION'
			AND CodeName = '02=Confederated Tribes of Coos, Lower Umpqua & Siuslaw'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XTRIBALAFFILIATION'
		,'02=Confederated Tribes of Coos, Lower Umpqua & Siuslaw'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XTRIBALAFFILIATION'
			AND CodeName = '03=Confederated Tribes of Grand Ronde'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XTRIBALAFFILIATION'
		,'03=Confederated Tribes of Grand Ronde'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XTRIBALAFFILIATION'
			AND CodeName = '04=Confederated Tribes of the Siletz'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XTRIBALAFFILIATION'
		,'04=Confederated Tribes of the Siletz'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XTRIBALAFFILIATION'
			AND CodeName = '05=Confederated Tribes of the Umatilla'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XTRIBALAFFILIATION'
		,'05=Confederated Tribes of the Umatilla'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XTRIBALAFFILIATION'
			AND CodeName = '06=Confederated Tribes of Warm Springs'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XTRIBALAFFILIATION'
		,'06=Confederated Tribes of Warm Springs'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XTRIBALAFFILIATION'
			AND CodeName = '07=Coquille Indian Tribe'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XTRIBALAFFILIATION'
		,'07=Coquille Indian Tribe'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XTRIBALAFFILIATION'
			AND CodeName = '08=Cow Creek Band of Umpqua Indians'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XTRIBALAFFILIATION'
		,'08=Cow Creek Band of Umpqua Indians'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XTRIBALAFFILIATION'
			AND CodeName = '09=Klamath Tribes'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XTRIBALAFFILIATION'
		,'09=Klamath Tribes'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XTRIBALAFFILIATION'
			AND CodeName = '10=Not Applicable'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XTRIBALAFFILIATION'
		,'10=Not Applicable'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 
IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodes
		WHERE Category = 'XTRIBALAFFILIATION'
			AND CodeName = '11=Other'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'XTRIBALAFFILIATION'
		,'11=Other'
		,NULL
		,NULL
		,'Y'
		,'Y'
		,1
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
END 






