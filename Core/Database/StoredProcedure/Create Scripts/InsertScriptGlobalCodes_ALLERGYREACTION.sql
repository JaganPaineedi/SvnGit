/********************************************************************************************
Author    :  Vinod kumar A
ModifiedDate  : 30 Oct 2017 
Purpose    :  Insert/Update script to modify existing GlobalCodes.CodeName as per the clients requirement
*********************************************************************************************/
IF EXISTS (SELECT * FROM GlobalCodeCategories WHERE Category = 'ALLERGYREACTION'  and isnull(RecordDeleted,'N')='N')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Abdominal cramps')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('ALLERGYREACTION','Abdominal cramps','Y','N',1)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 1  WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Abdominal cramps'
	END
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Diarrhea')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('ALLERGYREACTION','Diarrhea','Y','N',2)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 2  WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Diarrhea'
	END
	
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Dizziness')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('ALLERGYREACTION','Dizziness','Y','N',3)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 3   WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Dizziness'
	END
    
    IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Fainting')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('ALLERGYREACTION','Fainting','Y','N',4)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 4  WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Fainting'
	END
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Hives')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('ALLERGYREACTION','Hives','Y','N',5)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 5   WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Hives'
	END
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Itchy skin')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('ALLERGYREACTION','Itchy skin','Y','N',6)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 6  WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Itchy skin'
	END
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Low blood pressure')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('ALLERGYREACTION','Low blood pressure','Y','N',7)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 7   WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Low blood pressure'
	END
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Nausea')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('ALLERGYREACTION','Nausea','Y','N',8)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 8  WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Nausea'
	END
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Rash')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('ALLERGYREACTION','Rash','Y','N',9)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 9   WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Rash'
	END
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Seizure')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('ALLERGYREACTION','Seizure','Y','N',10)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 10   WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Seizure'
	END
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Swollen face, lips, or tongue')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('ALLERGYREACTION','Swollen face, lips, or tongue','Y','N',11)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 11  WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Swollen face, lips, or tongue'
	END
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Vomiting')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('ALLERGYREACTION','Vomiting','Y','N',12)
	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 12  WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Vomiting'
	END
	IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Wheezing')
	BEGIN
		INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
		VALUES ('ALLERGYREACTION','Wheezing','Y','N',13)

	END
	ELSE
	BEGIN
		UPDATE GlobalCodes SET SortOrder = 13  WHERE Category = 'ALLERGYREACTION' AND CodeName = 'Wheezing'
	END
END

