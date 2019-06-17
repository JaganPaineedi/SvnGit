--
-- Set up the recodes for NDNW Enhancements #18
--
DECLARE @RecodeCategory VARCHAR(100) = 'XCoveragePlansToUseSupervisorNPI';
DECLARE @RecodeCategoryId INT;
DECLARE @User VARCHAR(30) = 'Task 18';

SELECT @RecodeCategoryId = RecodeCategoryId
FROM RecodeCategories
WHERE CategoryCode = @RecodeCategory
	AND isnull(RecordDeleted, 'N') <> 'Y';

IF @RecodeCategoryId IS NULL
BEGIN
	INSERT INTO RecodeCategories (
		CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDAte
		,CategoryCode
		,CategoryName
		,Description
		,MappingEntity
		,RecodeType
		)
	VALUES (
		@user
		,GetDAte()
		,@user
		,GetDate()
		,@RecodeCategory
		,@RecodeCategory
		,'Coverage plans whose residential service claims in service area SA will use the clinician''s NPI as rendering.'
		,'CoveragePlanId'
		,8401
		);

	SET @RecodeCategoryId = Scope_Identity();
END;

IF (
		SELECT count(*)
		FROM Recodes
		WHERE RecodeCategoryId = @RecodeCategoryId
			AND isnull(RecordDeleted, 'N') <> 'Y'
		) = 0
BEGIN
	INSERT INTO Recodes (
		CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,IntegerCodeId
		,CodeName
		,FromDate
		,ToDate
		,RecodeCategoryId
		)
	VALUES (
		@user
		,GetDAte()
		,@User
		,GetDAte()
		,284
		,'Columbia Pacific CCO'
		,'20010101'
		,NULL
		,@RecodeCategoryId
		)
		,(
		@user
		,GetDAte()
		,@User
		,GetDAte()
		,299
		,'Jackson Care CCO'
		,'20010101'
		,NULL
		,@RecodeCategoryId
		)
		,(
		@user
		,GetDAte()
		,@User
		,GetDAte()
		,316
		,'Trillium'
		,'20010101'
		,NULL
		,@RecodeCategoryId
		);
END;
go
