/********************************************************************************************
Author    :  Vinod kumar A
ModifiedDate  : 30 Oct 2017 
Purpose    :  Insert/Update script to modify existing GlobalCodes.CodeName as per the clients requirement
*********************************************************************************************/
IF EXISTS (SELECT * FROM GlobalCodeCategories WHERE  Category = 'ALLERGYSEVERITY'  and isnull(RecordDeleted,'N')='N')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'ALLERGYSEVERITY' AND CodeName = 'Mild')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('ALLERGYSEVERITY','Mild','Y','N',1)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 1 WHERE Category = 'ALLERGYSEVERITY' AND CodeName = 'Mild'
	END
    IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'ALLERGYSEVERITY' AND CodeName = 'Mild to Moderate')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('ALLERGYSEVERITY','Mild to Moderate','Y','N',2)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 2 WHERE Category = 'ALLERGYSEVERITY' AND CodeName = 'Mild to Moderate'
	END	
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'ALLERGYSEVERITY' AND CodeName = 'Moderate')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('ALLERGYSEVERITY','Moderate','Y','N',3)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 3 WHERE Category = 'ALLERGYSEVERITY' AND CodeName = 'Moderate'
	END	
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'ALLERGYSEVERITY' AND CodeName = 'Moderate to severe')
	BEGIN	
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('ALLERGYSEVERITY','Moderate to severe','Y','N',4)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 4  WHERE Category = 'ALLERGYSEVERITY' AND CodeName = 'Moderate to severe'
	END	

	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'ALLERGYSEVERITY' AND CodeName = 'Severe')
	BEGIN	
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('ALLERGYSEVERITY','Severe','Y','N',5)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 5 WHERE Category = 'ALLERGYSEVERITY' AND CodeName = 'Severe'
	END	

END
