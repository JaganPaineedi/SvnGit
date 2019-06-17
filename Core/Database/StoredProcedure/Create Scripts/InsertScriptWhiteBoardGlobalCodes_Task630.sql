
 
----------------------- Global Categories -----------------------
 DECLARE @WBLegalStatusCategoryId INT
 DECLARE @WBCompetencyStatusCatgeoryId INT
 
IF NOT EXISTS (SELECT Category
               FROM   GlobalCodeCategories
               WHERE  Category = 'WBLegalStatus')
    BEGIN
        INSERT  INTO GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement)
        VALUES                           ('WBLegalStatus', 'WBLegalStatus', 'Y', 'Y', 'Y', 'Y', NULL, 'N', 'N', 'Y');
    END
    
    
 
IF NOT EXISTS (SELECT Category
               FROM   GlobalCodeCategories
               WHERE  Category = 'WBCompetencyStatus')
    BEGIN
        INSERT  INTO GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement)
        VALUES                           ('WBCompetencyStatus', 'WBCompetencyStatus', 'Y', 'Y', 'Y', 'Y', NULL, 'N', 'N', 'Y');
    END
    
    
    
  SELECT   @WBLegalStatusCategoryId = GlobalCodeCategoryId FROM GlobalCodeCategories WHERE Category = 'WBLegalStatus'
  SELECT  @WBCompetencyStatusCatgeoryId = GlobalCodeCategoryId FROM GlobalCodeCategories WHERE Category = 'WBCompetencyStatus'
  
    
-------------------GlobalCodes -----------------------------
 
  
IF NOT EXISTS (SELECT GlobalCodeId
               FROM   GlobalCodes
               WHERE  Category = 'WBLegalStatus'
                      AND Code = 'Voluntary')
    BEGIN
        INSERT  INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder)
        VALUES                  ('WBLegalStatus', 'Voluntary', 'Voluntary', NULL, 'Y', 'Y', 1);
      
    END
    
    
IF NOT EXISTS (SELECT GlobalCodeId
               FROM   GlobalCodes
               WHERE  Category = 'WBLegalStatus'
                      AND Code = 'Involuntary')
    BEGIN
        INSERT  INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder)
        VALUES                  ('WBLegalStatus', 'Involuntary', 'Involuntary', NULL, 'Y', 'Y', 1);
      
    END
    
    
IF NOT EXISTS (SELECT GlobalCodeId
               FROM   GlobalCodes
               WHERE  Category = 'WBCompetencyStatus'
                      AND CodeName = 'Competent')
    BEGIN
        INSERT  INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder)
        VALUES  ('WBCompetencyStatus', 'Competent', 'C', NULL, 'Y', 'Y', 1);
      
    END
    
    
IF NOT EXISTS (SELECT GlobalCodeId
               FROM   GlobalCodes
               WHERE  Category = 'WBCompetencyStatus'
                      AND CodeName = 'Incompetent')
    BEGIN
        INSERT  INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder)
        VALUES  ('WBCompetencyStatus', 'Incompetent', 'I', NULL, 'Y', 'Y', 1);
      
    END
    
IF NOT EXISTS (SELECT GlobalCodeId
               FROM   GlobalCodes
               WHERE  Category = 'WBCompetencyStatus'
                      AND CodeName = 'New Admission')
    BEGIN
        INSERT  INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder)
        VALUES  ('WBCompetencyStatus', 'New Admission', 'NA', NULL, 'Y', 'Y', 1);
      
    END
    

------------------GlobalCodes -------------------------------    




