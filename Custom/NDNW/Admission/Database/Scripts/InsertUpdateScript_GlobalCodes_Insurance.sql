/********************************************************************************************
Author    :  Malathi Shiva  
CreatedDate  :  08 Sept 2014  
Purpose    :  GlobalCodes insert/update for Categories : XRESIDENCETYPE
*********************************************************************************************/

-- Category = 'XRESIDENCETYPE'  
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XRESIDENCETYPE') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XRESIDENCETYPE','XRESIDENCETYPE','Y','Y','Y','Y','Y' 
                   , 
                   'N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XRESIDENCETYPE' 
                     AND CodeName = 'Residence Type1') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XRESIDENCETYPE','Residence Type1','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XRESIDENCETYPE' 
                     AND CodeName = 'Residence Type2') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XRESIDENCETYPE','Residence Type2','Y','N') 
  END 