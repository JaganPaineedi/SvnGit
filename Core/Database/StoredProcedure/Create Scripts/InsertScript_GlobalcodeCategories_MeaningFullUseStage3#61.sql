--- Insert script for GlobalCode category   PRGDISCHARGEREASON 

IF NOT EXISTS (SELECT * 
               FROM   GlobalCodeCategories 
               WHERE  Category ='PRGDISCHARGEREASON') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category 
                   ,CategoryName 
                   ,Active 
                   ,AllowAddDelete 
                   ,AllowCodeNameEdit 
                   ,AllowSortOrderEdit 
                   ,UsedInCareManagement) 
      VALUES      ('PRGDISCHARGEREASON' 
                   ,'PRGDISCHARGEREASON' 
                   ,'Y'
                   ,'Y' 
                   ,'Y' 
                   ,'Y' 
                   ,'Y') 
  END 
  
  
    