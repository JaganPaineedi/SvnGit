DECLARE @SortOrder INT

SELECT @SortOrder = MAX(SortOrder)
FROM GlobalCodes
WHERE Category = 'CHARGECLAIMSACTION'

SET @SortOrder = @SortOrder +1
IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'CHARGECLAIMSACTION' AND CodeName='Add to Internal Collections' AND ISNULL(RecordDeleted,'N') = 'N')
BEGIN
	INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
	VALUES ('CHARGECLAIMSACTION','Add to Internal Collections','Y','Y',@SortOrder)
END

SET @SortOrder = @SortOrder +1
IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'CHARGECLAIMSACTION' AND CodeName='Add to External Collections' AND ISNULL(RecordDeleted,'N') = 'N')
BEGIN
	INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
	VALUES ('CHARGECLAIMSACTION','Add to External Collections','Y','Y',@SortOrder)
END

SET @SortOrder = @SortOrder +1
IF NOT EXISTS(SELECT 1 FROM GlobalCodes WHERE Category = 'CHARGECLAIMSACTION' AND CodeName='Remove from Internal Collections' AND ISNULL(RecordDeleted,'N') = 'N')
BEGIN
	INSERT INTO GlobalCodes (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder)
	VALUES ('CHARGECLAIMSACTION','Remove from Internal Collections','Y','Y',@SortOrder)
END

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'ExtCollectionStatus'
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
		'ExtCollectionStatus'
		,'ExtCollectionStatus'
		,'Y'
		,'N'
		,'N'
		,'N'
		,'N'
		,'N'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ExtCollectionStatus'
			AND CodeName = 'Added to External Collections'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ExtCollectionStatus'
		,'Added to External Collections'
		,'Added to External Collections'
		,'Y'
		,'Y'
		,1
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ExtCollectionStatus'
			AND CodeName = 'Sent to Collection Agency'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ExtCollectionStatus'
		,'Sent to Collection Agency'
		,'Sent to Collection Agency'
		,'Y'
		,'Y'
		,2
		)
END
