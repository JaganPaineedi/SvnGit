/********************************************************************************
--
-- Copyright:   Streamline Healthcare Solutions
-- Author:	    K. Soujanya
-- CreatedDate: 30/oct/2018
-- Purpose:     To insert a new entry into Globalcodes for the GlobalCodeCategory 'CLAIMLINESACTION',Task #591 - SWMBH - Enhancements

*********************************************************************************/

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE Code = 'VOID'
			AND Category = 'CLAIMLINESACTION'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'CLAIMLINESACTION'
		,'Void'
		,'VOID'
		,NULL
		,'Y'
		,'Y'
		,2
		)
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE Code = 'ADDTOUNDERREVIEW'
			AND Category = 'CLAIMLINESACTION'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'CLAIMLINESACTION'
		,'Add to Under Review'
		,'ADDTOUNDERREVIEW'
		,NULL
		,'Y'
		,'Y'
		,3
		)
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE Code = 'REMOVEFROMUNDERREVIEW'
			AND Category = 'CLAIMLINESACTION'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'CLAIMLINESACTION'
		,'Remove From Under Review'
		,'REMOVEFROMUNDERREVIEW'
		,NULL
		,'Y'
		,'Y'
		,4
		)
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE Code = 'MANUALPEND'
			AND Category = 'CLAIMLINESACTION'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'CLAIMLINESACTION'
		,'Manual Pend'
		,'MANUALPEND'
		,NULL
		,'Y'
		,'Y'
		,5
		)
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE Code = 'MARKASFINALSTATUS'
			AND Category = 'CLAIMLINESACTION'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'CLAIMLINESACTION'
		,'Mark as Final Status'
		,'MARKASFINALSTATUS'
		,NULL
		,'Y'
		,'Y'
		,6
		)
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE Code = 'REVERTFINALSTATUS'
			AND Category = 'CLAIMLINESACTION'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'CLAIMLINESACTION'
		,'Revert Final Status'
		,'REVERTFINALSTATUS'
		,NULL
		,'Y'
		,'Y'
		,7
		)
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE Code = 'REMOVETOBEWORKED'
			AND Category = 'CLAIMLINESACTION'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'CLAIMLINESACTION'
		,'Remove To Be Worked'
		,'REMOVETOBEWORKED'
		,NULL
		,'Y'
		,'Y'
		,8
		)
END


IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE Code = 'DENY'
			AND Category = 'CLAIMLINESACTION'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'CLAIMLINESACTION'
		,'Deny'
		,'DENY'
		,NULL
		,'Y'
		,'Y'
		,9
		)
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE Code = 'ADJUDICATE'
			AND Category = 'CLAIMLINESACTION'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'CLAIMLINESACTION'
		,'Adjudicate'
		,'ADJUDICATE'
		,NULL
		,'Y'
		,'Y'
		,10
		)
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE Code = 'PAY'
			AND Category = 'CLAIMLINESACTION'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'CLAIMLINESACTION'
		,'Pay'
		,'PAY'
		,NULL
		,'Y'
		,'Y'
		,11
		)
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE Code = 'DENIALLETTER'
			AND Category = 'CLAIMLINESACTION'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'CLAIMLINESACTION'
		,'Denial Letter'
		,'DENIALLETTER'
		,NULL
		,'Y'
		,'Y'
		,12
		)
END


IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE Code = 'REVERT'
			AND Category = 'CLAIMLINESACTION'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'CLAIMLINESACTION'
		,'Revert'
		,'REVERT'
		,NULL
		,'Y'
		,'Y'
		,13
		)
END
IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE Code = 'READJUDICATE'
			AND Category = 'CLAIMLINESACTION'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'CLAIMLINESACTION'
		,'Re-adjudicate'
		,'READJUDICATE'
		,NULL
		,'Y'
		,'Y'
		,14
		)
END
IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE Code = 'DONOTADJUDICATE'
			AND Category = 'CLAIMLINESACTION'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'CLAIMLINESACTION'
		,'Do not Adjudicate'
		,'DONOTADJUDICATE'
		,NULL
		,'Y'
		,'Y'
		,15
		)
END

IF NOT EXISTS (
		SELECT *
		FROM globalcodes
		WHERE Code = 'APPROVE'
			AND Category = 'CLAIMLINESACTION'
		)
BEGIN
	INSERT INTO globalcodes (
		Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		'CLAIMLINESACTION'
		,'Approve'
		,'APPROVE'
		,NULL
		,'Y'
		,'Y'
		,16
		)
END