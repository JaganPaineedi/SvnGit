/*********************************************************************/                                                                                                                                                                                                                     
 /* Creation Date:   20 july 2017                                  */                                                                                  
 /*                                                                 */                                                                                  
 /* Purpose: Insert script for Recodes Category StatusAllowForBatchSigning  */                                                                                 
           
 /*********************************************************************/  
IF NOT EXISTS (SELECT * 
               FROM   RecodeCategories 
               WHERE  CategoryName = 'StatusAllowForBatchSigning') 
  BEGIN 
      INSERT INTO RecodeCategories 
                  (CategoryCode, 
                   CategoryName, 
                   Description, 
                   MappingEntity) 
      VALUES      ( 'STATUSALLOWFORBATCHSIGNING', 
                    'STATUSALLOWFORBATCHSIGNING', 
      'This Category is used to bind the BatchSignature Statuses Dropdown', 
      'GlobalCodes') 
  END 
  
  
DECLARE @RecodeCategoryId INT 
DECLARE @ToSignIntegerCodeId int
DECLARE @ToCoSignIntegerCodeId int
SELECT @RecodeCategoryId = RecodeCategoryId 
FROM   RecodeCategories 
WHERE  CategoryCode = 'STATUSALLOWFORBATCHSIGNING' 

SELECT @ToSignIntegerCodeId= GlobalCodeId from GlobalCodes where Category= 'BatchSignatureStatus' and Code='TOSIGN'
SELECT @ToCoSignIntegerCodeId= GlobalCodeId from GlobalCodes where Category= 'BatchSignatureStatus' and Code='TOCOSIGN'

DELETE FROM Recodes 
WHERE  RecodeCategoryId = @RecodeCategoryId 

IF NOT EXISTS (SELECT * 
               FROM   Recodes 
               WHERE  RecodeCategoryId = @RecodeCategoryId 
                      AND CodeName = 'TOSIGN') 
        BEGIN              
INSERT INTO  Recodes 
            (RecodeCategoryId, 
             IntegerCodeId, 
             CodeName) Values
             
           ( @RecodeCategoryId,
             @ToSignIntegerCodeId,
             'TOSIGN'
           )
        END
  IF NOT EXISTS (SELECT * 
               FROM   Recodes 
               WHERE  RecodeCategoryId = @RecodeCategoryId 
                      AND CodeName = 'TOCOSIGN')   
          BEGIN                   
 INSERT INTO  Recodes 
            (RecodeCategoryId, 
             IntegerCodeId, 
             CodeName) Values
             
           ( @RecodeCategoryId,
             @ToCoSignIntegerCodeId,
             'TOCOSIGN'
           )     
           END     
      