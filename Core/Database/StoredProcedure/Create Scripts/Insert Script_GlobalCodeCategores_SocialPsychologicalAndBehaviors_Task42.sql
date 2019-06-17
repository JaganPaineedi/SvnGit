-- *********** RESOURCESTRAINCODE START****************
IF NOT EXISTS(SELECT * from GlobalCodeCategories WHERE Category='RESOURCESTRAINCODE' and ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodeCategories
				(Category,
				CategoryName,
				Active,
				AllowAddDelete,
				AllowCodeNameEdit,
				AllowSortOrderEdit,
				[Description],
				UserDefinedCategory,
				HasSubcodes)
	VALUES('RESOURCESTRAINCODE',
			'Financial Resource Strain',
			'Y',
			'N',
			'Y',
			'Y',
			NULL,
			'N',
			'N') 
END

IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'RESOURCESTRAINCODE' AND Code='VERYHARD')
 BEGIN
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('RESOURCESTRAINCODE','Very Hard','VERYHARD','Y','Y',1,'LA15832-1')  
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'RESOURCESTRAINCODE' AND Code='HARD')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('RESOURCESTRAINCODE','Hard','HARD','Y','Y',2,'LA14745-6')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'RESOURCESTRAINCODE' AND Code='SOMEWHATHARD')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('RESOURCESTRAINCODE','Somewhat hard','SOMEWHATHARD','Y','Y',3,'LA22683-9')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'RESOURCESTRAINCODE' AND Code='NOTVERYHARD')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('RESOURCESTRAINCODE','Not very hard','NOTVERYHARD','Y','Y',4,'LA22682-1')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'RESOURCESTRAINCODE' AND Code='DECLINEDTOSPECIFY')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('RESOURCESTRAINCODE','Declined to Specify','DECLINEDTOSPECIFY','Y','Y',5)    
 END
 
-- *********** RESOURCESTRAINCODE END ****************
-- *********** EDUCATIONCODE START ****************
IF NOT EXISTS(SELECT * from GlobalCodeCategories WHERE Category='EDUCATIONCODE' and ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodeCategories
				(Category,
				CategoryName,
				Active,
				AllowAddDelete,
				AllowCodeNameEdit,
				AllowSortOrderEdit,
				[Description],
				UserDefinedCategory,
				HasSubcodes)
	VALUES('EDUCATIONCODE',
			'Education',
			'Y',
			'N',
			'Y',
			'Y',
			NULL,
			'N',
			'N') 
END

IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='NEVERATTENDEDKINDERGARTENONLY')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('EDUCATIONCODE','Never attended/kindergarten only','NEVERATTENDEDKINDERGARTENONLY','Y','Y',1,'LA15606-9')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='1STGRADE')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('EDUCATIONCODE','1st grade','1STGRADE','Y','Y',2,'LA15607-7')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='2NDGRADE')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('EDUCATIONCODE','2nd grade','2NDGRADE','Y','Y',3,'LA15608-5')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='3RDGRADE')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('EDUCATIONCODE','3rd grade','3RDGRADE','Y','Y',4,'LA15609-3')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='4THGRADE')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('EDUCATIONCODE','4th grade','4THGRADE','Y','Y',5,'LA15610-1')   
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='5THGRADE')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('EDUCATIONCODE','5th grade','5THGRADE','Y','Y',6,'LA15611-9')   
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='6THGRADE')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('EDUCATIONCODE','6th grade','6THGRADE','Y','Y',7,'LA15612-7')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='7THGRADE')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('EDUCATIONCODE','7th grade','7THGRADE','Y','Y',8,'LA15613-5')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='8THGRADE')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('EDUCATIONCODE','8th grade','8THGRADE','Y','Y',9,'LA15614-3')   
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='9THGRADE')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('EDUCATIONCODE','9th grade','9THGRADE','Y','Y',10,'LA15615-0')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='10THGRADE')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('EDUCATIONCODE','10th grade','10THGRADE','Y','Y',11,'LA15616-8')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='11THGRADE')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('EDUCATIONCODE','11th grade','11THGRADE','Y','Y',12,'LA15617-6')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='12THGRADENODIPLOMA')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('EDUCATIONCODE','12th grade, no diploma','12THGRADENODIPLOMA','Y','Y',13,'LA15618-4')   
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='HIGHSCHOOLGRADUATE')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('EDUCATIONCODE','High school graduate','HIGHSCHOOLGRADUATE','Y','Y',14,'LA15564-0')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='GEDOREQUIVALENT')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('EDUCATIONCODE','GED or equivalent','GEDOREQUIVALENT','Y','Y',15,'LA15619-2')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='SOMECOLLEGENODEGREE')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('EDUCATIONCODE','Some college, no degree','SOMECOLLEGENODEGREE','Y','Y',16,'LA15620-0')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='ASSOCIATEDEGREEOCCUPATIONAL')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('EDUCATIONCODE','Associate degree - occupational, technical, or vocational program','ASSOCIATEDEGREEOCCUPATIONAL','Y','Y',17,'LA15621-8')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='ASSOCIATEDEGREEACADEMICPROGRAM')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('EDUCATIONCODE','Associate degree - academic program','ASSOCIATEDEGREEACADEMICPROGRAM','Y','Y',18,'LA15622-6')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='BACHELORSDEGREE')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('EDUCATIONCODE','Bachelor''s degree (e.g., BA, AB, BS):','BACHELORSDEGREE','Y','Y',19,'LA12460-4')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='MASTERSDEGREE')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('EDUCATIONCODE','Master''s degree (e.g., MA, MS, MEng, MED, MSW, MBA):','MASTERSDEGREE','Y','Y',20,'LA12461-2')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='PROFESSIONALSCHOOLDEGREE')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('EDUCATIONCODE','Professional school degree (example: MD, DDS, DVM, JD)','PROFESSIONALSCHOOLDEGREE','Y','Y',21,'LA15625-9')   
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='DOCTORALDEGREE')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('EDUCATIONCODE','Doctoral degree (example: PhD, EdD)','DOCTORALDEGREE','Y','Y',22,'LA15626-7')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='REFUSED')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('EDUCATIONCODE','Refused','REFUSED','Y','Y',23,'LA4389-8')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='DONTKNOW')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('EDUCATIONCODE','Don''t Know','DONTKNOW','Y','Y',24,'LA12688-0')    
 END
  
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'EDUCATIONCODE' AND Code='DECLINEDTOSPECIFY')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('EDUCATIONCODE','Declined to Specify','DECLINEDTOSPECIFY','Y','Y',25)    
 END
 
-- *********** EDUCATIONCODE END ****************
-- *********** STRESSCODE START****************
IF NOT EXISTS(SELECT * from GlobalCodeCategories WHERE Category='STRESSCODE' and ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodeCategories
				(Category,
				CategoryName,
				Active,
				AllowAddDelete,
				AllowCodeNameEdit,
				AllowSortOrderEdit,
				[Description],
				UserDefinedCategory,
				HasSubcodes)
	VALUES('STRESSCODE',
			'Stress',
			'Y',
			'N',
			'Y',
			'Y',
			NULL,
			'N',
			'N') 
END

IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'STRESSCODE' AND Code='NOTATALL')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('STRESSCODE','Not at all','NOTATALL','Y','Y',1,'LA6568-5')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'STRESSCODE' AND Code='ONLYALITTLE')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('STRESSCODE','Only a little','ONLYALITTLE','Y','Y',2,'LA22687-0')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'STRESSCODE' AND Code='TOSOMEEXTENT')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('STRESSCODE','To some extent','TOSOMEEXTENT','Y','Y',3,'LA22686-2')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'STRESSCODE' AND Code='RATHERMUCH')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('STRESSCODE','Rather much','RATHERMUCH','Y','Y',4,'LA22685-4')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'STRESSCODE' AND Code='VERYMUCH')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('STRESSCODE','Very much','VERYMUCH','Y','Y',5,'LA13914-9')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'STRESSCODE' AND Code='DECLINEDTOSPECIFY')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('STRESSCODE','Declined to Specify','DECLINEDTOSPECIFY','Y','Y',6)    
 END
 
-- *********** RESOURCESTRAINCODE END ****************
-- *********** DEPRESSIONCODE START****************
IF NOT EXISTS(SELECT * from GlobalCodeCategories WHERE Category='DEPRESSIONCODE' and ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodeCategories
				(Category,
				CategoryName,
				Active,
				AllowAddDelete,
				AllowCodeNameEdit,
				AllowSortOrderEdit,
				[Description],
				UserDefinedCategory,
				HasSubcodes)
	VALUES('DEPRESSIONCODE',
			'Depression',
			'Y',
			'N',
			'Y',
			'Y',
			NULL,
			'N',
			'N') 
END

IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'DEPRESSIONCODE' AND Code='NOTATALL')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('DEPRESSIONCODE','Not at all','NOTATALL','Y','Y',1,'LA6568-5')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'DEPRESSIONCODE' AND Code='SEVERALDAYS')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('DEPRESSIONCODE','Several Days','SEVERALDAYS','Y','Y',2,'LA6569-3')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'DEPRESSIONCODE' AND Code='MORETHANHALFTHEDAYS')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('DEPRESSIONCODE','More than half the days','MORETHANHALFTHEDAYS','Y','Y',3,'LA6570-1')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'DEPRESSIONCODE' AND Code='NEARLYEVERYDAY')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('DEPRESSIONCODE','Nearly every day','NEARLYEVERYDAY','Y','Y',4,'LA6571-9')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'DEPRESSIONCODE' AND Code='DECLINEDTOSPECIFY')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('DEPRESSIONCODE','Declined to Specify','DECLINEDTOSPECIFY','Y','Y',5)    
 END
 
-- *********** DEPRESSIONCODE END ****************
-- *********** PHYSICALACTIVITYCODE START****************
IF NOT EXISTS(SELECT * from GlobalCodeCategories WHERE Category='PHYSICALACTIVITYCODE' and ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodeCategories
				(Category,
				CategoryName,
				Active,
				AllowAddDelete,
				AllowCodeNameEdit,
				AllowSortOrderEdit,
				[Description],
				UserDefinedCategory,
				HasSubcodes)
	VALUES('PHYSICALACTIVITYCODE',
			'Physical Activity',
			'Y',
			'N',
			'Y',
			'Y',
			NULL,
			'N',
			'N') 
END

IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'PHYSICALACTIVITYCODE' AND Code='0')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('PHYSICALACTIVITYCODE','0','0','Y','Y',1)    
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'PHYSICALACTIVITYCODE' AND Code='1')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('PHYSICALACTIVITYCODE','1','1','Y','Y',2)    
 END

IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'PHYSICALACTIVITYCODE' AND Code='2')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('PHYSICALACTIVITYCODE','2','2','Y','Y',3)    
 END

IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'PHYSICALACTIVITYCODE' AND Code='3')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('PHYSICALACTIVITYCODE','3','3','Y','Y',4)    
 END

IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'PHYSICALACTIVITYCODE' AND Code='4')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('PHYSICALACTIVITYCODE','4','4','Y','Y',5)    
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'PHYSICALACTIVITYCODE' AND Code='5')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('PHYSICALACTIVITYCODE','5','5','Y','Y',6)    
 END

IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'PHYSICALACTIVITYCODE' AND Code='6')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('PHYSICALACTIVITYCODE','6','6','Y','Y',7)    
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'PHYSICALACTIVITYCODE' AND Code='7')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('PHYSICALACTIVITYCODE','7','7','Y','Y',8)    
 END  
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'PHYSICALACTIVITYCODE' AND Code='DECLINEDTOSPECIFY')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('PHYSICALACTIVITYCODE','Declined to Specify','DECLINEDTOSPECIFY','Y','Y',9)    
 END
 
-- *********** DEPRESSIONCODE END ****************
-- *********** ALCOHOL1CODE START****************
IF NOT EXISTS(SELECT * from GlobalCodeCategories WHERE Category='ALCOHOL1CODE' and ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodeCategories
				(Category,
				CategoryName,
				Active,
				AllowAddDelete,
				AllowCodeNameEdit,
				AllowSortOrderEdit,
				[Description],
				UserDefinedCategory,
				HasSubcodes)
	VALUES('ALCOHOL1CODE',
			'Alcohol',
			'Y',
			'N',
			'Y',
			'Y',
			NULL,
			'N',
			'N') 
END

IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'ALCOHOL1CODE' AND Code='NEVER')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('ALCOHOL1CODE','Never','NEVER','Y','Y',1,'LA6270-8')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'ALCOHOL1CODE' AND Code='MONTHLYORLESS')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('ALCOHOL1CODE','Monthly or less','MONTHLYORLESS','Y','Y',2,'LA18926-8')   
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'ALCOHOL1CODE' AND Code='2-4TIMESAMONTH')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('ALCOHOL1CODE','2-4 times a month','2-4TIMESAMONTH','Y','Y',3,'A18927-6')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'ALCOHOL1CODE' AND Code='2-3TIMESAWEEK')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('ALCOHOL1CODE','2-3 times a week','2-3TIMESAWEEK','Y','Y',4,'LA18928-4')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'ALCOHOL1CODE' AND Code='4ORMORETIMESAWEEK')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('ALCOHOL1CODE','4 or more times a week','4ORMORETIMESAWEEK','Y','Y',5,'LA18929-2')    
 END
  
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'ALCOHOL1CODE' AND Code='DECLINEDTOSPECIFY')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('ALCOHOL1CODE','Declined to Specify','DECLINEDTOSPECIFY','Y','Y',6)   
 END
 
-- *********** ALCOHOL1CODE END ****************
-- *********** ALCOHOL2CODE START****************
IF NOT EXISTS(SELECT * from GlobalCodeCategories WHERE Category='ALCOHOL2CODE' and ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodeCategories
				(Category,
				CategoryName,
				Active,
				AllowAddDelete,
				AllowCodeNameEdit,
				AllowSortOrderEdit,
				[Description],
				UserDefinedCategory,
				HasSubcodes)
	VALUES('ALCOHOL2CODE',
			'Alcohol',
			'Y',
			'N',
			'Y',
			'Y',
			NULL,
			'N',
			'N') 
END

IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'ALCOHOL2CODE' AND Code='1OR2')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('ALCOHOL2CODE','1 or 2','1OR2','Y','Y',1,'LA15694-5')    
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'ALCOHOL2CODE' AND Code='3OR4')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('ALCOHOL2CODE','3 or 4','3OR4','Y','Y',2,'LA15695-2')   
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'ALCOHOL2CODE' AND Code='5OR6')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('ALCOHOL2CODE','5 or 6','5OR6','Y','Y',3,'LA18930-0')    
 END

IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'ALCOHOL2CODE' AND Code='7TO9')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('ALCOHOL2CODE','7 to 9','7TO9','Y','Y',4,'LA18931-8')    
 END

IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'ALCOHOL2CODE' AND Code='10ORMORE')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('ALCOHOL2CODE','10 or more','10ORMORE','Y','Y',5,'LA18932-6')    
 END

 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'ALCOHOL2CODE' AND Code='DECLINEDTOSPECIFY')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('ALCOHOL2CODE','Declined to Specify','DECLINEDTOSPECIFY','Y','Y',6)    
 END
 
-- *********** ALCOHOL2CODE END ****************
-- *********** ALCOHOL3CODE START****************
IF NOT EXISTS(SELECT * from GlobalCodeCategories WHERE Category='ALCOHOL3CODE' and ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodeCategories
				(Category,
				CategoryName,
				Active,
				AllowAddDelete,
				AllowCodeNameEdit,
				AllowSortOrderEdit,
				[Description],
				UserDefinedCategory,
				HasSubcodes)
	VALUES('ALCOHOL3CODE',
			'Alcohol',
			'Y',
			'N',
			'Y',
			'Y',
			NULL,
			'N',
			'N') 
END

IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'ALCOHOL3CODE' AND Code='NEVER')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('ALCOHOL3CODE','Never','NEVER','Y','Y',1,'LA6270-8')   
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'ALCOHOL3CODE' AND Code='LESSTHANMONTHLY')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('ALCOHOL3CODE','Less than monthly','LESSTHANMONTHLY','Y','Y',2,'LA18933-4')    
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'ALCOHOL3CODE' AND Code='MONTHLY')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('ALCOHOL3CODE','Monthly','MONTHLY','Y','Y',3,'LA18876-5')    
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'ALCOHOL3CODE' AND Code='WEEKLY')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('ALCOHOL3CODE','Weekly','WEEKLY','Y','Y',4,'LA18891-4')    
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'ALCOHOL3CODE' AND Code='DAILYORALMOSTDAILY')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('ALCOHOL3CODE','Daily or almost daily','DAILYORALMOSTDAILY','Y','Y',5,'LA18934-2')    
 END

 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'ALCOHOL3CODE' AND Code='DECLINEDTOSPECIFY')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('ALCOHOL3CODE','Declined to Specify','DECLINEDTOSPECIFY','Y','Y',6)    
 END
 
-- *********** ALCOHOL3CODE END ****************
-- *********** SOCIAL1CODE START****************
IF NOT EXISTS(SELECT * from GlobalCodeCategories WHERE Category='SOCIAL1CODE' and ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodeCategories
				(Category,
				CategoryName,
				Active,
				AllowAddDelete,
				AllowCodeNameEdit,
				AllowSortOrderEdit,
				[Description],
				UserDefinedCategory,
				HasSubcodes)
	VALUES('SOCIAL1CODE',
			'Social Connection and Isolation',
			'Y',
			'N',
			'Y',
			'Y',
			NULL,
			'N',
			'N') 
END

IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'SOCIAL1CODE' AND Code='MARRIED')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('SOCIAL1CODE','Married','MARRIED','Y','Y',1,'LA48-4')    
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'SOCIAL1CODE' AND Code='WIDOWED')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('SOCIAL1CODE','Widowed','WIDOWED','Y','Y',2,'LA49-2')    
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'SOCIAL1CODE' AND Code='DIVORCED')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('SOCIAL1CODE','Divorced','DIVORCED','Y','Y',3,'LA51-8')   
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'SOCIAL1CODE' AND Code='SEPARATED')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('SOCIAL1CODE','Separated','SEPARATED','Y','Y',4,'LA4288-2')    
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'SOCIAL1CODE' AND Code='NEVERMARRIED')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('SOCIAL1CODE','Never married','NEVERMARRIED','Y','Y',5,'LA47-6')   
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'SOCIAL1CODE' AND Code='LIVINGWITHPARTNER')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('SOCIAL1CODE','Living with partner','LIVINGWITHPARTNER','Y','Y',6,'LA15605-1')    
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'SOCIAL1CODE' AND Code='REFUSED')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('SOCIAL1CODE','Refused','REFUSED','Y','Y',7,'LA4389-8')   
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'SOCIAL1CODE' AND Code='DONTKNOW')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('SOCIAL1CODE','Don''t know','DONTKNOW','Y','Y',8,'LA12688-0')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'SOCIAL1CODE' AND Code='DECLINEDTOSPECIFY')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('SOCIAL1CODE','Declined to Specify','DECLINEDTOSPECIFY','Y','Y',9)   
 END
 
-- *********** SOCIAL1CODE END ****************
-- *********** SOCIAL2AND3CODE START****************
IF NOT EXISTS(SELECT * from GlobalCodeCategories WHERE Category='SOCIAL2AND3CODE' and ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodeCategories
				(Category,
				CategoryName,
				Active,
				AllowAddDelete,
				AllowCodeNameEdit,
				AllowSortOrderEdit,
				[Description],
				UserDefinedCategory,
				HasSubcodes)
	VALUES('SOCIAL2AND3CODE',
			'Social Connection and Isolation',
			'Y',
			'N',
			'Y',
			'Y',
			NULL,
			'N',
			'N') 
END

IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'SOCIAL2AND3CODE' AND Code='3ORMOREINTERACTIONSPERWEEK')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('SOCIAL2AND3CODE','3 or more interactions per week','3ORMOREINTERACTIONSPERWEEK','Y','Y',1)    
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'SOCIAL2AND3CODE' AND Code='LESSTHAN3INTERACTIONSPERWEEK')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('SOCIAL2AND3CODE','Less than 3 interactions per week','LESSTHAN3INTERACTIONSPERWEEK','Y','Y',2)    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'SOCIAL2AND3CODE' AND Code='DECLINEDTOSPECIFY')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('SOCIAL2AND3CODE','Declined to Specify','DECLINEDTOSPECIFY','Y','Y',3)    
 END
 
-- *********** SOCIAL2AND3CODE END ****************
-- *********** SOCIAL4CODE START****************
IF NOT EXISTS(SELECT * from GlobalCodeCategories WHERE Category='SOCIAL4CODE' and ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodeCategories
				(Category,
				CategoryName,
				Active,
				AllowAddDelete,
				AllowCodeNameEdit,
				AllowSortOrderEdit,
				[Description],
				UserDefinedCategory,
				HasSubcodes)
	VALUES('SOCIAL4CODE',
			'Social Connection and Isolation',
			'Y',
			'N',
			'Y',
			'Y',
			NULL,
			'N',
			'N') 
END

IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'SOCIAL4CODE' AND Code='MORETHAN4TIMESPERYEAR')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('SOCIAL4CODE','More than 4 times per year','MORETHAN4TIMESPERYEAR','Y','Y',1)    
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'SOCIAL4CODE' AND Code='4ORLESSTIMESPERYEAR')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('SOCIAL4CODE','4 or less times per year','4ORLESSTIMESPERYEAR','Y','Y',2)    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'SOCIAL4CODE' AND Code='DECLINEDTOSPECIFY')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('SOCIAL4CODE','Declined to Specify','DECLINEDTOSPECIFY','Y','Y',3)    
 END
 
-- *********** SOCIAL4CODE END ****************
-- *********** SOCIAL5CODE START****************
IF NOT EXISTS(SELECT * from GlobalCodeCategories WHERE Category='SOCIAL5CODE' and ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodeCategories
				(Category,
				CategoryName,
				Active,
				AllowAddDelete,
				AllowCodeNameEdit,
				AllowSortOrderEdit,
				[Description],
				UserDefinedCategory,
				HasSubcodes)
	VALUES('SOCIAL5CODE',
			'Social Connection and Isolation',
			'Y',
			'N',
			'Y',
			'Y',
			NULL,
			'N',
			'N') 
END

IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'SOCIAL5CODE' AND Code='YES')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('SOCIAL5CODE','Yes','YES','Y','Y',1,'LA33-6')    
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'SOCIAL5CODE' AND Code='NO')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('SOCIAL5CODE','No','NO','Y','Y',2,'LA32-8')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'SOCIAL5CODE' AND Code='DECLINEDTOSPECIFY')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('SOCIAL5CODE','Declined to Specify','DECLINEDTOSPECIFY','Y','Y',3)    
 END
 
-- *********** SOCIAL5CODE END ****************
-- *********** VIOLENCECODE START****************
IF NOT EXISTS(SELECT * from GlobalCodeCategories WHERE Category='VIOLENCECODE' and ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodeCategories
				(Category,
				CategoryName,
				Active,
				AllowAddDelete,
				AllowCodeNameEdit,
				AllowSortOrderEdit,
				[Description],
				UserDefinedCategory,
				HasSubcodes)
	VALUES('VIOLENCECODE',
			'Exposure to Violence',
			'Y',
			'N',
			'Y',
			'Y',
			NULL,
			'N',
			'N') 
END

IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'VIOLENCECODE' AND Code='YES')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('VIOLENCECODE','Yes','YES','Y','Y',1,'LA33-6')    
 END
 
IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'VIOLENCECODE' AND Code='NO')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('VIOLENCECODE','No','NO','Y','Y',2,'LA32-8')    
 END
 
 IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes WHERE Category = 'VIOLENCECODE' AND Code='DECLINEDTOSPECIFY')
 BEGIN  
  Insert into GlobalCodes(Category,CodeName,Code,Active,CannotModifyNameOrDelete,SortOrder)
  values('VIOLENCECODE','Declined to Specify','DECLINEDTOSPECIFY','Y','Y',3)    
 END
 
-- *********** VIOLENCECODE END ****************