IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'NOOFCLIENTSTATEMENT' AND Category = 'NOOFCLIENTSTATEMENT')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('NOOFCLIENTSTATEMENT','NOOFCLIENTSTATEMENT','Y','Y','Y','Y','N','N','Y')
	
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'NOOFCLIENTSTATEMENT' AND CodeName = '1')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('NOOFCLIENTSTATEMENT','1','Y','N',1)
	END
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'NOOFCLIENTSTATEMENT' AND CodeName = '2')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('NOOFCLIENTSTATEMENT','2','Y','N',2)
	END
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'NOOFCLIENTSTATEMENT' AND CodeName = '3')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('NOOFCLIENTSTATEMENT','3','Y','N',3)
	END
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'NOOFCLIENTSTATEMENT' AND CodeName = '4')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('NOOFCLIENTSTATEMENT','4','Y','N',4)
	END
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'NOOFCLIENTSTATEMENT' AND CodeName = '5')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('NOOFCLIENTSTATEMENT','5','Y','N',5)
	END
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'NOOFCLIENTSTATEMENT' AND CodeName = '6')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('NOOFCLIENTSTATEMENT','6','Y','N',6)
	END
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'NOOFCLIENTSTATEMENT' AND CodeName = '7')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('NOOFCLIENTSTATEMENT','7','Y','N',7)
	END
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'NOOFCLIENTSTATEMENT' AND CodeName = '8')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('NOOFCLIENTSTATEMENT','8','Y','N',8)
	END
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'NOOFCLIENTSTATEMENT' AND CodeName = '9')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('NOOFCLIENTSTATEMENT','9','Y','N',9)
	END
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'NOOFCLIENTSTATEMENT' AND CodeName = '10')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('NOOFCLIENTSTATEMENT','10','Y','N',10)
	END
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'NOOFCLIENTSTATEMENT' AND CodeName = '11')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('NOOFCLIENTSTATEMENT','11','Y','N',11)
	END
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'NOOFCLIENTSTATEMENT' AND CodeName = '12')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('NOOFCLIENTSTATEMENT','12','Y','N',12)
	END
END