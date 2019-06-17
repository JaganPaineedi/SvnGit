/* Category :  */
/*Insert Into GlobalCodes */
/*Insert Into GlobalCodeCategories */
/* XMilitarySTATUS */

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'ASSIGNMENTTYPES'
		)
		BEGIN
	INSERT INTO [GlobalCodeCategories] (
		Category
		,CategoryName
		,Active
		,AllowAddDelete
		,AllowCodeNameEdit
		,AllowSortOrderEdit
		,UserDefinedCategory
		,HasSubcodes
		)
	VALUES (
		'ASSIGNMENTTYPES'
		,'ASSIGNMENTTYPES'
		,'Y'
		,'N'
		,'N'
		,'N'
		,'N'
		,'N'
		)
END



SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS (
		SELECT *
		FROM [GlobalCodes]
		WHERE Category = 'ASSIGNMENTTYPES'
			AND CodeName = 'Primary Clinician'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		GlobalCodeId
		,[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		 9431
		,'ASSIGNMENTTYPES'
		,'Primary Clinician'
		,'PRIMARYCLINICIAN'
		,'Y'
		,'Y'
		,1
		)
END
SET IDENTITY_INSERT GlobalCodes OFF



SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ASSIGNMENTTYPES'
			AND CodeName = 'Flag'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		GlobalCodeId
		,[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		 9432
		,'ASSIGNMENTTYPES'
		,'Flag'
		,'FLAG'
		,'Y'
		,'Y'
		,2
		)
END
SET IDENTITY_INSERT GlobalCodes OFF

SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ASSIGNMENTTYPES'
			AND CodeName = 'Program'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		GlobalCodeId
		,[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		 9433
		,'ASSIGNMENTTYPES'
		,'Program'
		,'PROGRAM'
		,'Y'
		,'Y'
		,3
		)
END
SET IDENTITY_INSERT GlobalCodes OFF


SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ASSIGNMENTTYPES'
			AND CodeName = 'Primary Physician'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		GlobalCodeId
		,[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		 9434
		,'ASSIGNMENTTYPES'
		,'Primary Physician'
		,'PRIMARYPHYSICIAN'
		,'Y'
		,'Y'
		,4
		)
END
SET IDENTITY_INSERT GlobalCodes OFF



SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ASSIGNMENTTYPES'
			AND CodeName = 'Documents'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		GlobalCodeId
		,[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		 9435
		,'ASSIGNMENTTYPES'
		,'Documents'
		,'DOCUMENTS'
		,'Y'
		,'Y'
		,5
		)
END
SET IDENTITY_INSERT GlobalCodes OFF


SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ASSIGNMENTTYPES'
			AND CodeName = 'Events'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		GlobalCodeId
		,[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		 9436
		,'ASSIGNMENTTYPES'
		,'Events'
		,'EVENTS'
		,'Y'
		,'Y'
		,6
		)
END
SET IDENTITY_INSERT GlobalCodes OFF


SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ASSIGNMENTTYPES'
			AND CodeName = 'Orders'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		GlobalCodeId
		,[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		 9437
		,'ASSIGNMENTTYPES'
		,'Orders'
		,'ORDERS'
		,'Y'
		,'Y'
		,7
		)
END
SET IDENTITY_INSERT GlobalCodes OFF


SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ASSIGNMENTTYPES'
			AND CodeName = 'Inquiry'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		GlobalCodeId
		,[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		 9438
		,'ASSIGNMENTTYPES'
		,'Inquiry'
		,'INQUIRY'
		,'Y'
		,'Y'
		,8
		)
END
SET IDENTITY_INSERT GlobalCodes OFF

SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ASSIGNMENTTYPES'
			AND CodeName = 'Financial Assignments'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		GlobalCodeId
		,[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		 9439
		,'ASSIGNMENTTYPES'
		,'Financial Assignments'
		,'FINANCIALASSIGNMENTS'
		,'Y'
		,'Y'
		,9
		)
END
SET IDENTITY_INSERT GlobalCodes OFF


SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ASSIGNMENTTYPES'
			AND CodeName = 'Contact Notes'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		GlobalCodeId
		,[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		 9440
		,'ASSIGNMENTTYPES'
		,'Contact Notes'
		,'CONTACTNOTES'
		,'Y'
		,'Y'
		,10
		)
END
SET IDENTITY_INSERT GlobalCodes OFF

SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ASSIGNMENTTYPES'
			AND CodeName = 'Disclosures'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		GlobalCodeId
		,[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		 9441
		,'ASSIGNMENTTYPES'
		,'Disclosures'
		,'DISCLOSURES'
		,'Y'
		,'Y'
		,11
		)
END
SET IDENTITY_INSERT GlobalCodes OFF

SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ASSIGNMENTTYPES'
			AND CodeName = 'Grievances/Appeals'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		GlobalCodeId
		,[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		 9442
		,'ASSIGNMENTTYPES'
		,'Grievances/Appeals'
		,'GRIEVANCES/APPEALS'
		,'Y'
		,'Y'
		,12
		)
END
SET IDENTITY_INSERT GlobalCodes OFF

SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ASSIGNMENTTYPES'
			AND CodeName = 'Peer Record Reviews'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		GlobalCodeId
		,[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		 9443
		,'ASSIGNMENTTYPES'
		,'Peer Record Reviews'
		,'PEERRECORDREVIEWS'
		,'Y'
		,'Y'
		,13
		)
END
SET IDENTITY_INSERT GlobalCodes OFF

SET IDENTITY_INSERT GlobalCodes ON
IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ASSIGNMENTTYPES'
			AND CodeName = 'Rx'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		GlobalCodeId
		,[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		 9444
		,'ASSIGNMENTTYPES'
		,'Rx'
		,'RX'
		,'Y'
		,'Y'
		,14
		)
END
SET IDENTITY_INSERT GlobalCodes OFF


