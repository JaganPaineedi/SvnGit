/********************************************************************************
--
-- Copyright:   Streamline Healthcare Solutions
-- Author:	    K. Soujanya
-- CreatedDate: 31/Oct/2018
-- Purpose:     To insert a new entry into GlobalSubcodes for the  Category 'FILTERCMCLAIMLINES',Task #591 - SWMBH - Enhancements
*********************************************************************************/
IF NOT EXISTS (
		SELECT GlobalSubCodeId
		FROM GlobalSubCodes
		WHERE GlobalSubCodeId = 6271
		)
BEGIN
	SET IDENTITY_INSERT GlobalSubCodes ON

	INSERT INTO GlobalSubCodes (
		GlobalSubCodeId
		,GlobalCodeId
		,SubCodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		6271
		,8722
		,'Claim Line Under Review'
		,'ClaimLineUnderReview'
		,NULL
		,'Y'
		,'Y'
		,18
		)

	SET IDENTITY_INSERT GlobalCodes OFF
END

IF NOT EXISTS (
		SELECT GlobalSubCodeId
		FROM GlobalSubCodes
		WHERE GlobalSubCodeId = 6272
		)
BEGIN
	SET IDENTITY_INSERT GlobalSubCodes ON

	INSERT INTO GlobalSubCodes (
		GlobalSubCodeId
		,GlobalCodeId
		,SubCodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
		6272
		,8722
		,'Final Status'
		,'FinalStatus'
		,NULL
		,'Y'
		,'Y'
		,19
		)

	SET IDENTITY_INSERT GlobalCodes OFF
END

