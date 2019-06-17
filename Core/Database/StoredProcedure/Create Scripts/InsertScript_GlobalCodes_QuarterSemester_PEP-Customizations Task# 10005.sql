/********************************************************************************                                                    
--     
-- Copyright: Streamline Healthcare Solutions     
--     
--  Purpose: Insert script for new Academic Terms(Application DropDown) & new GlobalCodes for Application Dropdown  

--  Author:  Animesh 
--  Date:    09 March 2018 

*********************************************************************************/ 
IF NOT EXISTS(SELECT 1 
              FROM   GLOBALCODECATEGORIES 
              WHERE  Category = 'AcademicTermQuartSem') 
  BEGIN 
      INSERT INTO GLOBALCODECATEGORIES 
                  (Category, 
                   Categoryname, 
                   Active, 
                   Allowadddelete, 
                   Allowcodenameedit, 
                   Allowsortorderedit, 
                   Userdefinedcategory, 
                   Hassubcodes) 
      SELECT 'AcademicTermQuartSem', 
             'AcademicTermQuartSem', 
             'Y', 
             'N', 
             'N', 
             'N', 
             'N', 
             'N' 
  END 
ELSE 
  BEGIN 
      UPDATE GLOBALCODECATEGORIES 
      SET    Category = 'AcademicTermQuartSem', 
             Categoryname = 'AcademicTermQuartSem', 
             Active = 'Y', 
             Allowadddelete = 'N', 
             Allowsortorderedit = 'N', 
             Userdefinedcategory = 'N', 
             Hassubcodes = 'N' 
      WHERE  Category = 'AcademicTermQuartSem' 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GLOBALCODES 
              WHERE  Category = 'AcademicTermQuartSem' 
                     AND Code = 'Q1') 
  BEGIN 
      INSERT INTO GLOBALCODES 
                  (Category, 
                   Codename, 
                   Code, 
                   Active, 
                   Cannotmodifynameordelete) 
      SELECT 'AcademicTermQuartSem', 
             'Quarter 1', 
             'Q1', 
             'Y', 
             'N' 
  END 
ELSE 
  BEGIN 
      UPDATE GLOBALCODES 
      SET    Category = 'AcademicTermQuartSem', 
             Codename = 'Quarter 1', 
             Code = 'Q1', 
             Active = 'Y', 
             Cannotmodifynameordelete = 'N' 
      WHERE  Category = 'AcademicTermQuartSem' 
             AND Code = 'Q1' 
  END 

IF NOT EXISTS(SELECT * 
              FROM   GLOBALCODES 
              WHERE  Category = 'AcademicTermQuartSem' 
                     AND Code = 'Q2') 
  BEGIN 
      INSERT INTO GLOBALCODES 
                  (Category, 
                   Codename, 
                   Code, 
                   Active, 
                   Cannotmodifynameordelete) 
      SELECT 'AcademicTermQuartSem', 
             'Quarter 2', 
             'Q2', 
             'Y', 
             'N' 
  END 
ELSE 
  BEGIN 
      UPDATE GLOBALCODES 
      SET    Category = 'AcademicTermQuartSem', 
             Codename = 'Quarter 2', 
             Code = 'Q2', 
             Active = 'Y', 
             Cannotmodifynameordelete = 'N' 
      WHERE  Category = 'AcademicTermQuartSem' 
             AND Code = 'Q2' 
  END 
  IF NOT EXISTS(SELECT * 
              FROM   GLOBALCODES 
              WHERE  Category = 'AcademicTermQuartSem' 
                     AND Code = 'Q3') 
  BEGIN 
      INSERT INTO GLOBALCODES 
                  (Category, 
                   Codename, 
                   Code, 
                   Active, 
                   Cannotmodifynameordelete) 
      SELECT 'AcademicTermQuartSem', 
             'Quarter 3', 
             'Q3', 
             'Y', 
             'N' 
  END 
ELSE 
  BEGIN 
      UPDATE GLOBALCODES 
      SET    Category = 'AcademicTermQuartSem', 
             Codename = 'Quarter 3', 
             Code = 'Q3', 
             Active = 'Y', 
             Cannotmodifynameordelete = 'N' 
      WHERE  Category = 'AcademicTermQuartSem' 
             AND Code = 'Q3' 
  END 
  
  
  IF NOT EXISTS(SELECT * 
              FROM   GLOBALCODES 
              WHERE  Category = 'AcademicTermQuartSem' 
                     AND Code = 'Q4') 
  BEGIN 
      INSERT INTO GLOBALCODES 
                  (Category, 
                   Codename, 
                   Code, 
                   Active, 
                   Cannotmodifynameordelete) 
      SELECT 'AcademicTermQuartSem', 
             'Quarter 4', 
             'Q4', 
             'Y', 
             'N' 
  END 
ELSE 
  BEGIN 
      UPDATE GLOBALCODES 
      SET    Category = 'AcademicTermQuartSem', 
             Codename = 'Quarter 4', 
             Code = 'Q4', 
             Active = 'Y', 
             Cannotmodifynameordelete = 'N' 
      WHERE  Category = 'AcademicTermQuartSem' 
             AND Code = 'Q4' 
  END 
  
  IF NOT EXISTS(SELECT * 
              FROM   GLOBALCODES 
              WHERE  Category = 'AcademicTermQuartSem' 
                     AND Code = 'Fall') 
  BEGIN 
      INSERT INTO GLOBALCODES 
                  (Category, 
                   Codename, 
                   Code, 
                   Active, 
                   Cannotmodifynameordelete) 
      SELECT 'AcademicTermQuartSem', 
             'Fall', 
             'Fall', 
             'Y', 
             'N' 
  END 
ELSE 
  BEGIN 
      UPDATE GLOBALCODES 
      SET    Category = 'AcademicTermQuartSem', 
             Codename = 'Fall', 
             Code = 'Fall', 
             Active = 'Y', 
             Cannotmodifynameordelete = 'N' 
      WHERE  Category = 'AcademicTermQuartSem' 
             AND Code = 'Fall' 
  END 
  
  IF NOT EXISTS(SELECT * 
              FROM   GLOBALCODES 
              WHERE  Category = 'AcademicTermQuartSem' 
                     AND Code = 'Spring') 
  BEGIN 
      INSERT INTO GLOBALCODES 
                  (Category, 
                   Codename, 
                   Code, 
                   Active, 
                   Cannotmodifynameordelete) 
      SELECT 'AcademicTermQuartSem', 
             'Spring', 
             'Spring', 
             'Y', 
             'N' 
  END 
ELSE 
  BEGIN 
      UPDATE GLOBALCODES 
      SET    Category = 'AcademicTermQuartSem', 
             Codename = 'Spring', 
             Code = 'Spring', 
             Active = 'Y', 
             Cannotmodifynameordelete = 'N' 
      WHERE  Category = 'AcademicTermQuartSem' 
             AND Code = 'Spring' 
  END 
  
  IF NOT EXISTS(SELECT * 
              FROM   GLOBALCODES 
              WHERE  Category = 'AcademicTermQuartSem' 
                     AND Code = 'Summer1') 
  BEGIN 
      INSERT INTO GLOBALCODES 
                  (Category, 
                   Codename, 
                   Code, 
                   Active, 
                   Cannotmodifynameordelete) 
      SELECT 'AcademicTermQuartSem', 
             'Summer 1', 
             'Summer1', 
             'Y', 
             'N' 
  END 
ELSE 
  BEGIN 
      UPDATE GLOBALCODES 
      SET    Category = 'AcademicTermQuartSem', 
             Codename = 'Summer 1', 
             Code = 'Summer1', 
             Active = 'Y', 
             Cannotmodifynameordelete = 'N' 
      WHERE  Category = 'AcademicTermQuartSem' 
             AND Code = 'Summer1' 
  END 
  
  IF NOT EXISTS(SELECT * 
              FROM   GLOBALCODES 
              WHERE  Category = 'AcademicTermQuartSem' 
                     AND Code = 'Summer2') 
  BEGIN 
      INSERT INTO GLOBALCODES 
                  (Category, 
                   Codename, 
                   Code, 
                   Active, 
                   Cannotmodifynameordelete) 
      SELECT 'AcademicTermQuartSem', 
             'Summer 2', 
             'Summer2', 
             'Y', 
             'N' 
  END 
ELSE 
  BEGIN 
      UPDATE GLOBALCODES 
      SET    Category = 'AcademicTermQuartSem', 
             Codename = 'Summer 2', 
             Code = 'Summer2', 
             Active = 'Y', 
             Cannotmodifynameordelete = 'N' 
      WHERE  Category = 'AcademicTermQuartSem' 
             AND Code = 'Summer2' 
  END 