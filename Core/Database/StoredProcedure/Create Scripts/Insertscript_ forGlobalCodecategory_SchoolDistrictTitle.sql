--- Insert script for GlobalCode category   School District Title   

IF NOT EXISTS (SELECT * 
               FROM   GlobalCodeCategories 
               WHERE  Category ='SchoolDistrictTitle') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category 
                   ,CategoryName 
                   ,Active 
                   ,AllowAddDelete 
                   ,AllowCodeNameEdit 
                   ,AllowSortOrderEdit 
              ) 
      VALUES      ('SchoolDistrictTitle' 
                   ,'SchoolDistrictTitle' 
                   ,'Y'
                   ,'Y' 
                   ,'Y' 
                   ,'Y' 
                   ) 
  END 
  
  IF EXISTS (SELECT * FROM GlobalCodeCategories WHERE Category = 'SchoolDistrictTitle'  and isnull(RecordDeleted,'N')='N')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'SchoolDistrictTitle' AND CodeName = 'Value1')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('SchoolDistrictTitle','Value1','Y','N',1)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 1  WHERE Category = 'SchoolDistrictTitle' AND CodeName = 'Value2'
	END
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'SchoolDistrictTitle' AND CodeName = 'Value2')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('SchoolDistrictTitle','Value2','Y','N',2)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 2  WHERE Category = 'SchoolDistrictTitle' AND CodeName = 'Value2'
	END
   END

    