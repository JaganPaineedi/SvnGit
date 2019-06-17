/********************************************************************************************
Author    :  Malathi Shiva  
CreatedDate  :  27 April 2015
Purpose    :  GlobalCodes insert/update for Categories : Gambling Tab drop downs
*********************************************************************************************/
 DELETE FROM GlobalCodes WHERE Category = 'XGAMBLINGGENERAL' AND GlobalCodeId > 10000

--Category = 'XGAMBLINGGENERAL'    
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XGAMBLINGGENERAL') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XGAMBLINGGENERAL','XGAMBLINGGENERAL','Y','Y','Y','Y','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XGAMBLINGGENERAL' 
                     AND CodeName = 'Never') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XGAMBLINGGENERAL','Never','Y','N',1) 
  END 
  
  IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XGAMBLINGGENERAL' 
                     AND CodeName = 'Rarely') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XGAMBLINGGENERAL','Rarely','Y','N',2) 
  END 
  
  IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XGAMBLINGGENERAL' 
                     AND CodeName = 'Sometimes') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XGAMBLINGGENERAL','Sometimes','Y','N',3) 
  END 
  
  IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XGAMBLINGGENERAL' 
                     AND CodeName = 'Often') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XGAMBLINGGENERAL','Often','Y','N',4) 
  END 

  IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XGAMBLINGGENERAL' 
                     AND CodeName = 'Always') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XGAMBLINGGENERAL','Always','Y','N',5) 
  END 
  
    IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XGAMBLINGGENERAL' 
                     AND CodeName = 'Don’t know/doesn’t apply') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XGAMBLINGGENERAL','Don’t know/doesn’t apply','Y','N',6) 
  END 


 DELETE FROM GlobalCodes WHERE Category = 'XGAMBLING' AND GlobalCodeId > 10000
 
--Category = 'XGAMBLING'    
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XGAMBLING') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XGAMBLING','XGAMBLING','Y','Y','Y','Y','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XGAMBLING' 
                     AND CodeName = 'Yes') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XGAMBLING','Yes','Y','N',1) 
  END 
  
  IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XGAMBLING' 
                     AND CodeName = 'No') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XGAMBLING','No','Y','N',2) 
  END 
  
  
 DELETE FROM GlobalCodes WHERE Category = 'XCommunicableDisease' AND GlobalCodeId > 10000
 
--Category = 'XCommunicableDisease'    
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XCommunicableDisease') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XCommunicableDisease','XCommunicableDisease','Y','Y','Y','Y','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XCommunicableDisease' 
                     AND CodeName = 'IDRA not collected') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XCommunicableDisease','IDRA not collected','Y','N',1) 
  END 
  
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XCommunicableDisease' 
                     AND CodeName = 'Low-to-no risk, no referral') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XCommunicableDisease','Low-to-no risk, no referral','Y','N',2) 
  END 
  
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XCommunicableDisease' 
                     AND CodeName = 'Moderate-to-high risk, no referral') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XCommunicableDisease','Moderate-to-high risk, no referral','Y','N',3) 
  END   
  
 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XCommunicableDisease' 
                     AND CodeName = 'Moderate-to-high risk, referral made') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XCommunicableDisease','Moderate-to-high risk, referral made','Y','N',4) 
  END
  
 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XCommunicableDisease' 
                     AND CodeName = 'Mental health client, IDRA not applicable') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XCommunicableDisease','Mental health client, IDRA not applicable','Y','N',5) 
  END