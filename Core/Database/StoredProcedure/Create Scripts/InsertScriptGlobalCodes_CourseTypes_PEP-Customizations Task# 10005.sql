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
  WHERE Category = 'CLASSROOMCOURSETYPE')
BEGIN
  INSERT INTO GLOBALCODECATEGORIES (Category,
  Categoryname,
  Active,
  Allowadddelete,
  Allowcodenameedit,
  Allowsortorderedit)
    SELECT
      'CLASSROOMCOURSETYPE',
      'Class Room Course Type',
      'Y',
      'Y',
      'Y',
      'Y'
END

IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODES
  WHERE Category = 'CLASSROOMCOURSETYPE'
  AND CodeName = 'Honours')
BEGIN
  INSERT INTO GLOBALCODES (Category,
  Codename,
  Active,
  Cannotmodifynameordelete)
    SELECT
      'CLASSROOMCOURSETYPE',
      'Honours',
      'Y',
      'Y'
END

IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODES
  WHERE Category = 'CLASSROOMCOURSETYPE'
  AND CodeName = 'Graduate')
BEGIN
  INSERT INTO GLOBALCODES (Category,
  Codename,
  Active,
  Cannotmodifynameordelete)
    SELECT
      'CLASSROOMCOURSETYPE',
      'Graduate',
      'Y',
      'Y'
END

DECLARE @GlobalCodeId int
SELECT
  @GlobalCodeId = GlobalCodeId
FROM dbo.GlobalCodes
WHERE Category = 'CLASSROOMCOURSETYPE'
AND CodeName = 'Graduate'

IF NOT EXISTS (SELECT
    *
  FROM GlobalSubCodes
  WHERE SubCodeName = 'Diploma of Education'
  AND GlobalCodeId = @GlobalCodeId)
BEGIN

  INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Active, CannotModifyNameOrDelete)
    VALUES (@GlobalCodeId, 'Diploma of Education', 'Y', 'Y')

END

--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT
    *
  FROM GlobalSubCodes
  WHERE SubCodeName = 'Master of Teaching'
  AND GlobalCodeId = @GlobalCodeId)
BEGIN

  INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Active, CannotModifyNameOrDelete)
    VALUES (@GlobalCodeId, 'Master of Teaching', 'Y', 'Y')

END

--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT
    *
  FROM GlobalSubCodes
  WHERE SubCodeName = 'Graduate Diploma'
  AND GlobalCodeId = @GlobalCodeId)
BEGIN

  INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Active, CannotModifyNameOrDelete)
    VALUES (@GlobalCodeId, 'Graduate Diploma', 'Y', 'Y')

END

--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT
    *
  FROM GlobalSubCodes
  WHERE SubCodeName = 'Bachelor Diploma'
  AND GlobalCodeId = @GlobalCodeId)
BEGIN

  INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Active, CannotModifyNameOrDelete)
    VALUES (@GlobalCodeId, 'Bachelor Diploma', 'Y', 'Y')

END

--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT
    *
  FROM GlobalSubCodes
  WHERE SubCodeName = 'Honours'
  AND GlobalCodeId = @GlobalCodeId)
BEGIN

  INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Active, CannotModifyNameOrDelete)
    VALUES (@GlobalCodeId, 'Honours', 'Y', 'Y')

END

--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT
    *
  FROM GlobalSubCodes
  WHERE SubCodeName = 'Master degree'
  AND GlobalCodeId = @GlobalCodeId)
BEGIN

  INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Active, CannotModifyNameOrDelete)
    VALUES (@GlobalCodeId, 'Master degree', 'Y', 'Y')

END

--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT
    *
  FROM GlobalSubCodes
  WHERE SubCodeName = 'Doctorate'
  AND GlobalCodeId = @GlobalCodeId)
BEGIN

  INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Active, CannotModifyNameOrDelete)
    VALUES (@GlobalCodeId, 'Doctorate', 'Y', 'Y')

END

--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODES
  WHERE Category = 'CLASSROOMCOURSETYPE'
  AND CodeName = 'Undergraduate')
BEGIN
  INSERT INTO GLOBALCODES (Category,
  Codename,
  Active,
  Cannotmodifynameordelete)
    SELECT
      'CLASSROOMCOURSETYPE',
      'Undergraduate',
      'Y',
      'Y'
END

SELECT
  @GlobalCodeId = GlobalCodeId
FROM dbo.GlobalCodes
WHERE Category = 'CLASSROOMCOURSETYPE'
AND CodeName = 'Undergraduate'

IF NOT EXISTS (SELECT
    *
  FROM GlobalSubCodes
  WHERE SubCodeName = 'Bachelor'
  AND GlobalCodeId = @GlobalCodeId)
BEGIN

  INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Active, CannotModifyNameOrDelete)
    VALUES (@GlobalCodeId, 'Bachelor', 'Y', 'Y')

END

--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT
    *
  FROM GlobalSubCodes
  WHERE SubCodeName = 'Associate'
  AND GlobalCodeId = @GlobalCodeId)
BEGIN

  INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Active, CannotModifyNameOrDelete)
    VALUES (@GlobalCodeId, 'Associate', 'Y', 'Y')

END

--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODES
  WHERE Category = 'CLASSROOMCOURSETYPE'
  AND CodeName = 'Vocational')
BEGIN
  INSERT INTO GLOBALCODES (Category,
  Codename,
  Active,
  Cannotmodifynameordelete)
    SELECT
      'CLASSROOMCOURSETYPE',
      'Vocational',
      'Y',
      'Y'
END

SELECT
  @GlobalCodeId = GlobalCodeId
FROM dbo.GlobalCodes
WHERE Category = 'CLASSROOMCOURSETYPE'
AND CodeName = 'Vocational'

IF NOT EXISTS (SELECT
    *
  FROM GlobalSubCodes
  WHERE SubCodeName = 'Certificate II'
  AND GlobalCodeId = @GlobalCodeId)
BEGIN

  INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Active, CannotModifyNameOrDelete)
    VALUES (@GlobalCodeId, 'Certificate II', 'Y', 'Y')

END

--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT
    *
  FROM GlobalSubCodes
  WHERE SubCodeName = 'Certificate III'
  AND GlobalCodeId = @GlobalCodeId)
BEGIN

  INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Active, CannotModifyNameOrDelete)
    VALUES (@GlobalCodeId, 'Certificate III', 'Y', 'Y')

END

--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT
    *
  FROM GlobalSubCodes
  WHERE SubCodeName = 'Certificate IV'
  AND GlobalCodeId = @GlobalCodeId)
BEGIN

  INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Active, CannotModifyNameOrDelete)
    VALUES (@GlobalCodeId, 'Certificate IV', 'Y', 'Y')

END

--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT
    *
  FROM GlobalSubCodes
  WHERE SubCodeName = 'Diploma'
  AND GlobalCodeId = @GlobalCodeId)
BEGIN

  INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Active, CannotModifyNameOrDelete)
    VALUES (@GlobalCodeId, 'Diploma', 'Y', 'Y')

END

--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT
    *
  FROM GlobalSubCodes
  WHERE SubCodeName = 'Advanced Diploma'
  AND GlobalCodeId = @GlobalCodeId)
BEGIN

  INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Active, CannotModifyNameOrDelete)
    VALUES (@GlobalCodeId, 'Advanced Diploma', 'Y', 'Y')

END

--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODECATEGORIES
  WHERE Category = 'CLASSROOMTESTMODE')
BEGIN
  INSERT INTO GLOBALCODECATEGORIES (Category,
  Categoryname,
  Active,
  Allowadddelete,
  Allowcodenameedit,
  Allowsortorderedit)
    SELECT
      'CLASSROOMTESTMODE',
      'Class Room Test Mode',
      'Y',
      'Y',
      'Y',
      'Y'
END

IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODES
  WHERE Category = 'CLASSROOMTESTMODE'
  AND CodeName = 'Test 1')
BEGIN
  INSERT INTO GLOBALCODES (Category,
  Codename,
  Active,
  Cannotmodifynameordelete)
    SELECT
      'CLASSROOMTESTMODE',
      'Test 1',
      'Y',
      'Y'
END

--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODES
  WHERE Category = 'CLASSROOMTESTMODE'
  AND CodeName = 'Test 2')
BEGIN
  INSERT INTO GLOBALCODES (Category,
  Codename,
  Active,
  Cannotmodifynameordelete)
    SELECT
      'CLASSROOMTESTMODE',
      'Test 2',
      'Y',
      'Y'
END

--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODECATEGORIES
  WHERE Category = 'CLASSROOMCOURSELEVEL')
BEGIN
  INSERT INTO GLOBALCODECATEGORIES (Category,
  Categoryname,
  Active,
  Allowadddelete,
  Allowcodenameedit,
  Allowsortorderedit)
    SELECT
      'CLASSROOMCOURSELEVEL',
      'Class Room Course Level',
      'Y',
      'Y',
      'Y',
      'Y'
END

IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODES
  WHERE Category = 'CLASSROOMCOURSELEVEL'
  AND CodeName = 'Course 1')
BEGIN
  INSERT INTO GLOBALCODES (Category,
  Codename,
  Active,
  Cannotmodifynameordelete)
    SELECT
      'CLASSROOMCOURSELEVEL',
      'Course 1',
      'Y',
      'Y'
END

--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODES
  WHERE Category = 'CLASSROOMCOURSELEVEL'
  AND CodeName = 'Course 2')
BEGIN
  INSERT INTO GLOBALCODES (Category,
  Codename,
  Active,
  Cannotmodifynameordelete)
    SELECT
      'CLASSROOMCOURSELEVEL',
      'Course 2',
      'Y',
      'Y'
END

--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODECATEGORIES
  WHERE Category = 'CLASSROOMHSCREDIT')
BEGIN
  INSERT INTO GLOBALCODECATEGORIES (Category,
  Categoryname,
  Active,
  Allowadddelete,
  Allowcodenameedit,
  Allowsortorderedit)
    SELECT
      'CLASSROOMHSCREDIT',
      'Class Room HS Credit',
      'Y',
      'Y',
      'Y',
      'Y'
END

IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODES
  WHERE Category = 'CLASSROOMHSCREDIT'
  AND CodeName = 'Credit 1')
BEGIN
  INSERT INTO GLOBALCODES (Category,
  Codename,
  Active,
  Cannotmodifynameordelete)
    SELECT
      'CLASSROOMHSCREDIT',
      'Credit 1',
      'Y',
      'Y'
END
--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODES
  WHERE Category = 'CLASSROOMHSCREDIT'
  AND CodeName = 'Credit 2')
BEGIN
  INSERT INTO GLOBALCODES (Category,
  Codename,
  Active,
  Cannotmodifynameordelete)
    SELECT
      'CLASSROOMHSCREDIT',
      'Credit 2',
      'Y',
      'Y'
END
--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODECATEGORIES
  WHERE Category = 'CLASSROOMINSTRUCTION')
BEGIN
  INSERT INTO GLOBALCODECATEGORIES (Category,
  Categoryname,
  Active,
  Allowadddelete,
  Allowcodenameedit,
  Allowsortorderedit)
    SELECT
      'CLASSROOMINSTRUCTION',
      'Class Room Length Of Instruction',
      'Y',
      'Y',
      'Y',
      'Y'
END

IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODES
  WHERE Category = 'CLASSROOMINSTRUCTION'
  AND CodeName = 'Instruction 1')
BEGIN
  INSERT INTO GLOBALCODES (Category,
  Codename,
  Active,
  Cannotmodifynameordelete)
    SELECT
      'CLASSROOMINSTRUCTION',
      'Instruction 1',
      'Y',
      'Y'
END
--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODES
  WHERE Category = 'CLASSROOMINSTRUCTION'
  AND CodeName = 'Instruction 2')
BEGIN
  INSERT INTO GLOBALCODES (Category,
  Codename,
  Active,
  Cannotmodifynameordelete)
    SELECT
      'CLASSROOMINSTRUCTION',
      'Instruction 2',
      'Y',
      'Y'
END
--------------------------------------------------------------------------------------------------------------