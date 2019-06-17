/********************************************************************************                                                    
--     
-- Copyright: Streamline Healthcare Solutions     
--     
--  Purpose: Insert script for new Course Types Auto complete and Course Group (Application DropDown) & new GlobalCodes for Course Group Dropdown  

--  Author:  Abhishek 
--  Date:    10 April 2018 

*********************************************************************************/
IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODECATEGORIES
  WHERE Category = 'EDUCATSCHOOLDISTRICT')
BEGIN
  INSERT INTO GLOBALCODECATEGORIES (Category,
  Categoryname,
  Active,
  Allowadddelete,
  Allowcodenameedit,
  Allowsortorderedit)
    SELECT
      'EDUCATSCHOOLDISTRICT',
      'Educating School District',
      'Y',
      'Y',
      'Y',
      'Y'
END

IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODES
  WHERE Category = 'EDUCATSCHOOLDISTRICT'
  AND CodeName = 'Educating1')
BEGIN
  INSERT INTO GLOBALCODES (Category,
  Codename,
  Active,
  Cannotmodifynameordelete)
    SELECT
      'EDUCATSCHOOLDISTRICT',
      'Educating1',
      'Y',
      'Y'
END
--------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODES
  WHERE Category = 'EDUCATSCHOOLDISTRICT'
  AND CodeName = 'Educating2')
BEGIN
  INSERT INTO GLOBALCODES (Category,
  Codename,
  Active,
  Cannotmodifynameordelete)
    SELECT
      'EDUCATSCHOOLDISTRICT',
      'Educating2',
      'Y',
      'Y'
END
--------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODECATEGORIES
  WHERE Category = 'RESIDESCHOOLDISTRICT')
BEGIN
  INSERT INTO GLOBALCODECATEGORIES (Category,
  Categoryname,
  Active,
  Allowadddelete,
  Allowcodenameedit,
  Allowsortorderedit)
    SELECT
      'RESIDESCHOOLDISTRICT',
      'Residential School District',
      'Y',
      'Y',
      'Y',
      'Y'
END

IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODES
  WHERE Category = 'RESIDESCHOOLDISTRICT'
  AND CodeName = 'Residential1')
BEGIN
  INSERT INTO GLOBALCODES (Category,
  Codename,
  Active,
  Cannotmodifynameordelete)
    SELECT
      'RESIDESCHOOLDISTRICT',
      'Residential1',
      'Y',
      'Y'
END
--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODES
  WHERE Category = 'RESIDESCHOOLDISTRICT'
  AND CodeName = 'Residential2')
BEGIN
  INSERT INTO GLOBALCODES (Category,
  Codename,
  Active,
  Cannotmodifynameordelete)
    SELECT
      'RESIDESCHOOLDISTRICT',
      'Residential2',
      'Y',
      'Y'
END
--------------------------------------------------------------------------------------------------------------