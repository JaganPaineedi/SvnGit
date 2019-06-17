--- Insert script for GlobalCode category   PREFERREDPRONOUN   

IF NOT EXISTS (SELECT * 
               FROM   GlobalCodeCategories 
               WHERE  Category ='PREFERREDPRONOUN') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category 
                   ,CategoryName 
                   ,Active 
                   ,AllowAddDelete 
                   ,AllowCodeNameEdit 
                   ,AllowSortOrderEdit 
                   ,UsedInCareManagement) 
      VALUES      ('PREFERREDPRONOUN' 
                   ,'PREFERREDPRONOUN' 
                   ,'Y'
                   ,'Y' 
                   ,'Y' 
                   ,'Y' 
                   ,'Y') 
  END 
  
  IF EXISTS (SELECT * FROM GlobalCodeCategories WHERE Category = 'PREFERREDPRONOUN'  and isnull(RecordDeleted,'N')='N')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'PREFERREDPRONOUN' AND CodeName = 'He')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('PREFERREDPRONOUN','He','Y','N',1)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 1  WHERE Category = 'PREFERREDPRONOUN' AND CodeName = 'He'
	END
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'PREFERREDPRONOUN' AND CodeName = 'She')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('PREFERREDPRONOUN','She','Y','N',2)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 2  WHERE Category = 'PREFERREDPRONOUN' AND CodeName = 'She'
	END
	
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'PREFERREDPRONOUN' AND CodeName = 'They')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('PREFERREDPRONOUN','They','Y','N',3)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 3   WHERE Category = 'PREFERREDPRONOUN' AND CodeName = 'They'
	END
    
   END

    