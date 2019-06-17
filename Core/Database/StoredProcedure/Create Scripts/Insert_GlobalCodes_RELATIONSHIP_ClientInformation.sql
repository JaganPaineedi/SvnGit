/********************************************************************************************
Author			:  Alok Kumar
CreatedDate		:  03/04/2016 
Purpose			:  Insert script to add GlobalCodes entry for Client Information. Task#52 Network 180 - Customizations 
*********************************************************************************************/


IF EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'RELATIONSHIP'
		)
BEGIN

	/*Insert Into GlobalCodes */
	IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE Category = 'RELATIONSHIP' AND CodeName = 'Foster Parent/Guardian'   AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
	 INSERT INTO GlobalCodes (Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	   VALUES ('RELATIONSHIP','Foster Parent/Guardian','Foster Parent/Guardian','','Y','N',NULL,'',NULL,'',NULL,'','','')
	END
	
	/*Insert Into GlobalCodes */
	IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE Category = 'RELATIONSHIP' AND CodeName = 'Foster Care Worker'   AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
	 INSERT INTO GlobalCodes (Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	   VALUES ('RELATIONSHIP','Foster Care Worker','Foster Care Worker','','Y','N',NULL,'',NULL,'',NULL,'','','')
	END
		
	/*Insert Into GlobalCodes */
	IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE Category = 'RELATIONSHIP' AND CodeName = 'Plenary/Guardian'   AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
	 INSERT INTO GlobalCodes (Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	   VALUES ('RELATIONSHIP','Plenary/Guardian','Plenary/Guardian','','Y','N',NULL,'',NULL,'',NULL,'','','')
	END

	/*Insert Into GlobalCodes */
	IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE Category = 'RELATIONSHIP' AND CodeName = 'Adult Client has Payee'   AND ISNULL(RecordDeleted, 'N') = 'N')
	BEGIN
	 INSERT INTO GlobalCodes (Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	   VALUES ('RELATIONSHIP','Adult Client has Payee','Adult Client has Payee','','Y','N',NULL,'',NULL,'',NULL,'','','')
	END

END
GO
