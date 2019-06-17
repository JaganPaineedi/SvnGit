
DECLARE @RecodeCategoryId INT
----------------------Nurse Status Category----------------------------------
IF NOT EXISTS (	SELECT * FROM RecodeCategories	WHERE CategoryName = 'LABWIDGETRNSTATUS' AND ISNULL(RecordDeleted, 'N') = 'N' )
BEGIN
	INSERT INTO RecodeCategories (
		CategoryName
		,CategoryCode
		,MappingEntity
		,Description
		)
	VALUES (
		'LABWIDGETRNSTATUS'
		,'LABWIDGETRNSTATUS'
		,'GlobalCodeId - OrderStatus'
		,'To map Nurse Statuses'
		)

	SET @RecodeCategoryId = SCOPE_IDENTITY()
END
ELSE
BEGIN
	SELECT @RecodeCategoryId = RecodeCategoryId
	FROM RecodeCategories
	WHERE CategoryName = 'LABWIDGETRNSTATUS'
		AND ISNULL(RecordDeleted, 'N') = 'N'
END

IF NOT EXISTS (	SELECT * FROM Recodes WHERE RecodeCategoryId = @RecodeCategoryId AND IntegerCodeId = 6512 AND ISNULL(RecordDeleted, 'N') = 'N' )
BEGIN
	INSERT INTO Recodes (
		CodeName
		,IntegerCodeId
		,RecodeCategoryId
		)
	VALUES (
		'Nurse Reviewed'
		,6512
		,@RecodeCategoryId
		)
END

----------------------Doctor Status Category----------------------------------
IF NOT EXISTS (	SELECT * FROM RecodeCategories	WHERE CategoryName = 'LABWIDGETDRSTATUS' AND ISNULL(RecordDeleted, 'N') = 'N' )
BEGIN
	INSERT INTO RecodeCategories (
		CategoryName
		,CategoryCode
		,MappingEntity
		,Description
		)
	VALUES (
		'LABWIDGETDRSTATUS'
		,'LABWIDGETDRSTATUS'
		,'GlobalCodeId - OrderStatus'
		,'To map Doctor Statuses'
		)

	SET @RecodeCategoryId = SCOPE_IDENTITY()
END
ELSE
BEGIN
	SELECT @RecodeCategoryId = RecodeCategoryId
	FROM RecodeCategories
	WHERE CategoryName = 'LABWIDGETDRSTATUS'
		AND ISNULL(RecordDeleted, 'N') = 'N'
END

IF NOT EXISTS (	SELECT * FROM Recodes WHERE RecodeCategoryId = @RecodeCategoryId AND IntegerCodeId = 6504 AND ISNULL(RecordDeleted, 'N') = 'N' )
BEGIN
	INSERT INTO Recodes (
		CodeName
		,IntegerCodeId
		,RecodeCategoryId
		)
	VALUES (
		'Results Obtained'
		,6504
		,@RecodeCategoryId
		)
END