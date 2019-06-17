-- 
-- What: insert new core recode category for procedure codes that are not to be overriden for e&m note procedure code calculation
-- Why: moving EM coding logic to core broke ability to prevent override from post update stored procedure.  Valley SGL #1038
--
IF NOT EXISTS (
		SELECT *
		FROM RecodeCategories AS rc
		WHERE rc.CategoryCode = 'EMCodeProcCodeOverride'
			AND isnull(rc.RecordDeleted, 'N') = 'N'
		)
BEGIN
	DECLARE @NewCategoryId INT

	INSERT INTO RecodeCategories (
		CategoryCode
		,CategoryName
		,Description
		,MappingEntity
		,RecodeType
		)
	VALUES (
		'EMCodeProcCodeOverride'
		,'E&M Coding Procedure Code Override'
		,'Services for procedure codes specified in this category will *not* be overriden based on settings in the EM coding setup tables.'
		,'ProcedureCodes'
		,8401
		)

	SET @NewCategoryId = SCOPE_IDENTITY()

	-- if there were old recode values defined for "XEMCodeServiceProcedureOverride", copy them to the recode category
	INSERT INTO Recodes (
		IntegerCodeId
		,CharacterCodeId
		,CodeName
		,FromDate
		,ToDate
		,RecodeCategoryId
		)
	SELECT DISTINCT rc.IntegerCodeId
		,rc.CharacterCodeId
		,rc.CodeName
		,rc.FromDate
		,rc.ToDate
		,@NewCategoryId
	FROM Recodes AS rc
	JOIN RecodeCategories AS rcat ON rcat.RecodeCategoryId = rc.RecodeCategoryId
	WHERE rcat.CategoryCode = 'XEMCodeServiceProcedureOverride'
		AND isnull(rcat.RecordDeleted, 'N') = 'N'
		AND isnull(rc.RecordDeleted, 'N') = 'N'
END
