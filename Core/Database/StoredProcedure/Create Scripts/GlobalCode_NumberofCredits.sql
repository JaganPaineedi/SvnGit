IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODECATEGORIES
  WHERE Category = 'NumberofCredits')
BEGIN
  INSERT INTO GLOBALCODECATEGORIES (Category,
  Categoryname,
  Active,
  Allowadddelete,
  Allowcodenameedit,
  Allowsortorderedit)
    SELECT
      'NumberofCredits',
      'Number of Credits',
      'Y',
      'Y',
      'Y',
      'Y'
END

IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODES
  WHERE Category = 'NumberofCredits'
  AND CodeName = '1')
BEGIN
  INSERT INTO GLOBALCODES (Category,
  Codename,
  Active,
  Cannotmodifynameordelete)
    SELECT
      'NumberofCredits',
      '1',
      'Y',
      'Y'
END
--------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODES
  WHERE Category = 'NumberofCredits'
  AND CodeName = '2')
BEGIN
  INSERT INTO GLOBALCODES (Category,
  Codename,
  Active,
  Cannotmodifynameordelete)
    SELECT
      'NumberofCredits',
      '2',
      'Y',
      'Y'
END


IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODES
  WHERE Category = 'NumberofCredits'
  AND CodeName = '3')
BEGIN
  INSERT INTO GLOBALCODES (Category,
  Codename,
  Active,
  Cannotmodifynameordelete)
    SELECT
      'NumberofCredits',
      '3',
      'Y',
      'Y'
END


IF NOT EXISTS (SELECT
    1
  FROM GLOBALCODES
  WHERE Category = 'NumberofCredits'
  AND CodeName = '4')
BEGIN
  INSERT INTO GLOBALCODES (Category,
  Codename,
  Active,
  Cannotmodifynameordelete)
    SELECT
      'NumberofCredits',
      '4',
      'Y',
      'Y'
END