IF NOT EXISTS (SELECT 1 FROM GlobalCodeCategories WHERE Category='GENDERIDENTITY')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit)
	VALUES ('GENDERIDENTITY','GENDERIDENTITY','Y','Y','Y','Y')
END



/*******************************GlobalCodes***************************************/
SET IDENTITY_INSERT GlobalCodes  ON
IF NOT EXISTS (SELECT 1 FROM GlobalCodes WHERE Category ='GENDERIDENTITY' AND CodeName='Transgender')

INSERT INTO GlobalCodes (GlobalCodeId,Category,CodeName,Code,Description,Active,SortOrder,ExternalCode1)
VALUES (9382,'GENDERIDENTITY','Transgender','TRANSGENDER','','Y',1,'TRANSGENDER')

SET IDENTITY_INSERT GlobalCodes OFF
/*******************************GlobalCodes***************************************/