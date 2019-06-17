/*****************************************************************************************************************
Author			:  Nandita S
CreatedDate		:  14 June 2016 
Purpose			:  Insert script to add GlobalCodes entry for Portal Message Staff permission. Task#546 KCMHSAS 
*****************************************************************************************************************/

IF EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'STAFFLIST'
		)
BEGIN

	/*Insert Into GlobalCodes */
	IF NOT EXISTS (SELECT *  FROM GlobalCodes  WHERE Category = 'STAFFLIST' AND CodeName = 'Portal Message Staff'   AND ISNULL(RecordDeleted, 'N') = 'N' AND GlobalCodeId=5736)
	BEGIN
	 SET IDENTITY_INSERT dbo.GlobalCodes ON 
	 INSERT INTO GlobalCodes (GlobalCodeId,Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	 VALUES (5736,'STAFFLIST','Portal Message Staff','Portal Message Staff','','Y','N',NULL,'',NULL,'',NULL,'','','')
	 SET IDENTITY_INSERT dbo.GlobalCodes OFF 
	END

END
GO