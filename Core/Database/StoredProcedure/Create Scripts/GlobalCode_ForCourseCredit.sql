IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODECATEGORIES
  WHERE Category = 'CourseCreditNumber')
BEGIN
  INSERT INTO GLOBALCODECATEGORIES (Category,
  Categoryname,
  Active,
  Allowadddelete,
  Allowcodenameedit,
  Allowsortorderedit)
    SELECT
      'CourseCreditNumber',
      'Course Credit Number',
      'Y',
      'Y',
      'Y',
      'Y'
END

IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODES
  WHERE Category = 'CourseCreditNumber'
  AND CodeName = 'Credit 1')
BEGIN
  INSERT INTO GLOBALCODES (Category,
  Codename,
  Active,
  Cannotmodifynameordelete)
    SELECT
      'CourseCreditNumber',
      'Credit 1',
      'Y',
      'Y'
END
--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODES
  WHERE Category = 'CourseCreditNumber'
  AND CodeName = 'Credit 2')
BEGIN
  INSERT INTO GLOBALCODES (Category,
  Codename,
  Active,
  Cannotmodifynameordelete)
    SELECT
      'CourseCreditNumber',
      'Credit 2',
      'Y',
      'Y'
END