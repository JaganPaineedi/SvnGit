--- Insert script for GlobalCode category   HL7MESSAGEPRSTATUS   
-- Childrens Services Center-Customizations # 13

IF NOT EXISTS (SELECT * 
               FROM   GlobalCodeCategories 
               WHERE  Category ='HL7MESSAGEPRSTATUS') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category 
                   ,CategoryName 
                   ,Active 
                   ,AllowAddDelete 
                   ,AllowCodeNameEdit 
                   ,AllowSortOrderEdit 
                   ,UsedInCareManagement) 
      VALUES      ('HL7MESSAGEPRSTATUS' 
                   ,'HL7MESSAGEPRSTATUS' 
                   ,'Y'
                   ,'Y' 
                   ,'Y' 
                   ,'Y' 
                   ,'N') 
  END 
  

	IF NOT EXISTS(SELECT * FROM GlobalCodes WHERE GlobalCodeID=9501)
	BEGIN
		 SET IDENTITY_INSERT GlobalCodes ON
		INSERT INTO GlobalCodes (GlobalcodeId,Category,CodeName,CODE,Active,CannotModifyNameOrDelete)
		VALUES (9501,'HL7MESSAGEPRSTATUS','Unmatched','UNMATCHED','Y','N')
		 SET IDENTITY_INSERT GlobalCodes OFF   
	END