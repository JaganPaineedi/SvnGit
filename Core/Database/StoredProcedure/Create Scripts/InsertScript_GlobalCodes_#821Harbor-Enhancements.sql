--- Insert script for GlobalCode category  BatchSignatureStatus  
DECLARE @Active CHAR(1) 
DECLARE @CannotModifyNameOrDelete CHAR(1) 
DECLARE @Category VARCHAR(MAX) 

SET @Active='Y' 
SET @CannotModifyNameOrDelete='N' 
SET @Category='BatchSignatureStatus' 

IF NOT EXISTS (SELECT * 
               FROM   GlobalCodeCategories 
               WHERE  Category = @Category) 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category 
                   ,CategoryName 
                   ,Active 
                   ,AllowAddDelete 
                   ,AllowCodeNameEdit 
                   ,AllowSortOrderEdit 
                   ,UsedInCareManagement) 
      VALUES      (@Category 
                   ,'Batch Signature Status' 
                   ,@Active 
                   ,'Y' 
                   ,'Y' 
                   ,'Y' 
                   ,'Y') 
  END 

IF NOT EXISTS (SELECT * 
               FROM   GlobalCodes 
               WHERE  Category = @Category 
                      AND Code = 'TOCOSIGN') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category 
                   ,CodeName 
                   ,Code 
                   ,Active 
                   ,CannotModifyNameOrDelete 
                   ,SortOrder) 
      VALUES      (@Category 
                   ,'To Cosign' 
                   ,'TOCOSIGN' 
                   ,@Active 
                   ,@CannotModifyNameOrDelete 
                   ,2) 
  END 

IF NOT EXISTS (SELECT * 
               FROM   GlobalCodes 
               WHERE  Category = @Category 
                      AND Code = 'TOSIGN') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category 
                   ,CodeName 
                   ,Code 
                   ,Active 
                   ,CannotModifyNameOrDelete 
                   ,SortOrder) 
      VALUES      (@Category 
                   ,'To Sign' 
                   ,'TOSIGN' 
                   ,@Active 
                   ,@CannotModifyNameOrDelete 
                   ,1) 
  END 

IF NOT EXISTS (SELECT * 
               FROM   GlobalCodes 
               WHERE  Category = @Category 
                      AND Code = 'INPROGRESS') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category 
                   ,CodeName 
                   ,Code 
                   ,Active 
                   ,CannotModifyNameOrDelete 
                   ,SortOrder) 
      VALUES      (@Category 
                   ,'In Progress' 
                   ,'INPROGRESS' 
                   ,@Active 
                   ,@CannotModifyNameOrDelete 
                   ,3) 
  END 

IF NOT EXISTS (SELECT * 
               FROM   GlobalCodes 
               WHERE  Category = @Category 
                      AND Code = 'TOBEREVIEWED') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category 
                   ,CodeName 
                   ,Code 
                   ,Active 
                   ,CannotModifyNameOrDelete 
                   ,SortOrder) 
      VALUES      (@Category 
                   ,'To Be Reviewed' 
                   ,'TOBEREVIEWED' 
                   ,@Active 
                   ,@CannotModifyNameOrDelete 
                   ,4) 
  END 

IF NOT EXISTS (SELECT * 
               FROM   GlobalCodes 
               WHERE  Category = @Category 
                      AND Code = 'TOACKNOWLEDGE') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category 
                   ,CodeName 
                   ,Code 
                   ,Active 
                   ,CannotModifyNameOrDelete 
                   ,SortOrder) 
      VALUES      (@Category 
                   ,'To Acknowledge' 
                   ,'TOACKNOWLEDGE' 
                   ,@Active 
                   ,@CannotModifyNameOrDelete 
                   ,5) 
  END 