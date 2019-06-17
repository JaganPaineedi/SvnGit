DECLARE @categoryId INT
DECLARE @RoleId INT

IF NOT EXISTS (
		SELECT *
		FROM RecodeCategories
		WHERE CategoryCode = 'ORDERACKNOWLEDGMENTROLES'
		)
BEGIN
	INSERT INTO RecodeCategories (
		CategoryCode
		,CategoryName
		,Description
		,MappingEntity
		)
	VALUES (
		'ORDERACKNOWLEDGMENTROLES'
		,'Order Acknowledgment Roles'
		,'This category is used within Orders Set up for configuring Acknowledgment Roles'
		,'GlobalCodeId'
		)
END


SET @categoryId = (
		SELECT TOP 1 RecodeCategoryId
		FROM RecodeCategories
		WHERE CategoryCode = 'ORDERACKNOWLEDGMENTROLES'
		)

SET @RoleId = NULL -- '<-- Configure RoleId here'

IF NOT EXISTS (
		SELECT *
		FROM dbo.Recodes
		WHERE RecodeCategoryId = @categoryId AND IntegerCodeId = @RoleId
		)
BEGIN
	INSERT INTO dbo.Recodes (
		IntegerCodeId
		,FromDate
		,ToDate
		,RecodeCategoryId
		)
	VALUES (
		@RoleId
		,GETDATE()
		,NULL
		,@categoryId
		)
END