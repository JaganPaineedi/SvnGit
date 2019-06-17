DECLARE @OrderId INT
DECLARE @RecodeCategoryId INT

IF NOT EXISTS ( SELECT * FROM Orders WHERE OrderName = 'Rx Order' AND ISNULL(RecordDeleted, 'N') = 'N' )
BEGIN
	INSERT INTO Orders (
		OrderName
		,OrderType
		,CanBeCompleted
		,CanBePended
		,HasRationale
		,HasComments
		,Active
		,ShowOnWhiteBoard
		,NeedsDiagnosis
		,IsBillable
		,AddOrderToMAR
		,Prescription
		,Permissioned
		,Sensitive
		)
	VALUES (
		'Rx Order'
		,8503
		,'N'
		,'N'
		,'N'
		,'N'
		,'Y'
		,'N'
		,'N'
		,'N'
		,'Y'
		,'N'
		,'N'
		,'N'
		)

	SET @OrderId = SCOPE_IDENTITY()
END
ELSE
BEGIN
	SELECT @OrderId = OrderId
	FROM Orders
	WHERE OrderName = 'Rx Order'
		AND ISNULL(RecordDeleted, 'N') = 'N'
END

IF NOT EXISTS (	SELECT * FROM RecodeCategories	WHERE CategoryName = 'RxOrder'	AND ISNULL(RecordDeleted, 'N') = 'N' )
BEGIN
	INSERT INTO RecodeCategories (
		CategoryName
		,CategoryCode
		,MappingEntity
		,Description
		)
	VALUES (
		'RxOrder'
		,'RxOrder'
		,'OrderId'
		,'To map Rx Medications to SC Orders'
		)

	SET @RecodeCategoryId = SCOPE_IDENTITY()
END
ELSE
BEGIN
	SELECT @RecodeCategoryId = RecodeCategoryId
	FROM RecodeCategories
	WHERE CategoryName = 'RxOrder'
		AND ISNULL(RecordDeleted, 'N') = 'N'
END

IF NOT EXISTS (	SELECT * FROM Recodes WHERE RecodeCategoryId = @RecodeCategoryId AND IntegerCodeId = @OrderId AND ISNULL(RecordDeleted, 'N') = 'N' )
BEGIN
	INSERT INTO Recodes (
		CodeName
		,IntegerCodeId
		,RecodeCategoryId
		)
	VALUES (
		'RxOrder'
		,@OrderId
		,@RecodeCategoryId
		)
END

