
IF NOT EXISTS (
		SELECT *
		FROM RecodeCategories AS rc
		WHERE rc.CategoryCode = 'RECODECREDENTIALINGSTATUSFORAPPTSEARCH'
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
		'RECODECREDENTIALINGSTATUSFORAPPTSEARCH'
		,'Recode Credentialing  Status  For Appointment Search'
		,'Credentialing Status values listed in this category will be used when doing appointment search by Plan or Payer'
		,'GlobalCodeId'
		,8401
		)

	SET @NewCategoryId = SCOPE_IDENTITY()
	
	

INSERT INTO dbo.Recodes (
	IntegerCodeId
	,CharacterCodeId
	,CodeName
	,FromDate
	,ToDate
	,RecodeCategoryId
	)
SELECT 2642 --Completed
	,NULL
	,'Completed'
	,NULL
	,NULL
	,@NewCategoryId
	
END
