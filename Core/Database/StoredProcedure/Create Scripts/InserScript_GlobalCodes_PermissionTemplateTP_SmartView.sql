IF NOT EXISTS (SELECT 1 FROM GlobalCodes WHERE Category='PERMISSIONTEMPLATETP' AND CodeName='SmartView' AND GlobalCodeId=5929)
BEGIN
SET IDENTITY_INSERT GlobalCodes ON
	INSERT INTO GlobalCodes 
		(GlobalCodeId,
		 Category,
		 CodeName,
		 Active,
		 CannotModifyNameOrDelete)
	VALUES (5929,
			'PERMISSIONTEMPLATETP',
			'SmartView',
			'Y',
			'N')
	 SET IDENTITY_INSERT GlobalCodes OFF 
END