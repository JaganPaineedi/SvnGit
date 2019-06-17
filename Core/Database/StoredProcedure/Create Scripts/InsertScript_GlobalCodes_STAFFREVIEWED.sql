-- Global codes script for category MEDRECONCILIATION and related Global codes 

IF NOT EXISTS(SELECT *,Category from GlobalCodeCategories WHERE Category='MEDRECONCILIATION' and ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],
									UserDefinedCategory,HasSubcodes,UsedInPracticeManagement,UsedInCareManagement)
	VALUES('MEDRECONCILIATION','MEDRECONCILIATION','Y','Y','Y','Y',NULL,'N','N','Y','Y') 
END
GO 
		
-- code name 'Satff Reviewed'		
IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=8991) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
				   CreatedBy,
				   CreatedDate,
				   ModifiedBy,
				   ModifiedDate,
                   Category, 
                   CodeName, 
                   Code,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (8991,
				  'Streamline-dbo',
				  GETDATE(),
				  'Streamline-dbo',
				  GETDATE(),
				 'MEDRECONCILIATION', 
                  'Staff Reviewed', 
                  'STAFFREVIEWED',
                  'Y', 
                  'N',
                  1) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
  ELSE 
  BEGIN 
      UPDATE GlobalCodes 
      SET    Category = 'MEDRECONCILIATION', 
             CodeName = 'Staff Reviewed', 
             Code = 'STAFFREVIEWED',
             Active = 'Y', 
             CannotModifyNameOrDelete = 'N',            
             SortOrder=1,
             ModifiedBy ='Streamline-dbo',
			 ModifiedDate =  GETDATE()
      WHERE  GlobalcodeId = 8991           
  END 
  

 		


  
