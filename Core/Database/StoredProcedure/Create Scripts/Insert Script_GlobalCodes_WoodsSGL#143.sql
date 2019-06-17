 
 IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'CLIENTCONTACTNOTE' AND Category = 'CLIENTCONTACTNOTE')
BEGIN 
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description])
	VALUES ('CLIENTCONTACTNOTE','CLIENTCONTACTNOTE','Y','Y','Y','Y','CLIENTCONTACTNOTE') 
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'CLIENTCONTACTNOTE' ,CategoryName = 'CLIENTCONTACTNOTE',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Woods - Support Go Live:#143',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'CLIENTCONTACTNOTE' AND Category = 'CLIENTCONTACTNOTE'
END
 
 
 
 IF NOT EXISTS(SELECT * FROM   GlobalCodes WHERE  GlobalcodeId=9409 and isnull(RecordDeleted,'N')='N' ) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   Code,
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete ) 
          VALUES  (9409,
				  'CLIENTCONTACTNOTE', 
                  'Reason',
                  'Reason',
                   NULL,
                  'Y', 
                  'N' ) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
 ---------------------------------------------------------------------------
 
 IF NOT EXISTS(SELECT * FROM   GlobalCodes WHERE  GlobalcodeId=5925 and isnull(RecordDeleted,'N')='N' ) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName,
                   Code, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete ) 
          VALUES  (5925,
				  'PERMISSIONTEMPLATETP', 
                  'Client Contact Note',
                  'Client Contact Note',
                   NULL,
                  'Y', 
                  'N' ) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END 
  
  