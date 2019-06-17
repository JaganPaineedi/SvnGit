/*****************************************************************************************************************
Author			:  Nandita S
CreatedDate		:  24 June 2016 
Purpose			:  Insert script to add GlobalCodes entry for MU Supervisor Dashboard. Task#745 SWMBH 
*****************************************************************************************************************/

IF EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'STAFFLIST'
		)
BEGIN

	/*Insert Into GlobalCodes */
	IF NOT EXISTS (SELECT *  FROM GlobalCodes  WHERE Category = 'STAFFLIST' AND CodeName = 'Meaningful Use Supervisor'   AND ISNULL(RecordDeleted, 'N') = 'N' AND GlobalCodeId=5737)
	BEGIN
	 SET IDENTITY_INSERT dbo.GlobalCodes ON 
	 INSERT INTO GlobalCodes (GlobalCodeId,Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)
	 VALUES (5737,'STAFFLIST','Meaningful Use Supervisor','MUSupervisor','','Y','N',NULL,'',NULL,'',NULL,'','','')
	 SET IDENTITY_INSERT dbo.GlobalCodes OFF 
	END

END
GO