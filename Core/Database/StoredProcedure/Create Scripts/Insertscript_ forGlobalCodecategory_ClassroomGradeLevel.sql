--- Insert script for GlobalCode category   ClassroomGradeLevel   

IF NOT EXISTS (SELECT * 
               FROM   GlobalCodeCategories 
               WHERE  Category ='ClassroomGradeLevel') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category 
                   ,CategoryName 
                   ,Active 
                   ,AllowAddDelete 
                   ,AllowCodeNameEdit 
                   ,AllowSortOrderEdit 
              ) 
      VALUES      ('ClassroomGradeLevel' 
                   ,'ClassroomGradeLevel' 
                   ,'Y'
                   ,'Y' 
                   ,'Y' 
                   ,'Y' 
                   ) 
  END 
  
  IF EXISTS (SELECT * FROM GlobalCodeCategories WHERE Category = 'ClassroomGradeLevel'  and isnull(RecordDeleted,'N')='N')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'ClassroomGradeLevel' AND CodeName = 'Freshman')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('ClassroomGradeLevel','Freshman','Y','N',1)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 1  WHERE Category = 'ClassroomGradeLevel' AND CodeName = 'Freshman'
	END
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'ClassroomGradeLevel' AND CodeName = 'Sophomore')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('ClassroomGradeLevel','Sophomore','Y','N',2)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 2  WHERE Category = 'ClassroomGradeLevel' AND CodeName = 'Sophomore'
	END
	
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'ClassroomGradeLevel' AND CodeName = 'Junior')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('ClassroomGradeLevel','Junior','Y','N',3)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 3   WHERE Category = 'ClassroomGradeLevel' AND CodeName = 'Junior'
	END
	
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'ClassroomGradeLevel' AND CodeName = 'Senior')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('ClassroomGradeLevel','Senior','Y','N',4)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 4  WHERE Category = 'ClassroomGradeLevel' AND CodeName = 'Senior'
	END
    
   END

    