/********************************************************************************************
/*	Date    : 13 Sep 2016																					 */
/*	Author  : Alok Kumar 																					 */
/*	Purpose : Created for the Task #602- Aspenpointe Customizations											*/
*********************************************************************************************/


--Insert script for GlobalCodeCategories [TRIAGESTATUS]

IF EXISTS (SELECT
    1
  FROM dbo.GlobalCodeCategories
  WHERE Category = 'TRIAGESTATUS')
BEGIN
  
	--Insert/Update script for globalcodes [TRIAGESTATUS]
	--IF NOT EXISTS (SELECT
	--	1
	--  FROM globalcodes
	--  WHERE GlobalCodeId = 9410)
	--BEGIN
	--  SET IDENTITY_INSERT dbo.GlobalCodes ON
	--  INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder)
	--	VALUES (9410, 'TRIAGESTATUS', 'Heads up', NULL, 'Y', 'Y', 1)
	--  SET IDENTITY_INSERT dbo.GlobalCodes OFF
	--END
	--ELSE
	--BEGIN
	--  UPDATE globalcodes
	--  SET Category = 'TRIAGESTATUS',
	--	  CodeName = 'Heads up',
	--	  Description = NULL,
	--	  Active = 'Y',
	--	  CannotModifyNameOrDelete = 'Y',
	--	  SortOrder = 1,
	--	  ExternalCode1 = NULL
	--  WHERE GlobalCodeId = 9410
	--END

	IF NOT EXISTS (SELECT
		1
	  FROM globalcodes
	  WHERE GlobalCodeId = 9411)
	BEGIN
	  SET IDENTITY_INSERT dbo.GlobalCodes ON
	  INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder)
		VALUES (9411, 'TRIAGESTATUS', 'Information Only', NULL, 'Y', 'Y', 2)
	  SET IDENTITY_INSERT dbo.GlobalCodes OFF
	END
	--ELSE
	--BEGIN
	--  UPDATE globalcodes
	--  SET Category = 'TRIAGESTATUS',
	--	  CodeName = 'Information Only',
	--	  Description = NULL,
	--	  Active = 'Y',
	--	  CannotModifyNameOrDelete = 'Y',
	--	  SortOrder = 2,
	--	  ExternalCode1 = NULL
	--  WHERE GlobalCodeId = 9411
	--END

	IF NOT EXISTS (SELECT
		1
	  FROM globalcodes
	  WHERE GlobalCodeId = 9412)
	BEGIN
	  SET IDENTITY_INSERT dbo.GlobalCodes ON
	  INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder)
		VALUES (9412, 'TRIAGESTATUS', 'Medical Clearance Pending', NULL, 'Y', 'Y', 3)
	  SET IDENTITY_INSERT dbo.GlobalCodes OFF
	END
	--ELSE
	--BEGIN
	--  UPDATE globalcodes
	--  SET Category = 'TRIAGESTATUS',
	--	  CodeName = 'Medical Clearance Pending',
	--	  Description = NULL,
	--	  Active = 'Y',
	--	  CannotModifyNameOrDelete = 'Y',
	--	  SortOrder = 3,
	--	  ExternalCode1 = NULL
	--  WHERE GlobalCodeId = 9412
	--END


	IF NOT EXISTS (SELECT
		1
	  FROM globalcodes
	  WHERE GlobalCodeId = 9413)
	BEGIN
	  SET IDENTITY_INSERT dbo.GlobalCodes ON
	  INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder)
		VALUES (9413, 'TRIAGESTATUS', 'Medical Clearance Final', NULL, 'Y', 'Y', 4)
	  SET IDENTITY_INSERT dbo.GlobalCodes OFF
	END
	--ELSE
	--BEGIN
	--  UPDATE globalcodes
	--  SET Category = 'TRIAGESTATUS',
	--	  CodeName = 'Medical Clearance Final',
	--	  Description = NULL,
	--	  Active = 'Y',
	--	  CannotModifyNameOrDelete = 'Y',
	--	  SortOrder = 4,
	--	  ExternalCode1 = NULL
	--  WHERE GlobalCodeId = 9413
	--END


	IF NOT EXISTS (SELECT
		1
	  FROM globalcodes
	  WHERE GlobalCodeId = 9414)
	BEGIN
	  SET IDENTITY_INSERT dbo.GlobalCodes ON
	  INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder)
		VALUES (9414, 'TRIAGESTATUS', 'Evaluator Requested', NULL, 'Y', 'Y', 5)
	  SET IDENTITY_INSERT dbo.GlobalCodes OFF
	END
	--ELSE
	--BEGIN
	--  UPDATE globalcodes
	--  SET Category = 'TRIAGESTATUS',
	--	  CodeName = 'Evaluator Requested',
	--	  Description = NULL,
	--	  Active = 'Y',
	--	  CannotModifyNameOrDelete = 'Y',
	--	  SortOrder = 5,
	--	  ExternalCode1 = NULL
	--  WHERE GlobalCodeId = 9414
	--END


	IF NOT EXISTS (SELECT
		1
	  FROM globalcodes
	  WHERE GlobalCodeId = 9415)
	BEGIN
	  SET IDENTITY_INSERT dbo.GlobalCodes ON
	  INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder)
		VALUES (9415, 'TRIAGESTATUS', 'Evaluation Completed', NULL, 'Y', 'Y', 6)
	  SET IDENTITY_INSERT dbo.GlobalCodes OFF
	END
	--ELSE
	--BEGIN
	--  UPDATE globalcodes
	--  SET Category = 'TRIAGESTATUS',
	--	  CodeName = 'Evaluation Completed',
	--	  Description = NULL,
	--	  Active = 'Y',
	--	  CannotModifyNameOrDelete = 'Y',
	--	  SortOrder = 6,
	--	  ExternalCode1 = NULL
	--  WHERE GlobalCodeId = 9415
	--END


	IF NOT EXISTS (SELECT
		1
	  FROM globalcodes
	  WHERE GlobalCodeId = 9416)
	BEGIN
	  SET IDENTITY_INSERT dbo.GlobalCodes ON
	  INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder)
		VALUES (9416, 'TRIAGESTATUS', 'Request for Placement', NULL, 'Y', 'Y', 7)
	  SET IDENTITY_INSERT dbo.GlobalCodes OFF
	END
	--ELSE
	--BEGIN
	--  UPDATE globalcodes
	--  SET Category = 'TRIAGESTATUS',
	--	  CodeName = 'Request for Placement',
	--	  Description = NULL,
	--	  Active = 'Y',
	--	  CannotModifyNameOrDelete = 'Y',
	--	  SortOrder = 7,
	--	  ExternalCode1 = NULL
	--  WHERE GlobalCodeId = 9416
	--END


	IF NOT EXISTS (SELECT
		1
	  FROM globalcodes
	  WHERE GlobalCodeId = 9417)
	BEGIN
	  SET IDENTITY_INSERT dbo.GlobalCodes ON
	  INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder)
		VALUES (9417, 'TRIAGESTATUS', 'Nurse to Nurse Requested', NULL, 'Y', 'Y', 8)
	  SET IDENTITY_INSERT dbo.GlobalCodes OFF
	END
	--ELSE
	--BEGIN
	--  UPDATE globalcodes
	--  SET Category = 'TRIAGESTATUS',
	--	  CodeName = 'Nurse to Nurse Requested',
	--	  Description = NULL,
	--	  Active = 'Y',
	--	  CannotModifyNameOrDelete = 'Y',
	--	  SortOrder = 8,
	--	  ExternalCode1 = NULL
	--  WHERE GlobalCodeId = 9417
	--END


	IF NOT EXISTS (SELECT
		1
	  FROM globalcodes
	  WHERE GlobalCodeId = 9418)
	BEGIN
	  SET IDENTITY_INSERT dbo.GlobalCodes ON
	  INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder)
		VALUES (9418, 'TRIAGESTATUS', 'Transportation Requested', NULL, 'Y', 'Y', 9)
	  SET IDENTITY_INSERT dbo.GlobalCodes OFF
	END
	--ELSE
	--BEGIN
	--  UPDATE globalcodes
	--  SET Category = 'TRIAGESTATUS',
	--	  CodeName = 'Transportation Requested',
	--	  Description = NULL,
	--	  Active = 'Y',
	--	  CannotModifyNameOrDelete = 'Y',
	--	  SortOrder = 9,
	--	  ExternalCode1 = NULL
	--  WHERE GlobalCodeId = 9418
	--END


	IF NOT EXISTS (SELECT
		1
	  FROM globalcodes
	  WHERE GlobalCodeId = 9419)
	BEGIN
	  SET IDENTITY_INSERT dbo.GlobalCodes ON
	  INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder)
		VALUES (9419, 'TRIAGESTATUS', 'Referral Closed', NULL, 'Y', 'Y', 10)
	  SET IDENTITY_INSERT dbo.GlobalCodes OFF
	END
	--ELSE
	--BEGIN
	--  UPDATE globalcodes
	--  SET Category = 'TRIAGESTATUS',
	--	  CodeName = 'Referral Closed',
	--	  Description = NULL,
	--	  Active = 'Y',
	--	  CannotModifyNameOrDelete = 'Y',
	--	  SortOrder = 10,
	--	  ExternalCode1 = NULL
	--  WHERE GlobalCodeId = 9419
	--END


	IF NOT EXISTS (SELECT
		1
	  FROM globalcodes
	  WHERE GlobalCodeId = 9420)
	BEGIN
	  SET IDENTITY_INSERT dbo.GlobalCodes ON
	  INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder)
		VALUES (9420, 'TRIAGESTATUS', 'Mobile Requested', NULL, 'Y', 'Y', 11)
	  SET IDENTITY_INSERT dbo.GlobalCodes OFF
	END
	--ELSE
	--BEGIN
	--  UPDATE globalcodes
	--  SET Category = 'TRIAGESTATUS',
	--	  CodeName = 'Mobile Requested',
	--	  Description = NULL,
	--	  Active = 'Y',
	--	  CannotModifyNameOrDelete = 'Y',
	--	  SortOrder = 11,
	--	  ExternalCode1 = NULL
	--  WHERE GlobalCodeId = 9420
	--END
	
	
	IF NOT EXISTS (SELECT
		1
	  FROM globalcodes
	  WHERE GlobalCodeId = 9421)
	BEGIN
	  SET IDENTITY_INSERT dbo.GlobalCodes ON
	  INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder)
		VALUES (9421, 'TRIAGESTATUS', 'Mobile Dispatched', NULL, 'Y', 'Y', 12)
	  SET IDENTITY_INSERT dbo.GlobalCodes OFF
	END
	--ELSE
	--BEGIN
	--  UPDATE globalcodes
	--  SET Category = 'TRIAGESTATUS',
	--	  CodeName = 'Mobile Dispatched',
	--	  Description = NULL,
	--	  Active = 'Y',
	--	  CannotModifyNameOrDelete = 'Y',
	--	  SortOrder = 12,
	--	  ExternalCode1 = NULL
	--  WHERE GlobalCodeId = 9421
	--END
	
	
	IF NOT EXISTS (SELECT
		1
	  FROM globalcodes
	  WHERE GlobalCodeId = 9422)
	BEGIN
	  SET IDENTITY_INSERT dbo.GlobalCodes ON
	  INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder)
		VALUES (9422, 'TRIAGESTATUS', 'Mobile Contact', NULL, 'Y', 'Y', 13)
	  SET IDENTITY_INSERT dbo.GlobalCodes OFF
	END
	--ELSE
	--BEGIN
	--  UPDATE globalcodes
	--  SET Category = 'TRIAGESTATUS',
	--	  CodeName = 'Mobile Contact',
	--	  Description = NULL,
	--	  Active = 'Y',
	--	  CannotModifyNameOrDelete = 'Y',
	--	  SortOrder = 13,
	--	  ExternalCode1 = NULL
	--  WHERE GlobalCodeId = 9422
	--END


	IF NOT EXISTS (SELECT
		1
	  FROM globalcodes
	  WHERE GlobalCodeId = 9423)
	BEGIN
	  SET IDENTITY_INSERT dbo.GlobalCodes ON
	  INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder)
		VALUES (9423, 'TRIAGESTATUS', 'CSU Contact', NULL, 'Y', 'Y', 14)
	  SET IDENTITY_INSERT dbo.GlobalCodes OFF
	END
	--ELSE
	--BEGIN
	--  UPDATE globalcodes
	--  SET Category = 'TRIAGESTATUS',
	--	  CodeName = 'CSU Contact',
	--	  Description = NULL,
	--	  Active = 'Y',
	--	  CannotModifyNameOrDelete = 'Y',
	--	  SortOrder = 14,
	--	  ExternalCode1 = NULL
	--  WHERE GlobalCodeId = 9423
	--END
	

	IF NOT EXISTS (SELECT
		1
	  FROM globalcodes
	  WHERE GlobalCodeId = 9424)
	BEGIN
	  SET IDENTITY_INSERT dbo.GlobalCodes ON
	  INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder)
		VALUES (9424, 'TRIAGESTATUS', 'Respite Contact', NULL, 'Y', 'Y', 15)
	  SET IDENTITY_INSERT dbo.GlobalCodes OFF
	END
	--ELSE
	--BEGIN
	--  UPDATE globalcodes
	--  SET Category = 'TRIAGESTATUS',
	--	  CodeName = 'Respite Contact',
	--	  Description = NULL,
	--	  Active = 'Y',
	--	  CannotModifyNameOrDelete = 'Y',
	--	  SortOrder = 15,
	--	  ExternalCode1 = NULL
	--  WHERE GlobalCodeId = 9424
	--END


	IF NOT EXISTS (SELECT
		1
	  FROM globalcodes
	  WHERE GlobalCodeId = 9425)
	BEGIN
	  SET IDENTITY_INSERT dbo.GlobalCodes ON
	  INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder)
		VALUES (9425, 'TRIAGESTATUS', 'Crisis in progress', NULL, 'Y', 'Y', 16)
	  SET IDENTITY_INSERT dbo.GlobalCodes OFF
	END
	--ELSE
	--BEGIN
	--  UPDATE globalcodes
	--  SET Category = 'TRIAGESTATUS',
	--	  CodeName = 'Crisis in progress',
	--	  Description = NULL,
	--	  Active = 'Y',
	--	  CannotModifyNameOrDelete = 'Y',
	--	  SortOrder = 16,
	--	  ExternalCode1 = NULL
	--  WHERE GlobalCodeId = 9425
	--END
	



END

GO