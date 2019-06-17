-- 26/July/2017      Added by: Ajay       What/why: Created GlobalCodes for AHN-Customization: #44

-- GlobalCode Category 'CHARGESTATUS'

IF NOT EXISTS (SELECT
    *
  FROM dbo.GlobalCodeCategories
  WHERE Category = 'CHARGESTATUS')
BEGIN
  INSERT INTO dbo.GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement)
    VALUES ('CHARGESTATUS', 'CHARGESTATUS', 'Y', 'Y', 'N', 'N', NULL, 'N', 'N', 'N', 'Y')
END

-- GlobalCodes

IF NOT EXISTS (SELECT
    *
  FROM globalcodes
  WHERE Category = 'CHARGESTATUS'
  AND GlobalCodeId = 9453)
BEGIN
  SET IDENTITY_INSERT GlobalCodes ON
  INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder)
    VALUES (9453, 'CHARGESTATUS', 'Denied', NULL, 'Y', 'Y', 1)
  SET IDENTITY_INSERT GlobalCodes OFF
END

IF NOT EXISTS (SELECT
    *
  FROM globalcodes
  WHERE Category = 'CHARGESTATUS'
  AND GlobalCodeId = 9454)
BEGIN
  SET IDENTITY_INSERT GlobalCodes ON
  INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder)
    VALUES (9454, 'CHARGESTATUS', 'Charge Created', NULL, 'Y', 'Y', 2)
  SET IDENTITY_INSERT GlobalCodes OFF
END


IF NOT EXISTS (SELECT
    *
  FROM globalcodes
  WHERE Category = 'CHARGESTATUS'
  AND GlobalCodeId = 9455)
BEGIN
  SET IDENTITY_INSERT GlobalCodes ON
  INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder)
    VALUES (9455, 'CHARGESTATUS', 'Claim Sent', NULL, 'Y', 'Y', 3)
  SET IDENTITY_INSERT GlobalCodes OFF
END

IF NOT EXISTS (SELECT
    *
  FROM globalcodes
  WHERE Category = 'CHARGESTATUS'
  AND GlobalCodeId = 9456)
BEGIN
  SET IDENTITY_INSERT GlobalCodes ON
  INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder)
    VALUES (9456, 'CHARGESTATUS', 'Paid', NULL, 'Y', 'Y', 4)
  SET IDENTITY_INSERT GlobalCodes OFF
END

IF NOT EXISTS (SELECT
    *
  FROM globalcodes
  WHERE Category = 'CHARGESTATUS'
  AND GlobalCodeId = 9457)
BEGIN
  SET IDENTITY_INSERT GlobalCodes ON
  INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder)
    VALUES (9457, 'CHARGESTATUS', 'Partially Paid', NULL, 'Y', 'Y', 5)
  SET IDENTITY_INSERT GlobalCodes OFF
END

IF NOT EXISTS (SELECT
    *
  FROM globalcodes
  WHERE Category = 'CHARGESTATUS'
  AND GlobalCodeId = 9458)
BEGIN
  SET IDENTITY_INSERT GlobalCodes ON
  INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder)
    VALUES (9458, 'CHARGESTATUS', 'Closed', NULL, 'Y', 'Y', 6)
  SET IDENTITY_INSERT GlobalCodes OFF
END